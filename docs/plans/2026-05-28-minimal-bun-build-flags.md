# Minimal Bun Build Flags Design

**Date:** 2026-05-28
**Status:** Approved
**Goal:** Make all non-core Bun features optional at compile time to enable smaller, faster builds for specific use cases.

## Problem

Bun is a monolithic runtime that bundles everything into a single binary. For users who only need `bun install`, `bun build`, or `bun test`, the binary includes many features they never use:

- S3 client (AWS signature code, HTTP client)
- Image manipulation (image codecs, resizing)
- Valkey/Redis client
- SQL clients (Postgres, MySQL)
- Archive support (tar/zip via libarchive)
- Parsers (Markdown, JSON5, JSONC, TOML, YAML)
- Cron scheduler
- HTML rewriter (lol-html)
- HTTP/3 (QUIC via lsquic)
- FileSystemRouter, Glob, Terminal, CSRF

These add significant binary bloat and compile time. We want them to be optional.

## Design

### Core vs. Optional Features

**Core features (always compiled):**
- JavaScript runtime (JSC engine)
- Transpiler (JS/TS/JSX/TSX → JS)
- Bundler (JS/CSS/HTML bundling, tree-shaking)
- Package manager (npm install, lockfile, workspaces)
- Test runner (jest-compatible)
- HTTP server (`Bun.serve()`)
- File system (`Bun.file`, `Bun.write`, `Bun.read`, `Bun.UDP`)
- Spawn / Shell (`Bun.spawn`, `Bun.shell`, `Bun.$`)
- Basic crypto (SHA-1/256/512, MD5, MD4, SHA512_256)
- Compression (zlib, gzip, deflate, zstd)
- TCP/UDP sockets (`Bun.connect`, `Bun.listen`, `Bun.udpSocket`)
- FFI (Foreign Function Interface)
- Base64, hex, string utilities
- `Bun.resolve`, `Bun.which`, `Bun.sleepSync`, `Bun.nanoseconds`
- `Bun.argv`, `Bun.cwd`, `Bun.main`, `Bun.origin`, `Bun.env`
- `Bun.inspect`, `Bun.hash`, `Bun.semver`, `Bun.unsafe`
- `Bun.embeddedFiles`, `Bun.enableANSIColors`
- `Bun.indexOfLine`, `Bun.stringWidth`, `Bun.shrink`, `Bun.shellEscape`
- `Bun.openInEditor`, `Bun.registerMacro`, `Bun.mmapFile`
- `Bun.color` (CSS color parsing)
- `Bun.zstdCompress/Decompress` (Sync + async)
- `Bun.deflateSync`, `Bun.gunzipSync`, `Bun.gzipSync`, `Bun.inflateSync`
- `Bun.build` (JS bundler API)
- `Bun.jest` (test runner)
- `Bun.allocUnsafe`

**Optional features (can be disabled at compile time):**

| Feature | Build Flag | Default | Estimated Size Impact |
|---------|-----------|---------|---------------------|
| S3 Client | `enable_s3` | `true` | ~200KB (AWS sigv4) |
| Image manipulation | `enable_image` | `true` | ~500KB (image codecs) |
| Valkey/Redis | `enable_valkey` | `true` | ~100KB (RESP parser) |
| SQL (Postgres/MySQL) | `enable_sql` | `true` | ~300KB (protocol parsers) |
| Archive (tar/zip) | `enable_archive` | `true` | ~200KB (libarchive) |
| Markdown parser | `enable_markdown` | `true` | ~100KB (CommonMark) |
| JSON5 parser | `enable_json5` | `true` | ~50KB |
| JSONC parser | `enable_jsonc` | `true` | ~30KB |
| TOML parser | `enable_toml` | `true` | ~50KB |
| YAML parser | `enable_yaml` | `true` | ~100KB |
| Cron scheduler | `enable_cron` | `true` | ~50KB |
| CSRF | `enable_csrf` | `true` | ~30KB |
| Terminal emulator | `enable_terminal` | `true` | ~100KB |
| FileSystemRouter | `enable_router` | `true` | ~100KB |
| Glob | `enable_glob` | `true` | ~50KB |
| HTTP/3 (QUIC) | `enable_quic` | `true` | ~500KB (lsquic) |
| HTML rewriter (lol-html) | `enable_lolhtml` | `true` | ~200KB |
| Transpiler object | `enable_transpiler` | `true` | ~100KB |
| FFI object | `enable_ffi` | `true` | ~200KB (TinyCC) |

### Build Flag Examples

```bash
# Minimal: disable all heavy features
zig build obj -Denable_s3=false -Denable_image=false -Denable_valkey=false -Denable_sql=false -Denable_quic=false

# Server-only: just runtime + HTTP, no parsers
zig build obj -Denable_s3=false -Denable_image=false -Denable_valkey=false -Denable_sql=false -Denable_markdown=false -Denable_json5=false -Denable_jsonc=false -Denable_toml=false -Denable_yaml=false

# Full build (all features)
zig build obj  # defaults are all true
```

