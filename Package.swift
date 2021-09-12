// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "JavaScriptCore",
    products: [
        .library(name: "SJavaScriptCore", targets: ["SJavaScriptCore"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftstack/javascript.git",
            .branch("dev")),
        .package(
            url: "https://github.com/swiftstack/test.git",
            .branch("dev"))
    ],
    targets: [
        .target(
            name: "CJavaScriptCore",
            dependencies: []),
        .target(
            name: "SJavaScriptCore",
            dependencies: ["CJavaScriptCore", "JavaScript"]),
        .testTarget(
            name: "SJavaScriptCoreTests",
            dependencies: ["Test", "SJavaScriptCore"]),
    ]
)
