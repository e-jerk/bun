//! Minimal shim for @import("std-net-shim").Address (removed in Zig 0.16)
const std = @import("std");

pub const Address = extern union {
    any: std.posix.sockaddr,
    in: std.posix.sockaddr.in,
    in6: std.posix.sockaddr.in6,

    pub fn initIp4(ip: [4]u8, port: u16) Address {
        const result: Address = .{ .in = .{
            .family = std.posix.AF.INET,
            .port = std.mem.nativeToBig(u16, port),
// safe-transpile: @bitCast requires manual review
            .addr = @as(u32, @bitCast(ip)),
            .zero = [_]u8{0} ** 8,
        }};
        return result;
    }

    pub fn initIp6(ip: [16]u8, port: u16, flowinfo: u32, scope_id: u32) Address {
        const result: Address = .{ .in6 = .{
            .family = std.posix.AF.INET6,
            .port = std.mem.nativeToBig(u16, port),
            .flowinfo = std.mem.nativeToBig(u32, flowinfo),
            .addr = ip,
            .scope_id = std.mem.nativeToBig(u32, scope_id),
        }};
        return result;
    }

    pub fn initPosix(addr: *const std.posix.sockaddr) Address {
        return switch (addr.family) {
// safe-transpile: @alignCast requires manual review
            std.posix.AF.INET => .{ .in = @as(*const std.posix.sockaddr.in, @ptrCast(@alignCast(addr))).* },
// safe-transpile: @alignCast requires manual review
            std.posix.AF.INET6 => .{ .in6 = @as(*const std.posix.sockaddr.in6, @ptrCast(@alignCast(addr))).* },
            else => @panic("unsupported address family"),
        };
    }

    pub fn format(self: Address, writer: anytype) !void {
        switch (self.any.family) {
            std.posix.AF.INET => {
                const addr = self.in.addr;
                try writer.print("{d}.{d}.{d}.{d}:{d}", .{
                    (addr >> 0) & 0xFF,
                    (addr >> 8) & 0xFF,
                    (addr >> 16) & 0xFF,
                    (addr >> 24) & 0xFF,
                    std.mem.bigToNative(u16, self.in.port),
                });
            },
            std.posix.AF.INET6 => {
                const port = std.mem.bigToNative(u16, self.in6.port);
                const addr = self.in6.addr;
                if (std.mem.eql(u8, addr[0..12], &[_]u8{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xff, 0xff })) {
                    try writer.print("[::ffff:{d}.{d}.{d}.{d}]:{d}", .{
                        addr[12], addr[13], addr[14], addr[15], port,
                    });
                    return;
                }
                const big_endian_parts = @as(*align(1) const [8]u16, @ptrCast(&addr));
                const native_endian_parts = blk: {
                    var buf: [8]u16 = undefined;
                    for (big_endian_parts, 0..) |part, i| {
                        buf[i] = std.mem.bigToNative(u16, part);
                    }
                    break :blk buf;
                };

                var longest_start: usize = 8;
                var longest_len: usize = 0;
                var current_start: usize = 0;
                var current_len: usize = 0;
                for (native_endian_parts, 0..) |part, i| {
                    if (part == 0) {
                        if (current_len == 0) current_start = i;
                        current_len += 1;
                        if (current_len > longest_len) {
                            longest_start = current_start;
                            longest_len = current_len;
                        }
                    } else {
                        current_len = 0;
                    }
                }
                if (longest_len < 2) {
                    longest_start = 8;
                    longest_len = 0;
                }

                try writer.writeAll("[");
                var i: usize = 0;
                var abbrv = false;
                while (i < native_endian_parts.len) : (i += 1) {
                    if (i == longest_start) {
                        if (!abbrv) {
                            try writer.writeAll(if (i == 0) "::" else ":");
                            abbrv = true;
                        }
                        i += longest_len - 1;
                        continue;
                    }
                    if (abbrv) abbrv = false;
                    try writer.print("{x}", .{native_endian_parts[i]});
                    if (i != native_endian_parts.len - 1) try writer.writeAll(":");
                }
                try writer.print("]:{d}", .{port});
            },
            else => try writer.writeAll("<unknown address family>"),
        }
    }

};

pub const Ip4Address = struct {
    sa: std.posix.sockaddr.in,

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn parse(presentation: []const u8, port: u16) !Ip4Address {
        const addr = try std.Io.net.Ip4Address.parse(presentation, port);
        return .{ .sa = .{
            .port = std.mem.nativeToBig(u16, addr.port),
            .addr = @bitCast(addr.bytes),
        } };
    }
};

pub const Ip6Address = struct {
    sa: std.posix.sockaddr.in6,

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn parse(presentation: []const u8, port: u16) !Ip6Address {
        const addr = try std.Io.net.Ip6Address.parse(presentation, port);
        return .{ .sa = .{
            .family = std.posix.AF.INET6,
            .port = std.mem.nativeToBig(u16, port),
            .flowinfo = std.mem.nativeToBig(u32, addr.flow),
            .addr = addr.bytes,
            .scope_id = std.mem.nativeToBig(u32, addr.interface.index),
        }};
    }
};

pub const has_unix_sockets = @hasField(std.posix.sockaddr, "un");

const safe = @import("safe");
