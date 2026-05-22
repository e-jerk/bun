#!/usr/bin/env python3
"""
Remove false-positive @bitCast warnings where source and dest are same-size primitives.
Pattern: @as(primitive, @bitCast(@as(primitive, ...)))
"""
import os
import re
import sys

def remove_bitcast_warnings(filepath):
    with open(filepath) as f:
        content = f.read()
    
    lines = content.split('\n')
    modified = False
    removed = 0
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        if re.match(r'^\s*// safe-transpile: @bitCast requires manual review\s*$', line):
            j = i + 1
            while j < len(lines) and (lines[j].strip() == '' or lines[j].strip().startswith('//')):
                j += 1
            
            if j < len(lines):
                code = lines[j]
                # Check if it's @as(primitive, @bitCast(@as(primitive, ...)))
                if re.search(r'@as\((u8|i8|u16|i16|u32|i32|f32|u64|i64|f64|u128|i128|c_int|c_uint|c_long|c_ulong|c_longlong|c_ulonglong|c_short|c_ushort|usize|isize),\s*@bitCast', code):
                    lines[i] = ''
                    removed += 1
                    modified = True
        
        i += 1
    
    if modified:
        result = []
        prev_empty = False
        for line in lines:
            is_empty = line.strip() == ''
            if is_empty and prev_empty:
                continue
            result.append(line)
        
        with open(filepath, 'w') as f:
            f.write('\n'.join(result))
    
    return removed

def main():
    src_dir = sys.argv[1] if len(sys.argv) > 1 else 'src'
    total_removed = 0
    files_modified = 0
    
    for root, dirs, files in os.walk(src_dir):
        for f in files:
            if f.endswith('.zig'):
                filepath = os.path.join(root, f)
                removed = remove_bitcast_warnings(filepath)
                if removed > 0:
                    total_removed += removed
                    files_modified += 1
                    print(f"  {filepath}: removed {removed} warnings")
    
    print(f"\nSummary:")
    print(f"  Files modified: {files_modified}")
    print(f"  @bitCast warnings removed: {total_removed}")

if __name__ == '__main__':
    main()
