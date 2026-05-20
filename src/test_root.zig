// Minimal test root that imports the bun module so all test blocks are discovered
const bun = @import("bun");

pub const std_options = std.Options{
    .enable_segfault_handler = false,
};

const std = @import("std");

const safe = @import("safe");
