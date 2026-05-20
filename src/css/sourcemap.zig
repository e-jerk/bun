pub const css = @import("./css_parser.zig");
pub const css_values = @import("./values/values.zig");
pub const Error = css.Error;

pub const SourceMap = struct {
    project_root: []const u8,
    inner: SourceMapInner,
};

pub const SourceMapInner = struct {
    sources: safe.ArrayList([]const u8),
    sources_content: safe.ArrayList([]const u8),
    names: safe.ArrayList([]const u8),
    mapping_lines: safe.ArrayList(MappingLine),
};

pub const MappingLine = struct { mappings: safe.ArrayList(LineMapping), last_column: u32, is_sorted: bool };

pub const LineMapping = struct { generated_column: u32, original: ?OriginalLocation };

pub const OriginalLocation = struct {
    original_line: u32,
    original_column: u32,
    source: u32,
    name: ?u32,
};

const std = @import("std");
const ArrayList = std.ArrayListUnmanaged;

const safe = @import("safe");
