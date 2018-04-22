/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

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
