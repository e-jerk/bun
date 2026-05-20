const RowDescription = @This();

fields: []FieldDescription = &[_]FieldDescription{},
pub fn deinit(this: *@This()) void {
    for (0..this.fields.len) |__zust_i| {
    var field = &this.fields[__zust_i];
        field.deinit();
    }

    // safe-transpile: free removed (memory owned by safe type);
}

pub fn decodeInternal(this: *@This(), comptime Container: type, reader: NewReader(Container)) !void {
    var remaining_bytes = try reader.length();
    remaining_bytes -|= 4;

// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    const field_count: usize = @intCast(@max(try reader.short(), 0));
    var fields = try bun.default_allocator.alloc(
        FieldDescription,
        field_count,
    );
    var remaining = fields;
    errdefer {
        for (0..fields[0 .. field_count - remaining.len].len) |__zust_i| {
    var field = &fields[0 .. field_count - remaining.len][__zust_i];
            field.deinit();
        }

        // safe-transpile: free removed (memory owned by safe type);
    }
    while (remaining.len > 0) {
        try remaining[0].decodeInternal(Container, reader);
        remaining = remaining[1..];
    }
    this[0] = .{
        .fields = fields,
    };
}

pub const decode = DecoderWrap(RowDescription, decodeInternal).decode;

const FieldDescription = @import("./FieldDescription.zig");
const bun = @import("bun");
const DecoderWrap = @import("./DecoderWrap.zig").DecoderWrap;
const NewReader = @import("./NewReader.zig").NewReader;
