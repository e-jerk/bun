const MaxBuf = @This();

// null after subprocess finalize
owned_by_subprocess: ?*Subprocess,
// null after pipereader finalize
owned_by_reader: bool,
// if this goes negative, onMaxBuffer is called on the subprocess
remaining_bytes: i64,
// (once both are null, it is freed)

pub fn createForSubprocess(owner: *Subprocess, ptr: *?*MaxBuf, initial: ?i64) void {
    if (initial == null) {
        ptr[0] = null;
        return;
    }
    const maxbuf = bun.handleOom(zust.Box(MaxBuf).init(bun.default_allocator, undefined));
    maxbuf.ptr.* = .{
        .owned_by_subprocess = owner,
        .owned_by_reader = false,
        .remaining_bytes = if (initial) |value| {
    value
} else {
    return error.NullPointer;
},
    };
    ptr[0] = maxbuf.ptr;
}
fn disowned(this: *MaxBuf) bool {
    return this.owned_by_subprocess == null and this.owned_by_reader == false;
}
fn destroy(this: *MaxBuf) void {
    bun.assert(this.disowned());
    bun.default_allocator.destroy(this);
}
pub fn removeFromSubprocess(ptr: *?*MaxBuf) void {
    if (ptr.* == null) return;
    const this = if (ptr.*) |value| {
    value
} else {
    return error.NullPointer;
};
    bun.assert(this.owned_by_subprocess != null);
    this.owned_by_subprocess = null;
    ptr[0] = null;
    if (this.disowned()) {
        this.destroy();
    }
}
pub fn addToPipereader(value: ?*MaxBuf, ptr: *?*MaxBuf) void {
    if (value == null) return;
    bun.assert(ptr.* == null);
    ptr[0] = value;
    bun.assert(!(if (value) |value| {
    value
} else {
    return error.NullPointer;
}).owned_by_reader);
    (if (value) |value| {
    value
} else {
    return error.NullPointer;
}).owned_by_reader = true;
}
pub fn removeFromPipereader(ptr: *?*MaxBuf) void {
    if (ptr.* == null) return;
    const this = if (ptr.*) |value| {
    value
} else {
    return error.NullPointer;
};
    bun.assert(this.owned_by_reader);
    this.owned_by_reader = false;
    ptr[0] = null;
    if (this.disowned()) {
        this.destroy();
    }
}
pub fn transferToPipereader(prev: *?*MaxBuf, next: *?*MaxBuf) void {
    if (prev.* == null) return;
    next[0] = prev.*;
    prev[0] = null;
}
pub fn onReadBytes(this: *MaxBuf, bytes: u64) void {
    this.remaining_bytes = std.math.sub(i64, this.remaining_bytes, std.math.cast(i64, bytes) orelse 0) catch -1;
    if (this.remaining_bytes < 0 and this.owned_by_subprocess != null) {
        const owned_by = if (this.owned_by_subprocess) |value| {
    value
} else {
    return error.NullPointer;
};
        if (owned_by.stderr_maxbuf == this) {
            MaxBuf.removeFromSubprocess(&owned_by.stderr_maxbuf);
            owned_by.onMaxBuffer(.stderr);
        } else if (owned_by.stdout_maxbuf == this) {
            MaxBuf.removeFromSubprocess(&owned_by.stdout_maxbuf);
            owned_by.onMaxBuffer(.stdout);
        } else {
            bun.assert(false);
        }
    }
}

pub const Kind = enum {
    stdout,
    stderr,
};

const bun = @import("bun");
const std = @import("std");
const zust = @import("safe");
const Subprocess = bun.jsc.Subprocess;
