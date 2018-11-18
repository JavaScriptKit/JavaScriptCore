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

```bash
brew install v8
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

### Linux

#### V8

For full instructions follow https://v8.dev/docs/build
```bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:$(pwd)/depot_tools
fetch v8
cd v8
gclient sync -r 7.0.276.28
./build/install-build-deps.sh #OMG
gn gen --args="is_debug=false is_component_build=true v8_use_external_startup_data=false v8_enable_i18n_support=false" out.gn/x64.release
ninja -j8 -C out.gn/x64.release -v d8
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
