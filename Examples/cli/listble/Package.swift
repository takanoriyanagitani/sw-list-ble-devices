// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "ListBle",
  platforms: [
    .macOS(.v15)
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.59.1"),
    .package(
      url: "https://github.com/apple/swift-async-algorithms", from: "1.0.4",
    ),
    .package(path: "../../.."),
  ],
  targets: [
    .executableTarget(
      name: "ListBle",
      dependencies: [
        .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
        .product(name: "ListBleDevices", package: "sw-list-ble-devices"),
      ],
      swiftSettings: [
        .unsafeFlags(
          ["-cross-module-optimization"],
          .when(configuration: .release),
        )
      ],
    )
  ]
)
