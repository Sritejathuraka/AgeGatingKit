// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AgeGatingKit",

    platforms: [
        .iOS(.v16)
    ],

    products: [
        .library(
            name: "AgeGatingKit",
            targets: ["AgeGatingKit"]
        )
    ],

    targets: [
        .target(
            name: "AgeGatingKit",
            path: "ios/Sources/AgeGatingKit"
        ),

        .testTarget(
            name: "AgeGatingKitTests",
            dependencies: ["AgeGatingKit"],
            path: "ios/Tests/AgeGatingKitTests"
        )
    ]
)
