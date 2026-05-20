var file: @import("std-fs-compat").File = std.mem.zeroes(@import("std-fs-compat").File);
pub var enabled = false;
pub var check_done = false;

pub fn load() void {
    if (bun.env_var.BUN_POSTGRES_SOCKET_MONITOR_READER.get()) |monitor| {
        enabled = true;
        const fd = switch (bun.sys.openA(monitor, bun.O.CREAT | bun.O.TRUNC | bun.O.WRONLY, 0o666)) {
            .result => |fd| fd,
            .err => {
                enabled = false;
                return;
            },
        };
        file = .{ .handle = fd.native() };
        debug("duplicating reads to {s}", .{monitor});
    }
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn write(data: []const u8) void {
    file.writeAll(data) catch {};
}

const debug = bun.Output.scoped(.Postgres, .visible);

const bun = @import("bun");
const std = @import("std");

const safe = @import("safe");
