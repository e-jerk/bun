const std = @import("std");

pub fn main() void {
    std.debug.print("Dir type: {s}\n", .{@typeName(std.Io.Dir)});
    std.debug.print("Dir size: {d}\n", .{@sizeOf(std.Io.Dir)});
}