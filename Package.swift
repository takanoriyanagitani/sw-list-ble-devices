// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "ListBleDevices",
  platforms: [
    .macOS(.v15)
  ],
  products: [
    .library(
      name: "ListBleDevices",
      targets: ["ListBleDevices"])
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.59.1")
  ],
  targets: [
    .target(
      name: "ListBleDevices"),
    .testTarget(
      name: "ListBleDevicesTests",
      dependencies: ["ListBleDevices"]
    ),
  ]
)
