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

// Re-export AST and SmolList from the main shell module
pub const AST = @import("../../shell/shell.zig").AST;
pub const SmolList = @import("../../shell/shell.zig").SmolList;
pub const Parser = @import("../../shell/shell.zig").Parser;
pub const LexResult = @import("../../shell/shell.zig").LexResult;

pub const SUBSHELL_TODO_ERROR = "Subshells are not implemented, please open GitHub issue!";

// Re-export from the real shell module
pub const ShellErr = @import("../../shell/shell.zig").ShellErr;
pub const Result = @import("../../shell/shell.zig").Result;
pub const isValidVarName = @import("../../shell/shell.zig").isValidVarName;
pub const ParseError = @import("../../shell/shell.zig").ParseError;
pub const Test = @import("../../shell/shell.zig").Test;

pub const LexerAscii = @import("../../shell/shell.zig").LexerAscii;
pub const LexerUnicode = @import("../../shell/shell.zig").LexerUnicode;

pub const shellCmdFromJS = @import("../../shell/shell.zig").shellCmdFromJS;

pub fn needsEscapeUtf8AsciiLatin1(str: []const u8) bool {
    for (str) |c| {
        if (c == ' ' or c == '\'' or c == '"' or c == '\\' or c == '$' or c == '`' or c == '|' or c == '&' or c == ';' or c == '(' or c == ')' or c == '<' or c == '>' or c == '*' or c == '?' or c == '[' or c == ']' or c == '{' or c == '}' or c == '~' or c == '#' or c == '!') return true;
    }
    return false;
}

pub fn needsEscapeBunstr(str: bun.String) bool {
    _ = str;
    return false;
}

pub fn escape8Bit(str: []const u8, outbuf: anytype, comptime _: bool) !void {
    try outbuf.appendSlice(str);
}

pub fn escapeBunStr(str: bun.String, outbuf: anytype, comptime _: bool) !bool {
    try outbuf.appendSlice(str.byteSlice());
    return true;
}

/// Using these instead of the file descriptor decl literals to make sure we use LivUV fds on Windows
pub const STDIN_FD: bun.FD = .fromUV(0);
pub const STDOUT_FD: bun.FD = .fromUV(1);
pub const STDERR_FD: bun.FD = .fromUV(2);

const safe = @import("safe");
