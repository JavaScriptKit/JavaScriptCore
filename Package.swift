// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "JavaScript",
    products: [
        .library(name: "JavaScript", targets: ["JavaScriptCoreSwift"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-code/test.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "CJavaScriptCore",
            dependencies: []),
        .target(
            name: "JavaScriptCoreSwift",
            dependencies: ["CJavaScriptCore", "JavaScript"]),
        .target(
            name: "JavaScript",
            dependencies: []),
        .testTarget(
            name: "JavaScriptTests",
            dependencies: ["Test", "JavaScriptCoreSwift"]),
    ]
)
