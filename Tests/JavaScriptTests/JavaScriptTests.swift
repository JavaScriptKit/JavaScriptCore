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
@testable import JavaScript

final class JavaScriptCoreTests: TestCase {
    func testEvaluate() {
        let context = JSContext()
        assertNoThrow(try context.evaluate("40 + 2"))
    }

    func testException() {
        let context = JSContext()
        assertThrowsError(try context.evaluate("x()")) { error in
            assertEqual("\(error)", "ReferenceError: Can't find variable: x")
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


            var captured = false
            try context.createFunction(name: "testUndefined") {
                captured = true
                return .undefined
            }
            let undefinedResult = try context.evaluate("testUndefined()")
            assertTrue(captured)
            assertTrue(undefinedResult.isUndefined)
            assertFalse(undefinedResult.isNull)
            assertFalse(undefinedResult.isBool)
            assertFalse(undefinedResult.isNumber)
            assertFalse(undefinedResult.isString)
            assertEqual(try undefinedResult.toString(), "undefined")


            try context.createFunction(name: "testNull") {
                return .null
            }
            let nullResult = try context.evaluate("testNull()")
            assertFalse(nullResult.isUndefined)
            assertTrue(nullResult.isNull)
            assertFalse(nullResult.isBool)
            assertFalse(nullResult.isNumber)
            assertFalse(nullResult.isString)
            assertEqual(try nullResult.toString(), "null")


            try context.createFunction(name: "testBool") {
                return .bool(true)
            }
            let boolResult = try context.evaluate("testBool()")
            assertFalse(boolResult.isUndefined)
            assertFalse(boolResult.isNull)
            assertTrue(boolResult.isBool)
            assertFalse(boolResult.isNumber)
            assertFalse(boolResult.isString)
            assertEqual(boolResult.toBool(), true)

            try context.createFunction(name: "testNumber") {
                return .number(3.14)
            }
            let numberResult = try context.evaluate("testNumber()")
            assertFalse(numberResult.isUndefined)
            assertFalse(numberResult.isNull)
            assertFalse(numberResult.isBool)
            assertTrue(numberResult.isNumber)
            assertFalse(numberResult.isString)
            assertEqual(try numberResult.toDouble(), 3.14)

            try context.createFunction(name: "testString") {
                return .string("success")
            }
            let stringResult = try context.evaluate("testString()")
            assertFalse(stringResult.isUndefined)
            assertFalse(stringResult.isNull)
            assertFalse(stringResult.isBool)
            assertFalse(stringResult.isNumber)
            assertTrue(stringResult.isString)
            assertEqual(try stringResult.toString(), "success")
        } catch {
            fail(String(describing: error))
        }
    }
}
