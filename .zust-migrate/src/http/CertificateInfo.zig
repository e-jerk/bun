const CertificateInfo = @This();

cert: []const u8,
cert_error: HTTPCertError,
hostname: []const u8,
pub fn deinit(this: *const CertificateInfo, allocator: std.mem.Allocator) void {
    // safe-transpile: free removed (memory owned by safe type);
    // safe-transpile: free removed (memory owned by safe type);
    // safe-transpile: free removed (memory owned by safe type);
    // safe-transpile: free removed (memory owned by safe type);
}

const HTTPCertError = @import("./HTTPCertError.zig");
const std = @import("std");
