// Re-export from src/cli/ci_info.zig
pub const isCI = @import("../../cli/ci_info.zig").isCI;
pub const detectCIName = @import("../../cli/ci_info.zig").detectCIName;

const safe = @import("safe");
