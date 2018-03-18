# JavaScript

This package provides JavaScript APIs for several engines.

## Package Targets
* JavaScipt - common protocols
* V8 - google's v8 engine wrapper
* JavaScriptCoreSwift - linux version of apple's JavaScriptCore
* СhakraCore - microsoft's chakracore engine wrapper (WIP)

## Package.swift

```swift
.package(url: "https://github.com/tris-foundation/javascript.git", .branch("master"))
```

## Requirements

### V8

#### macOS
```bash
brew install v8
```

#### Linux
```bash
add-apt-repository -y ppa:pinepain/libv8-archived
apt update && apt install -y libv8-dev
```

### JavaScriptCore

#### Linux
```bash
apt install -y libjavascriptcoregtk-1.0-dev
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

## SwiftPM arguments

### macOS
```bash
swift package \
 -Xcc -I/usr/local/include \
 -Xlinker -L/usr/local/lib \
 -Xlinker /usr/local/lib/libv8.dylib \
 -Xlinker /usr/local/lib/libv8_libbase.a \
 -Xlinker /usr/local/lib/libv8_libplatform.a \
 generate-xcodeproj

swift test \
 -Xlinker /System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/JavaScriptCore \
 -Xcc -I/usr/local/include \
 -Xlinker /usr/local/lib/libv8.dylib \
 -Xlinker /usr/local/lib/libv8_libbase.a \
 -Xlinker /usr/local/lib/libv8_libplatform.a \
 --generate-linuxmain
```

### Linux
```bash
swift build -Xlinker /usr/lib/libv8_libbase.a -Xlinker /usr/lib/libv8_libplatform.a
swift test -Xlinker /usr/lib/libv8_libbase.a -Xlinker /usr/lib/libv8_libplatform.a
```
