pub const int4 = u32;
pub const PostgresInt32 = int4;
pub const int8 = i64;
pub const PostgresInt64 = int8;
pub const short = u16;
pub const PostgresShort = u16;

pub fn Int32(value: anytype) [4]u8 {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    return // safe-transpile: @bitCast requires manual review
    @bitCast(@byteSwap(@as(int4, @intCast(value))));
}
