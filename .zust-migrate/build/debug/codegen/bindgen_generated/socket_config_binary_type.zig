pub const SocketConfigBinaryType = enum(u32) {
    @"arraybuffer",
    @"buffer",
    @"uint8array",
};

pub const BindgenSocketConfigBinaryType = bindgen.BindgenTrivial(SocketConfigBinaryType);
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
