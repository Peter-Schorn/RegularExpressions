// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RegularExpressions",
    products: [
        // Products define the executables and libraries
        // produced by a package, and make them visible to other packages.
        .library(
            name: "RegularExpressions",
            targets: ["RegularExpressions"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package.
        // A target can define a module or a test suite.
        // Targets can depend on other targets in this package,
        // and on products in packages which this package depends on.
        .target(
            name: "RegularExpressions",
            dependencies: []
        )
    ]
)


/*
 /Users/pschorn/Swift/Libraries/RegularExpressions/Package.swift: dependency 'Utilities' in target 'RegularExpressionsTests' requires explicit declaration; provide the name of the package dependency with '.package(name: "Utilities", url: "https://github.com/Peter-Schorn/Swift_Utilities", from: "2.1.5")'
 */
