import Test
@testable import SJavaScriptCore

test.case("isUndefined") {
    let context = JSContext()

    let result = try context.evaluate("undefined")
    expect(result.isUndefined)
    expect(!result.isNull)
    expect(!result.isBool)
    expect(!result.isNumber)
    expect(!result.isString)
    expect(try result.toString() == "undefined")
}

test.case("isNull") {
    let context = JSContext()
    let result = try context.evaluate("null")
    expect(!result.isUndefined)
    expect(result.isNull)
    expect(!result.isBool)
    expect(!result.isNumber)
    expect(!result.isString)
    expect(try result.toString() == "null")
}

test.case("isBool") {
    let context = JSContext()
    let result = try context.evaluate("true")
    expect(!result.isUndefined)
    expect(!result.isNull)
    expect(result.isBool)
    expect(!result.isNumber)
    expect(!result.isString)
    expect(try result.toString() == "true")
    expect(result.toBool() == true)
}

test.case("isNumber") {
    let context = JSContext()
    let result = try context.evaluate("3.14")
    expect(!result.isUndefined)
    expect(!result.isNull)
    expect(!result.isBool)
    expect(result.isNumber)
    expect(!result.isString)
    expect(try result.toString() == "3.14")
    expect(try result.toDouble() == 3.14)
}

test.case("isString") {
    let context = JSContext()
    let result = try context.evaluate("'success'")
    expect(!result.isUndefined)
    expect(!result.isNull)
    expect(!result.isBool)
    expect(!result.isNumber)
    expect(result.isString)
    expect(try result.toString() == "success")
}

test.case("toInt()") {
    let context = JSContext()
    let result = try context.evaluate("40 + 2")
    expect(try result.toInt() == 42)
}

test.case("toString()") {
    let context = JSContext()
    let result = try context.evaluate("40 + 2")
    expect(try result.toString() == "42")
}

test.case("property") {
    let context = JSContext()
    let result = try context.evaluate("""
        (function(){
            return { property: 'test' }
        })()
        """)

    expect(try result["property"]?.toString() == "test")
}

test.run()
