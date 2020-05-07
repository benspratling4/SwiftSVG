// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSVG",
    products: [
        .library(
            name: "SwiftSVG",
            targets: ["SwiftSVG"]),
    ],
    dependencies: [
		.package(url: "https://github.com/benspratling4/SwiftGraphicsCore.git", from: "1.0.5"),
//		.package(url: "https://github.com/benspratling4/SwiftPNG.git", from: "1.0.0"),	//for testing
    ],
    targets: [
        .target(
            name: "SwiftSVG",
			dependencies: [.byName(name: "SwiftGraphicsCore")]),
        .testTarget(
            name: "SwiftSVGTests",
            dependencies: ["SwiftSVG"/*, "SwiftPNG"*/]),
    ]
)
