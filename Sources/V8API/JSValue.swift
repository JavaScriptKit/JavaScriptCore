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

public class JSValue {
    let isolate: UnsafeMutableRawPointer
    let pointer: UnsafeMutableRawPointer

    init(isolate: UnsafeMutableRawPointer, pointer: UnsafeMutableRawPointer) {
        self.isolate = isolate
        self.pointer = pointer
    }

    deinit {
        CV8.disposeValue(pointer)
    }
}

extension JSValue: JavaScript.JSValue {
    public var isNull: Bool {
        return CV8.isNull(isolate, pointer)
    }

    public var isUndefined: Bool {
        return CV8.isUndefined(isolate, pointer)
    }

    public var isBool: Bool {
        return CV8.isBoolean(isolate, pointer)
    }

    public var isNumber: Bool {
        return CV8.isNumber(isolate, pointer)
    }

    public var isString: Bool {
        return CV8.isString(isolate, pointer)
    }

    public var isObject: Bool {
        return CV8.isObject(isolate, pointer)
    }

    public func toInt() throws -> Int {
        return Int(CV8.valueToInt(isolate, pointer))
    }

    public func toString() throws -> String {
        let count = CV8.getUtf8StringLength(isolate, pointer)
        var buffer = [UInt8](repeating: 0, count: Int(count))
        CV8.copyUtf8String(isolate, pointer, &buffer, count)
        return String(decoding: buffer, as: UTF8.self)
    }
}

extension JSValue {
    public subscript(_ key: String) -> JSValue? {
        guard isObject else {
            return nil
        }
        guard let result = getProperty(isolate, pointer, key, nil) else {
            return nil
        }
        return JSValue(isolate: isolate, pointer: result)
    }
}

extension JSValue: CustomStringConvertible {
    public var description: String {
        return try! toString()
    }
}
