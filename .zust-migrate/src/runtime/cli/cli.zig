const std = @import("std");

// Re-export from src/cli/cli.zig
pub const Cli = @import("../../cli/cli.zig").Cli;
pub const Command = @import("../../cli/cli.zig").Command;
pub const debug_flags = @import("../../cli/cli.zig").debug_flags;
pub const Arguments = @import("../../cli/Arguments.zig");
pub const RunCommand = @import("../../cli/cli.zig").RunCommand;
pub const DefineColonList = @import("../../cli/cli.zig").DefineColonList;
pub const LoaderColonList = @import("../../cli/cli.zig").LoaderColonList;
pub const printVersionAndExit = @import("../../cli/cli.zig").printVersionAndExit;
pub const printRevisionAndExit = @import("../../cli/cli.zig").printRevisionAndExit;
pub const invalidTarget = @import("../../cli/cli.zig").invalidTarget;
pub var start_time: i128 = 0;
pub var pretend_to_be_node: bool = false;

pub const BuildCommand = struct {
    pub fn exec(cmd: anytype, fetcher: anytype) !void {
        _ = cmd;
        _ = fetcher;
        return error.Unimplemented;
    }
};

pub const ShellCompletions = struct {
    pub const Shell = enum {
        unknown,
        bash,
        zsh,
        fish,
        powershell,
        pwsh,

        pub fn fromEnv(comptime T: type, shell_path: T) Shell {
            _ = shell_path;
            return .unknown;
        }
    };
};

pub const PackCommand = struct {
    pub const Context = struct {
        allocator: std.mem.Allocator = undefined,
        manager: ?*anyopaque = null,
        command_ctx: ?*anyopaque = null,
        lockfile: ?*anyopaque = null,

        pub fn pack(_: anytype) !void {
            return error.Unimplemented;
        }

        pub fn printSummary(stats: anytype, maybe_shasum: anytype, maybe_integrity: anytype, log_level: anytype) void {
            _ = stats;
            _ = maybe_shasum;
            _ = maybe_integrity;
            _ = log_level;
        }
    };

    pub fn PackError(comptime for_publish: bool) type {
        _ = for_publish;
        return error{ Unimplemented, OutOfMemory, MissingPackageName, MissingPackageVersion, MissingPackageJSON, RestrictedUnscopedPackage, PrivatePackage, InvalidPackageName, InvalidPackageVersion };
    }

    pub const TarballNameFormatter = struct {
        pub const Style = enum { raw, escaped };
        name: []const u8,
        version: []const u8,
        style: Style,

        pub fn format(this: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
            try writer.print("{s}-{s}.tgz", .{ this.name, this.version });
        }
    };

// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn fmtTarballFilename(package_name: []const u8, package_version: []const u8, style: TarballNameFormatter.Style) TarballNameFormatter {
        return .{ .name = package_name, .version = package_version, .style = style };
    }

    pub fn pack(ctx: anytype, path: anytype, comptime for_publish: bool) PackError(for_publish)!if (for_publish) @import("../../cli/publish_command.zig").PublishCommand.Context(true) else void {
        _ = ctx;
        _ = path;
        if (for_publish) return undefined;
    }

    pub fn exec(ctx: anytype) !void {
        _ = ctx;
        return error.Unimplemented;
    }
};

pub const InitCommand = struct {
// safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn prompt(alloc: std.mem.Allocator, comptime label: []const u8, default: []const u8) ![:0]const u8 {
        _ = alloc;
        _ = default;
        return label ++ "";
    }
};
