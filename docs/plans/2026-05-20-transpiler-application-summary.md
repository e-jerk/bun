# Zust Transpiler Application Summary - 2026-05-20

## Results

- **128 files successfully transpiled** out of 1,305 total `.zig` files (stable baseline)
- **Transpiler improvements committed**: `4f55bfc` + `d4ca8e2` (11 major bug fixes, 48 tests passing)
- **Build status**: `vendor/zig/zig build obj` → **PASS** (0 errors)
- **Test status**: `vendor/zig/zig build test` → 3 pre-existing errors in test runner (`main_test.zig`), unrelated to transpiled code
- **Bulk expansion attempted**: 528 files with no `safe.Box` changes applied, reduced to 91 errors, then to 73 errors, but reverting individual erroring files breaks dependent transpiled files — **128 files remain the proven stable set**

## Why Only 128 Files?

The zust transpiler makes file-local changes that often alter public API signatures (e.g., `*T` → `safe.Box(T)`). In a tightly coupled codebase like Bun with 1,305 interconnected files, changing a function signature in one file breaks all callers in other files.

### Root Cause

Bun's architecture has:
- Dense dependency graph (most files import from many others)
- Heavy use of non-self `*T` pointer parameters in public functions
- `extern` variables for C interop
- Complex generic patterns

When the transpiler converts `pub fn foo(ptr: *T)` to `pub fn foo(ptr: safe.Box(T))`, every call site across the entire codebase breaks because:
1. Callers pass `&value` (raw pointer), not `safe.Box(T)`
2. Even if callers were updated, `safe.Box` requires allocator initialization

## Manual Fix Patterns Discovered

### 1. `std.mem.zeroes()` Cannot Zero Non-Zeroable Types

**Transpiler generates**: `var x = std.mem.zeroes([MAX_PATH]u8);`
**Problem**: Creates a 0-element array instead of zero-initialized array
**Fix**: Use `var x: [MAX_PATH]u8 = undefined; @memset(&x, 0);`

**Transpiler generates**: `var t = std.mem.zeroes(Transpiler);`
**Problem**: Type has non-nullable pointers or enums without zero value
**Fix**: Use `var t: Transpiler = undefined;`

### 2. `safe.Box` With `.*` Dereference is Wrong

**Transpiler generates**: `var box = safe.BoxStateful(T,0,0,0).init(allocator, value);` then `box.*.field`
**Problem**: `safe.Box` is not a raw pointer - it has `.ptr` field
**Fix**: Use `box.ptr.field` or use `allocator.create()` for raw pointers

### 3. `extern` Variables Must Never Be Modified

**Transpiler changes**: `pub extern "C" var x: ?*anyopaque = undefined;`
**Problem**: `extern` variables cannot have initializers in Zig
**Fix**: Skip all `extern` variables entirely - do not transpile them

### 4. Empty Array Init `.{}` Creates 0-Element Array

**Transpiler generates**: `path_buf: [MAX_PATH]u8 = .{}`
**Problem**: `.{}` creates empty array literal (0 elements), not zero-filled array
**Fix**: Use `path_buf: [MAX_PATH]u8 = undefined;` or `@memset(&path_buf, 0);`

### 5. `if (expr) |capture|` in Return Context

**Transpiler bug**: `handleUnwrapOptional` checks for `"return "` prefix but captures in return statements need special handling
**Example**: `return if (foo()) |x| bar(x) else baz;`
**Fix**: The return-check logic was off-by-one (checked for `"return "` instead of `"return"`). Fixed in transpiler commit `e84357b`.

## Files Successfully Transpiled

The 128 files that compiled successfully are primarily:
- **Internal/leaf modules** with minimal public API surface
- **Data structures** and protocol implementations
- **Helper modules** used locally within subsystems
- **Files with only body changes** (`@memcpy` → `safe.SimdUtils.copy`, loop fixes, comments)

Full list: See `git diff --stat` on commit `68dff1fa7`

## Key Categories of Skipped Files

1. **Public API files** (1169 files): Any file with `pub fn` having non-self `*T` parameters
2. **Entry points** (`entry/`, `main.zig`): Have `extern` variables, special initialization
3. **C interop files** (`jsc/bindings/`, `napi/`): Raw pointer heavy, `extern` functions
4. **Core runtime files** (`runtime/`, `bun.zig`, `Output.zig`): Too many callers
5. **Files with no transpiler changes**: 945 files had no `safe.Box` or body modifications

## Transpiler Fixes Implemented (Commits `4f55bfc` + `d4ca8e2`)

