# *T Parameter to safe.Box(T) Transpiler Enhancement

## Goal
Extend the zust transpiler to automatically convert function parameters of type `*T` and `*const T` to `safe.Box(T)`, and rewrite all dereferences of those parameters within the function body to use `.ptr`.

## Architecture
Add a new AST pass in `handleFnProto` that:
1. Detects `*T` / `*const T` parameter types in function signatures
2. Replaces the parameter type with `safe.Box(T)` (where T is the inner type)
3. Records the parameter name in a per-function scope registry
4. Rewrites body usages: `param.*` → `param.ptr.*`, `param.field` → `param.ptr.field`, `param[index]` → `param.ptr[index]`

## Variants That Must Be Handled

### 1. Parameter Type Detection (What to convert)

| Source Pattern | Action | Reason |
|---|---|---|
| `*T` where T is not `anyopaque` | Convert to `safe.Box(T)` | Standard owned pointer |
| `*const T` | Convert to `safe.Box(T)` | Box owns the value regardless of const |
| `?*T` | Convert to `?safe.Box(T)` | Optional owned pointer |
| `*T` where T is `anyopaque`, `c_void`, `extern struct` | **Skip** | C interop / opaque pointers |
| `[]T` / `[]const u8` | **Skip** (existing comment only) | Slices are different from single pointers |
| `[*]T` / `[*c]T` | **Skip** | Many-item / C pointers need special handling |
| `**T` / `***T` (double/triple pointer) | **Skip** | Too complex for automatic conversion |
| `*T` in `extern` / `callconv(.c)` functions | **Skip** | C ABI compatibility |
| `*T` in `pub` functions exported to JS/C++ | **Skip** | External ABI compatibility |
| `*T` where T is a function pointer type | **Skip** | Function pointers are different |

### 2. Parameter Type Replacement (What text to emit)

| Source | Replacement | Example |
|---|---|---|
| `*T` | `safe.Box(T)` | `node: *Node` → `node: safe.Box(Node)` |
| `*const T` | `safe.Box(T)` | `data: *const u8` → `data: safe.Box(u8)` |
| `?*T` | `?safe.Box(T)` | `opt: ?*Node` → `opt: ?safe.Box(Node)` |

### 3. Body Usage Rewrites (What to change inside the function)

When parameter `p: *T` becomes `p: safe.Box(T)`:

| Source Pattern | Replacement | Example |
|---|---|---|
| `p.*` | `p.ptr.*` | `node.*.next = ...` → `node.ptr.*.next = ...` |
| `p.* = value` | `p.ptr.* = value` | `node.* = new_node` → `node.ptr.* = new_node` |
| `p.field` | `p.ptr.field` | `node.data` → `node.ptr.data` |
| `p[index]` | `p.ptr[index]` | `data[0]` → `data.ptr[0]` |
| `p + 1` | `p.ptr + 1` | `ptr + offset` → `ptr.ptr + offset` |
| `p - 1` | `p.ptr - 1` | `ptr - offset` → `ptr.ptr - offset` |
| `&p.*` | `p.ptr` | `&node.*` → `node.ptr` |
| `p == q` | `p.ptr == q.ptr` | Pointer comparison |
| `p != null` | `p != null` | Keep (Box is never null) |
| `p == null` | `false` | Box is never null |
| `if (p) \|v\|` | **Remove** | Box always has value |
| `p.?` | `p` | Box is never optional |

### 4. Call Site Handling (What happens at callers)

The transpiler operates file-by-file and does NOT have cross-file analysis. Therefore:

**Decision: Do NOT automatically rewrite call sites.**

Instead, when a parameter is converted, emit a comment before the function:
```zig
// safe-transpile: parameter 'node' converted to safe.Box(Node)
//                  callers must pass safe.Box(Node) instead of *Node
```

This allows the developer to:
1. See which functions need caller updates
2. Update callers manually or with a follow-up tool
3. Decide whether to keep raw pointers for functions with many external callers

### 5. Edge Cases to Skip (Do NOT convert)

| Edge Case | Reason |
|---|---|
| Self-referential structs | `*T` where T contains a field of type `*T` - Box would create circular ownership |
| Function is a method on T itself | `fn(self: *T)` in `impl T` - self pointer should NOT be Box |
| Parameter is `this: *Self` in struct methods | Self pointer is borrowed, not owned |
| Parameter is `allocator: *std.mem.Allocator` | Allocator is always borrowed, never owned |
| Parameter is used in `@ptrCast` to `*anyopaque` | Likely C interop |
| Parameter is immediately passed to `extern` function | C FFI |
| Parameter name starts with `_` | Unused parameter, skip |

