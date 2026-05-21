//! Compatibility shim for removed Zig 0.16 stdlib APIs
const std = @import("std");
const bun = @import("bun");

/// Helper for C pointers that are null-terminated but Zig 0.16's std.mem.span
/// does not accept [*c] pointers anymore.
pub fn spanC(ptr: [*c]const u8) [:0]const u8 {
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
    const p: [*:0]const u8 = @ptrCast(ptr);
    var len: usize = 0;
    while (p[len] != 0) : (len += 1) {}
    return p[0..len :0];
}

// fs compatibility - use std.fs types
pub const Dir = std.fs.Dir;

/// Old-style fs.File compatibility shim for code that needs @import("std-fs-compat").File API
pub const File = struct {
    handle: std.posix.fd_t,
    flags: Flags = .{ .nonblocking = false },

    pub const Flags = struct {
        nonblocking: bool = false,
    };

    pub fn close(self: File) void {
        _ = std.c.close(self.handle);
    }

    pub fn isTty(self: File) bool {
        return std.c.isatty(self.handle) != 0;
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn writeAll(self: File, data: []const u8) (error{ WriteFailed, BrokenPipe })!void {
        var written: usize = 0;
        while (written < data.len) {
            const n = std.c.write(self.handle, data[written..].ptr, data.len - written);
            if (n < 0) {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                if (std.posix.errno(@as(c_int, @intCast(n))) == .PIPE) return error.BrokenPipe;
                return error.WriteFailed;
            }
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            written += @intCast(n);
        }
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn pwriteAll(self: File, data: []const u8, offset: u64) (error{ WriteFailed, BrokenPipe })!void {
        var written: usize = 0;
        while (written < data.len) {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            const n = std.c.pwrite(self.handle, data[written..].ptr, data.len - written, @intCast(offset + written));
            if (n < 0) {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                if (std.posix.errno(@as(c_int, @intCast(n))) == .PIPE) return error.BrokenPipe;
                return error.WriteFailed;
            }
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            written += @intCast(n);
        }
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn readAll(self: File, buf: []u8) error{Unexpected, ReadFailed}!usize {
        var read_count: usize = 0;
        while (read_count < buf.len) {
            const n = std.c.read(self.handle, buf[read_count..].ptr, buf.len - read_count);
            if (n < 0) return error.Unexpected;
            if (n == 0) break;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            read_count += @intCast(n);
        }
        return read_count;
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn preadAll(self: File, buf: []u8, offset: u64) !usize {
        var read_count: usize = 0;
        while (read_count < buf.len) {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            const n = std.c.pread(self.handle, buf[read_count..].ptr, buf.len - read_count, @intCast(offset + read_count));
            if (n < 0) return error.ReadFailed;
            if (n == 0) break;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            read_count += @intCast(n);
        }
        return read_count;
    }

    pub fn writer(self: File) Writer {
        return .{ .context = self };
    }

    pub fn reader(self: File) Reader {
        return .{ .context = self };
    }

// safe-transpile: function returns small constant slice — consider safe.String
    pub fn readToEndAlloc(self: File, allocator: std.mem.Allocator, max_size: usize) ![]u8 {
        const size = try self.getEndPos();
        if (size > max_size) return error.FileTooBig;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        const buf = try allocator.alloc(u8, @intCast(size));
        errdefer allocator.free(buf);
        const read_size = try self.readAll(buf);
        return buf[0..read_size];
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn writerStreaming(self: File, buffer: []u8) std.fs.File.Writer {
        const std_file = std.fs.File{ .handle = self.handle };
        return std.fs.File.writerStreaming(std_file, buffer);
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn readerStreaming(self: File, buffer: []u8) std.fs.File.Reader {
        const std_file = std.fs.File{ .handle = self.handle };
        return std.fs.File.readerStreaming(std_file, buffer);
    }

    pub fn stdin() File {
        return .{ .handle = std.c.STDIN_FILENO };
    }

    pub fn stdout() File {
        return .{ .handle = std.c.STDOUT_FILENO };
    }

    pub fn stderr() File {
        return .{ .handle = std.c.STDERR_FILENO };
    }

    pub fn seekTo(self: File, pos: u64) !void {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        _ = std.c.lseek(self.handle, @intCast(pos), std.c.SEEK.SET);
    }

    pub fn seekBy(self: File, delta: i64) !void {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        _ = std.c.lseek(self.handle, @intCast(delta), std.c.SEEK.CUR);
    }

    pub fn length(self: File) !u64 {
        return self.getEndPos();
    }

    pub fn getEndPos(self: File) !u64 {
        var st: std.c.Stat = undefined;
        if (std.c.fstat(self.handle, &st) != 0) return error.Unexpected;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        return @intCast(st.size);
    }

    pub fn setEndPos(self: File, new_length: u64) !void {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        if (std.c.ftruncate(self.handle, @intCast(new_length)) != 0) return error.Unexpected;
    }

    pub fn stat(self: File) !Stat {
        var st: std.c.Stat = undefined;
        if (std.c.fstat(self.handle, &st) != 0) return error.Unexpected;
        const tsToIo = struct {
            pub fn call(ts: std.c.timespec) Timestamp {
                return .{ .nanoseconds = @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec };
            }
        }.call;
        return .{
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            .inode = @intCast(st.ino),
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            .nlink = @intCast(st.nlink),
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            .size = @intCast(st.size),
            .permissions = Permissions.fromMode(st.mode),
            .kind = bun.sys.kindFromMode(st.mode),
            .atime = tsToIo(st.atime()),
            .mtime = tsToIo(st.mtime()),
            .ctime = tsToIo(st.ctime()),
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            .block_size = @intCast(st.blksize),
        };
    }

    pub const Kind = std.fs.File.Kind;
    pub const INode = std.fs.File.INode;
    pub const Timestamp = struct {
        nanoseconds: i128,
    };
    pub const Permissions = struct {
        mode: std.posix.mode_t,

        pub fn fromMode(mode: std.posix.mode_t) Permissions {
            return .{ .mode = mode };
        }
    };
    pub const Stat = struct {
        inode: INode,
        nlink: u64,
        size: u64,
        block_size: u64,
        permissions: Permissions,
        kind: Kind,
        atime: Timestamp,
        mtime: Timestamp,
        ctime: Timestamp,
    };
    pub const OpenFlags = std.fs.File.OpenFlags;

    pub const Writer = @import("std-io-compat").MakeGenericWriter(File, error{WriteFailed}, struct {
// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn write(ctx: File, data: []const u8) error{WriteFailed}!usize {
            const n = std.c.write(ctx.handle, data.ptr, data.len);
            if (n < 0) return error.WriteFailed;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            return @intCast(n);
        }
    }.write);

    pub const Reader = @import("std-io-compat").MakeGenericReader(File, error{ReadFailed}, struct {
// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn read(ctx: File, buf: []u8) error{ReadFailed}!usize {
            const n = std.c.read(ctx.handle, buf.ptr, buf.len);
            if (n < 0) return error.ReadFailed;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            return @intCast(n);
        }
    }.read);
};

/// Old-style fs.Dir compatibility shim for code that needs @import("std-fs-compat").FsDir API
pub const FsDir = struct {
    fd: std.posix.fd_t,

    pub const OpenError = error{
        FileNotFound,
        NotDir,
        AccessDenied,
        SymLinkLoop,
        NameTooLong,
        SystemResources,
        DeviceBusy,
        IsDir,
        FileBusy,
        Unexpected,
    };

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn makeOpenPath(self: FsDir, sub_path: []const u8, opts: MakePathOptions) OpenError!FsDir {
        _ = opts;
        if (sub_path.len == 0) return error.Unexpected;
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));

        // Create intermediate directories
        var i: usize = 0;
        while (i < sub_path.len) : (i += 1) {
            if (sub_path[i] == std.fs.path.sep) {
                if (i > 0) {
                    buf[i] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
                    const rc = std.c.mkdirat(self.fd, @as([*:0]u8, @ptrCast(&buf)), 0o755);
                    if (rc != 0) {
                        if (std.posix.errno(rc) != .EXIST) return error.Unexpected;
                    }
                    buf[i] = std.fs.path.sep;
                }
            }
        }
        const rc = std.c.mkdirat(self.fd, pathz, 0o755);
        if (rc != 0) {
            if (std.posix.errno(rc) != .EXIST) return error.Unexpected;
        }

        const new_fd = std.c.openat(self.fd, pathz, std.c.O{ .DIRECTORY = true, .ACCMODE = .RDONLY }, @as(std.posix.mode_t, 0));
        if (new_fd < 0) return error.Unexpected;
        return FsDir{ .fd = new_fd };
    }

    pub fn makeDirZ(self: FsDir, sub_path: [*:0]const u8) !void {
        if (std.c.mkdirat(self.fd, sub_path, 0o755) != 0) {
            return error.Unexpected;
        }
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn openDir(self: FsDir, sub_path: []const u8, opts: struct { no_follow: bool = false, iterate: bool = true }) OpenError!FsDir {
        _ = opts;
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));
        const new_fd = std.c.openat(self.fd, pathz, std.c.O{ .DIRECTORY = true, .ACCMODE = .RDONLY }, @as(std.posix.mode_t, 0));
        if (new_fd < 0) return error.Unexpected;
        return FsDir{ .fd = new_fd };
    }

    pub fn accessZ(self: FsDir, sub_path: [*:0]const u8, flags: u32) !void {
        _ = flags;
        if (std.c.faccessat(self.fd, sub_path, std.c.F_OK, 0) != 0) {
            return error.FileNotFound;
        }
    }

    pub fn deleteFileZ(self: FsDir, sub_path: [*:0]const u8) !void {
        if (std.c.unlinkat(self.fd, sub_path, 0) != 0) {
            return error.Unexpected;
        }
    }

    pub fn symLinkZ(self: FsDir, target_path: [*:0]const u8, sym_link_path: [*:0]const u8, flags: u32) !void {
        _ = flags;
        if (std.c.symlinkat(target_path, self.fd, sym_link_path) != 0) {
            return error.Unexpected;
        }
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn createFile(self: FsDir, sub_path: []const u8, flags: CreateFileOptions) !File {
        _ = flags;
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));
        const fd = std.c.openat(self.fd, pathz, std.c.O{ .CREAT = true, .ACCMODE = .WRONLY, .TRUNC = true }, @as(std.posix.mode_t, 0o644));
        if (fd < 0) return error.Unexpected;
        return File{ .handle = fd, .flags = .{ .nonblocking = false } };
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn makeDir(self: FsDir, sub_path: []const u8) !void {
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));
        if (std.c.mkdirat(self.fd, pathz, 0o755) != 0) {
            return error.Unexpected;
        }
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn readLinkZ(self: FsDir, sub_path: [*:0]const u8, out_buffer: []u8) ![]u8 {
        const result = std.c.readlinkat(self.fd, sub_path, out_buffer.ptr, out_buffer.len);
        if (result < 0) return error.Unexpected;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        return out_buffer[0..@intCast(result)];
    }

    pub fn close(self: FsDir) void {
        _ = std.c.close(self.fd);
    }

    pub fn statZ(self: FsDir, sub_path: [*:0]const u8) !std.posix.Stat {
        var st: std.posix.Stat = undefined;
        if (std.c.fstatat(self.fd, sub_path, &st, 0) != 0) {
            return error.Unexpected;
        }
        return st;
    }

    pub fn statFileZ(self: FsDir, sub_path: [*:0]const u8) !std.posix.Stat {
        var st: std.posix.Stat = undefined;
        if (std.c.fstatat(self.fd, sub_path, &st, 0) != 0) {
            return error.Unexpected;
        }
        return st;
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn statFile(self: FsDir, sub_path: []const u8) !std.posix.Stat {
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));
        return self.statFileZ(pathz);
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn readFile(self: FsDir, sub_path: []const u8, buf: []u8) ![]u8 {
        var file = try self.openFile(sub_path, .{});
        defer file.close();
        const len = try file.readAll(buf);
        return buf[0..len];
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn deleteTree(self: FsDir, sub_path: []const u8) !void {
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));
        if (std.c.unlinkat(self.fd, pathz, std.c.AT.REMOVEDIR) != 0) {
            return error.Unexpected;
        }
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn deleteTreeAbsolute(abs_path: []const u8) !void {
        const dirname = std.fs.path.dirname(abs_path) orelse "/";
        var dir_buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(dir_buf[0..dirname.len], dirname);
        dir_buf[dirname.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const dirz = @as([*:0]u8, @ptrCast(&dir_buf));
        const dir_fd = std.c.open(dirz, std.c.O{ .DIRECTORY = true, .ACCMODE = .RDONLY }, @as(std.posix.mode_t, 0));
        if (dir_fd < 0) return error.Unexpected;
        defer _ = std.c.close(dir_fd);
        const basename = std.fs.path.basename(abs_path);
        var name_buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(name_buf[0..basename.len], basename);
        name_buf[basename.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const namez = @as([*:0]u8, @ptrCast(&name_buf));
        if (std.c.unlinkat(dir_fd, namez, std.c.AT.REMOVEDIR) != 0) {
            return error.Unexpected;
        }
    }

    pub fn createFileZ(self: FsDir, sub_path: [*:0]const u8, flags: CreateFileOptions) OpenError!File {
        const oflags: std.c.O = .{
            .CREAT = true,
            .ACCMODE = .WRONLY,
            .TRUNC = flags.truncate,
            .EXCL = flags.exclusive,
        };
        const fd = std.c.openat(self.fd, sub_path, oflags, flags.mode);
        if (fd < 0) return error.Unexpected;
        return File{ .handle = fd, .flags = .{ .nonblocking = false } };
    }

    pub fn openFileZ(self: FsDir, sub_path: [*:0]const u8, flags: struct { mode: std.c.O = .{ .ACCMODE = .RDONLY } }) !File {
        const fd = std.c.openat(self.fd, sub_path, flags.mode, @as(u32, 0));
        if (fd < 0) return error.Unexpected;
        return File{ .handle = fd, .flags = .{ .nonblocking = false } };
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn openFile(self: FsDir, sub_path: []const u8, flags: struct { mode: std.c.O = .{ .ACCMODE = .RDONLY } }) OpenError!File {
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));
        const fd = std.c.openat(self.fd, pathz, flags.mode, @as(u32, 0));
        if (fd < 0) {
            return switch (@intFromEnum(std.posix.errno(fd))) {
                2 => error.FileNotFound,
                13 => error.AccessDenied,
                16 => error.FileBusy,
                21 => error.IsDir,
                else => error.Unexpected,
            };
        }
        return File{ .handle = fd, .flags = .{ .nonblocking = false } };
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn readFileAlloc(self: FsDir, allocator: std.mem.Allocator, sub_path: []const u8, max_size: usize) ![]u8 {
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));
        const file = try self.openFileZ(pathz, .{});
        defer file.close();
        const size = try file.getEndPos();
        const actual_size = @min(size, max_size);
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        const result = try allocator.alloc(u8, @intCast(actual_size));
        errdefer allocator.free(result);
        const read_size = try file.readAll(result);
        if (read_size < actual_size) {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            return try allocator.realloc(result, @intCast(read_size));
        }
        return result;
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn writeFile(self: FsDir, sub_path: []const u8, data: []const u8) !void {
        var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
        @memcpy(buf[0..sub_path.len], sub_path);
        buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
        const pathz = @as([*:0]u8, @ptrCast(&buf));
        const oflags: std.c.O = .{
            .CREAT = true,
            .ACCMODE = .WRONLY,
            .TRUNC = true,
        };
        const fd = std.c.openat(self.fd, pathz, oflags, @as(u32, 0o644));
        if (fd < 0) return error.Unexpected;
        const file = File{ .handle = fd, .flags = .{ .nonblocking = false } };
        defer file.close();
        var written: usize = 0;
        while (written < data.len) {
            const rc = std.c.write(fd, data[written..].ptr, data.len - written);
            if (rc < 0) return error.Unexpected;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            written += @intCast(rc);
        }
    }

    pub const CreateFileOptions = struct {
        read: bool = true,
        truncate: bool = true,
        exclusive: bool = false,
        lock: bool = false,
        mode: u32 = 0o666,
    };

    pub const MakePathOptions = struct {
        access_sub_paths: bool = true,
    };

    pub fn setAsCwd(self: FsDir) !void {
        if (std.c.fchdir(self.fd) != 0) return error.Unexpected;
    }

    pub fn toDir(self: FsDir) Dir {
        return .{ .fd = self.fd };
    }

    pub fn fromDir(dir: Dir) FsDir {
        return .{ .fd = dir.fd };
    }

    pub fn iterate(self: FsDir) Iterator {
        return Iterator{ .dir = self };
    }

    pub const Entry = Iterator.Entry;

    pub const Iterator = struct {
        dir: FsDir,
        index: usize = 0,

        pub const Kind = enum {
            file,
            directory,
            sym_link,
            unknown,
        };

        pub const Entry = struct {
            name: []const u8,
            kind: Kind,
        };

        pub fn next(self: *Iterator) !?@This().Entry {
            // Simplified implementation
            _ = self;
            return null;
        }

        pub fn deinit(self: *Iterator) void {
            self.dir.close();
        }
    };
};

// time compatibility
pub const Timer = struct {
    start_time: i128,

    pub fn start() error{Unexpected}!Timer {
        var ts: std.posix.timespec = undefined;
        if (std.c.clock_gettime(std.c.CLOCK.MONOTONIC, &ts) != 0) return error.Unexpected;
        return .{ .start_time = @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec };
    }

    pub fn read(self: *Timer) u64 {
        var ts: std.posix.timespec = undefined;
        _ = std.c.clock_gettime(std.c.CLOCK.MONOTONIC, &ts);
        const now = @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        return @intCast(@max(0, now - self.start_time));
    }

    pub fn readNs(self: *Timer) u64 {
        return self.read();
    }

    pub fn reset(self: *Timer) void {
        var ts: std.posix.timespec = undefined;
        _ = std.c.clock_gettime(std.c.CLOCK.MONOTONIC, &ts);
        self.start_time = @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec;
    }

    pub fn lap(self: *Timer) u64 {
        var ts: std.posix.timespec = undefined;
        _ = std.c.clock_gettime(std.c.CLOCK.MONOTONIC, &ts);
        const now = @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec;
        const elapsed = @max(0, now - self.start_time);
        self.start_time = now;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        return @intCast(elapsed);
    }
};

pub const Instant = struct {
    timestamp: i128,

    pub fn now() !Instant {
        var ts: std.posix.timespec = undefined;
        _ = std.c.clock_gettime(std.c.CLOCK.MONOTONIC, &ts);
        return .{ .timestamp = @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec };
    }

    pub fn since(self: Instant, other: Instant) u64 {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        return @intCast(@max(0, self.timestamp - other.timestamp));
    }

    pub fn order(self: Instant, other: Instant) std.math.Order {
        return std.math.order(self.timestamp, other.timestamp);
    }
};

pub fn milliTimestamp() i64 {
    var ts: std.posix.timespec = undefined;
    _ = std.c.clock_gettime(std.c.CLOCK.REALTIME, &ts);
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    return @intCast(ts.sec * std.time.ms_per_s + @divTrunc(ts.nsec, std.time.ns_per_ms));
}

pub fn timestamp() i64 {
    var ts: std.posix.timespec = undefined;
    _ = std.c.clock_gettime(std.c.CLOCK.REALTIME, &ts);
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    return @intCast(ts.sec);
}

// Thread compatibility
pub fn sleep(ns: u64) void {
    var req: std.posix.timespec = .{
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        .sec = @intCast(ns / std.time.ns_per_s),
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        .nsec = @intCast(ns % std.time.ns_per_s),
    };
    var rem: std.posix.timespec = undefined;
    _ = std.c.nanosleep(&req, &rem);
}

// posix compatibility
pub fn isatty(fd: std.posix.fd_t) bool {
    return std.c.isatty(fd) != 0;
}

pub fn nanosleep(seconds: u64, nanoseconds: u64) !void {
    const ns_total = seconds * std.time.ns_per_s + nanoseconds;
    var req: std.posix.timespec = .{
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        .sec = @intCast(ns_total / std.time.ns_per_s),
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        .nsec = @intCast(ns_total % std.time.ns_per_s),
    };
    var rem: std.posix.timespec = undefined;
    if (std.c.nanosleep(&req, &rem) != 0) {
        return error.Unexpected;
    }
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn makeDir(dir: Dir, sub_path: []const u8) !void {
    var buf: [std.fs.max_path_bytes]u8 = undefined;
// safe-transpile: @memcpy requires manual review
    @memcpy(buf[0..sub_path.len], sub_path);
    buf[sub_path.len] = 0;
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
    const pathz = @as([*:0]u8, @ptrCast(&buf));
    const rc = std.c.mkdirat(dir.fd, pathz, 0o755);
    if (rc != 0) {
        return switch (std.posix.errno(rc)) {
            .EXIST => error.PathAlreadyExists,
            .NOENT => error.FileNotFound,
            .ACCES => error.AccessDenied,
            else => error.Unexpected,
        };
    }
}

pub fn nanoTimestamp() i128 {
    var ts: std.posix.timespec = undefined;
    _ = std.c.clock_gettime(std.c.CLOCK.REALTIME, &ts);
    return @as(i128, ts.sec) * std.time.ns_per_s + ts.nsec;
}

// debug compatibility
pub fn captureStackTrace(first_address: ?usize, stack_trace: *std.builtin.StackTrace) void {
    _ = first_address;
    // In Zig 0.16, stack trace capture is different
    // This is a stub
    stack_trace.index = 0;
}

// mem compatibility
pub fn trimLeft(comptime T: type, slice: []const T, values_to_strip: []const T) []const T {
    return std.mem.trimStart(T, slice, values_to_strip);
}

// process compatibility
// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn getEnvVarOwned(allocator: std.mem.Allocator, key: []const u8) error{OutOfMemory}!?[]u8 {
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
    const value = std.c.getenv(@ptrCast(key.ptr));
    if (value == null) return null;
    const slice = std.mem.span(value.?);
    return try allocator.dupe(u8, slice);
}

// heap compatibility
// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn getFdPath(fd: std.posix.fd_t, buf: []u8) ![]u8 {
    if (std.c.fcntl(fd, std.c.F.GETPATH, @intFromPtr(buf.ptr)) != 0) {
        return error.Unexpected;
    }
    var len: usize = 0;
    while (len < buf.len and buf[len] != 0) : (len += 1) {}
    return buf[0..len];
}

