//! Compatibility shim for ArrayHashMap
//! In Zig 0.16, use std.AutoArrayHashMapUnmanaged which is deprecated but works.
const std = @import("std");

pub const ArrayHashMap = std.array_hash_map.Custom;
pub const AutoArrayHashMap = std.AutoArrayHashMapUnmanaged;
pub const StringArrayHashMap = std.StringArrayHashMapUnmanaged;
pub const AutoArrayHashMapUnmanaged = std.AutoArrayHashMapUnmanaged;

pub fn Auto(comptime K: type, comptime V: type) type {
    return std.AutoArrayHashMapUnmanaged(K, V);
}
