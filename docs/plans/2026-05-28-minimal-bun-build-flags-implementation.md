# Minimal Bun Build Flags Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make all non-core Bun features (S3, Image, Valkey, SQL, parsers, etc.) optional at compile time via build flags.

**Architecture:** Add boolean flags to `BunBuildOptions` in `build.zig`, expose them via `@import("build_options")`, conditionally compile feature exports in `BunObject.zig`, and create stub modules for disabled features.

**Tech Stack:** Zig 0.16.0, Bun build system (build.zig), conditional compilation via comptime

---

## Phase 1: Foundation — Build Flags and Options Module

### Task 1: Add 20 build flags to `BunBuildOptions` in `build.zig`

**Files:**
- Modify: `build.zig:23-108` (BunBuildOptions struct)
- Modify: `build.zig:234-282` (BunBuildOptions initialization)
- Modify: `build.zig:72-100` (buildOptionsModule)

**Step 1: Add fields to BunBuildOptions struct**

Add these fields to `BunBuildOptions` after line ~277:

```zig
// Feature flags for optional features
enable_s3: bool = true,
enable_image: bool = true,
enable_valkey: bool = true,
enable_sql: bool = true,
enable_archive: bool = true,
enable_markdown: bool = true,
enable_json5: bool = true,
enable_jsonc: bool = true,
enable_toml: bool = true,
enable_yaml: bool = true,
enable_cron: bool = true,
enable_csrf: bool = true,
enable_terminal: bool = true,
enable_router: bool = true,
enable_glob: bool = true,
enable_quic: bool = true,
enable_lolhtml: bool = true,
enable_transpiler: bool = true,
enable_ffi: bool = true,
```

**Step 2: Add option() calls in build.zig initialization**

After line ~278 (`enable_tinycc`), add:

```zig
.enable_s3 = b.option(bool, "enable_s3", "Enable S3 client support") orelse true,
.enable_image = b.option(bool, "enable_image", "Enable Image manipulation support") orelse true,
.enable_valkey = b.option(bool, "enable_valkey", "Enable Valkey/Redis client support") orelse true,
.enable_sql = b.option(bool, "enable_sql", "Enable SQL (Postgres/MySQL) support") orelse true,
.enable_archive = b.option(bool, "enable_archive", "Enable Archive (tar/zip) support") orelse true,
.enable_markdown = b.option(bool, "enable_markdown", "Enable Markdown parser support") orelse true,
.enable_json5 = b.option(bool, "enable_json5", "Enable JSON5 parser support") orelse true,
.enable_jsonc = b.option(bool, "enable_jsonc", "Enable JSONC parser support") orelse true,
.enable_toml = b.option(bool, "enable_toml", "Enable TOML parser support") orelse true,
.enable_yaml = b.option(bool, "enable_yaml", "Enable YAML parser support") orelse true,
.enable_cron = b.option(bool, "enable_cron", "Enable Cron scheduler support") orelse true,
.enable_csrf = b.option(bool, "enable_csrf", "Enable CSRF token support") orelse true,
.enable_terminal = b.option(bool, "enable_terminal", "Enable Terminal emulator support") orelse true,
.enable_router = b.option(bool, "enable_router", "Enable FileSystemRouter support") orelse true,
.enable_glob = b.option(bool, "enable_glob", "Enable Glob support") orelse true,
.enable_quic = b.option(bool, "enable_quic", "Enable HTTP/3 (QUIC) support") orelse true,
.enable_lolhtml = b.option(bool, "enable_lolhtml", "Enable HTML rewriter (lol-html) support") orelse true,
.enable_transpiler = b.option(bool, "enable_transpiler", "Enable Transpiler object support") orelse true,
.enable_ffi = b.option(bool, "enable_ffi", "Enable FFI (TinyCC) support") orelse true,
```

**Step 3: Add options to buildOptionsModule**

In `buildOptionsModule` (after line ~92), add:

