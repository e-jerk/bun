array: *std.array_list.Managed(u8),

pub fn offset(this: @This()) usize {
    return this.array.items.len;
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn write(this: @This(), bytes: []const u8) AnyPostgresError!void {
    try this.array.appendSlice(bytes);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn pwrite(this: @This(), bytes: []const u8, i: usize) AnyPostgresError!void {
// safe-transpile: @memcpy requires manual review
    @memcpy(this.array.items[i..][0..bytes.len], bytes);
}

pub const Writer = NewWriter(@This());

const std = @import("std");
const AnyPostgresError = @import("../AnyPostgresError.zig").AnyPostgresError;
const NewWriter = @import("./NewWriter.zig").NewWriter;

const safe = @import("safe");
