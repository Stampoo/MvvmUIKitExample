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
            url: "https://github.com/Stampoo/EventTransceiver.git",
            branch: "main"
        ),
        .package(
            name: "ReactiveDataDisplayManager",
            url: "https://github.com/surfstudio/ReactiveDataDisplayManager.git",
            revision: "7.2.1"
        )
    ],
    targets: [
        .target(name: "Core", dependencies: ["EventTransceiver", "ReactiveDataDisplayManager"]),
        .testTarget(name: "CoreTests", dependencies: ["Core"]),
    ]
)

