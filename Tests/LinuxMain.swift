import XCTest

import JavaScriptTests

var tests = [XCTestCaseEntry]()
tests += JavaScriptTests.__allTests()

XCTMain(tests)
