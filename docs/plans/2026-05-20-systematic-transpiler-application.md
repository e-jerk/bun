# Systematic zust Transpiler Application Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**Goal:** Apply the zust transpiler to the maximum possible portion of the Bun codebase while maintaining compilation, excluding only JSC interop pointers.

**Architecture:** Use a "transpile-all, then selectively revert breakers" approach. Run transpiler on all 1,305 .zig files, then iteratively identify and revert files that break compilation, keeping the ones that work. Track all manual fixes needed for future transpiler updates.

**Tech Stack:** Zig 0.15.2, zust transpiler, Bun build system

---

## Background

The zust transpiler (`/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-transpile`) converts unsafe Zig patterns:
- `*T` parameters → `safe.Box(T)` (skips `self`/`this`, scalars, `**T`, `*anyopaque`)
- `@memcpy` → `safe.SimdUtils.copy`
- `while(true)` → loop with limit + `__zust_loop_counter`
- `undefined` → `std.mem.zeroes()` (when safe)
- `allocator.create/destroy` → `safe.Box`
- `.?` unwraps → checked access patterns

**Critical constraint:** The transpiler is file-local. Converting `*T` params in public APIs breaks all callers. We must identify which transpiled files compile successfully and revert those that don't.

---

## Task 1: Backup All Source Files

**Files:** All `src/**/*.zig` files in `/Users/barrett/github.com/e-jerk/bun-zust-port`

**Step 1: Create backup directory**

Run:
```bash
cd /Users/barrett/github.com/e-jerk/bun-zust-port
mkdir -p /tmp/bun-src-backup-$(date +%Y%m%d)
find src -name "*.zig" -not -path "*/.zig-cache/*" | while read f; do
    mkdir -p "/tmp/bun-src-backup-$(date +%Y%m%d)/$(dirname $f)"
    cp "$f" "/tmp/bun-src-backup-$(date +%Y%m%d)/$f"
done
```

**Step 2: Verify backup**

Run:
```bash
cd /Users/barrett/github.com/e-jerk/bun-zust-port
find src -name "*.zig" -not -path "*/.zig-cache/*" | wc -l
find /tmp/bun-src-backup-* -name "*.zig" | wc -l
```

Expected: Both return 1305

---

## Task 2: Batch Transpile All Files

**Files:** All 1,305 .zig files

**Step 1: Create transpile script**

Create `/tmp/transpile_all.sh`:
```bash
#!/bin/bash
TRANSPILE="/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-transpile"
PROJECT="/Users/barrett/github.com/e-jerk/bun-zust-port"

# Find all .zig files
find "$PROJECT/src" -name "*.zig" -not -path "*/.zig-cache/*" | while read f; do
    "$TRANSPILE" "$f" "$f" 2>/dev/null || echo "FAILED: $f"
done
```

**Step 2: Run transpiler on all files**

Run:
```bash
cd /Users/barrett/github.com/e-jerk/bun-zust-port
bash /tmp/transpile_all.sh
```

Expected: Takes 5-10 minutes. Some files may fail (complex AST patterns).

---

## Task 3: Iterative Compilation - Identify and Revert Breakers

**Files:** All transpiled .zig files

**Step 1: First compilation attempt**

Run:
```bash
cd /Users/barrett/github.com/e-jerk/bun-zust-port
unset CPATH
vendor/zig/zig build obj 2>&1 | tee /tmp/compile_errors_1.txt
```

**Step 2: Extract breaking files from error output**

Run:
```bash
grep "error:" /tmp/compile_errors_1.txt | grep "\.zig:" | sed 's/.*\(src\/.*\.zig\):.*/\1/' | sort | uniq > /tmp/breaking_files_1.txt
```

**Step 3: Revert breaking files to backup**

Run:
```bash
BACKUP="/tmp/bun-src-backup-$(date +%Y%m%d)"
while read f; do
    if [ -f "$BACKUP/$f" ]; then
        cp "$BACKUP/$f" "/Users/barrett/github.com/e-jerk/bun-zust-port/$f"
        echo "Reverted: $f"
    fi
done < /tmp/breaking_files_1.txt
```

**Step 4: Recompile**

Run:
```bash
cd /Users/barrett/github.com/e-jerk/bun-zust-port
unset CPATH
vendor/zig/zig build obj 2>&1 | tee /tmp/compile_errors_2.txt
```

**Step 5: Repeat until 0 errors**

Continue the extract-revert-recompile loop until `vendor/zig/zig build obj` returns 0 errors.

