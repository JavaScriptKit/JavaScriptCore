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

public enum ReturnValue {
    case undefined
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
}

private var functions: [OpaquePointer: ([JSValue]) throws -> ReturnValue] = [:]

extension JSContext {
    public func createFunction(
        name: String,
        _ body: @escaping ([JSValue]) throws -> ReturnValue) throws
    {
        let function = try createFunction(name: name, callback: wrapper)
        functions[function] = body
    }

    public func createFunction(
        name: String,
        _ body: @escaping ([JSValue]) throws -> Void) throws
    {
        let function = try createFunction(name: name, callback: wrapper)
        functions[function] = { arguments in
            try body(arguments)
            return .undefined
        }
    }
}

extension JSContext {
    public func createFunction(
        name: String,
        _ body: @escaping () throws -> ReturnValue) throws
    {
        return try createFunction(name: name) { _ in
            return try body()
        }
    }

    public func createFunction(
        name: String,
        _ body: @escaping () throws -> Void) throws
    {
        try createFunction(name: name) { _ in
            try body()
        }
    }
}

func wrapper(
    ctx: JSContextRef!,
    function: JSObjectRef!,
    thisObject: JSObjectRef!,
    argumentCount: Int,
    arguments: UnsafePointer<JSValueRef?>?,
    exception: UnsafeMutablePointer<JSValueRef?>?) -> JSValueRef?
{
    guard let body = functions[function] else {
        if let exception = exception {
            let error = "swift error: unregistered function"
            exception.pointee = JSValue(string: error, in: ctx).pointer
        }
        return nil
    }
    do {
        let arguments = [JSValue](
            start: arguments,
            count: argumentCount,
            in: ctx)
        let result = try body(arguments)
        switch result {
        case .undefined: return JSValueMakeUndefined(ctx)
        case .null: return JSValueMakeNull(ctx)
        case .bool(let value): return JSValueMakeBoolean(ctx, value)
        case .number(let value): return JSValueMakeNumber(ctx, value)
        case .string(let value): return JSValue(string: value, in: ctx).pointer
        }
    } catch {
        if let exception = exception {
            exception.pointee = JSValue(string: "\(error)", in: ctx).pointer
        }
        return nil
    }
}
