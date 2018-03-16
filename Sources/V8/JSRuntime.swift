/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import CV8Platform
import JavaScript

@_exported import V8API

public class JSRuntime {
    let platform: UnsafeMutableRawPointer
    let isolate: UnsafeMutableRawPointer

    public static var global: JSRuntime = {
        return JSRuntime()
    }()

    public required init() {
        // The whole V8API & V8 split is caused
        // by difference in this initialization
        // between standalone v8 and node.js
        self.platform = initialize()
        self.isolate = createIsolate()
    }

    deinit {
        disposeIsolate(isolate)
        dispose(platform)
    }
}

extension V8API.JSContext {
    public convenience init(_ runtime: JSRuntime = JSRuntime.global) {
        self.init(isolate: runtime.isolate)
    }
}

extension JSRuntime: JavaScript.JSRuntime {
    public func createContext() -> V8API.JSContext {
        return JSContext()
    }
}
