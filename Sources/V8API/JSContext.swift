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

import CV8
import JavaScript

public class JSContext {
    let isolate: UnsafeMutableRawPointer
    let context: UnsafeMutableRawPointer
    var template: UnsafeMutableRawPointer

    let unowned: Bool

    public init(
        isolate: UnsafeMutableRawPointer,
        context: UnsafeMutableRawPointer,
        template: UnsafeMutableRawPointer)
    {
        self.unowned = true
        self.isolate = isolate
        self.context = context
        self.template = template
    }

    public init(isolate: UnsafeMutableRawPointer) {
        self.unowned = false
        self.isolate = isolate
        self.template = CV8.createTemplate(isolate)
        self.context = CV8.createContext(isolate, template)
    }

    deinit {
        if !unowned {
            CV8.disposeTemplate(template)
            CV8.disposeContext(context)
        }
    }
}

struct JSError: Error, CustomStringConvertible {
    let description: String
}

extension JSContext: JavaScript.JSContext {
    @discardableResult
    public func evaluate(_ script: String) throws -> JSValue {
        var exception: UnsafeMutableRawPointer?
        guard let pointer = CV8.evaluate(isolate, context, script, &exception) else {
            guard let exception = exception else {
                fatalError("exception pointer is nil")
            }
            let value = JSValue(isolate: isolate, pointer: exception)
            throw JSError(description: value.description)
        }
        return JSValue(isolate: isolate, pointer: pointer)
    }
}
