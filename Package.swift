// swift-tools-version:4.0
/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import PackageDescription

let package = Package(
    name: "JavaScript",
    products: [
        .library(name: "JavaScript", targets: ["JavaScript"]),
        .library(name: "V8", targets: ["V8"]),
        .library(name: "V8API", targets: ["V8API"]),
        .library(name: "JavaScriptCoreSwift", targets: ["JavaScriptCoreSwift"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/platform.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/test.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "CJavaScriptCore",
            dependencies: []),
        .target(
            name: "CV8",
            dependencies: []),
        .target(
            name: "CV8Platform",
            dependencies: []),
        .target(
            name: "JavaScriptCoreSwift",
            dependencies: ["CJavaScriptCore", "JavaScript"]),
        .target(
            name: "V8API",
            dependencies: ["CV8", "Platform", "JavaScript"]),
        .target(
            name: "V8",
            dependencies: ["CV8Platform", "V8API", "Platform", "JavaScript"]),
        .target(
            name: "JavaScript",
            dependencies: []),
        .testTarget(
            name: "JavaScriptCoreTests",
            dependencies: ["Test", "JavaScriptCoreSwift"]),
        .testTarget(
            name: "V8Tests",
            dependencies: ["Test", "V8"]),
    ],
    cxxLanguageStandard: .cxx11
)
