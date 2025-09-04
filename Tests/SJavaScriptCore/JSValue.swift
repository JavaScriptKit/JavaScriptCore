import Testing
@testable import SJavaScriptCore

@Test func isUndefined() async throws {
    let context = JSContext()

    let result = try context.evaluate("undefined")
    #expect(result.isUndefined)
    #expect(!result.isNull)
    #expect(!result.isBool)
    #expect(!result.isNumber)
    #expect(!result.isString)
    #expect(try result.toString() == "undefined")
}

@Test func isNull() async throws {
    let context = JSContext()
    let result = try context.evaluate("null")
    #expect(!result.isUndefined)
    #expect(result.isNull)
    #expect(!result.isBool)
    #expect(!result.isNumber)
    #expect(!result.isString)
    #expect(try result.toString() == "null")
}

@Test func isBool() async throws {
    let context = JSContext()
    let result = try context.evaluate("true")
    #expect(!result.isUndefined)
    #expect(!result.isNull)
    #expect(result.isBool)
    #expect(!result.isNumber)
    #expect(!result.isString)
    #expect(try result.toString() == "true")
    #expect(result.toBool() == true)
}

@Test func isNumber() async throws {
    let context = JSContext()
    let result = try context.evaluate("3.14")
    #expect(!result.isUndefined)
    #expect(!result.isNull)
    #expect(!result.isBool)
    #expect(result.isNumber)
    #expect(!result.isString)
    #expect(try result.toString() == "3.14")
    #expect(try result.toDouble() == 3.14)
}

@Test func isString() async throws {
    let context = JSContext()
    let result = try context.evaluate("'success'")
    #expect(!result.isUndefined)
    #expect(!result.isNull)
    #expect(!result.isBool)
    #expect(!result.isNumber)
    #expect(result.isString)
    #expect(try result.toString() == "success")
}

@Test func toInt() async throws {
    let context = JSContext()
    let result = try context.evaluate("40 + 2")
    #expect(try result.toInt() == 42)
}

@Test func toString() async throws {
    let context = JSContext()
    let result = try context.evaluate("40 + 2")
    #expect(try result.toString() == "42")
}

@Test func property() async throws {
    let context = JSContext()
    let result = try context.evaluate("""
        (function(){
            return { property: 'test' }
        })()
        """)

    #expect(try result["property"]?.toString() == "test")
}
