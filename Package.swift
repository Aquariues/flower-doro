// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "FlowerDoro",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "FlowerDoro",
            targets: ["FlowerDoro"]
        )
    ],
    targets: [
        .target(name: "FlowerDoro"),
        .testTarget(
            name: "FlowerDoroTests",
            dependencies: ["FlowerDoro"]
        )
    ]
)
