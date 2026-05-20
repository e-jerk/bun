/// Opaque type for working with JavaScript `Map` objects.
pub const JSMap = opaque {
    pub fn create(globalObject: *JSGlobalObject) JSValue {
        return bun.cpp.JSC__JSMap__create(globalObject);
    }

    pub fn set(this: *JSMap, globalObject: *JSGlobalObject, key: JSValue, value: JSValue) bun.JSError!void {
        return bun.cpp.JSC__JSMap__set(this, globalObject, key, value);
    }

    /// Retrieve a value from this JS Map object.
    ///
    /// Note this shares semantics with the JS `Map.prototype.get` method, and
    /// will return .js_undefined if a value is not found.
    pub fn get(this: *JSMap, globalObject: *JSGlobalObject, key: JSValue) bun.JSError!JSValue {
        return bun.cpp.JSC__JSMap__get(this, globalObject, key);
    }

    /// Test whether this JS Map object has a given key.
    pub fn has(this: *JSMap, globalObject: *JSGlobalObject, key: JSValue) bun.JSError!bool {
        return bun.cpp.JSC__JSMap__has(this, globalObject, key);
    }

    /// Attempt to remove a key from this JS Map object.
    pub fn remove(this: *JSMap, globalObject: *JSGlobalObject, key: JSValue) bun.JSError!bool {
        return bun.cpp.JSC__JSMap__remove(this, globalObject, key);
    }

    /// Clear all entries from this JS Map object.
    pub fn clear(this: *JSMap, globalObject: *JSGlobalObject) bun.JSError!void {
        return bun.cpp.JSC__JSMap__clear(this, globalObject);
    }

    /// Retrieve the number of entries in this JS Map object.
    pub fn size(this: *JSMap, globalObject: *JSGlobalObject) bun.JSError!u32 {
        return bun.cpp.JSC__JSMap__size(this, globalObject);
    }

    /// Attempt to convert a `JSValue` to a `*JSMap`.
    ///
    /// Returns `null` if the value is not a Map.
    pub fn fromJS(value: JSValue) ?*JSMap {
        if (value.jsTypeLoose() == .Map) {
            return bun.cast(*JSMap, if (value.asEncoded().asPtr) |value| {
    value
} else {
    return error.NullPointer;
});
        }

        return null;
    }
};

const bun = @import("bun");

const jsc = bun.jsc;
const JSValue = jsc.JSValue;
const JSGlobalObject = jsc.JSGlobalObject;
