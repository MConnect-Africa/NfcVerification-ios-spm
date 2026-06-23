// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NfcSdk",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // The public library now points to the wrapper target
        .library(
            name: "NfcSdk",
            targets: ["NfcSdk"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/AndyQ/NFCPassportReader.git", exact: "2.3.0")
    ],
    targets: [

        .target(
            name: "NfcSdk",
            dependencies: [
                .target(name: "NfcSdkBinary"),
                .product(name: "NFCPassportReader", package: "NFCPassportReader")
            ],
            path: "Sources/NfcSdk"
        ),
        
        .binaryTarget(
            name: "NfcSdkBinary",
            url: "https://github.com/MConnect-Africa/NfcVerification-ios-spm/releases/download/0.0.1/NfcSdk.xcframework.zip",
            checksum: "00074c9699704181bfd18271602a37c7597e06401826d88394b6d9c67aa41d44"
        )
    ]
)
