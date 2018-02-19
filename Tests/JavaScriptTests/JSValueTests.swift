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
@testable import JavaScript

final class JSValueTests: TestCase {
    func testToInt() {
        do {
            let context = JSContext()
            let result = try context.evaluate("40 + 2")
            assertEqual(try result.toInt(), 42)
        } catch {
            fail(String(describing: error))
        }
    }

    func testToString() {
        do {
            let context = JSContext()
            let result = try context.evaluate("40 + 2")
            assertEqual(try result.toString(), "42")
        } catch {
            fail(String(describing: error))
        }
    }
}
