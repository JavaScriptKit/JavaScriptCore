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
@testable import V8

final class V8Tests: TestCase {
    func testEvaluate() {
        let context = JSContext()
        assertNoThrow(try context.evaluate("40 + 2"))
    }

    func testException() {
        let context = JSContext()
        assertThrowsError(try context.evaluate("x()")) { error in
            assertEqual("\(error)", "ReferenceError: x is not defined")
        }
    }
}
