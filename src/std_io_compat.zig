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

        pub fn getWritten(self: Self) []const u8 {
            if (@typeInfo(@TypeOf(self.buffer)) == .Pointer) {
                return self.buffer[0..self.pos];
            } else {
                return &self.buffer[0..self.pos];
            }
        }

        const Writer = struct {
            context: *Self,

            pub const Error = error{OutOfMemory};

            pub fn writeAll(w: Writer, bytes: []const u8) Error!void {
                const self = w.context;
                const end = @min(self.pos + bytes.len, self.buffer.len);
                const to_write = bytes[0..(end - self.pos)];
                @memcpy(self.buffer[self.pos..end], to_write);
                self.pos += to_write.len;
                if (to_write.len < bytes.len) return error.OutOfMemory;
            }

            pub fn print(w: Writer, comptime fmt: []const u8, args: anytype) error{OutOfMemory}!void {
                const self = w.context;
                const remaining = self.buffer[self.pos..];
                const result = std.fmt.bufPrint(remaining, fmt, args) catch return error.OutOfMemory;
                self.pos += result.len;
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

            pub fn readNoEof(r: Reader, buf: []u8) Error!void {
                const self = r.context;
                if (self.pos + buf.len > self.buffer.len) return error.EndOfStream;
                @memcpy(buf, self.buffer[self.pos..][0..buf.len]);
                self.pos += buf.len;
            }
        };
    };
}

pub fn fixedBufferStream(buffer: anytype) FixedBufferStream(@TypeOf(buffer)) {
    return .{ .buffer = buffer };
}

pub const GenericWriter = struct {
    context: *anyopaque,
    writeFn: *const fn (*anyopaque, []const u8) anyerror!usize,

    pub fn write(self: GenericWriter, bytes: []const u8) anyerror!usize {
        return self.writeFn(self.context, bytes);
    }

    pub fn writeAll(self: GenericWriter, bytes: []const u8) !void {
        var written: usize = 0;
        while (written < bytes.len) {
            written += try self.write(bytes[written..]);
        }
    }
};

pub fn detectConfig(file: anytype) @TypeOf(file) {
    return file;
}
