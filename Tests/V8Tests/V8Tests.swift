/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Test
@testable import V8

final class V8Tests: TestCase {
    func testEvaluate() {
        let context = JSContext()
        assertNoThrow(try context.evaluate("40 + 2"))
    }

    func testException() {
        let context = JSContext()
        assertThrowsError(try context.evaluate("x()")) { error in
            assertEqual("\(error)", "ReferenceError: x is not defined")
        }
    }

    func testFunction() {
        do {
            let context = JSContext()
            try context.createFunction(name: "test") { (_) -> Value in
                return .string("success")
            }
            let result = try context.evaluate("test()")
            assertEqual(try result.toString(), "success")
        } catch {
            fail(String(describing: error))
        }
    }

    func testClosure() {
        do {
            let context = JSContext()

            try context.createFunction(name: "testUndefined") {
                return .undefined
            }
            let undefinedResult = try context.evaluate("testUndefined()")
            assertTrue(undefinedResult.isUndefined)

            try context.createFunction(name: "testNull") {
                return .null
            }
            let nullResult = try context.evaluate("testNull()")
            assertTrue(nullResult.isNull)

            try context.createFunction(name: "testBool") {
                return .bool(true)
            }
            let boolResult = try context.evaluate("testBool()")
            assertTrue(boolResult.isBool)

            try context.createFunction(name: "testNumber") {
                return .number(3.14)
            }
            let numberResult = try context.evaluate("testNumber()")
            assertTrue(numberResult.isNumber)

            try context.createFunction(name: "testString") {
                return .string("success")
            }
            let stringResult = try context.evaluate("testString()")
            assertTrue(stringResult.isString)
        } catch {
            fail(String(describing: error))
        }
    }

    func testCapture() {
        do {
            let context = JSContext()

            var captured = false
            try context.createFunction(name: "test") { (_) -> Value in
                captured = true
                return .string("captured")
            }
            let result = try context.evaluate("test()")
            assertTrue(captured)
            assertEqual("\(result)", "captured")
        } catch {
            fail(String(describing: error))
        }
    }

    func testArguments() {
        do {
            let context = JSContext()
            try context.createFunction(name: "test") { (arguments) -> Void in
                assertEqual(arguments.count, 2)
                assertEqual(try arguments.first?.toString(), "one")
                assertEqual(try arguments.last?.toInt(), 42)
            }
            try context.evaluate("test('one', 42)")
        } catch {
            fail(String(describing: error))
        }
    }
}
