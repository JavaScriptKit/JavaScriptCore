
import Test
@testable import SJavaScriptCore

final class JSValueTests: TestCase {
    func testIsUndefined() {
        do {
            let context = JSContext()

            let result = try context.evaluate("undefined")
            expect(result.isUndefined)
            expect(!result.isNull)
            expect(!result.isBool)
            expect(!result.isNumber)
            expect(!result.isString)
            expect(try result.toString() == "undefined")
        } catch {
            fail(String(describing: error))
        }
    }

    func testIsNull() {
        do {
            let context = JSContext()
            let result = try context.evaluate("null")
            expect(!result.isUndefined)
            expect(result.isNull)
            expect(!result.isBool)
            expect(!result.isNumber)
            expect(!result.isString)
            expect(try result.toString() == "null")
        } catch {
            fail(String(describing: error))
        }
    }

    func testIsBool() {
        do {
            let context = JSContext()
            let result = try context.evaluate("true")
            expect(!result.isUndefined)
            expect(!result.isNull)
            expect(result.isBool)
            expect(!result.isNumber)
            expect(!result.isString)
            expect(try result.toString() == "true")
            expect(result.toBool() == true)
        } catch {
            fail(String(describing: error))
        }
    }

    func testIsNumber() {
        do {
            let context = JSContext()
            let result = try context.evaluate("3.14")
            expect(!result.isUndefined)
            expect(!result.isNull)
            expect(!result.isBool)
            expect(result.isNumber)
            expect(!result.isString)
            expect(try result.toString() == "3.14")
            expect(try result.toDouble() == 3.14)
        } catch {
            fail(String(describing: error))
        }
    }

    func testIsString() {
        do {
            let context = JSContext()
            let result = try context.evaluate("'success'")
            expect(!result.isUndefined)
            expect(!result.isNull)
            expect(!result.isBool)
            expect(!result.isNumber)
            expect(result.isString)
            expect(try result.toString() == "success")
        } catch {
            fail(String(describing: error))
        }
    }

    func testToInt() {
        do {
            let context = JSContext()
            let result = try context.evaluate("40 + 2")
            expect(try result.toInt() == 42)
        } catch {
            fail(String(describing: error))
        }
    }

    func testToString() {
        do {
            let context = JSContext()
            let result = try context.evaluate("40 + 2")
            expect(try result.toString() == "42")
        } catch {
            fail(String(describing: error))
        }
    }

    func testProperty() {
        do {
            let context = JSContext()
            let result = try context.evaluate("""
                (function(){
                    return { property: 'test' }
                })()
                """)

            expect(try result["property"]?.toString() == "test")
        } catch {
            fail(String(describing: error))
        }
    }
}
