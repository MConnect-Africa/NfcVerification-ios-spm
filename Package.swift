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
            path: "Sources/NfcVerification"
        ),
        
        .binaryTarget(
            name: "NfcSdkBinary",
            url: "https://github.com/MConnect-Africa/NfcVerification-ios-spm/releases/download/v1.0.0/NfcSdk.xcframework.zip",
            checksum: "2732477a0a0dd599025d210e4cbe841dc810d56f017d895d2362744e2bf2a0f7"
        )
    ]
)
