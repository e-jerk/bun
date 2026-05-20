//! This file defines the low(er)-level `get` method, returning `Data`.
//! (It also must be separate from `root.zig` so that `types.zig` can use it to
//! allow for a better API on `Slice` fields.)

fn TableData(comptime Table: anytype) type {
    const DataSlice = if (@hasField(Table, "stage3"))
        @FieldType(Table, "stage3")
    else
        @FieldType(Table, "stage2");
    return @typeInfo(DataSlice).pointer.child;
}

// safe-transpile: function uses raw slice parameter — consider safe.String
fn tableInfoFor(comptime field: []const u8) std.builtin.Type.StructField {
    inline for (@typeInfo(@TypeOf(tables)).@"struct".fields) |tableInfo| {
        if (@hasField(TableData(tableInfo.type), field)) {
            return tableInfo;
        }
    }

    @compileError("Table not found for field: " ++ field);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
fn getTableInfo(comptime table_name: []const u8) std.builtin.Type.StructField {
    inline for (@typeInfo(@TypeOf(tables)).@"struct".fields) |tableInfo| {
        if (safe.SimdUtils.eql(tableInfo.name, table_name)) {
            return tableInfo;
        }
    }

    @compileError("Table '" ++ table_name ++ "' not found in tables");
}

// safe-transpile: function uses raw slice parameter — consider safe.String
fn BackingFor(comptime field: []const u8) type {
    const tableInfo = tableInfoFor(field);
    const Backing = @FieldType(@FieldType(@TypeOf(tables), tableInfo.name), "backing");
    return @FieldType(@typeInfo(Backing).pointer.child, field);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn backingFor(comptime field: []const u8) BackingFor(field) {
    const tableInfo = tableInfoFor(field);
    return @field(@field(tables, tableInfo.name).backing, field);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
fn TableFor(comptime field: []const u8) type {
    const tableInfo = tableInfoFor(field);
    return @FieldType(@TypeOf(tables), tableInfo.name);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
fn tableFor(comptime field: []const u8) TableFor(field) {
    return @field(tables, tableInfoFor(field).name);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
fn GetTable(comptime table_name: []const u8) type {
    const tableInfo = getTableInfo(table_name);
    return @FieldType(@TypeOf(tables), tableInfo.name);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
fn getTable(comptime table_name: []const u8) GetTable(table_name) {
    return @field(tables, getTableInfo(table_name).name);
}

fn data(comptime table: anytype, cp: u21) TableData(@TypeOf(table)) {
    const stage1_idx = cp >> 8;
    const stage2_idx = cp & 0xFF;
    if (@hasField(@TypeOf(table), "stage3")) {
        return table.stage3[table.stage2[table.stage1[stage1_idx] + stage2_idx]];
    } else {
        return table.stage2[table.stage1[stage1_idx] + stage2_idx];
    }
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn getAll(comptime table_name: []const u8, cp: u21) TypeOfAll(table_name) {
    const table = comptime getTable(table_name);
    return data(table, cp);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
pub fn TypeOfAll(comptime table_name: []const u8) type {
    return TableData(getTableInfo(table_name).type);
}

pub const FieldEnum = blk: {
    var fields_len: usize = 0;
    for (@typeInfo(@TypeOf(tables)).@"struct".fields) |tableInfo| {
        fields_len += @typeInfo(TableData(tableInfo.type)).@"struct".fields.len;
    }

    var names: [fields_len][]const u8 = .{};
    var values: [fields_len]std.math.IntFittingRange(0, fields_len - 1) = .{};
    var i: usize = 0;

    for (@typeInfo(@TypeOf(tables)).@"struct".fields) |tableInfo| {
        for (@typeInfo(TableData(tableInfo.type)).@"struct".fields) |f| {
            names[i] = f.name;
            values[i] = i;
            i += 1;
        }
    }

    break :blk @Type(.{
        .@"enum" = .{
            .tag_type = std.math.IntFittingRange(0, fields_len - 1),
            .fields = blk: {
                var enum_fields: [fields_len]std.builtin.Type.EnumField = .{};
                for (0..fields_len) |i| {
                    enum_fields[i] = .{
                        .name = names[i],
                        .value = values[i],
                    };
                }
                break :blk &enum_fields;
            },
            .decls = &.{},
            .is_exhaustive = true,
        },
    });
};

// safe-transpile: function uses raw slice parameter — consider safe.String
fn DataField(comptime field: []const u8) type {
    return @FieldType(TableData(tableInfoFor(field).type), field);
}

// safe-transpile: function uses raw slice parameter — consider safe.String
fn FieldValue(comptime field: []const u8) type {
    const D = DataField(field);
    if (@typeInfo(D) == .@"struct") {
        if (@hasDecl(D, "unshift") and @TypeOf(D.unshift) != void) {
            return if (@typeInfo(@TypeOf(D.unshift)).@"fn".return_type) |value| {
    value
} else {
    return error.NullPointer;
};
        } else if (@hasDecl(D, "unpack")) {
            return if (@typeInfo(@TypeOf(D.unpack)).@"fn".return_type) |value| {
    value
} else {
    return error.NullPointer;
};
        } else if (@hasDecl(D, "value") and @TypeOf(D.value) != void) {
            return if (@typeInfo(@TypeOf(D.value)).@"fn".return_type) |value| {
    value
} else {
    return error.NullPointer;
};
        } else {
            return D;
        }
    } else {
        return D;
    }
}

// Note: I tried using a union with members that are the known types, and using
// @FieldType(KnownFieldsForLspUnion, field) but the LSP was still unable to
// figure out the type. It seems like the only way to get the LSP to know the
// type would be having dedicated `get` functions for each field, but I don't
// want to go that route.
pub fn get(comptime field: FieldEnum, cp: u21) TypeOf(field) {
    const name = @tagName(field);
    const D = DataField(name);
    const table = comptime tableFor(name);

    if (@typeInfo(D) == .@"struct" and (@hasDecl(D, "unpack") or @hasDecl(D, "unshift") or (@hasDecl(D, "value") and @TypeOf(D.value) != void))) {
        const d = @field(data(table, cp), name);
        if (@hasDecl(D, "unshift") and @TypeOf(D.unshift) != void) {
            return d.unshift(cp);
        } else if (@hasDecl(D, "unpack")) {
            return d.unpack();
        } else {
            return d.value();
        }
    } else {
        return @field(data(table, cp), name);
    }
}

pub fn TypeOf(comptime field: FieldEnum) type {
    return FieldValue(@tagName(field));
}

const std = @import("std");
const types = @import("./types.zig");
const tables = @import("tables").tables;
