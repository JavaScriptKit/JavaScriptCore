/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import CV8
import JavaScript

public class JSContext {
    let runtime: JSRuntime
    let context: UnsafeMutableRawPointer?

    public init(_ runtime: JSRuntime = JSRuntime.global) {
        self.runtime = runtime
        self.context = CV8.createContext(runtime.isolate)
    }

    deinit {
        CV8.disposeContext(context)
    }
}

struct JSError: Error, CustomStringConvertible {
    let description: String
}

extension JSContext: JavaScript.JSContext {
    public func evaluate(_ script: String) throws -> JSValue {
        var exception: UnsafeMutableRawPointer?
        guard let pointer = CV8.evaluate(runtime.isolate, context, script, &exception) else {
            guard let exception = exception else {
                fatalError("exception pointer is nil")
            }
            let value = JSValue(pointer: exception, isolate: runtime.isolate)
            throw JSError(description: value.description)
        }
        return JSValue(pointer: pointer, isolate: runtime.isolate)
    }
}
