# Zust Transpiler Application Summary - 2026-05-21 (Updated)

## Results

- **324 files successfully transpiled** out of 1,305 total `.zig` files (**24.8%**)
- **Transpiler improvements committed**: 14 major bug fixes + call graph module, 52 tests passing
- **Build status**: `vendor/zig/zig build obj` → **PASS** (0 errors)
- **Previous baselines**: 128 files (9.8%) → 266 files (20.4%) → **324 files**
- **Call graph integration**: Whole-program analysis now identifies internal-only functions safe for `*T` → `Box(T)` conversion

## Transpiler Bug Fixes Applied (14 total)

1. **Import injection at file top** — injects `const zust = @import("safe")` after doc comments, never inside struct definitions
2. **Disable OffsetPtr pattern** — `&local → safe.OffsetPtr` requires `allocator` in scope, causing undeclared identifier errors
3. **Fix loop counter insertion position** — only insert in statement position, not inside expressions like `const x = while (true) { ... }`
4. **Disable loop counter entirely** — `return error.InfiniteLoop` breaks function error sets, causing cascading compile errors
5. **Fix allocator name detection** — `allocator.create(T)` → `Box(T).init(alloc_name, undefined)` uses actual receiver name (e.g., `alloc`, `gpa`)
6. **Add if capture → `_`** — when body is `allocator.free(capture)`, change `|capture|` to `|_|`
7. **Disable optional unwrap comments** — `.?` comments inserted mid-expression break complex nested syntax
8. **Disable `std.mem.zeroes()` for C-structs** — compile-time error when type contains non-nullable pointers
9. **Skip `pub fn *T` → `safe.Box`** — public function signature changes break all callers across files
10. **Scope body rewrite to function body only** — avoid rewriting captures/loops outside function scope
11. **Unique loop counter names** — `__zust_loop_counter_0`, `_1`, etc. to avoid shadowing
12. **Comment deduplication per function** — prevent duplicate `safe-transpile:` comments
13. **Safe module alias detection** — detect `const zust = @import("safe")` and use `zust.` in all generated code
14. **Keep `undefined` for arrays** — `.{}` creates 0-element array, not zero-initialized array

## Call Graph Integration (NEW)

### Implementation
- **Module**: `zust/tools/call_graph.zig` — lightweight name-based whole-program analysis
- **Approach A**: Parse all `.zig` files, extract function declarations (name, `pub`/`private`) and direct calls
- **Cross-file safety**: A function is "safe to convert" only if no OTHER file calls it by name
- **Memory model**: `StringHashMap` in Zig 0.16 does NOT copy keys — all stored strings are explicitly duplicated via `allocator.dupe()`

### Key Bug Fix: Double-Free → Ownership Model
- **Problem**: `extractCalls` used `defer allocator.free(fn_name)` while also storing `fn_name` in `ArrayList(CallerEntry)`, causing both dangling pointers and double-free in `deinit`
- **Fix**: Remove `defer` in `extractCalls`; transfer ownership to `callers` array on append, free duplicate on existing-entry hit
- **Fix**: Duplicate `file_path` before storing in `StringHashMap(void)` entries (was using dangling pointers from freed CLI buffer)
- **Fix**: Free all `files` hashmap keys in `CallGraph.deinit()`

### Impact
- Call graph analysis now prevents converting non-public functions that ARE called from other files in the same package
- Enables safer `*T` → `Box(T)` conversion for truly internal-only functions
- 324 files stable (up from 266)

## Why 324 Files (Not All 1,305)?

The zust transpiler makes file-local changes that alter API signatures (e.g., `*T` → `safe.Box(T)`). In Bun's tightly coupled codebase with 1,305 interconnected files, changing a function signature in one file breaks all callers in other files.

### Root Cause

Bun's architecture has:
- Dense dependency graph (most files import from many others)
- Heavy use of non-self `*T` pointer parameters in both public AND non-public functions
- Non-public functions ARE called from other files within the same package (Zig `pub` is package-level visibility)
- `extern` variables for C interop
- Complex generic patterns
- Functions with explicit error sets that can't accept `error.InfiniteLoop`

When the transpiler converts `fn foo(ptr: *T)` to `fn foo(ptr: safe.Box(T))`, every call site breaks because:
1. Callers pass `&value` (raw pointer), not `safe.Box(T)`
2. Even if callers were updated, `safe.Box` requires allocator initialization

### Call Graph Does Not Fully Solve This

The call graph correctly identifies functions with NO external callers, but:
- Many non-public functions ARE called from other files in the same package
- The transpiler only converts parameters, not call sites (callers still pass raw pointers)
- Other transpiler changes (`std.mem.zeroes()` removal, loop counters, etc.) also cause errors
- A single bad transpilation in one file can cause cascading errors in dozens of dependent files

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

The 266 files that compiled successfully are primarily:
- **Internal/leaf modules** with minimal public API surface
- **Data structures** and protocol implementations
- **Helper modules** used locally within subsystems
- **Files with only body changes** (`@memcpy` → `safe.SimdUtils.copy`, loop fixes, comments)
- **Non-public functions** where `*T` → `Box(T)` conversions don't break external callers

Full list: See `git diff --stat` on latest commit

## Key Categories of Skipped Files

