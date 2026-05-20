#!/bin/zsh
# zust-check — Run zust-analyzer on selective modules or all files

ZUST_BIN="/Users/barrett/github.com/e-jerk/zust/zig-out/bin/zust-analyze"
STRICTNESS="high"
PROJECT_ROOT="/Users/barrett/github.com/e-jerk/bun-zust-port"

# High-risk modules for selective scanning (determined by unsafe pattern density)
HIGH_RISK_MODULES=(
    "src/sys/sys.zig"
    "src/js_parser/ast/Expr.zig"
    "src/test_runner/diff/diff_match_patch.zig"
    "src/cli/pack_command.zig"
    "src/js_parser/lexer.zig"
    "src/jsc/VirtualMachine.zig"
    "src/install/lockfile/bun.lockb.zig"
    "src/install/PackageManager/security_scanner.zig"
    "src/runtime/node/node_fs.zig"
    "src/test_runner/expect.zig"
    "src/zlib/zlib.zig"
    "src/md/ansi_renderer.zig"
    "src/jsc/rare_data.zig"
    "src/interchange/toml/lexer.zig"
    "src/install/PackageManager.zig"
    "src/install/lockfile.zig"
    "src/css/css_parser.zig"
    "src/bake/DevServer.zig"
    "src/bun.zig"
    "src/bun_core/deprecated.zig"
    "src/bun_alloc/allocation_scope.zig"
    "src/bun_alloc/bun_alloc.zig"
    "src/bun_alloc/memory.zig"
    "src/bun_core/fmt.zig"
    "src/bun_core/output.zig"
    "src/bun_core/Global.zig"
    "src/bun_core/Progress.zig"
    "src/bundler/AstBuilder.zig"
    "src/bundler/bundle_v2.zig"
    "src/bundler/OutputFile.zig"
)

analyze_file() {
    local file="$1"
    local strictness="$2"
    
    if [ ! -f "$PROJECT_ROOT/$file" ]; then
        echo "⚠️  Skipping (not found): $file"
        return 0
    fi
    
    output=$($ZUST_BIN "$PROJECT_ROOT/$file" --strictness=$strictness 2>&1)
    exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "✅ $file"
        return 0
    else
        echo "❌ $file"
        # Extract diagnostics (filter out stack traces)
        diagnostics=$(echo "$output" | grep -E "^.*:\d+:\d+:\s*\[(Error|Warning)\]" | head -10)
        if [ -n "$diagnostics" ]; then
            echo "$diagnostics" | sed 's/^/   /'
        fi
        return 1
    fi
}

# Parse arguments
ALL_MODE=false
while [ $# -gt 0 ]; do
    case "$1" in
        --all)
            ALL_MODE=true
            shift
            ;;
        --strictness=*)
            STRICTNESS="${1#*=}"
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [ "$ALL_MODE" = true ]; then
    echo "🔍 Running zust-analyzer on ALL source files (this will take a while)..."
    echo "   strictness=$STRICTNESS"
    echo ""
    
    total=0
    passed=0
    failed=0
    
    while IFS= read -r file; do
        rel_path="${file#$PROJECT_ROOT/}"
        total=$((total + 1))
        if analyze_file "$rel_path" "$STRICTNESS"; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
    done < <(find "$PROJECT_ROOT/src" -name "*.zig" -not -path "*/zig-cache/*" -not -path "*/zig-out/*" | sort)
    
    echo ""
    echo "═══════════════════════════════════════"
    echo "  Total: $total | ✅ Pass: $passed | ❌ Fail: $failed"
    echo "═══════════════════════════════════════"
    
    if [ $failed -gt 0 ]; then
        exit 1
    fi
else
    # Default: run on high-risk modules
    echo "🔍 Running zust-analyzer on high-risk modules..."
    echo "   strictness=$STRICTNESS"
    echo "   modules=${#HIGH_RISK_MODULES[@]}"
    echo ""
    
    total=0
    passed=0
    failed=0
    
    for file in "${HIGH_RISK_MODULES[@]}"; do
        total=$((total + 1))
        if analyze_file "$file" "$STRICTNESS"; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
    done
    
    echo ""
    echo "═══════════════════════════════════════"
    echo "  Total: $total | ✅ Pass: $passed | ❌ Fail: $failed"
    echo "═══════════════════════════════════════"
    
    if [ $failed -gt 0 ]; then
        exit 1
    fi
fi
