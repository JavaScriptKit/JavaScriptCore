import XCTest

extension JSValueTests {
    static let __allTests = [
        ("testIsBool", testIsBool),
        ("testIsNull", testIsNull),
        ("testIsNumber", testIsNumber),
        ("testIsString", testIsString),
        ("testIsUndefined", testIsUndefined),
        ("testToInt", testToInt),
        ("testToString", testToString),
    ]
}

extension V8Tests {
    static let __allTests = [
        ("testArguments", testArguments),
        ("testCapture", testCapture),
        ("testClosure", testClosure),
        ("testEvaluate", testEvaluate),
        ("testException", testException),
        ("testFunction", testFunction),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(JSValueTests.__allTests),
        testCase(V8Tests.__allTests),
    ]
}
#endif
