# Zust Transpiler Application Summary - 2026-05-21 (Final)

## Results

- **580 files successfully transpiled** out of 1,305 total `.zig` files (**44.4%**)
- **Transpiler improvements committed**: 15+ major bug fixes + call graph module + variable tracking, 52 tests passing
- **Build status**: `vendor/zig/zig build obj` → **PASS** (0 errors)
- **Previous baselines**: 128 files (9.8%) → 266 files (20.4%) → 316 files (24.2%) → **580 files (44.4%)**
- **Key breakthrough**: Intra-function variable tracking rewrites ALL usages of safe.Box variables
- **Commits**: `d8117a9ae` (bun-zust-port 580 files), `5494bf0` (zust transpiler variable tracking)

## Transpiler Bug Fixes Applied (15+ total)

### Core Safety Fixes
1. **Import injection at file top** — injects `const zust = @import("safe")` after doc comments, never inside struct definitions
2. **Disable OffsetPtr pattern** — `&local → safe.OffsetPtr` requires `allocator` in scope, causing undeclared identifier errors
3. **Fix loop counter insertion position** — only insert in statement position, not inside expressions like `const x = while (true) { ... }`
4. **Disable loop counter entirely** — `return error.InfiniteLoop` breaks function error sets, causing cascading compile errors
5. **Fix allocator name detection** — `allocator.create(T)` → `Box(T).init(alloc_name, undefined)` uses actual receiver name (e.g., `alloc`, `gpa`)
6. **Disable optional unwrap comments** — `.?` comments inserted mid-expression break complex nested syntax
7. **Disable `std.mem.zeroes()` for C-structs** — compile-time error when type contains non-nullable pointers
8. **Skip `pub fn *T` → `safe.Box`** — public function signature changes break all callers across files
9. **Scope body rewrite to function body only** — avoid rewriting captures/loops outside function scope
10. **Unique loop counter names** — `__zust_loop_counter_0`, `_1`, etc. to avoid shadowing
11. **Comment deduplication per function** — prevent duplicate `safe-transpile:` comments
12. **Safe module alias detection** — detect `const zust = @import("safe")` and use `zust.` in all generated code
13. **Keep `undefined` for arrays** — `.{}` creates 0-element array, not zero-initialized array

### v8 Critical Fixes (Expands coverage from 266 → 316)
14. **Fix `bun.destroy` false positive** — only match allocator-like `.destroy` (allocator, alloc, gpa, arena, heap), skip `bun.destroy`, `std.destroy`, etc.
15. **Disable `ptr.* → ptr[0]` rewrite** — single-item pointers (`*T`) do NOT support indexing in Zig; only many-item pointers (`[*]T`) do
16. **Fix tuple destructuring crash** — `const a: T = undefined, const b = ...` breaks when `= undefined` is inserted after type in tuple context
17. **Disable ALL `allocator.free` removal** — removing `free` causes unused capture/parameter errors; safer to keep the call
18. **Disable `*T → safe.Box` parameter conversions ENTIRELY** — even for private functions, callers within the same file break because `Box` requires `.ptr` access

### v11 BREAKTHROUGH: Intra-Function Variable Tracking (Expands coverage from 316 → 580)
19. **Track safe.Box variables per function body** — When `allocator.create(T)` is converted to `safe.Box(T).init(...)`, the variable's type changes from `*T` to `safe.Box(T)`. The transpiler now scans the entire function body and rewrites ALL usages of that variable
20. **Rewrite patterns for Box variables**:
    - `ptr.*` → `ptr.ptr.*`
    - `ptr.field` → `ptr.ptr.field`
    - `ptr[index]` → `ptr.ptr[index]`
    - `&ptr` → `ptr.ptr`
    - `ptr ± N` → `ptr.ptr ± N`
    - `allocator.destroy(ptr)` → `_ = ptr.deinit()`
21. **Unwrap `.try` and `.catch` nodes** — `try allocator.create(T)` and `allocator.create(T) catch fallback` are both correctly tracked
22. **Skip already-rewritten identifiers** — prevents `ptr.ptr` from being double-rewritten to `ptr.ptr.ptr`

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

## Why 580 Files (Not All 1,305)?

The zust transpiler makes file-local changes that alter variable types and API signatures. In Bun's tightly coupled codebase with 1,305 interconnected files, even body-only rewrites can break compilation because:

### Root Cause: Body Rewrites Change Variable Types

Even when function signatures are preserved, body rewrites change the TYPE of local variables:

**Example (BEFORE v11 — this would BREAK):**
```zig
// Original
var ptr = allocator.create(Node);
ptr.*.next = null;

// Transpiled (BREAKS)
var ptr = safe.Box(Node).init(allocator, undefined);
ptr.*.next = null;  // ERROR: cannot dereference non-pointer type 'Box(Node)'
```

**Fixed in v11 with variable tracking:**
```zig
// Transpiled (WORKS)
var ptr = safe.Box(Node).init(allocator, undefined);
ptr.ptr.*.next = null;  // OK: accesses the inner pointer
```

### Remaining Breaking Patterns (Preventing Full 1,305)

- **`std.ArrayList(T)` → `safe.ArrayList(T)`** — changes method signatures (e.g., `.append()` return type)
- **`std.mem.eql` → `safe.SimdUtils.eql`** — different function, different behavior on edge cases
- **`[]u8` parameter → `safe.Slice(u8)`** — changes how slices are passed and accessed
- **Complex generic instantiations** — `ThreadlocalBuffers(T)` with `allocator.create(Storage)` creates `Box(BoxStateful)` which doesn't support direct dereference
- **Cascading effects** — reverting one error file can cause errors in dependent transpiled files
- **Files with no transpiler changes** — ~400 files have no applicable patterns

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

1. ✅ **Implement call-graph analysis** — DONE. Whole-program name-based call graph module created
2. ✅ **Expand stable set** — DONE. 580 files stable (up from 316), 0 build errors
3. ✅ **Variable usage tracking** — DONE. All local variables created with `allocator.create` now have their usages rewritten (`ptr.*`, `ptr.field`, `ptr[0]`, `&ptr`, etc.) to use `ptr.ptr` within the same function
4. **Expand to 800+ files** — The current barrier is files with complex generic patterns and cascading revert effects. Targeted manual expansion of internal modules could push coverage higher.
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

- **Latest bulk application**: `d8117a9ae` (580 files transpiled, intra-function variable tracking)
- **Transpiler improvements**: `5494bf0` (zust repo: variable tracking for safe.Box conversions)
- **Previous bulk application**: `976c994e5` (316 files transpiled, call graph integration)
- **Previous bulk application**: `dc452d6d4` (266 files transpiled, 1,509 insertions, 473 deletions)
- **Previous baseline**: `68dff1fa7` (128 files transpiled)
- **Transpiler tests**: 52 tests passing (up from 48)
