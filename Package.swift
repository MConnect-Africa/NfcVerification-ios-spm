// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

import PackageDescription

let package = Package(
    name: "NfcSdk",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "NfcSdk",
            targets: ["NfcSdkWrapper"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/AndyQ/NFCPassportReader.git", exact: "2.3.0")
    ],
    targets: [
        .target(
            name: "NfcSdkWrapper",
            dependencies: [
                .target(name: "NfcSdkBinary"),
                .product(name: "NFCPassportReader", package: "NFCPassportReader")
            ]
        ),
        .binaryTarget(
            name: "NfcSdkBinary",
            url: "https://github.com/MConnect-Africa/NfcVerification-ios-spm/releases/download/v1.0.2/NfcSdk.xcframework.zip",
            checksum: "d4e40c310884c62d0f9666a92e3a094fe58594c937d95024a64329e7201a1ff9"
        )
    ]
)
