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
            std.posix.AF.INET => .{ .in = @as(*const std.posix.sockaddr.in, @ptrCast(@alignCast(addr))).* },
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
                try writer.print("[{any}]:{d}", .{ self.in6.addr, std.mem.bigToNative(u16, self.in6.port) });
            },
            else => try writer.writeAll("<unknown address family>"),
        }
    }

};

pub const Ip4Address = struct {
    sa: std.posix.sockaddr.in,

    pub fn parse(presentation: []const u8, port: u16) !Ip4Address {
        const addr = try std.net.Ip4Address.parse(presentation, port);
        return .{ .sa = addr.sa };
    }
};

pub const Ip6Address = struct {
    sa: std.posix.sockaddr.in6,

    pub fn parse(presentation: []const u8, port: u16) !Ip6Address {
        const addr = try std.net.Ip6Address.parse(presentation, port);
        return .{ .sa = addr.sa };
    }
};

pub const has_unix_sockets = @hasField(std.posix.sockaddr, "un");

const safe = @import("safe");
