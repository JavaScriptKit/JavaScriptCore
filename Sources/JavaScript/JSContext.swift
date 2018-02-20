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
