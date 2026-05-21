const BackendKeyData = @This();

process_id: u32 = 0,
secret_key: u32 = 0,
pub const decode = DecoderWrap(BackendKeyData, decodeInternal).decode;

pub fn decodeInternal(this: *@This(), comptime Container: type, reader: NewReader(Container)) !void {
    if (!try reader.expectInt(u32, 12)) {
        return error.InvalidBackendKeyData;
    }

    this.* = .{
// safe-transpile: @bitCast requires manual review
// safe-transpile: @bitCast requires manual review
        .process_id = @bitCast(try reader.int4()),
// safe-transpile: @bitCast requires manual review
// safe-transpile: @bitCast requires manual review
        .secret_key = @bitCast(try reader.int4()),
    };
}

const DecoderWrap = @import("./DecoderWrap.zig").DecoderWrap;

const NewReader = @import("./NewReader.zig").NewReader;

const safe = @import("safe");
