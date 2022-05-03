// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DepositFlow",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "DepositFlow", targets: ["DepositFlow"])
    ],
    dependencies: [
        .package(path: "./Flows/SupportPackages/Library")
    ],
    targets: [
        .target(name: "DepositFlow", dependencies: ["Library"]),
        .testTarget(name: "DepositFlowTests", dependencies: ["DepositFlow"]),
    ]
)

