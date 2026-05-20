const bun = @import("bun");
const std = @import("std");

// Re-export from src/bake/bake.zig
pub const production = @import("../../bake/production.zig");
pub const DevServer = @import("../../bake/DevServer.zig");
pub const FrameworkRouter = @import("../../bake/FrameworkRouter.zig");
pub const api_name = "app";

pub fn printWarning() void {
    bun.Output.warn("Bake is not fully implemented in this build", .{});
}

pub fn addImportMetaDefines(allocator: std.mem.Allocator, define: anytype, mode: anytype, side: anytype) !void {
    _ = allocator; _ = define; _ = mode; _ = side;
}

pub const UserOptions = struct {
    arena: std.heap.ArenaAllocator,
    allocations: StringRefList = .{},
    root: [:0]const u8 = "",
    framework: Framework = .{},
    bundler_options: bun.bake.SplitBundlerOptions = .{},

    pub fn deinit(this: *UserOptions) void {
        this.arena.deinit();
    }

    pub fn fromJS(config: bun.JSC.JSValue, global: *bun.JSC.JSGlobalObject) bun.JSError!UserOptions {
        _ = config;
        return global.throw("Bake UserOptions.fromJS is not implemented in runtime stub", .{});
    }
};

pub const Side = enum { client, server,

    pub fn graph(self: Side) Graph {
        return switch (self) {
            .client => .client,
            .server => .server,
        };
    }
};

pub const BuiltInModule = union(enum) {
    import: []const u8,
    code: []const u8,
};

pub const ServerComponents = struct {
    separate_ssr_graph: bool = false,
    server_runtime_import: []const u8 = "",
    server_register_client_reference: []const u8 = "registerClientReference",
    server_register_server_reference: []const u8 = "registerServerReference",
    client_register_server_reference: []const u8 = "registerServerReference",
};

pub const SplitBundlerOptions = struct {
    // Stub for missing bake SplitBundlerOptions type
    plugin: ?*anyopaque = null,
    client: BuildConfigSubset = .{},
    server: BuildConfigSubset = .{},
    ssr: BuildConfigSubset = .{},
    pub const empty: SplitBundlerOptions = .{};
};

pub const PatternBuffer = struct {
    pub var empty: PatternBuffer = .{};
    pub fn prependPart(_: *PatternBuffer, _: anytype) void {}
    pub fn slice(_: PatternBuffer) []const u8 {
        return "";
    }
};

pub const Graph = enum {
    client,
    server,
    ssr,

    pub fn side(self: Graph) Side {
        return switch (self) {
            .client => .client,
            .server => .server,
            .ssr => .server,
        };
    }
};

pub const HmrRuntime = @import("../../bake/bake.zig").HmrRuntime;

pub fn getHmrRuntime(graph: Graph) HmrRuntime {
    return @import("../../bake/bake.zig").getHmrRuntime(@enumFromInt(@intFromEnum(graph.side())));
}

pub const server_virtual_source: bun.logger.Source = .{
    .path = bun.fs.Path.init("bun:virtual/server"),
    .contents = "",
    .index = .{ .value = std.math.maxInt(u32) },
};

pub const client_virtual_source: bun.logger.Source = .{
    .path = bun.fs.Path.init("bun:virtual/client"),
    .contents = "",
    .index = .{ .value = std.math.maxInt(u32) },
};

pub const StringRefList = struct {
    // Stub for StringRefList
    pub const empty: StringRefList = .{};

    pub fn append(_: *StringRefList, _: []const u8) void {}
    pub fn track(_: *StringRefList, str: []const u8) []const u8 {
        return str;
    }
};

pub const BuildConfigSubset = struct {
    env: bun.schema.api.DotEnvBehavior = ._none,
    env_prefix: ?[]const u8 = null,
    define: bun.schema.api.StringMap = .{ .keys = &.{}, .values = &.{} },
    source_map: bun.schema.api.SourceMapMode = .none,
    minify_whitespace: bool = false,
    minify_syntax: bool = false,
    minify_identifiers: bool = false,
    entry_points: []const []const u8 = &.{},
    outdir: ?[]const u8 = null,
    public_path: ?[]const u8 = null,
    // naming: bun.schema.api.NamingConvention = .{ .chunk = null, .entry = null, .asset = null },
    external: []const []const u8 = &.{},
    target: bun.schema.api.Target = .browser,
    // format: bun.schema.api.Format = .esm,
    splitting: bool = false,
    banner: ?[]const u8 = null,
    footer: ?[]const u8 = null,
    root_dir: ?[]const u8 = null,
    jsx: bun.schema.api.Jsx = .{ .factory = "React.createElement", .runtime = .automatic, .fragment = "React.Fragment", .import_source = "react" },
    tsconfig_override: ?[]const u8 = null,
    main_fields: []const []const u8 = &.{"module", "main"},
    conditions: []const []const u8 = &.{},
    drop: []const []const u8 = &.{},
    no_summary: bool = false,
    emit_dce_annotations: bool = true,
    code_splitting: bool = false,
    css_chunking: bool = false,
    react_fast_refresh: bool = false,
    server_react_register_server_reference: ?[]const u8 = null,
    bytecode: bool = false,
};

pub const Framework = struct {
    pub const FileSystemRouterType = struct {
        root: []const u8,
        prefix: []const u8,
        entry_server: []const u8,
        entry_client: ?[]const u8,
        ignore_underscores: bool,
        ignore_dirs: []const []const u8,
        extensions: []const []const u8,
        style: FrameworkRouter.Style,
        allow_layouts: bool,
    };

    pub fn auto(allocator: std.mem.Allocator, resolver: anytype, router_list: anytype) !Framework {
        _ = allocator; _ = resolver; _ = router_list;
        return .{};
    }

    pub fn initTranspiler(_: Framework, allocator: std.mem.Allocator, log: anytype, mode: anytype, side: anytype, transpiler: anytype, options: anytype) !void {
        _ = allocator; _ = log; _ = mode; _ = side; _ = transpiler; _ = options;
    }

    pub fn initTranspilerWithOptions(_: Framework, allocator: std.mem.Allocator, log: anytype, mode: anytype, side: anytype, transpiler: anytype, options: anytype, source_map: anytype, minify_whitespace: anytype, minify_syntax: anytype, minify_identifiers: anytype) !void {
        _ = allocator; _ = log; _ = mode; _ = side; _ = transpiler; _ = options; _ = source_map; _ = minify_whitespace; _ = minify_syntax; _ = minify_identifiers;
    }

    pub fn resolve(self: Framework, server_resolver: anytype, client_resolver: anytype, arena: anytype) !Framework {
        _ = server_resolver; _ = client_resolver; _ = arena;
        return self;
    }

    pub fn isBuiltInReact(_: Framework) bool {
        return false;
    }

    is_built_in_react: bool = false,
    file_system_router_types: []FileSystemRouterType = &.{},
    server_components: ?ServerComponents = null,
    react_fast_refresh: ?struct { import_source: []const u8 = "react-refresh/runtime" } = null,
    built_in_modules: bun.StringArrayHashMapUnmanaged(BuiltInModule) = .{},
};
