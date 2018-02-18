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
import struct Foundation.URL

public class JSContext {
    let group: JSContextGroupRef
    let context: JSGlobalContextRef
    var exception: JSObjectRef? = nil

    var global: JSObjectRef {
        return JSContextGetGlobalObject(context)!
    }

    public init() {
        guard let group = JSContextGroupCreate(),
            let context = JSGlobalContextCreateInGroup(group, nil) else {
                fatalError("can't create context")
        }

        self.group = group
        self.context = context
    }

    deinit {
        JSGlobalContextRelease(context)
        JSContextGroupRelease(group)
    }

    @discardableResult
    public func evaluate(
        _ script: String,
        source: String? = nil
    ) throws -> JSValue {
        let file = JSStringCreateWithUTF8CString(source)
        let script = JSStringCreateWithUTF8CString(script)
        defer {
            JSStringRelease(file)
            JSStringRelease(script)
        }
        let result = try JSEvaluateScript(context, script, global, file, 0)
        return JSValue(context: context, pointer: result)
    }

    @discardableResult
    public func createFunction(
        name: String,
        callback: @escaping JSObjectCallAsFunctionCallback
    ) throws -> JSObjectRef {
        let name = JSStringCreateWithUTF8CString(name)
        defer { JSStringRelease(name) }
        let function = JSObjectMakeFunctionWithCallback(context, name, callback)
        try JSObjectSetProperty(context, global, name, function, .none)
        return function!
    }
}

// MARK: register swift closure as javascript function

public enum ReturnValue {
    case undefined
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
}

var functions: [OpaquePointer: [OpaquePointer: () throws -> ReturnValue]] = [:]

extension JSContext {
    public func createFunction(
        name: String,
        _ body: @escaping () throws -> ReturnValue
    ) throws {
        let function = try createFunction(name: name, callback: wrapper)
        functions[global, default: [:]][function] = body
    }
}

func wrapper(
    ctx: JSContextRef!,
    function: JSObjectRef!,
    thisObject: JSObjectRef!,
    argumentCount: Int,
    arguments: UnsafePointer<JSValueRef?>?,
    exception: UnsafeMutablePointer<JSValueRef?>?
) -> JSValueRef? {
    guard let body = functions[thisObject]?[function] else {
        if let exception = exception {
            let error = "swift error: unregistered function"
            exception.pointee = JSValue(string: error, in: thisObject).pointer
        }
        return nil
    }
    do {
        let result = try body()
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
