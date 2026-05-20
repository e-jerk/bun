test {
    _ = @import("./shell_parser/braces.zig");
    _ = @import("./runtime/node/assert/myers_diff.zig");
}

test "basic string usage" {
    var s = bun.String.cloneUTF8("hi");
    defer s.deref();
    try t.expect(s.tag != .Dead and s.tag != .Empty);
    try t.expectEqual(s.length(), 2);
    try t.expectEqualStrings(if (s.asUTF8()) |value| {
    value
} else {
    return error.NullPointer;
}, "hi");
}

const bun = @import("bun");

const std = @import("std");
const t = std.testing;
