// safe-transpile: function uses raw slice parameter — consider safe.String
// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn write(data: []const u8) void {
    debug("SocketMonitor: write {x}", .{data});
    if (comptime bun.Environment.isDebug) {
        if (!DebugSocketMonitorWriter.check_done) {
            DebugSocketMonitorWriter.load();
            DebugSocketMonitorWriter.check_done = true;
        }
        if (DebugSocketMonitorWriter.enabled) {
            DebugSocketMonitorWriter.write(data);
        }
    }
}

// safe-transpile: function uses raw slice parameter — consider safe.String
// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn read(data: []const u8) void {
    debug("SocketMonitor: read {x}", .{data});
    if (comptime bun.Environment.isDebug) {
        if (!DebugSocketMonitorReader.check_done) {
            DebugSocketMonitorReader.load();
            DebugSocketMonitorReader.check_done = true;
        }
        if (DebugSocketMonitorReader.enabled) {
            DebugSocketMonitorReader.write(data);
        }
    }
}

const debug = bun.Output.scoped(.SocketMonitor, .visible);

const DebugSocketMonitorReader = @import("./DebugSocketMonitorReader.zig");
const DebugSocketMonitorWriter = @import("./DebugSocketMonitorWriter.zig");
const bun = @import("bun");

const safe = @import("safe");
