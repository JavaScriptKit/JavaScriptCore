/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public protocol JSEngine {
    associatedtype JSRuntime: JavaScript.JSRuntime
    static func createRuntime() throws -> JSRuntime
}

public protocol JSRuntime {
    associatedtype JSContext: JavaScript.JSContext
    func createContext() -> JSContext
}

public protocol JSContext {
    associatedtype JSValue: JavaScript.JSValue
    func evaluate(_ script: String) throws -> JSValue

//    func createValue(string: String) -> JSValue
//    func createValue(number: Int) -> JSValue
//    func createValue(number: Double) -> JSValue

//    func createFunction()
}

public protocol JSValue {
    func toString() throws -> String

    var isNull: Bool { get }
    var isUndefined: Bool { get }
    var isBool: Bool { get }
    var isNumber: Bool { get }
    var isString: Bool { get }
    var isObject: Bool { get }
}

public enum Value {
    case undefined
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
}
