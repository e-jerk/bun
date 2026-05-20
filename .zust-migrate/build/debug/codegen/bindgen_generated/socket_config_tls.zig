pub const SocketConfigTLS = union(enum) {
    none: void,
    boolean: bool,
    object: bindgen_generated.SSLConfig,

    pub fn deinit(self: *@This()) void {
        switch (std.meta.activeTag(self.*)) {
            inline else => |tag| bun.memory.deinit(&@field(self, @tagName(tag))),
        }
        self[0] = undefined;
    }
};

pub const BindgenSocketConfigTLS = struct {
    const Self = @This();
    pub const ZigType = SocketConfigTLS;
    pub const ExternType = bindgen.ExternTaggedUnion(&.{ bindgen.BindgenNull.ExternType, bindgen.BindgenBool.ExternType, bindgen_generated.internal.SSLConfig.ExternType });
    pub fn convertFromExtern(extern_value: Self.ExternType) Self.ZigType {
        return switch (extern_value.tag) {
            0 => .{ .none = bindgen.BindgenNull.convertFromExtern(extern_value.data.@"0") },
            1 => .{ .boolean = bindgen.BindgenBool.convertFromExtern(extern_value.data.@"1") },
            2 => .{ .object = bindgen_generated.internal.SSLConfig.convertFromExtern(extern_value.data.@"2") },
            else => unreachable,
        };
    }
};

const bindgen_generated = @import("bindgen_generated");
const std = @import("std");
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
