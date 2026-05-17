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
    try callback(if (ctx) |__zust_v| __zust_v else return error.Null);
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
            return @call(bun.callmod_inline, Callback, .{@as(*Type, @ptrCast(@alignCast(if (this.*) |__zust_v| __zust_v else return error.Null)))});
        }
    };
}

const bun = @import("bun");
const safe = @import("safe");

const jsc = bun.jsc;
const Task = jsc.Task;
