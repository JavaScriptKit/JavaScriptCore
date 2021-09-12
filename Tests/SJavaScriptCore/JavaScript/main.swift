import Test
@testable import SJavaScriptCore

test.case("evaluate") {
    let context = JSContext()
    _ = try context.evaluate("40 + 2")
}

test.case("exception") {
    let context = JSContext()
    expect(throws: JSError("Can't find variable: x")) {
        try context.evaluate("x()")
    }

    expect(throws: JSError("Unexpected end of script")) {
        try context.evaluate("{")
    }
}

test.case("function") {
    let context = JSContext()
    try context.createFunction(name: "test") { (_) -> Value in
        return .string("success")
    }
    let result = try context.evaluate("test()")
    expect(try result.toString() == "success")
}

test.case("closure") {
    let context = JSContext()

    try context.createFunction(name: "testUndefined") {
        return .undefined
    }
    let undefinedResult = try context.evaluate("testUndefined()")
    expect(undefinedResult.isUndefined)

    try context.createFunction(name: "testNull") {
        return .null
    }
    let nullResult = try context.evaluate("testNull()")
    expect(nullResult.isNull)

    try context.createFunction(name: "testBool") {
        return .bool(true)
    }
    let boolResult = try context.evaluate("testBool()")
    expect(boolResult.isBool)

    try context.createFunction(name: "testNumber") {
        return .number(3.14)
    }
    let numberResult = try context.evaluate("testNumber()")
    expect(numberResult.isNumber)

    try context.createFunction(name: "testString") {
        return .string("success")
    }
    let stringResult = try context.evaluate("testString()")
    expect(stringResult.isString)
}

test.case("capture") {
    let context = JSContext()

    var captured = false
    try context.createFunction(name: "test") { (_) -> Value in
        captured = true
        return .string("captured")
    }
    let result = try context.evaluate("test()")
    expect(captured)
    expect("\(result)" == "captured")
}

test.case("arguments") {
    let context = JSContext()
    try context.createFunction(name: "test") { (arguments) -> Void in
        expect(arguments.count == 2)
        expect(try arguments.first?.toString() == "one")
        expect(try arguments.last?.toInt() == 42)
    }
    try context.evaluate("test('one', 42)")
}

test.case("persistent context") {
    let context = JSContext()
    try context.evaluate("result = 'success'")
    expect(try context.evaluate("result").toString() == "success")

    try context.createFunction(name: "test") { (arguments) -> Value in
        return .string("test ok")
    }

    expect(try context.evaluate("result").toString() == "success")
}

test.case("sandbox") {
    try {
        let context = JSContext()
        try context.evaluate("test = 'hello'")
        let result = try context.evaluate("test")
        expect(try result.toString() == "hello")
    }()

    let context = JSContext()
    expect(throws: JSError("Can\'t find variable: test")) {
        try context.evaluate("test")
    }
}

test.run()
