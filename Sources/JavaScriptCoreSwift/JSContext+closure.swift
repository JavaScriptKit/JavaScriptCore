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

#if os(Linux)
import CJavaScriptCore
#else
import JavaScriptCore
#endif

@_exported import JavaScript

private var functions: [OpaquePointer: ([JSValue]) throws -> Value] = [:]

extension JSContext {
    public func createFunction(
        name: String,
        _ body: @escaping ([JSValue]) throws -> Value) throws
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
        _ body: @escaping () throws -> Value) throws
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
