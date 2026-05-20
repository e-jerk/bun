#!/bin/zsh
# zust-check — Helper to run zust-analyze on specific files with clean output

ZUST_BIN="/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze"
STRICTNESS="${ZUST_STRICTNESS:-high}"

if [ $# -eq 0 ]; then
    echo "Usage: zust-check <file.zig> [file2.zig ...]"
    echo "   or: ZUST_STRICTNESS=medium zust-check src/foo.zig"
    exit 1
fi

for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "❌ File not found: $file"
        continue
    fi
    
    echo "🔍 Analyzing: $file (strictness=$STRICTNESS)"
    output=$($ZUST_BIN "$file" --strictness=$STRICTNESS 2>&1)
    exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "✅ No zust issues found"
    else
        # Extract just the relevant diagnostics
        echo "$output" | grep -E "(error:|warning:|note:)" | head -20
        echo "..."
    fi
    echo ""
done
