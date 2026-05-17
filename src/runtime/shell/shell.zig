const bun = @import("bun");

// Re-export from src/shell/shell.zig
pub const interpret = @import("../../shell/interpreter.zig");
pub const subproc = @import("../../shell/subproc.zig");

pub const AllocScope = @import("../../shell/AllocScope.zig");

pub const EnvMap = interpret.EnvMap;
pub const EnvStr = interpret.EnvStr;
pub const Interpreter = interpret.Interpreter;
pub const ParsedShellScript = interpret.ParsedShellScript;
pub const Subprocess = subproc.ShellSubprocess;
pub const ShellSubprocess = Subprocess; // alias for compatibility
pub const ExitCode = interpret.ExitCode;
pub const IOWriter = Interpreter.IOWriter;
pub const IOReader = Interpreter.IOReader;

pub const Yield = @import("../../shell/Yield.zig").Yield;
pub const unreachableState = interpret.unreachableState;

pub const SUBSHELL_TODO_ERROR = "Subshells are not implemented, please open GitHub issue!";

/// Using these instead of the file descriptor decl literals to make sure we use LivUV fds on Windows
pub const STDIN_FD: bun.FD = .fromUV(0);
pub const STDOUT_FD: bun.FD = .fromUV(1);
pub const STDERR_FD: bun.FD = .fromUV(2);
