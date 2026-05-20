//! Compatibility shim for ArrayHashMap - in Zig 0.16, std.array_hash_map.ArrayHashMap
//! IS the managed version with the old API, so we just re-export it.
const std = @import("std");

pub const ArrayHashMap = std.array_hash_map.ArrayHashMap;
pub const AutoArrayHashMap = std.array_hash_map.AutoArrayHashMap;
pub const StringArrayHashMap = std.array_hash_map.StringArrayHashMap;

/// Convenience alias matching the old std.array_hash_map.Auto
pub fn Auto(comptime K: type, comptime V: type) type {
    return AutoArrayHashMap(K, V);
}
