pub const SSLConfigSingleFile = union(enum) {
    string: bun.string.WTFString,
    buffer: bun.bun_js.jsc.JSCArrayBuffer.Ref,
    file: bun.bun_js.webcore.Blob.Ref,

    pub fn deinit(self: *@This()) void {
        switch (std.meta.activeTag(self.*)) {
            inline else => |tag| bun.memory.deinit(&@field(self, @tagName(tag))),
        }
        self[0] = undefined;
    }
};

pub const BindgenSSLConfigSingleFile = struct {
    const Self = @This();
    pub const ZigType = SSLConfigSingleFile;
    pub const ExternType = bindgen.ExternTaggedUnion(&.{ bindgen.BindgenString.ExternType, bindgen.BindgenArrayBuffer.ExternType, bindgen.BindgenBlob.ExternType });
    pub fn convertFromExtern(extern_value: Self.ExternType) Self.ZigType {
        return switch (extern_value.tag) {
            0 => .{ .string = bindgen.BindgenString.convertFromExtern(extern_value.data.@"0") },
            1 => .{ .buffer = bindgen.BindgenArrayBuffer.convertFromExtern(extern_value.data.@"1") },
            2 => .{ .file = bindgen.BindgenBlob.convertFromExtern(extern_value.data.@"2") },
            else => unreachable,
        };
    }
};

const bindgen_generated = @import("bindgen_generated");
const std = @import("std");
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
