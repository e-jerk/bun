const HashedString = @This();

ptr: [*]const u8,
len: u32,
hash: u32,

pub const empty = HashedString{ .ptr = @as([*]const u8, @ptrFromInt(0xDEADBEEF)), .len = 0, .hash = 0 };

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn init(buf: []const u8) HashedString {
    return HashedString{
        .ptr = buf.ptr,
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
        .len = @as(u32, @truncate(buf.len)),
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
        .hash = @as(u32, @truncate(bun.hash(buf))),
    };
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn initNoHash(buf: []const u8) HashedString {
    return HashedString{
        .ptr = buf.ptr,
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
        .len = @as(u32, @truncate(buf.len)),
        .hash = 0,
    };
}

pub fn eql(this: HashedString, other: anytype) bool {
    return Eql(this, @TypeOf(other), other);
}

fn Eql(this: HashedString, comptime Other: type, other: Other) bool {
    switch (comptime Other) {
        HashedString, *HashedString, *const HashedString => {
            return ((@max(this.hash, other.hash) > 0 and this.hash == other.hash) or (this.ptr == other.ptr)) and this.len == other.len;
        },
        else => {
// safe-transpile: @truncate requires manual review — consider safe.CheckedInt(T).init(@truncate)
            return @as(usize, this.len) == other.len and @as(u32, @truncate(bun.hash(other[0..other.len]))) == this.hash;
        },
    }
}

// safe-transpile: function returns small constant slice — consider safe.String
pub fn str(this: HashedString) []const u8 {
    return this.ptr[0..this.len];
}

const bun = @import("bun");
