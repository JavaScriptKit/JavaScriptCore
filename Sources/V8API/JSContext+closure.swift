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
            id = Int32(bitPattern: arc4random())
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
