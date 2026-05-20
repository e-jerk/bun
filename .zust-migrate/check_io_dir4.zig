const std = @import("std");

pub fn main() void {
    const info = @typeInfo(std.Io.Dir);
    std.debug.print("Tag: {s}\n", .{@tagName(info)});
    if (info == .Int) {
        std.debug.print("Int bits: {d}\n", .{@intFromEnum(info.Int.signedness)});
    }
    if (info == .Enum) {
        std.debug.print("Enum\n", .{});
    }
    if (info == .Struct) {
        std.debug.print("Struct fields: {d}\n", .{info.Struct.fields.len});
    }
}