pub const ResetEvent = struct {
    mutex: std.Thread.Mutex = .{},
    cond: std.Thread.Condition = .{},
    signaled: bool = false,

    pub fn wait(self: *ResetEvent) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        while (!self.signaled) {
            self.cond.wait(&self.mutex);
        }
    }

    pub fn set(self: *ResetEvent) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        self.signaled = true;
        self.cond.broadcast();
    }

    pub fn reset(self: *ResetEvent) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        self.signaled = false;
    }
};

pub const raw_c_allocator = std.heap.c_allocator;

// Thread.Mutex compatibility - simple spinlock
pub const Mutex = struct {
    locked: std.atomic.Value(bool) = .init(false),

    pub fn lock(self: *Mutex) void {
        while (self.locked.cmpxchgWeak(false, true, .acquire, .monotonic) != null) {
            std.atomic.spinLoopHint();
        }
    }

    pub fn unlock(self: *Mutex) void {
        self.locked.store(false, .release);
    }
};

// Thread.Semaphore compatibility
pub const Semaphore = struct {
    count: std.atomic.Value(usize) = .init(0),

    pub fn wait(self: *Semaphore) void {
        while (true) {
            const current = self.count.load(.monotonic);
            if (current > 0) {
                if (self.count.cmpxchgWeak(current, current - 1, .acquire, .monotonic) == null) {
                    return;
                }
            }
            std.atomic.spinLoopHint();
        }
    }

    pub fn post(self: *Semaphore) void {
        _ = self.count.fetchAdd(1, .release);
    }
};

const safe = @import("safe");
