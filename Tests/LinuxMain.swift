import XCTest

import JavaScriptCoreTests
import V8Tests

var tests = [XCTestCaseEntry]()
tests += JavaScriptCoreTests.__allTests()
tests += V8Tests.__allTests()

XCTMain(tests)
