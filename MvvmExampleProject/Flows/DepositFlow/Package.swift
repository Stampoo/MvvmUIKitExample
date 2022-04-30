// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DepositFlow",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "DepositFlow", targets: ["DepositFlow"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "DepositFlow", dependencies: []),
        .testTarget(name: "DepositFlowTests", dependencies: ["DepositFlow"]),
    ]
)

