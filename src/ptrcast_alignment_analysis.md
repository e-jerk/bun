# @ptrCast Alignment Analysis - All 614 Instances

Generated: Analysis of all `// safe-transpile: @ptrCast requires manual review` comments

## Summary

- **YES (auto-fixable):** 247
- **NO (not auto-fixable):** 293
- **REVIEW (needs manual check):** 70
- **UNKNOWN:** 4

## Category: YES (247 items)

### 1. `bun.zig:1296`

**Code:**
```zig
zust-port/src/bun.zig-1297-    @memset(@as([*]u8, @ptrCast(&out))[0..out.len], 0);
```

**Source Analysis:** address-of operator (guaranteed aligned): &out

**Auto-fixable:** True

**Action:** Replace @ptrCast(&out) with @ptrCast(@alignCast(&out))

---

### 2. `bun.zig:1737`

**Code:**
```zig
zust-port/src/bun.zig-1738-    const newargv = @as([*:null]?[*:0]const u8, @ptrCast(dupe_argv.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): dupe_argv.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(dupe_argv.ptr) with @ptrCast(@alignCast(dupe_argv.ptr))

---

### 3. `bun.zig:1741`

**Code:**
```zig
zust-port/src/bun.zig-1742-    const envp = @as([*:null]?[*:0]const u8, @ptrCast(environ.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): environ.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(environ.ptr) with @ptrCast(@alignCast(environ.ptr))

---

### 4. `bun.zig:2401`

**Code:**
```zig
zust-port/src/bun.zig-2402-    const result: *T = @ptrCast(&zeroed);
```

**Source Analysis:** address-of operator (guaranteed aligned): &zeroed

**Auto-fixable:** True

**Action:** Replace @ptrCast(&zeroed) with @ptrCast(@alignCast(&zeroed))

---

### 5. `bun.zig:2413`

**Code:**
```zig
zust-port/src/bun.zig-2414-    const result: *T = @ptrCast(&zeroed);
```

**Source Analysis:** address-of operator (guaranteed aligned): &zeroed

**Auto-fixable:** True

**Action:** Replace @ptrCast(&zeroed) with @ptrCast(@alignCast(&zeroed))

---

### 6. `zlib/zlib.zig:489`

**Code:**
```zig
zust-port/src/zlib/zlib.zig-490-                this.zlib.next_out = @ptrCast(&this.list.items[initial]);
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.list.items[initial]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.list.items[initial]) with @ptrCast(@alignCast(&this.list.items[initial]))

---

### 7. `zlib/zlib.zig:939`

**Code:**
```zig
zust-port/src/zlib/zlib.zig-940-                this.zlib.next_out = @ptrCast(&this.list.items[initial]);
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.list.items[initial]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.list.items[initial]) with @ptrCast(@alignCast(&this.list.items[initial]))

---

### 8. `tcc_sys/tcc.zig:314`

**Code:**
```zig
zust-port/src/tcc_sys/tcc.zig-315-        return @ptrCast(tcc_get_symbol(s, name.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): tcc_get_symbol(s, name.ptr)

**Auto-fixable:** True

**Action:** Replace @ptrCast(tcc_get_symbol(s, name.ptr)) with @ptrCast(@alignCast(tcc_get_symbol(s, name.ptr)))

---

### 9. `brotli/brotli.zig:127`

**Code:**
```zig
zust-port/src/brotli/brotli.zig-128-                @ptrCast(&next_in),
```

**Source Analysis:** address-of operator (guaranteed aligned): &next_in

**Auto-fixable:** True

**Action:** Replace @ptrCast(&next_in) with @ptrCast(@alignCast(&next_in))

---

### 10. `brotli/brotli.zig:130`

**Code:**
```zig
zust-port/src/brotli/brotli.zig-131-                @ptrCast(&unused_capacity.ptr),
```

**Source Analysis:** address-of operator (guaranteed aligned): &unused_capacity.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&unused_capacity.ptr) with @ptrCast(@alignCast(&unused_capacity.ptr))

---

### 11. `runtime/socket/socket.zig:2178`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2179-        .onOpen = @ptrCast(&DuplexUpgradeContext.onOpen),
```

**Source Analysis:** address-of operator (guaranteed aligned): &DuplexUpgradeContext.onOpen

**Auto-fixable:** True

**Action:** Replace @ptrCast(&DuplexUpgradeContext.onOpen) with @ptrCast(@alignCast(&DuplexUpgradeContext.onOpen))

---

### 12. `runtime/socket/socket.zig:2180`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2181-        .onData = @ptrCast(&DuplexUpgradeContext.onData),
```

**Source Analysis:** address-of operator (guaranteed aligned): &DuplexUpgradeContext.onData

**Auto-fixable:** True

**Action:** Replace @ptrCast(&DuplexUpgradeContext.onData) with @ptrCast(@alignCast(&DuplexUpgradeContext.onData))

---

### 13. `runtime/socket/socket.zig:2182`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2183-        .onHandshake = @ptrCast(&DuplexUpgradeContext.onHandshake),
```

**Source Analysis:** address-of operator (guaranteed aligned): &DuplexUpgradeContext.onHandshake

**Auto-fixable:** True

**Action:** Replace @ptrCast(&DuplexUpgradeContext.onHandshake) with @ptrCast(@alignCast(&DuplexUpgradeContext.onHandshake))

---

### 14. `runtime/socket/socket.zig:2184`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2185-        .onClose = @ptrCast(&DuplexUpgradeContext.onClose),
```

**Source Analysis:** address-of operator (guaranteed aligned): &DuplexUpgradeContext.onClose

**Auto-fixable:** True

**Action:** Replace @ptrCast(&DuplexUpgradeContext.onClose) with @ptrCast(@alignCast(&DuplexUpgradeContext.onClose))

---

### 15. `runtime/socket/socket.zig:2186`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2187-        .onEnd = @ptrCast(&DuplexUpgradeContext.onEnd),
```

**Source Analysis:** address-of operator (guaranteed aligned): &DuplexUpgradeContext.onEnd

**Auto-fixable:** True

**Action:** Replace @ptrCast(&DuplexUpgradeContext.onEnd) with @ptrCast(@alignCast(&DuplexUpgradeContext.onEnd))

---

### 16. `runtime/socket/socket.zig:2188`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2189-        .onWritable = @ptrCast(&DuplexUpgradeContext.onWritable),
```

**Source Analysis:** address-of operator (guaranteed aligned): &DuplexUpgradeContext.onWritable

**Auto-fixable:** True

**Action:** Replace @ptrCast(&DuplexUpgradeContext.onWritable) with @ptrCast(@alignCast(&DuplexUpgradeContext.onWritable))

---

### 17. `runtime/socket/socket.zig:2190`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2191-        .onError = @ptrCast(&DuplexUpgradeContext.onError),
```

**Source Analysis:** address-of operator (guaranteed aligned): &DuplexUpgradeContext.onError

**Auto-fixable:** True

**Action:** Replace @ptrCast(&DuplexUpgradeContext.onError) with @ptrCast(@alignCast(&DuplexUpgradeContext.onError))

---

### 18. `runtime/socket/socket.zig:2192`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2193-        .onTimeout = @ptrCast(&DuplexUpgradeContext.onTimeout),
```

**Source Analysis:** address-of operator (guaranteed aligned): &DuplexUpgradeContext.onTimeout

**Auto-fixable:** True

**Action:** Replace @ptrCast(&DuplexUpgradeContext.onTimeout) with @ptrCast(@alignCast(&DuplexUpgradeContext.onTimeout))

---

### 19. `aio/posix_event_loop.zig:1309`

**Code:**
```zig
zust-port/src/aio/posix_event_loop.zig-1310-        _ = std.posix.read(this.fd.cast(), @as(*[8]u8, @ptrCast(&bytes))) catch 0;
```

**Source Analysis:** address-of operator (guaranteed aligned): &bytes

**Auto-fixable:** True

**Action:** Replace @ptrCast(&bytes) with @ptrCast(@alignCast(&bytes))

---

### 20. `aio/posix_event_loop.zig:1317`

**Code:**
```zig
zust-port/src/aio/posix_event_loop.zig-1318-            @as(*[8]u8, @ptrCast(&bytes)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &bytes

**Auto-fixable:** True

**Action:** Replace @ptrCast(&bytes) with @ptrCast(@alignCast(&bytes))

---

### 21. `cli/install_command.zig:48`

**Code:**
```zig
zust-port/src/cli/install_command.zig-49-            .onFetch = @ptrCast(&Analyzer.onAnalyze),
```

**Source Analysis:** address-of operator (guaranteed aligned): &Analyzer.onAnalyze

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Analyzer.onAnalyze) with @ptrCast(@alignCast(&Analyzer.onAnalyze))

---

### 22. `runtime/socket/WindowsNamedPipeContext.zig:193`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-194-        .ref_ctx = @ptrCast(&WindowsNamedPipeContext.ref),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.ref

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.ref) with @ptrCast(@alignCast(&WindowsNamedPipeContext.ref))

---

### 23. `runtime/socket/WindowsNamedPipeContext.zig:195`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-196-        .deref_ctx = @ptrCast(&WindowsNamedPipeContext.deref),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.deref

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.deref) with @ptrCast(@alignCast(&WindowsNamedPipeContext.deref))

---

### 24. `runtime/socket/WindowsNamedPipeContext.zig:197`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-198-        .onOpen = @ptrCast(&WindowsNamedPipeContext.onOpen),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.onOpen

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.onOpen) with @ptrCast(@alignCast(&WindowsNamedPipeContext.onOpen))

---

### 25. `runtime/socket/WindowsNamedPipeContext.zig:199`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-200-        .onData = @ptrCast(&WindowsNamedPipeContext.onData),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.onData

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.onData) with @ptrCast(@alignCast(&WindowsNamedPipeContext.onData))

---

### 26. `runtime/socket/WindowsNamedPipeContext.zig:201`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-202-        .onHandshake = @ptrCast(&WindowsNamedPipeContext.onHandshake),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.onHandshake

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.onHandshake) with @ptrCast(@alignCast(&WindowsNamedPipeContext.onHandshake))

---

### 27. `runtime/socket/WindowsNamedPipeContext.zig:203`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-204-        .onEnd = @ptrCast(&WindowsNamedPipeContext.onEnd),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.onEnd

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.onEnd) with @ptrCast(@alignCast(&WindowsNamedPipeContext.onEnd))

---

### 28. `runtime/socket/WindowsNamedPipeContext.zig:205`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-206-        .onWritable = @ptrCast(&WindowsNamedPipeContext.onWritable),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.onWritable

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.onWritable) with @ptrCast(@alignCast(&WindowsNamedPipeContext.onWritable))

---

### 29. `runtime/socket/WindowsNamedPipeContext.zig:207`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-208-        .onError = @ptrCast(&WindowsNamedPipeContext.onError),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.onError

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.onError) with @ptrCast(@alignCast(&WindowsNamedPipeContext.onError))

---

### 30. `runtime/socket/WindowsNamedPipeContext.zig:209`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-210-        .onTimeout = @ptrCast(&WindowsNamedPipeContext.onTimeout),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.onTimeout

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.onTimeout) with @ptrCast(@alignCast(&WindowsNamedPipeContext.onTimeout))

---

### 31. `runtime/socket/WindowsNamedPipeContext.zig:211`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipeContext.zig-212-        .onClose = @ptrCast(&WindowsNamedPipeContext.onClose),
```

**Source Analysis:** address-of operator (guaranteed aligned): &WindowsNamedPipeContext.onClose

**Auto-fixable:** True

**Action:** Replace @ptrCast(&WindowsNamedPipeContext.onClose) with @ptrCast(@alignCast(&WindowsNamedPipeContext.onClose))

---

### 32. `cli/run_command.zig:630`

**Code:**
```zig
zust-port/src/cli/run_command.zig-631-            @ptrCast(&temp_path_buffer),
```

**Source Analysis:** address-of operator (guaranteed aligned): &temp_path_buffer

**Auto-fixable:** True

**Action:** Replace @ptrCast(&temp_path_buffer) with @ptrCast(@alignCast(&temp_path_buffer))

---

### 33. `cli/run_command.zig:660`

**Code:**
```zig
zust-port/src/cli/run_command.zig-661-            var argv0 = @as([*:0]const u8, @ptrCast(optional_bun_path.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): optional_bun_path.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(optional_bun_path.ptr) with @ptrCast(@alignCast(optional_bun_path.ptr))

---

### 34. `cli/run_command.zig:720`

**Code:**
```zig
zust-port/src/cli/run_command.zig-721-                @ptrCast(&target_path_buffer[prefix.len]),
```

**Source Analysis:** address-of operator (guaranteed aligned): &target_path_buffer[prefix.len]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&target_path_buffer[prefix.len]) with @ptrCast(@alignCast(&target_path_buffer[prefix.len]))

---

### 35. `cli/run_command.zig:756`

**Code:**
```zig
zust-port/src/cli/run_command.zig-757-                if (bun.windows.CreateHardLinkW(@ptrCast(file_slice.ptr), image_path.ptr, null) == 0) {
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): file_slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(file_slice.ptr) with @ptrCast(@alignCast(file_slice.ptr))

---

### 36. `cli/run_command.zig:768`

**Code:**
```zig
zust-port/src/cli/run_command.zig-769-                            if (bun.windows.CreateHardLinkW(@ptrCast(file_slice.ptr), image_path.ptr, null) == 0) {
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): file_slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(file_slice.ptr) with @ptrCast(@alignCast(file_slice.ptr))

---

### 37. `runtime/socket/WindowsNamedPipe.zig:565`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipe.zig-566-        .code = @ptrCast(this.ssl_error.code.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): this.ssl_error.code.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(this.ssl_error.code.ptr) with @ptrCast(@alignCast(this.ssl_error.code.ptr))

---

### 38. `runtime/socket/WindowsNamedPipe.zig:567`

**Code:**
```zig
zust-port/src/runtime/socket/WindowsNamedPipe.zig-568-        .reason = @ptrCast(this.ssl_error.reason.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): this.ssl_error.reason.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(this.ssl_error.reason.ptr) with @ptrCast(@alignCast(this.ssl_error.reason.ptr))

---

### 39. `bun_core/fmt.zig:280`

**Code:**
```zig
zust-port/src/bun_core/fmt.zig-281-                bun.default_allocator.destroy(@as(*SharedTempBuffer, @ptrCast(chunk.ptr)));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): chunk.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(chunk.ptr) with @ptrCast(@alignCast(chunk.ptr))

---

### 40. `bun_core/fmt.zig:284`

**Code:**
```zig
zust-port/src/bun_core/fmt.zig-285-            shared_temp_buffer_ptr = @ptrCast(chunk.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): chunk.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(chunk.ptr) with @ptrCast(@alignCast(chunk.ptr))

---

### 41. `bun_core/fmt.zig:308`

**Code:**
```zig
zust-port/src/bun_core/fmt.zig-309-                bun.default_allocator.destroy(@as(*SharedTempBuffer, @ptrCast(chunk.ptr)));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): chunk.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(chunk.ptr) with @ptrCast(@alignCast(chunk.ptr))

---

### 42. `bun_core/fmt.zig:312`

**Code:**
```zig
zust-port/src/bun_core/fmt.zig-313-            shared_temp_buffer_ptr = @ptrCast(chunk.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): chunk.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(chunk.ptr) with @ptrCast(@alignCast(chunk.ptr))

---

### 43. `bun_core/fmt.zig:476`

**Code:**
```zig
zust-port/src/bun_core/fmt.zig-477-                bun.default_allocator.destroy(@as(*SharedTempBuffer, @ptrCast(chunk.ptr)));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): chunk.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(chunk.ptr) with @ptrCast(@alignCast(chunk.ptr))

---

### 44. `bun_core/fmt.zig:480`

**Code:**
```zig
zust-port/src/bun_core/fmt.zig-481-            shared_temp_buffer_ptr = @ptrCast(chunk.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): chunk.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(chunk.ptr) with @ptrCast(@alignCast(chunk.ptr))

---

### 45. `bun_core/fmt.zig:1710`

**Code:**
```zig
zust-port/src/bun_core/fmt.zig-1711-        const len = bun.cpp.WTF__dtoa(@ptrCast(buf.ptr), number);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf.ptr) with @ptrCast(@alignCast(buf.ptr))

---

### 46. `bun_core/fmt.zig:1720`

**Code:**
```zig
zust-port/src/bun_core/fmt.zig-1721-        const len = bun.cpp.WTF__dtoa(@ptrCast(buf.ptr), number);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf.ptr) with @ptrCast(@alignCast(buf.ptr))

---

### 47. `runtime/socket/UpgradedDuplex.zig:441`

**Code:**
```zig
zust-port/src/runtime/socket/UpgradedDuplex.zig-442-        .code = @ptrCast(this.ssl_error.code.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): this.ssl_error.code.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(this.ssl_error.code.ptr) with @ptrCast(@alignCast(this.ssl_error.code.ptr))

---

### 48. `runtime/socket/UpgradedDuplex.zig:443`

**Code:**
```zig
zust-port/src/runtime/socket/UpgradedDuplex.zig-444-        .reason = @ptrCast(this.ssl_error.reason.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): this.ssl_error.reason.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(this.ssl_error.reason.ptr) with @ptrCast(@alignCast(this.ssl_error.reason.ptr))

---

### 49. `event_loop/AutoFlusher.zig:22`

**Code:**
```zig
zust-port/src/event_loop/AutoFlusher.zig-23-    bun.assert(!vm.eventLoop().deferred_tasks.postTask(this, @ptrCast(&Type.onAutoFlush)));
```

**Source Analysis:** address-of operator (guaranteed aligned): &Type.onAutoFlush

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Type.onAutoFlush) with @ptrCast(@alignCast(&Type.onAutoFlush))

---

### 50. `cli/create_command.zig:1683`

**Code:**
```zig
zust-port/src/cli/create_command.zig-1684-            .onFetch = @ptrCast(&Analyzer.onAnalyze),
```

**Source Analysis:** address-of operator (guaranteed aligned): &Analyzer.onAnalyze

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Analyzer.onAnalyze) with @ptrCast(@alignCast(&Analyzer.onAnalyze))

---

### 51. `std_fs_compat.zig:258`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-259-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 52. `std_fs_compat.zig:267`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-268-                    const rc = std.c.mkdirat(self.fd, @as([*:0]u8, @ptrCast(&buf)), 0o755);
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 53. `std_fs_compat.zig:299`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-300-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 54. `std_fs_compat.zig:333`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-334-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 55. `std_fs_compat.zig:346`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-347-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 56. `std_fs_compat.zig:387`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-388-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 57. `std_fs_compat.zig:406`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-407-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 58. `std_fs_compat.zig:420`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-421-        const dirz = @as([*:0]u8, @ptrCast(&dir_buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &dir_buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&dir_buf) with @ptrCast(@alignCast(&dir_buf))

---

### 59. `std_fs_compat.zig:430`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-431-        const namez = @as([*:0]u8, @ptrCast(&name_buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &name_buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&name_buf) with @ptrCast(@alignCast(&name_buf))

---

### 60. `std_fs_compat.zig:461`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-462-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 61. `std_fs_compat.zig:482`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-483-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 62. `std_fs_compat.zig:505`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-506-        const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 63. `std_fs_compat.zig:692`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-693-    const pathz = @as([*:0]u8, @ptrCast(&buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 64. `std_fs_compat.zig:727`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-728-    const value = std.c.getenv(@ptrCast(key.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): key.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(key.ptr) with @ptrCast(@alignCast(key.ptr))

---

### 65. `main_wasm.zig:467`

**Code:**
```zig
zust-port/src/main_wasm.zig-468-    parser.analyze(&anaylzer, @ptrCast(&TestAnalyzer.visitParts)) catch |err| {
```

**Source Analysis:** address-of operator (guaranteed aligned): &TestAnalyzer.visitParts

**Auto-fixable:** True

**Action:** Replace @ptrCast(&TestAnalyzer.visitParts) with @ptrCast(@alignCast(&TestAnalyzer.visitParts))

---

### 66. `runtime/socket/SocketAddress.zig:606`

**Code:**
```zig
zust-port/src/runtime/socket/SocketAddress.zig-607-        const addr_src: *const anyopaque = if (self.family() == AF.INET) @ptrCast(&self.sin.addr) else @ptrCast(&self.sin6.addr);
```

**Source Analysis:** address-of operator (guaranteed aligned): &self.sin.addr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&self.sin.addr) with @ptrCast(@alignCast(&self.sin.addr))

---

### 67. `runtime/socket/tls_socket_functions.zig:172`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-173-    const size = BoringSSL.SSL_get_finished(ssl_ptr, @as(*anyopaque, @ptrCast(&dummy)), @sizeOf(@TypeOf(dummy)));
```

**Source Analysis:** address-of operator (guaranteed aligned): &dummy

**Auto-fixable:** True

**Action:** Replace @ptrCast(&dummy) with @ptrCast(@alignCast(&dummy))

---

### 68. `runtime/socket/tls_socket_functions.zig:179`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-180-    const buffer_ptr = @as(*anyopaque, @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buffer.asArrayBuffer(globalObject).?.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr) with @ptrCast(@alignCast(buffer.asArrayBuffer(globalObject).?.ptr))

---

### 69. `runtime/socket/tls_socket_functions.zig:317`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-318-    const size = BoringSSL.SSL_get_peer_finished(ssl_ptr, @as(*anyopaque, @ptrCast(&dummy)), @sizeOf(@TypeOf(dummy)));
```

**Source Analysis:** address-of operator (guaranteed aligned): &dummy

**Auto-fixable:** True

**Action:** Replace @ptrCast(&dummy) with @ptrCast(@alignCast(&dummy))

---

### 70. `runtime/socket/tls_socket_functions.zig:324`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-325-    const buffer_ptr = @as(*anyopaque, @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buffer.asArrayBuffer(globalObject).?.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr) with @ptrCast(@alignCast(buffer.asArrayBuffer(globalObject).?.ptr))

---

### 71. `runtime/socket/tls_socket_functions.zig:375`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-376-            const buffer_ptr = @as([*c]u8, @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buffer.asArrayBuffer(globalObject).?.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr) with @ptrCast(@alignCast(buffer.asArrayBuffer(globalObject).?.ptr))

---

### 72. `runtime/socket/tls_socket_functions.zig:378`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-379-            const result = BoringSSL.SSL_export_keying_material(ssl_ptr, buffer_ptr, buffer_size, @as([*c]const u8, @ptrCast(label_slice.ptr)), label_slice.len, @as([*c]const u8, @ptrCast(context_slice.ptr)), context_slice.len, 1);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): label_slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(label_slice.ptr) with @ptrCast(@alignCast(label_slice.ptr))

---

### 73. `runtime/socket/tls_socket_functions.zig:391`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-392-        const buffer_ptr = @as([*c]u8, @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buffer.asArrayBuffer(globalObject).?.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr) with @ptrCast(@alignCast(buffer.asArrayBuffer(globalObject).?.ptr))

---

### 74. `runtime/socket/tls_socket_functions.zig:394`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-395-        const result = BoringSSL.SSL_export_keying_material(ssl_ptr, buffer_ptr, buffer_size, @as([*c]const u8, @ptrCast(label_slice.ptr)), label_slice.len, null, 0, 0);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): label_slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(label_slice.ptr) with @ptrCast(@alignCast(label_slice.ptr))

---

### 75. `runtime/socket/tls_socket_functions.zig:494`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-495-    var buffer_ptr = @as([*c]u8, @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buffer.asArrayBuffer(globalObject).?.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buffer.asArrayBuffer(globalObject).?.ptr) with @ptrCast(@alignCast(buffer.asArrayBuffer(globalObject).?.ptr))

---

### 76. `runtime/socket/tls_socket_functions.zig:521`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-522-        var tmp = @as([*c]const u8, @ptrCast(session_slice.ptr));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): session_slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(session_slice.ptr) with @ptrCast(@alignCast(session_slice.ptr))

---

### 77. `runtime/socket/tls_socket_functions.zig:543`

**Code:**
```zig
zust-port/src/runtime/socket/tls_socket_functions.zig-544-    BoringSSL.SSL_SESSION_get0_ticket(session, @as([*c][*c]const u8, @ptrCast(&ticket)), &length);
```

**Source Analysis:** address-of operator (guaranteed aligned): &ticket

**Auto-fixable:** True

**Action:** Replace @ptrCast(&ticket) with @ptrCast(@alignCast(&ticket))

---

### 78. `libuv_sys/libuv.zig:1479`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-1480-        if (uv_pipe_connect2(req, this, @ptrCast(name.ptr), name.len, UV_PIPE_NO_TRUNCATE, &Wrapper.uvConnectCb).toError(.connect2)) |err| {
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): name.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(name.ptr) with @ptrCast(@alignCast(name.ptr))

---

### 79. `libuv_sys/libuv.zig:2043`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-2044-        return @ptrCast(this.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): this.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(this.ptr) with @ptrCast(@alignCast(this.ptr))

---

### 80. `libuv_sys/libuv.zig:3220`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3221-            return @ptrCast(&@field(this, @tagName(@tagName(pipe_field_name))));
```

**Source Analysis:** address-of operator (guaranteed aligned): &@field(this, @tagName(@tagName(pipe_field_name)))

**Auto-fixable:** True

**Action:** Replace @ptrCast(&@field(this, @tagName(@tagName(pipe_field_name)))) with @ptrCast(@alignCast(&@field(this, @tagName(@tagName(pipe_field_name)))))

---

### 81. `jsc/AnyPromise.zig:97`

**Code:**
```zig
zust-port/src/jsc/AnyPromise.zig-98-        JSC__AnyPromise__wrap(globalObject, this.asValue(), &ctx, @ptrCast(&Wrapper.call));
```

**Source Analysis:** address-of operator (guaranteed aligned): &Wrapper.call

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Wrapper.call) with @ptrCast(@alignCast(&Wrapper.call))

