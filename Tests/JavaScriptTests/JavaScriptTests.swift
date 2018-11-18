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

import Test
@testable import JavaScriptCoreSwift

final class JavaScriptCoreSwiftTests: TestCase {
    func testEvaluate() {
        let context = JSContext()
        assertNoThrow(try context.evaluate("40 + 2"))
    }

    func testException() {
        let context = JSContext()
        assertThrowsError(try context.evaluate("x()")) { error in
            assertEqual("\(error)", "Can't find variable: x")
        }

        assertThrowsError(try context.evaluate("{")) { error in
            assertEqual("\(error)", "Unexpected end of script")
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

    func testPersistentContext() {
        do {
            let context = JSContext()
            try context.evaluate("result = 'success'")
            assertEqual(try context.evaluate("result").toString(), "success")

            try context.createFunction(name: "test") { (arguments) -> Value in
                return .string("test ok")
            }

            assertEqual(try context.evaluate("result").toString(), "success")
        } catch {
            fail(String(describing: error))
        }
    }

    func testSandbox() {
        do {
            let context = JSContext()
            try context.evaluate("test = 'hello'")
            let result = try context.evaluate("test")
            assertEqual(try result.toString(), "hello")
        } catch {
            fail(String(describing: error))
            return
        }

        let context = JSContext()
        assertThrowsError(try context.evaluate("test"))
    }
}