### Implementation Strategy

#### 1. Add flags to `BunBuildOptions` in `build.zig`

Extend the existing `BunBuildOptions` struct with one bool per optional feature. These are already passed through `buildOptionsModule()` which makes them available as compile-time constants via `@import("build_options")`.

#### 2. Conditional compilation in `BunObject.zig`

Wrap each optional feature's `@export` and callback declarations with a compile-time check:

```zig
// Before
pub const Image = toJSLazyPropertyCallback(Bun.getImageConstructor);
// ...
@export(&BunObject.Image, .{ .name = lazyPropertyCallbackName("Image") });

// After
if (build_options.enable_image) {
    pub const Image = toJSLazyPropertyCallback(Bun.getImageConstructor);
    // ...
    @export(&BunObject.Image, .{ .name = lazyPropertyCallbackName("Image") });
}
```

#### 3. Conditional module imports in `src/bun.zig`

Use `@import("build_options")` to conditionally include feature modules:

```zig
const enable_s3 = @import("build_options").enable_s3;
const S3Client = if (enable_s3) @import("runtime/webcore/S3Client.zig") else struct {};
```

#### 4. Stub modules for disabled features

When a feature is disabled, provide a minimal stub that throws a runtime error:

```zig
// src/runtime/api/Image.zig (disabled)
const bun = @import("bun");

pub const js = struct {
    pub fn getConstructor(global: *JSGlobalObject, _: *JSObject) JSValue {
        return global.throw("Bun.Image is not enabled in this build. Recompile with -Denable_image=true", .{});
    }
};
```

#### 5. CLI command filtering

In `src/cli/cli.zig`, conditionally include CLI commands:

```zig
const enable_s3 = @import("build_options").enable_s3;

// Only include S3 commands if S3 is enabled
if (enable_s3) {
    pub const S3Command = @import("s3_command.zig").S3Command;
}
```

### Testing Strategy

1. **Full build** (all features): `zig build obj` — must compile
2. **Minimal build** (no optional features): `zig build obj -Denable_s3=false -Denable_image=false ...` — must compile
3. **Per-feature tests**: For each optional feature, verify it compiles when enabled and is absent when disabled
4. **Runtime test**: Build minimal, run `bun test`, `bun install`, `bun build` — must work

### Risk Analysis

| Risk | Mitigation |
|------|-----------|
| C++ code references disabled features | Use `#ifdef` guards in C++ with same build flags passed through zig translate-c |
| Feature dependencies (e.g., bake uses S3) | Make bake disable dependent features automatically when parent is disabled |
| Code generation (`.classes.ts`) generates bindings for disabled features | Add `@import("build_options")` checks in generated code, or skip generation for disabled features |
| Third-party vendored libs still compiled | Add conditional compilation in vendor build scripts |

## Success Criteria

- `zig build obj` compiles with all features enabled (default)
- `zig build obj -Denable_s3=false -Denable_image=false` compiles with minimal features
- `bun test` passes on minimal build
- `bun install` works on minimal build
- `bun build` works on minimal build
- Binary size reduction: > 20% smaller for minimal build

## Next Steps

1. Create implementation plan
2. Add build flags to `build.zig`
3. Modify `BunObject.zig` to conditionally export features
4. Create stub modules for disabled features
5. Add CI jobs for minimal builds
6. Update documentation

---

## Appendix: Feature Mapping

### BunObject APIs → Build Flags

```
Bun.Image         → enable_image
Bun.S3Client      → enable_s3
Bun.s3            → enable_s3
Bun.ValkeyClient  → enable_valkey
Bun.valkey        → enable_valkey
Bun.Archive       → enable_archive
Bun.markdown      → enable_markdown
Bun.JSON5         → enable_json5
Bun.JSONC         → enable_jsonc
Bun.TOML          → enable_toml
Bun.YAML          → enable_yaml
Bun.cron          → enable_cron
Bun.CSRF          → enable_csrf
Bun.Terminal      → enable_terminal
Bun.FileSystemRouter → enable_router
Bun.Glob          → enable_glob
Bun.Transpiler    → enable_transpiler
Bun.FFI           → enable_ffi
```

### CLI Commands → Build Flags

```
bun s3 (if exists) → enable_s3
bun valkey (if exists) → enable_valkey
```

### Runtime Modules → Build Flags

```
S3Client.zig → enable_s3
Image.zig → enable_image
ValkeyClient.zig → enable_valkey
SQL bindings → enable_sql
Archive.zig → enable_archive
MarkdownObject.zig → enable_markdown
JSONC.zig → enable_jsonc
JSON5.zig → enable_json5
TOML.zig → enable_toml
YAML.zig → enable_yaml
Cron.zig → enable_cron
CSRF.zig → enable_csrf
Terminal.zig → enable_terminal
FileSystemRouter.zig → enable_router
Glob.zig → enable_glob
Transpiler.zig → enable_transpiler
FFI.zig → enable_ffi
```
