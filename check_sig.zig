const std = @import("std");

pub fn main() void {
    std.debug.print("SIG type: {s}\n", .{@typeName(std.c.SIG)});
}