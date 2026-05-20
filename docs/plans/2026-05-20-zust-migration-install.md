# Zust Migration for src/install/ Module

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Migrate four key files in Bun's `src/install/` module to zust memory-safe types, passing `zust-analyze --strictness=high` and compilation with `vendor/zig/zig build test -Dtarget=aarch64-macos-none -Doptimize=Debug -Dcpu=apple_m1`.

**Architecture:** Apply targeted zust patterns (`safe.Box`, `safe.SimdUtils.copy`, null unwrap fixes, loop limits, zero-initialization) to each file, guided by the transpiled versions in `.zust-migrate/src/install/`, while preserving comptime signatures, extern declarations, and high-performance string slices.

**Tech Stack:** Zig 0.15, zust analyzer, zust safe library

---

### Task 1: Analyze and Fix `src/install/lockfile/bun.lockb.zig`

**Files:**
- Modify: `src/install/lockfile/bun.lockb.zig`
- Reference: `.zust-migrate/src/install/lockfile/bun.lockb.zig`

**Step 1: Run zust-analyzer**
Run: `/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze src/install/lockfile/bun.lockb.zig --strictness=high`
Expected: ~640 lines, 31 errors

**Step 2: Check transpiled version**
Read: `.zust-migrate/src/install/lockfile/bun.lockb.zig`
Note actual patterns used.

**Step 3: Apply zust patterns**
- Replace `allocator.create(T)` with `safe.Box(T).init(allocator, default)` where pointer is kept
- Replace `.?` unwraps with `if (opt) |v| v else ...` for non-trivial cases
- Add loop limits to `while (true)` that don't already have them
- Replace `@memcpy` with `safe.SimdUtils.copy` ONLY if it doesn't break compilation
- Replace `var x: T = undefined` with `var x = std.mem.zeroes(T)` for small structs
- DO NOT change: comptime signatures, extern function declarations, string slice parameters in high-performance code

**Step 4: Verify compilation**
Run: `vendor/zig/zig build test -Dtarget=aarch64-macos-none -Doptimize=Debug -Dcpu=apple_m1 2>&1 | grep error`
Expected: No errors (or unrelated errors only)

**Step 5: Re-run zust-analyzer**
Run: `/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze src/install/lockfile/bun.lockb.zig --strictness=high`
Expected: File passes or only false positives remain

---

### Task 2: Analyze and Fix `src/install/PackageManager/security_scanner.zig`

**Files:**
- Modify: `src/install/PackageManager/security_scanner.zig`
- Reference: `.zust-migrate/src/install/PackageManager/security_scanner.zig`

**Step 1: Run zust-analyzer**
Run: `/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze src/install/PackageManager/security_scanner.zig --strictness=high`
Expected: ~1303 lines, 39 errors

**Step 2: Check transpiled version**
Read: `.zust-migrate/src/install/PackageManager/security_scanner.zig`
Note actual patterns used.

**Step 3: Apply zust patterns**
(Same pattern rules as Task 1)

**Step 4: Verify compilation**
Run: `vendor/zig/zig build test -Dtarget=aarch64-macos-none -Doptimize=Debug -Dcpu=apple_m1 2>&1 | grep error`
Expected: No errors (or unrelated errors only)

**Step 5: Re-run zust-analyzer**
Run: `/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze src/install/PackageManager/security_scanner.zig --strictness=high`
Expected: File passes or only false positives remain

---

### Task 3: Analyze and Fix `src/install/lockfile.zig`

**Files:**
- Modify: `src/install/lockfile.zig`
- Reference: `.zust-migrate/src/install/lockfile.zig`

**Step 1: Run zust-analyzer**
Run: `/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze src/install/lockfile.zig --strictness=high`
Expected: Large file, multiple errors

**Step 2: Check transpiled version**
Read: `.zust-migrate/src/install/lockfile.zig`
Note actual patterns used.

**Step 3: Apply zust patterns**
(Same pattern rules as Task 1)

**Step 4: Verify compilation**
Run: `vendor/zig/zig build test -Dtarget=aarch64-macos-none -Doptimize=Debug -Dcpu=apple_m1 2>&1 | grep error`
Expected: No errors (or unrelated errors only)

**Step 5: Re-run zust-analyzer**
Run: `/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze src/install/lockfile.zig --strictness=high`
Expected: File passes or only false positives remain

---

### Task 4: Analyze and Fix `src/install/PackageManager.zig`

**Files:**
- Modify: `src/install/PackageManager.zig`
- Reference: `.zust-migrate/src/install/PackageManager.zig`

**Step 1: Run zust-analyzer**
Run: `/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze src/install/PackageManager.zig --strictness=high`
Expected: Large file, multiple errors

**Step 2: Check transpiled version**
Read: `.zust-migrate/src/install/PackageManager.zig`
Note actual patterns used.

**Step 3: Apply zust patterns**
(Same pattern rules as Task 1)

**Step 4: Verify compilation**
Run: `vendor/zig/zig build test -Dtarget=aarch64-macos-none -Doptimize=Debug -Dcpu=apple_m1 2>&1 | grep error`
Expected: No errors (or unrelated errors only)

**Step 5: Re-run zust-analyzer**
Run: `/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze src/install/PackageManager.zig --strictness=high`
Expected: File passes or only false positives remain

---

### Task 5: Final Summary

Compile all results and provide a summary of:
- Which files were fixed
- What patterns were changed
- Any files that couldn't be fully migrated (and why)
