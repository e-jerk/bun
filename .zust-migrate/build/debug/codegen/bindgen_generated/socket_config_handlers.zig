pub const SocketConfigHandlers = struct {
    const Self = @This();

    onOpen: bun.bun_js.jsc.JSValue,
    onClose: bun.bun_js.jsc.JSValue,
    onError: bun.bun_js.jsc.JSValue,
    onData: bun.bun_js.jsc.JSValue,
    onWritable: bun.bun_js.jsc.JSValue,
    onHandshake: bun.bun_js.jsc.JSValue,
    onEnd: bun.bun_js.jsc.JSValue,
    onConnectError: bun.bun_js.jsc.JSValue,
    onTimeout: bun.bun_js.jsc.JSValue,
    binary_type: bindgen_generated.SocketConfigBinaryType,

    pub fn deinit(self: *Self) void {
        bun.memory.deinit(&self.onOpen);
        bun.memory.deinit(&self.onClose);
        bun.memory.deinit(&self.onError);
        bun.memory.deinit(&self.onData);
        bun.memory.deinit(&self.onWritable);
        bun.memory.deinit(&self.onHandshake);
        bun.memory.deinit(&self.onEnd);
        bun.memory.deinit(&self.onConnectError);
        bun.memory.deinit(&self.onTimeout);
        bun.memory.deinit(&self.binary_type);
        self[0] = undefined;
    }
    pub fn fromJS(globalThis: *jsc.JSGlobalObject, value: jsc.JSValue) bun.JSError!Self {
        var scope: jsc.ExceptionValidationScope = std.mem.zeroes(jsc.ExceptionValidationScope);
        scope.init(globalThis, @src());
        defer scope.deinit();
        var extern_result: ExternSocketConfigHandlers = undefined;
        const success = bindgenConvertJSToSocketConfigHandlers(globalThis, value, &extern_result);
        scope.assertExceptionPresenceMatches(!success);
        return if (success)
            BindgenSocketConfigHandlers.convertFromExtern(extern_result)
        else
            error.JSError;
    }
};

pub const BindgenSocketConfigHandlers = struct {
    const Self = @This();
    pub const ZigType = SocketConfigHandlers;
    pub const ExternType = ExternSocketConfigHandlers;
    pub fn convertFromExtern(extern_value: Self.ExternType) Self.ZigType {
        return .{
            .onOpen = bindgen.BindgenRawAny.convertFromExtern(extern_value.onOpen),
            .onClose = bindgen.BindgenRawAny.convertFromExtern(extern_value.onClose),
            .onError = bindgen.BindgenRawAny.convertFromExtern(extern_value.onError),
            .onData = bindgen.BindgenRawAny.convertFromExtern(extern_value.onData),
            .onWritable = bindgen.BindgenRawAny.convertFromExtern(extern_value.onWritable),
            .onHandshake = bindgen.BindgenRawAny.convertFromExtern(extern_value.onHandshake),
            .onEnd = bindgen.BindgenRawAny.convertFromExtern(extern_value.onEnd),
            .onConnectError = bindgen.BindgenRawAny.convertFromExtern(extern_value.onConnectError),
            .onTimeout = bindgen.BindgenRawAny.convertFromExtern(extern_value.onTimeout),
            .binary_type = bindgen_generated.internal.SocketConfigBinaryType.convertFromExtern(extern_value.binary_type),
        };
    }
};

const ExternSocketConfigHandlers = extern struct {
    onOpen: bindgen.BindgenRawAny.ExternType,
    onClose: bindgen.BindgenRawAny.ExternType,
    onError: bindgen.BindgenRawAny.ExternType,
    onData: bindgen.BindgenRawAny.ExternType,
    onWritable: bindgen.BindgenRawAny.ExternType,
    onHandshake: bindgen.BindgenRawAny.ExternType,
    onEnd: bindgen.BindgenRawAny.ExternType,
    onConnectError: bindgen.BindgenRawAny.ExternType,
    onTimeout: bindgen.BindgenRawAny.ExternType,
    binary_type: bindgen_generated.internal.SocketConfigBinaryType.ExternType,
};

extern fn bindgenConvertJSToSocketConfigHandlers(
    globalObject: *jsc.JSGlobalObject,
    value: jsc.JSValue,
    result: *ExternSocketConfigHandlers,
) bool;

const bindgen_generated = @import("bindgen_generated");
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
const jsc = bun.bun_js.jsc;
