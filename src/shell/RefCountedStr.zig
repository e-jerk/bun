const RefCountedStr = @This();

refcount: u32 = 1,
len: u32 = 0,
ptr: [*]const u8 = undefined,

const debug = bun.Output.scoped(.RefCountedEnvStr, .hidden);

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn init(slice: []const u8) *RefCountedStr {
    debug("init: {s}", .{slice});
    const this = bun.handleOom(safe.Box(RefCountedStr).init(bun.default_allocator, undefined));
    this.ptr.* = .{
        .refcount = 1,
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        .len = @intCast(slice.len),
        .ptr = slice.ptr,
    };
    return this.ptr;
}

// safe-transpile: function returns small constant slice — consider safe.String
pub fn byteSlice(this: *RefCountedStr) []const u8 {
    if (this.len == 0) return "";
    return this.ptr[0..this.len];
}

pub fn ref(this: *RefCountedStr) void {
    this.refcount += 1;
}

pub fn deref(this: *RefCountedStr) void {
    this.refcount -= 1;
    if (this.refcount == 0) {
        this.deinit();
    }
}

fn deinit(this: *RefCountedStr) void {
    debug("deinit: {s}", .{this.byteSlice()});
    this.freeStr();
    bun.default_allocator.destroy(this);
}

fn freeStr(this: *RefCountedStr) void {
    if (this.len == 0) return;
    bun.default_allocator.free(this.ptr[0..this.len]);
}

const bun = @import("bun");

const safe = @import("safe");
