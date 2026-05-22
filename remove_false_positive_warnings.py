#!/usr/bin/env python3
"""
Remove false-positive safe-transpile warnings from bun codebase:
1. For loop warnings (pointer capture + multi-iterator) — valid Zig 0.16
2. ptrCast warnings on lines where @alignCast is already present

This ONLY removes comments, never touches actual code.
"""
import os
import re
import sys

def remove_false_positive_warnings(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    original_lines = content.split('\n')
    modified_lines = []
    removed_count = 0
    
    # Pattern 1: for loop warnings (two variants)
    for_loop_patterns = [
        r'^\s*// safe-transpile: for loop with pointer capture requires manual review\s*$',
        r'^\s*// safe-transpile: for with index access requires manual review\s*$',
    ]
    
    # Pattern 2: ptrCast warnings where line also has @alignCast
    # We need to check each line individually
    for line in original_lines:
        # Check for for loop warnings
        is_for_warning = any(re.match(pattern, line) for pattern in for_loop_patterns)
        
        # Check for ptrCast warning on same line as @alignCast
        # Note: we need the line AFTER the comment to check for @alignCast
        # But since we're processing line by line, we'll do a second pass
        # For now, just remove for loop warnings
        
        if is_for_warning:
            removed_count += 1
            continue
        
        modified_lines.append(line)
    
    # Second pass: remove ptrCast warnings where the next non-comment line has @alignCast
    # Actually, the warning is on a comment line, and the @alignCast is on the code line below
    # So we need to look ahead
    final_lines = []
    i = 0
    while i < len(modified_lines):
        line = modified_lines[i]
        
        # Check if this is a ptrCast warning comment
        ptrcast_match = re.match(r'^(\s*)// safe-transpile: @ptrCast requires manual review.*$', line)
        if ptrcast_match:
            # Look ahead for the next non-empty, non-comment line
            j = i + 1
            while j < len(modified_lines) and (modified_lines[j].strip() == '' or modified_lines[j].strip().startswith('//')):
                j += 1
            
            if j < len(modified_lines):
                next_line = modified_lines[j]
                if '@alignCast' in next_line:
                    # Skip this ptrCast warning
                    removed_count += 1
                    i += 1
                    continue
        
        final_lines.append(line)
        i += 1
    
    new_content = '\n'.join(final_lines)
    
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        return removed_count
    
    return 0

def main():
    src_dir = sys.argv[1] if len(sys.argv) > 1 else 'src'
    total_removed = 0
    files_modified = 0
    
    for root, dirs, files in os.walk(src_dir):
        for filename in files:
            if filename.endswith('.zig'):
                filepath = os.path.join(root, filename)
                removed = remove_false_positive_warnings(filepath)
                if removed > 0:
                    total_removed += removed
                    files_modified += 1
                    print(f"  {filepath}: removed {removed} warnings")
    
    print(f"\nSummary:")
    print(f"  Files modified: {files_modified}")
    print(f"  Warnings removed: {total_removed}")

if __name__ == '__main__':
    main()
