#!/bin/bash
# Comprehensive test and metrics script for bun zust port

set -euo pipefail

PORT_DIR="/Users/barrett/github.com/e-jerk/bun-zust-port"
ORIG_DIR="/Users/barrett/github.com/e-jerk/bun-zig-last"
RUST_DIR="/Users/barrett/github.com/e-jerk/bun"
RESULTS_FILE="/tmp/bun_zust_metrics.md"

echo "# Bun Zust Port - Metrics and Test Results" > "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "Generated: $(date)" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# --- Source Metrics ---
echo "## Source Code Metrics" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

ORIG_ZIG_LOC=$(find "$ORIG_DIR/src" -name "*.zig" -exec cat {} + | wc -l)
ZUST_ZIG_LOC=$(find "$PORT_DIR/src" -name "*.zig" -exec cat {} + | wc -l)
RUST_LOC=$(find "$RUST_DIR/src" -name "*.rs" -exec cat {} + | wc -l)

ORIG_ZIG_FILES=$(find "$ORIG_DIR/src" -name "*.zig" | wc -l)
ZUST_FILES=$(find "$PORT_DIR/src" -name "*.zig" | wc -l)
RUST_FILES=$(find "$RUST_DIR/src" -name "*.rs" | wc -l)

echo "| Metric | Original Zig | Zust Port | Rust |" >> "$RESULTS_FILE"
echo "|--------|-------------|-----------|------|" >> "$RESULTS_FILE"
echo "| Files | $ORIG_ZIG_FILES | $ZUST_FILES | $RUST_FILES |" >> "$RESULTS_FILE"
echo "| Lines of Code | $ORIG_ZIG_LOC | $ZUST_ZIG_LOC | $RUST_LOC |" >> "$RESULTS_FILE"
echo "| LOC Change | - | +$((ZUST_ZIG_LOC - ORIG_ZIG_LOC)) | - |" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# --- Zust Transformations ---
echo "## Zust Transformations Applied" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

SAFE_IMPORTS=$(grep -rn "const safe = @import(\"safe\")" "$PORT_DIR/src" | wc -l)
ARRAY_LIST_REPLACEMENTS=$(grep -rn "safe.ArrayList" "$PORT_DIR/src" | wc -l)
BOX_REPLACEMENTS=$(grep -rn "safe.Box(" "$PORT_DIR/src" | wc -l)
LOOP_LIMITS=$(grep -rn "__loop_limit\|__zust_loop" "$PORT_DIR/src" | wc -l)
NULL_CHECKS=$(grep -rn "else return error.Null" "$PORT_DIR/src" | wc -l)

echo "- Files with safe import: $SAFE_IMPORTS" >> "$RESULTS_FILE"
echo "- safe.ArrayList usages: $ARRAY_LIST_REPLACEMENTS" >> "$RESULTS_FILE"
echo "- safe.Box usages: $BOX_REPLACEMENTS" >> "$RESULTS_FILE"
echo "- Loop limits added: $LOOP_LIMITS" >> "$RESULTS_FILE"
echo "- Null checks added: $NULL_CHECKS" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# --- Test Results ---
echo "## Compilation Test Results" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "Testing standalone .zig files..."
PASS=0
FAIL=0
ERRORS=""

# Test files that should compile standalone
TEST_FILES=(
  "src/bun_core/result.zig"
  "src/bun_core/deprecated.zig"
  "src/string/StringBuilder.zig"
  "src/semver/Version.zig"
  "src/unicode/uucode/lut.zig"
  "src/string/immutable/paths.zig"
  "src/ptr/ref_count.zig"
  "src/collections/linear_fifo.zig"
)

for f in "${TEST_FILES[@]}"; do
  filepath="$PORT_DIR/$f"
  if [ -f "$filepath" ]; then
    if zig test "$filepath" 2>/dev/null; then
      echo "- PASS: $f" >> "$RESULTS_FILE"
      ((PASS++))
    else
      echo "- FAIL: $f" >> "$RESULTS_FILE"
      ((FAIL++))
      err=$(zig test "$filepath" 2>&1 | head -3)
      ERRORS="$ERRORS\n  $f: $err"
    fi
  fi
done

echo "" >> "$RESULTS_FILE"
echo "**Summary: $PASS passed, $FAIL failed**" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# --- Bugs Caught by Zust ---
echo "## Bugs Caught by Zust" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "1. **deprecated.zig:147** - `return error.Null` in a `void` function." >> "$RESULTS_FILE"
echo "   The original `.?` unwrap would panic at runtime. Zust transformation exposed" >> "$RESULTS_FILE"
echo "   that this function cannot return errors, requiring proper error handling." >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "## Compilation Errors Summary" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "Pre-existing Zig 0.16 incompatibilities (not caused by zust):" >> "$RESULTS_FILE"
echo "- `#` private field syntax (13 files)" >> "$RESULTS_FILE"
echo "- `env_map` renamed to `environ_map` in Build.Graph" >> "$RESULTS_FILE"
echo "- `std.process.Child.run` removed in 0.16" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "Zust-related compilation issues:" >> "$RESULTS_FILE"
echo "- `safe.Box` return type incompatible with raw pointer fields" >> "$RESULTS_FILE"
echo "- `safe.ArrayList` API incompatible with `ArrayListUnmanaged` patterns" >> "$RESULTS_FILE"
echo "- Loop limit additions may affect CAS spinloop semantics" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# --- Build Comparison ---
echo "## Build Comparison" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "| Aspect | Original Zig | Rust | Zust Port |" >> "$RESULTS_FILE"
echo "|--------|-------------|------|-----------|" >> "$RESULTS_FILE"
echo "| Build System | build.zig | Cargo | build.zig + zust |" >> "$RESULTS_FILE"
echo "| Build Status | Incompatible with Zig 0.16 | Missing vendor deps | Incompatible with Zig 0.16 |" >> "$RESULTS_FILE"
echo "| Test Status | Partial | N/A (no build) | Partial |" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

cat "$RESULTS_FILE"
echo ""
echo "Full report saved to: $RESULTS_FILE"
