# Zust Transpiler Application Summary

## Current Status: 830 files (63.6%)

**Date:** 2026-05-20
**Commit:** b8bb3b421

### Milestones
- 128 files (9.8%) - initial conservative pass
- 266 files (20.4%) - conservative transpiler v2
- 316 files (24.2%) - with OffsetPtr + allocator.create fixes
- 580 files (44.4%) - with scoped import fix + reverted cross-file changes
- 688 files (52.7%) - with body-only rewrites + safe alias detection
- 712 files (54.6%) - with tuple fix + false-positive create fix
- 809 files (62.0%) - with stricter matching + shadowing detection (v19)
- **830 files (63.6%)** - with recursive arg checking + nested fn exclusion (v23)

### Transpiler Fixes Applied in v23
1. **Recursive argument checking in variable tracking**: `bun.handleOom(allocator.create(T))`
   now correctly tracks the resulting variable as a Box, enabling `.ptr` rewrites on all usages.

2. **Nested function body exclusion**: When processing a parent function body that contains
   struct definitions with methods (e.g., `fn Foo() type { return struct { pub fn init() {...} }; }`),
   the transpiler now skips identifiers and destroy calls inside nested method bodies.
   Prevents false `.ptr` rewrites on unrelated parameters like `this`.

3. **Smarter shadowing detection**: Only disables tracking for names that appear in BOTH
   Box-pattern and non-Box declarations. Multiple Box declarations of the same name
   (e.g., `const task` declared twice with `allocator.create`) are still tracked.

### Remaining Barriers to 80-90%
- **Struct field assignments**: `allocator.create(T)` result stored in struct fields causes
  type mismatches. Would require cross-file type changes (disabled).
- **Scoped imports**: Files with `const zust = @import("safe")` inside structs fail when
  generated code references `zust` outside the struct scope.
- **Return type mismatches**: Functions returning `*T` that create Box variables internally
  can't be fixed without changing the return type (cross-file change).
- **Local variable never mutated**: Some `var` declarations become `const`-eligible after
  transpilation (Zig compiler stricter about unused mutability).

### Next Steps
1. Fix scoped import issue by moving imports to top-level when safe
2. Identify leaf modules vs core modules to avoid cascading reverts
3. Consider skipping `allocator.create` conversions for struct field assignments
4. Target 850+ files (65%) as next milestone
