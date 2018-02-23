/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

#if os(Linux)
import CJavaScriptCore
#else
import JavaScriptCore
#endif

public struct JSError: Error, CustomStringConvertible {
    public var description: String

    init(context: JSContextRef, pointer: JSValueRef) {
        let value = JSValue(context: context, pointer: pointer)
        do {
            guard value.isObject else {
                description = "not an object"
                return
            }
            guard let message = value["message"] else {
                self.description = "failed to access error.message"
                return
            }
            self.description = try message.toString()
        } catch {
            self.description = "failed to convert JSError"
        }
    }
}