```zig
opts.addOption(bool, "enable_s3", this.enable_s3);
opts.addOption(bool, "enable_image", this.enable_image);
opts.addOption(bool, "enable_valkey", this.enable_valkey);
opts.addOption(bool, "enable_sql", this.enable_sql);
opts.addOption(bool, "enable_archive", this.enable_archive);
opts.addOption(bool, "enable_markdown", this.enable_markdown);
opts.addOption(bool, "enable_json5", this.enable_json5);
opts.addOption(bool, "enable_jsonc", this.enable_jsonc);
opts.addOption(bool, "enable_toml", this.enable_toml);
opts.addOption(bool, "enable_yaml", this.enable_yaml);
opts.addOption(bool, "enable_cron", this.enable_cron);
opts.addOption(bool, "enable_csrf", this.enable_csrf);
opts.addOption(bool, "enable_terminal", this.enable_terminal);
opts.addOption(bool, "enable_router", this.enable_router);
opts.addOption(bool, "enable_glob", this.enable_glob);
opts.addOption(bool, "enable_quic", this.enable_quic);
opts.addOption(bool, "enable_lolhtml", this.enable_lolhtml);
opts.addOption(bool, "enable_transpiler", this.enable_transpiler);
opts.addOption(bool, "enable_ffi", this.enable_ffi);
```

**Step 4: Test compilation**

Run: `BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast`
Expected: Compiles successfully (no errors from build.zig changes)

**Step 5: Commit**

```bash
git add build.zig
git commit -m "feat: add 20 build flags for optional features"
```

---

## Phase 2: BunObject — Conditional Exports

### Task 2: Create conditional compilation in `BunObject.zig`

**Files:**
- Modify: `src/runtime/api/BunObject.zig`

**Step 1: Add build_options import**

At the top of `BunObject.zig`, add:
```zig
const build_options = @import("build_options");
```

**Step 2: Wrap optional features in BunObject struct**

For each optional feature, wrap the `pub const` and `@export` in `if (build_options.enable_XXX)`:

For example, for Image:
```zig
if (build_options.enable_image) {
    pub const Image = toJSLazyPropertyCallback(Bun.getImageConstructor);
}
```

And in the export block:
```zig
if (build_options.enable_image) {
    @export(&BunObject.Image, .{ .name = lazyPropertyCallbackName("Image") });
}
```

Apply to all 20 features:
- Image, S3Client, s3, ValkeyClient, valkey, Archive, markdown, JSON5, JSONC, TOML, YAML, cron, CSRF, Terminal, FileSystemRouter, Glob, Transpiler, FFI

**Step 3: Handle conditional callback exports**

For features with `toJSCallback` (not `toJSLazyPropertyCallback`):
```zig
if (build_options.enable_ffi) {
    pub const FFI = toJSLazyPropertyCallback(Bun.FFIObject.getter);
    @export(&BunObject.FFI, .{ .name = lazyPropertyCallbackName("FFI") });
}
```

**Step 4: Test compilation**

Run: `BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast`
Expected: Compiles successfully

Run: `BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast -Denable_s3=false`
Expected: Compiles successfully

**Step 5: Commit**

```bash
git add src/runtime/api/BunObject.zig
git commit -m "feat: conditionally export BunObject APIs based on build flags"
```

---

## Phase 3: Stub Modules for Disabled Features

### Task 3: Create stub modules for disabled features

**Files:**
- Create: `src/runtime/api/Image.zig` (stub)
- Create: `src/runtime/api/S3Client.zig` (stub)
- Create: `src/runtime/api/ValkeyClient.zig` (stub)
- Create: `src/runtime/api/Archive.zig` (stub)
- Create: `src/runtime/api/MarkdownObject.zig` (stub)
- Create: `src/runtime/api/JSON5.zig` (stub)
- Create: `src/runtime/api/JSONC.zig` (stub)
- Create: `src/runtime/api/TOML.zig` (stub)
- Create: `src/runtime/api/YAML.zig` (stub)
- Create: `src/runtime/api/Cron.zig` (stub)
- Create: `src/runtime/api/CSRF.zig` (stub)
- Create: `src/runtime/api/Terminal.zig` (stub)
- Create: `src/runtime/api/FileSystemRouter.zig` (stub)
- Create: `src/runtime/api/Glob.zig` (stub)
- Create: `src/runtime/api/Transpiler.zig` (stub)
- Create: `src/runtime/api/FFI.zig` (stub)
- Create: `src/runtime/api/SQL.zig` (stub)

