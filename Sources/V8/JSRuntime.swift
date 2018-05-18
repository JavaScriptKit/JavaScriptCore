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
import Platform

@_exported import V8API

public class JSRuntime {
    let platform: UnsafeMutableRawPointer
    let isolate: UnsafeMutableRawPointer

    public static var global: JSRuntime = {
        return JSRuntime()
    }()

    // The whole V8API & V8 split is caused
    // by difference in the initialization
    // between standalone v8 and node.js,
    // so this way we can reuse the api
    public required init() {
        // used to load snapshot_blob, natives_blob, icudtl.dat
        let libsPath = Environment["NODE_PATH"] ?? "/usr/local/lib/"
        self.platform = initialize(libsPath)
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
