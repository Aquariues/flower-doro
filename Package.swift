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
        ),
        .executable(
            name: "FlowerDoroApp",
            targets: ["FlowerDoroApp"]
        )
    ],
    targets: [
        .target(
            name: "FlowerDoro",
            resources: [
                .process("Resources")
            ]
        ),
        .executableTarget(
            name: "FlowerDoroApp",
            dependencies: ["FlowerDoro"]
        ),
        .testTarget(
            name: "FlowerDoroTests",
            dependencies: ["FlowerDoro"]
        )
    ]
)
