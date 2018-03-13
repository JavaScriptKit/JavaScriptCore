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

public class JSRuntime {
    let platform: UnsafeMutableRawPointer
    let isolate: UnsafeMutableRawPointer

    public static var global: JSRuntime = {
        return JSRuntime()
    }()

    public required init() {
        self.platform = initialize()
        self.isolate = createIsolate()
        CV8.swiftCallback = functionWrapper
    }

    deinit {
        disposeIsolate(isolate)
        dispose(platform)
    }
}

extension JSRuntime: JavaScript.JSRuntime {
    public func createContext() -> JSContext {
        return JSContext(self)
    }
}
