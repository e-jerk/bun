const bun = @import("bun");

pub const Version = @import("std").mem.zeroes(u32);

pub const upgrade_js_bindings = struct {
    pub fn generate(global: *bun.jsc.JSGlobalObject) bun.jsc.JSValue {
        _ = global;
        return .js_undefined;
    }
};
