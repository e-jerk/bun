//! Median-cut colour quantizer for `.png({ palette: true, colors: N })`.
//!
//! Goal is "good enough to match Sharp's palette PNG path for screenshot
//! compression", not perceptual perfection — Sharp uses libimagequant which
//! is GPL, so we roll a small permissive one. Median-cut is the classic
//! Heckbert '82 algorithm: treat the RGBA pixels as points in a 4-D box,
//! repeatedly split the box with the largest channel range at that channel's
//! median until you have N boxes, then each box's mean becomes a palette
//! entry. Mapping is nearest-entry by squared RGBA distance, optionally with
//! Floyd–Steinberg error diffusion (`dither: true`).

pub const Result = struct {
    /// `[colors][4]u8` RGBA palette, `bun.default_allocator`-owned.
    palette: []u8,
    /// One palette index per input pixel, `bun.default_allocator`-owned.
    indices: []u8,
    /// Actual palette length (≤ requested `colors`).
    colors: u16,
    /// True if any palette entry has alpha < 255 — caller writes a tRNS chunk.
    has_alpha: bool,

    pub fn deinit(self: *Result) void {
        // safe-transpile: free removed (memory owned by safe type);
        // safe-transpile: free removed (memory owned by safe type);
    }
};

const Box = struct {
    /// Slice into the shared `order` index buffer.
    lo: u32,
    hi: u32,
    min: [4]u8,
    max: [4]u8,

    fn widestChannel(self: Box) u2 {
        var best: u2 = 0;
        var span: i32 = -1;
        inline for (0..4) |c| {
            const s: i32 = @as(i32, self.max[c]) - @as(i32, self.min[c]);
            if (s > span) {
                span = s;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                best = @intCast(c);
            }
        }
        return best;
    }
};

extern fn bun_image_nearest_palette(palette: [*]const u8, k: u32, r: i32, g: i32, b: i32, a: i32) u32;

pub const Options = struct {
    max_colors: u16,
    /// Floyd–Steinberg error diffusion. Hides banding on gradients at the
    /// cost of grain on flat areas; off by default to match Sharp's
    /// `palette:true` default.
    dither: bool = false,
};

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn quantize(rgba: []const u8, w: u32, h: u32, opts: Options) error{OutOfMemory}!Result {
    const max_colors = opts.max_colors;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    const n: u32 = @intCast(rgba.len / 4);
    const want: u16 = @max(1, @min(max_colors, 256));

    // `order` is a permutation of pixel indices that we partition in-place;
    // each Box owns a contiguous [lo,hi) slice of it.
    var order = try bun.default_allocator.alloc(u32, n);
    // safe-transpile: free removed (memory owned by safe type);
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    // safe-transpile: for with index access requires manual review
    for (order, 0..) |*o, i| o[0] = @intCast(i);

    var boxes = try safe.ArrayList(Box).initCapacity(bun.default_allocator, want);
    defer boxes.deinit(bun.default_allocator);
    boxes.appendAssumeCapacity(shrink(rgba, order, 0, n));

    while (boxes.items.len < want) {
        // Pick the box with the largest single-channel range — the one that
        // most wants splitting.
        var pick: usize = 0;
        var best: i32 = -1;
        // safe-transpile: for with index access requires manual review
    for (boxes.items, 0..) |b, i| {
            const c = b.widestChannel();
            const s: i32 = @as(i32, b.max[c]) - @as(i32, b.min[c]);
            if (s > best) {
                best = s;
                pick = i;
            }
        }
        if (best <= 0) break; // every remaining box is a single colour
        const b = boxes.items[pick];
        if (b.hi - b.lo < 2) break;

        const ch = b.widestChannel();
        // Partial sort by the chosen channel, then cut at the midpoint.
        const slice = order[b.lo..b.hi];
        std.sort.pdq(u32, slice, SortCtx{ .rgba = rgba, .ch = ch }, SortCtx.less);
        const mid = b.lo + (b.hi - b.lo) / 2;
        boxes.items[pick] = shrink(rgba, order, b.lo, mid);
        boxes.appendAssumeCapacity(shrink(rgba, order, mid, b.hi));
    }

// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
    const k: u16 = @intCast(boxes.items.len);
    var palette = try bun.default_allocator.alloc(u8, @as(usize, k) * 4);
    // safe-transpile: free removed (memory owned by safe type);
    var has_alpha = false;
    // safe-transpile: for with index access requires manual review
    for (boxes.items, 0..) |b, i| {
        var sum: [4]u64 = .{ 0, 0, 0, 0 };
        for (order[b.lo..b.hi]) |px| inline for (0..4) |c| {
            sum[c] += rgba[@as(usize, px) * 4 + c];
        };
        const cnt: u64 = b.hi - b.lo;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
        inline for (0..4) |c| palette[i * 4 + c] = @intCast((sum[c] + cnt / 2) / cnt);
        if (palette[i * 4 + 3] < 255) has_alpha = true;
    }

    var indices = try bun.default_allocator.alloc(u8, n);
    // safe-transpile: free removed (memory owned by safe type);
    if (opts.dither) {
        try mapFloydSteinberg(rgba, w, h, palette, k, indices);
    } else {
        // Direct nearest-entry mapping. k ≤ 256; the inner search is the
        // highway-dispatched kernel so it runs under the best -march.
        for (0..n) |px| {
            const p = rgba[px * 4 ..][0..4];
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            indices[px] = @intCast(bun_image_nearest_palette(palette.ptr, k, p[0], p[1], p[2], p[3]));
        }
    }

    return .{ .palette = palette, .indices = indices, .colors = k, .has_alpha = has_alpha };
}