## Implementation Steps

### Step 1: Extend `handleFnProto` to detect and convert `*T` parameters

Modify `handleFnProto` in `tools/transpiler.zig`:

```zig
fn handleFnProto(self: *Self, node: std.zig.Ast.Node.Index) !void {
    // ... existing code ...
    
    // NEW: Detect *T / *const T parameters and convert to safe.Box(T)
    var box_conversions = std.ArrayList(BoxConversion).init(self._allocator);
    defer box_conversions.deinit();
    
    for (proto.ast.params) |param_type| {
        const type_span = ast.nodeToSpan(param_type);
        const type_text = source[type_span.start..type_span.end];
        
        if (isConvertiblePointerType(type_text)) {
            const inner_type = extractPointerInnerType(type_text);
            if (shouldConvertToBox(inner_type)) {
                const repl = try std.fmt.allocPrint(self._allocator, "safe.Box({s})", .{inner_type});
                try self.addEdit(type_span.start, type_span.end, repl);
                
                // Record parameter name for body rewrite
                // Need to get param name from the param node (not just type)
                // Zig AST: param node has name token and type node
                const param_name = getParamName(ast, param_type);
                try box_conversions.append(.{
                    .name = param_name,
                    .inner_type = inner_type,
                });
            }
        }
    }
    
    // Emit conversion comment if any params were converted
    if (box_conversions.items.len > 0) {
        const span = ast.nodeToSpan(node);
        var line_start = span.start;
        while (line_start > 0 and source[line_start - 1] != '\n') {
            line_start -= 1;
        }
        
        var comment = safe.String.init(self._allocator);
        defer comment.deinit();
        try comment.append("// safe-transpile: parameters converted to safe.Box — callers must update\n");
        for (box_conversions.items) |conv| {
            try std.fmt.format(comment.writer(), "//   {s}: safe.Box({s})\n", .{conv.name, conv.inner_type});
        }
        try self.addEdit(line_start, line_start, comment.slice());
    }
}
```

### Step 2: Add body usage rewrite pass

Add a new handler `rewriteBoxDereferences` that walks the function body and rewrites usages of converted parameters.

This needs to run AFTER `collectEdits` on the function body nodes, or as a separate pass that looks for:
- `.identifier` nodes matching recorded parameter names
- Parent nodes: `.deref`, `.field_access`, `.array_access`
- Sibling nodes: arithmetic operators `+`, `-`

```zig
fn rewriteBoxDereferences(self: *Self, body_node: std.zig.Ast.Node.Index, box_params: []const BoxConversion) !void {
    const ast = &self.ast.?;
    const source = self.source.slice();
    
    // Walk all nodes in the body
    // For each identifier matching a box param name:
    //   - If parent is .deref: rewrite `param.*` → `param.ptr.*`
    //   - If parent is .field_access: rewrite `param.field` → `param.ptr.field`
    //   - If parent is .array_access: rewrite `param[index]` → `param.ptr[index]`
    //   - If used in arithmetic: rewrite `param + N` → `param.ptr + N`
    
    // This requires a full tree walk of the function body subtree
}
```

### Step 3: Helper functions

```zig
fn isConvertiblePointerType(type_text: []const u8) bool {
    // Match: *T, *const T, ?*T, ?*const T
    // Skip: []T, [*]T, [*c]T, **T, *anyopaque
    if (std.mem.startsWith(u8, type_text, "[]")) return false;
    if (std.mem.startsWith(u8, type_text, "[*")) return false;
    if (std.mem.startsWith(u8, type_text, "*")) {
        // Check for double pointer
        const after_star = type_text[1..];
        if (after_star.len > 0 and after_star[0] == '*') return false;
        // Skip *anyopaque
        if (std.mem.indexOf(u8, after_star, "anyopaque")) |_| return false;
        return true;
    }
    if (std.mem.startsWith(u8, type_text, "?*")) {
        const after_qstar = type_text[2..];
        if (after_qstar.len > 0 and after_qstar[0] == '*') return false;
        if (std.mem.indexOf(u8, after_qstar, "anyopaque")) |_| return false;
        return true;
    }
    return false;
}

fn extractPointerInnerType(type_text: []const u8) []const u8 {
    // *const T → T
    // *T → T
    // ?*T → T
    var start: usize = 1; // skip *
    if (type_text.len > 1 and type_text[0] == '?') {
        start = 2; // skip ?*
    }
    if (start < type_text.len and std.mem.startsWith(u8, type_text[start..], "const ")) {
        start += 7; // skip "const "
    }
    return type_text[start..];
}

fn shouldConvertToBox(inner_type: []const u8) bool {
    // Skip function pointer types
    if (std.mem.startsWith(u8, inner_type, "fn(")) return false;
    // Skip extern types
    if (std.mem.startsWith(u8, inner_type, "extern")) return false;
    // Skip C types
    if (std.mem.eql(u8, inner_type, "c_void") or 
        std.mem.eql(u8, inner_type, "anyopaque")) return false;
    return true;
}
```

