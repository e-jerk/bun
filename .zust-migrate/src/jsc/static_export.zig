Type: type,
symbol_name: []const u8,
local_name: []const u8,

Parent: type,

pub fn Decl(comptime this: *const @This()) std.builtin.Type.Declaration {
    return comptime std.meta.declarationInfo(this.Parent, this.local_name);
}

// safe-transpile: function returns small constant slice — consider safe.String
pub fn wrappedName(comptime this: *const @This()) []const u8 {
    return comptime "wrap" ++ this.symbol_name;
}

const std = @import("std");
