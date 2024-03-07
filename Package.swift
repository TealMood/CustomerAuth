// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomerAuth",
    platforms: [
      .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CustomerAuth",
            targets: ["CustomerAuth"]
        ),
    ],
    dependencies: [
      .package(url: "https://github.com/p2/OAuth2", .upToNextMajor(from: "5.3.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CustomerAuth",
            dependencies: [
              .product(name: "OAuth2", package: "OAuth2")
            ]
        ),
        .testTarget(
            name: "CustomerAuthTests",
            dependencies: ["CustomerAuth"]
        ),
    ]
)
