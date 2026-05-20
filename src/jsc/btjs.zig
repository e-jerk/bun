extern const jsc_llint_begin: u8;
extern const jsc_llint_end: u8;

/// allocated using bun.default_allocator. when called from lldb, it is never freed.
pub export fn dumpBtjsTrace() [*:0]const u8 {
    if (comptime bun.Environment.isDebug) {
        return dumpBtjsTraceDebugImpl();
    }

    return "btjs is disabled in release builds";
}

fn dumpBtjsTraceDebugImpl() [*:0]const u8 {
    // std.debug.cpu_context and std.Io.Writer are no longer available in Zig 0.16
    return "<btjs unavailable>".ptr;
}

const bun = @import("bun");
const std = @import("std");
