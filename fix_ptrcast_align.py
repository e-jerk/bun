#!/usr/bin/env python3
"""
Auto-fix @ptrCast warnings by adding @alignCast where alignment is guaranteed.
Direct source analysis without relying on the analysis file format.
"""
import os
import re
import sys

def is_guaranteed_aligned(source_arg):
    """Check if the ptrCast source has guaranteed alignment."""
    source_arg = source_arg.strip()
    
    # Address-of: &variable, &struct.field
    if source_arg.startswith('&'):
        return True
    
    # Typed slice .ptr: slice.ptr where slice is a typed array/slice
    if re.match(r'^[a-zA-Z_][a-zA-Z0-9_.]*\.ptr$', source_arg):
        return True
    
    # Well-known aligned globals
    if 'std.c.environ' in source_arg or 'std.os.environ' in source_arg:
        return True
    
    # Already has @alignCast
    if '@alignCast' in source_arg:
        return True
    
    return False

def fix_ptrcast_in_file(filepath):
    """Fix @ptrCast warnings in a single file."""
    with open(filepath) as f:
        content = f.read()
    
    lines = content.split('\n')
    modified = False
    fixes = 0
    
    for i, line in enumerate(lines):
        # Check for ptrCast warning
        if 'safe-transpile: @ptrCast requires manual review' in line:
            # Look ahead for the actual @ptrCast call
            j = i + 1
            while j < len(lines) and (lines[j].strip() == '' or lines[j].strip().startswith('//')):
                j += 1
            
            if j < len(lines):
                code_line = lines[j]
                # Find @ptrCast(X) where X doesn't contain @alignCast
                ptrcast_matches = list(re.finditer(r'@ptrCast\(([^)]+)\)', code_line))
                
                for match in ptrcast_matches:
                    arg = match.group(1)
                    if is_guaranteed_aligned(arg) and '@alignCast(' not in arg:
                        # Replace @ptrCast(arg) with @ptrCast(@alignCast(arg))
                        old = f'@ptrCast({arg})'
                        new = f'@ptrCast(@alignCast({arg}))'
                        code_line = code_line.replace(old, new)
                        fixes += 1
                
                if code_line != lines[j]:
                    lines[j] = code_line
                    modified = True
    
    if modified:
        with open(filepath, 'w') as f:
            f.write('\n'.join(lines))
    
    return fixes

def main():
    src_dir = sys.argv[1] if len(sys.argv) > 1 else 'src'
    total_fixes = 0
    files_modified = 0
    
    for root, dirs, files in os.walk(src_dir):
        for f in files:
            if f.endswith('.zig'):
                filepath = os.path.join(root, f)
                fixes = fix_ptrcast_in_file(filepath)
                if fixes > 0:
                    total_fixes += fixes
                    files_modified += 1
    
    print(f"Summary:")
    print(f"  Files modified: {files_modified}")
    print(f"  @ptrCast fixes applied: {total_fixes}")

if __name__ == '__main__':
    main()