---

### 82. `cli/install_completions_command.zig:33`

**Code:**
```zig
zust-port/src/cli/install_completions_command.zig-34-        if (std.c.symlink(@ptrCast(exe.ptr), @ptrCast(target.ptr)) != 0) {
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): exe.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(exe.ptr) with @ptrCast(@alignCast(exe.ptr))

---

### 83. `cli/install_completions_command.zig:38`

**Code:**
```zig
zust-port/src/cli/install_completions_command.zig-39-                    if (std.c.symlink(@ptrCast(exe.ptr), @ptrCast(target.ptr)) == 0) return;
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): exe.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(exe.ptr) with @ptrCast(@alignCast(exe.ptr))

---

### 84. `http/Decompressor.zig:80`

**Code:**
```zig
zust-port/src/http/Decompressor.zig-81-                reader.zlib.next_out = @ptrCast(&body_out_str.list.items[initial]);
```

**Source Analysis:** address-of operator (guaranteed aligned): &body_out_str.list.items[initial]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&body_out_str.list.items[initial]) with @ptrCast(@alignCast(&body_out_str.list.items[initial]))

---

### 85. `sql/postgres/protocol/ParameterDescription.zig:31`

**Code:**
```zig
zust-port/src/sql/postgres/protocol/ParameterDescription.zig-32-    return @as([*]align(1) const Int, @ptrCast(slice.ptr))[0 .. slice.len / @sizeOf((Int))];
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(slice.ptr) with @ptrCast(@alignCast(slice.ptr))

---

### 86. `runtime/node/node_os.zig:260`

**Code:**
```zig
zust-port/src/runtime/node/node_os.zig-261-        @as(*bun.c.processor_info_array_t, @ptrCast(&info)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &info

**Auto-fixable:** True

**Action:** Replace @ptrCast(&info) with @ptrCast(@alignCast(&info))

---

### 87. `runtime/node/node_os.zig:783`

**Code:**
```zig
zust-port/src/runtime/node/node_os.zig-784-                @import("std-net-shim").Address.initPosix(@ptrCast(&iface.address.address4)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &iface.address.address4

**Auto-fixable:** True

**Action:** Replace @ptrCast(&iface.address.address4) with @ptrCast(@alignCast(&iface.address.address4))

---

### 88. `runtime/node/node_os.zig:804`

**Code:**
```zig
zust-port/src/runtime/node/node_os.zig-805-                @import("std-net-shim").Address.initPosix(@ptrCast(&iface.netmask.netmask4)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &iface.netmask.netmask4

**Auto-fixable:** True

**Action:** Replace @ptrCast(&iface.netmask.netmask4) with @ptrCast(@alignCast(&iface.netmask.netmask4))

---

### 89. `runtime/node/dir_iterator.zig:104`

**Code:**
```zig
zust-port/src/runtime/node/dir_iterator.zig-105-                    const darwin_entry = @as(*align(1) posix.system.dirent, @ptrCast(&self.buf[self.index]));
```

**Source Analysis:** address-of operator (guaranteed aligned): &self.buf[self.index]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&self.buf[self.index]) with @ptrCast(@alignCast(&self.buf[self.index]))

---

### 90. `runtime/node/dir_iterator.zig:109`

**Code:**
```zig
zust-port/src/runtime/node/dir_iterator.zig-110-                    const name = @as([*]u8, @ptrCast(&darwin_entry.name))[0..darwin_entry.namlen];
```

**Source Analysis:** address-of operator (guaranteed aligned): &darwin_entry.name

**Auto-fixable:** True

**Action:** Replace @ptrCast(&darwin_entry.name) with @ptrCast(@alignCast(&darwin_entry.name))

---

### 91. `runtime/node/dir_iterator.zig:162`

**Code:**
```zig
zust-port/src/runtime/node/dir_iterator.zig-163-                    const entry = @as(*align(1) posix.system.dirent, @ptrCast(&self.buf[self.index]));
```

**Source Analysis:** address-of operator (guaranteed aligned): &self.buf[self.index]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&self.buf[self.index]) with @ptrCast(@alignCast(&self.buf[self.index]))

---

### 92. `runtime/node/dir_iterator.zig:166`

**Code:**
```zig
zust-port/src/runtime/node/dir_iterator.zig-167-                    const name = @as([*]u8, @ptrCast(&entry.name))[0..entry.namlen];
```

**Source Analysis:** address-of operator (guaranteed aligned): &entry.name

**Auto-fixable:** True

**Action:** Replace @ptrCast(&entry.name) with @ptrCast(@alignCast(&entry.name))

---

### 93. `runtime/node/dir_iterator.zig:213`

**Code:**
```zig
zust-port/src/runtime/node/dir_iterator.zig-214-                    const linux_entry = @as(*align(1) linux.dirent64, @ptrCast(&self.buf[self.index]));
```

**Source Analysis:** address-of operator (guaranteed aligned): &self.buf[self.index]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&self.buf[self.index]) with @ptrCast(@alignCast(&self.buf[self.index]))

---

### 94. `runtime/node/dir_iterator.zig:218`

**Code:**
```zig
zust-port/src/runtime/node/dir_iterator.zig-219-                    const name = mem.sliceTo(@as([*:0]u8, @ptrCast(&linux_entry.name)), 0);
```

**Source Analysis:** address-of operator (guaranteed aligned): &linux_entry.name

**Auto-fixable:** True

**Action:** Replace @ptrCast(&linux_entry.name) with @ptrCast(@alignCast(&linux_entry.name))

---

### 95. `runtime/node/dir_iterator.zig:395`

**Code:**
```zig
zust-port/src/runtime/node/dir_iterator.zig-396-                    const dir_info_name = @as([*]const u16, @ptrCast(&dir_info.FileName))[0..name_len_u16];
```

**Source Analysis:** address-of operator (guaranteed aligned): &dir_info.FileName

**Auto-fixable:** True

**Action:** Replace @ptrCast(&dir_info.FileName) with @ptrCast(@alignCast(&dir_info.FileName))

---

### 96. `runtime/node/dir_iterator.zig:476`

**Code:**
```zig
zust-port/src/runtime/node/dir_iterator.zig-477-                    const entry = @as(*align(1) w.dirent_t, @ptrCast(&self.buf[self.index]));
```

**Source Analysis:** address-of operator (guaranteed aligned): &self.buf[self.index]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&self.buf[self.index]) with @ptrCast(@alignCast(&self.buf[self.index]))

---

### 97. `shell/states/Expansion.zig:83`

**Code:**
```zig
zust-port/src/shell/states/Expansion.zig-84-                bun.handleOom(this.array_of_ptr.append(@as([*:0]const u8, @ptrCast(buf.ptr))));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf.ptr) with @ptrCast(@alignCast(buf.ptr))

---

### 98. `shell/states/Expansion.zig:107`

**Code:**
```zig
zust-port/src/shell/states/Expansion.zig-108-                bun.handleOom(this.array_of_ptr.append(@as([*:0]const u8, @ptrCast(buf.items.ptr))));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf.items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf.items.ptr) with @ptrCast(@alignCast(buf.items.ptr))

---

### 99. `patch/patch.zig:1157`

**Code:**
```zig
zust-port/src/patch/patch.zig-1158-            envp_buf[envp_buf.len - 1] = @ptrCast(p.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): p.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(p.ptr) with @ptrCast(@alignCast(p.ptr))

---

### 100. `shell/IOReader.zig:117`

**Code:**
```zig
zust-port/src/shell/IOReader.zig-118-    const usize_slice: []const usize = @as([*]const usize, @ptrCast(slice.ptr))[0..slice.len];
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(slice.ptr) with @ptrCast(@alignCast(slice.ptr))

---

### 101. `shell/IOReader.zig:132`

**Code:**
```zig
zust-port/src/shell/IOReader.zig-133-    const usize_slice: []const usize = @as([*]const usize, @ptrCast(slice.ptr))[0..slice.len];
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(slice.ptr) with @ptrCast(@alignCast(slice.ptr))

---

### 102. `runtime/node/win_watcher.zig:213`

**Code:**
```zig
zust-port/src/runtime/node/win_watcher.zig-214-        uv.uv_unref(@ptrCast(&this.handle));
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.handle

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.handle) with @ptrCast(@alignCast(&this.handle))

---

### 103. `runtime/node/win_watcher.zig:253`

**Code:**
```zig
zust-port/src/runtime/node/win_watcher.zig-254-        if (uv.uv_is_closed(@ptrCast(&this.handle))) {
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.handle

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.handle) with @ptrCast(@alignCast(&this.handle))

---

### 104. `runtime/node/win_watcher.zig:258`

**Code:**
```zig
zust-port/src/runtime/node/win_watcher.zig-259-            _ = uv.uv_close(@ptrCast(&this.handle), PathWatcher.uvClosedCallback);
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.handle

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.handle) with @ptrCast(@alignCast(&this.handle))

---

### 105. `sys/windows/windows.zig:3186`

**Code:**
```zig
zust-port/src/sys/windows/windows.zig-3187-    if (GetUserNameW(@ptrCast(&buf), &size) == 0) {
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf) with @ptrCast(@alignCast(&buf))

---

### 106. `sys/windows/windows.zig:3368`

**Code:**
```zig
zust-port/src/sys/windows/windows.zig-3369-    const rc = GetModuleFileNameW(module, @ptrCast(buf.ptr), @intCast(buf.len));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf.ptr) with @ptrCast(@alignCast(buf.ptr))

---

### 107. `sys/windows/windows.zig:3768`

**Code:**
```zig
zust-port/src/sys/windows/windows.zig-3769-        @ptrCast(&job),
```

**Source Analysis:** address-of operator (guaranteed aligned): &job

**Auto-fixable:** True

**Action:** Replace @ptrCast(&job) with @ptrCast(@alignCast(&job))

---

### 108. `sys/windows/windows.zig:3849`

**Code:**
```zig
zust-port/src/sys/windows/windows.zig-3850-        @ptrCast(&startupinfo),
```

**Source Analysis:** address-of operator (guaranteed aligned): &startupinfo

**Auto-fixable:** True

**Action:** Replace @ptrCast(&startupinfo) with @ptrCast(@alignCast(&startupinfo))

---

### 109. `sys/windows/windows.zig:3950`

**Code:**
```zig
zust-port/src/sys/windows/windows.zig-3951-    const rename_info = @as(*w.FILE_RENAME_INFORMATION_EX, @ptrCast(&rename_info_buf));
```

**Source Analysis:** address-of operator (guaranteed aligned): &rename_info_buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&rename_info_buf) with @ptrCast(@alignCast(&rename_info_buf))

---

### 110. `shell/subproc.zig:873`

**Code:**
```zig
zust-port/src/shell/subproc.zig-874-            @ptrCast(spawn_args.cmd_parent.args.items.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): spawn_args.cmd_parent.args.items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(spawn_args.cmd_parent.args.items.ptr) with @ptrCast(@alignCast(spawn_args.cmd_parent.args.items.ptr))

---

### 111. `shell/subproc.zig:875`

**Code:**
```zig
zust-port/src/shell/subproc.zig-876-            @ptrCast(spawn_args.env_array.items.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): spawn_args.env_array.items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(spawn_args.env_array.items.ptr) with @ptrCast(@alignCast(spawn_args.env_array.items.ptr))

---

### 112. `sys/windows/env.zig:45`

**Code:**
```zig
zust-port/src/sys/windows/env.zig-46-        const str_ptr: [*:0]u8 = @ptrCast(wtf8_buf[len..].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): wtf8_buf[len..].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(wtf8_buf[len..].ptr) with @ptrCast(@alignCast(wtf8_buf[len..].ptr))

---

### 113. `runtime/node/node_fs.zig:4322`

**Code:**
```zig
zust-port/src/runtime/node/node_fs.zig-4323-            const rc = uv.uv_fs_mkdtemp(bun.Async.Loop.get(), &req, @ptrCast(prefix_buf.ptr), null);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): prefix_buf.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(prefix_buf.ptr) with @ptrCast(@alignCast(prefix_buf.ptr))

---

### 114. `entry/main.zig:44`

**Code:**
```zig
zust-port/src/entry/main.zig-45-        environ = @ptrCast(std.c.environ);
```

**Source Analysis:** well-known global (guaranteed aligned): std.c.environ

**Auto-fixable:** True

**Action:** Replace @ptrCast(std.c.environ) with @ptrCast(@alignCast(std.c.environ))

---

### 115. `entry/main.zig:46`

**Code:**
```zig
zust-port/src/entry/main.zig-47-        _environ = @ptrCast(std.c.environ);
```

**Source Analysis:** well-known global (guaranteed aligned): std.c.environ

**Auto-fixable:** True

**Action:** Replace @ptrCast(std.c.environ) with @ptrCast(@alignCast(std.c.environ))

---

### 116. `threading/Futex.zig:235`

**Code:**
```zig
zust-port/src/threading/Futex.zig-236-            @ptrCast(&ptr.raw),
```

**Source Analysis:** address-of operator (guaranteed aligned): &ptr.raw

**Auto-fixable:** True

**Action:** Replace @ptrCast(&ptr.raw) with @ptrCast(@alignCast(&ptr.raw))

---

### 117. `perf/hw_timer.zig:165`

**Code:**
```zig
zust-port/src/perf/hw_timer.zig-166-        _ = std.os.linux.clock_gettime(.MONOTONIC, @ptrCast(&spec));
```

**Source Analysis:** address-of operator (guaranteed aligned): &spec

**Auto-fixable:** True

**Action:** Replace @ptrCast(&spec) with @ptrCast(@alignCast(&spec))

---

### 118. `perf/hw_timer.zig:168`

**Code:**
```zig
zust-port/src/perf/hw_timer.zig-169-        _ = std.c.clock_gettime(.MONOTONIC_RAW, @ptrCast(&spec));
```

**Source Analysis:** address-of operator (guaranteed aligned): &spec

**Auto-fixable:** True

**Action:** Replace @ptrCast(&spec) with @ptrCast(@alignCast(&spec))

---

### 119. `perf/hw_timer.zig:171`

**Code:**
```zig
zust-port/src/perf/hw_timer.zig-172-        _ = std.c.clock_gettime(.MONOTONIC, @ptrCast(&spec));
```

**Source Analysis:** address-of operator (guaranteed aligned): &spec

**Auto-fixable:** True

**Action:** Replace @ptrCast(&spec) with @ptrCast(@alignCast(&spec))

---

### 120. `runtime/node/path_watcher.zig:610`

**Code:**
```zig
zust-port/src/runtime/node/path_watcher.zig-611-                const ev: *align(1) const InotifyEvent = @ptrCast(buf[i..].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf[i..].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf[i..].ptr) with @ptrCast(@alignCast(buf[i..].ptr))

---

### 121. `runtime/node/path_watcher.zig:633`

**Code:**
```zig
zust-port/src/runtime/node/path_watcher.zig-634-                    const name_ptr: [*:0]const u8 = @ptrCast(buf[i - ev.name_len ..].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf[i - ev.name_len ..].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf[i - ev.name_len ..].ptr) with @ptrCast(@alignCast(buf[i - ev.name_len ..].ptr))

---

### 122. `runtime/webcore/Blob.zig:255`

**Code:**
```zig
zust-port/src/runtime/webcore/Blob.zig-256-            try S3.download(cred, path, @ptrCast(&Task.cb), t, proxy, payer);
```

**Source Analysis:** address-of operator (guaranteed aligned): &Task.cb

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Task.cb) with @ptrCast(@alignCast(&Task.cb))

---

### 123. `runtime/webcore/Blob.zig:2466`

**Code:**
```zig
zust-port/src/runtime/webcore/Blob.zig-2467-            try S3.downloadSlice(credentials, path, offset, len, @ptrCast(&S3BlobDownloadTask.onS3DownloadResolved), this, if (env.getHttpProxy(true, null, null)) |proxy| proxy.href else null, s3_store.request_payer);
```

**Source Analysis:** address-of operator (guaranteed aligned): &S3BlobDownloadTask.onS3DownloadResolved

**Auto-fixable:** True

**Action:** Replace @ptrCast(&S3BlobDownloadTask.onS3DownloadResolved) with @ptrCast(@alignCast(&S3BlobDownloadTask.onS3DownloadResolved))

---

### 124. `runtime/webcore/Blob.zig:2469`

**Code:**
```zig
zust-port/src/runtime/webcore/Blob.zig-2470-            try S3.download(credentials, path, @ptrCast(&S3BlobDownloadTask.onS3DownloadResolved), this, if (env.getHttpProxy(true, null, null)) |proxy| proxy.href else null, s3_store.request_payer);
```

**Source Analysis:** address-of operator (guaranteed aligned): &S3BlobDownloadTask.onS3DownloadResolved

**Auto-fixable:** True

**Action:** Replace @ptrCast(&S3BlobDownloadTask.onS3DownloadResolved) with @ptrCast(@alignCast(&S3BlobDownloadTask.onS3DownloadResolved))

---

### 125. `runtime/webcore/Blob.zig:2476`

**Code:**
```zig
zust-port/src/runtime/webcore/Blob.zig-2477-            try S3.downloadSlice(credentials, path, offset, len, @ptrCast(&S3BlobDownloadTask.onS3DownloadResolved), this, if (env.getHttpProxy(true, null, null)) |proxy| proxy.href else null, s3_store.request_payer);
```

**Source Analysis:** address-of operator (guaranteed aligned): &S3BlobDownloadTask.onS3DownloadResolved

**Auto-fixable:** True

**Action:** Replace @ptrCast(&S3BlobDownloadTask.onS3DownloadResolved) with @ptrCast(@alignCast(&S3BlobDownloadTask.onS3DownloadResolved))

---

### 126. `runtime/webcore/Blob.zig:2772`

**Code:**
```zig
zust-port/src/runtime/webcore/Blob.zig-2773-        @as(**anyopaque, @ptrCast(&signal.ptr)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &signal.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&signal.ptr) with @ptrCast(@alignCast(&signal.ptr))

---

### 127. `runtime/webcore/Blob.zig:5121`

**Code:**
```zig
zust-port/src/runtime/webcore/Blob.zig-5122-                    .onDone = @ptrCast(&onIORequestClosed),
```

**Source Analysis:** address-of operator (guaranteed aligned): &onIORequestClosed

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onIORequestClosed) with @ptrCast(@alignCast(&onIORequestClosed))

---

### 128. `exe_format/pe.zig:155`

**Code:**
```zig
zust-port/src/exe_format/pe.zig-156-        return @ptrCast(buf[off .. off + @sizeOf(T)].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf[off .. off + @sizeOf(T)].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf[off .. off + @sizeOf(T)].ptr) with @ptrCast(@alignCast(buf[off .. off + @sizeOf(T)].ptr))

---

### 129. `exe_format/pe.zig:162`

