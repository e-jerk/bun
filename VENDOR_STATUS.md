# Bun Zust-Port: Vendor Dependency Status Report

## Summary

The zust-port **Zig code compiles successfully** with 0 errors (`zig build obj` and `zig build test`). However, **C++ vendor compilation is blocked by a system toolchain issue** on macOS 26.5 that affects **both the original bun repo and the zust-port equally**.

## What Works

### 1. Zig Compilation (Zust-Port)
- **`zig build obj`**: 0 compilation errors
- **`zig build test`**: 0 compilation errors
- All 1,290 Zig files compile with Zig 0.16 + patched stdlib
- Object file produced: `zig-out/bun-zig.o` (186 MB with debug info + ASAN)

### 2. Build System Configuration
- Bun's TypeScript build scripts (`scripts/build.ts`) configure successfully
- Prebuilt WebKit downloaded: `~/.bun/build-cache/webkit-5488984d20e0dbfe-arm64-debug-asan/`
  - `libJavaScriptCore.a` (1.4 GB)
  - `libWTF.a` (54 MB)
  - `libbmalloc.a` (11 MB)
- Node.js headers downloaded: `~/.bun/build-cache/nodejs-headers-24.3.0/`
- C vendor dependencies compile: **533 object files** produced successfully
  - zlib, brotli, libdeflate, libarchive, cares, picohttpparser, etc.

### 3. Original Bun Repo (bun-zig-last)
- Same C++ toolchain issue confirmed (identical errors)
- `zig build` not directly available (uses TypeScript scripts)
- Vendor directory exists with same deps as zust-port

## What's Blocked

### C++ Compilation Failure

All C++ compilation fails with the same root cause: **macOS 26.5 SDK C++ standard library headers are incompatible with the available compilers**.

#### Compilers Tested

| Compiler | Version | Result |
|----------|---------|--------|
| `/opt/homebrew/opt/llvm@21/bin/clang++` | LLVM 21.1.8 | ❌ `cstddef` cannot find libc++'s `stddef.h` |
| `/usr/bin/clang++` | Apple clang 21.0.0 | ❌ Same header conflict |
| `vendor/zig/zig cc` | Clang 20.1.2 | ❌ CommandLineTools SDK has broken `size_t` definitions |

#### Error Pattern

```
/Applications/Xcode.app/.../c++/v1/cstddef:45:5: error: <cstddef> tried including <stddef.h>
  but didn't find libc++'s <stddef.h> header.
```

or:

```
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/_wchar.h:111:1:
  error: unknown type name 'size_t'
```

#### Root Cause

macOS 26.5 (beta/seed build) has C++ standard library headers where:
1. libc++'s `cstddef` expects its own `stddef.h` to be found first via `#include <stddef.h>`
2. The SDK's `stddef.h` uses `__has_feature(modules)` conditional logic that doesn't work correctly with non-Apple compilers
3. When using `-isysroot`, the compiler resolves to the wrong SDK path (`CommandLineTools` vs `Xcode`)
4. Basic types like `size_t`, `ptrdiff_t` are not defined in the found headers

### Affected Targets

- **PCH**: `pch/root-pch.h.hxx.pch` (precompiled header for all C++ bindings)
- **Highway**: 8 C++ files in `vendor/highway/hwy/`
- **Unified C++ Sources**: 71 `UnifiedSource-*.cpp` files (JSC bindings, WebCore, etc.)
- All targets that depend on these

## What We CAN Measure/Compare

Despite the C++ linking blocker, we can collect meaningful metrics:

### 1. Compile Time
- `zig build obj` timing for zust-port (measurable now)
- Original bun doesn't have `build.zig` for direct comparison, but uses `scripts/build.ts` → ninja

### 2. Object File Size
- Zust-port: `zig-out/bun-zig.o` = **186 MB** (debug build with ASAN)
- Original bun: object file not directly available (different build system)

### 3. Lines of Code
- Original Zig: **710,058 LOC**
- Zust-port: **710,643 LOC** (+585)
- Rust: **978,405 LOC**

### 4. zust Analysis Results
- **216 files** have zust imports
- **148** `zust.Box` usages (pointer safety)
- **306** loop limits (preventing infinite loops)
- **531** null checks (preventing null dereferences)
- **1 real bug caught**: `return error.Null` in `void` function in `deprecated.zig:147`

## Next Steps Options

Since the C++ toolchain issue is system-level and affects both repos equally:

**Option A**: Collect and report the metrics we can measure (compile time, object size, zust analysis, LOC)

**Option B**: Attempt to build in a Linux VM/container where the toolchain might work

**Option C**: Create minimal C++ stub archives to force linking (for binary size comparison only - binary won't run)

**Option D**: Wait for macOS SDK fix or use a different macOS version

## Files Modified for Zust-Port Build

- `build.zig`: Zig 0.16 compatibility + zust module + test setup
- `src/std_fs_compat.zig`: File/Dir/Timer shim for Zig 0.16
- `src/std_io_compat.zig`: Writer shim for Zig 0.16
- `src/std_net_shim.zig`: Network address shim
- `src/array_hash_map_compat.zig`: Managed ArrayHashMap wrapper
- Patched Zig 0.16 stdlib: `macho.zig`, `mem.zig`, `Allocator.zig`, `c.zig`

## Conclusion

The zust-port **Zig code is fully compilable** and ready for comparison. The vendor dependency "fix" is blocked by a **system C++ toolchain incompatibility on macOS 26.5** that is outside the project's control and affects both original and ported code equally.
