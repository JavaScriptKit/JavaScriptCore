// swift-tools-version:6.4
import PackageDescription

let package = Package(
    name: "JavaScriptCore",
    platforms: [
        .macOS(.v26),
    ],
    products: [
        .library(
            name: "SJavaScriptCore",
            targets: ["SJavaScriptCore"]
        ),
    ],
    dependencies: [
        .package(name: "JavaScript"),
    ],
    targets: [
        .target(
            name: "SJavaScriptCore",
            dependencies: [
                .target(
                    name: "CJavaScriptCore",
                    condition: .when(platforms: [.linux])
                ),
                .product(
                    name: "JavaScript",
                    package: "javascript"
                ),
            ],
            path: "./Sources/JavaScriptCore"
        ),
        .systemLibrary(
            name: "CJavaScriptCore",
            pkgConfig: "javascriptcoregtk-4.1",
            providers: [.aptItem(["libjavascriptcoregtk-4.1-dev"])]
        ),
        .testTarget(
            name: "Tests",
            dependencies: [
                "SJavaScriptCore"
            ]
        )
    ]
)

// MARK: - custom package source

#if canImport(ObjectiveC)
import Darwin.C
#else
import Glibc
#endif

extension Package.Dependency {
    enum Source: String {
        case local, remote, github

        static var `default`: Self { .github }

        var baseUrl: String {
            switch self {
            case .local: return "../../swiftstack/"
            case .remote: return "https://swiftstack.io/"
            case .github: return "https://github.com/swiftstack/"
            }
        }

        func url(for name: String) -> String {
            return self == .local
                ? baseUrl + name.lowercased()
                : baseUrl + name.lowercased() + ".git"
        }
    }

    static func package(name: String) -> Package.Dependency {
        guard let pointer = getenv("SWIFTSTACK") else {
            return .package(name: name, source: .default)
        }
        guard let source = Source(rawValue: String(cString: pointer)) else {
            fatalError("Invalid source. Use local, remote or github")
        }
        return .package(name: name, source: source)
    }

    static func package(name: String, source: Source) -> Package.Dependency {
        return source == .local
            ? .package(name: name, path: source.url(for: name))
            : .package(url: source.url(for: name), branch: "dev")
    }
}