### Completed Fixes (11 total)
1. **Skip `extern` variables entirely** - `handleVarDecl` detects `extern` keyword and returns early
2. **Handle `.{}` array init correctly** - arrays keep `undefined` instead of `.{}` (0-element array literal)
3. **Fix `std.mem.zeroes()` for non-zeroable types** - skips types containing `*`, `enum`, or `union`
4. **Skip `*T` → `safe.Box` for public APIs** - `handleFnDecl` checks for `pub` keyword and skips Box conversion
5. **Scope body rewrite to function body only** - `rewriteBoxDereferencesInBody` limits scan to function body span
6. **Skip labeled while loops for counter insertion** - inserting `var __zust_loop_counter` before `label: while` breaks syntax
7. **Disable for loop pointer capture rewrite** - too fragile in switch arms; now adds comment only
8. **Unique loop counter names** - `__zust_loop_counter_0`, `_1`, etc. instead of bare `__zust_loop_counter`
9. **Builtin comments before line** - `@ptrCast`, `@intCast`, etc. get comments before the line, not mid-expression
10. **Safe import auto-injection** - files using `safe.` types without `@import("safe")` get `const safe = @import("safe")` prepended
11. **Always comment for `.?` unwraps** - block rewrite (`if (opt) |v| v else ...`) is invalid in expression contexts; now always comments

### Transpiler Bugs Still Causing Compilation Errors (528-file attempt)

These issues prevent expanding beyond 128 files:

1. **`safe` module imported under different alias** - some files use `const zust = @import("safe")` but transpiler generates `safe.SimdUtils` references
2. **`allocator.free` removal makes `if` captures unused** - when `if (x) |text| allocator.free(text)` becomes `if (x) |text| _ = undefined`, `text` is unused
3. **`allocator` parameter becomes unused** - functions whose only `allocator` use was `allocator.free(...)` lose their parameter usage
4. **`std` module reference issues** - some files get `std.mem.zeroes()` inserted but `std` isn't available in that scope
5. **Duplicate comments** - `safe-transpile:` comments inserted multiple times per function (2-4x) when multiple params match

## Lessons Learned

### Bulk Transpilation is Fundamentally Incompatible with Bun
The transpiler is designed for file-local transformations. Bun's architecture requires global program analysis to safely change signatures. A whole-program approach would be needed:
- Parse all files
- Build call graph
- Identify safe conversion points (internal-only functions)
- Apply changes globally with all callers updated

### Selective Approach is Required
The only viable path is:
1. Identify leaf/internal modules with no external callers
2. Transpile those files only
3. Verify compilation
4. Gradually expand outward as APIs are proven safe

### Manual Review is Essential
Even "safe" transpiler changes need human review:
- `std.mem.zeroes()` vs `undefined` semantics
- `extern` variable preservation
- Array initialization patterns
- Test runner compatibility

## Next Steps

1. **Fix remaining transpiler bugs** (safe alias detection, if-capture unused after free removal, param unused after free removal)
2. **Consider targeted manual expansion** - hand-pick 50-100 additional internal modules and transpile individually
3. **Consider whole-program approach** for signature-safe conversions (parse all files, build call graph)
4. **Add file-level deduplication** to prevent duplicate comment insertion (track already-commented functions)
5. **Validate `safe` module alias** before inserting safe types — detect `const zust = @import("safe")` and use `zust.` instead

## Test Command Reference

```bash
# Build main binary (must pass with 0 errors)
cd /Users/barrett/github.com/e-jerk/bun-zust-port
unset CPATH
vendor/zig/zig build obj

# Test build (has pre-existing issues in test runner)
vendor/zig/zig build test

# Count transpiled files
cd /Users/barrett/github.com/e-jerk/bun-zust-port
diff_count=0
while read f; do
  if ! diff -q "$f" "/tmp/bun-src-backup/$f" >/dev/null 2>&1; then
    diff_count=$((diff_count+1))
  fi
done < /tmp/all_zig_files.txt
echo "Transpiled: $diff_count files"
```

## Commit Reference

- **Transpiler enhancements**: `e84357b` (`*T` → `safe.Box` param conversion + unwrap fix)
- **Bulk application**: `68dff1fa7` (128 files transpiled, 1,289 insertions, 193 deletions)
- **Transpiler bug fixes (batch 1)**: `4f55bfc` (extern vars, pub fn filter, body rewrite scoping, array init, zeroes detection, labeled while loops, for loop rewrite disabled)
- **Transpiler bug fixes (batch 2)**: `d4ca8e2` (unique loop counters, builtin comments before line, safe import injection, unwrap comment-only, expanded is_chained check)
