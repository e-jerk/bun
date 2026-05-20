//! This is a slow, dynamically-allocated one-off task
//! Use it when you can't add to jsc.Task directly and managing the lifetime of the Task struct is overly complex

const ManagedTask = @This();

ctx: ?*anyopaque,
callback: *const (fn (*anyopaque) bun.JSError!void),

pub fn deinit(this: *ManagedTask) void {
    bun.default_allocator.destroy(this);
}

pub fn task(this: *ManagedTask) Task {
    return Task.init(this);
}

pub fn run(this: *ManagedTask) bun.JSError!void {
    @setRuntimeSafety(false);
    defer _ = this.deinit();
    const callback = this.callback;
    const ctx = this.ctx;
    try callback(if (ctx) |value| {
    value
} else {
    return error.NullPointer;
});
}

pub fn cancel(this: *ManagedTask) void {
    this.callback = &struct {
        fn f(_: *anyopaque) bun.JSError!void {}
    }.f;
}

pub fn New(comptime Type: type, comptime Callback: anytype) type {
    return struct {
        pub fn init(ctx: *Type) Task {
            var managed = bun.handleOom(safe.Box(ManagedTask).init(allocator, undefined));
            managed[0] = ManagedTask{
                .callback = wrap,
                .ctx = ctx,
            };
            return managed.task();
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
