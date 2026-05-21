pub const SEGNAME_BUN = "__BUN\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".*;
pub const SECTNAME = "__bun\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".*;

pub const MachoFile = struct {
    header: macho.mach_header_64,
    data: std.array_list.Managed(u8),
    segment: macho.segment_command_64,
    section: macho.section_64,
    allocator: Allocator,

    const LoadCommand = struct {
        cmd: u32,
        cmdsize: u32,
        offset: usize,
    };

    const LoadCommandIterator = struct {
        buffer: []const u8,
        ncmds: usize,
        i: usize = 0,
        offset: usize = 0,

        pub const Entry = struct {
            hdr: macho.load_command,
            data: []const u8,

            pub fn cast(entry: Entry, comptime Cmd: type) ?Cmd {
                if (entry.data.len < @sizeOf(Cmd)) return null;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
                const ptr: *align(1) const Cmd = @ptrCast(entry.data.ptr);
                var cmd = ptr.*;
                if (builtin.cpu.arch.endian() != .little) std.mem.byteSwapAllFields(Cmd, &cmd);
                return cmd;
            }

            pub fn getSections(entry: Entry) []align(1) const macho.section_64 {
                const segment_lc = entry.cast(macho.segment_command_64).?;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
                const sects_ptr: [*]align(1) const macho.section_64 = @ptrCast(entry.data[@sizeOf(macho.segment_command_64)..]);
                return sects_ptr[0..segment_lc.nsects];
            }

// safe-transpile: function returns small constant slice — consider safe.String
            pub fn getDylibPathName(entry: Entry) []const u8 {
                const dylib_lc = entry.cast(macho.dylib_command).?;
                return std.mem.sliceTo(entry.data[dylib_lc.dylib.name..], 0);
            }

// safe-transpile: function returns small constant slice — consider safe.String
            pub fn getRpathPathName(entry: Entry) []const u8 {
                const rpath_lc = entry.cast(macho.rpath_command).?;
                return std.mem.sliceTo(entry.data[rpath_lc.path..], 0);
            }

            pub fn getBuildVersionTools(entry: Entry) []align(1) const macho.build_tool_version {
                const build_lc = entry.cast(macho.build_version_command).?;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
                const tools_ptr: [*]align(1) const macho.build_tool_version = @ptrCast(entry.data[@sizeOf(macho.build_version_command)..]);
                return tools_ptr[0..build_lc.ntools];
            }
        };

        pub fn next(it: *LoadCommandIterator) ?Entry {
            if (it.i >= it.ncmds) return null;
            const hdr_bytes = it.buffer[it.offset..][0..@sizeOf(macho.load_command)];
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
            const hdr: *align(1) const macho.load_command = @ptrCast(hdr_bytes.ptr);
            var cmd = hdr.*;
            if (builtin.cpu.arch.endian() != .little) std.mem.byteSwapAllFields(macho.load_command, &cmd);
            const cmdsize = cmd.cmdsize;
            const data = it.buffer[it.offset..][0..cmdsize];
            it.offset += cmdsize;
            it.i += 1;
            return Entry{ .hdr = cmd, .data = data };
        }
    };

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn init(allocator: Allocator, obj_file: []const u8, blob_to_embed_length: usize) !*MachoFile {
        var data = try std.array_list.Managed(u8).initCapacity(allocator, obj_file.len + blob_to_embed_length);
        try data.appendSlice(obj_file);

// safe-transpile: @alignCast requires manual review
        const header: *const macho.mach_header_64 = @ptrCast(@alignCast(data.items.ptr));

        const self = try safe.Box(MachoFile).init(allocator, undefined);
        errdefer _ = self.deinit();

        self.ptr.* = .{
            .header = header.*,
            .data = data,
            .segment = std.mem.zeroes(macho.segment_command_64),
            .section = std.mem.zeroes(macho.section_64),
            .allocator = allocator,
        };

        return self.ptr;
    }

    pub fn deinit(self: *MachoFile) void {
        self.data.deinit();
        self.allocator.destroy(self);
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn writeSection(self: *MachoFile, data: []const u8) !void {
        const blob_alignment = 16 * 1024;
        const PAGE_SIZE: u64 = 1 << 12;
        const HASH_SIZE: usize = 32; // SHA256 = 32 bytes

        const header_size = @sizeOf(u64);
        const total_size = header_size + data.len;
        const aligned_size = alignSize(total_size, blob_alignment);

        // Look for existing __BUN,__BUN section

        var original_fileoff: u64 = 0;
        var original_vmaddr: u64 = 0;
        var original_data_end: u64 = 0;
        var original_segsize: u64 = blob_alignment;

        // Use an index instead of a pointer to avoid issues with resizing the arraylist later.
        var code_sign_cmd_idx: ?usize = null;
        var linkedit_seg_idx: ?usize = null;

        var found_bun = false;

        var iter = self.iterator();

        while (iter.next()) |entry| {
            const cmd = entry.hdr;
            switch (cmd.cmd) {
                .SEGMENT_64 => {
                    const command = entry.cast(macho.segment_command_64).?;
                    if (strings.eqlComptime(command.segName(), "__BUN")) {
                        if (command.nsects > 0) {
                            const section_offset = @intFromPtr(entry.data.ptr) - @intFromPtr(self.data.items.ptr);
// safe-transpile: @alignCast requires manual review
                            const sections = @as([*]macho.section_64, @ptrCast(@alignCast(&self.data.items[section_offset + @sizeOf(macho.segment_command_64)])))[0..command.nsects];
// safe-transpile: for loop with pointer capture requires manual review
                            for (sections) |*sect| {
                                if (strings.eqlComptime(sect.sectName(), "__bun")) {
                                    found_bun = true;
                                    original_fileoff = sect.offset;
                                    original_vmaddr = sect.addr;
                                    original_data_end = command.fileoff + command.filesize;
                                    original_segsize = command.filesize;
                                    self.segment = command;
                                    self.section = sect.*;

                                    // Update segment with proper sizes and alignment
                                    self.segment.vmsize = alignVmsize(aligned_size, blob_alignment);
                                    self.segment.filesize = aligned_size;
                                    self.segment.maxprot = 3; // VM_PROT_READ | VM_PROT_WRITE
                                    self.segment.initprot = 3; // VM_PROT_READ | VM_PROT_WRITE

                                    self.section = .{
                                        .sectname = SECTNAME,
                                        .segname = SEGNAME_BUN,
                                        .addr = original_vmaddr,
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                                        .size = @intCast(total_size),
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                                        .offset = @intCast(original_fileoff),
                                        .@"align" = @intFromFloat(@log2(@as(f64, @floatFromInt(blob_alignment)))),
                                        .reloff = 0,
                                        .nreloc = 0,
                                        .flags = macho.S_REGULAR | macho.S_ATTR_NO_DEAD_STRIP,
                                        .reserved1 = 0,
                                        .reserved2 = 0,
                                        .reserved3 = 0,
                                    };
                                    const entry_ptr: [*]u8 = @constCast(entry.data.ptr);
// safe-transpile: @alignCast requires manual review
                                    const segment_command_ptr: *align(1) macho.segment_command_64 = @ptrCast(@alignCast(entry_ptr));
                                    segment_command_ptr.* = self.segment;
                                    sect.* = self.section;
                                }
                            }
                        }
                    } else if (strings.eqlComptime(command.segName(), SEG_LINKEDIT)) {
                        linkedit_seg_idx = @intFromPtr(entry.data.ptr) - @intFromPtr(self.data.items.ptr);
                    }
                },
                .CODE_SIGNATURE => {
                    code_sign_cmd_idx = @intFromPtr(entry.data.ptr) - @intFromPtr(self.data.items.ptr);
                },
                else => {},
            }
        }

        if (!found_bun) {
            return error.InvalidObject;
        }

        // Calculate how much larger/smaller the section will be compared to its current size
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        const size_diff = @as(i64, @intCast(aligned_size)) - @as(i64, @intCast(original_segsize));

        // We assume that the section is page-aligned, so we can calculate the number of new pages
        const num_of_new_pages = @divExact(size_diff, PAGE_SIZE);

        // Pre-grow the backing buffer to fit: the `size_diff` bytes of new section
        // content and one SHA-256 hash per new page. `buildAndSign` may grow further
        // to write the complete signature, but reserving this up front avoids the
        // common reallocation.
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        try self.data.ensureUnusedCapacity(@intCast(size_diff + num_of_new_pages * HASH_SIZE));

        const code_sign_cmd: ?*align(1) macho.linkedit_data_command =
            if (code_sign_cmd_idx) |idx|
// safe-transpile: @alignCast requires manual review
                @as(*align(1) macho.linkedit_data_command, @ptrCast(@alignCast(@constCast(&self.data.items[idx]))))
            else
                null;
        const linkedit_seg: *align(1) macho.segment_command_64 =
            if (linkedit_seg_idx) |idx|
// safe-transpile: @alignCast requires manual review
                @as(*align(1) macho.segment_command_64, @ptrCast(@alignCast(@constCast(&self.data.items[idx]))))
            else
                return error.MissingLinkeditSegment;

        var sig_size: usize = 0;

        const prev_data_slice = self.data.items[original_fileoff..];
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        self.data.items.len += @as(usize, @intCast(size_diff));

        // Binary is:
        // [header][...data before __BUN][__BUN][...data after __BUN]
        // We need to shift [...data after __BUN] forward by size_diff bytes.
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        const after_bun_slice = self.data.items[original_data_end + @as(usize, @intCast(size_diff)) ..];
        const prev_after_bun_slice = prev_data_slice[original_segsize..];
        bun.memmove(after_bun_slice, prev_after_bun_slice);

        // Now we copy the u64 size header (8 bytes for alignment)
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        std.mem.writeInt(u64, self.data.items[original_fileoff..][0..8], @intCast(data.len), .little);

        // Now we copy the data itself
// safe-transpile: @memcpy requires manual review
        @memcpy(self.data.items[original_fileoff + 8 ..][0..data.len], data);

        // Lastly, we zero any of the padding that was added
        const padding_bytes = self.data.items[original_fileoff..][data.len + 8 .. aligned_size];
        @memset(padding_bytes, 0);

        if (code_sign_cmd) |cs| {
            sig_size = cs.datasize;
        }

        if (size_diff != 0) {
            // We move the offsets of the LINKEDIT segment ahead by `size_diff`
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            linkedit_seg.fileoff += @as(usize, @intCast(size_diff));
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            linkedit_seg.vmaddr += @as(usize, @intCast(size_diff));
        }

        if (code_sign_cmd) |cs| {
            if (self.header.cputype == macho.CPU_TYPE_ARM64 and !bun.feature_flag.BUN_NO_CODESIGN_MACHO_BINARY.get()) {
                // `buildAndSign` replaces the template's signature with one built by
                // `MachoSigner`, whose size depends only on the (possibly-shifted)
                // `cs.dataoff` — not on the template signature's shape. Resize
                // __LINKEDIT and `LC_CODE_SIGNATURE.datasize` to that exact size.
                //
                // This must run even when `size_diff == 0` (bundle fits in the
                // template's existing __BUN slot): the template may have been signed
                // with a different page size / identifier / blob set, so its
                // `cs.datasize` can be smaller than what `sign()` will produce, which
                // the trailing truncation in `sign()` then chops (issue #29120).
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                const new_sig_dataoff: u64 = cs.dataoff + @as(u64, @intCast(size_diff));
                const new_sig_size = MachoSigner.computeSignatureSize(new_sig_dataoff);

                // The template signature is the tail of __LINKEDIT; swap its footprint.
                // vmsize must be page-aligned and >= filesize, so derive it from the
                // freshly-computed filesize rather than the pre-update vmsize (otherwise
                // an old vmsize that was already page-aligned to a wider page can leave
                // the segment one page larger than necessary).
                linkedit_seg.filesize = linkedit_seg.filesize - sig_size + new_sig_size;
                linkedit_seg.vmsize = alignSize(linkedit_seg.filesize, PAGE_SIZE);

                // Stamp datasize directly so the `size_diff == 0` path — which skips
                // `updateLoadCommandOffsets` below — still records the new size.
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                cs.datasize = @intCast(new_sig_size);
                sig_size = new_sig_size;
            }
        }

        if (size_diff != 0) {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            try self.updateLoadCommandOffsets(original_fileoff, @intCast(size_diff), linkedit_seg.fileoff, linkedit_seg.filesize, sig_size);
        }

        try self.validateSegments();
    }

    const Shifter = struct {
        start: u64,
        amount: u64,
        linkedit_fileoff: u64,
        linkedit_filesize: u64,

        fn do(value: u64, amount: u64, range_min: u64, range_max: u64) !u64 {
            if (value == 0) return 0;
            if (value < range_min) return error.OffsetOutOfRange;
            if (value > range_max) return error.OffsetOutOfRange;

            // Check for overflow
            if (value > std.math.maxInt(u64) - amount) {
                return error.OffsetOverflow;
            }

            return value + amount;
        }

        pub fn shift(this: *const Shifter, value: anytype, comptime fields: []const []const u8) !void {
            inline for (fields) |field| {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                @field(value, field) = @intCast(try do(@field(value, field), this.amount, this.start, this.linkedit_fileoff + this.linkedit_filesize));
            }
        }
    };

    // Helper function to update load command offsets when resizing an existing section
    fn updateLoadCommandOffsets(self: *MachoFile, previous_fileoff: u64, size_diff: u64, new_linkedit_fileoff: u64, new_linkedit_filesize: u64, sig_size: usize) !void {
        // Validate inputs
        if (new_linkedit_fileoff < previous_fileoff) {
            return error.InvalidLinkeditOffset;
        }

        const PAGE_SIZE: u64 = 1 << 12;

        // Ensure all offsets are page-aligned
        const aligned_previous = alignSize(previous_fileoff, PAGE_SIZE);
        const aligned_linkedit = alignSize(new_linkedit_fileoff, PAGE_SIZE);

        var iter = self.iterator();

        // Create shifter with validated parameters
        const shifter = Shifter{
            .start = aligned_previous,
            .amount = size_diff,
            .linkedit_fileoff = aligned_linkedit,
            .linkedit_filesize = new_linkedit_filesize,
        };

        while (iter.next()) |entry| {
            const cmd = entry.hdr;
            const cmd_ptr: [*]u8 = @constCast(entry.data.ptr);

            switch (cmd.cmd) {
                .SYMTAB => {
// safe-transpile: @alignCast requires manual review
                    const symtab: *align(1) macho.symtab_command = @ptrCast(@alignCast(cmd_ptr));

                    try shifter.shift(symtab, &.{
                        "symoff",
                        "stroff",
                    });
                },
                .DYSYMTAB => {
// safe-transpile: @alignCast requires manual review
                    const dysymtab: *align(1) macho.dysymtab_command = @ptrCast(@alignCast(cmd_ptr));

                    try shifter.shift(dysymtab, &.{
                        "tocoff",
                        "modtaboff",
                        "extrefsymoff",
                        "indirectsymoff",
                        "extreloff",
                        "locreloff",
                    });
                },
                .DYLD_CHAINED_FIXUPS,
                .CODE_SIGNATURE,
                .FUNCTION_STARTS,
                .DATA_IN_CODE,
                .DYLIB_CODE_SIGN_DRS,
                .LINKER_OPTIMIZATION_HINT,
                .DYLD_EXPORTS_TRIE,
                => {
// safe-transpile: @alignCast requires manual review
                    const linkedit_cmd: *align(1) macho.linkedit_data_command = @ptrCast(@alignCast(cmd_ptr));

                    try shifter.shift(linkedit_cmd, &.{"dataoff"});

                    // Special handling for code signature
                    if (cmd.cmd == .CODE_SIGNATURE) {
                        // Update the size of the code signature to the newer signature size
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                        linkedit_cmd.datasize = @intCast(sig_size);
                    }
                },
                .DYLD_INFO, .DYLD_INFO_ONLY => {
// safe-transpile: @alignCast requires manual review
                    const dyld_info: *align(1) macho.dyld_info_command = @ptrCast(@alignCast(cmd_ptr));

                    try shifter.shift(dyld_info, &.{
                        "rebase_off",
                        "bind_off",
                        "weak_bind_off",
                        "lazy_bind_off",
                        "export_off",
                    });
                },
                else => {},
            }
        }
    }

    pub fn iterator(self: *const MachoFile) LoadCommandIterator {
        return .{
            .buffer = self.data.items[@sizeOf(macho.mach_header_64)..][0..self.header.sizeofcmds],
            .ncmds = self.header.ncmds,
        };
    }

    pub fn build(self: *MachoFile, writer: anytype) !void {
        try writer.writeAll(self.data.items);
    }

    fn validateSegments(self: *MachoFile) !void {
        var iter = self.iterator();
        var prev_end: u64 = 0;

        while (iter.next()) |entry| {
            const cmd = entry.hdr;
            if (cmd.cmd == .SEGMENT_64) {
                const seg = entry.cast(macho.segment_command_64).?;
                if (seg.fileoff < prev_end) {
                    return error.OverlappingSegments;
                }
                prev_end = seg.fileoff + seg.filesize;
            }
        }
    }

    pub fn buildAndSign(self: *MachoFile, writer: *std.Io.Writer) !void {
        if (self.header.cputype == macho.CPU_TYPE_ARM64 and !bun.feature_flag.BUN_NO_CODESIGN_MACHO_BINARY.get()) {
            var data = std.array_list.Managed(u8).init(self.allocator);
            defer data.deinit();
            const ArrayListWriter = struct {
                list: *std.array_list.Managed(u8),
// safe-transpile: function uses raw slice parameter — consider safe.String
                pub fn writeAll(self_: @This(), bytes: []const u8) !void {
                    try self_.list.appendSlice(bytes);
                }
            };
            try self.build(ArrayListWriter{ .list = &data });
            var signer = try MachoSigner.init(self.allocator, data.items);
            defer signer.deinit();
            try signer.sign(writer);
        } else {
            try self.build(writer);
        }
    }

    const MachoSigner = struct {
        data: std.array_list.Managed(u8),
        sig_off: usize,
        sig_sz: usize,
        cs_cmd_off: usize,
        linkedit_off: usize,
        linkedit_seg: macho.segment_command_64,
        text_seg: macho.segment_command_64,
        allocator: Allocator,

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn init(allocator: Allocator, obj: []const u8) !*MachoSigner {
            var self = try safe.Box(MachoSigner).init(allocator, undefined);
            errdefer _ = self.deinit();

// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
            const header = @as(*align(1) const macho.mach_header_64, @ptrCast(obj.ptr)).*;
            const header_size = @sizeOf(macho.mach_header_64);

            var sig_off: usize = 0;
            var sig_sz: usize = 0;
            var cs_cmd_off: usize = 0;
            var linkedit_off: usize = 0;

            var text_seg = std.mem.zeroes(macho.segment_command_64);
            var linkedit_seg = std.mem.zeroes(macho.segment_command_64);

            var it = MachoFile.LoadCommandIterator{
                .ncmds = header.ncmds,
                .buffer = obj[header_size..][0..header.sizeofcmds],
            };

            // First pass: find segments to establish bounds
            while (it.next()) |cmd| {
                if (cmd.hdr.cmd == .SEGMENT_64) {
                    const seg = cmd.cast(macho.segment_command_64).?;

                    // Store segment info
                    if (strings.eqlComptime(seg.segName(), SEG_LINKEDIT)) {
                        linkedit_seg = seg;
                        linkedit_off = @intFromPtr(cmd.data.ptr) - @intFromPtr(obj.ptr);

                        // Validate linkedit is after text
                        if (linkedit_seg.fileoff < text_seg.fileoff + text_seg.filesize) {
                            return error.InvalidLinkeditOffset;
                        }
                    } else if (strings.eqlComptime(seg.segName(), "__TEXT")) {
                        text_seg = seg;
                    }
                }
            }

            // Reset iterator
            it = MachoFile.LoadCommandIterator{
                .ncmds = header.ncmds,
                .buffer = obj[header_size..][0..header.sizeofcmds],
            };

            // Second pass: find code signature
            while (it.next()) |cmd| {
                switch (cmd.hdr.cmd) {
                    .CODE_SIGNATURE => {
                        const cs = cmd.cast(macho.linkedit_data_command).?;
                        sig_off = cs.dataoff;
                        sig_sz = cs.datasize;
                        cs_cmd_off = @intFromPtr(cmd.data.ptr) - @intFromPtr(obj.ptr);
                    },
                    else => {},
                }
            }

            if (linkedit_off == 0 or sig_off == 0) {
                return error.MissingRequiredSegment;
            }

            self.ptr.* = .{
                .data = try std.array_list.Managed(u8).initCapacity(allocator, obj.len),
                .sig_off = sig_off,
                .sig_sz = sig_sz,
                .cs_cmd_off = cs_cmd_off,
                .linkedit_off = linkedit_off,
                .linkedit_seg = linkedit_seg,
                .text_seg = text_seg,
                .allocator = allocator,
            };

            try self.ptr.data.appendSlice(obj);
            return self.ptr;
        }

        pub fn deinit(self: *MachoSigner) void {
            self.data.deinit();
            self.allocator.destroy(self);
        }

        const IDENTIFIER = "a.out\x00";
        const SIGNATURE_PAGE_SIZE: usize = 1 << 12;
        const SIGNATURE_HASH_SIZE: usize = 32; // SHA256 = 32 bytes

        /// Compute the exact number of bytes that `sign()` will write at `sig_off`
        /// (the `SuperBlob` + `BlobIndex` + `CodeDirectory` + identifier + page
        /// hashes). `writeSection` uses this to size `linkedit_seg.filesize` and
        /// the `LC_CODE_SIGNATURE.datasize` so the signer's output fits exactly
        /// inside __LINKEDIT.
        pub fn computeSignatureSize(sig_off: u64) usize {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            const total_pages: usize = @intCast((sig_off + SIGNATURE_PAGE_SIZE - 1) / SIGNATURE_PAGE_SIZE);
            const super_blob_header_size = @sizeOf(SuperBlob);
            const blob_index_size = @sizeOf(BlobIndex);
            const code_dir_header_size = @sizeOf(CodeDirectory);
            const hash_offset = code_dir_header_size + IDENTIFIER.len;
            const hashes_size = total_pages * SIGNATURE_HASH_SIZE;
            const code_dir_length = hash_offset + hashes_size;
            return super_blob_header_size + blob_index_size + code_dir_length;
        }

        pub fn sign(self: *MachoSigner, writer: *std.Io.Writer) !void {
            const PAGE_SIZE: usize = SIGNATURE_PAGE_SIZE;
            const HASH_SIZE: usize = SIGNATURE_HASH_SIZE;

            // Calculate total binary pages before signature
            const total_pages = (self.sig_off + PAGE_SIZE - 1) / PAGE_SIZE;
            const aligned_sig_off = total_pages * PAGE_SIZE;

            // Calculate base signature structure sizes
            const id = IDENTIFIER;
            const super_blob_header_size = @sizeOf(SuperBlob);
            const blob_index_size = @sizeOf(BlobIndex);
            const code_dir_header_size = @sizeOf(CodeDirectory);
            const id_offset = code_dir_header_size;
            const hash_offset = id_offset + id.len;

            // Calculate hash sizes
            const hashes_size = total_pages * HASH_SIZE;
            const code_dir_length = hash_offset + hashes_size;

            // Calculate total signature size
            const sig_structure_size = super_blob_header_size + blob_index_size + code_dir_length;
            bun.debugAssert(sig_structure_size == computeSignatureSize(self.sig_off));
            const total_sig_size = alignSize(sig_structure_size, PAGE_SIZE);

            // Setup SuperBlob
            var super_blob = SuperBlob{
                .magic = @byteSwap(CSMAGIC_EMBEDDED_SIGNATURE),
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
                .length = @byteSwap(@as(u32, @truncate(sig_structure_size))),
                .count = @byteSwap(@as(u32, 1)),
            };

            // Setup BlobIndex
            var blob_index = BlobIndex{
                .type = @byteSwap(CSSLOT_CODEDIRECTORY),
                .offset = @byteSwap(@as(u32, super_blob_header_size + blob_index_size)),
            };

            // Setup CodeDirectory
            var code_dir = std.mem.zeroes(CodeDirectory);
            code_dir.magic = @byteSwap(CSMAGIC_CODEDIRECTORY);
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
            code_dir.length = @byteSwap(@as(u32, @truncate(code_dir_length)));
            code_dir.version = @byteSwap(@as(u32, 0x20400));
            code_dir.flags = @byteSwap(@as(u32, 0x20002));
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
            code_dir.hashOffset = @byteSwap(@as(u32, @truncate(hash_offset)));
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
            code_dir.identOffset = @byteSwap(@as(u32, @truncate(id_offset)));
            code_dir.nSpecialSlots = 0;
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
            code_dir.nCodeSlots = @byteSwap(@as(u32, @truncate(total_pages)));
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
            code_dir.codeLimit = @byteSwap(@as(u32, @truncate(self.sig_off)));
            code_dir.hashSize = HASH_SIZE;
            code_dir.hashType = SEC_CODE_SIGNATURE_HASH_SHA256;
            code_dir.pageSize = 12; // log2(4096)

            // Get text segment info
            const text_base = alignSize(self.text_seg.fileoff, PAGE_SIZE);
            const text_limit = alignSize(self.text_seg.filesize, PAGE_SIZE);
            code_dir.execSegBase = @byteSwap(@as(u64, text_base));
            code_dir.execSegLimit = @byteSwap(@as(u64, text_limit));
            code_dir.execSegFlags = @byteSwap(CS_EXECSEG_MAIN_BINARY);

            // Ensure space for signature
            try self.data.resize(aligned_sig_off + total_sig_size);
            self.data.items.len = self.sig_off;
            @memset(self.data.unusedCapacitySlice(), 0);

            // Write signature components
            const offset = self.sig_off;
// safe-transpile: @memcpy requires manual review
            @memcpy(self.data.items[offset..][0..@sizeOf(@TypeOf(super_blob))], mem.asBytes(&super_blob));
// safe-transpile: @memcpy requires manual review
            @memcpy(self.data.items[offset + @sizeOf(@TypeOf(super_blob))..][0..@sizeOf(@TypeOf(blob_index))], mem.asBytes(&blob_index));
// safe-transpile: @memcpy requires manual review
            @memcpy(self.data.items[offset + @sizeOf(@TypeOf(super_blob)) + @sizeOf(@TypeOf(blob_index))..][0..@sizeOf(@TypeOf(code_dir))], mem.asBytes(&code_dir));
// safe-transpile: @memcpy requires manual review
            @memcpy(self.data.items[offset + @sizeOf(@TypeOf(super_blob)) + @sizeOf(@TypeOf(blob_index)) + @sizeOf(@TypeOf(code_dir))..][0..id.len], id);

            // Hash and write pages
            var remaining = self.data.items[0..self.sig_off];
            var write_offset = self.sig_off + @sizeOf(@TypeOf(super_blob)) + @sizeOf(@TypeOf(blob_index)) + @sizeOf(@TypeOf(code_dir)) + id.len;
            while (remaining.len >= PAGE_SIZE) {
                const page = remaining[0..PAGE_SIZE];
                var digest: bun.sha.SHA256.Digest = undefined;
                bun.sha.SHA256.hash(page, &digest, null);
// safe-transpile: @memcpy requires manual review
                @memcpy(self.data.items[write_offset..][0..digest.len], &digest);
                write_offset += digest.len;
                remaining = remaining[PAGE_SIZE..];
            }

            if (remaining.len > 0) {
                var last_page = [_]u8{0} ** PAGE_SIZE;
// safe-transpile: @memcpy requires manual review
                @memcpy(last_page[0..remaining.len], remaining);
                var digest: bun.sha.SHA256.Digest = undefined;
                bun.sha.SHA256.hash(&last_page, &digest, null);
// safe-transpile: @memcpy requires manual review
                @memcpy(self.data.items[write_offset..][0..digest.len], &digest);
            }

            // Finally, ensure that the length of data we write matches the total data expected
            self.data.items.len = self.linkedit_seg.fileoff + self.linkedit_seg.filesize;

            // Write final binary
            try writer.writeAll(self.data.items);
        }
    };
};

fn alignSize(size: u64, base: u64) u64 {
    const over = size % base;
    return if (over == 0) size else size + (base - over);
}

fn alignVmsize(size: u64, page_size: u64) u64 {
    return alignSize(if (size > 0x4000) size else 0x4000, page_size);
}

const SEG_LINKEDIT = "__LINKEDIT";

pub const utils = struct {
// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn isElf(data: []const u8) bool {
        if (data.len < 4) return false;
        return mem.readInt(u32, data[0..4], .big) == 0x7f454c46;
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn isMacho(data: []const u8) bool {
        if (data.len < 4) return false;
        return mem.readInt(u32, data[0..4], .little) == macho.MH_MAGIC_64;
    }
};

const CSMAGIC_CODEDIRECTORY: u32 = 0xfade0c02;
const CSMAGIC_EMBEDDED_SIGNATURE: u32 = 0xfade0cc0;
const CSSLOT_CODEDIRECTORY: u32 = 0;
const SEC_CODE_SIGNATURE_HASH_SHA256: u8 = 2;
const CS_EXECSEG_MAIN_BINARY: u64 = 0x1;

const builtin = @import("builtin");
const std = @import("std");

const bun = @import("bun");
const strings = bun.strings;

const macho = std.macho;
const BlobIndex = std.macho.BlobIndex;
const CodeDirectory = std.macho.CodeDirectory;
const SuperBlob = std.macho.SuperBlob;

const mem = std.mem;
const Allocator = mem.Allocator;

const safe = @import("safe");
