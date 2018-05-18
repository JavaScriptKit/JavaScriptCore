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

## Requirements

### macOS

#### V8

Default homebrew formula is outdated, please remove it first

```bash
brew remove v8
```

```bash
brew tap tris-brew/macos
brew install libv8
```

#### JavaScriptCore

Works OOB

#### SwiftPM arguments

```bash
swift package \
 -Xcc -I/usr/local/include \
 -Xlinker -L/usr/local/lib \
 -Xlinker /usr/local/lib/libv8.dylib \
 -Xlinker /usr/local/lib/libv8_libbase.dylib \
 -Xlinker /usr/local/lib/libv8_libplatform.dylib \
 generate-xcodeproj

swift test \
 -Xlinker /System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/JavaScriptCore \
 -Xcc -I/usr/local/include \
 -Xlinker /usr/local/lib/libv8.dylib \
 -Xlinker /usr/local/lib/libv8_libbase.dylib \
 -Xlinker /usr/local/lib/libv8_libplatform.dylib \
 --generate-linuxmain
```

### Linuxbrew

#### V8

```bash
brew tap tris-brew/linux
brew install libv8
```

#### SwiftPM arguments

```bash
export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib/
swift build -Xcc -I/home/linuxbrew/.linuxbrew/include -Xlinker -L/home/linuxbrew/.linuxbrew/lib -Xlinker -lv8_libbase -Xlinker -lv8_libplatform
swift test -Xcc -I/home/linuxbrew/.linuxbrew/include -Xlinker -L/home/linuxbrew/.linuxbrew/lib -Xlinker -lv8_libbase -Xlinker -lv8_libplatform
```

### Linux

#### V8

```bash
add-apt-repository -y ppa:pinepain/libv8
apt update && apt install -y libv8-6.6-dev
```

#### JavaScriptCore
```bash
apt install -y libjavascriptcoregtk-1.0-dev
```

#### SwiftPM arguments

```bash
export LD_LIBRARY_PATH=/opt/libv8-6.6/lib
swift build -Xcc -I/opt/libv8-6.6/include -Xlinker -L/opt/libv8-6.6/lib -Xlinker -lv8_libbase -Xlinker -lv8_libplatform
swift test -Xcc -I/opt/libv8-6.6/include -Xlinker -L/opt/libv8-6.6/lib -Xlinker -lv8_libbase -Xlinker -lv8_libplatform
```
