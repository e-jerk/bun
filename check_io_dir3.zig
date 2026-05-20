const std = @import("std");

pub fn main() void {
    const info = @typeInfo(std.Io.Dir);
    std.debug.print("Tag: {s}\n", .{@tagName(info)});
    switch (info) {
        inline else => |payload| {
            std.debug.print("Payload: {any}\n", .{payload});
        },
    }
}