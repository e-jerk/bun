#!/usr/bin/env python3
"""
Fix Bun's # private field syntax for standard Zig 0.16
Uses _ prefix convention to indicate private fields
"""

import re
import sys
import subprocess
from pathlib import Path

def is_in_comment_or_string(line, pos):
    """Check if position is inside a comment or string literal"""
    in_string = False
    string_char = None
    i = 0
    while i < pos:
        if i >= len(line):
            return True
        ch = line[i]
        if not in_string:
            if ch == '"' or ch == "'":
                in_string = True
                string_char = ch
            elif ch == '/' and i + 1 < len(line) and line[i + 1] == '/':
                return True  # Inside comment
        else:
            if ch == string_char and (i == 0 or line[i-1] != '\\'):
                in_string = False
                string_char = None
        i += 1
    return in_string

def fix_line(line):
    """Replace #field with _field in a single line"""
    result = []
    i = 0
    while i < len(line):
        if line[i] == '#' and i + 1 < len(line) and (line[i+1].isalpha() or line[i+1] == '_'):
            # Check if we're in a comment or string
            if is_in_comment_or_string(line, i):
                result.append(line[i])
                i += 1
                continue
            
            # Found #identifier, replace with _identifier
            result.append('_')
            i += 1
        else:
            result.append(line[i])
            i += 1
    return ''.join(result)

def process_file(filepath):
    """Process a single .zig file"""
    try:
        with open(filepath, 'r') as f:
            content = f.read()
    except Exception as e:
        print(f"  ERROR reading {filepath}: {e}")
        return False
    
    lines = content.split('\n')
    modified = False
    new_lines = []
    
    for line in lines:
        # Skip comment-only lines
        stripped = line.lstrip()
        if stripped.startswith('//') or stripped.startswith('///'):
            new_lines.append(line)
            continue
        
        # Check if line has # followed by identifier
        if re.search(r'#[a-zA-Z_]', line):
            new_line = fix_line(line)
            if new_line != line:
                modified = True
                line = new_line
        
        new_lines.append(line)
    
    if not modified:
        return True  # No changes needed
    
    # Write modified content
    new_content = '\n'.join(new_lines)
    try:
        with open(filepath, 'w') as f:
            f.write(new_content)
    except Exception as e:
        print(f"  ERROR writing {filepath}: {e}")
        return False
    
    # Verify with zig fmt
    try:
        result = subprocess.run(
            ['zig', 'fmt', filepath],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            return True
        else:
            print(f"  zig fmt failed for {filepath}")
            print(f"    {result.stderr[:200]}")
            return False
    except Exception as e:
        print(f"  zig fmt error for {filepath}: {e}")
        return False

def main():
    port_dir = Path('/Users/barrett/github.com/e-jerk/bun-zust-port')
    src_dir = port_dir / 'src'
    
    # Find all .zig files
    zig_files = list(src_dir.rglob('*.zig'))
    
    # Filter to only files that contain # followed by identifier
    files_to_fix = []
    for f in zig_files:
        try:
            with open(f, 'r') as file:
                content = file.read()
                if re.search(r'#[a-zA-Z_]', content):
                    files_to_fix.append(f)
        except:
            pass
    
    total = len(files_to_fix)
    print(f"Found {total} files with # private field syntax")
    
    fixed = 0
    failed = 0
    
    for i, filepath in enumerate(files_to_fix, 1):
        rel_path = filepath.relative_to(port_dir)
        print(f"[{i}/{total}] {rel_path}...", end=' ')
        
        if process_file(str(filepath)):
            print("OK")
            fixed += 1
        else:
            print("FAIL")
            failed += 1
    
    print(f"\n=== Results ===")
    print(f"Files processed: {total}")
    print(f"Fixed: {fixed}")
    print(f"Failed: {failed}")

if __name__ == '__main__':
    main()
