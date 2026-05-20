const std = @import("std");

pub fn main() void {
    inline for (@typeInfo(std.Target.Os.Tag).Enum.fields) |f| {
        if (std.mem.containsAtLeast(u8, f.name, 1, "sol") or std.mem.containsAtLeast(u8, f.name, 1, "il")) {
            std.debug.print("{s}\n", .{f.name});
        }
    }
}