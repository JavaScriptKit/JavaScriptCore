import Testing
@testable import SJavaScriptCore

@Test func evaluate() async throws {
    let context = JSContext()
    _ = try context.evaluate("40 + 2")
}

@Test func exception() async throws {
    let context = JSContext()
    #expect(throws: JSError("Can't find variable: x")) {
        try context.evaluate("x()")
    }

    #expect(throws: JSError("Unexpected end of script")) {
        try context.evaluate("{")
    }
}

@Test func function() async throws {
    let context = JSContext()
    try context.createFunction(name: "test") { (_) -> Value in
        return .string("success")
    }
    let result = try context.evaluate("test()")
    #expect(try result.toString() == "success")
}

@Test func closure() async throws {
    let context = JSContext()

    try context.createFunction(name: "testUndefined") {
        return .undefined
    }
    let undefinedResult = try context.evaluate("testUndefined()")
    #expect(undefinedResult.isUndefined)

    try context.createFunction(name: "testNull") {
        return .null
    }
    let nullResult = try context.evaluate("testNull()")
    #expect(nullResult.isNull)

    try context.createFunction(name: "testBool") {
        return .bool(true)
    }
    let boolResult = try context.evaluate("testBool()")
    #expect(boolResult.isBool)

    try context.createFunction(name: "testNumber") {
        return .number(3.14)
    }
    let numberResult = try context.evaluate("testNumber()")
    #expect(numberResult.isNumber)

    try context.createFunction(name: "testString") {
        return .string("success")
    }
    let stringResult = try context.evaluate("testString()")
    #expect(stringResult.isString)
}

@Test func capture() async throws {
    let context = JSContext()

    var captured = false
    try context.createFunction(name: "test") { (_) -> Value in
        captured = true
        return .string("captured")
    }
    let result = try context.evaluate("test()")
    #expect(captured)
    #expect("\(result)" == "captured")
}

@Test func arguments() async throws {
    let context = JSContext()
    try context.createFunction(name: "test") { (arguments) -> Void in
        #expect(arguments.count == 2)
        try #expect(arguments.first?.toString() == "one")
        try #expect(arguments.last?.toInt() == 42)
    }
    try context.evaluate("test('one', 42)")
}

@Test func `persistent context`() async throws {
    let context = JSContext()
    try context.evaluate("result = 'success'")
    #expect(try context.evaluate("result").toString() == "success")

    try context.createFunction(name: "test") { (_) -> Value in
        return .string("test ok")
    }

    #expect(try context.evaluate("result").toString() == "success")
}

@Test func sandbox() async throws {
    try {
        let context = JSContext()
        try context.evaluate("test = 'hello'")
        let result = try context.evaluate("test")
        #expect(try result.toString() == "hello")
    }()

    let context = JSContext()
    #expect(throws: JSError("Can\'t find variable: test")) {
        try context.evaluate("test")
    }
}
