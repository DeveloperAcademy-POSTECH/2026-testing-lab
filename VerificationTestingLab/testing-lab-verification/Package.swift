// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "VerificationTestingLab",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "VerificationTestingLab",
            targets: ["VerificationTestingLab"]
        )
    ],
    targets: [
        .target(name: "VerificationTestingLab"),
        .testTarget(
            name: "VerificationTestingLabTests",
            dependencies: ["VerificationTestingLab"]
        )
    ]
)
