pub const SSLConfigFile = union(enum) {
    none: void,
    string: bun.string.WTFString,
    buffer: bun.bun_js.jsc.JSCArrayBuffer.Ref,
    file: bun.bun_js.webcore.Blob.Ref,
    array: bun.collections.ArrayListDefault(bindgen_generated.SSLConfigSingleFile),

    pub fn deinit(self: *@This()) void {
        switch (std.meta.activeTag(self.*)) {
            inline else => |tag| bun.memory.deinit(&@field(self, @tagName(tag))),
        }
        self[0] = undefined;
    }
};

pub const BindgenSSLConfigFile = struct {
    const Self = @This();
    pub const ZigType = SSLConfigFile;
    pub const ExternType = bindgen.ExternTaggedUnion(&.{ bindgen.BindgenNull.ExternType, bindgen.BindgenString.ExternType, bindgen.BindgenArrayBuffer.ExternType, bindgen.BindgenBlob.ExternType, bindgen.BindgenArray(bindgen_generated.internal.SSLConfigSingleFile).ExternType });
    pub fn convertFromExtern(extern_value: Self.ExternType) Self.ZigType {
        return switch (extern_value.tag) {
            0 => .{ .none = bindgen.BindgenNull.convertFromExtern(extern_value.data.@"0") },
            1 => .{ .string = bindgen.BindgenString.convertFromExtern(extern_value.data.@"1") },
            2 => .{ .buffer = bindgen.BindgenArrayBuffer.convertFromExtern(extern_value.data.@"2") },
            3 => .{ .file = bindgen.BindgenBlob.convertFromExtern(extern_value.data.@"3") },
            4 => .{ .array = bindgen.BindgenArray(bindgen_generated.internal.SSLConfigSingleFile).convertFromExtern(extern_value.data.@"4") },
            else => unreachable,
        };
    }
};

const bindgen_generated = @import("bindgen_generated");
const std = @import("std");
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
