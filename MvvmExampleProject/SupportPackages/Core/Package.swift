// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
        .package(
            name: "EventTransceiver",
            url: "git@github.com:Stampoo/EventTransceiver.git",
            branch: "main"
        )
    ],
    targets: [
        .target(name: "Core", dependencies: ["EventTransceiver"]),
        .testTarget(name: "CoreTests", dependencies: ["Core"]),
    ]
)

