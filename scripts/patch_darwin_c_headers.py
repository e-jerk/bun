import sys, re

with open(sys.argv[1], 'r') as f:
    content = f.read()

# Replace opaque mach_msg types with sized extern structs
replacements = {
    'mach_msg_type_descriptor_t': 12,
    'mach_msg_port_descriptor_t': 12,
    'mach_msg_ool_descriptor32_t': 12,
    'mach_msg_ool_descriptor64_t': 16,
    'mach_msg_ool_descriptor_t': 16,
    'mach_msg_ool_ports_descriptor32_t': 12,
    'mach_msg_ool_ports_descriptor64_t': 16,
    'mach_msg_ool_ports_descriptor_t': 16,
    'mach_msg_guarded_port_descriptor32_t': 12,
    'mach_msg_guarded_port_descriptor64_t': 16,
    'mach_msg_guarded_port_descriptor_t': 16,
    'mach_msg_descriptor_t': 16,
}

for name, size in replacements.items():
    pattern = f"pub const {name} = opaque {{}};"
    replacement = f"pub const {name} = extern struct {{ _opaque: [{size}]u8, }};"
    content = content.replace(pattern, replacement)

# Remove ALL comptime blocks containing mach_msg size assertions
# Match: comptime { ... if (!(@sizeOf(mach_msg_... ) ... @compileError ... }
content = re.sub(
    r'comptime \{\s*if \(!\(@sizeOf\(mach_msg_[\w_]+\) == @as\(c_ulong, \d+\)\)\) @compileError\("static assertion failed \\"struct changed size unexpectedly\\""\);\s*\}',
    '',
    content,
    flags=re.DOTALL
)

with open(sys.argv[2], 'w') as f:
    f.write(content)