1. **Public API files**: Any file with `pub fn` having non-self `*T` parameters (skipped to avoid breaking callers)
2. **Entry points** (`entry/`, `main.zig`): Have `extern` variables, special initialization
3. **C interop files** (`jsc/bindings/`, `napi/`): Raw pointer heavy, `extern` functions
4. **Core runtime files** (`runtime/`, `bun.zig`, `Output.zig`): Too many callers
5. **Files with caller dependencies**: Non-public functions called from other files break when converted to Box
6. **Files with no transpiler changes**: ~950 files had no safe.Box or body modifications

## Transpiler Fixes Implemented

### Completed Fixes (14 total)
1. **Skip `extern` variables entirely** - `handleVarDecl` detects `extern` keyword and returns early
2. **Handle `.{}` array init correctly** - arrays keep `undefined` instead of `.{}` (0-element array literal)
3. **Fix `std.mem.zeroes()` for non-zeroable types** - DISABLED entirely for C-structs; compile-time errors on pointer fields
4. **Skip `*T` → `safe.Box` for public APIs** - `handleFnDecl` checks for `pub` keyword and skips Box conversion
5. **Scope body rewrite to function body only** - `rewriteBoxDereferencesInBody` limits scan to function body span
6. **Skip labeled while loops for counter insertion** - inserting `var __zust_loop_counter` before `label: while` breaks syntax
7. **Disable for loop pointer capture rewrite** - too fragile in switch arms; now adds comment only
8. **Unique loop counter names** - `__zust_loop_counter_0`, `_1`, etc. instead of bare `__zust_loop_counter`
9. **Builtin comments before line** - `@ptrCast`, `@intCast`, etc. get comments before the line, not mid-expression
10. **Safe import auto-injection** - files using `safe.` types without `@import("safe")` get `const zust = @import("safe")` injected after doc comments
11. **Disable optional unwrap comments** - `.?` comments break expression syntax; disabled entirely
12. **Disable OffsetPtr pattern** - `&local → safe.OffsetPtr` requires `allocator` in scope; causes undeclared identifier errors
13. **Fix allocator name detection** - `alloc.create(T)` → `Box(T).init(alloc, undefined)` uses actual receiver name
14. **Add if capture → `_`** - when `if (x) |text| allocator.free(text)`, change capture to `|_|`

### Transpiler Bugs Still Causing Compilation Errors

These issues prevent expanding beyond 266 files:

1. **Non-public functions with external callers** - `fn foo(ptr: *T)` converted to `Box(T)` breaks callers in other files
2. **Functions with restricted error sets** - `while (true)` loop guards add `error.InfiniteLoop` (disabled but pattern still exists)
3. **`Box(T)` dereference syntax** - callers using `ptr[0]` or `ptr.*` break when `ptr` becomes `Box(T)`
4. **Capture-only `if`/`for` bodies** - `if (x) |text| allocator.free(text)` leaves `text` unused when free is removed

## Lessons Learned

### Bulk Transpilation Requires Call-Graph Awareness
The transpiler is file-local but Bun's architecture requires knowing which functions are called from other files. A whole-program approach would be needed:
- Parse all files
- Build call graph
- Identify safe conversion points (truly internal-only functions)
- Apply changes globally with all callers updated

### Selective + Iterative Approach Works
The viable path proven by this work:
1. Apply transpiler to ALL files
2. Skip files with `safe.Box` signature changes (break cross-file callers)
3. Compile and iteratively revert erroring files
4. End with a stable set that compiles (266 files)

### Manual Review is Essential
Even "safe" transpiler changes need human review:
- `std.mem.zeroes()` vs `undefined` semantics
- `extern` variable preservation
- Array initialization patterns
- Caller/callee compatibility for `*T` → `Box(T)`

## Next Steps

1. ✅ **Implement call-graph analysis** — DONE. Whole-program name-based call graph now prevents converting functions with external callers
2. ✅ **Expand Box param conversion** — DONE. 324 files stable (up from 266)
3. **Consider targeted manual expansion** — Hand-pick additional internal modules and transpile individually
4. **Add whole-program caller updating** — When converting `*T` → `Box(T)`, update all callers in the same file to construct `safe.Box(T)` instead of passing `&value`
5. **Test `zig build test`** — The main `obj` build passes; test runner build may have pre-existing issues

## Test Command Reference

```bash
# Build main binary (must pass with 0 errors)
cd /Users/barrett/github.com/e-jerk/bun-zust-port
unset CPATH
vendor/zig/zig build obj

# Test build (has pre-existing issues in test runner)
vendor/zig/zig build test

# Count transpiled files
python3 -c "
import os
with open('/tmp/all_zig_files.txt', 'r') as f:
    all_files = [line.strip() for line in f if line.strip()]
applied = 0
for rel_path in all_files:
    backup = f'/tmp/bun-src-backup/{rel_path}'
    current = f'/Users/barrett/github.com/e-jerk/bun-zust-port/{rel_path}'
    if os.path.exists(backup) and os.path.exists(current):
        with open(backup, 'rb') as b:
            with open(current, 'rb') as c:
                if b.read() != c.read():
                    applied += 1
print(f'Transpiled: {applied} files ({applied/len(all_files)*100:.1f}%)')
"
```

## Commit Reference

- **Latest bulk application**: `TBD` (324 files transpiled, call graph integration)
- **Previous bulk application**: `dc452d6d4` (266 files transpiled, 1,509 insertions, 473 deletions)
- **Transpiler bug fixes (14 total) + call graph module**: See zust repo `transpiler.zig` and `call_graph.zig` history
- **Previous baseline**: `68dff1fa7` (128 files transpiled)
- **Transpiler tests**: 52 tests passing (up from 48)
