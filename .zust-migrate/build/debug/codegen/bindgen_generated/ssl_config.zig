pub const SSLConfig = struct {
    const Self = @This();

    passphrase: bun.string.WTFString.Optional,
    dh_params_file: bun.string.WTFString.Optional,
    server_name: bun.string.WTFString.Optional,
    low_memory_mode: bool,
    reject_unauthorized: ?bool,
    request_cert: bool,
    ca: bindgen_generated.SSLConfigFile,
    cert: bindgen_generated.SSLConfigFile,
    key: bindgen_generated.SSLConfigFile,
    secure_options: u32,
    key_file: bun.string.WTFString.Optional,
    cert_file: bun.string.WTFString.Optional,
    ca_file: bun.string.WTFString.Optional,
    alpn_protocols: bindgen_generated.ALPNProtocols,
    ciphers: bun.string.WTFString.Optional,
    client_renegotiation_limit: u32,
    client_renegotiation_window: u32,

    pub fn deinit(self: *Self) void {
        bun.memory.deinit(&self.passphrase);
        bun.memory.deinit(&self.dh_params_file);
        bun.memory.deinit(&self.server_name);
        bun.memory.deinit(&self.low_memory_mode);
        bun.memory.deinit(&self.reject_unauthorized);
        bun.memory.deinit(&self.request_cert);
        bun.memory.deinit(&self.ca);
        bun.memory.deinit(&self.cert);
        bun.memory.deinit(&self.key);
        bun.memory.deinit(&self.secure_options);
        bun.memory.deinit(&self.key_file);
        bun.memory.deinit(&self.cert_file);
        bun.memory.deinit(&self.ca_file);
        bun.memory.deinit(&self.alpn_protocols);
        bun.memory.deinit(&self.ciphers);
        bun.memory.deinit(&self.client_renegotiation_limit);
        bun.memory.deinit(&self.client_renegotiation_window);
        self[0] = undefined;
    }
    pub fn fromJS(globalThis: *jsc.JSGlobalObject, value: jsc.JSValue) bun.JSError!Self {
        var scope: jsc.ExceptionValidationScope = std.mem.zeroes(jsc.ExceptionValidationScope);
        scope.init(globalThis, @src());
        defer scope.deinit();
        var extern_result: ExternSSLConfig = undefined;
        const success = bindgenConvertJSToSSLConfig(globalThis, value, &extern_result);
        scope.assertExceptionPresenceMatches(!success);
        return if (success)
            BindgenSSLConfig.convertFromExtern(extern_result)
        else
            error.JSError;
    }
};

pub const BindgenSSLConfig = struct {
    const Self = @This();
    pub const ZigType = SSLConfig;
    pub const ExternType = ExternSSLConfig;
    pub fn convertFromExtern(extern_value: Self.ExternType) Self.ZigType {
        return .{
            .passphrase = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.passphrase),
            .dh_params_file = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.dh_params_file),
            .server_name = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.server_name),
            .low_memory_mode = bindgen.BindgenBool.convertFromExtern(extern_value.low_memory_mode),
            .reject_unauthorized = bindgen.BindgenOptional(bindgen.BindgenBool).convertFromExtern(extern_value.reject_unauthorized),
            .request_cert = bindgen.BindgenBool.convertFromExtern(extern_value.request_cert),
            .ca = bindgen_generated.internal.SSLConfigFile.convertFromExtern(extern_value.ca),
            .cert = bindgen_generated.internal.SSLConfigFile.convertFromExtern(extern_value.cert),
            .key = bindgen_generated.internal.SSLConfigFile.convertFromExtern(extern_value.key),
            .secure_options = bindgen.BindgenU32.convertFromExtern(extern_value.secure_options),
            .key_file = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.key_file),
            .cert_file = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.cert_file),
            .ca_file = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.ca_file),
            .alpn_protocols = bindgen_generated.internal.ALPNProtocols.convertFromExtern(extern_value.alpn_protocols),
            .ciphers = bindgen.BindgenOptional(bindgen.BindgenString).convertFromExtern(extern_value.ciphers),
            .client_renegotiation_limit = bindgen.BindgenU32.convertFromExtern(extern_value.client_renegotiation_limit),
            .client_renegotiation_window = bindgen.BindgenU32.convertFromExtern(extern_value.client_renegotiation_window),
        };
    }
};

const ExternSSLConfig = extern struct {
    passphrase: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    dh_params_file: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    server_name: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    low_memory_mode: bindgen.BindgenBool.ExternType,
    reject_unauthorized: bindgen.BindgenOptional(bindgen.BindgenBool).ExternType,
    request_cert: bindgen.BindgenBool.ExternType,
    ca: bindgen_generated.internal.SSLConfigFile.ExternType,
    cert: bindgen_generated.internal.SSLConfigFile.ExternType,
    key: bindgen_generated.internal.SSLConfigFile.ExternType,
    secure_options: bindgen.BindgenU32.ExternType,
    key_file: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    cert_file: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    ca_file: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    alpn_protocols: bindgen_generated.internal.ALPNProtocols.ExternType,
    ciphers: bindgen.BindgenOptional(bindgen.BindgenString).ExternType,
    client_renegotiation_limit: bindgen.BindgenU32.ExternType,
    client_renegotiation_window: bindgen.BindgenU32.ExternType,
};

extern fn bindgenConvertJSToSSLConfig(
    globalObject: *jsc.JSGlobalObject,
    value: jsc.JSValue,
    result: *ExternSSLConfig,
) bool;

const bindgen_generated = @import("bindgen_generated");
const bun = @import("bun");
const bindgen = bun.bun_js.bindgen;
const jsc = bun.bun_js.jsc;
