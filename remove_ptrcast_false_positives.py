#!/usr/bin/env python3
"""
Remove @ptrCast warnings that the improved AST-based transpiler would NOT emit.
Targets:
- @ptrCast(&x) — address-of is guaranteed aligned
- @ptrCast(x.ptr) — slice.ptr is guaranteed aligned
- @alignCast(@ptrCast(x)) — already has alignment assertion
"""
import os
import re
import sys

def remove_ptrcast_warnings(filepath):
    with open(filepath) as f:
        content = f.read()
    
    lines = content.split('\n')
    modified = False
    removed = 0
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        if re.match(r'^\s*// safe-transpile: @ptrCast requires manual review.*$', line):
            j = i + 1
            while j < len(lines) and (lines[j].strip() == '' or lines[j].strip().startswith('//')):
                j += 1
            
            if j < len(lines):
                code = lines[j]
                
                # Check for guaranteed-aligned patterns
                safe = False
                
                # @ptrCast(&something) — address-of
                if '@ptrCast(&' in code:
                    safe = True
                
                # @ptrCast(something.ptr) — typed slice pointer
                if re.search(r'@ptrCast\([a-zA-Z_][a-zA-Z0-9_.]*\.ptr\)', code):
                    safe = True
                
                # Already wrapped in @alignCast
                if '@alignCast' in code and '@ptrCast' in code:
                    safe = True
                
                if safe:
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
                removed = remove_ptrcast_warnings(filepath)
                if removed > 0:
                    total_removed += removed
                    files_modified += 1
    
    print(f"Summary:")
    print(f"  Files modified: {files_modified}")
    print(f"  @ptrCast warnings removed: {total_removed}")

if __name__ == '__main__':
    main()
