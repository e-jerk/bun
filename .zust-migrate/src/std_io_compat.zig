//! Compatibility shim for std.io APIs removed in Zig 0.16
const std = @import("std");

pub fn FixedBufferStream(comptime Buffer: type) type {
    return struct {
        buffer: Buffer,
        pos: usize = 0,

        const Self = @This();

        pub fn writer(self: *Self) Writer {
            return .{ .context = self };
        }

        pub fn reader(self: *Self) Reader {
            return .{ .context = self };
        }

        pub fn seekTo(self: *Self, pos: usize) !void {
            self.pos = pos;
        }

        pub fn getPos(self: Self) !usize {
            return self.pos;
        }

        pub fn reset(self: *Self) void {
            self.pos = 0;
        }

// safe-transpile: function returns small constant slice — consider safe.String
        pub fn getWritten(self: Self) []const u8 {
            if (@typeInfo(@TypeOf(self.buffer)) == .pointer) {
                return self.buffer[0..self.pos];
            } else {
                return &self.buffer[0..self.pos];
            }
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn write(self: *Self, bytes: []const u8) error{OutOfMemory}!usize {
            const end = @min(self.pos + bytes.len, self.buffer.len);
            const to_write = bytes[0..(end - self.pos)];
            safe.SimdUtils.copy(self.buffer[self.pos..end], to_write);
            self.pos += to_write.len;
            return to_write.len;
        }

        const Writer = struct {
            context: *Self,

            pub const Error = error{OutOfMemory};

// safe-transpile: function uses raw slice parameter — consider safe.String
            pub fn write(w: Writer, bytes: []const u8) Error!usize {
                const self = w.context;
                const end = @min(self.pos + bytes.len, self.buffer.len);
                const to_write = bytes[0..(end - self.pos)];
                safe.SimdUtils.copy(self.buffer[self.pos..end], to_write);
                self.pos += to_write.len;
                return to_write.len;
            }

// safe-transpile: function uses raw slice parameter — consider safe.String
            pub fn writeAll(w: Writer, bytes: []const u8) Error!void {
                const self = w.context;
                const end = @min(self.pos + bytes.len, self.buffer.len);
                const to_write = bytes[0..(end - self.pos)];
                safe.SimdUtils.copy(self.buffer[self.pos..end], to_write);
                self.pos += to_write.len;
                if (to_write.len < bytes.len) return error.OutOfMemory;
            }

// safe-transpile: function uses raw slice parameter — consider safe.String
            pub fn print(w: Writer, comptime fmt: []const u8, args: anytype) error{OutOfMemory}!void {
                const self = w.context;
                const remaining = self.buffer[self.pos..];
                const result = std.fmt.bufPrint(remaining, fmt, args) catch return error.OutOfMemory;
                self.pos += result.len;
            }

            pub fn writeByte(w: Writer, byte: u8) Error!void {
                const self = w.context;
                if (self.pos >= self.buffer.len) return error.OutOfMemory;
                self.buffer[self.pos] = byte;
                self.pos += 1;
            }

            pub fn writeInt(w: Writer, comptime T: type, value: T, endian: std.builtin.Endian) Error!void {
                const size = @sizeOf(T);
                const self = w.context;
                const end = self.pos + size;
                if (end > self.buffer.len) return error.OutOfMemory;
                std.mem.writeInt(T, self.buffer[self.pos..end][0..size], value, endian);
                self.pos = end;
            }
        };

        const Reader = struct {
            context: *Self,

            pub const Error = error{EndOfStream};

            pub fn readInt(r: Reader, comptime T: type, endian: std.builtin.Endian) Error!T {
                const self = r.context;
                const size = @sizeOf(T);
                if (self.pos + size > self.buffer.len) return error.EndOfStream;
                const result = std.mem.readInt(T, self.buffer[self.pos..][0..size], endian);
                self.pos += size;
                return result;
            }

            pub fn readEnum(r: Reader, comptime T: type, endian: std.builtin.Endian) Error!T {
                const self = r.context;
                const tag_type = @typeInfo(T).@"enum".tag_type;
                const size = @sizeOf(tag_type);
                if (self.pos + size > self.buffer.len) return error.EndOfStream;
                const tag_value = std.mem.readInt(tag_type, self.buffer[self.pos..][0..size], endian);
                self.pos += size;
                return @enumFromInt(tag_value);
            }

            pub fn readStruct(r: Reader, comptime T: type) Error!T {
                const self = r.context;
                const size = @sizeOf(T);
                if (self.pos + size > self.buffer.len) return error.EndOfStream;
                var result: T = undefined;
                safe.SimdUtils.copy(std.mem.asBytes(&result), self.buffer[self.pos..][0..size]);
                self.pos += size;
                return result;
            }

// safe-transpile: function uses raw slice parameter — consider safe.String
            pub fn readNoEof(r: Reader, buf: []u8) Error!void {
                const self = r.context;
                if (self.pos + buf.len > self.buffer.len) return error.EndOfStream;
                safe.SimdUtils.copy(buf, self.buffer[self.pos..][0..buf.len]);
                self.pos += buf.len;
            }

// safe-transpile: function uses raw slice parameter — consider safe.String
            pub fn read(r: Reader, buf: []u8) Error!usize {
                const self = r.context;
                const available = self.buffer.len - self.pos;
                const to_read = @min(buf.len, available);
                safe.SimdUtils.copy(buf[0..to_read], self.buffer[self.pos..][0..to_read]);
                self.pos += to_read;
                return to_read;
            }

// safe-transpile: function uses raw slice parameter — consider safe.String
            pub fn readAll(r: Reader, buf: []u8) Error!usize {
                const self = r.context;
                const available = self.buffer.len - self.pos;
                const to_read = @min(buf.len, available);
                safe.SimdUtils.copy(buf[0..to_read], self.buffer[self.pos..][0..to_read]);
                self.pos += to_read;
                return to_read;
            }
        };
    };
}

pub fn fixedBufferStream(buffer: anytype) FixedBufferStream(@TypeOf(buffer)) {
    return .{ .buffer = buffer };
}

pub const GenericWriter = struct {
    context: *anyopaque,
// safe-transpile: function uses raw slice parameter — consider safe.String
    writeFn: *const fn (*anyopaque, []const u8) anyerror!usize,

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn write(self: GenericWriter, bytes: []const u8) anyerror!usize {
        return self.writeFn(self.context, bytes);
    }

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn writeAll(self: GenericWriter, bytes: []const u8) !void {
        var written: usize = 0;
        while (written < bytes.len) {
            written += try self.write(bytes[written..]);
        }
    }
};

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn MakeGenericWriter(comptime Context: type, comptime WriteError: type, comptime writeFn: fn (context: Context, bytes: []const u8) WriteError!usize) type {
    return struct {
        context: Context,

        pub const Error = WriteError;

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn write(self: @This(), bytes: []const u8) Error!usize {
            return writeFn(self.context, bytes);
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn writeAll(self: @This(), bytes: []const u8) Error!void {
            var written: usize = 0;
            while (written < bytes.len) {
                written += try self.write(bytes[written..]);
            }
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn print(self: @This(), comptime fmt: []const u8, args: anytype) Error!void {
            var buf: [65536]u8 = .{};
            const result = std.fmt.bufPrint(&buf, fmt, args) catch unreachable;
            try self.writeAll(result);
        }

        pub fn writeInt(self: @This(), comptime T: type, value: T, endian: std.builtin.Endian) Error!void {
            var buf: [@sizeOf(T)]u8 = .{};
            std.mem.writeInt(T, &buf, value, endian);
            try self.writeAll(&buf);
        }

        pub fn writeStruct(self: @This(), value: anytype) Error!void {
            const bytes = std.mem.asBytes(&value);
            try self.writeAll(bytes);
        }

        pub const Adapter = struct {
            new_interface: std.Io.Writer,
            context: Context,

            fn drain(w: *std.Io.Writer, data: []const []const u8, splat: usize) std.Io.Writer.Error!usize {
                const adapter: *Adapter = // safe-transpile: @alignCast requires manual review
    @alignCast(@fieldParentPtr("new_interface", w));
                if (w.end > 0) {
                    _ = writeFn(adapter.context, w.buffer[0..w.end]) catch return error.WriteFailed;
                    w.end = 0;
                }
                var total: usize = 0;
                if (data.len > 0) {
                    for (data[0 .. data.len - 1]) |bytes| {
                        total += writeFn(adapter.context, bytes) catch return error.WriteFailed;
                    }
                    const last = data[data.len - 1];
                    for (0..splat) |_| {
                        total += writeFn(adapter.context, last) catch return error.WriteFailed;
                    }
                }
                return total;
            }

            fn flush(w: *std.Io.Writer) std.Io.Writer.Error!void {
                const adapter: *Adapter = // safe-transpile: @alignCast requires manual review
    @alignCast(@fieldParentPtr("new_interface", w));
                if (w.end > 0) {
                    _ = writeFn(adapter.context, w.buffer[0..w.end]) catch return error.WriteFailed;
                    w.end = 0;
                }
            }
        };

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn adaptToNewApi(self: @This(), buffer: []u8) Adapter {
            return .{
                .new_interface = .{
                    .vtable = &.{
                        .drain = Adapter.drain,
                        .flush = Adapter.flush,
                        .rebase = std.Io.Writer.failingRebase,
                    },
                    .buffer = buffer,
                },
                .context = self.context,
            };
        }
    };
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn MakeGenericReader(comptime Context: type, comptime ReadError: type, comptime readFn: fn (context: Context, buf: []u8) ReadError!usize) type {
    return struct {
        context: Context,

        pub const Error = ReadError;

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn read(self: @This(), buf: []u8) Error!usize {
            return readFn(self.context, buf);
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn readAll(self: @This(), buf: []u8) Error!usize {
            var read_count: usize = 0;
            while (read_count < buf.len) {
                const n = try self.read(buf[read_count..]);
                if (n == 0) break;
                read_count += n;
            }
            return read_count;
        }

        pub fn readByte(self: @This()) Error!u8 {
            var buf: [1]u8 = .{};
            const n = try self.read(&buf);
            if (n == 0) return error.EndOfStream;
            return buf[0];
        }

        pub fn readInt(self: @This(), comptime T: type, endian: std.builtin.Endian) Error!T {
            var buf: [@sizeOf(T)]u8 = .{};
            const n = try self.readAll(&buf);
            if (n < @sizeOf(T)) return error.EndOfStream;
            return std.mem.readInt(T, &buf, endian);
        }

        pub fn readEnum(self: @This(), comptime T: type, endian: std.builtin.Endian) Error!T {
            const tag_type = @typeInfo(T).@"enum".tag_type;
            const tag_value = try self.readInt(tag_type, endian);
            return @enumFromInt(tag_value);
        }
    };
}

pub fn ArrayListWriter(comptime List: type) type {
    // Detect if List stores allocator internally (Managed) or not (Unmanaged)
    const is_managed = comptime blk: {
        var LT = List;
        while (@typeInfo(LT) == .pointer) LT = @typeInfo(LT).pointer.child;
        break :blk @hasField(LT, "allocator") or @hasField(LT, "__allocator");
    };
    // Normalize context to always be a single pointer to the list struct
    const Context = blk: {
        var T = List;
        // Follow double (or deeper) pointers one level
        if (@typeInfo(T) == .pointer) {
            const Child = @typeInfo(T).pointer.child;
            if (@typeInfo(Child) == .pointer) T = Child;
        }
        break :blk if (@typeInfo(T) == .pointer) T else *T;
    };
    return struct {
        context: Context,

        pub const Error = error{OutOfMemory};

        fn listPtr(self: @This()) Context {
            return @constCast(self.context);
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        fn doAppend(list: Context, bytes: []const u8) Error!void {
            const old_len = list.items.len;
            const new_len = old_len + bytes.len;
            if (new_len > list.capacity) {
                if (comptime is_managed) {
                    try list.ensureTotalCapacity(new_len);
                } else {
                    // unreachable for unmanaged through this writer
                    return error.OutOfMemory;
                }
            }
            safe.SimdUtils.copy(list.items.ptr[old_len..new_len], bytes);
            list.items.len = new_len;
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn writeAll(self: @This(), bytes: []const u8) Error!void {
            try doAppend(self.listPtr(), bytes);
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn write(self: @This(), bytes: []const u8) Error!usize {
            try doAppend(self.listPtr(), bytes);
            return bytes.len;
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn print(self: @This(), comptime fmt: []const u8, args: anytype) Error!void {
            var buf: [4096]u8 = .{};
            const result = std.fmt.bufPrint(&buf, fmt, args) catch return error.OutOfMemory;
            try doAppend(self.listPtr(), result);
        }

        pub fn writeByte(self: @This(), byte: u8) Error!void {
            try doAppend(self.listPtr(), &.{byte});
        }

        pub fn writeInt(self: @This(), comptime T: type, value: T, endian: std.builtin.Endian) Error!void {
            var buf: [@sizeOf(T)]u8 = .{};
            std.mem.writeInt(T, &buf, value, endian);
            try doAppend(self.listPtr(), &buf);
        }

        pub fn writeByteNTimes(self: @This(), byte: u8, n: usize) Error!void {
            const list = self.listPtr();
            const old_len = list.items.len;
            const new_len = old_len + n;
            if (new_len > list.capacity) {
                if (comptime is_managed) {
                    try list.ensureTotalCapacity(new_len);
                } else {
                    return error.OutOfMemory;
                }
            }
            @memset(list.items.ptr[old_len..new_len], byte);
            list.items.len = new_len;
        }

        pub fn writeStruct(self: @This(), value: anytype) Error!void {
            const bytes = std.mem.asBytes(&value);
            try doAppend(self.listPtr(), bytes);
        }
    };
}

pub fn arrayListWriter(list: anytype) ArrayListWriter(@TypeOf(list)) {
    const List = @TypeOf(list);
    if (@typeInfo(List) == .pointer) {
        const Child = @typeInfo(List).pointer.child;
        if (@typeInfo(Child) == .pointer) {
            // list is **T or deeper; store *T
            return .{ .context = list.* };
        }
        return .{ .context = list };
    } else {
        return .{ .context = @constCast(&list) };
    }
}



/// Compatibility shim for .writer() on std.array_list.Managed
/// Usage: `const w = @import("std-io-compat").writer(my_list);`
pub fn writer(list: anytype) ArrayListWriter(@TypeOf(list)) {
    return arrayListWriter(list);
}

pub fn allocatingWriterFromArrayList(allocator: std.mem.Allocator, list: anytype) UnmanagedArrayListWriter(@TypeOf(list)) {
    return .{ .context = list, .allocator = allocator };
}

pub fn UnmanagedArrayListWriter(comptime List: type) type {
    const is_managed = comptime blk: {
        var LT = List;
        while (@typeInfo(LT) == .pointer) LT = @typeInfo(LT).pointer.child;
        break :blk @hasField(LT, "allocator") or @hasField(LT, "__allocator");
    };
    return struct {
        context: List,
        allocator: std.mem.Allocator,

        pub const Error = error{OutOfMemory};

// safe-transpile: function uses raw slice parameter — consider safe.String
        fn doAppend(list: List, allocator: std.mem.Allocator, bytes: []const u8) Error!void {
            var l = if (comptime @typeInfo(List) == .pointer) list.* else list;
            const old_len = l.items.len;
            const new_len = old_len + bytes.len;
            if (comptime is_managed) {
                try l.ensureTotalCapacity(new_len);
            } else {
                try l.ensureTotalCapacity(allocator, new_len);
            }
            safe.SimdUtils.copy(l.items.ptr[old_len..new_len], bytes);
            l.items.len = new_len;
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn writeAll(self: @This(), bytes: []const u8) Error!void {
            try doAppend(self.context, self.allocator, bytes);
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn write(self: @This(), bytes: []const u8) Error!usize {
            try doAppend(self.context, self.allocator, bytes);
            return bytes.len;
        }

// safe-transpile: function uses raw slice parameter — consider safe.String
        pub fn print(self: @This(), comptime fmt: []const u8, args: anytype) Error!void {
            var buf: [4096]u8 = .{};
            const result = std.fmt.bufPrint(&buf, fmt, args) catch return error.OutOfMemory;
            try doAppend(self.context, self.allocator, result);
        }

        pub fn writeByte(self: @This(), byte: u8) Error!void {
            try doAppend(self.context, self.allocator, &.{byte});
        }
    };
}

pub const DummyIo = struct {};

pub fn compatIo() DummyIo {
    return .{};
}

pub const Color = enum {
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    bright_black,
    bright_red,
    bright_green,
    bright_yellow,
    bright_blue,
    bright_magenta,
    bright_cyan,
    bright_white,
    bold,
    dim,
    reset,
};

pub const TtyConfig = union(enum) {
    no_color,
    escape_codes,

    pub fn setColor(self: TtyConfig, out_stream: anytype, color: Color) !void {
        switch (self) {
            .no_color => return,
            .escape_codes => {
                const color_string = switch (color) {
                    .black => "\x1b[30m",
                    .red => "\x1b[31m",
                    .green => "\x1b[32m",
                    .yellow => "\x1b[33m",
                    .blue => "\x1b[34m",
                    .magenta => "\x1b[35m",
                    .cyan => "\x1b[36m",
                    .white => "\x1b[37m",
                    .bright_black => "\x1b[90m",
                    .bright_red => "\x1b[91m",
                    .bright_green => "\x1b[92m",
                    .bright_yellow => "\x1b[93m",
                    .bright_blue => "\x1b[94m",
                    .bright_magenta => "\x1b[95m",
                    .bright_cyan => "\x1b[96m",
                    .bright_white => "\x1b[97m",
                    .bold => "\x1b[1m",
                    .dim => "\x1b[2m",
                    .reset => "\x1b[0m",
                };
                try out_stream.writeAll(color_string);
            },
        }
    }
};

pub fn detectConfig(file: anytype) TtyConfig {
    _ = file;
    return .escape_codes;
}
