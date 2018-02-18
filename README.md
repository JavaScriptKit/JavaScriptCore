# JavaScript

Linux version of JavaScriptCore written in Swift with closure support.

## Requirements

```bash
apt install libjavascriptcoregtk-1.0-dev
```

## Package.swift

```swift
.package(url: "https://github.com/tris-foundation/javascript.git", .branch("master"))
```

## Usage

```swift
let context = JSContext()
try context.evaluate("40 + 2")

try context.createFunction(name: "getResult") {
    return .string("result string")
}
let result = try context.evaluate("getResult()")
assertTrue(result.isString)
assertEqual(try result.toString(), "result string")
assertEqual("\(result)", "result string")
```
