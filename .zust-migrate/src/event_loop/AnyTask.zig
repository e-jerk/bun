//! This is a slower wrapper around a function pointer.
//! Prefer adding a task type directly to `Task` instead of using this.

const AnyTask = @This();

ctx: ?*anyopaque,
callback: *const (fn (*anyopaque) bun.JSError!void),

pub fn task(this: *AnyTask) Task {
    return Task.init(this);
}

pub fn run(this: *AnyTask) bun.JSError!void {
    @setRuntimeSafety(false);
    const callback = this.callback;
    const ctx = this.ctx;
    try callback(if (ctx) |value| {
    value
} else {
    return error.NullPointer;
});
}

pub fn New(comptime Type: type, comptime Callback: anytype) type {
    return struct {
        pub fn init(ctx: *Type) AnyTask {
            return AnyTask{
                .callback = wrap,
                .ctx = ctx,
            };
        }

        pub fn wrap(this: ?*anyopaque) bun.JSError!void {
            return @call(bun.callmod_inline, Callback, .{@as(*Type, // safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
    @ptrCast(@alignCast(this.?)))});
        }
    };
}

const bun = @import("bun");
const zust = @import("safe");

const jsc = bun.jsc;
const Task = jsc.Task;