**Code:**
```zig
zust-port/src/exe_format/pe.zig-163-        return @ptrCast(buf[off .. off + @sizeOf(T)].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf[off .. off + @sizeOf(T)].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf[off .. off + @sizeOf(T)].ptr) with @ptrCast(@alignCast(buf[off .. off + @sizeOf(T)].ptr))

---

### 130. `exe_format/pe.zig:215`

**Code:**
```zig
zust-port/src/exe_format/pe.zig-216-        const ptr: [*]align(1) const SectionHeader = @ptrCast(self.data.items[start..].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): self.data.items[start..].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(self.data.items[start..].ptr) with @ptrCast(@alignCast(self.data.items[start..].ptr))

---

### 131. `exe_format/pe.zig:224`

**Code:**
```zig
zust-port/src/exe_format/pe.zig-225-        const ptr: [*]align(1) SectionHeader = @ptrCast(self.data.items[start..].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): self.data.items[start..].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(self.data.items[start..].ptr) with @ptrCast(@alignCast(self.data.items[start..].ptr))

---

### 132. `exe_format/pe.zig:307`

**Code:**
```zig
zust-port/src/exe_format/pe.zig-308-            const sections_ptr: [*]align(1) const SectionHeader = @ptrCast(data.items[section_headers_offset..].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): data.items[section_headers_offset..].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(data.items[section_headers_offset..].ptr) with @ptrCast(@alignCast(data.items[section_headers_offset..].ptr))

---

### 133. `exe_format/pe.zig:743`

**Code:**
```zig
zust-port/src/exe_format/pe.zig-744-        const dos: *align(1) const PEFile.DOSHeader = @ptrCast(data.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): data.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(data.ptr) with @ptrCast(@alignCast(data.ptr))

---

### 134. `exe_format/pe.zig:750`

**Code:**
```zig
zust-port/src/exe_format/pe.zig-751-        const pe: *align(1) const PEFile.PEHeader = @ptrCast(data[off..].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): data[off..].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(data[off..].ptr) with @ptrCast(@alignCast(data[off..].ptr))

---

### 135. `exe_format/macho.zig:29`

**Code:**
```zig
zust-port/src/exe_format/macho.zig-30-                const ptr: *align(1) const Cmd = @ptrCast(entry.data.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): entry.data.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(entry.data.ptr) with @ptrCast(@alignCast(entry.data.ptr))

---

### 136. `exe_format/macho.zig:66`

**Code:**
```zig
zust-port/src/exe_format/macho.zig-67-            const hdr: *align(1) const macho.load_command = @ptrCast(hdr_bytes.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): hdr_bytes.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(hdr_bytes.ptr) with @ptrCast(@alignCast(hdr_bytes.ptr))

---

### 137. `exe_format/macho.zig:467`

**Code:**
```zig
zust-port/src/exe_format/macho.zig-468-            const header = @as(*align(1) const macho.mach_header_64, @ptrCast(obj.ptr)).*;
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): obj.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(obj.ptr) with @ptrCast(@alignCast(obj.ptr))

---

### 138. `standalone_graph/StandaloneModuleGraph.zig:1408`

**Code:**
```zig
zust-port/src/standalone_graph/StandaloneModuleGraph.zig-1409-            return @ptrCast(map.bytes.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): map.bytes.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(map.bytes.ptr) with @ptrCast(@alignCast(map.bytes.ptr))

---

### 139. `main_test.zig:24`

**Code:**
```zig
zust-port/src/main_test.zig-25-            @ptrCast(&bun.mimalloc.mi_malloc),
```

**Source Analysis:** address-of operator (guaranteed aligned): &bun.mimalloc.mi_malloc

**Auto-fixable:** True

**Action:** Replace @ptrCast(&bun.mimalloc.mi_malloc) with @ptrCast(@alignCast(&bun.mimalloc.mi_malloc))

---

### 140. `main_test.zig:26`

**Code:**
```zig
zust-port/src/main_test.zig-27-            @ptrCast(&bun.mimalloc.mi_realloc),
```

**Source Analysis:** address-of operator (guaranteed aligned): &bun.mimalloc.mi_realloc

**Auto-fixable:** True

**Action:** Replace @ptrCast(&bun.mimalloc.mi_realloc) with @ptrCast(@alignCast(&bun.mimalloc.mi_realloc))

---

### 141. `main_test.zig:28`

**Code:**
```zig
zust-port/src/main_test.zig-29-            @ptrCast(&bun.mimalloc.mi_calloc),
```

**Source Analysis:** address-of operator (guaranteed aligned): &bun.mimalloc.mi_calloc

**Auto-fixable:** True

**Action:** Replace @ptrCast(&bun.mimalloc.mi_calloc) with @ptrCast(@alignCast(&bun.mimalloc.mi_calloc))

---

### 142. `main_test.zig:30`

**Code:**
```zig
zust-port/src/main_test.zig-31-            @ptrCast(&bun.mimalloc.mi_free),
```

**Source Analysis:** address-of operator (guaranteed aligned): &bun.mimalloc.mi_free

**Auto-fixable:** True

**Action:** Replace @ptrCast(&bun.mimalloc.mi_free) with @ptrCast(@alignCast(&bun.mimalloc.mi_free))

---

### 143. `main_test.zig:33`

**Code:**
```zig
zust-port/src/main_test.zig-34-        environ = @ptrCast(std.os.environ.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): std.os.environ.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(std.os.environ.ptr) with @ptrCast(@alignCast(std.os.environ.ptr))

---

### 144. `main_test.zig:35`

**Code:**
```zig
zust-port/src/main_test.zig-36-        _environ = @ptrCast(std.os.environ.ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): std.os.environ.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(std.os.environ.ptr) with @ptrCast(@alignCast(std.os.environ.ptr))

---

### 145. `collections/baby_list.zig:39`

**Code:**
```zig
zust-port/src/collections/baby_list.zig-40-                .ptr = @as([*]Type, @ptrCast(items.ptr)),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(items.ptr) with @ptrCast(@alignCast(items.ptr))

---

### 146. `collections/baby_list.zig:466`

**Code:**
```zig
zust-port/src/collections/baby_list.zig-467-            @as([*]align(1) Int, @ptrCast(this.ptr[this.len .. this.len + @sizeOf(Int)]))[0] = int;
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): this.ptr[this.len .. this.len + @sizeOf(Int)]

**Auto-fixable:** True

**Action:** Replace @ptrCast(this.ptr[this.len .. this.len + @sizeOf(Int)]) with @ptrCast(@alignCast(this.ptr[this.len .. this.len + @sizeOf(Int)]))

---

### 147. `runtime/webcore/blob/write_file.zig:59`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/write_file.zig-60-                .onError = @ptrCast(&onIOError),
```

**Source Analysis:** address-of operator (guaranteed aligned): &onIOError

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onIOError) with @ptrCast(@alignCast(&onIOError))

---

### 148. `runtime/webcore/blob/write_file.zig:435`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/write_file.zig-436-            @ptrCast(&onOpen),
```

**Source Analysis:** address-of operator (guaranteed aligned): &onOpen

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onOpen) with @ptrCast(@alignCast(&onOpen))

---

### 149. `runtime/webcore/blob/write_file.zig:497`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/write_file.zig-498-            .completion = @ptrCast(&onMkdirpCompleteConcurrent),
```

**Source Analysis:** address-of operator (guaranteed aligned): &onMkdirpCompleteConcurrent

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onMkdirpCompleteConcurrent) with @ptrCast(@alignCast(&onMkdirpCompleteConcurrent))

---

### 150. `runtime/webcore/blob/read_file.zig:172`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/read_file.zig-173-                .onError = @ptrCast(&onIOError),
```

**Source Analysis:** address-of operator (guaranteed aligned): &onIOError

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onIOError) with @ptrCast(@alignCast(&onIOError))

---

### 151. `runtime/webcore/blob/read_file.zig:571`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/read_file.zig-572-            .on_complete_fn = @ptrCast(&Handler.run),
```

**Source Analysis:** address-of operator (guaranteed aligned): &Handler.run

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Handler.run) with @ptrCast(@alignCast(&Handler.run))

---

### 152. `runtime/webcore/blob/Store.zig:371`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/Store.zig-372-        try bun.S3.delete(&aws_options.credentials, this.path(), @ptrCast(&Wrapper.resolve), Wrapper.new(.{
```

**Source Analysis:** address-of operator (guaranteed aligned): &Wrapper.resolve

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Wrapper.resolve) with @ptrCast(@alignCast(&Wrapper.resolve))

---

### 153. `runtime/webcore/blob/Store.zig:432`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/Store.zig-433-        try bun.S3.listObjects(&aws_options.credentials, options, @ptrCast(&Wrapper.resolve), bun.new(Wrapper, .{
```

**Source Analysis:** address-of operator (guaranteed aligned): &Wrapper.resolve

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Wrapper.resolve) with @ptrCast(@alignCast(&Wrapper.resolve))

---

### 154. `sql/postgres/types/Tag.zig:213`

**Code:**
```zig
zust-port/src/sql/postgres/types/Tag.zig-214-                var head = @as([*]T, @ptrCast(&this.first_value));
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.first_value

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.first_value) with @ptrCast(@alignCast(&this.first_value))

---

### 155. `dns/dns.zig:247`

**Code:**
```zig
zust-port/src/dns/dns.zig-248-            const bytes = @as(*const [4]u8, @ptrCast(&self.addr));
```

**Source Analysis:** address-of operator (guaranteed aligned): &self.addr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&self.addr) with @ptrCast(@alignCast(&self.addr))

---

### 156. `string/string.zig:426`

**Code:**
```zig
zust-port/src/string/string.zig-427-                cb(ctx, @ptrCast(@constCast(bytes.ptr)), @truncate(bytes.len));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): @constCast(bytes.ptr)

**Auto-fixable:** True

**Action:** Replace @ptrCast(@constCast(bytes.ptr)) with @ptrCast(@alignCast(@constCast(bytes.ptr)))

---

### 157. `string/string.zig:431`

**Code:**
```zig
zust-port/src/string/string.zig-432-        return validateRefCount(BunString__createExternal(@ptrCast(bytes.ptr), bytes.len, isLatin1, ctx, @ptrCast(callback)));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): bytes.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(bytes.ptr) with @ptrCast(@alignCast(bytes.ptr))

---

### 158. `runtime/server/RequestContext.zig:1067`

**Code:**
```zig
zust-port/src/runtime/server/RequestContext.zig-1068-                    .onFirstWrite = @ptrCast(&handleFirstStreamWrite),
```

**Source Analysis:** address-of operator (guaranteed aligned): &handleFirstStreamWrite

**Auto-fixable:** True

**Action:** Replace @ptrCast(&handleFirstStreamWrite) with @ptrCast(@alignCast(&handleFirstStreamWrite))

---

### 159. `runtime/server/RequestContext.zig:1093`

**Code:**
```zig
zust-port/src/runtime/server/RequestContext.zig-1094-                @as(**anyopaque, @ptrCast(&signal.ptr)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &signal.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&signal.ptr) with @ptrCast(@alignCast(&signal.ptr))

---

### 160. `runtime/server/RequestContext.zig:1451`

**Code:**
```zig
zust-port/src/runtime/server/RequestContext.zig-1452-                        S3.stat(credentials, path, @ptrCast(&onS3SizeResolved), this, if (env.getHttpProxy(true, null, null)) |proxy| proxy.href else null, blob.store.?.data.s3.request_payer) catch {}; // TODO: properly propagate exception upwards
```

**Source Analysis:** address-of operator (guaranteed aligned): &onS3SizeResolved

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onS3SizeResolved) with @ptrCast(@alignCast(&onS3SizeResolved))

---

### 161. `runtime/webcore/fetch.zig:1349`

**Code:**
```zig
zust-port/src/runtime/webcore/fetch.zig-1350-                @ptrCast(&Wrapper.resolve),
```

**Source Analysis:** address-of operator (guaranteed aligned): &Wrapper.resolve

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Wrapper.resolve) with @ptrCast(@alignCast(&Wrapper.resolve))

---

### 162. `jsc/HTTPServerAgent.zig:156`

**Code:**
```zig
zust-port/src/jsc/HTTPServerAgent.zig-157-        bun.cpp.Bun__HTTPServerAgent__notifyServerRoutesUpdated(agent, serverId, hotReloadId, @ptrCast(routes.ptr), routes.len);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): routes.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(routes.ptr) with @ptrCast(@alignCast(routes.ptr))

---

### 163. `jsc/JSPromise.zig:206`

**Code:**
```zig
zust-port/src/jsc/JSPromise.zig-207-        const promise = JSC__JSPromise__wrap(globalObject, &ctx, @ptrCast(&Wrapper.call));
```

**Source Analysis:** address-of operator (guaranteed aligned): &Wrapper.call

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Wrapper.call) with @ptrCast(@alignCast(&Wrapper.call))

---

### 164. `jsc/JSValue.zig:588`

**Code:**
```zig
zust-port/src/jsc/JSValue.zig-589-            @as([*]const JSValue, @ptrCast(&this)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &this

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this) with @ptrCast(@alignCast(&this))

---

### 165. `runtime/webview/HostProcess.zig:110`

**Code:**
```zig
zust-port/src/runtime/webview/HostProcess.zig-111-        @ptrCast(&argv),
```

**Source Analysis:** address-of operator (guaranteed aligned): &argv

**Auto-fixable:** True

**Action:** Replace @ptrCast(&argv) with @ptrCast(@alignCast(&argv))

---

### 166. `runtime/webview/HostProcess.zig:112`

**Code:**
```zig
zust-port/src/runtime/webview/HostProcess.zig-113-        @ptrCast(env.items.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): env.items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(env.items.ptr) with @ptrCast(@alignCast(env.items.ptr))

---

### 167. `runtime/webview/ChromeProcess.zig:339`

**Code:**
```zig
zust-port/src/runtime/webview/ChromeProcess.zig-340-        @ptrCast(argv.items.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): argv.items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(argv.items.ptr) with @ptrCast(@alignCast(argv.items.ptr))

---

### 168. `runtime/webview/ChromeProcess.zig:341`

**Code:**
```zig
zust-port/src/runtime/webview/ChromeProcess.zig-342-        @ptrCast(env.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): env.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(env.ptr) with @ptrCast(@alignCast(env.ptr))

---

### 169. `runtime/webcore/FileSink.zig:826`

**Code:**
```zig
zust-port/src/runtime/webcore/FileSink.zig-827-    const promise_result = jsc.WebCore.FileSink.JSSink.assignToStream(globalThis, stream.value, this, @as(**anyopaque, @ptrCast(&signal.ptr)));
```

**Source Analysis:** address-of operator (guaranteed aligned): &signal.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&signal.ptr) with @ptrCast(@alignCast(&signal.ptr))

---

### 170. `js_parser/ast/E.zig:909`

**Code:**
```zig
zust-port/src/js_parser/ast/E.zig-910-                .data = @as([*]const u8, @ptrCast(value.ptr))[0..value.len],
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): value.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(value.ptr) with @ptrCast(@alignCast(value.ptr))

---

### 171. `js_parser/ast/E.zig:1153`

**Code:**
```zig
zust-port/src/js_parser/ast/E.zig-1154-            return bun.hash(@as([*]const u8, @ptrCast(s.slice16().ptr))[0 .. s.slice16().len * 2]);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): s.slice16().ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(s.slice16().ptr) with @ptrCast(@alignCast(s.slice16().ptr))

---

### 172. `runtime/webcore/Body.zig:1680`

**Code:**
```zig
zust-port/src/runtime/webcore/Body.zig-1681-            @as(**anyopaque, @ptrCast(&signal.ptr)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &signal.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&signal.ptr) with @ptrCast(@alignCast(&signal.ptr))

---

### 173. `jsc/CallFrame.zig:249`

**Code:**
```zig
zust-port/src/jsc/CallFrame.zig-250-            return init(vm, @as([*]const jsc.JSValue, @ptrCast(slice.ptr))[0..slice.len]);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(slice.ptr) with @ptrCast(@alignCast(slice.ptr))

---

### 174. `jsc/array_buffer.zig:191`

**Code:**
```zig
zust-port/src/jsc/array_buffer.zig-192-            .Uint8Array => try bun.jsc.fromJSHostCall(global, @src(), Bun__allocUint8ArrayForCopy, .{ global, len, @ptrCast(&ptr) }),
```

**Source Analysis:** address-of operator (guaranteed aligned): &ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&ptr) with @ptrCast(@alignCast(&ptr))

---

### 175. `jsc/array_buffer.zig:193`

**Code:**
```zig
zust-port/src/jsc/array_buffer.zig-194-            .ArrayBuffer => try bun.jsc.fromJSHostCall(global, @src(), Bun__allocArrayBufferForCopy, .{ global, len, @ptrCast(&ptr) }),
```

**Source Analysis:** address-of operator (guaranteed aligned): &ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&ptr) with @ptrCast(@alignCast(&ptr))

---

### 176. `jsc/array_buffer.zig:360`

**Code:**
```zig
zust-port/src/jsc/array_buffer.zig-361-        return @ptrCast(this.ptr.?[0 .. this.byte_len / @sizeOf(u16) * @sizeOf(u16)]);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): this.ptr.?[0 .. this.byte_len / @sizeOf(u16) * @sizeOf(u16)]

**Auto-fixable:** True

**Action:** Replace @ptrCast(this.ptr.?[0 .. this.byte_len / @sizeOf(u16) * @sizeOf(u16)]) with @ptrCast(@alignCast(this.ptr.?[0 .. this.byte_len / @sizeOf(u16) * @sizeOf(u16)]))

---

### 177. `jsc/array_buffer.zig:372`

**Code:**
```zig
zust-port/src/jsc/array_buffer.zig-373-        return @ptrCast(this.ptr.?[0 .. this.byte_len / @sizeOf(u32) * @sizeOf(u32)]);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): this.ptr.?[0 .. this.byte_len / @sizeOf(u32) * @sizeOf(u32)]

**Auto-fixable:** True

**Action:** Replace @ptrCast(this.ptr.?[0 .. this.byte_len / @sizeOf(u32) * @sizeOf(u32)]) with @ptrCast(@alignCast(this.ptr.?[0 .. this.byte_len / @sizeOf(u32) * @sizeOf(u32)]))

---

### 178. `jsc/hot_reloader.zig:502`

**Code:**
```zig
zust-port/src/jsc/hot_reloader.zig-503-                                            const was_deleted = std.c.faccessat(std.c.AT.FDCWD, @as([*:0]u8, @ptrCast(&path_buf)), std.c.F_OK, 0) != 0;
```

**Source Analysis:** address-of operator (guaranteed aligned): &path_buf

**Auto-fixable:** True

**Action:** Replace @ptrCast(&path_buf) with @ptrCast(@alignCast(&path_buf))

---

### 179. `runtime/webcore/s3/client.zig:328`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/client.zig-329-        .callback = @ptrCast(&Wrapper.callback),
```

**Source Analysis:** address-of operator (guaranteed aligned): &Wrapper.callback

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Wrapper.callback) with @ptrCast(@alignCast(&Wrapper.callback))

---

### 180. `runtime/webcore/s3/client.zig:347`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/client.zig-348-    task.onWritable = @ptrCast(&jsc.WebCore.NetworkSink.onWritable);
```

**Source Analysis:** address-of operator (guaranteed aligned): &jsc.WebCore.NetworkSink.onWritable

**Auto-fixable:** True

**Action:** Replace @ptrCast(&jsc.WebCore.NetworkSink.onWritable) with @ptrCast(@alignCast(&jsc.WebCore.NetworkSink.onWritable))

---

### 181. `runtime/webcore/s3/client.zig:512`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/client.zig-513-        .callback = @ptrCast(&S3UploadStreamWrapper.resolve),
```

**Source Analysis:** address-of operator (guaranteed aligned): &S3UploadStreamWrapper.resolve

**Auto-fixable:** True

**Action:** Replace @ptrCast(&S3UploadStreamWrapper.resolve) with @ptrCast(@alignCast(&S3UploadStreamWrapper.resolve))

---

### 182. `runtime/webcore/s3/client.zig:540`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/client.zig-541-    task.onWritable = @ptrCast(&S3UploadStreamWrapper.onWritable);
```

**Source Analysis:** address-of operator (guaranteed aligned): &S3UploadStreamWrapper.onWritable

**Auto-fixable:** True

**Action:** Replace @ptrCast(&S3UploadStreamWrapper.onWritable) with @ptrCast(@alignCast(&S3UploadStreamWrapper.onWritable))

---

### 183. `runtime/webcore/s3/multipart.zig:246`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/multipart.zig-247-            }, .{ .part = @ptrCast(&onPartResponse) }, this);
```

**Source Analysis:** address-of operator (guaranteed aligned): &onPartResponse

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onPartResponse) with @ptrCast(@alignCast(&onPartResponse))

---

### 184. `runtime/webcore/s3/multipart.zig:325`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/multipart.zig-326-                    }, .{ .upload = @ptrCast(&singleSendUploadResponse) }, this);
```

**Source Analysis:** address-of operator (guaranteed aligned): &singleSendUploadResponse

**Auto-fixable:** True

**Action:** Replace @ptrCast(&singleSendUploadResponse) with @ptrCast(@alignCast(&singleSendUploadResponse))

---

### 185. `runtime/webcore/s3/multipart.zig:584`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/multipart.zig-585-        }, .{ .commit = @ptrCast(&onCommitMultiPartRequest) }, this);
```

**Source Analysis:** address-of operator (guaranteed aligned): &onCommitMultiPartRequest

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onCommitMultiPartRequest) with @ptrCast(@alignCast(&onCommitMultiPartRequest))

---

### 186. `runtime/webcore/s3/multipart.zig:601`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/multipart.zig-602-        }, .{ .upload = @ptrCast(&onRollbackMultiPartRequest) }, this);
```

**Source Analysis:** address-of operator (guaranteed aligned): &onRollbackMultiPartRequest

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onRollbackMultiPartRequest) with @ptrCast(@alignCast(&onRollbackMultiPartRequest))

---

### 187. `runtime/webcore/s3/multipart.zig:624`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/multipart.zig-625-            }, .{ .download = @ptrCast(&startMultiPartRequestResult) }, this);
```

**Source Analysis:** address-of operator (guaranteed aligned): &startMultiPartRequestResult

**Auto-fixable:** True

**Action:** Replace @ptrCast(&startMultiPartRequestResult) with @ptrCast(@alignCast(&startMultiPartRequestResult))

---

### 188. `runtime/webcore/s3/multipart.zig:704`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/multipart.zig-705-            }, .{ .upload = @ptrCast(&singleSendUploadResponse) }, this) catch {}; // TODO: properly propagate exception upwards
```

