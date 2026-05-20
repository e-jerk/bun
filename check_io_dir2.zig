const std = @import("std");

pub fn main() void {
    const info = @typeInfo(std.Io.Dir);
    switch (info) {
        .Struct => |s| {
            std.debug.print("Struct with {d} fields\n", .{s.fields.len});
            for (s.fields) |f| {
                std.debug.print("  {s}: {s}\n", .{f.name, @typeName(f.type)});
            }
        },
        .Int => |i| std.debug.print("Int: {d} bits\n", .{i.bits}),
        .Enum => |e| {
            std.debug.print("Enum with {d} fields\n", .{e.fields.len});
            for (e.fields) |f| {
                std.debug.print("  {s}\n", .{f.name});
            }
        },
        .Union => |u| {
            std.debug.print("Union with {d} fields\n", .{u.fields.len});
        },
        .Opaque => std.debug.print("Opaque\n", .{}),
        else => std.debug.print("Other: {s}\n", .{@tagName(info)}),
    }
}