**Step 1: Create stub module template**

Each stub module should throw a clear error at runtime:

```zig
// src/runtime/api/Image.zig
const jsc = @import("bun").jsc;
const JSValue = jsc.JSValue;
const JSGlobalObject = jsc.JSGlobalObject;
const JSObject = jsc.JSObject;

pub const js = struct {
    pub fn getConstructor(global: *JSGlobalObject, _: *JSObject) JSValue {
        return global.throw("Bun.Image is not available in this build. Recompile with -Denable_image=true", .{});
    }
};
```

**Step 2: Modify existing files to import stubs conditionally**

In `src/bun.zig`, modify imports to use stubs when disabled:

```zig
const Image = if (build_options.enable_image) @import("runtime/api/Image.zig") else @import("runtime/api/Image_stub.zig");
```

**Step 3: Test compilation**

Run: `BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast -Denable_s3=false -Denable_image=false`
Expected: Compiles successfully

**Step 4: Commit**

```bash
git add src/runtime/api/*_stub.zig
git commit -m "feat: add stub modules for disabled features"
```

---

## Phase 4: Conditional Module Imports

### Task 4: Modify `src/bun.zig` to conditionally import modules

**Files:**
- Modify: `src/bun.zig`

**Step 1: Add build_options import**

```zig
const build_options = @import("build_options");
```

**Step 2: Conditionally import runtime modules**

Find all imports of optional feature modules and make them conditional:

```zig
// Before
const S3Client = @import("runtime/webcore/S3Client.zig");

// After
const S3Client = if (build_options.enable_s3) @import("runtime/webcore/S3Client.zig") else struct {};
```

**Step 3: Conditionally import CLI modules**

In `src/cli/cli.zig`, make CLI commands conditional:
```zig
const S3Command = if (build_options.enable_s3) @import("s3_command.zig").S3Command else struct {};
```

**Step 4: Test compilation**

Run: `BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast`
Run: `BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast -Denable_s3=false -Denable_image=false -Denable_valkey=false -Denable_sql=false`
Expected: Both compile successfully

**Step 5: Commit**

```bash
git add src/bun.zig src/cli/cli.zig
git commit -m "feat: conditionally import modules based on build flags"
```

---

## Phase 5: Core Feature Verification

### Task 5: Verify core features always compile

**Step 1: Test full build (all features enabled)**

```bash
BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast
```
Expected: Exit code 0, produces `zig-out/bun-zig.o`

**Step 2: Test minimal build (all optional features disabled)**

```bash
BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast \
  -Denable_s3=false \
  -Denable_image=false \
  -Denable_valkey=false \
  -Denable_sql=false \
  -Denable_archive=false \
  -Denable_markdown=false \
  -Denable_json5=false \
  -Denable_jsonc=false \
  -Denable_toml=false \
  -Denable_yaml=false \
  -Denable_cron=false \
  -Denable_csrf=false \
  -Denable_terminal=false \
  -Denable_router=false \
  -Denable_glob=false \
  -Denable_quic=false \
  -Denable_lolhtml=false \
  -Denable_transpiler=false \
  -Denable_ffi=false
```
Expected: Exit code 0, produces `zig-out/bun-zig.o`

**Step 3: Compare binary sizes**

```bash
ls -lh zig-out/bun-zig.o  # full build
ls -lh zig-out/bun-zig.o  # minimal build
```
Expected: Minimal build is >20% smaller

**Step 4: Commit test results**

```bash
git commit -m "test: verify minimal build compiles and produces smaller binary"
```

---

## Phase 6: Documentation

### Task 6: Update README with build flag documentation

**Files:**
- Modify: `README.md` or `CLAUDE.md`

**Step 1: Add build flags section to documentation**

Add a section:
```markdown
### Optional Build Flags

Bun supports optional features that can be disabled at compile time:

```bash
# Disable all heavy features
zig build obj -Denable_s3=false -Denable_image=false -Denable_valkey=false