**Source Analysis:** address-of operator (guaranteed aligned): &singleSendUploadResponse

**Auto-fixable:** True

**Action:** Replace @ptrCast(&singleSendUploadResponse) with @ptrCast(@alignCast(&singleSendUploadResponse))

---

### 189. `jsc/ZigString.zig:804`

**Code:**
```zig
zust-port/src/jsc/ZigString.zig-805-            callback(ctx, @ptrCast(@constCast(this.byteSlice().ptr)), this.len);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): @constCast(this.byteSlice().ptr)

**Auto-fixable:** True

**Action:** Replace @ptrCast(@constCast(this.byteSlice().ptr)) with @ptrCast(@alignCast(@constCast(this.byteSlice().ptr)))

---

### 190. `runtime/dns_jsc/dns.zig:1539`

**Code:**
```zig
zust-port/src/runtime/dns_jsc/dns.zig-1540-                    const addr_in: *std.c.sockaddr.in = @ptrCast(&results[i].addr);
```

**Source Analysis:** address-of operator (guaranteed aligned): &results[i].addr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&results[i].addr) with @ptrCast(@alignCast(&results[i].addr))

---

### 191. `runtime/dns_jsc/dns.zig:1543`

**Code:**
```zig
zust-port/src/runtime/dns_jsc/dns.zig-1544-                    const addr_in: *std.c.sockaddr.in6 = @ptrCast(&results[i].addr);
```

**Source Analysis:** address-of operator (guaranteed aligned): &results[i].addr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&results[i].addr) with @ptrCast(@alignCast(&results[i].addr))

---

### 192. `runtime/dns_jsc/dns.zig:2609`

**Code:**
```zig
zust-port/src/runtime/dns_jsc/dns.zig-2610-                    uv.uv_close(@ptrCast(&entry.value.poll), onCloseUv);
```

**Source Analysis:** address-of operator (guaranteed aligned): &entry.value.poll

**Auto-fixable:** True

**Action:** Replace @ptrCast(&entry.value.poll) with @ptrCast(@alignCast(&entry.value.poll))

---

### 193. `runtime/dns_jsc/dns.zig:2636`

**Code:**
```zig
zust-port/src/runtime/dns_jsc/dns.zig-2637-                uv.uv_close(@ptrCast(&poll.poll), onCloseUv);
```

**Source Analysis:** address-of operator (guaranteed aligned): &poll.poll

**Auto-fixable:** True

**Action:** Replace @ptrCast(&poll.poll) with @ptrCast(@alignCast(&poll.poll))

---

### 194. `runtime/dns_jsc/dns.zig:3593`

**Code:**
```zig
zust-port/src/runtime/dns_jsc/dns.zig-3594-        if (c_ares.getSockaddr(addr_s, port, @as(*std.posix.sockaddr, @ptrCast(&sa))) != 0) {
```

**Source Analysis:** address-of operator (guaranteed aligned): &sa

**Auto-fixable:** True

**Action:** Replace @ptrCast(&sa) with @ptrCast(@alignCast(&sa))

---

### 195. `runtime/dns_jsc/dns.zig:3628`

**Code:**
```zig
zust-port/src/runtime/dns_jsc/dns.zig-3629-            @as(*std.posix.sockaddr, @ptrCast(&sa)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &sa

**Auto-fixable:** True

**Action:** Replace @ptrCast(&sa) with @ptrCast(@alignCast(&sa))

---

### 196. `bake/DevServer.zig:2260`

**Code:**
```zig
zust-port/src/bake/DevServer.zig-2261-        return @ptrCast(&subslice[i.get()]);
```

**Source Analysis:** address-of operator (guaranteed aligned): &subslice[i.get()]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&subslice[i.get()]) with @ptrCast(@alignCast(&subslice[i.get()]))

---

### 197. `analytics/schema.zig:93`

**Code:**
```zig
zust-port/src/analytics/schema.zig-94-                        return @as([*]T, @ptrCast(enum_values.ptr))[0..length];
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): enum_values.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(enum_values.ptr) with @ptrCast(@alignCast(enum_values.ptr))

---

### 198. `js_parser/js_parser.zig:655`

**Code:**
```zig
zust-port/src/js_parser/js_parser.zig-656-            return @as(*Type, @ptrCast(&this.head.eat1(value).ptr));
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.head.eat1(value).ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.head.eat1(value).ptr) with @ptrCast(@alignCast(&this.head.eat1(value).ptr))

---

### 199. `picohttp/picohttp.zig:199`

**Code:**
```zig
zust-port/src/picohttp/picohttp.zig-200-            @as([*c][*c]const u8, @ptrCast(&method.ptr)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &method.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&method.ptr) with @ptrCast(@alignCast(&method.ptr))

---

### 200. `picohttp/picohttp.zig:202`

**Code:**
```zig
zust-port/src/picohttp/picohttp.zig-203-            @as([*c][*c]const u8, @ptrCast(&path.ptr)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &path.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&path.ptr) with @ptrCast(@alignCast(&path.ptr))

---

### 201. `picohttp/picohttp.zig:206`

**Code:**
```zig
zust-port/src/picohttp/picohttp.zig-207-            @as([*c]c.phr_header, @ptrCast(src.ptr)),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): src.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(src.ptr) with @ptrCast(@alignCast(src.ptr))

---

### 202. `picohttp/picohttp.zig:311`

**Code:**
```zig
zust-port/src/picohttp/picohttp.zig-312-            @as([*c][*c]const u8, @ptrCast(&status.ptr)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &status.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(&status.ptr) with @ptrCast(@alignCast(&status.ptr))

---

### 203. `picohttp/picohttp.zig:314`

**Code:**
```zig
zust-port/src/picohttp/picohttp.zig-315-            @as([*c]c.phr_header, @ptrCast(src.ptr)),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): src.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(src.ptr) with @ptrCast(@alignCast(src.ptr))

---

### 204. `picohttp/picohttp.zig:366`

**Code:**
```zig
zust-port/src/picohttp/picohttp.zig-367-            @as([*c]c.phr_header, @ptrCast(src.ptr)),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): src.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(src.ptr) with @ptrCast(@alignCast(src.ptr))

---

### 205. `picohttp/picohttp.zig:368`

**Code:**
```zig
zust-port/src/picohttp/picohttp.zig-369-            @as([*c]usize, @ptrCast(&num_headers)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &num_headers

**Auto-fixable:** True

**Action:** Replace @ptrCast(&num_headers) with @ptrCast(@alignCast(&num_headers))

---

### 206. `bundler/linker_context/writeOutputFilesToDisk.zig:391`

**Code:**
```zig
zust-port/src/bundler/linker_context/writeOutputFilesToDisk.zig-392-                .javascript => |js| @ptrCast(try bun.default_allocator.dupe(u32, js.css_chunks)),
```

**Source Analysis:** allocator output (guaranteed aligned): try bun.default_allocator.dupe(u32, js.css_chunks)

**Auto-fixable:** True

**Action:** Replace @ptrCast(try bun.default_allocator.dupe(u32, js.css_chunks)) with @ptrCast(@alignCast(try bun.default_allocator.dupe(u32, js.css_chunks)))

---

### 207. `io/PipeReader.zig:1126`

**Code:**
```zig
zust-port/src/io/PipeReader.zig-1127-                                    if (uv.uv_fs_read(this.vtable.loop(this.parent), &file_ptr.fs, file_ptr.file, @ptrCast(&file_ptr.iov), 1, if (this.flags.use_pread) @intCast(this._offset) else -1, onFileRead).toError(.write)) |err| {
```

**Source Analysis:** address-of operator (guaranteed aligned): &file_ptr.iov

**Auto-fixable:** True

**Action:** Replace @ptrCast(&file_ptr.iov) with @ptrCast(@alignCast(&file_ptr.iov))

---

### 208. `io/PipeReader.zig:1178`

**Code:**
```zig
zust-port/src/io/PipeReader.zig-1179-                if (uv.uv_fs_read(this.vtable.loop(this.parent), &file.fs, file.file, @ptrCast(&file.iov), 1, if (this.flags.use_pread) @intCast(this._offset) else -1, onFileRead).toError(.write)) |err| {
```

**Source Analysis:** address-of operator (guaranteed aligned): &file.iov

**Auto-fixable:** True

**Action:** Replace @ptrCast(&file.iov) with @ptrCast(@alignCast(&file.iov))

---

### 209. `io/source.zig:81`

**Code:**
```zig
zust-port/src/io/source.zig-82-            const cancel_result = uv.uv_cancel(@ptrCast(&this.fs));
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.fs

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.fs) with @ptrCast(@alignCast(&this.fs))

---

### 210. `bundler/linker_context/generateChunksInParallel.zig:745`

**Code:**
```zig
zust-port/src/bundler/linker_context/generateChunksInParallel.zig-746-                    .javascript => |js| @ptrCast(try bun.default_allocator.dupe(u32, js.css_chunks)),
```

**Source Analysis:** allocator output (guaranteed aligned): try bun.default_allocator.dupe(u32, js.css_chunks)

**Auto-fixable:** True

**Action:** Replace @ptrCast(try bun.default_allocator.dupe(u32, js.css_chunks)) with @ptrCast(@alignCast(try bun.default_allocator.dupe(u32, js.css_chunks)))

---

### 211. `io/PipeWriter.zig:1089`

**Code:**
```zig
zust-port/src/io/PipeWriter.zig-1090-                    if (uv.uv_fs_write(this.parent.loop(), &file.fs, file.file, @ptrCast(&this.write_buffer), 1, -1, onFsWriteComplete).toError(.write)) |err| {
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.write_buffer

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.write_buffer) with @ptrCast(@alignCast(&this.write_buffer))

---

### 212. `io/PipeWriter.zig:1449`

**Code:**
```zig
zust-port/src/io/PipeWriter.zig-1450-                    if (uv.uv_fs_write(this.parent.loop(), &file.fs, file.file, @ptrCast(&this.write_buffer), 1, -1, onFsWriteComplete).toError(.write)) |err| {
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.write_buffer

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.write_buffer) with @ptrCast(@alignCast(&this.write_buffer))

---

### 213. `io/io.zig:62`

**Code:**
```zig
zust-port/src/io/io.zig-63-            const rc = std.c.kevent(loop.kqueue_fd.cast(), @as([*]const KEvent, @ptrCast(&change)), 1, undefined, 0, null);
```

**Source Analysis:** address-of operator (guaranteed aligned): &change

**Auto-fixable:** True

**Action:** Replace @ptrCast(&change) with @ptrCast(@alignCast(&change))

---

### 214. `runtime/api/Archive.zig:197`

**Code:**
```zig
zust-port/src/runtime/api/Archive.zig-198-        @ptrCast(&growing_buffer),
```

**Source Analysis:** address-of operator (guaranteed aligned): &growing_buffer

**Auto-fixable:** True

**Action:** Replace @ptrCast(&growing_buffer) with @ptrCast(@alignCast(&growing_buffer))

---

### 215. `runtime/api/html_rewriter.zig:499`

**Code:**
```zig
zust-port/src/runtime/api/html_rewriter.zig-500-            sink.bodyValueBufferer = jsc.WebCore.Body.ValueBufferer.init(sink, @ptrCast(&onFinishedBuffering), sink.global, bun.default_allocator);
```

**Source Analysis:** address-of operator (guaranteed aligned): &onFinishedBuffering

**Auto-fixable:** True

**Action:** Replace @ptrCast(&onFinishedBuffering) with @ptrCast(@alignCast(&onFinishedBuffering))

---

### 216. `runtime/ffi/ffi.zig:269`

**Code:**
```zig
zust-port/src/runtime/ffi/ffi.zig-270-                    .envp = @ptrCast(std.c.environ),
```

**Source Analysis:** well-known global (guaranteed aligned): std.c.environ

**Auto-fixable:** True

**Action:** Replace @ptrCast(std.c.environ) with @ptrCast(@alignCast(std.c.environ))

---

### 217. `runtime/api/bun/process.zig:2243`

**Code:**
```zig
zust-port/src/runtime/api/bun/process.zig-2244-        const envp = options.envp orelse @as([*:null]?[*:0]const u8, @ptrCast(std.c.environ));
```

**Source Analysis:** well-known global (guaranteed aligned): std.c.environ

**Auto-fixable:** True

**Action:** Replace @ptrCast(std.c.environ) with @ptrCast(@alignCast(std.c.environ))

---

### 218. `runtime/api/bun/process.zig:2262`

**Code:**
```zig
zust-port/src/runtime/api/bun/process.zig-2263-        return spawnWithArgv(options, @ptrCast(args.items.ptr), @ptrCast(envp));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): args.items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(args.items.ptr) with @ptrCast(@alignCast(args.items.ptr))

---

### 219. `runtime/api/bun/js_bun_spawn_bindings.zig:631`

**Code:**
```zig
zust-port/src/runtime/api/bun/js_bun_spawn_bindings.zig-632-        @ptrCast(argv.items.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): argv.items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(argv.items.ptr) with @ptrCast(@alignCast(argv.items.ptr))

---

### 220. `runtime/api/bun/js_bun_spawn_bindings.zig:633`

**Code:**
```zig
zust-port/src/runtime/api/bun/js_bun_spawn_bindings.zig-634-        @ptrCast(env_array.items.ptr),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): env_array.items.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(env_array.items.ptr) with @ptrCast(@alignCast(env_array.items.ptr))

---

### 221. `css/rules/import.zig:192`

**Code:**
```zig
zust-port/src/css/rules/import.zig-193-        return @ptrCast(&this.layer);
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.layer

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.layer) with @ptrCast(@alignCast(&this.layer))

---

### 222. `css/rules/import.zig:197`

**Code:**
```zig
zust-port/src/css/rules/import.zig-198-        return @ptrCast(&this.layer);
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.layer

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.layer) with @ptrCast(@alignCast(&this.layer))

---

### 223. `bun_alloc/MimallocArena.zig:269`

**Code:**
```zig
zust-port/src/bun_alloc/MimallocArena.zig-270-    return @ptrCast(mimalloc.mi_realloc_aligned(buf.ptr, new_len, alignment.toByteUnits()));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): mimalloc.mi_realloc_aligned(buf.ptr, new_len, alignment.toByteUnits())

**Auto-fixable:** True

**Action:** Replace @ptrCast(mimalloc.mi_realloc_aligned(buf.ptr, new_len, alignment.toByteUnits())) with @ptrCast(@alignCast(mimalloc.mi_realloc_aligned(buf.ptr, new_len, alignment.toByteUnits())))

---

### 224. `bun_alloc/basic.zig:64`

**Code:**
```zig
zust-port/src/bun_alloc/basic.zig-65-        return @ptrCast(mimalloc.mi_realloc_aligned(buf.ptr, new_len, alignment.toByteUnits()));
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): mimalloc.mi_realloc_aligned(buf.ptr, new_len, alignment.toByteUnits())

**Auto-fixable:** True

**Action:** Replace @ptrCast(mimalloc.mi_realloc_aligned(buf.ptr, new_len, alignment.toByteUnits())) with @ptrCast(@alignCast(mimalloc.mi_realloc_aligned(buf.ptr, new_len, alignment.toByteUnits())))

---

### 225. `css/css_parser.zig:7238`

**Code:**
```zig
zust-port/src/css/css_parser.zig-7239-    const buf_len = bun.fmt.FormatDouble.dtoa(@ptrCast(buf[1..].ptr), @floatCast(value)).len;
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): buf[1..].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(buf[1..].ptr) with @ptrCast(@alignCast(buf[1..].ptr))

---

### 226. `install/NetworkTask.zig:318`

**Code:**
```zig
zust-port/src/install/NetworkTask.zig-319-        header_builder.content = GlobalStringBuilder{ .ptr = @as([*]u8, @ptrCast(@constCast(header_buf.ptr))), .len = header_buf.len, .cap = header_buf.len };
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): @constCast(header_buf.ptr)

**Auto-fixable:** True

**Action:** Replace @ptrCast(@constCast(header_buf.ptr)) with @ptrCast(@alignCast(@constCast(header_buf.ptr)))

---

### 227. `install/windows-shim/BinLinkingShim.zig:266`

**Code:**
```zig
zust-port/src/install/windows-shim/BinLinkingShim.zig-267-        @as(*align(1) u32, @ptrCast(&wbuf[0])).* = @intCast(options.bin_path.len * 2);
```

**Source Analysis:** address-of operator (guaranteed aligned): &wbuf[0]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&wbuf[0]) with @ptrCast(@alignCast(&wbuf[0]))

---

### 228. `install/windows-shim/BinLinkingShim.zig:268`

**Code:**
```zig
zust-port/src/install/windows-shim/BinLinkingShim.zig-269-        @as(*align(1) u32, @ptrCast(&wbuf[2])).* = (s.utf16_len) * 2 + 2; // include the spaces!
```

**Source Analysis:** address-of operator (guaranteed aligned): &wbuf[2]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&wbuf[2]) with @ptrCast(@alignCast(&wbuf[2]))

---

### 229. `install/windows-shim/BinLinkingShim.zig:273`

**Code:**
```zig
zust-port/src/install/windows-shim/BinLinkingShim.zig-274-    @as(*align(1) Flags, @ptrCast(&wbuf[0])).* = flags;
```

**Source Analysis:** address-of operator (guaranteed aligned): &wbuf[0]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&wbuf[0]) with @ptrCast(@alignCast(&wbuf[0]))

---

### 230. `install/windows-shim/BinLinkingShim.zig:292`

**Code:**
```zig
zust-port/src/install/windows-shim/BinLinkingShim.zig-293-    const flags = @as(*align(1) const Flags, @ptrCast(&input[input.len - @sizeOf(Flags)])).*;
```

**Source Analysis:** address-of operator (guaranteed aligned): &input[input.len - @sizeOf(Flags)]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&input[input.len - @sizeOf(Flags)]) with @ptrCast(@alignCast(&input[input.len - @sizeOf(Flags)]))

---

### 231. `install/windows-shim/BinLinkingShim.zig:299`

**Code:**
```zig
zust-port/src/install/windows-shim/BinLinkingShim.zig-300-        const bin_path_byte_len = @as(*align(1) const u32, @ptrCast(&input[input.len - @sizeOf(Flags) - 2 * @sizeOf(u32)])).*;
```

**Source Analysis:** address-of operator (guaranteed aligned): &input[input.len - @sizeOf(Flags) - 2 * @sizeOf(u32)]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&input[input.len - @sizeOf(Flags) - 2 * @sizeOf(u32)]) with @ptrCast(@alignCast(&input[input.len - @sizeOf(Flags) - 2 * @sizeOf(u32)]))

---

### 232. `install/windows-shim/bun_shim_impl.zig:325`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-326-    const image_path_u8 = @as([*]u8, @ptrCast(if (is_standalone) ImagePathName.Buffer.? else bun_ctx.base_path.ptr))[0..image_path_b_len];
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): if (is_standalone) ImagePathName.Buffer.? else bun_ctx.base_path.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(if (is_standalone) ImagePathName.Buffer.? else bun_ctx.base_path.ptr) with @ptrCast(@alignCast(if (is_standalone) ImagePathName.Buffer.? else bun_ctx.base_path.ptr))

---

### 233. `install/windows-shim/bun_shim_impl.zig:343`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-344-    const buf1_u8 = @as([*]u8, @ptrCast(&buf1[0]))[comptime buf1.len..];
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf1[0]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf1[0]) with @ptrCast(@alignCast(&buf1[0]))

---

### 234. `install/windows-shim/bun_shim_impl.zig:345`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-346-    const buf1_u16 = @as([*]u16, @ptrCast(&buf1[0]))[comptime buf1.len / 2..];
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf1[0]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf1[0]) with @ptrCast(@alignCast(&buf1[0]))

---

### 235. `install/windows-shim/bun_shim_impl.zig:348`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-349-    const buf2_u8 = @as([*]u8, @ptrCast(&buf2[0]))[comptime buf2.len..];
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf2[0]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf2[0]) with @ptrCast(@alignCast(&buf2[0]))

---

### 236. `install/windows-shim/bun_shim_impl.zig:350`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-351-    const buf2_u16 = @as([*:0]u16, @ptrCast(&buf2[0]))[comptime buf2.len / 2..];
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf2[0]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf2[0]) with @ptrCast(@alignCast(&buf2[0]))

---

### 237. `install/windows-shim/bun_shim_impl.zig:358`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-359-        @as(*align(1) u64, @ptrCast(&buf1_u8[0])).* = @as(u64, @bitCast(nt_object_prefix));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf1_u8[0]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf1_u8[0]) with @ptrCast(@alignCast(&buf1_u8[0]))

---

### 238. `install/windows-shim/bun_shim_impl.zig:381`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-382-        @as(*align(1) u64, @ptrCast(&buf1_u8[image_path_b_len + 2 * (nt_object_prefix.len - "exe".len)])).* = @as(u64, @bitCast([4]u16{ 'b', 'u', 'n', 'x' }));
```

**Source Analysis:** address-of operator (guaranteed aligned): &buf1_u8[image_path_b_len + 2 * (nt_object_prefix.len - "exe".len)]

**Auto-fixable:** True

**Action:** Replace @ptrCast(&buf1_u8[image_path_b_len + 2 * (nt_object_prefix.len - "exe".len)]) with @ptrCast(@alignCast(&buf1_u8[image_path_b_len + 2 * (nt_object_prefix.len - "exe".len)]))

---

### 239. `sql_jsc/postgres/DataCell.zig:536`

**Code:**
```zig
zust-port/src/sql_jsc/postgres/DataCell.zig-537-                            .ptr = if (elements.len > 0) @ptrCast(elements.ptr) else null,
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): elements.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(elements.ptr) with @ptrCast(@alignCast(elements.ptr))

---

### 240. `sql_jsc/shared/SQLDataCell.zig:129`

**Code:**
```zig
zust-port/src/sql_jsc/shared/SQLDataCell.zig-130-                .value = .{ .raw = .{ .ptr = @ptrCast(bytes_slice.ptr), .len = bytes_slice.len } },
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): bytes_slice.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(bytes_slice.ptr) with @ptrCast(@alignCast(bytes_slice.ptr))

---

### 241. `watcher/INotifyWatcher.zig:208`