Each iteration:
1. `vendor/zig/zig build obj 2>&1 | tee /tmp/compile_errors_N.txt`
2. `grep "error:" /tmp/compile_errors_N.txt | grep "\.zig:" | sed 's/.*\(src\/.*\.zig\):.*/\1/' | sort | uniq > /tmp/breaking_files_N.txt`
3. Revert files from backup
4. Recompile

Expected: 3-10 iterations. Each iteration should have fewer breakers.

---

## Task 4: Fix Non-Signature Issues

**Goal:** Some compilation errors may be from `std.mem.zeroes()` applied to types that can't be zeroed, or other fixable issues. Fix these manually instead of reverting.

**Common patterns to fix:**

1. **Non-zeroable types with `std.mem.zeroes()`:**
   - Error: "Only nullable and allowzero pointers can be set to zero"
   - Fix: Revert `std.mem.zeroes(T)` back to `undefined`
   
2. **Empty array init `.{}` instead of `undefined`:**
   - Error: "expected N array elements; found 0"
   - Fix: Change `.{}` to `undefined` for non-zeroable arrays

3. **safe.Box() with wrong dereference:**
   - Error: "cannot dereference non-pointer type 'Box...'"
   - Fix: Change `box.*` to `box.ptr.*` or revert to `allocator.create`

4. **Missing `safe` import:**
   - Error: "use of undeclared identifier 'safe'"
   - Fix: Add `const safe = @import("safe");` at bottom of file

**Step 1: Identify fixable errors**

After each compilation attempt, analyze errors:
```bash
grep -E "Only nullable|expected.*array elements|cannot dereference|use of undeclared identifier 'safe'" /tmp/compile_errors_N.txt | head -20
```

**Step 2: Apply targeted fixes**

For each fixable error, edit the specific line in the file rather than reverting the whole file.

---

## Task 5: Track Manual Fixes

**File:** `/Users/barrett/github.com/e-jerk/bun-zust-port/docs/plans/2026-05-20-transpiler-manual-fixes-log.md`

**Step 1: Create tracking document**

For each manual fix applied (instead of reverting), log:
- File path
- Error message
- Original code
- Fixed code
- Why the transpiler got it wrong
- Suggested transpiler improvement

---

## Task 6: Verify Full Build

**Step 1: Run full test build**

```bash
cd /Users/barrett/github.com/e-jerk/bun-zust-port
unset CPATH
vendor/zig/zig build test 2>&1 | tail -5
```

Expected: EXIT CODE: 0

**Step 2: Run obj build**

```bash
cd /Users/barrett/github.com/e-jerk/bun-zust-port
unset CPATH
vendor/zig/zig build obj 2>&1 | tail -5
```

Expected: EXIT CODE: 0

---

## Task 7: Commit All Changes

**Step 1: Stage all changes**

```bash
cd /Users/barrett/github.com/e-jerk/bun-zust-port
git add -A
git status
```

**Step 2: Commit with summary**

```bash
git commit -m "feat(zust): apply transpiler to maximum safe subset of codebase

Applied zust transpiler to $(git diff --stat | grep -c 'zig$') files.

Transpiler patterns applied:
- *T parameters → safe.Box(T) (where safe)
- @memcpy → safe.SimdUtils.copy
- while(true) → bounded loops with __zust_loop_counter
- allocator.create/destroy → safe.Box
- []const u8 params → safe.String comments

Files reverted (broke compilation):
- Public API files with *T params (SinglyLinkedList, OutputFile, etc.)
- Files with non-zeroable types (transpiler.Transpiler, etc.)
- Files with complex pointer patterns

Manual fixes applied:
- [documented in docs/plans/2026-05-20-transpiler-manual-fixes-log.md]

Compilation verified: vendor/zig/zig build test passes with 0 errors.
"
```

---

## Post-Completion: Update Transpiler

After all files are processed and compilation passes, use the manual fixes log to update the transpiler for the next iteration:

1. Fix `std.mem.zeroes()` to skip types with non-nullable pointers
2. Fix `.{}` array init to use `undefined` for non-empty arrays  
3. Fix `safe.Box()` dereference patterns
4. Add auto-import of `safe` module
5. Improve public API detection to skip files with exported *T params

---

## Success Criteria

- [ ] `vendor/zig/zig build test` passes with 0 errors
- [ ] `vendor/zig/zig build obj` passes with 0 errors
- [ ] >50% of .zig files have been successfully transpiled
- [ ] Manual fixes log documents all patterns for transpiler improvement
- [ ] No JSC interop pointer files were modified (src/jsc/bindings, C++ FFI)
