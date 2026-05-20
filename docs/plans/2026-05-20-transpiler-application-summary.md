# Zust Transpiler Application Summary - 2026-05-20

## Results

- **128 files successfully transpiled** out of 1,305 total `.zig` files (stable baseline)
- **Transpiler improvements committed**: `4f55bfc` (6 major bug fixes, 48 tests passing)
- **Build status**: `vendor/zig/zig build obj` → **PASS** (0 errors)
- **Test status**: `vendor/zig/zig build test` → 3 pre-existing errors in test runner (`main_test.zig`), unrelated to transpiled code
- **Bulk expansion attempted**: 529 files with no `safe.Box` changes applied, but 208 compilation errors from remaining transpiler edge cases — reverted to 128-file baseline

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

## Transpiler Fixes Implemented (Commit `4f55bfc`)

### Completed Fixes
1. **Skip `extern` variables entirely** - `handleVarDecl` now detects `extern` keyword and returns early
2. **Handle `.{}` array init correctly** - arrays keep `undefined` instead of `.{}` (which creates 0-element array literal)
3. **Fix `std.mem.zeroes()` for non-zeroable types** - skips types containing `*`, `enum`, or `union`
4. **Skip `*T` → `safe.Box` for public APIs** - `handleFnDecl` checks for `pub` keyword and skips Box conversion
5. **Scope body rewrite to function body only** - `rewriteBoxDereferencesInBody` now limits scan to function body span instead of entire AST
6. **Skip labeled while loops for counter insertion** - inserting `var __zust_loop_counter` before `label: while` breaks syntax; now skipped
7. **Disable for loop pointer capture rewrite** - too fragile in switch arms and single-statement contexts; now adds comment only

### Transpiler Bugs Still Causing Compilation Errors

These issues prevent expanding beyond 128 files:

1. **Duplicate comments inserted** - `safe-transpile:` comments are added multiple times per function (up to 3-4x)
2. **`@ptrCast` comment breaks mid-expression** - comment inserted inside `@as([*]T, @ptrCast(...))` splits expression across lines, sometimes invalid
3. **`safe` module import missing** - 9 files reference `safe` types but don't have `const safe = @import("safe")`
4. **`std` module reference broken** - 7 files lose `std` import context after transpilation
5. **`__zust_loop_counter` shadowing/redeclaration** - multiple `while (true)` loops in same scope get duplicate counter names
6. **Unused captures after `for` body rewrite** - `_` capture replacement leaves unused variables in some contexts

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

1. **Fix remaining transpiler bugs** (duplicate comments, @ptrCast mid-expression, missing imports)
2. **Re-run bulk transpilation** after fixes to attempt 200-300 file target
3. **Consider whole-program approach** for signature-safe conversions
4. **Add file-level deduplication** to prevent duplicate comment insertion
5. **Validate `safe` module availability** before inserting safe types

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
- **Transpiler bug fixes**: `4f55bfc` (extern vars, pub fn filter, body rewrite scoping, array init, zeroes detection, labeled while loops, for loop rewrite disabled)