**Code:**
```zig
zust-port/src/watcher/INotifyWatcher.zig-209-        const event: *align(1) Event = @ptrCast(read_eventlist_bytes[i..][0..@sizeOf(Event)].ptr);
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): read_eventlist_bytes[i..][0..@sizeOf(Event)].ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(read_eventlist_bytes[i..][0..@sizeOf(Event)].ptr) with @ptrCast(@alignCast(read_eventlist_bytes[i..][0..@sizeOf(Event)].ptr))

---

### 242. `js_parser_jsc/Macro.zig:253`

**Code:**
```zig
zust-port/src/js_parser_jsc/Macro.zig-254-                @as([*]js.JSObjectRef, @ptrCast(args.ptr)),
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): args.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(args.ptr) with @ptrCast(@alignCast(args.ptr))

---

### 243. `test_runner/diff_format.zig:42`

**Code:**
```zig
zust-port/src/test_runner/diff_format.zig-43-                @as([*]const JSValue, @ptrCast(&received)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &received

**Auto-fixable:** True

**Action:** Replace @ptrCast(&received) with @ptrCast(@alignCast(&received))

---

### 244. `test_runner/diff_format.zig:52`

**Code:**
```zig
zust-port/src/test_runner/diff_format.zig-53-                @as([*]const JSValue, @ptrCast(&this.expected)),
```

**Source Analysis:** address-of operator (guaranteed aligned): &this.expected

**Auto-fixable:** True

**Action:** Replace @ptrCast(&this.expected) with @ptrCast(@alignCast(&this.expected))

---

### 245. `install/lifecycle_script_runner.zig:232`

**Code:**
```zig
zust-port/src/install/lifecycle_script_runner.zig-233-        var spawned = try (try bun.spawn.spawnProcess(&spawn_options, @ptrCast(&argv), this.envp)).unwrap();
```

**Source Analysis:** address-of operator (guaranteed aligned): &argv

**Auto-fixable:** True

**Action:** Replace @ptrCast(&argv) with @ptrCast(@alignCast(&argv))

---

### 246. `install/PackageManager/updatePackageJSONAndInstall.zig:726`

**Code:**
```zig
zust-port/src/install/PackageManager/updatePackageJSONAndInstall.zig-727-            .onFetch = @ptrCast(&Analyzer.onAnalyze),
```

**Source Analysis:** address-of operator (guaranteed aligned): &Analyzer.onAnalyze

**Auto-fixable:** True

**Action:** Replace @ptrCast(&Analyzer.onAnalyze) with @ptrCast(@alignCast(&Analyzer.onAnalyze))

---

### 247. `options_types/schema.zig:93`

**Code:**
```zig
zust-port/src/options_types/schema.zig-94-                        return @as([*]T, @ptrCast(enum_values.ptr))[0..length];
```

**Source Analysis:** typed slice .ptr (guaranteed aligned): enum_values.ptr

**Auto-fixable:** True

**Action:** Replace @ptrCast(enum_values.ptr) with @ptrCast(@alignCast(enum_values.ptr))

---

## Category: NO (293 items)

### 1. `bun.zig:419`

**Code:**
```zig
zust-port/src/bun.zig-420-                const sentinel = @as(*align(1) const info.child, @ptrCast(sentinel_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): sentinel_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 2. `bun.zig:488`

**Code:**
```zig
zust-port/src/bun.zig-489-        const s = @as(*align(1) const ptr_info.child, @ptrCast(s_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): s_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 3. `bun.zig:1401`

**Code:**
```zig
zust-port/src/bun.zig-1402-                        const sentinel = @as(*align(1) const array_info.child, @ptrCast(sentinel_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): sentinel_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 4. `bun.zig:1412`

**Code:**
```zig
zust-port/src/bun.zig-1413-                const sentinel = @as(*align(1) const ptr_info.child, @ptrCast(sentinel_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): sentinel_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 5. `bun.zig:1427`

**Code:**
```zig
zust-port/src/bun.zig-1428-                    const sentinel = @as(*align(1) const ptr_info.child, @ptrCast(sentinel_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): sentinel_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 6. `bun.zig:1458`

**Code:**
```zig
zust-port/src/bun.zig-1459-                            const sentinel = @as(*align(1) const array_info.child, @ptrCast(sentinel_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): sentinel_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 7. `bun.zig:1474`

**Code:**
```zig
zust-port/src/bun.zig-1475-                        const sentinel = @as(*align(1) const ptr_info.child, @ptrCast(sentinel_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): sentinel_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 8. `bun.zig:1524`

**Code:**
```zig
zust-port/src/bun.zig-1525-        const s = @as(*align(1) const ptr_info.child, @ptrCast(s_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): s_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 9. `libarchive/libarchive.zig:652`

**Code:**
```zig
zust-port/src/libarchive/libarchive.zig-653-                                                const archive_error = bun.sliceTo(lib.Archive.errorString(@ptrCast(archive)), 0);
```

**Source Analysis:** function parameter (alignment unknown): archive

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 10. `tcc_sys/tcc.zig:121`

**Code:**
```zig
zust-port/src/tcc_sys/tcc.zig-122-        tcc_set_error_func(s, errorOpaque, @ptrCast(errorFunc));
```

**Source Analysis:** function parameter (alignment unknown): errorFunc

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 11. `runtime/socket/socket.zig:2194`

**Code:**
```zig
zust-port/src/runtime/socket/socket.zig-2195-        .ctx = @ptrCast(duplexContext),
```

**Source Analysis:** function parameter (alignment unknown): duplexContext

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 12. `clap/clap.zig:678`

**Code:**
```zig
zust-port/src/clap/clap.zig-679-        const name = if (param.names.short) |*s| @as([*]const u8, @ptrCast(s))[0..1] else param.names.long orelse {
```

**Source Analysis:** function parameter (alignment unknown): s

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 13. `event_loop/ConcurrentTask.zig:46`

**Code:**
```zig
zust-port/src/event_loop/ConcurrentTask.zig-47-        const value = @atomicLoad(usize, @as(*const usize, @ptrCast(self)), ordering);
```

**Source Analysis:** function parameter (alignment unknown): self

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 14. `event_loop/ConcurrentTask.zig:56`

**Code:**
```zig
zust-port/src/event_loop/ConcurrentTask.zig-57-        const self_ptr: *usize = @ptrCast(self);
```

**Source Analysis:** function parameter (alignment unknown): self

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 15. `runtime/socket/udp_socket.zig:77`

**Code:**
```zig
zust-port/src/runtime/socket/udp_socket.zig-78-                const peer4: *std.posix.sockaddr.in = @ptrCast(peer);
```

**Source Analysis:** function parameter (alignment unknown): peer

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 16. `runtime/socket/udp_socket.zig:83`

**Code:**
```zig
zust-port/src/runtime/socket/udp_socket.zig-84-                const peer6: *std.posix.sockaddr.in6 = @ptrCast(peer);
```

**Source Analysis:** function parameter (alignment unknown): peer

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 17. `runtime/socket/udp_socket.zig:861`

**Code:**
```zig
zust-port/src/runtime/socket/udp_socket.zig-862-        var addr4: *std.posix.sockaddr.in = @ptrCast(storage);
```

**Source Analysis:** function parameter (alignment unknown): storage

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 18. `runtime/socket/udp_socket.zig:868`

**Code:**
```zig
zust-port/src/runtime/socket/udp_socket.zig-869-            var addr6: *std.posix.sockaddr.in6 = @ptrCast(storage);
```

**Source Analysis:** function parameter (alignment unknown): storage

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 19. `std_fs_compat.zig:8`

**Code:**
```zig
zust-port/src/std_fs_compat.zig-9-    const p: [*:0]const u8 = @ptrCast(ptr);
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 20. `runtime/valkey_jsc/js_valkey.zig:1489`

**Code:**
```zig
zust-port/src/runtime/valkey_jsc/js_valkey.zig-1490-                    const ssl_ptr: *BoringSSL.c.SSL = @ptrCast(this.client.socket.getNativeHandle());
```

**Source Analysis:** field access on unknown/param: this.client.socket.getNativeHandle()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 21. `libuv_sys/libuv.zig:442`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-443-            return uv_handle_get_loop(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 22. `libuv_sys/libuv.zig:446`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-447-            uv_handle_set_data(@ptrCast(handle), ptr);
```

**Source Analysis:** function parameter (alignment unknown): handle

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 23. `libuv_sys/libuv.zig:452`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-453-            uv_close(@ptrCast(this), @ptrCast(cb));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 24. `libuv_sys/libuv.zig:457`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-458-            return uv_has_ref(@ptrCast(this)) != 0;
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 25. `libuv_sys/libuv.zig:464`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-465-            uv_ref(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 26. `libuv_sys/libuv.zig:471`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-472-            uv_unref(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 27. `libuv_sys/libuv.zig:476`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-477-            return uv_is_closing(@ptrCast(this)) != 0;
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 28. `libuv_sys/libuv.zig:481`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-482-            return uv_is_closed(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 29. `libuv_sys/libuv.zig:486`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-487-            return uv_is_active(@ptrCast(this)) != 0;
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 30. `libuv_sys/libuv.zig:492`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-493-            _ = uv_fileno(@ptrCast(this), &fd_);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 31. `libuv_sys/libuv.zig:506`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-507-            return @ptrCast(uv_req_get_data(@ptrCast(this)));
```

**Source Analysis:** function return (alignment unknown): uv_req_get_data(@ptrCast(this))

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 32. `libuv_sys/libuv.zig:510`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-511-            return uv_handle_get_loop(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 33. `libuv_sys/libuv.zig:514`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-515-            uv_req_set_data(@ptrCast(handle), ptr);
```

**Source Analysis:** function parameter (alignment unknown): handle

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 34. `libuv_sys/libuv.zig:518`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-519-            _ = uv_cancel(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 35. `libuv_sys/libuv.zig:632`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-633-        if (uv_async_init(loop, @ptrCast(this), callback) != 0) {
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 36. `libuv_sys/libuv.zig:1356`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-1357-            const rc = uv_write(req, stream, @ptrCast(input), 1, &Wrapper.uvWriteCb);
```

**Source Analysis:** function parameter (alignment unknown): input

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 37. `libuv_sys/libuv.zig:1367`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-1368-        const rc = uv_write(req, stream, @ptrCast(input), 1, null);
```

**Source Analysis:** function parameter (alignment unknown): input

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 38. `libuv_sys/libuv.zig:1472`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-1473-        this.data = @ptrCast(context);
```

**Source Analysis:** function parameter (alignment unknown): context

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 39. `libuv_sys/libuv.zig:1491`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-1492-        return @ptrCast(this);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 40. `libuv_sys/libuv.zig:3077`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3078-            return uv_stream_get_write_queue_size(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 41. `libuv_sys/libuv.zig:3082`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3083-            this.data = @ptrCast(context);
```

**Source Analysis:** function parameter (alignment unknown): context

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 42. `libuv_sys/libuv.zig:3089`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3090-            if (uv_listen(@ptrCast(this), backlog, &Wrapper.uvConnectCb).toError(.listen)) |err| {
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 43. `libuv_sys/libuv.zig:3097`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3098-            if (uv_accept(@ptrCast(this), @ptrCast(client)).toError(.accept)) |err| {
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 44. `libuv_sys/libuv.zig:3112`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3113-            this.data = @ptrCast(context);
```

**Source Analysis:** function parameter (alignment unknown): context

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 45. `libuv_sys/libuv.zig:3132`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3133-            if (uv_read_start(@ptrCast(this), @ptrCast(&Wrapper.uvAllocb), @ptrCast(&Wrapper.uvReadcb)).toError(.listen)) |err| {
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 46. `libuv_sys/libuv.zig:3141`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3142-            _ = uv_read_stop(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 47. `libuv_sys/libuv.zig:3160`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3161-                if (uv_write(uv_data, @ptrCast(this), @ptrCast(input), 1, &Wrapper.uvWriteCb).toError(.write)) |err| {
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 48. `libuv_sys/libuv.zig:3168`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3169-            if (uv_write(&req, this, @ptrCast(input), 1, null).toError(.write)) |err| {
```

**Source Analysis:** function parameter (alignment unknown): input

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 49. `libuv_sys/libuv.zig:3178`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3179-            const rc = uv_try_write(@ptrCast(this), @ptrCast(&uv_buf_t.init(input)), 1);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 50. `libuv_sys/libuv.zig:3189`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3190-            const rc = uv_try_write2(@ptrCast(this), @ptrCast(&uv_buf_t.init(input)), 1, send_handle);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 51. `libuv_sys/libuv.zig:3199`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3200-            return uv_is_readable(@ptrCast(this)) != 0;
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 52. `libuv_sys/libuv.zig:3204`

**Code:**
```zig
zust-port/src/libuv_sys/libuv.zig-3205-            return uv_is_writable(@ptrCast(this)) != 0;
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 53. `jsc/AnyPromise.zig:58`

**Code:**
```zig
zust-port/src/jsc/AnyPromise.zig-59-            .internal => |p| @ptrCast(p),
```

**Source Analysis:** function parameter (alignment unknown): p

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 54. `cares_sys/c_ares.zig:496`

**Code:**
```zig
zust-port/src/cares_sys/c_ares.zig-497-        opts.sock_state_cb_data = @as(*anyopaque, @ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 55. `jsc/jsc.zig:24`

**Code:**
```zig
zust-port/src/jsc/jsc.zig-25-    JSCInitialize(@as([*]const [*:0]u8, @ptrCast(envp)), env_len, onJSCInvalidEnvVar, eval_mode);
```

**Source Analysis:** function parameter (alignment unknown): envp

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 56. `http/ThreadSafeStreamBuffer.zig:15`

**Code:**
```zig
zust-port/src/http/ThreadSafeStreamBuffer.zig-16-        return .{ .callback = @ptrCast(callback), .context = @ptrCast(context) };
```

**Source Analysis:** function parameter (alignment unknown): callback

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 57. `jsc/JSGlobalObject.zig:641`

**Code:**
```zig
zust-port/src/jsc/JSGlobalObject.zig-642-                bun.assert(this.bunVMUnsafe() == @as(*anyopaque, @ptrCast(vm_)));
```

**Source Analysis:** function parameter (alignment unknown): vm_

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 58. `jsc/JSGlobalObject.zig:660`

**Code:**
```zig
zust-port/src/jsc/JSGlobalObject.zig-661-                bun.assert(this.bunVMUnsafe() == @as(*anyopaque, @ptrCast(vm_)));
```

**Source Analysis:** function parameter (alignment unknown): vm_

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 59. `http/HTTPContext.zig:416`

**Code:**
```zig
zust-port/src/http/HTTPContext.zig-417-                            const ssl_ptr = @as(*BoringSSL.SSL, @ptrCast(socket.getNativeHandle()));
```

**Source Analysis:** field access on unknown/param: socket.getNativeHandle()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 60. `jsc/ModuleLoader.zig:552`

**Code:**
```zig
zust-port/src/jsc/ModuleLoader.zig-553-            const module_info_deserialized: ?*anyopaque = if (module_info) |mi| @ptrCast(mi.asDeserialized()) else null;
```

**Source Analysis:** field access on unknown/param: mi.asDeserialized()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 61. `jsc/ModuleLoader.zig:644`

**Code:**
```zig
zust-port/src/jsc/ModuleLoader.zig-645-                            .u = .{ .ptr = @ptrCast(globalThis) },
```

**Source Analysis:** function parameter (alignment unknown): globalThis

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 62. `http/http.zig:232`

**Code:**
```zig
zust-port/src/http/http.zig-233-        var ssl_ptr: *BoringSSL.SSL = @ptrCast(socket.getNativeHandle());
```

**Source Analysis:** field access on unknown/param: socket.getNativeHandle()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 63. `http/http.zig:316`

**Code:**
```zig
zust-port/src/http/http.zig-317-        const ssl_ptr: *BoringSSL.SSL = @ptrCast(socket.getNativeHandle());
```

**Source Analysis:** field access on unknown/param: socket.getNativeHandle()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 64. `runtime/node/zlib/NativeBrotli.zig:150`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeBrotli.zig-151-                this.state = @ptrCast((state.?));
```

**Source Analysis:** optional unwrapping (alignment unknown): (state.?)

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 65. `runtime/node/zlib/NativeBrotli.zig:161`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeBrotli.zig-162-                this.state = @ptrCast((state.?));
```

**Source Analysis:** optional unwrapping (alignment unknown): (state.?)

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 66. `runtime/node/zlib/NativeBrotli.zig:172`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeBrotli.zig-173-                if (c.BrotliEncoderSetParameter(@ptrCast(this.state), key, value) == 0) {
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 67. `runtime/node/zlib/NativeBrotli.zig:179`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeBrotli.zig-180-                if (c.BrotliDecoderSetParameter(@ptrCast(this.state), key, value) == 0) {
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 68. `runtime/node/zlib/NativeBrotli.zig:222`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeBrotli.zig-223-                this.last_result.e = c.BrotliEncoderCompressStream(@ptrCast(this.state), this.flush, &this.avail_in, &next_in, &this.avail_out, &this.next_out, null);
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 69. `runtime/node/zlib/NativeBrotli.zig:228`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeBrotli.zig-229-                this.last_result.d = c.BrotliDecoderDecompressStream(@ptrCast(this.state), &this.avail_in, &next_in, &this.avail_out, &this.next_out, null);
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 70. `runtime/node/zlib/NativeBrotli.zig:232`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeBrotli.zig-233-                    this.error_ = c.BrotliDecoderGetErrorCode(@ptrCast(this.state));
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 71. `runtime/node/zlib/NativeZstd.zig:164`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeZstd.zig-165-                const result = c.ZSTD_CCtx_setParameter(@ptrCast(this.state), key, @bitCast(value));
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 72. `runtime/node/zlib/NativeZstd.zig:170`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeZstd.zig-171-                const result = c.ZSTD_DCtx_setParameter(@ptrCast(this.state), key, @bitCast(value));
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 73. `runtime/node/zlib/NativeZstd.zig:190`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeZstd.zig-191-            .ZSTD_COMPRESS => c.ZSTD_freeCCtx(@ptrCast(this.state)),
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 74. `runtime/node/zlib/NativeZstd.zig:192`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeZstd.zig-193-            .ZSTD_DECOMPRESS => c.ZSTD_freeDCtx(@ptrCast(this.state)),
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 75. `runtime/node/zlib/NativeZstd.zig:214`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeZstd.zig-215-            .ZSTD_COMPRESS => c.ZSTD_compressStream2(@ptrCast(this.state), &this.output, &this.input, @intCast(this.flush)),
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 76. `runtime/node/zlib/NativeZstd.zig:216`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeZstd.zig-217-            .ZSTD_DECOMPRESS => c.ZSTD_decompressStream(@ptrCast(this.state), &this.output, &this.input),
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 77. `runtime/node/zlib/NativeZstd.zig:275`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeZstd.zig-276-            .ZSTD_COMPRESS => c.ZSTD_CCtx_reset(@ptrCast(this.state), c.ZSTD_reset_session_and_parameters),
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 78. `runtime/node/zlib/NativeZstd.zig:277`

**Code:**
```zig
zust-port/src/runtime/node/zlib/NativeZstd.zig-278-            .ZSTD_DECOMPRESS => c.ZSTD_DCtx_reset(@ptrCast(this.state), c.ZSTD_reset_session_and_parameters),
```

**Source Analysis:** field access on unknown/param: this.state

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 79. `runtime/node/win_watcher.zig:106`

**Code:**
```zig
zust-port/src/runtime/node/win_watcher.zig-107-            bun.assert(event.data == @as(?*anyopaque, @ptrCast(this)));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 80. `jsc/CachedBytecode.zig:60`

**Code:**
```zig
zust-port/src/jsc/CachedBytecode.zig-61-                CachedBytecode__deref(@ptrCast(ctx));
```

**Source Analysis:** function parameter (alignment unknown): ctx

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 81. `jsc/bindgen.zig:181`

**Code:**
```zig
zust-port/src/jsc/bindgen.zig-182-                var storage: []u8 = @ptrCast(unmanaged.allocatedSlice());
```

**Source Analysis:** function return (alignment unknown): unmanaged.allocatedSlice()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 82. `runtime/node/node_fs.zig:4609`

**Code:**
```zig
zust-port/src/runtime/node/node_fs.zig-4610-        return switch (Syscall.pwritev(args.fd, @ptrCast(args.buffers.buffers.items), position)) {
```

**Source Analysis:** field access on unknown/param: args.buffers.buffers.items

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 83. `runtime/node/node_fs.zig:4624`

**Code:**
```zig
zust-port/src/runtime/node/node_fs.zig-4625-        return switch (Syscall.writev(args.fd, @ptrCast(args.buffers.buffers.items))) {
```

**Source Analysis:** field access on unknown/param: args.buffers.buffers.items

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 84. `sys/fd.zig:183`

**Code:**
```zig
zust-port/src/sys/fd.zig-184-            .windows => @ptrCast(fd.native()),
```

**Source Analysis:** function return (alignment unknown): fd.native()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 85. `runtime/node/uv_signal_handle_windows.zig:20`

**Code:**
```zig
zust-port/src/runtime/node/uv_signal_handle_windows.zig-21-        libuv.uv_close(@ptrCast(signal), &freeWithDefaultAllocator);
```

**Source Analysis:** function parameter (alignment unknown): signal

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 86. `runtime/node/uv_signal_handle_windows.zig:25`

**Code:**
```zig
zust-port/src/runtime/node/uv_signal_handle_windows.zig-26-    libuv.uv_unref(@ptrCast(signal));
```

**Source Analysis:** function parameter (alignment unknown): signal

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 87. `runtime/node/uv_signal_handle_windows.zig:37`

**Code:**
```zig
zust-port/src/runtime/node/uv_signal_handle_windows.zig-38-    libuv.uv_close(@ptrCast(signal), &freeWithDefaultAllocator);
```

**Source Analysis:** function parameter (alignment unknown): signal

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 88. `runtime/node/path_watcher.zig:728`

**Code:**
```zig
zust-port/src/runtime/node/path_watcher.zig-729-            @ptrCast(watcher),
```

**Source Analysis:** function parameter (alignment unknown): watcher

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 89. `runtime/webcore/Blob.zig:5047`

**Code:**
```zig
zust-port/src/runtime/webcore/Blob.zig-5048-                this.req.data = @ptrCast(this);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 90. `exe_format/macho.zig:38`

**Code:**
```zig
zust-port/src/exe_format/macho.zig-39-                const sects_ptr: [*]align(1) const macho.section_64 = @ptrCast(entry.data[@sizeOf(macho.segment_command_64)..]);
```

**Source Analysis:** field access on unknown/param: entry.data[@sizeOf(macho.segment_command_64)..]

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 91. `exe_format/macho.zig:57`

**Code:**
```zig
zust-port/src/exe_format/macho.zig-58-                const tools_ptr: [*]align(1) const macho.build_tool_version = @ptrCast(entry.data[@sizeOf(macho.build_version_command)..]);
```

**Source Analysis:** field access on unknown/param: entry.data[@sizeOf(macho.build_version_command)..]

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 92. `collections/hive_array.zig:47`

**Code:**
```zig
zust-port/src/collections/hive_array.zig-48-            bun.asan.assertUnpoisoned(@ptrCast(value));
```

**Source Analysis:** function parameter (alignment unknown): value

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 93. `collections/hive_array.zig:64`

**Code:**
```zig
zust-port/src/collections/hive_array.zig-65-            bun.asan.assertUnpoisoned(@ptrCast(value));
```

**Source Analysis:** function parameter (alignment unknown): value

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 94. `standalone_graph/StandaloneModuleGraph.zig:141`

**Code:**
```zig
zust-port/src/standalone_graph/StandaloneModuleGraph.zig-142-                const slice_ptr: [*]const u8 = @ptrCast(length);
```

**Source Analysis:** function parameter (alignment unknown): length

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 95. `standalone_graph/StandaloneModuleGraph.zig:1422`

**Code:**
```zig
zust-port/src/standalone_graph/StandaloneModuleGraph.zig-1423-            return @as([*]align(1) const StringPointer, @ptrCast(map.bytes[@sizeOf(Header)..]))[0..head.source_files_count];
```

**Source Analysis:** function return (alignment unknown): map.bytes[@sizeOf(Header)..]

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 96. `standalone_graph/StandaloneModuleGraph.zig:1428`

**Code:**
```zig
zust-port/src/standalone_graph/StandaloneModuleGraph.zig-1429-            return @as([*]align(1) const StringPointer, @ptrCast(map.bytes[@sizeOf(Header)..]))[head.source_files_count..][0..head.source_files_count];
```

**Source Analysis:** function return (alignment unknown): map.bytes[@sizeOf(Header)..]

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 97. `libarchive_sys/bindings.zig:679`

**Code:**
```zig
zust-port/src/libarchive_sys/bindings.zig-680-        const r = archive_read_data_block(@ptrCast(archive), @ptrCast(&buff), &size, offset);
```

**Source Analysis:** function parameter (alignment unknown): archive

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 98. `libarchive_sys/bindings.zig:953`

**Code:**
```zig
zust-port/src/libarchive_sys/bindings.zig-954-            return @intCast(archive_entry_mtime(@ptrCast(entry)));
```

**Source Analysis:** function parameter (alignment unknown): entry

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 99. `libarchive_sys/bindings.zig:1508`

**Code:**
```zig
zust-port/src/libarchive_sys/bindings.zig-1509-        const data: [*]const u8 = @ptrCast(buff.?);
```

**Source Analysis:** optional unwrapping (alignment unknown): buff.?

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 100. `boringssl/boringssl.zig:68`

**Code:**
```zig
zust-port/src/boringssl/boringssl.zig-69-    @memset(@as([*]u8, @ptrCast(ptr))[0..len], 0);
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 101. `runtime/webcore/blob/write_file.zig:113`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/write_file.zig-114-            @as(*anyopaque, @ptrCast(context)),
```

**Source Analysis:** function parameter (alignment unknown): context

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 102. `runtime/webcore/blob/write_file.zig:657`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/write_file.zig-658-            @as(*anyopaque, @ptrCast(context)),
```

**Source Analysis:** function parameter (alignment unknown): context

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 103. `runtime/webcore/blob/write_file.zig:659`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/write_file.zig-660-            @ptrCast(callback),
```

**Source Analysis:** function parameter (alignment unknown): callback

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 104. `runtime/webcore/blob/read_file.zig:126`

**Code:**
```zig
zust-port/src/runtime/webcore/blob/read_file.zig-127-        return try ReadFile.createWithCtx(allocator, store, @as(*anyopaque, @ptrCast(context)), Handler.run, off, max_len);
```

**Source Analysis:** function parameter (alignment unknown): context

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 105. `runtime/server/NodeHTTPResponse.zig:305`

**Code:**
```zig
zust-port/src/runtime/server/NodeHTTPResponse.zig-306-            .context = @ptrCast(upgrade_ctx),
```

**Source Analysis:** function parameter (alignment unknown): upgrade_ctx

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 106. `runtime/server/NodeHTTPResponse.zig:509`

**Code:**
```zig
zust-port/src/runtime/server/NodeHTTPResponse.zig-510-        .TCP => NodeHTTPServer__writeHead_http(globalObject, status_message.ptr, status_message.len, headers, @ptrCast(response.TCP)),
```

**Source Analysis:** field access on unknown/param: response.TCP

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 107. `runtime/server/NodeHTTPResponse.zig:511`

**Code:**
```zig
zust-port/src/runtime/server/NodeHTTPResponse.zig-512-        .SSL => NodeHTTPServer__writeHead_https(globalObject, status_message.ptr, status_message.len, headers, @ptrCast(response.SSL)),
```

**Source Analysis:** field access on unknown/param: response.SSL

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 108. `runtime/server/server.zig:2616`

**Code:**
```zig
zust-port/src/runtime/server/server.zig-2617-                upgradeWebSocketUserRoute(@ptrCast(this), resp, req, upgrade_ctx, null);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 109. `jsc/MarkedArgumentBuffer.zig:9`

**Code:**
```zig
zust-port/src/jsc/MarkedArgumentBuffer.zig-10-        MarkedArgumentBuffer__run(@ptrCast(ctx), @ptrCast(func));
```

**Source Analysis:** function parameter (alignment unknown): ctx

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 110. `runtime/server/RequestContext.zig:2252`

**Code:**
```zig
zust-port/src/runtime/server/RequestContext.zig-2253-                cookies.write(this.server.?.globalThis, resp_kind, @ptrCast(this.resp.?)) catch return; // TODO: properly propagate exception upwards
```

**Source Analysis:** field access on unknown/param: this.resp.?

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 111. `jsc/RuntimeTranspilerStore.zig:618`

**Code:**
```zig
zust-port/src/jsc/RuntimeTranspilerStore.zig-619-                .module_info = if (module_info) |mi| @ptrCast(mi.asDeserialized()) else null,
```

**Source Analysis:** field access on unknown/param: mi.asDeserialized()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 112. `jsc/FFI.zig:73`

**Code:**
```zig
zust-port/src/jsc/FFI.zig-74-    return UINT64_TO_JSVALUE_SLOW(@as(*jsc.JSGlobalObject, @ptrCast(globalObject.?)), val).asEncoded();
```

**Source Analysis:** field access on unknown/param: globalObject.?

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 113. `jsc/FFI.zig:86`

**Code:**
```zig
zust-port/src/jsc/FFI.zig-87-    return INT64_TO_JSVALUE_SLOW(@as(*jsc.JSGlobalObject, @ptrCast(globalObject.?)), val).asEncoded();
```

**Source Analysis:** field access on unknown/param: globalObject.?

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 114. `jsc/virtual_machine_exports.zig:184`

**Code:**
```zig
zust-port/src/jsc/virtual_machine_exports.zig-185-    vm.source_mappings.putBakeSourceProvider(@as(*BakeSourceProvider, @ptrCast(opaque_source_provider)), slice.slice());
```

**Source Analysis:** function parameter (alignment unknown): opaque_source_provider

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 115. `jsc/virtual_machine_exports.zig:192`

**Code:**
```zig
zust-port/src/jsc/virtual_machine_exports.zig-193-    vm.source_mappings.putDevServerSourceProvider(@as(*DevServerSourceProvider, @ptrCast(opaque_source_provider)), slice.slice());
```

**Source Analysis:** function parameter (alignment unknown): opaque_source_provider

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 116. `jsc/virtual_machine_exports.zig:200`

**Code:**
```zig
zust-port/src/jsc/virtual_machine_exports.zig-201-    vm.source_mappings.removeDevServerSourceProvider(@as(*DevServerSourceProvider, @ptrCast(opaque_source_provider)), slice.slice());
```

**Source Analysis:** function parameter (alignment unknown): opaque_source_provider

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 117. `jsc/JSValue.zig:2271`

**Code:**
```zig
zust-port/src/jsc/JSValue.zig-2272-        const func = @as(*const fn (vm: *VM, globalObject: *JSGlobalObject, ctx: ?*anyopaque, nextValue: JSValue) callconv(.c) void, @ptrCast(callback));
```

**Source Analysis:** function parameter (alignment unknown): callback

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 118. `uws_sys/socket.zig:123`

**Code:**
```zig
zust-port/src/uws_sys/socket.zig-124-                    return @as(*BoringSSL.SSL, @ptrCast(handle));
```

**Source Analysis:** function parameter (alignment unknown): handle

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 119. `uws_sys/socket.zig:137`

**Code:**
```zig
zust-port/src/uws_sys/socket.zig-138-                .upgradedDuplex => |socket| if (is_ssl) @as(*anyopaque, @ptrCast(socket.ssl() orelse return null)) else null,
```

**Source Analysis:** field access on unknown/param: socket.ssl() orelse return null

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 120. `uws_sys/socket.zig:139`

**Code:**
```zig
zust-port/src/uws_sys/socket.zig-140-                .pipe => |socket| if (is_ssl and Environment.isWindows) @as(*anyopaque, @ptrCast(socket.ssl() orelse return null)) else null,
```

**Source Analysis:** field access on unknown/param: socket.ssl() orelse return null

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 121. `jsc/Debugger.zig:68`

**Code:**
```zig
zust-port/src/jsc/Debugger.zig-69-                    uv.uv_close(@ptrCast(handle), deinitTimer);
```

**Source Analysis:** function parameter (alignment unknown): handle

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 122. `jsc/VirtualMachine.zig:2951`

**Code:**
```zig
zust-port/src/jsc/VirtualMachine.zig-2952-                    cached = .{ .ism = .{ .data = @as([*]const u8, @ptrCast(ptr)) } };
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 123. `jsc/AbortSignal.zig:29`

**Code:**
```zig
zust-port/src/jsc/AbortSignal.zig-30-        return this.addListener(@as(?*anyopaque, @ptrCast(ctx)), Wrapper.callback);
```

**Source Analysis:** function parameter (alignment unknown): ctx

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 124. `runtime/webcore/FileSink.zig:93`

**Code:**
```zig
zust-port/src/runtime/webcore/FileSink.zig-94-                    if (uv.uv_stream_set_blocking(@ptrCast(pipe), 1) == .zero) {
```

**Source Analysis:** function parameter (alignment unknown): pipe

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 125. `runtime/webcore/FileSink.zig:99`

**Code:**
```zig
zust-port/src/runtime/webcore/FileSink.zig-100-                    if (uv.uv_stream_set_blocking(@ptrCast(tty), 1) == .zero) {
```

**Source Analysis:** function parameter (alignment unknown): tty

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 126. `string/SmolStr.zig:172`

**Code:**
```zig
zust-port/src/string/SmolStr.zig-173-            const bytes: [*]const u8 = @ptrCast(this);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 127. `runtime/webcore/Body.zig:1792`

**Code:**
```zig
zust-port/src/runtime/webcore/Body.zig-1793-        locked.task = @ptrCast(sink);
```

**Source Analysis:** function parameter (alignment unknown): sink

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 128. `uws_sys/SocketContext.zig:78`

**Code:**
```zig
zust-port/src/uws_sys/SocketContext.zig-79-                    const path = std.mem.span(@as([*:0]const u8, @ptrCast(p)));
```

**Source Analysis:** function parameter (alignment unknown): p

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 129. `uws_sys/WebSocket.zig:6`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-7-            return @as(*RawWebSocket, @ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 130. `uws_sys/WebSocket.zig:94`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-95-        return @as(*uws.Socket, @ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 131. `uws_sys/WebSocket.zig:199`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-200-            inline else => |tls| uws.NewApp(tls).publishWithOptions(@ptrCast(app), topic, message, opcode, compress),
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 132. `uws_sys/WebSocket.zig:318`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-319-                    @as(*NewApp(is_ssl).Response, @ptrCast(res)),
```

**Source Analysis:** function parameter (alignment unknown): res

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 133. `jsc/hot_reloader.zig:546`

**Code:**
```zig
zust-port/src/jsc/hot_reloader.zig-547-                                        if (dir_ent.entries.get(@as([]const u8, @ptrCast(changed_name)))) |file_ent| {
```

**Source Analysis:** function parameter (alignment unknown): changed_name

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 134. `js_parser/ast/Parser.zig:372`

**Code:**
```zig
zust-port/src/js_parser/ast/Parser.zig-373-            bun.assert(binary_expression_stack_heap.fixed_buffer_allocator.ownsPtr(@ptrCast(p.binary_expression_stack.items)));
```

**Source Analysis:** field access on unknown/param: p.binary_expression_stack.items

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 135. `js_parser/ast/Parser.zig:374`

**Code:**
```zig
zust-port/src/js_parser/ast/Parser.zig-375-            bun.assert(binary_expression_simplify_stack_heap.fixed_buffer_allocator.ownsPtr(@ptrCast(p.binary_expression_simplify_stack.items)));
```

**Source Analysis:** field access on unknown/param: p.binary_expression_simplify_stack.items

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 136. `runtime/webcore/s3/client.zig:345`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/client.zig-346-    task.callback_context = @ptrCast(response_stream);
```

**Source Analysis:** function parameter (alignment unknown): response_stream

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 137. `runtime/webcore/s3/client.zig:538`

**Code:**
```zig
zust-port/src/runtime/webcore/s3/client.zig-539-    task.callback_context = @ptrCast(ctx);
```

**Source Analysis:** function parameter (alignment unknown): ctx

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 138. `runtime/webcore/encoding.zig:402`

**Code:**
```zig
zust-port/src/runtime/webcore/encoding.zig-403-                const input_u8 = @as([*]const u8, @ptrCast(input));
```

**Source Analysis:** function parameter (alignment unknown): input

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 139. `runtime/webcore/encoding.zig:412`

**Code:**
```zig
zust-port/src/runtime/webcore/encoding.zig-413-                const input_u8 = @as([*]const u8, @ptrCast(input));
```

**Source Analysis:** function parameter (alignment unknown): input

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 140. `uws_sys/App.zig:43`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-44-            return c.uws_app_close(ssl_flag, @as(*uws_app_s, @ptrCast(this)));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 141. `uws_sys/App.zig:48`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-49-            return c.uws_app_close_idle(ssl_flag, @as(*uws_app_s, @ptrCast(this)));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 142. `uws_sys/App.zig:53`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-54-            return @ptrCast(c.uws_create_app(ssl_flag, opts));
```

**Source Analysis:** field access on unknown/param: c.uws_create_app(ssl_flag, opts)

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 143. `uws_sys/App.zig:58`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-59-            return c.uws_app_destroy(ssl_flag, @as(*uws_app_s, @ptrCast(app)));
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 144. `uws_sys/App.zig:63`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-64-            return c.uws_app_set_flags(ssl_flag, @as(*uws_app_t, @ptrCast(this)), require_host_header, use_strict_method_validation);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 145. `uws_sys/App.zig:68`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-69-            return c.uws_app_set_max_http_header_size(ssl_flag, @as(*uws_app_t, @ptrCast(this)), max_header_size);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 146. `uws_sys/App.zig:73`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-74-            return c.uws_app_clear_routes(ssl_flag, @as(*uws_app_t, @ptrCast(app)));
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 147. `uws_sys/App.zig:81`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-82-                @ptrCast(app),
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 148. `uws_sys/App.zig:122`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-123-                return @as(*uws.ListenSocket, @ptrCast(this)).close();
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 149. `uws_sys/App.zig:126`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-127-                return @as(*uws.ListenSocket, @ptrCast(this)).getLocalPort();
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 150. `uws_sys/App.zig:131`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-132-                return uws.NewSocketHandler(ssl).from(@ptrCast(this));
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 151. `uws_sys/App.zig:144`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-145-            c.uws_app_get(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 152. `uws_sys/App.zig:155`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-156-            c.uws_app_post(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 153. `uws_sys/App.zig:166`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-167-            c.uws_app_options(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 154. `uws_sys/App.zig:177`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-178-            c.uws_app_delete(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 155. `uws_sys/App.zig:188`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-189-            c.uws_app_patch(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 156. `uws_sys/App.zig:199`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-200-            c.uws_app_put(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 157. `uws_sys/App.zig:210`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-211-            c.uws_app_head(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 158. `uws_sys/App.zig:221`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-222-            c.uws_app_connect(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 159. `uws_sys/App.zig:232`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-233-            c.uws_app_trace(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 160. `uws_sys/App.zig:265`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-266-            c.uws_app_any(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern.ptr, pattern.len, RouteHandler(UserDataType, handler).handle, if (UserDataType == void) null else user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 161. `uws_sys/App.zig:269`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-270-            c.uws_app_domain(ssl_flag, @as(*uws_app_t, @ptrCast(app)), pattern);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 162. `uws_sys/App.zig:273`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-274-            return c.uws_app_run(ssl_flag, @as(*uws_app_t, @ptrCast(app)));
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 163. `uws_sys/App.zig:286`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-287-                        @call(bun.callmod_inline, handler, .{ {}, @as(?*ThisApp.ListenSocket, @ptrCast(socket)), conf });
```

**Source Analysis:** function parameter (alignment unknown): socket

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 164. `uws_sys/App.zig:291`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-292-                            @as(?*ThisApp.ListenSocket, @ptrCast(socket)),
```

**Source Analysis:** function parameter (alignment unknown): socket

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 165. `uws_sys/App.zig:298`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-299-            return c.uws_app_listen(ssl_flag, @as(*uws_app_t, @ptrCast(app)), port, Wrapper.handle, user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 166. `uws_sys/App.zig:318`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-319-            return c.uws_app_set_on_clienterror(ssl_flag, @ptrCast(app), Wrapper.handle, @ptrCast(user_data));
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 167. `uws_sys/App.zig:332`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-333-                        @call(bun.callmod_inline, handler, .{ {}, @as(?*ThisApp.ListenSocket, @ptrCast(socket)) });
```

**Source Analysis:** function parameter (alignment unknown): socket

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 168. `uws_sys/App.zig:337`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-338-                            @as(?*ThisApp.ListenSocket, @ptrCast(socket)),
```

**Source Analysis:** function parameter (alignment unknown): socket

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 169. `uws_sys/App.zig:343`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-344-            return c.uws_app_listen_with_config(ssl_flag, @as(*uws_app_t, @ptrCast(app)), config.host, @as(u16, @intCast(config.port)), config.options, Wrapper.handle, user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 170. `uws_sys/App.zig:358`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-359-                        @call(bun.callmod_inline, handler, .{ {}, @as(?*ThisApp.ListenSocket, @ptrCast(socket)) });
```

**Source Analysis:** function parameter (alignment unknown): socket

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 171. `uws_sys/App.zig:363`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-364-                            @as(?*ThisApp.ListenSocket, @ptrCast(socket)),
```

**Source Analysis:** function parameter (alignment unknown): socket

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 172. `uws_sys/App.zig:371`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-372-                @as(*uws_app_t, @ptrCast(app)),
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 173. `uws_sys/App.zig:386`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-387-            return c.uws_num_subscribers(ssl_flag, @as(*uws_app_t, @ptrCast(app)), topic.ptr, topic.len);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 174. `uws_sys/App.zig:391`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-392-            return c.uws_publish(ssl_flag, @as(*uws_app_t, @ptrCast(app)), topic.ptr, topic.len, message.ptr, message.len, opcode, compress);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 175. `uws_sys/App.zig:398`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-399-            return c.uws_remove_server_name(ssl_flag, @as(*uws_app_t, @ptrCast(app)), hostname_pattern);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 176. `uws_sys/App.zig:402`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-403-            return c.uws_add_server_name(ssl_flag, @as(*uws_app_t, @ptrCast(app)), hostname_pattern);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 177. `uws_sys/App.zig:406`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-407-            if (c.uws_add_server_name_with_options(ssl_flag, @as(*uws_app_t, @ptrCast(app)), hostname_pattern, opts) != 0) {
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 178. `uws_sys/App.zig:412`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-413-            return c.uws_missing_server_name(ssl_flag, @as(*uws_app_t, @ptrCast(app)), handler, user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 179. `uws_sys/App.zig:416`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-417-            return c.uws_filter(ssl_flag, @as(*uws_app_t, @ptrCast(app)), handler, user_data);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 180. `uws_sys/App.zig:422`

**Code:**
```zig
zust-port/src/uws_sys/App.zig-423-            uws_ws(ssl_flag, @as(*uws_app_t, @ptrCast(app)), ctx, pattern.ptr, pattern.len, id, &behavior);
```

**Source Analysis:** function parameter (alignment unknown): app

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 181. `uws_sys/Response.zig:137`

**Code:**
```zig
zust-port/src/uws_sys/Response.zig-138-                return .fromNative(@ptrCast(c.uws_res_get_native_handle(ssl_flag, res.downcast())));
```

**Source Analysis:** field access on unknown/param: c.uws_res_get_native_handle(ssl_flag, res.downcast())

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 182. `uws_sys/ListenSocket.zig:13`

**Code:**
```zig
zust-port/src/uws_sys/ListenSocket.zig-14-        return @ptrCast(this);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 183. `jsc/DOMFormData.zig:39`

**Code:**
```zig
zust-port/src/jsc/DOMFormData.zig-40-                cb(@as(Ctx, @ptrCast(c)), str.*);
```

**Source Analysis:** function parameter (alignment unknown): c

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 184. `uws_sys/us_socket_t.zig:130`

**Code:**
```zig
zust-port/src/uws_sys/us_socket_t.zig-131-        return @ptrCast(c.us_socket_get_native_handle(this));
```

**Source Analysis:** field access on unknown/param: c.us_socket_get_native_handle(this)

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 185. `jsc/SavedSourceMap.zig:93`

**Code:**
```zig
zust-port/src/jsc/SavedSourceMap.zig-94-    const source_provider: *SourceProviderMap = @ptrCast(opaque_source_provider);
```

**Source Analysis:** function parameter (alignment unknown): opaque_source_provider

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 186. `jsc/SavedSourceMap.zig:220`

**Code:**
```zig
zust-port/src/jsc/SavedSourceMap.zig-221-                .data = @as([*]u8, @ptrCast(Value.from(mapping.value_ptr.*).as(InternalSourceMap))),
```

**Source Analysis:** function return (alignment unknown): Value.from(mapping.value_ptr.*).as(InternalSourceMap)

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 187. `napi/napi.zig:399`

**Code:**
```zig
zust-port/src/napi/napi.zig-400-                break :brk bun.sliceTo(@as([*:0]const u8, @ptrCast(ptr)), 0);
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 188. `napi/napi.zig:442`

**Code:**
```zig
zust-port/src/napi/napi.zig-443-                break :brk bun.sliceTo(@as([*:0]const u8, @ptrCast(ptr)), 0);
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 189. `napi/napi.zig:476`

**Code:**
```zig
zust-port/src/napi/napi.zig-477-                break :brk bun.sliceTo(@as([*:0]const u16, @ptrCast(ptr)), 0);
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 190. `napi/napi.zig:700`

**Code:**
```zig
zust-port/src/napi/napi.zig-701-            @as([*]const jsc.JSValue, @ptrCast(args.?))[0..arg_count]
```

**Source Analysis:** field access on unknown/param: args.?

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 191. `napi/napi.zig:1364`

**Code:**
```zig
zust-port/src/napi/napi.zig-1365-            napi_internal_cleanup_env_cpp(@ptrCast(data));
```

**Source Analysis:** function parameter (alignment unknown): data

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 192. `jsc/ZigString.zig:459`

**Code:**
```zig
zust-port/src/jsc/ZigString.zig-460-        return @as([*]align(1) const u16, @ptrCast(untagged(this._unsafe_ptr_do_not_use)))[0..this.len];
```

**Source Analysis:** function return (alignment unknown): untagged(this._unsafe_ptr_do_not_use)

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 193. `bake/production.zig:321`

**Code:**
```zig
zust-port/src/bake/production.zig-322-            .plugins = @ptrCast(options.bundler_options.plugin),
```

**Source Analysis:** field access on unknown/param: options.bundler_options.plugin

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 194. `runtime/dns_jsc/dns.zig:1638`

**Code:**
```zig
zust-port/src/runtime/dns_jsc/dns.zig-1639-            afterResult(req, @ptrCast(addrinfo), err);
```

**Source Analysis:** function parameter (alignment unknown): addrinfo

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 195. `runtime/dns_jsc/dns.zig:2622`

**Code:**
```zig
zust-port/src/runtime/dns_jsc/dns.zig-2623-                if (uv.uv_poll_init_socket(bun.uws.Loop.get().uv_loop, &poll.poll, @ptrCast(fd)) < 0) {
```

**Source Analysis:** function parameter (alignment unknown): fd

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 196. `bundler/bundle_v2.zig:2606`

**Code:**
```zig
zust-port/src/bundler/bundle_v2.zig-2607-        this.linker.computeDataForSourceMap(@as([]Index.Int, @ptrCast(js_reachable_files)));
```

**Source Analysis:** function parameter (alignment unknown): js_reachable_files

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 197. `bundler/bundle_v2.zig:2642`

**Code:**
```zig
zust-port/src/bundler/bundle_v2.zig-2643-                    .files_in_chunk_order = @ptrCast(js_reachable_files),
```

**Source Analysis:** function parameter (alignment unknown): js_reachable_files

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 198. `runtime/api/cron.zig:1212`

**Code:**
```zig
zust-port/src/runtime/api/cron.zig-1213-    var spawned = (bun.spawn.spawnProcess(&spawn_options, @ptrCast(argv), envp) catch |e| {
```

**Source Analysis:** function parameter (alignment unknown): argv

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 199. `bundler/OutputFile.zig:139`

**Code:**
```zig
zust-port/src/bundler/OutputFile.zig-140-                        ctx.allocator.free(@as([*]u8, @ptrCast(buffer))[0..len]);
```

**Source Analysis:** function parameter (alignment unknown): buffer

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 200. `bundler/LinkerGraph.zig:355`

**Code:**
```zig
zust-port/src/bundler/LinkerGraph.zig-356-        this.stable_source_indices = @as([]const u32, @ptrCast(stable_source_indices));
```

**Source Analysis:** function parameter (alignment unknown): stable_source_indices

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 201. `io/source.zig:151`

**Code:**
```zig
zust-port/src/io/source.zig-152-            .pipe => @ptrCast(this.pipe),
```

**Source Analysis:** field access on unknown/param: this.pipe

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 202. `io/source.zig:153`

**Code:**
```zig
zust-port/src/io/source.zig-154-            .tty => @ptrCast(this.tty),
```

**Source Analysis:** field access on unknown/param: this.tty

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 203. `io/source.zig:161`

**Code:**
```zig
zust-port/src/io/source.zig-162-            .tty => @ptrCast(this.tty),
```

**Source Analysis:** field access on unknown/param: this.tty

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 204. `io/PipeWriter.zig:201`

**Code:**
```zig
zust-port/src/io/PipeWriter.zig-202-            return Async.FilePoll.init(@as(*Parent, @ptrCast(this.parent)).eventLoop(), fd, .{}, PosixWriter, this);
```

**Source Analysis:** field access on unknown/param: this.parent

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 205. `io/PipeWriter.zig:365`

**Code:**
```zig
zust-port/src/io/PipeWriter.zig-366-            const loop = @as(*Parent, @ptrCast(this.parent)).eventLoop().loop();
```

**Source Analysis:** field access on unknown/param: this.parent

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 206. `io/PipeWriter.zig:373`

**Code:**
```zig
zust-port/src/io/PipeWriter.zig-374-                    this.enableKeepingProcessAlive(@as(*Parent, @ptrCast(this.parent)).eventLoop());
```

**Source Analysis:** field access on unknown/param: this.parent

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 207. `io/PipeWriter.zig:493`

**Code:**
```zig
zust-port/src/io/PipeWriter.zig-494-                cb(@ptrCast(this.parent));
```

**Source Analysis:** field access on unknown/param: this.parent

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 208. `runtime/api/Archive.zig:195`

**Code:**
```zig
zust-port/src/runtime/api/Archive.zig-196-        @ptrCast(archive),
```

**Source Analysis:** function parameter (alignment unknown): archive

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 209. `runtime/image/backend_wic.zig:56`

**Code:**
```zig
zust-port/src/runtime/image/backend_wic.zig-57-    if (f.vt.CreateDecoderFromStream(f, @ptrCast(stream), null, 0, &dec) < 0 or dec == null)
```

**Source Analysis:** function parameter (alignment unknown): stream

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 210. `sourcemap/ParsedSourceMap.zig:44`

**Code:**
```zig
zust-port/src/sourcemap/ParsedSourceMap.zig-45-            .zig => @ptrCast(this.zig),
```

**Source Analysis:** field access on unknown/param: this.zig

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 211. `sourcemap/ParsedSourceMap.zig:46`

**Code:**
```zig
zust-port/src/sourcemap/ParsedSourceMap.zig-47-            .bake => @ptrCast(this.bake),
```

**Source Analysis:** field access on unknown/param: this.bake

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 212. `sourcemap/ParsedSourceMap.zig:48`

**Code:**
```zig
zust-port/src/sourcemap/ParsedSourceMap.zig-49-            .dev_server => @ptrCast(this.dev_server),
```

**Source Analysis:** field access on unknown/param: this.dev_server

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 213. `css/values/ident.zig:253`

**Code:**
```zig
zust-port/src/css/values/ident.zig-254-            const slice: [*]const u64 = @ptrCast(this);
```

**Source Analysis:** function parameter (alignment unknown): this

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 214. `boringssl_sys/boringssl.zig:716`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-717-    return @as(?*struct_stack_st_void, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 215. `boringssl_sys/boringssl.zig:832`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-833-    return @as(?*struct_stack_st_OPENSSL_STRING, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 216. `boringssl_sys/boringssl.zig:973`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-974-    return @as(?*struct_stack_st_BIO, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 217. `boringssl_sys/boringssl.zig:1763`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-1764-    return @as(?*struct_stack_st_ASN1_INTEGER, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 218. `boringssl_sys/boringssl.zig:1933`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-1934-    var a_ptr: ?*const ASN1_OBJECT = @as(?*const ASN1_OBJECT, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 219. `boringssl_sys/boringssl.zig:1935`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-1936-    var b_ptr: ?*const ASN1_OBJECT = @as(?*const ASN1_OBJECT, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 220. `boringssl_sys/boringssl.zig:1944`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-1945-    return @as(?*struct_stack_st_ASN1_OBJECT, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 221. `boringssl_sys/boringssl.zig:2066`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2067-    return @as(?*struct_stack_st_ASN1_TYPE, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 222. `boringssl_sys/boringssl.zig:2529`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2530-    var a_ptr: ?*const CRYPTO_BUFFER = @as(?*const CRYPTO_BUFFER, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 223. `boringssl_sys/boringssl.zig:2531`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2532-    var b_ptr: ?*const CRYPTO_BUFFER = @as(?*const CRYPTO_BUFFER, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 224. `boringssl_sys/boringssl.zig:2540`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2541-    return @as(?*struct_stack_st_CRYPTO_BUFFER, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 225. `boringssl_sys/boringssl.zig:2752`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2753-    var a_ptr: ?*const X509 = @as(?*const X509, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 226. `boringssl_sys/boringssl.zig:2754`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2755-    var b_ptr: ?*const X509 = @as(?*const X509, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 227. `boringssl_sys/boringssl.zig:2763`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2764-    return @as(?*struct_stack_st_X509, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 228. `boringssl_sys/boringssl.zig:2923`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2924-    var a_ptr: ?*const X509_CRL = @as(?*const X509_CRL, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 229. `boringssl_sys/boringssl.zig:2925`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-2926-    var b_ptr: ?*const X509_CRL = @as(?*const X509_CRL, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 230. `boringssl_sys/boringssl.zig:3017`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3018-    @as(stack_ACCESS_DESCRIPTION_free_func, @ptrCast(free_func)).?(@as(?*AUTHORITY_INFO_ACCESS, @ptrCast(ptr)));
```

**Source Analysis:** function parameter (alignment unknown): free_func

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 231. `boringssl_sys/boringssl.zig:3042`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3043-    return @as(?*anyopaque, @ptrCast(@as(stack_X509_CRL_copy_func, @ptrCast(copy_func)).?(@as(?*X509_CRL, @ptrCast(ptr)))));
```

**Source Analysis:** optional unwrapping (alignment unknown): @as(stack_X509_CRL_copy_func, @ptrCast(copy_func)).?(@as(?*X509_CRL, @ptrCast(ptr)))

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 232. `boringssl_sys/boringssl.zig:3047`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3048-    return @as(?*struct_stack_st_X509_CRL, @ptrCast(sk_new(@as(stack_cmp_func, @ptrCast(comp)))));
```

**Source Analysis:** function return (alignment unknown): sk_new(@as(stack_cmp_func, @ptrCast(comp)))

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 233. `boringssl_sys/boringssl.zig:3051`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3052-    return @as(?*struct_stack_st_X509_CRL, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 234. `boringssl_sys/boringssl.zig:3209`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3210-    var a_ptr: ?*const X509_NAME_ENTRY = @as(?*const X509_NAME_ENTRY, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 235. `boringssl_sys/boringssl.zig:3211`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3212-    var b_ptr: ?*const X509_NAME_ENTRY = @as(?*const X509_NAME_ENTRY, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 236. `boringssl_sys/boringssl.zig:3220`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3221-    return @as(?*struct_stack_st_X509_NAME_ENTRY, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 237. `boringssl_sys/boringssl.zig:3327`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3328-    var a_ptr: ?*const X509_NAME = @as(?*const X509_NAME, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 238. `boringssl_sys/boringssl.zig:3329`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3330-    var b_ptr: ?*const X509_NAME = @as(?*const X509_NAME, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 239. `boringssl_sys/boringssl.zig:3338`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3339-    return @as(?*struct_stack_st_X509_NAME, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 240. `boringssl_sys/boringssl.zig:3489`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3490-    var a_ptr: ?*const X509_EXTENSION = @as(?*const X509_EXTENSION, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 241. `boringssl_sys/boringssl.zig:3491`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3492-    var b_ptr: ?*const X509_EXTENSION = @as(?*const X509_EXTENSION, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 242. `boringssl_sys/boringssl.zig:3500`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3501-    return @as(?*struct_stack_st_X509_EXTENSION, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 243. `boringssl_sys/boringssl.zig:3627`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3628-    return @as(?*struct_stack_st_X509_ALGOR, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 244. `boringssl_sys/boringssl.zig:3813`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3814-    var a_ptr: ?*const X509_ATTRIBUTE = @as(?*const X509_ATTRIBUTE, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 245. `boringssl_sys/boringssl.zig:3815`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3816-    var b_ptr: ?*const X509_ATTRIBUTE = @as(?*const X509_ATTRIBUTE, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 246. `boringssl_sys/boringssl.zig:3824`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3825-    return @as(?*struct_stack_st_X509_ATTRIBUTE, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 247. `boringssl_sys/boringssl.zig:3942`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-3943-    return @as(?*struct_stack_st_X509_TRUST, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 248. `boringssl_sys/boringssl.zig:4048`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4049-    var a_ptr: ?*const X509_REVOKED = @as(?*const X509_REVOKED, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 249. `boringssl_sys/boringssl.zig:4050`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4051-    var b_ptr: ?*const X509_REVOKED = @as(?*const X509_REVOKED, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 250. `boringssl_sys/boringssl.zig:4059`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4060-    return @as(?*struct_stack_st_X509_REVOKED, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 251. `boringssl_sys/boringssl.zig:4175`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4176-    return @as(?*struct_stack_st_X509_INFO, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 252. `boringssl_sys/boringssl.zig:4465`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4466-    var a_ptr: ?*const X509_LOOKUP = @as(?*const X509_LOOKUP, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 253. `boringssl_sys/boringssl.zig:4467`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4468-    var b_ptr: ?*const X509_LOOKUP = @as(?*const X509_LOOKUP, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 254. `boringssl_sys/boringssl.zig:4476`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4477-    return @as(?*struct_stack_st_X509_LOOKUP, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 255. `boringssl_sys/boringssl.zig:4583`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4584-    var a_ptr: ?*const X509_OBJECT = @as(?*const X509_OBJECT, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 256. `boringssl_sys/boringssl.zig:4585`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4586-    var b_ptr: ?*const X509_OBJECT = @as(?*const X509_OBJECT, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 257. `boringssl_sys/boringssl.zig:4594`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4595-    return @as(?*struct_stack_st_X509_OBJECT, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 258. `boringssl_sys/boringssl.zig:4701`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4702-    var a_ptr: ?*const X509_VERIFY_PARAM = @as(?*const X509_VERIFY_PARAM, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 259. `boringssl_sys/boringssl.zig:4703`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4704-    var b_ptr: ?*const X509_VERIFY_PARAM = @as(?*const X509_VERIFY_PARAM, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 260. `boringssl_sys/boringssl.zig:4712`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-4713-    return @as(?*struct_stack_st_X509_VERIFY_PARAM, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 261. `boringssl_sys/boringssl.zig:5258`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-5259-    var a_ptr: ?*const SSL_CIPHER = @as(?*const SSL_CIPHER, @ptrCast(a.*));
```

**Source Analysis:** field access on unknown/param: a.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 262. `boringssl_sys/boringssl.zig:5260`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-5261-    var b_ptr: ?*const SSL_CIPHER = @as(?*const SSL_CIPHER, @ptrCast(b.*));
```

**Source Analysis:** field access on unknown/param: b.*

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 263. `boringssl_sys/boringssl.zig:5269`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-5270-    return @as(?*struct_stack_st_SSL_CIPHER, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 264. `boringssl_sys/boringssl.zig:5578`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-5579-    return @as(?*struct_stack_st_SRTP_PROTECTION_PROFILE, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 265. `boringssl_sys/boringssl.zig:5918`

**Code:**
```zig
zust-port/src/boringssl_sys/boringssl.zig-5919-    return @as(?*struct_stack_st_SSL_COMP, @ptrCast(sk_new_null()));
```

**Source Analysis:** function return (alignment unknown): sk_new_null()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 266. `bun_alloc/heap_breakdown.zig:57`

**Code:**
```zig
zust-port/src/bun_alloc/heap_breakdown.zig-58-        return @as(?[*]u8, @ptrCast(ptr));
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 267. `bun_alloc/heap_breakdown.zig:66`

**Code:**
```zig
zust-port/src/bun_alloc/heap_breakdown.zig-67-        return alignedAlloc(@ptrCast(zone), len, alignment);
```

**Source Analysis:** function parameter (alignment unknown): zone

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 268. `bun_alloc/heap_breakdown.zig:86`

**Code:**
```zig
zust-port/src/bun_alloc/heap_breakdown.zig-87-        malloc_zone_free(@ptrCast(zone), @ptrCast(buf.ptr));
```

**Source Analysis:** function parameter (alignment unknown): zone

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 269. `bun_alloc/heap_breakdown.zig:121`

**Code:**
```zig
zust-port/src/bun_alloc/heap_breakdown.zig-122-        malloc_zone_free(zone, @ptrCast(ptr));
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 270. `bun_alloc/MimallocArena.zig:85`

**Code:**
```zig
zust-port/src/bun_alloc/MimallocArena.zig-86-            @as([*]u8, @ptrCast(p))
```

**Source Analysis:** function parameter (alignment unknown): p

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 271. `bun_alloc/MimallocArena.zig:248`

**Code:**
```zig
zust-port/src/bun_alloc/MimallocArena.zig-249-    return @ptrCast(value);
```

**Source Analysis:** function parameter (alignment unknown): value

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 272. `bun_alloc/MimallocArena.zig:258`

**Code:**
```zig
zust-port/src/bun_alloc/MimallocArena.zig-259-    return if (ptr) |p| @ptrCast(p) else null;
```

**Source Analysis:** function parameter (alignment unknown): p

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 273. `bun_alloc/basic.zig:45`

**Code:**
```zig
zust-port/src/bun_alloc/basic.zig-46-        return @as(?[*]u8, @ptrCast(ptr));
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 274. `bun_alloc/basic.zig:101`

**Code:**
```zig
zust-port/src/bun_alloc/basic.zig-102-        return @as(?[*]u8, @ptrCast(ptr));
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 275. `lolhtml_sys/lol_html.zig:619`

**Code:**
```zig
zust-port/src/lolhtml_sys/lol_html.zig-620-        lol_html_str_free(.{ .ptr = @as([*]const u8, @ptrCast(ptr)), .len = len });
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 276. `bun_alloc/allocation_scope.zig:276`

**Code:**
```zig
zust-port/src/bun_alloc/allocation_scope.zig-277-        const allocation = locked.history.allocations.getPtr(@ptrCast(ptr)) orelse
```

**Source Analysis:** function parameter (alignment unknown): ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 277. `sql_jsc/mysql/MySQLConnection.zig:255`

**Code:**
```zig
zust-port/src/sql_jsc/mysql/MySQLConnection.zig-256-                    const ssl_ptr: *BoringSSL.c.SSL = @ptrCast(this._socket.getNativeHandle());
```

**Source Analysis:** field access on unknown/param: this._socket.getNativeHandle()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 278. `install/windows-shim/bun_shim_impl.zig:563`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-564-    const flags: Flags = @as(*align(1) Flags, @ptrCast(read_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): read_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 279. `install/windows-shim/bun_shim_impl.zig:567`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-568-        const flags_u16: u16 = @as(*align(1) u16, @ptrCast(read_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): read_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 280. `install/windows-shim/bun_shim_impl.zig:637`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-638-            const shebang_metadata: ShebangMetadataPacked = @as(*align(1) ShebangMetadataPacked, @ptrCast(read_ptr)).*;
```

**Source Analysis:** function parameter (alignment unknown): read_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 281. `install/windows-shim/bun_shim_impl.zig:690`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-691-            @memcpy(buf2_u8, @as([*]u8, @ptrCast(read_ptr))[0..shebang_arg_len_u8]);
```

**Source Analysis:** function parameter (alignment unknown): read_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 282. `install/windows-shim/bun_shim_impl.zig:742`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-743-                @memcpy(@as([*]u8, @ptrCast(write_ptr)), user_arguments_u8);
```

**Source Analysis:** function parameter (alignment unknown): write_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 283. `sql_jsc/postgres/PostgresSQLConnection.zig:458`

**Code:**
```zig
zust-port/src/sql_jsc/postgres/PostgresSQLConnection.zig-459-                    const ssl_ptr: *BoringSSL.c.SSL = @ptrCast(this.socket.getNativeHandle());
```

**Source Analysis:** field access on unknown/param: this.socket.getNativeHandle()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 284. `watcher/INotifyWatcher.zig:57`

**Code:**
```zig
zust-port/src/watcher/INotifyWatcher.zig-58-        return bun.sliceTo(@as([*:0]u8, @ptrCast(name_first_char_ptr)), 0);
```

**Source Analysis:** function parameter (alignment unknown): name_first_char_ptr

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 285. `http_jsc/websocket_client.zig:208`

**Code:**
```zig
zust-port/src/http_jsc/websocket_client.zig-209-                    const ssl_ptr = @as(*BoringSSL.c.SSL, @ptrCast(socket.getNativeHandle()));
```

**Source Analysis:** field access on unknown/param: socket.getNativeHandle()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 286. `http_jsc/websocket_client.zig:1362`

**Code:**
```zig
zust-port/src/http_jsc/websocket_client.zig-1363-                @ptrCast(ws),
```

**Source Analysis:** function parameter (alignment unknown): ws

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 287. `http_jsc/websocket_client.zig:1424`

**Code:**
```zig
zust-port/src/http_jsc/websocket_client.zig-1425-            return @as(*anyopaque, @ptrCast(ws));
```

**Source Analysis:** function parameter (alignment unknown): ws

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 288. `http_jsc/websocket_client/WebSocketUpgradeClient.zig:497`

**Code:**
```zig
zust-port/src/http_jsc/websocket_client/WebSocketUpgradeClient.zig-498-                    const ssl_ptr = @as(*BoringSSL.c.SSL, @ptrCast(socket.getNativeHandle()));
```

**Source Analysis:** field access on unknown/param: socket.getNativeHandle()

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 289. `install/PackageManager/security_scanner.zig:809`

**Code:**
```zig
zust-port/src/install/PackageManager/security_scanner.zig-810-        var spawned = try (try bun.spawn.spawnProcess(&spawn_options, @ptrCast(argv), @ptrCast(std.c.environ))).unwrap();
```

**Source Analysis:** function parameter (alignment unknown): argv

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 290. `install/PackageManager/security_scanner.zig:869`

**Code:**
```zig
zust-port/src/install/PackageManager/security_scanner.zig-870-        var spawned = try (try bun.spawn.spawnProcess(&spawn_options, @ptrCast(argv), @ptrCast(std.c.environ))).unwrap();
```

**Source Analysis:** function parameter (alignment unknown): argv

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 291. `install/TarballStream.zig:390`

**Code:**
```zig
zust-port/src/install/TarballStream.zig-391-    if (lib.archive_read_append_filter(@ptrCast(archive), 1) != 0) return error.Fail;
```

**Source Analysis:** function parameter (alignment unknown): archive

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 292. `install/TarballStream.zig:392`

**Code:**
```zig
zust-port/src/install/TarballStream.zig-393-    if (lib.archive_read_set_format(@ptrCast(archive), 0x30000) != 0) return error.Fail;
```

**Source Analysis:** function parameter (alignment unknown): archive

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

### 293. `install/TarballStream.zig:397`

**Code:**
```zig
zust-port/src/install/TarballStream.zig-398-        @ptrCast(archive),
```

**Source Analysis:** function parameter (alignment unknown): archive

**Auto-fixable:** False

**Action:** Manual review required - add @alignCast only if source alignment is guaranteed

---

## Category: REVIEW (70 items)

### 1. `bun.zig:1763`

**Code:**
```zig
zust-port/src/bun.zig-1764-        switch (spawn.spawnZ(exec_path, actions, attrs, @as([*:null]?[*:0]const u8, @ptrCast(newargv)), @as([*:null]?[*:0]const u8, @ptrCast(envp)))) {
```

**Source Analysis:** needs manual review: newargv

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 2. `bun.zig:2471`

**Code:**
```zig
zust-port/src/bun.zig-2472-    if (!Environment.isWindows) return @ptrCast(literal);
```

**Source Analysis:** needs manual review: literal

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 3. `bun.zig:2487`

**Code:**
```zig
zust-port/src/bun.zig-2488-    if (!Environment.isWindows) return @ptrCast(literal);
```

**Source Analysis:** needs manual review: literal

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 4. `bun.zig:2531`

**Code:**
```zig
zust-port/src/bun.zig-2532-                    @ptrCast(component.path))
```

**Source Analysis:** needs manual review: component.path

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 5. `event_loop/AnyEventLoop.zig:68`

**Code:**
```zig
zust-port/src/event_loop/AnyEventLoop.zig-69-                this.mini.tick(context, @ptrCast(isDone));
```

**Source Analysis:** needs manual review: isDone

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 6. `http/H2FrameParser.zig:122`

**Code:**
```zig
zust-port/src/http/H2FrameParser.zig-123-        @memcpy(@as(*[StreamPriority.byteSize]u8, @ptrCast(dst)), src);
```

**Source Analysis:** needs manual review: dst

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 7. `http/H2FrameParser.zig:138`

**Code:**
```zig
zust-port/src/http/H2FrameParser.zig-139-        @memcpy(@as(*[FrameHeader.byteSize]u8, @ptrCast(dst))[offset .. src.len + offset], src);
```

**Source Analysis:** needs manual review: dst

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 8. `http/H2FrameParser.zig:152`

**Code:**
```zig
zust-port/src/http/H2FrameParser.zig-153-        @memcpy(@as(*[SettingsPayloadUnit.byteSize]u8, @ptrCast(dst))[offset .. src.len + offset], src);
```

**Source Analysis:** needs manual review: dst

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 9. `http/HTTPContext.zig:256`

**Code:**
```zig
zust-port/src/http/HTTPContext.zig-257-                .ca = if (init_opts.ca.len > 0) @ptrCast(init_opts.ca) else null,
```

**Source Analysis:** needs manual review: init_opts.ca

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 10. `cli/Arguments.zig:626`

**Code:**
```zig
zust-port/src/cli/Arguments.zig-627-            ctx.test_options.test_filter_regex = @ptrCast(regex);
```

**Source Analysis:** needs manual review: regex

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 11. `shell/Builtin.zig:291`

**Code:**
```zig
zust-port/src/shell/Builtin.zig-292-    return @as([*][*:0]const u8, @ptrCast(args_ptr))[0..args_len];
```

**Source Analysis:** needs manual review: args_ptr

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 12. `sys/windows/env.zig:52`

**Code:**
```zig
zust-port/src/sys/windows/env.zig-53-    const envp_nonnull_slice: [][*:0]u8 = @ptrCast(envp_slice[0 .. envp_slice.len - 1]);
```

**Source Analysis:** needs manual review: envp_slice[0 .. envp_slice.len - 1]

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 13. `runtime/node/node_fs.zig:4852`

**Code:**
```zig
zust-port/src/runtime/node/node_fs.zig-4853-                    break :brk @ptrCast(utf8_name);
```

**Source Analysis:** needs manual review: utf8_name

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 14. `sys/File.zig:441`

**Code:**
```zig
zust-port/src/sys/File.zig-442-        return .{ .result = .{ this, @ptrCast(@constCast("")) } };
```

**Source Analysis:** needs manual review: @constCast("")

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 15. `sys/tmp.zig:60`

**Code:**
```zig
zust-port/src/sys/tmp.zig-61-                const basename: [:0]const u8 = @ptrCast(std.fs.path.basename(destname));
```

**Source Analysis:** needs manual review: std.fs.path.basename(destname)

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 16. `collections/hive_array.zig:33`

**Code:**
```zig
zust-port/src/collections/hive_array.zig-34-            bun.asan.unpoison(@ptrCast(ret), @sizeOf(T));
```

**Source Analysis:** needs manual review: ret

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 17. `collections/hive_array.zig:41`

**Code:**
```zig
zust-port/src/collections/hive_array.zig-42-            bun.asan.assertUnpoisoned(@ptrCast(ret));
```

**Source Analysis:** needs manual review: ret

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 18. `collections/hive_array.zig:50`

**Code:**
```zig
zust-port/src/collections/hive_array.zig-51-            const end = @as([*]const T, @ptrCast(start)) + capacity;
```

**Source Analysis:** needs manual review: start

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 19. `collections/hive_array.zig:67`

**Code:**
```zig
zust-port/src/collections/hive_array.zig-68-            const end = @as([*]const T, @ptrCast(start)) + capacity;
```

**Source Analysis:** needs manual review: start

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 20. `standalone_graph/StandaloneModuleGraph.zig:266`

**Code:**
```zig
zust-port/src/standalone_graph/StandaloneModuleGraph.zig-267-                    const file_names: [][]const u8 = @ptrCast(slices[0..source_files.len]);
```

**Source Analysis:** needs manual review: slices[0..source_files.len]

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 21. `libarchive_sys/bindings.zig:683`

**Code:**
```zig
zust-port/src/libarchive_sys/bindings.zig-684-        const ptr: [*]const u8 = @ptrCast(buff);
```

**Source Analysis:** needs manual review: buff

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 22. `runtime/server/NodeHTTPResponse.zig:311`

**Code:**
```zig
zust-port/src/runtime/server/NodeHTTPResponse.zig-312-            true => uws.AnyResponse{ .SSL = @ptrCast(response_ptr) },
```

**Source Analysis:** needs manual review: response_ptr

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 23. `runtime/server/NodeHTTPResponse.zig:313`

**Code:**
```zig
zust-port/src/runtime/server/NodeHTTPResponse.zig-314-            false => uws.AnyResponse{ .TCP = @ptrCast(response_ptr) },
```

**Source Analysis:** needs manual review: response_ptr

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 24. `crash_handler/crash_handler.zig:172`

**Code:**
```zig
zust-port/src/crash_handler/crash_handler.zig-173-    const count = backtrace(@ptrCast(addrs), @intCast(addrs.len));
```

**Source Analysis:** needs manual review: addrs

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 25. `runtime/server/server.zig:1076`

**Code:**
```zig
zust-port/src/runtime/server/server.zig-1077-                    try cookies.write(globalThis, uws.ResponseKind.from(ssl_enabled, false), @ptrCast(resp));
```

**Source Analysis:** needs manual review: resp

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 26. `runtime/webview/HostProcess.zig:90`

**Code:**
```zig
zust-port/src/runtime/webview/HostProcess.zig-91-    env.appendSliceAssumeCapacity(@ptrCast(base));
```

**Source Analysis:** needs manual review: base

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 27. `jsc/RuntimeTranspilerCache.zig:296`

**Code:**
```zig
zust-port/src/jsc/RuntimeTranspilerCache.zig-297-            try tmpfile.finish(@ptrCast(std.fs.path.basename(destination_path.slice())));
```

**Source Analysis:** needs manual review: std.fs.path.basename(destination_path.slice())

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 28. `string/SmolStr.zig:69`

**Code:**
```zig
zust-port/src/string/SmolStr.zig-70-            return @as([*]u8, @ptrCast(@as(*u128, @ptrCast(this))));
```

**Source Analysis:** needs manual review: @as(*u128, @ptrCast(this))

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 29. `uws_sys/WebSocket.zig:250`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-251-                const ws = @unionInit(AnyWebSocket, active_field_name, @as(*WebSocket, @ptrCast(raw_ws)));
```

**Source Analysis:** needs manual review: raw_ws

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 30. `uws_sys/WebSocket.zig:260`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-261-                const ws = @unionInit(AnyWebSocket, active_field_name, @as(*WebSocket, @ptrCast(raw_ws)));
```

**Source Analysis:** needs manual review: raw_ws

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 31. `uws_sys/WebSocket.zig:272`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-273-                const ws = @unionInit(AnyWebSocket, active_field_name, @as(*WebSocket, @ptrCast(raw_ws)));
```

**Source Analysis:** needs manual review: raw_ws

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 32. `uws_sys/WebSocket.zig:282`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-283-                const ws = @unionInit(AnyWebSocket, active_field_name, @as(*WebSocket, @ptrCast(raw_ws)));
```

**Source Analysis:** needs manual review: raw_ws

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 33. `uws_sys/WebSocket.zig:293`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-294-                const ws = @unionInit(AnyWebSocket, active_field_name, @as(*WebSocket, @ptrCast(raw_ws)));
```

**Source Analysis:** needs manual review: raw_ws

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 34. `uws_sys/WebSocket.zig:304`

**Code:**
```zig
zust-port/src/uws_sys/WebSocket.zig-305-                const ws = @unionInit(AnyWebSocket, active_field_name, @as(*WebSocket, @ptrCast(raw_ws)));
```

**Source Analysis:** needs manual review: raw_ws

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 35. `runtime/webcore/encoding.zig:324`

**Code:**
```zig
zust-port/src/runtime/webcore/encoding.zig-325-                const output = @as([*]align(1) u16, @ptrCast(to_ptr))[0 .. to_len / 2];
```

**Source Analysis:** needs manual review: to_ptr

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 36. `uws_sys/SocketGroup.zig:62`

**Code:**
```zig
zust-port/src/uws_sys/SocketGroup.zig-63-            .pointer => |p| if (p.size == .one) @ptrCast(@constCast(owner_ptr)) else @compileError("SocketGroup.init owner must be a single-item pointer"),
```

**Source Analysis:** needs manual review: @constCast(owner_ptr)

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 37. `uws_sys/SocketGroup.zig:64`

**Code:**
```zig
zust-port/src/uws_sys/SocketGroup.zig-65-            .optional => if (owner_ptr) |o| @ptrCast(@constCast(o)) else null,
```

**Source Analysis:** needs manual review: @constCast(o)

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 38. `uws_sys/Response.zig:285`

**Code:**
```zig
zust-port/src/uws_sys/Response.zig-286-            c.uws_res_cork(ssl_flag, res.downcast(), @ptrCast(@constCast(&args_tuple)), Wrapper.handle);
```

**Source Analysis:** needs manual review: @constCast(&args_tuple)

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 39. `uws_sys/ListenSocket.zig:39`

**Code:**
```zig
zust-port/src/uws_sys/ListenSocket.zig-40-        const erased: ?*anyopaque = if (U == @TypeOf(null)) null else @ptrCast(@constCast(user));
```

**Source Analysis:** needs manual review: @constCast(user)

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 40. `jsc/SavedSourceMap.zig:141`

**Code:**
```zig
zust-port/src/jsc/SavedSourceMap.zig-142-                (InternalSourceMap{ .data = @as([*]u8, @ptrCast(ism)) }).deinit();
```

**Source Analysis:** needs manual review: ism

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 41. `jsc/SavedSourceMap.zig:188`

**Code:**
```zig
zust-port/src/jsc/SavedSourceMap.zig-189-            (InternalSourceMap{ .data = @as([*]u8, @ptrCast(ism)) }).deinit();
```

**Source Analysis:** needs manual review: ism

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 42. `jsc/ZigString.zig:550`

**Code:**
```zig
zust-port/src/jsc/ZigString.zig-551-        var out = ZigString{ ._unsafe_ptr_do_not_use = @ptrCast(items), .len = items.len };
```

**Source Analysis:** needs manual review: items

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 43. `jsc/ZigString.zig:571`

**Code:**
```zig
zust-port/src/jsc/ZigString.zig-572-        var str = init(@as([*]const u8, @ptrCast(slice_))[0..len]);
```

**Source Analysis:** needs manual review: slice_

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 44. `bake/DevServer.zig:781`

**Code:**
```zig
zust-port/src/bake/DevServer.zig-782-        @ptrCast(dev.vm.global),
```

**Source Analysis:** needs manual review: dev.vm.global

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 45. `bake/DevServer.zig:1926`

**Code:**
```zig
zust-port/src/bake/DevServer.zig-1927-            .plugins = @ptrCast(dev.bundler_options.plugin),
```

**Source Analysis:** needs manual review: dev.bundler_options.plugin

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 46. `bake/DevServer.zig:2607`

**Code:**
```zig
zust-port/src/bake/DevServer.zig-2608-                @ptrCast(dev.vm.global),
```

**Source Analysis:** needs manual review: dev.vm.global

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 47. `bake/DevServer.zig:2620`

**Code:**
```zig
zust-port/src/bake/DevServer.zig-2621-        } else c.BakeLoadServerHmrPatch(@ptrCast(dev.vm.global), bun.String.cloneLatin1(server_bundle)) catch |err| {
```

**Source Analysis:** needs manual review: dev.vm.global

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 48. `analytics/schema.zig:154`

**Code:**
```zig
zust-port/src/analytics/schema.zig-155-                                return @as(*align(1) T, @ptrCast(slice[0..sizeof])).*;
```

**Source Analysis:** needs manual review: slice[0..sizeof]

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 49. `bundler/LinkerContext.zig:373`

**Code:**
```zig
zust-port/src/bundler/LinkerContext.zig-374-            this.computeDataForSourceMap(@as([]Index.Int, @ptrCast(reachable)));
```

**Source Analysis:** needs manual review: reachable

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 50. `runtime/api/cron.zig:1203`

**Code:**
```zig
zust-port/src/runtime/api/cron.zig-1204-        @ptrCast(@constCast(std.c.environ))
```

**Source Analysis:** needs manual review: @constCast(std.c.environ)

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 51. `runtime/ffi/ffi.zig:336`

**Code:**
```zig
zust-port/src/runtime/ffi/ffi.zig-337-                @ptrCast(tcc_options)
```

**Source Analysis:** needs manual review: tcc_options

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 52. `runtime/ffi/ffi.zig:1591`

**Code:**
```zig
zust-port/src/runtime/ffi/ffi.zig-1592-            state.compileString(@ptrCast(source_code.items)) catch {
```

**Source Analysis:** needs manual review: source_code.items

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 53. `runtime/ffi/ffi.zig:1681`

**Code:**
```zig
zust-port/src/runtime/ffi/ffi.zig-1682-            state.compileString(@ptrCast(source_code.items)) catch {
```

**Source Analysis:** needs manual review: source_code.items

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 54. `runtime/api/bun/h2_frame_parser.zig:169`

**Code:**
```zig
zust-port/src/runtime/api/bun/h2_frame_parser.zig-170-        @memcpy(@as(*[StreamPriority.byteSize]u8, @ptrCast(dst)), src);
```

**Source Analysis:** needs manual review: dst

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 55. `runtime/api/bun/h2_frame_parser.zig:191`

**Code:**
```zig
zust-port/src/runtime/api/bun/h2_frame_parser.zig-192-        @memcpy(@as(*[FrameHeader.byteSize]u8, @ptrCast(dst))[offset .. src.len + offset], src);
```

**Source Analysis:** needs manual review: dst

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 56. `runtime/api/bun/h2_frame_parser.zig:205`

**Code:**
```zig
zust-port/src/runtime/api/bun/h2_frame_parser.zig-206-        @memcpy(@as(*[SettingsPayloadUnit.byteSize]u8, @ptrCast(dst))[offset .. src.len + offset], src);
```

**Source Analysis:** needs manual review: dst

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 57. `runtime/api/bun/process.zig:1815`

**Code:**
```zig
zust-port/src/runtime/api/bun/process.zig-1816-                stdio.data.stream = @ptrCast(my_pipe);
```

**Source Analysis:** needs manual review: my_pipe

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 58. `runtime/api/bun/process.zig:1868`

**Code:**
```zig
zust-port/src/runtime/api/bun/process.zig-1869-                stdio.data.stream = @ptrCast(my_pipe);
```

**Source Analysis:** needs manual review: my_pipe

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 59. `runtime/api/bun/process.zig:1874`

**Code:**
```zig
zust-port/src/runtime/api/bun/process.zig-1875-                stdio.data.stream = @ptrCast(my_pipe);
```

**Source Analysis:** needs manual review: my_pipe

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 60. `runtime/api/bun/process.zig:1944`

**Code:**
```zig
zust-port/src/runtime/api/bun/process.zig-1945-                result_stdio.* = .{ .buffer = @ptrCast(stdio.data.stream) };
```

**Source Analysis:** needs manual review: stdio.data.stream

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 61. `runtime/api/bun/process.zig:1956`

**Code:**
```zig
zust-port/src/runtime/api/bun/process.zig-1957-                result.extra_pipes.appendAssumeCapacity(.{ .buffer = @ptrCast(stdio_containers.items[3 + i].data.stream) });
```

**Source Analysis:** needs manual review: stdio_containers.items[3 + i].data.stream

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 62. `runtime/image/backend_wic.zig:186`

**Code:**
```zig
zust-port/src/runtime/image/backend_wic.zig-187-    const ptr: [*]const u8 = @ptrCast(GlobalLock((if (hg) |v| v else unreachable)) orelse return error.EncodeFailed);
```

**Source Analysis:** needs manual review: GlobalLock((if (hg) |v| v else unreachable)) orelse return error.EncodeFailed

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 63. `runtime/image/backend_wic.zig:521`

**Code:**
```zig
zust-port/src/runtime/image/backend_wic.zig-522-    const ptr: [*]const u8 = @ptrCast(GlobalLock(h) orelse return null);
```

**Source Analysis:** needs manual review: GlobalLock(h) orelse return null

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 64. `install/windows-shim/bun_shim_impl.zig:330`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-331-    const cmd_line_u8 = @as([*]u8, @ptrCast(CommandLine.Buffer))[0..cmd_line_b_len];
```

**Source Analysis:** needs manual review: CommandLine.Buffer

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 65. `install/windows-shim/bun_shim_impl.zig:621`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-622-            @as(*align(1) u16, @ptrCast(argument_start_ptr + user_arguments_u8.len)).* = 0;
```

**Source Analysis:** needs manual review: argument_start_ptr + user_arguments_u8.len

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 66. `install/windows-shim/bun_shim_impl.zig:694`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-695-            @as(*align(1) u16, @ptrCast(buf2_u8 + shebang_arg_len_u8)).* = '"';
```

**Source Analysis:** needs manual review: buf2_u8 + shebang_arg_len_u8

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 67. `install/windows-shim/bun_shim_impl.zig:751`

**Code:**
```zig
zust-port/src/install/windows-shim/bun_shim_impl.zig-752-            break :spawn_command_line @ptrCast(buf2_u16);
```

**Source Analysis:** needs manual review: buf2_u16

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 68. `install/lockfile/Tree.zig:341`

**Code:**
```zig
zust-port/src/install/lockfile/Tree.zig-342-                var new: [*]Tree = @ptrCast(list_ptr);
```

**Source Analysis:** needs manual review: list_ptr

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 69. `http_jsc/websocket_client.zig:1303`

**Code:**
```zig
zust-port/src/http_jsc/websocket_client.zig-1304-            const tcp = @as(*uws.us_socket_t, @ptrCast(input_socket));
```

**Source Analysis:** needs manual review: input_socket

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

### 70. `options_types/schema.zig:154`

**Code:**
```zig
zust-port/src/options_types/schema.zig-155-                                return @as(*align(1) T, @ptrCast(slice[0..sizeof])).*;
```

**Source Analysis:** needs manual review: slice[0..sizeof]

**Auto-fixable:** False

**Action:** Manual review required - determine if source has guaranteed alignment

---

## Category: UNKNOWN (4 items)

### 1. `uws_sys/socket.zig:132`

**Code:**
```zig
zust-port/src/uws_sys/socket.zig-133-            return @ptrCast(switch (this.socket) {
```

**Source Analysis:** unbalanced parens

**Auto-fixable:** False

**Action:** 

---

### 2. `runtime/api/cron.zig:1206`

**Code:**
```zig
zust-port/src/runtime/api/cron.zig-1207-        @ptrCast((jsc.VirtualMachine.get().transpiler.env.map.createNullDelimitedEnvMap(envp_arena.allocator()) catch {
```

**Source Analysis:** unbalanced parens

**Auto-fixable:** False

**Action:** 

---

### 3. `bun_alloc/allocation_scope.zig:96`

**Code:**
```zig
zust-port/src/bun_alloc/allocation_scope.zig-97-        const cast_ptr: [*]const u8 = @ptrCast(switch (@typeInfo(@TypeOf(ptr)).pointer.size) {
```

**Source Analysis:** unbalanced parens

**Auto-fixable:** False

**Action:** 

---

### 4. `bun_alloc/allocation_scope.zig:107`

**Code:**
```zig
zust-port/src/bun_alloc/allocation_scope.zig-108-        const cast_ptr: [*]const u8 = @ptrCast(switch (@typeInfo(@TypeOf(ptr)).pointer.size) {
```

**Source Analysis:** unbalanced parens

**Auto-fixable:** False

**Action:** 

---

