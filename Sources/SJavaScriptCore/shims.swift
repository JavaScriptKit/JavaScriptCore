#if os(Linux)
import CJavaScriptCore
#else
import JavaScriptCore
#endif

public func JSValueToStringCopy(
    _ ctx: JSContextRef,
    _ value: JSValueRef
) throws -> JSStringRef {
    var exception: JSValueRef?
    let result = JSValueToStringCopy(ctx, value, &exception)
    if let exception = exception {
        throw JSError(context: ctx, pointer: exception)
    }
    return result!
}

public func JSValueToNumber(
    _ ctx: JSContextRef,
    _ value: JSValueRef
) throws -> Double {
    var exception: JSValueRef?
    let result = JSValueToNumber(ctx, value, &exception)
    if let exception = exception {
        throw JSError(context: ctx, pointer: exception)
    }
    return result
}

@discardableResult
public func JSEvaluateScript(
    _ ctx: JSContextRef!,
    _ script: JSStringRef!,
    _ thisObject: JSObjectRef!,
    _ sourceURL: JSStringRef!,
    _ startingLineNumber: Int32
) throws -> JSValueRef {
    var exception: JSValueRef?
    let result = JSEvaluateScript(
        ctx, script, thisObject, sourceURL, startingLineNumber, &exception)
    if let exception = exception {
        // FIXME: Exited with signal code 11
        throw JSError(context: ctx, pointer: exception)
    }
    return result!
}

public struct JSPropertyAttributes: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    /// Specifies that a property has no special attributes.
    static let none = JSPropertyAttributes(
        rawValue: UInt32(kJSPropertyAttributeNone))
    /// Specifies that a property is read-only.
    static let readOnly = JSPropertyAttributes(
        rawValue: UInt32(kJSPropertyAttributeNone))
    /// Specifies that a property should not be enumerated by
    /// JSPropertyEnumerators and JavaScript for...in loops.
    static let dontEnum = JSPropertyAttributes(
        rawValue: UInt32(kJSPropertyAttributeNone))
    /// Specifies that the delete operation should fail on a property.
    static let dontDelete = JSPropertyAttributes(
        rawValue: UInt32(kJSPropertyAttributeNone))
}

public func JSObjectSetProperty(
    _ ctx: JSContextRef!,
    _ object: JSObjectRef!,
    _ propertyName: JSStringRef!,
    _ value: JSValueRef!,
    _ attributes: JSPropertyAttributes
) throws {
    var exception: JSValueRef?
    JSObjectSetProperty(
        ctx, object, propertyName, value, attributes.rawValue, &exception)
    if let exception = exception {
        throw JSError(context: ctx, pointer: exception)
    }
}
