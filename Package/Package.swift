// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetKit",
    platforms: [
        .iOS(.v13) // Specify the minimum deployment target for iOS
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetKit",
            targets: ["NetKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/google/promises.git", .upToNextMajor(from: "2.4.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetKit",
            dependencies: [
                .product(name: "Promises", package: "promises"),
                "Alamofire"
            ]),
        .testTarget(
            name: "NetKitTests",
            dependencies: ["NetKit"]),
    ]
)
