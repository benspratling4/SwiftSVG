// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSVG"
	,platforms: [
        .macOS(.v10_15)
	]
    ,products: [
        .library(
            name: "SwiftSVG",
            targets: ["SwiftSVG"]),
    ]
    ,dependencies: [
		.package(url: "https://github.com/benspratling4/SwiftGraphicsCore.git", from: "2.0.0"),
		.package(url: "https://github.com/benspratling4/SwiftPatterns.git", from: "3.0.0"),
		.package(path: "../SwiftCSS"),
		.package(url: "https://github.com/benspratling4/SwiftPNG.git", from: "2.0.0"),	//for testing
    ]
    ,targets: [
        .target(
            name: "SwiftSVG",
			dependencies: [
				.byName(name: "SwiftGraphicsCore"),
				.byName(name: "SwiftPatterns"),
				.byName(name: "SwiftCSS"),
				.byName(name: "SwiftPNG")
		]),
        .testTarget(
            name: "SwiftSVGTests",
            dependencies: ["SwiftSVG"/*, "SwiftPNG"*/]),
    ]
)