### Step 4: Tests

Add tests for the new behavior:

```zig
test "pattern: *T param → safe.Box(T)" {
    const allocator = std.testing.allocator;
    const input =
        \\fn process(node: *Node) void {
        \\    node.*.next = null;
        \\    node.data = 42;
        \\}
    ;
    
    var transpiler = Transpiler.init(allocator);
    defer transpiler.deinit();
    
    const output = try transpiler.transpileFile(input, allocator);
    defer allocator.free(output);
    
    try std.testing.expect(std.mem.containsAtLeast(u8, output, 1, "node: safe.Box(Node)"));
    try std.testing.expect(std.mem.containsAtLeast(u8, output, 1, "node.ptr.*.next = null"));
    try std.testing.expect(std.mem.containsAtLeast(u8, output, 1, "node.ptr.data = 42"));
}

test "pattern: *const T param → safe.Box(T)" {
    const allocator = std.testing.allocator;
    const input =
        \\fn read(data: *const u8, len: usize) u8 {
        \\    return data[0];
        \\}
    ;
    
    var transpiler = Transpiler.init(allocator);
    defer transpiler.deinit();
    
    const output = try transpiler.transpileFile(input, allocator);
    defer allocator.free(output);
    
    try std.testing.expect(std.mem.containsAtLeast(u8, output, 1, "data: safe.Box(u8)"));
    try std.testing.expect(std.mem.containsAtLeast(u8, output, 1, "data.ptr[0]"));
}

test "skip: []T param gets comment only" {
    const allocator = std.testing.allocator;
    const input =
        \\fn process(data: []u8) void {
        \\    data[0] = 1;
        \\}
    ;
    
    var transpiler = Transpiler.init(allocator);
    defer transpiler.deinit();
    
    const output = try transpiler.transpileFile(input, allocator);
    defer allocator.free(output);
    
    // Should NOT convert to Box
    try std.testing.expect(!std.mem.containsAtLeast(u8, output, 1, "safe.Box(u8)"));
    // Should add comment
    try std.testing.expect(std.mem.containsAtLeast(u8, output, 1, "raw slice parameter"));
}

test "skip: **T param not converted" {
    const allocator = std.testing.allocator;
    const input =
        \\fn process(node: **Node) void {
        \\    node.*.*.next = null;
        \\}
    ;
    
    var transpiler = Transpiler.init(allocator);
    defer transpiler.deinit();
    
    const output = try transpiler.transpileFile(input, allocator);
    defer allocator.free(output);
    
    try std.testing.expect(!std.mem.containsAtLeast(u8, output, 1, "safe.Box(Node)"));
}
```

## Risks and Limitations

1. **Call sites not updated**: The transpiler only modifies the function definition. Callers will break compilation until manually updated.
2. **Address-of operator (`&param`)**: If code does `&param` where `param: *T`, converting to Box changes the semantics (address of Box struct vs address of T). These cases must be manually reviewed.
3. **Pointer arithmetic on struct fields**: `&node.next` where `node: *Node` becomes `&node.ptr.next` — this is correct but changes type from `*FieldType` to `*FieldType` (same).
4. **Cross-function passing**: When `param` is passed to another function expecting `*T`, the transpiler can't know if that function was also converted. The body rewrite will add `.ptr`, which is correct for raw pointer callees but may need `.ptr` removal if callee was also Box-converted.

## Mitigation: Selective Conversion Comments

For functions that are NOT converted (skipped), emit a different comment explaining why:

```zig
// safe-transpile: SKIPPED — *T parameter in extern function (C ABI)
// safe-transpile: SKIPPED — **T is too complex for automatic conversion
// safe-transpile: SKIPPED — []T is a slice, not a single pointer (use safe.Slice)
```

## Execution Plan

1. Implement helper functions (`isConvertiblePointerType`, `extractPointerInnerType`, `shouldConvertToBox`)
2. Extend `handleFnProto` to detect and replace `*T` parameters
3. Implement body rewrite pass for `.ptr` dereferences
4. Add comprehensive tests
5. Run transpiler tests: `zig build transpile-test`
6. Build transpiler: `zig build transpile`
7. Run on sample file: `./zig-out/bin/zust-transpile sample.zig output.zig`
8. Apply to Bun codebase (manual or scripted)
9. Verify compilation
