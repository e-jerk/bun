const PacketHeader = @This();
length: u24,
sequence_id: u8,

pub const size = 4;

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn decode(bytes: []const u8) ?PacketHeader {
    if (bytes.len < 4) return null;

    return PacketHeader{
        .length = @as(u24, bytes[0]) |
            (@as(u24, bytes[1]) << 8) |
            (@as(u24, bytes[2]) << 16),
        .sequence_id = bytes[3],
    };
}

pub fn encode(self: PacketHeader) [4]u8 {
    return [4]u8{
        // safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        @intCast(self.length & 0xff),
        // safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        @intCast((self.length >> 8) & 0xff),
        // safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        @intCast((self.length >> 16) & 0xff),
        self.sequence_id,
    };
}

const safe = @import("safe");
