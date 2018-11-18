/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import CV8
import JavaScript

public class JSEngine: JavaScript.JSEngine {
    public typealias JSRuntime = V8.JSRuntime
    public static func createRuntime() -> JSRuntime {
        return JSRuntime()
    }
}