# Server-only build (no parsers)
zig build obj -Denable_s3=false -Denable_image=false -Denable_markdown=false -Denable_json5=false
```

| Flag | Feature | Default |
|------|---------|---------|
| `enable_s3` | S3 client | `true` |
| `enable_image` | Image manipulation | `true` |
| `enable_valkey` | Valkey/Redis client | `true` |
| `enable_sql` | SQL (Postgres/MySQL) | `true` |
| `enable_archive` | Archive (tar/zip) | `true` |
| `enable_markdown` | Markdown parser | `true` |
| `enable_json5` | JSON5 parser | `true` |
| `enable_jsonc` | JSONC parser | `true` |
| `enable_toml` | TOML parser | `true` |
| `enable_yaml` | YAML parser | `true` |
| `enable_cron` | Cron scheduler | `true` |
| `enable_csrf` | CSRF tokens | `true` |
| `enable_terminal` | Terminal emulator | `true` |
| `enable_router` | FileSystemRouter | `true` |
| `enable_glob` | Glob patterns | `true` |
| `enable_quic` | HTTP/3 (QUIC) | `true` |
| `enable_lolhtml` | HTML rewriter | `true` |
| `enable_transpiler` | Transpiler object | `true` |
| `enable_ffi` | FFI (TinyCC) | `true` |
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: document optional build flags"
```

---

## Phase 7: CI Integration

### Task 7: Add CI job for minimal build

**Files:**
- Modify: `.github/workflows/ci.yml` (if exists)

**Step 1: Add minimal build step**

Add a CI job that builds with minimal features:
```yaml
- name: Build Minimal
  run: |
    BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast \
      -Denable_s3=false \
      -Denable_image=false \
      -Denable_valkey=false \
      -Denable_sql=false \
      -Denable_archive=false \
      -Denable_markdown=false \
      -Denable_json5=false \
      -Denable_jsonc=false \
      -Denable_toml=false \
      -Denable_yaml=false \
      -Denable_cron=false \
      -Denable_csrf=false \
      -Denable_terminal=false \
      -Denable_router=false \
      -Denable_glob=false \
      -Denable_quic=false \
      -Denable_lolhtml=false \
      -Denable_transpiler=false \
      -Denable_ffi=false
```

**Step 2: Commit**

```bash
git commit -m "ci: add minimal build test to CI"
```

---

## Final Verification

### Task 8: Full test suite

**Step 1: Run all builds**
```bash
# Full build
BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast

# Minimal build
BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast -Denable_s3=false -Denable_image=false -Denable_valkey=false -Denable_sql=false

# Partial build (disable some)
BUN_ZIG_PATH=custom_zig ./custom_zig/zig build obj -Doptimize=ReleaseFast -Denable_s3=false -Denable_image=false
```

**Step 2: Push to GitHub**
```bash
git push origin zust
```

---

## Summary

| Phase | Tasks | Estimated Time |
|-------|-------|---------------|
| 1. Build flags | 1 | 30 min |
| 2. BunObject exports | 2 | 60 min |
| 3. Stub modules | 3 | 90 min |
| 4. Conditional imports | 4 | 60 min |
| 5. Verification | 5 | 30 min |
| 6. Documentation | 6 | 15 min |
| 7. CI | 7 | 15 min |
| 8. Final | 8 | 30 min |
| **Total** | 8 | **~5.5 hours** |

**Key files to touch:**
- `build.zig` (add flags)
- `src/runtime/api/BunObject.zig` (conditional exports)
- `src/bun.zig` (conditional imports)
- `src/cli/cli.zig` (conditional CLI commands)
- `src/runtime/api/*_stub.zig` (17 stub files)
- `CLAUDE.md` (documentation)

**Risk:**
- C++ bindings may reference disabled features. Need to add guards in `src/jsc/bindings/BunObject.cpp` or regenerate classes.
- Code generation may produce references to disabled features. Need to skip generation for disabled features.
- Some features may have dependencies (e.g., bake uses S3). Need to handle cascading disables.

**Mitigation:**
- Start with features that are clearly standalone (Image, S3, Valkey, SQL)
- Test each feature individually
- Use `if (build_options.enable_XXX)` at the highest level possible to avoid deep changes
