// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "UIHandlers",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "UIHandlers", targets: ["UIHandlers"]),
    ],
    targets: [
        .target(name: "UIHandlers", path: "UIHandlers"),
        .testTarget(name: "UIHandlersTests", dependencies: ["UIHandlers"]),
    ]
)
