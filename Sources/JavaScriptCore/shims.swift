/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import CJavaScriptCore

public func JSValueToStringCopy(
    _ ctx: JSContextRef,
    _ value: JSValueRef
) throws -> JSStringRef {
    var exception: JSValueRef? = nil
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
    var exception: JSValueRef? = nil
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
    var exception: JSValueRef? = nil
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
    static let none = JSPropertyAttributes(rawValue: UInt32(kJSPropertyAttributeNone))
    /// Specifies that a property is read-only.
    static let readOnly = JSPropertyAttributes(rawValue: UInt32(kJSPropertyAttributeNone))
    /// Specifies that a property should not be enumerated by JSPropertyEnumerators and JavaScript for...in loops.
    static let dontEnum = JSPropertyAttributes(rawValue: UInt32(kJSPropertyAttributeNone))
    /// Specifies that the delete operation should fail on a property.
    static let dontDelete = JSPropertyAttributes(rawValue: UInt32(kJSPropertyAttributeNone))
}

public func JSObjectSetProperty(
    _ ctx: JSContextRef!,
    _ object: JSObjectRef!,
    _ propertyName: JSStringRef!,
    _ value: JSValueRef!,
    _ attributes: JSPropertyAttributes
) throws {
    var exception: JSValueRef? = nil
    JSObjectSetProperty(
        ctx, object, propertyName, value, attributes.rawValue, &exception)
    if let exception = exception {
        throw JSError(context: ctx, pointer: exception)
    }
}
