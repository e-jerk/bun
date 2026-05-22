#!/usr/bin/env python3
"""
Auto-fix EASY @intCast warnings by converting to safe.CheckedInt(T) wrapper.
Only handles patterns where destination type T is explicitly visible on same line:
- @as(T, @intCast(value)) -> safe.CheckedInt(T).init(@as(T, @intCast(value)))
- const x: T = @intCast(value) -> const x: T = safe.CheckedInt(T).init(@intCast(value))
"""
import os
import re
import sys

def fix_intcast_in_file(filepath):
    with open(filepath) as f:
        content = f.read()
    
    lines = content.split('\n')
    modified = False
    fixes = 0
    
    for i, line in enumerate(lines):
        # Check for intCast warning
        if 'safe-transpile: @intCast requires manual review' in line:
            # Look ahead for the actual @intCast call
            j = i + 1
            while j < len(lines) and (lines[j].strip() == '' or lines[j].strip().startswith('//')):
                j += 1
            
            if j < len(lines):
                code_line = lines[j]
                original = code_line
                
                # Pattern 1: @as(T, @intCast(value))
                # Replace with: safe.CheckedInt(T).init(@as(T, @intCast(value)))
                pattern1 = r'@as\(([^,]+),\s*@intCast\(([^)]+)\)\)'
                matches1 = list(re.finditer(pattern1, code_line))
                for match in reversed(matches1):
                    t_type = match.group(1).strip()
                    value = match.group(2).strip()
                    old_text = match.group(0)
                    new_text = f'safe.CheckedInt({t_type}).init({old_text})'
                    code_line = code_line[:match.start()] + new_text + code_line[match.end():]
                    fixes += 1
                
                # Pattern 2: var/const x: T = @intCast(value)
                pattern2 = r'(var|const)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*:\s*([^=]+)=\s*@intCast\(([^)]+)\)'
                matches2 = list(re.finditer(pattern2, code_line))
                for match in reversed(matches2):
                    decl_type = match.group(3).strip()
                    value = match.group(4).strip()
                    old_text = match.group(0)
                    # Get the part after the = sign
                    after_equals = code_line[match.start():]
                    # Replace just the @intCast part
                    new_text = f'{match.group(1)} {match.group(2)}: {decl_type}= safe.CheckedInt({decl_type}).init(@intCast({value}))'
                    code_line = code_line[:match.start()] + new_text + code_line[match.end():]
                    fixes += 1
                
                if code_line != original:
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
                fixes = fix_intcast_in_file(filepath)
                if fixes > 0:
                    total_fixes += fixes
                    files_modified += 1
    
    print(f"Summary:")
    print(f"  Files modified: {files_modified}")
    print(f"  @intCast EASY fixes applied: {total_fixes}")

if __name__ == '__main__':
    main()
