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
};
