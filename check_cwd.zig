const std = @import("std");

pub fn main() void {
    const cwd = std.Io.Dir.cwd();
    std.debug.print("cwd.handle = {d}\n", .{cwd.handle});
    std.debug.print("AT.FDCWD = {d}\n", .{std.c.AT.FDCWD});
}