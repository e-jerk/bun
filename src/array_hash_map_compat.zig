//! Compatibility shim for ArrayHashMap
//! Wraps Zig 0.16 unmanaged ArrayHashMap with a managed API.
const std = @import("std");

pub const ArrayHashMap = std.array_hash_map.Custom;

/// Managed wrapper that stores allocator (matches 0.15 managed API)
pub fn Managed(comptime K: type, comptime V: type, comptime Context: type, comptime store_hash: bool) type {
    const Unmanaged = std.array_hash_map.Custom(K, V, Context, store_hash);
    return struct {
        allocator: std.mem.Allocator,
        map: Unmanaged,

        const Self = @This();
        pub const Entry = Unmanaged.Entry;
        pub const GetOrPutResult = Unmanaged.GetOrPutResult;
        pub const KV = Unmanaged.KV;

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .map = .{},
            };
        }

        pub fn initContext(allocator: std.mem.Allocator, ctx: Context) Self {
            _ = ctx;
            return init(allocator);
        }

        pub fn deinit(self: *Self) void {
            self.map.deinit(self.allocator);
        }

        pub fn count(self: Self) usize {
            return self.map.count();
        }

        pub fn keys(self: Self) []K {
            return self.map.keys();
        }

        pub fn values(self: Self) []V {
            return self.map.values();
        }

        pub fn getOrPut(self: *Self, key: K) !GetOrPutResult {
            return self.map.getOrPut(self.allocator, key);
        }

        pub fn put(self: *Self, key: K, value: V) !void {
            return self.map.put(self.allocator, key, value);
        }

        pub fn get(self: Self, key: K) ?V {
            return self.map.get(key);
        }

        pub fn contains(self: Self, key: K) bool {
            return self.map.contains(key);
        }

        pub fn swapRemove(self: *Self, key: K) bool {
            return self.map.swapRemove(key);
        }

        pub fn clearAndFree(self: *Self) void {
            self.map.clearAndFree(self.allocator);
        }

        pub fn clearRetainingCapacity(self: *Self) void {
            self.map.clearRetainingCapacity();
        }

        pub fn ensureTotalCapacity(self: *Self, new_size: usize) !void {
            return self.map.ensureTotalCapacity(self.allocator, new_size);
        }

        pub fn ensureUnusedCapacity(self: *Self, additional_count: usize) !void {
            return self.map.ensureUnusedCapacity(self.allocator, additional_count);
        }

        pub fn putAssumeCapacity(self: *Self, key: K, value: V) void {
            return self.map.putAssumeCapacity(key, value);
        }

        pub fn iterator(self: Self) Unmanaged.Iterator {
            return self.map.iterator();
        }

        pub fn lockPointers(self: *Self) void {
            self.map.lockPointers();
        }

        pub fn unlockPointers(self: *Self) void {
            self.map.unlockPointers();
        }

        pub fn getPtr(self: Self, key: K) ?*V {
            return self.map.getPtr(key);
        }

        pub fn swapRemoveAt(self: *Self, i: usize) ?KV {
            return self.map.swapRemoveAt(i);
        }

        pub fn putAssumeCapacityNoClobber(self: *Self, key: K, value: V) void {
            return self.map.putAssumeCapacityNoClobber(key, value);
        }

        pub fn capacity(self: Self) usize {
            return self.map.capacity();
        }

        pub fn shrinkAndFree(self: *Self, new_len: usize) void {
            return self.map.shrinkAndFree(self.allocator, new_len);
        }
    };
}

pub fn AutoArrayHashMap(comptime K: type, comptime V: type) type {
    return Managed(K, V, std.array_hash_map.AutoContext(K), !std.array_hash_map.autoEqlIsCheap(K));
}

pub fn StringArrayHashMap(comptime V: type) type {
    return Managed([]const u8, V, std.array_hash_map.StringContext, true);
}

pub const AutoArrayHashMapUnmanaged = std.AutoArrayHashMapUnmanaged;

pub fn Auto(comptime K: type, comptime V: type) type {
    return AutoArrayHashMap(K, V);
}
