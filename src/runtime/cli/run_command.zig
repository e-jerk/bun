pub const RunCommand = struct {
    pub fn exec(ctx: anytype, argv: anytype) !void {
        _ = ctx;
        _ = argv;
        return error.Unimplemented;
    }

    pub fn createFakeTemporaryNodeExecutable(PATH: anytype, bun_path: *[]const u8) !void {
        _ = PATH;
        _ = bun_path;
        return error.Unimplemented;
    }

    pub fn configureEnvForRun(ctx: anytype, transpiler: anytype, env: anytype, _: bool, _: bool) (error{OutOfMemory} || error{Unimplemented})!void {
        _ = ctx;
        _ = transpiler;
        _ = env;
        return error.Unimplemented;
    }

    pub fn runPackageScriptForeground(ctx: anytype, allocator: anytype, script: anytype, name: anytype, cwd: anytype, env: anytype, _: anytype, _: anytype, _: anytype) (error{ MissingShell, OutOfMemory } || error{Unimplemented})!void {
        _ = ctx;
        _ = allocator;
        _ = script;
        _ = name;
        _ = cwd;
        _ = env;
        return error.Unimplemented;
    }
};

const safe = @import("safe");
