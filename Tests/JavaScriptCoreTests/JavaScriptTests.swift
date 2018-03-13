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
@testable import JavaScriptCoreSwift

final class JavaScriptCoreTests: TestCase {
    func testEvaluate() {
        let context = JSContext()
        assertNoThrow(try context.evaluate("40 + 2"))
    }

    func testException() {
        let context = JSContext()
        assertThrowsError(try context.evaluate("x()")) { error in
            assertEqual("\(error)", "Can't find variable: x")
        }
    }

    func testFunction() {
        do {
            let context = JSContext()
            try context.createFunction(name: "test") { ctx, _, _, _, _, _ in
                return JSValue(string: "success", in: ctx!).pointer
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
            try context.createFunction(name: "testCapture")
            { (_) -> Value in
                captured = true
                return .string("captured")
            }
            let result = try context.evaluate("testCapture()")
            assertTrue(captured)
            assertEqual("\(result)", "captured")
        } catch {
            fail(String(describing: error))
        }
    }

    func testArguments() {
        do {
            let context = JSContext()

            var result = [String]()
            try context.createFunction(name: "testArguments") { arguments in
                result = try arguments.map(String.init)
            }
            try context.evaluate("testArguments('one', 'two')")
            assertEqual(result, ["one", "two"])
        } catch {
            fail(String(describing: error))
        }
    }
}
