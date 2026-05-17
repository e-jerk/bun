#!/bin/bash
# Fix Bun's # private field syntax for standard Zig 0.16
# Uses _ prefix convention to indicate private fields

set -euo pipefail

PORT_DIR="/Users/barrett/github.com/e-jerk/bun-zust-port"
BAK_DIR="/tmp/bun-zig-backup-$(date +%s)"

# Backup
echo "Creating backup..."
cp -r "$PORT_DIR/src" "$BAK_DIR"

# Find all .zig files with # syntax
FILES=$(grep -rln "#" "$PORT_DIR/src/" | grep "\.zig$")
TOTAL=$(echo "$FILES" | wc -l)
echo "Found $TOTAL files with # syntax"

FIXED=0
FAILED=0

for file in $FILES; do
    # Create temp file
    tmp="${file}.tmp"
    
    # Use sed to replace # prefixes with _ prefixes
    # This handles:
    #   #field: Type → _field: Type
    #   self.#field → self._field  
    #   .#field = → ._field =
    #   this.#field → this._field
    
    # We must be careful to NOT replace:
    #   // # comments
    #   /// # doc comments
    #   #include, #define, #ifdef, #endif, #pragma (in .zig files these are string literals or comments)
    
    # Strategy: use a more targeted approach
    # Replace # only when followed by an identifier character and preceded by specific patterns
    
    if sed -E '
        # Pattern 1: struct field declaration: #field_name: type
        s/^([[:space:]]*)#([a-zA-Z_][a-zA-Z0-9_]*)(:[[:space:]]*)/\1_\2\3/g
        
        # Pattern 2: field access in struct init: .#field =
        s/\. #([a-zA-Z_][a-zA-Z0-9_]*)([[:space:]]*=)/._\1\2/g
        
        # Pattern 3: field access via self/this: self.#field or this.#field
        s/(self|this)\. #([a-zA-Z_][a-zA-Z0-9_]*)/\1._\2/g
        
        # Pattern 4: field access via any var: var.#field
        s/([a-zA-Z_][a-zA-Z0-9_]*)\. #([a-zA-Z_][a-zA-Z0-9_]*)/\1._\2/g
        
        # Pattern 5: function names: fn #name() 
        s/fn #([a-zA-Z_][a-zA-Z0-9_]*)/fn _\1/g
        
        # Pattern 6: &.#field (address of field)
        s/&\. #([a-zA-Z_][a-zA-Z0-9_]*)/&._\1/g
    ' "$file" > "$tmp"; then
        
        # Verify no # remains in code lines (not comments)
        if grep -vE "^[[:space:]]*(//|///|\\*)" "$tmp" | grep -v '"#' | grep -q '#[a-zA-Z_]'; then
            echo "  WARN: Still has # in $file"
            grep -n "#" "$tmp" | grep -v "//" | grep -v '"#' | head -5
        fi
        
        # Try zig fmt
        if zig fmt "$tmp" 2>/dev/null; then
            mv "$tmp" "$file"
            ((FIXED++))
        else
            echo "  FAIL: zig fmt failed for $file"
            mv "$tmp" "$file"  # Keep it anyway, might need manual fix
            ((FAILED++))
        fi
    else
        echo "  FAIL: sed failed for $file"
        ((FAILED++))
    fi
done

echo ""
echo "=== Results ==="
echo "Files processed: $TOTAL"
echo "Fixed (zig fmt passed): $FIXED"
echo "Failed (zig fmt failed): $FAILED"
echo "Backup at: $BAK_DIR"
