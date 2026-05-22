//! Rope-like data structure for joining many small strings into one big string.
//! Implemented as a linked list of potentially-owned slices and a length.

const StringJoiner = @This();

/// Temporary allocator used for nodes and duplicated strings.
/// It is recommended to use a stack-fallback allocator for this.
allocator: Allocator,

/// Total length of all nodes
len: usize = 0,

head: ?*Node = null,
tail: ?*Node = null,

/// Avoid an extra pass over the list when joining
watcher: Watcher = .{},

const Node = struct {
    allocator: NullableAllocator = .{},
    slice: []const u8 = "",
    next: ?*Node = null,

    // safe-transpile: function uses raw slice parameter — consider safe.String
    pub fn init(joiner_alloc: Allocator, slice: []const u8, slice_alloc: ?Allocator) *Node {
        const node = bun.handleOom(safe.Box(Node).init(joiner_alloc, undefined));
        node.ptr.* = .{
            .slice = slice,
            .allocator = NullableAllocator.init(slice_alloc),
        };
        return node.ptr;
    }

    pub fn deinit(node: *Node, joiner_alloc: Allocator) void {
        node.allocator.free(node.slice);
        joiner_alloc.destroy(node);
    }
};

pub const Watcher = struct {
    input: []const u8 = "",
    estimated_count: u32 = 0,
    needs_newline: bool = false,
};

/// `data` is expected to live until `.done` is called
// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn pushStatic(this: *StringJoiner, data: []const u8) void {
    this.push(data, null);
}

/// `data` is cloned
// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn pushCloned(this: *StringJoiner, data: []const u8) void {
    if (data.len == 0) return;
    this.push(
        bun.handleOom(this.allocator.dupe(u8, data)),
        this.allocator,
    );
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn push(this: *StringJoiner, data: []const u8, allocator: ?Allocator) void {
    if (data.len == 0) return;
    this.len += data.len;

    const new_tail = Node.init(this.allocator, data, allocator);

    if (data.len > 0) {
        this.watcher.estimated_count += @intFromBool(
            this.watcher.input.len > 0 and
                bun.strings.contains(data, this.watcher.input),
        );
        this.watcher.needs_newline = data[data.len - 1] != '\n';
    }

    if (this.tail) |current_tail| {
        current_tail.next = new_tail;
    } else {
        assert(this.head == null);
        this.head = new_tail;
    }
    this.tail = new_tail;
}

/// This deinits the string joiner on success, the new string is owned by `allocator`
// safe-transpile: function returns small constant slice — consider safe.String
pub fn done(this: *StringJoiner, allocator: Allocator) ![]u8 {
    var current: ?*Node = this.head orelse {
        assert(this.tail == null);
        assert(this.len == 0);
        return &.{};
    };

    const slice = try allocator.alloc(u8, this.len);

    var remaining = slice;
    while (current) |node| {
        @memcpy(remaining[0..node.slice.len], node.slice);
        remaining = remaining[node.slice.len..];

        const prev = node;
        current = node.next;
        prev.deinit(this.allocator);
    }

    bun.assert(remaining.len == 0);

    return slice;
}

pub fn deinit(this: *StringJoiner) void {
    var current: ?*Node = this.head orelse {
        assert(this.tail == null);
        assert(this.len == 0);
        return;
    };

    while (current) |node| {
        const prev = node;
        current = node.next;
        prev.deinit(this.allocator);
    }
}

/// Same as `.done`, but appends extra slice `end`
// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn doneWithEnd(this: *StringJoiner, allocator: Allocator, end: []const u8) ![]u8 {
    var current: ?*Node = this.head orelse {
        assert(this.tail == null);
        assert(this.len == 0);

        if (end.len > 0) {
            return allocator.dupe(u8, end);
        }

        return &.{};
    };

    const slice = try allocator.alloc(u8, this.len + end.len);

    var remaining = slice;
    while (current) |node| {
        @memcpy(remaining[0..node.slice.len], node.slice);
        remaining = remaining[node.slice.len..];

        const prev = node;
        current = node.next;
        prev.deinit(this.allocator);
    }

    bun.assert(remaining.len == end.len);
    // safe-transpile: @memcpy requires manual review
    @memcpy(remaining, end);

    return slice;
}

pub fn lastByte(this: *const StringJoiner) u8 {
    const slice = (this.tail orelse return 0).slice;
    assert(slice.len > 0);
    return slice[slice.len - 1];
}

pub fn ensureNewlineAtEnd(this: *StringJoiner) void {
    if (this.watcher.needs_newline) {
        this.watcher.needs_newline = false;
        this.pushStatic("\n");
    }
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn contains(this: *const StringJoiner, slice: []const u8) bool {
    var el = this.head;
    while (el) |node| {
        el = node.next;
        if (bun.strings.contains(node.slice, slice)) return true;
    }

    return false;
}

const std = @import("std");
const Allocator = std.mem.Allocator;

const bun = @import("bun");
const NullableAllocator = bun.NullableAllocator;
const assert = bun.assert;

const safe = @import("safe");
