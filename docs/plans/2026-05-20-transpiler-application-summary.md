# Zust Transpiler Application Summary

## Current Status: 1277 files (97.8%)

**Date:** 2026-05-21
**Commit:** (pending)

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
- **1277 files (97.8%)** - with conditional defer destroy + Phase 1 explicit ptr check (v27)

### Transpiler Fixes Applied in v27
1. **Conditional defer destroy conversion**: `allocator.destroy(ptr)` is only converted to
   `_ = ptr.deinit()` when the variable was actually converted to `safe.Box` (not skipped due
   to explicit pointer type or field assignment).

2. **Phase 1 explicit pointer type check**: Variables declared with explicit `*T` or `?*T` type
   are no longer added to `boxed_vars`, preventing false `.ptr` rewrites and `.deinit()` conversions.

3. **Stricter `isAllocatorMethod`**: Now recognizes compound allocator names like `bun.default_allocator`
   by checking if the prefix contains "allocator".

### Remaining 28 Files (2.2%)
Known categories of remaining failures:
- **Scoped imports** (init_command.zig, codec_gif.zig): `const zust = @import("safe")` inside structs
- **Thread spawn type mismatches** (web_worker.zig, fs_events.zig): `std.Thread.spawn` expects `*T`, gets `Box(T)`
- **Return type mismatches**: Functions returning `*T` with Box variables internally
- **Local variable never mutated** (Body.zig): `var` becomes `const`-eligible after transpilation
- **Struct init patterns** (Expr.zig, Binding.zig): `.ptr` missing on struct initialization
- **Complex generic patterns** (Chunk.zig, interpreter.zig): Generic types with nested Box issues
- **Cross-module type changes** (shell.zig, napi.zig, toml.zig): Fundamental type incompatibilities

### Next Steps
1. Target remaining 28 files individually - many may be fixable with targeted transpiler tweaks
2. Investigate `safe.Pool` vs `std.mem.Allocator` type mismatch in Chunk.zig
3. Fix scoped import issue by moving imports to top-level when safe
4. Consider disabling `safe.Pool` conversion for allocator-returning functions
5. Target 1290+ files (98.8%) as next milestone
