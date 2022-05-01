// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Library",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Library", targets: ["Library"])
    ],
    dependencies: [
        .package(path: "./Core")
    ],
    targets: [
        .target(name: "Library", dependencies: ["Core"])
    ]
)

