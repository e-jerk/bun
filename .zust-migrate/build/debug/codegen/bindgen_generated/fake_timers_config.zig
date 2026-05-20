pub const FakeTimersConfig = struct {
    const Self = @This();

    now: bun.bun_js.jsc.JSValue,

    pub fn deinit(self: *Self) void {
        bun.memory.deinit(&self.now);
        self[0] = undefined;
    }
    pub fn fromJS(globalThis: *jsc.JSGlobalObject, value: jsc.JSValue) bun.JSError!Self {
        var scope: jsc.ExceptionValidationScope = std.mem.zeroes(jsc.ExceptionValidationScope);
        scope.init(globalThis, @src());
        defer scope.deinit();
        var extern_result: ExternFakeTimersConfig = undefined;
        const success = bindgenConvertJSToFakeTimersConfig(globalThis, value, &extern_result);
        scope.assertExceptionPresenceMatches(!success);
        return if (success)
            BindgenFakeTimersConfig.convertFromExtern(extern_result)
        else
            error.JSError;
    }
};

pub const BindgenFakeTimersConfig = struct {
    const Self = @This();
    pub const ZigType = FakeTimersConfig;
    pub const ExternType = ExternFakeTimersConfig;
    pub fn convertFromExtern(extern_value: Self.ExternType) Self.ZigType {
        return .{
            .now = bindgen.BindgenRawAny.convertFromExtern(extern_value.now),
        };
    }
};

const ExternFakeTimersConfig = extern struct {
    now: bindgen.BindgenRawAny.ExternType,
};

extern fn bindgenConvertJSToFakeTimersConfig(
    globalObject: *jsc.JSGlobalObject,
    value: jsc.JSValue,
    result: *ExternFakeTimersConfig,
) bool;

const bindgen_generated = @import("bindgen_generated");
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
const jsc = bun.bun_js.jsc;
