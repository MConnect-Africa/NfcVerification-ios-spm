// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NfcSdk",
    products: [
        .library(
            name: "NfcSdk",
            targets: ["NfcSdk"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "NfcSdk",
            url: "https://github.com/MConnect-Africa/NfcVerification-ios-spm/releases/download/0.0.1/NfcSdk.xcframework.zip",
            checksum: "00074c9699704181bfd18271602a37c7597e06401826d88394b6d9c67aa41d44"
        )
    ]
)
