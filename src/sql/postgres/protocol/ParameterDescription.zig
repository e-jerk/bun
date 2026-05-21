const ParameterDescription = @This();

parameters: []int4 = &[_]int4{},

pub fn decodeInternal(this: *@This(), comptime Container: type, reader: NewReader(Container)) !void {
    var remaining_bytes = try reader.length();
    remaining_bytes -|= 4;

    const count = try reader.short();
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    const parameters = try bun.default_allocator.alloc(int4, @intCast(@max(count, 0)));

// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    var data = try reader.read(@as(usize, @intCast(@max(count, 0))) * @sizeOf((int4)));
    defer data.deinit();
    const input_params: []align(1) const int4 = toInt32Slice(int4, data.slice());
    // safe-transpile: for with index access requires manual review
    // safe-transpile: for with index access requires manual review
    for (input_params, parameters) |src, *dest| {
        dest.* = @byteSwap(src);
    }

    this.* = .{
        .parameters = parameters,
    };
}

pub const decode = DecoderWrap(ParameterDescription, decodeInternal).decode;

// workaround for zig compiler TODO
// safe-transpile: function uses raw slice parameter — consider safe.String
// safe-transpile: function uses raw slice parameter — consider safe.String
fn toInt32Slice(comptime Int: type, slice: []const u8) []align(1) const Int {
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
// safe-transpile: @ptrCast requires manual review — add @alignCast if alignment is guaranteed
    return @as([*]align(1) const Int, @ptrCast(slice.ptr))[0 .. slice.len / @sizeOf((Int))];
}

const bun = @import("bun");
const DecoderWrap = @import("./DecoderWrap.zig").DecoderWrap;
const NewReader = @import("./NewReader.zig").NewReader;

const types = @import("../PostgresTypes.zig");
const int4 = types.int4;

const safe = @import("safe");
