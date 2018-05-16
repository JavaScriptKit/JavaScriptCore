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
import Platform
@_exported import JavaScript

private var swiftCallback: Void = {
    CV8.swiftCallback = V8API.functionWrapper
}()

private var functions: [Int32: ([JSValue]) throws -> Value] = [:]

extension JSContext {
    func generateId() -> Int32 {
        var id: Int32 = 0
        repeat {
            id = Int32.random(in: 0...Int32.max)
        } while functions[id] != nil
        return id
    }

    public func createFunction(
        name: String,
        _ body: @escaping ([JSValue]) throws -> Value) throws
    {
        _ = swiftCallback
        let id = generateId()
        CV8.createFunction(isolate, context, name, id)
        functions[id] = body
    }

    public func createFunction(
        name: String,
        _ body: @escaping ([JSValue]) throws -> Void) throws
    {
        try createFunction(name: name) { arguments -> Value in
            try body(arguments)
            return .undefined
        }
    }

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

extension Array where Element == JSValue {
    init(
        isolate: UnsafeMutableRawPointer,
        pointer: UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
        count: Int
    ) {
        var arguments = [JSValue]()
        for i in 0..<count {
            let next = pointer!.advanced(by: i).pointee!
            arguments.append(JSValue(isolate: isolate, pointer: next))
        }
        self = arguments
    }
}

func functionWrapper(
    isolate: UnsafeMutableRawPointer,
    functionId: Int32,
    arguments: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
    argumentsCount: Int32,
    returnValue: UnsafeMutableRawPointer)
{
    guard let body = functions[functionId] else {
        fatalError("swift error: unregistered function")
    }
    do {
        let arguments = [JSValue](
            isolate: isolate,
            pointer: arguments,
            count: Int(argumentsCount))
        let result = try body(arguments)
        switch result {
        case .undefined: setReturnValueUndefined(isolate, returnValue)
        case .null: setReturnValueNull(isolate, returnValue)
        case .bool(let value): setReturnValueBoolean(isolate, returnValue, value)
        case .number(let value): setReturnValueNumber(isolate, returnValue, value)
        case .string(let value) where value.isEmpty: setReturnValueEmptyString(isolate, returnValue)
        case .string(let value): setReturnValueString(isolate, returnValue, value)
        }
    } catch {
        fatalError("\(error)")
    }
}
