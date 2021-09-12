# JavaScript

## Package.swift

```swift
.package(url: "https://github.com/JavaScriptKit/JavaScriptCore.git", .branch("dev"))
```

## Usage

```swift
let context = JSContext()
try context.evaluate("40 + 2")

try context.createFunction(name: "getResult") {
    return .string("result string")
}
let result = try context.evaluate("getResult()")
expect(result.isString)
expect(try result.toString() == "result string")
expect("\(result)" == "result string")
```

## Requirements

### macOS

Just works

### Linux

```bash
apt install -y libjavascriptcoregtk-4.0-dev
swift build -Xcc -I/usr/include/webkitgtk-4.0
swift test -Xcc -I/usr/include/webkitgtk-4.0
```
