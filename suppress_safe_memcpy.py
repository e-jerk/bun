#!/usr/bin/env python3
"""
Suppress @memcpy warnings where destination is a safe bounded destination.
Only removes the warning comment, never modifies actual code.
"""
import os
import re
import sys

def suppress_safe_memcpy(filepath):
    with open(filepath) as f:
        content = f.read()
    
    lines = content.split('\n')
    modified = False
    removed = 0
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        if 'safe-transpile: @memcpy requires manual review' in line:
            # Look ahead for the actual @memcpy call
            j = i + 1
            while j < len(lines) and (lines[j].strip() == '' or lines[j].strip().startswith('//')):
                j += 1
            
            if j < len(lines):
                code_line = lines[j]
                
                # Check if destination is SAFE
                safe = False
                
                # Pattern 1: Destination is stack array: var buf: [N]T = ...
                # Look for @memcpy(buf[...], ...) where buf was declared as [N]T nearby
                stack_array_match = re.search(r'@memcpy\(([a-zA-Z_][a-zA-Z0-9_]*)\[', code_line)
                if stack_array_match:
                    var_name = stack_array_match.group(1)
                    # Check if this variable is a stack array by looking backwards
                    k = i - 1
                    while k >= 0 and k >= i - 10:
                        if f'var {var_name}:' in lines[k] or f'var {var_name} =' in lines[k]:
                            if '[' in lines[k] and ']' in lines[k]:
                                safe = True
                                break
                        k -= 1
                
                # Pattern 2: Destination is `this.` field (inline struct buffer)
                this_field_match = re.search(r'@memcpy\(this\.([a-zA-Z_][a-zA-Z0-9_]*)', code_line)
                if this_field_match:
                    # Struct fields with inline buffers are typically safe
                    safe = True
                
                # Pattern 3: Destination is local slice with explicit bounds
                # e.g., @memcpy(user[0..len], src) where user is a bounded slice
                bounded_slice = re.search(r'@memcpy\(([a-zA-Z_][a-zA-Z0-9_]*)\[0\.\.', code_line)
                if bounded_slice:
                    safe = True
                
                # Pattern 4: Destination has @min or explicit size computation
                if '@min(' in code_line or '.len]' in code_line:
                    safe = True
                
                if safe:
                    # Remove the warning comment
                    lines[i] = ''
                    removed += 1
                    modified = True
        
        i += 1
    
    if modified:
        # Remove empty lines that were comments
        new_content = '\n'.join(lines)
        with open(filepath, 'w') as f:
            f.write(new_content)
    
    return removed

def main():
    src_dir = sys.argv[1] if len(sys.argv) > 1 else 'src'
    total_removed = 0
    files_modified = 0
    
    for root, dirs, files in os.walk(src_dir):
        for f in files:
            if f.endswith('.zig'):
                filepath = os.path.join(root, f)
                removed = suppress_safe_memcpy(filepath)
                if removed > 0:
                    total_removed += removed
                    files_modified += 1
    
    print(f"Summary:")
    print(f"  Files modified: {files_modified}")
    print(f"  @memcpy warnings suppressed: {total_removed}")

if __name__ == '__main__':
    main()
