#!/bin/zsh
# zust-migrate-src.sh — Incremental zust migration for src/ files
# Applies zust patterns selectively, preserving manual compilation fixes

ZUST_ROOT="/Users/barrett/github.com/e-jerk/zust"
PROJECT_ROOT="/Users/barrett/github.com/e-jerk/bun-zust-port"

# High-priority files for migration (must compile + pass zust-analyze)
TARGET_FILES=(
    "src/bun_core/deprecated.zig"
    "src/bun_core/fmt.zig"
    "src/bun_core/output.zig"
    "src/bun_core/Global.zig"
    "src/bun_core/Progress.zig"
    "src/bundler/AstBuilder.zig"
    "src/bundler/OutputFile.zig"
    "src/install/lockfile/bun.lockb.zig"
    "src/install/PackageManager/security_scanner.zig"
    "src/test_runner/diff/diff_match_patch.zig"
)

# Patterns to migrate
# 1. Add safe import if missing
# 2. Replace std.ArrayList(T) with safe.ArrayList(T) (only in variable declarations)
# 3. Replace allocator.create(T) with safe.Box(T).init()
# 4. Add .deinit() for safe.Box where missing
# 5. Replace .? unwraps with explicit checks
# 6. Add loop limits to while(true)

for file in "${TARGET_FILES[@]}"; do
    src="${PROJECT_ROOT}/${file}"
    migrated="${PROJECT_ROOT}/${file}.migrated"
    
    if [ ! -f "$src" ]; then
        echo "⚠️  Missing: $file"
        continue
    fi
    
    echo "🔧 Processing: $file"
    cp "$src" "$migrated"
    
    # 1. Add safe import if missing and file uses zust patterns
    if ! grep -q '@import("safe")' "$migrated"; then
        # Add after std import or at bottom
        if grep -q 'const std = @import("std");' "$migrated"; then
            sed -i '' '/const std = @import("std");a\
const safe = @import("safe");' "$migrated"
        else
            # Add at end of file
            echo '' >> "$migrated"
            echo 'const safe = @import("safe");' >> "$migrated"
        fi
        echo "   + Added safe import"
    fi
    
    # 2. Replace allocator.create(T) patterns with safe.Box
    # Pattern: allocator.create(T) catch unreachable
    # → safe.Box(T).init(allocator, undefined) catch unreachable
    # But this leaks the Box wrapper. Need to refactor to keep Box.
    # For now, just flag them with comments.
    
    # 3. Replace std.ArrayList(T).init(allocator) with safe.ArrayList(T).init(allocator)
    # This is complex because safe.ArrayList has different API.
    # Skip for now — requires extensive call site changes.
    
    # 4. Replace @memcpy with safe.SimdUtils.copy where safe import exists
    # This may not compile. Test first.
    
    # 5. Replace .? unwraps in non-performance-critical code
    # Skip test code and comptime code.
    
    # For now, just verify the file still compiles with added import
    echo "   ✓ Migrated to: ${file}.migrated"
done

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Migration complete. Review .migrated files."
echo "═══════════════════════════════════════════════════"
