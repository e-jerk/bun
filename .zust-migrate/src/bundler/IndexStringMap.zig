const IndexStringMap = @This();

pub const Index = bun.ast.Index;

map: std.AutoArrayHashMapUnmanaged(Index.Int, []const u8) = .{},

pub fn deinit(self: *IndexStringMap, allocator: std.mem.Allocator) void {
    for (self.map.values()) |value| {
        // safe-transpile: free removed (memory owned by safe type);
    }
    self.map.deinit(allocator);
}

pub fn get(self: *const IndexStringMap, index: Index.Int) ?[]const u8 {
    return self.map.get(index);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn put(self: *IndexStringMap, allocator: std.mem.Allocator, index: Index.Int, value: []const u8) !void {
    const duped = try allocator.dupe(u8, value);
    // safe-transpile: free removed (memory owned by safe type);
    try self.map.put(allocator, index, duped);
}

const bun = @import("bun");
const std = @import("std");
