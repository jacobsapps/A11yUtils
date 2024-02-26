// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "A11yUtils",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "A11yUtils",
            targets: ["A11yUtils"]),
    ],
    targets: [
        .target(
            name: "A11yUtils"),
        .testTarget(
            name: "A11yUtilsTests",
            dependencies: ["A11yUtils"]),
    ]
)
