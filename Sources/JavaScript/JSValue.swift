/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

#if os(Linux)
import CJavaScriptCore
#else
import JavaScriptCore
#endif

public class JSValue {
    let context: JSContextRef
    let pointer: JSValueRef

    init(context: JSContextRef, pointer: JSValueRef) {
        self.context = context
        self.pointer = pointer
    }

    init(undefinedIn context: JSContextRef) {
        self.context = context
        self.pointer = JSValueMakeUndefined(context)
    }

    init(bool: Bool, in context: JSContextRef) {
        self.context = context
        self.pointer = JSValueMakeBoolean(context, bool)
    }

    init(number: Double, in context: JSContextRef) {
        self.context = context
        self.pointer = JSValueMakeNumber(context, number)
    }

    init(string: String, in context: JSContextRef) {
        self.context = context
        let bytes = [UInt16](string.utf16)
        let stringRef = JSStringCreateWithCharacters(bytes, bytes.count)
        self.pointer = JSValueMakeString(context, stringRef)
    }
}

extension JSValue {
    convenience
    public init(undefinedIn context: JSContext) {
        self.init(undefinedIn: context.context)
    }

    convenience
    public init(bool: Bool, in context: JSContext) {
        self.init(bool: bool, in: context.context)
    }

    convenience
    public init(number: Double, in context: JSContext) {
        self.init(number: number, in: context.context)
    }

    convenience
    public init(string: String, in context: JSContext) {
        self.init(string: string, in: context.context)
    }
}

extension JSValue {
    public var isNull: Bool {
        return JSValueIsNull(context, pointer)
    }

    public var isUndefined: Bool {
        return JSValueIsUndefined(context, pointer)
    }

    public var isBool: Bool {
        return JSValueIsBoolean(context, pointer)
    }

    public var isNumber: Bool {
        return JSValueIsNumber(context, pointer)
    }

    public var isString: Bool {
        return JSValueIsString(context, pointer)
    }
}

extension JSValue {
    public func toBool() -> Bool {
        return JSValueToBoolean(context, pointer)
    }

    public func toDouble() throws -> Double {
        return try JSValueToNumber(context, pointer)
    }

    public func toInt() throws -> Int {
        return Int(try JSValueToNumber(context, pointer))
    }

    public func toString() throws -> String {
        let stringRef = try JSValueToStringCopy(context, pointer)
        defer { JSStringRelease(stringRef) }
        let len = JSStringGetLength(stringRef)
        let characters = JSStringGetCharactersPtr(stringRef)
        let buffer = UnsafeBufferPointer<UInt16>(start: characters!, count: len)
        return String(decoding: buffer, as: UTF16.self)
    }
}

extension Array where Element == JSValue {
    init(
        start: UnsafePointer<JSValueRef?>?,
        count: Int,
        in context: JSObjectRef
    ) {
        var arguments = [JSValue]()
        for i in 0..<count {
            let valueRef = start!.advanced(by: i).pointee!
            arguments.append(JSValue(context: context, pointer: valueRef))
        }
        self = arguments
    }
}

extension JSValue: CustomStringConvertible {
    public var description: String {
        do {
            return try toString()
        } catch {
            return "unknown"
        }
    }
}
