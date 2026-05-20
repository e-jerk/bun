pub const SocketConfig = struct {
    const Self = @This();

    handlers: bindgen_generated.SocketConfigHandlers,
    data: bun.bun_js.jsc.JSValue,
    allow_half_open: bool,
    hostname: bun.string.WTFString.Optional,
    port: ?u16,
    tls: bindgen_generated.SocketConfigTLS,
    exclusive: bool,
    reuse_port: bool,
    ipv6_only: bool,
    unix_: bun.string.WTFString.Optional,
    fd: ?i32,

    pub fn deinit(self: *Self) void {
        bun.memory.deinit(&self.handlers);
        bun.memory.deinit(&self.data);
        bun.memory.deinit(&self.allow_half_open);
        bun.memory.deinit(&self.hostname);
        bun.memory.deinit(&self.port);
        bun.memory.deinit(&self.tls);
        bun.memory.deinit(&self.exclusive);
        bun.memory.deinit(&self.reuse_port);
        bun.memory.deinit(&self.ipv6_only);
        bun.memory.deinit(&self.unix_);
        bun.memory.deinit(&self.fd);
        self[0] = undefined;
    }
    pub fn fromJS(globalThis: *jsc.JSGlobalObject, value: jsc.JSValue) bun.JSError!Self {
        var scope: jsc.ExceptionValidationScope = std.mem.zeroes(jsc.ExceptionValidationScope);
        scope.init(globalThis, @src());
        defer scope.deinit();
        var extern_result: ExternSocketConfig = undefined;
        const success = bindgenConvertJSToSocketConfig(globalThis, value, &extern_result);
        scope.assertExceptionPresenceMatches(!success);
        return if (success)
            BindgenSocketConfig.convertFromExtern(extern_result)
        else
            error.JSError;
    }
};

pub const BindgenSocketConfig = struct {
    const Self = @This();
    pub const ZigType = SocketConfig;
    pub const ExternType = ExternSocketConfig;
    pub fn convertFromExtern(extern_value: Self.ExternType) Self.ZigType {
        return .{
            .handlers = bindgen_generated.internal.SocketConfigHandlers.convertFromExtern(extern_value.handlers),
            .data = bindgen.BindgenRawAny.convertFromExtern(extern_value.data),
            .allow_half_open = bindgen.BindgenBool.convertFromExtern(extern_value.allow_half_open),
            .hostname = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.hostname),
            .port = bindgen.BindgenOptional(bindgen.BindgenU16).convertFromExtern(extern_value.port),
            .tls = bindgen_generated.internal.SocketConfigTLS.convertFromExtern(extern_value.tls),
            .exclusive = bindgen.BindgenBool.convertFromExtern(extern_value.exclusive),
            .reuse_port = bindgen.BindgenBool.convertFromExtern(extern_value.reuse_port),
            .ipv6_only = bindgen.BindgenBool.convertFromExtern(extern_value.ipv6_only),
            .unix_ = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.unix_),
            .fd = bindgen.BindgenOptional(bindgen.BindgenI32).convertFromExtern(extern_value.fd),
        };
    }
};

const ExternSocketConfig = extern struct {
    handlers: bindgen_generated.internal.SocketConfigHandlers.ExternType,
    data: bindgen.BindgenRawAny.ExternType,
    allow_half_open: bindgen.BindgenBool.ExternType,
    hostname: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    port: bindgen.BindgenOptional(bindgen.BindgenU16).ExternType,
    tls: bindgen_generated.internal.SocketConfigTLS.ExternType,
    exclusive: bindgen.BindgenBool.ExternType,
    reuse_port: bindgen.BindgenBool.ExternType,
    ipv6_only: bindgen.BindgenBool.ExternType,
    unix_: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    fd: bindgen.BindgenOptional(bindgen.BindgenI32).ExternType,
};

extern fn bindgenConvertJSToSocketConfig(
    globalObject: *jsc.JSGlobalObject,
    value: jsc.JSValue,
    result: *ExternSocketConfig,
) bool;

const bindgen_generated = @import("bindgen_generated");
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
const jsc = bun.bun_js.jsc;
