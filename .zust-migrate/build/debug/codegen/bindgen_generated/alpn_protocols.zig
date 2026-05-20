pub const ALPNProtocols = union(enum) {
    none: void,
    string: bun.string.WTFString,
    buffer: bun.bun_js.jsc.JSCArrayBuffer.Ref,

    pub fn deinit(self: *@This()) void {
        switch (std.meta.activeTag(self.*)) {
            inline else => |tag| bun.memory.deinit(&@field(self, @tagName(tag))),
        }
        self[0] = undefined;
    }
};

pub const BindgenALPNProtocols = struct {
    const Self = @This();
    pub const ZigType = ALPNProtocols;
    pub const ExternType = bindgen.ExternTaggedUnion(&.{ bindgen.BindgenNull.ExternType, bindgen.BindgenString.ExternType, bindgen.BindgenArrayBuffer.ExternType });
    pub fn convertFromExtern(extern_value: Self.ExternType) Self.ZigType {
        return switch (extern_value.tag) {
            0 => .{ .none = bindgen.BindgenNull.convertFromExtern(extern_value.data.@"0") },
            1 => .{ .string = bindgen.BindgenString.convertFromExtern(extern_value.data.@"1") },
            2 => .{ .buffer = bindgen.BindgenArrayBuffer.convertFromExtern(extern_value.data.@"2") },
            else => unreachable,
        };
    }
};

const bindgen_generated = @import("bindgen_generated");
const std = @import("std");
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
