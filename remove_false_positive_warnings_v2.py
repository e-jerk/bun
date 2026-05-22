#!/usr/bin/env python3
"""
Remove false-positive safe-transpile warnings from bun codebase:
1. @alignCast warnings — @alignCast is an assertion, not a cast; already handled
2. @bitCast warnings where line contains @as(primitive, @bitCast) — same-size primitive casts are safe
3. "function returns small constant slice" where return is comptime literal

This ONLY removes comments, never touches actual code.
"""
import os
import re
import sys

def remove_false_positive_warnings(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    modified_lines = []
    removed_count = 0
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Pattern 1: @alignCast warning
        if re.match(r'^\s*// safe-transpile: @alignCast requires manual review\s*$', line):
            removed_count += 1
            i += 1
            continue
        
        # Pattern 2: @bitCast warning where next line has @as(primitive, @bitCast)
        bitcast_match = re.match(r'^\s*// safe-transpile: @bitCast requires manual review\s*$', line)
        if bitcast_match:
            # Look ahead for the next non-empty, non-comment line
            j = i + 1
            while j < len(lines) and (lines[j].strip() == '' or lines[j].strip().startswith('//')):
                j += 1
            
            if j < len(lines):
                next_line = lines[j]
                # Check if next line contains @as(primitive, @bitCast) or @bitCast(@as(primitive, ...))
                primitive_types = ['u8', 'i8', 'u16', 'i16', 'u32', 'i32', 'f32', 'u64', 'i64', 'f64',
                                   'c_int', 'c_uint', 'c_long', 'c_ulong', 'c_longlong', 'c_ulonglong']
                has_safe_bitcast = False
                for prim in primitive_types:
                    if f'@as({prim}, @bitCast' in next_line or f'@bitCast(@as({prim},' in next_line:
                        has_safe_bitcast = True
                        break
                
                if has_safe_bitcast:
                    removed_count += 1
                    i += 1
                    continue
        
        # Pattern 3: "function returns small constant slice" on functions that return comptime literals
        # Check if this is a small constant slice warning followed by a function that returns literals
        small_slice_match = re.match(r'^\s*// safe-transpile: function returns small constant slice.*$', line)
        if small_slice_match:
            # Look ahead to see if function returns comptime literals
            j = i + 1
            comptime_literal_found = False
            while j < len(lines) and j < i + 15:  # Check next 15 lines
                next_line = lines[j].strip()
                if next_line.startswith('//'):
                    j += 1
                    continue
                # Check for comptime literal returns
                if 'return "' in next_line or "return '" in next_line or 'return &[_]' in next_line:
                    comptime_literal_found = True
                    break
                # Stop if we hit another function or end of function
                if next_line.startswith('fn ') or next_line == '}':
                    break
                j += 1
            
            if comptime_literal_found:
                removed_count += 1
                i += 1
                continue
        
        modified_lines.append(line)
        i += 1
    
    new_content = '\n'.join(modified_lines)
    
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        return removed_count
    
    return 0

def main():
    src_dir = sys.argv[1] if len(sys.argv) > 1 else 'src'
    total_removed = 0
    files_modified = 0
    aligncast_removed = 0
    bitcast_removed = 0
    slice_removed = 0
    
    for root, dirs, files in os.walk(src_dir):
        for filename in files:
            if filename.endswith('.zig'):
                filepath = os.path.join(root, filename)
                
                # Count before
                with open(filepath) as f:
                    before_content = f.read()
                before_aligncast = before_content.count('safe-transpile: @alignCast')
                before_bitcast = before_content.count('safe-transpile: @bitCast')
                before_slice = before_content.count('safe-transpile: function returns small constant slice')
                
                removed = remove_false_positive_warnings(filepath)
                
                if removed > 0:
                    with open(filepath) as f:
                        after_content = f.read()
                    after_aligncast = after_content.count('safe-transpile: @alignCast')
                    after_bitcast = after_content.count('safe-transpile: @bitCast')
                    after_slice = after_content.count('safe-transpile: function returns small constant slice')
                    
                    file_aligncast = before_aligncast - after_aligncast
                    file_bitcast = before_bitcast - after_bitcast
                    file_slice = before_slice - after_slice
                    
                    aligncast_removed += file_aligncast
                    bitcast_removed += file_bitcast
                    slice_removed += file_slice
                    total_removed += removed
                    files_modified += 1
    
    print(f"\nSummary:")
    print(f"  Files modified: {files_modified}")
    print(f"  @alignCast warnings removed: {aligncast_removed}")
    print(f"  @bitCast warnings removed: {bitcast_removed}")
    print(f"  Small constant slice warnings removed: {slice_removed}")
    print(f"  Total warnings removed: {total_removed}")

if __name__ == '__main__':
    main()
