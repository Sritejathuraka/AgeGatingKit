// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "age_gating_kit",

    platforms: [
        .iOS(.v16)
    ],

    products: [
        .library(
            name: "age-gating-kit",
            targets: ["age_gating_kit"]
        )
    ],

    dependencies: [
        .package(
            name: "FlutterFramework",
            path: "../FlutterFramework"
        ),

        .package(
            url: "https://github.com/Sritejathuraka/AgeGatingKit.git",
            from: "1.0.1"
        )
    ],

    targets: [
        .target(
            name: "age_gating_kit",

            dependencies: [
                .product(
                    name: "FlutterFramework",
                    package: "FlutterFramework"
                ),

                .product(
                    name: "AgeGatingKit",
                    package: "agegatingkit"
                )
            ],

            path: "Sources/age_gating_kit"
        )
    ]
)