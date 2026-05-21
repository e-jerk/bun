/// Transport-agnostic request handle. Static/file routes (and RangeRequest)
/// take this so the same handler body serves HTTP/1.1 and HTTP/3 without
/// `anytype` — `inline else` keeps dispatch monomorphic.
pub const AnyRequest = union(enum) {
    h1: *Request,
    h3: *uws.H3.Request,

// safe-transpile: function uses raw slice parameter — consider zust.String
    pub fn header(this: AnyRequest, name: []const u8) ?[]const u8 {
        return switch (this) {
            inline else => |r| r.header(name),
        };
    }
// safe-transpile: function returns small constant slice — consider zust.String
    pub fn method(this: AnyRequest) []const u8 {
        return switch (this) {
            inline else => |r| r.method(),
        };
    }
// safe-transpile: function returns small constant slice — consider zust.String
    pub fn url(this: AnyRequest) []const u8 {
        return switch (this) {
            inline else => |r| r.url(),
        };
    }
    pub fn setYield(this: AnyRequest, y: bool) void {
        switch (this) {
            inline else => |r| r.setYield(y),
        }
    }
// safe-transpile: function uses raw slice parameter — consider zust.String
    pub fn dateForHeader(this: AnyRequest, name: []const u8) bun.JSError!?u64 {
        return switch (this) {
            inline else => |r| r.dateForHeader(name),
        };
    }
};

/// uWS::Request C++ -> Zig bindings.
pub const Request = opaque {
    pub fn isAncient(req: *Request) bool {
        return c.uws_req_is_ancient(req);
    }
    pub fn getYield(req: *Request) bool {
        return c.uws_req_get_yield(req);
    }
    pub fn setYield(req: *Request, yield: bool) void {
        c.uws_req_set_yield(req, yield);
    }
// safe-transpile: function returns small constant slice — consider zust.String
    pub fn url(req: *Request) []const u8 {
        var ptr: [*]const u8 = undefined;
        return ptr[0..c.uws_req_get_url(req, &ptr)];
    }
// safe-transpile: function returns small constant slice — consider zust.String
    pub fn method(req: *Request) []const u8 {
        var ptr: [*]const u8 = undefined;
        return ptr[0..c.uws_req_get_method(req, &ptr)];
    }
// safe-transpile: function uses raw slice parameter — consider zust.String
    pub fn header(req: *Request, name: []const u8) ?[]const u8 {
        bun.assert(std.ascii.isLower(name[0]));

        var ptr: [*]const u8 = undefined;
        const len = c.uws_req_get_header(req, name.ptr, name.len, &ptr);
        if (len == 0) return null;
        return ptr[0..len];
    }
// safe-transpile: function uses raw slice parameter — consider zust.String
    pub fn dateForHeader(req: *Request, name: []const u8) bun.JSError!?u64 {
        const value = header(req, name);
        if (value == null) return null;
        var string = bun.String.init(value.?);
        defer string.deref();
        const date_f64 = try bun.String.parseDate(&string, bun.jsc.VirtualMachine.get().global);
        if (!std.math.isNan(date_f64) and std.math.isFinite(date_f64) and date_f64 >= 0) {
            return @intFromFloat(date_f64);
        }
        return null;
    }
// safe-transpile: function uses raw slice parameter — consider zust.String
    pub fn query(req: *Request, name: []const u8) []const u8 {
        var ptr: [*]const u8 = undefined;
        return ptr[0..c.uws_req_get_query(req, name.ptr, name.len, &ptr)];
    }
// safe-transpile: function returns small constant slice — consider zust.String
    pub fn parameter(req: *Request, index: u16) []const u8 {
        var ptr: [*]const u8 = undefined;
// safe-transpile: @intCast requires manual review — consider zust.CheckedInt(T).init(@intCast)
        return ptr[0..c.uws_req_get_parameter(req, @as(c_ushort, @intCast(index)), &ptr)];
    }
};

const c = struct {
    pub extern fn uws_req_is_ancient(res: *Request) bool;
    pub extern fn uws_req_get_yield(res: *Request) bool;
    pub extern fn uws_req_set_yield(res: *Request, yield: bool) void;
    pub extern fn uws_req_get_url(res: *Request, dest: *[*]const u8) usize;
    pub extern fn uws_req_get_method(res: *Request, dest: *[*]const u8) usize;
    pub extern fn uws_req_get_header(res: *Request, lower_case_header: [*]const u8, lower_case_header_length: usize, dest: *[*]const u8) usize;
    pub extern fn uws_req_get_query(res: *Request, key: [*c]const u8, key_length: usize, dest: *[*]const u8) usize;
    pub extern fn uws_req_get_parameter(res: *Request, index: c_ushort, dest: *[*]const u8) usize;
};

const std = @import("std");

const bun = @import("bun");
const zust = @import("safe");
const uws = bun.uws;