/// Floyd–Steinberg error diffusion. Serial in raster order — each pixel's
/// quantisation error is pushed to its yet-unvisited neighbours with the
/// classic 7/3/5/1 ÷16 kernel:
///
///         ·   X   7
///         3   5   1
///
/// Serpentine scan (alternate L→R / R→L per row) so the diffusion direction
/// flips each row, avoiding the directional artefacts a fixed scan produces.
/// The diffusion itself can't be vectorised (data dependence on the previous
/// pixel), but the per-pixel palette search goes through the highway kernel.
// safe-transpile: function uses raw slice parameter — consider safe.String
fn mapFloydSteinberg(
    rgba: []const u8,
    w: u32,
    h: u32,
    palette: []const u8,
    k: u16,
    indices: []u8,
) error{OutOfMemory}!void {
    // Two rows of accumulated error, ×4 channels. i32 not i16: when the
    // palette doesn't span the source range (e.g. colors:2, both entries near
    // 0, source has 255s) the residual grows without bound across the row —
    // each pixel's error is `cand − nearest`, and `cand = src + carried` keeps
    // climbing. i16 overflows there; two w×4 i32 rows are still negligible.
    // `cur` carries error pushed *into* the current row from the row above;
    // `nxt` collects error for the row below.
    const stride: usize = @as(usize, w) * 4;
    var cur = try bun.default_allocator.alloc(i32, stride);
    // safe-transpile: free removed (memory owned by safe type);
    var nxt = try bun.default_allocator.alloc(i32, stride);
    // safe-transpile: free removed (memory owned by safe type);
    @memset(cur, 0);
    @memset(nxt, 0);

    var y: u32 = 0;
    while (y < h) : (y += 1) {
        const ltr = (y & 1) == 0;
        const step: i64 = if (ltr) 1 else -1;
        var x: i64 = if (ltr) 0 else @as(i64, w) - 1;
        while (x >= 0 and x < w) : (x += step) {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            const px: usize = @as(usize, y) * w + @as(usize, @intCast(x));
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            const off: usize = @as(usize, @intCast(x)) * 4;

            // Candidate colour = source + accumulated error (clamped for the
            // search; the *unclamped* error is what propagates so rounding
            // doesn't accumulate bias).
            var cand: [4]i32 = .{};
            inline for (0..4) |c| cand[c] = @as(i32, rgba[px * 4 + c]) + cur[off + c];

// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
            const idx: u8 = @intCast(bun_image_nearest_palette(
                palette.ptr,
                k,
                clamp255(cand[0]),
                clamp255(cand[1]),
                clamp255(cand[2]),
                clamp255(cand[3]),
            ));
            indices[px] = idx;

            inline for (0..4) |c| {
                const err: i32 = cand[c] - @as(i32, palette[@as(usize, idx) * 4 + c]);
                // Push to the four neighbours. `dir` is +1 for L→R, −1 for R→L.
                const dir = step;
                const xr = x + dir;
                const xl = x - dir;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                if (xr >= 0 and xr < w) cur[@as(usize, @intCast(xr)) * 4 + c] += (err * 7) >> 4;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                if (xl >= 0 and xl < w) nxt[@as(usize, @intCast(xl)) * 4 + c] += (err * 3) >> 4;
                nxt[off + c] += (err * 5) >> 4;
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                if (xr >= 0 and xr < w) nxt[@as(usize, @intCast(xr)) * 4 + c] += err >> 4;
            }
        }
        // Slide: next row's error becomes current; clear next.
        std.mem.swap([]i32, &cur, &nxt);
        @memset(nxt, 0);
    }
}

inline fn clamp255(v: i32) i32 {
    return @min(@max(v, 0), 255);
}

const SortCtx = struct {
    rgba: []const u8,
    ch: u2,
    fn less(ctx: SortCtx, a: u32, b: u32) bool {
        // u32 ×4 overflows past ~1.07B pixels (allowed when the user raises
        // `maxPixels`); the other order-index sites already widen first.
        return ctx.rgba[@as(usize, a) * 4 + ctx.ch] < ctx.rgba[@as(usize, b) * 4 + ctx.ch];
    }
};

/// Recompute a box's tight min/max over its pixel slice.
// safe-transpile: function uses raw slice parameter — consider safe.String
fn shrink(rgba: []const u8, order: []const u32, lo: u32, hi: u32) Box {
    var min: [4]u8 = .{ 255, 255, 255, 255 };
    var max: [4]u8 = .{ 0, 0, 0, 0 };
    for (order[lo..hi]) |px| inline for (0..4) |c| {
        const v = rgba[@as(usize, px) * 4 + c];
        if (v < min[c]) min[c] = v;
        if (v > max[c]) max[c] = v;
    };
    return .{ .lo = lo, .hi = hi, .min = min, .max = max };
}

const bun = @import("bun");
const std = @import("std");
