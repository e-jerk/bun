# Zust Transpiler Application Summary

## Current Status: 1288 files (98.6%)

**Date:** 2026-05-21
**Commit:** d7c7e56

### Milestones
- 128 files (9.8%) - initial conservative pass
- 266 files (20.4%) - conservative transpiler v2
- 316 files (24.2%) - with OffsetPtr + allocator.create fixes
- 580 files (44.4%) - with scoped import fix + reverted cross-file changes
- 688 files (52.7%) - with body-only rewrites + safe alias detection
- 712 files (54.6%) - with tuple fix + false-positive create fix
- 809 files (62.0%) - with stricter matching + shadowing detection (v19)
- 830 files (63.6%) - with recursive arg checking + nested fn exclusion (v23)
- 839 files (64.3%) - with AST-based field assignment + explicit pointer checks (v26)
- 1277 files (97.8%) - with conditional defer destroy + Phase 1 explicit ptr check (v27)
- 1282 files (98.2%) - with `}` catch-all for tuple/struct literals (v28)
- 1287 files (98.6%) - with scoped import skip + safe.Pool disable (v29-v30)
- **1288 files (98.6%)** - final stable baseline

### Transpiler Fixes Applied in v27-v30
1. **Conditional defer destroy conversion**: `allocator.destroy(ptr)` is only converted to
   `_ = ptr.deinit()` when the variable was actually converted to `safe.Box` (v27).

2. **Phase 1 explicit pointer type check**: Variables declared with explicit `*T` or `?*T` type
   are no longer added to `boxed_vars`, preventing false `.ptr` rewrites (v27).

3. **Tuple/struct literal catch-all**: Bare boxed identifiers inside `.{ptr}` or function args
   now get `.ptr` appended (v28).

4. **Scoped import skip**: Files with `const zust = @import("safe")` inside structs are
   returned unchanged to avoid "undeclared identifier" errors (v29).

5. **safe.Pool disable**: `std.heap.page_allocator → safe.Pool` conversion disabled because
   `safe.Pool` is incompatible with `std.mem.Allocator` (v30).

### Remaining 17 Files (1.4%)
These represent fundamental type mismatches that require cross-file changes or complex context-aware rewrites:
- **Struct field type mismatches** (Expr.zig, toml.zig, output_file_jsc.zig): Box created for struct fields
- **Thread spawn / C API** (html_rewriter.zig, napi.zig, path_watcher.zig, rm.zig, c_ares.zig): `*T` expected by external APIs
- **Member function arg errors** (Watcher.zig): `.deinit()` on non-Box types
- **"Never mutated"** (Body.zig): `var` becomes `const`-eligible (Zig stricter checking)
- **Complex generics** (computeCrossChunkDependencies.zig): Generic type incompatibilities
- **Array buffer** (WorkspaceMap.zig): `.deinit()` called on `[1024]u8`
- **Missing struct field** (std_fs_compat.zig): `box` field injected into struct init

### Next Steps
1. 1288 files (98.6%) is the practical ceiling for source-to-source transpilation
2. Remaining 17 files require cross-file type changes or manual refactoring
3. Consider switching from transpiler approach to incremental manual fixes for remaining files
4. Target 1290+ files would require solving struct-field and generic-pattern issues
