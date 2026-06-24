# NfcDocVerification IOS Library

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/MConnect-Africa/NfcVerification-ios-spm.git", branch: "feat/nfc")
]
```
Or via Xcode:

File → Add Packages
Enter package URL → https://github.com/MConnect-Africa/NfcVerification-ios-spm

Select the latest package

## Setup
### 1. Configuration
Drag the `isocel_config.json` file into your projects file inspector and ensure that the file is added to your app's target. Confirm that it is by checking the Copy Bundle Resources drop down in the Build Phases tab as shown below.

<img width="1249" height="652" alt="Screenshot 2026-06-23 at 17 02 34" src="https://github.com/user-attachments/assets/106c9c6a-8d5a-448f-9bf3-675ec21015c7" />

### 2. Add NFC Entitlement
Add to your Info.plist:

```swift
<key>NFCReaderUsageDescription</key>
<string>We need NFC access to read your id information</string>

<key>com.apple.developer.nfc.readersession.formats</key>
<array>
    <string>NDEF</string>
    <string>TAG</string>
</array>
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
     <string>A0000002471001</string>
</array>
```
### 3. Import the Module and initialize sdk
 Ensure you call NfcVerification.shared.initialize() in AppDelegate `func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?)` function
```swift
import SwiftUI
import NfcSdk

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NfcVerification.shared.initialize()
        return true
    }
}

@main
struct NfcDocVerificationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            // Your apps content
        }
    }
}
```

## Core Components
### 1. MRZ Scanner (MRZCameraPreview and MRZEngine)
Use the camera to scan the Machine Readable Zone (MRZ) at the bottom of the id card.
The following is an example:
```swift
import SwiftUI
import NfcSdk

struct MRZScannerView: View {
    @StateObject private var mrzEngine = MRZEngine()
    @State private var showNfcScan = false
    @State private var bacKeys: BacKeys?
    
    var body: some View {
        VStack {
            MRZCameraPreview(session: mrzEngine.session)
                .frame(height: 300)
                .cornerRadius(12)
            
            if mrzEngine.isRunning {
                Text("Scanning MRZ...")
                    .foregroundColor(.blue)
            }
            
            Button(mrzEngine.torchOn ? "Torch Off" : "Torch On") {
                mrzEngine.toggleTorch()
            }
        }
        .onAppear {
            mrzEngine.start()
            mrzEngine.onBacKeys = { keys in
                self.bacKeys = keys
                self.showNfcScan = true
            }
        }
        .onDisappear {
            mrzEngine.stop()
        }
        .sheet(isPresented: $showNfcScan) {
            NFCScanView()
        }
    }
}
```
### 2. NFC Scan Service

Read passport data via NFC after MRZ scan is successful.

```swift
import SwiftUI
import NfcSdk

struct NFCScanView: View {
    @StateObject private var viewModel = NfcScanViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            switch viewModel.state {
            case .idle:
                Button("Start NFC Scan") {
                    viewModel.scan()
                }
                
            case .scanning(let progress):
                VStack {
                    ProgressView()
                    Text(progress)
                        .foregroundColor(.blue)
                }
                
            case .success(let documentData):
                DocumentDetailsView(data: documentData) // Contains the data from the chip
                
            case .failed(let error):
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Try Again") {
                        viewModel.scan()
                    }
                }
            }
        }
        .padding()
    }
}
```
## Data Model: `DocumentData`
The `DocumentData` object contains the following information (if available on the chip):
- `fullName`
- `surname`
- `givenNames`
- `documentNumber`
- `issuingState`
- `nationality`
- `gender`
- `dateOfBirth` (and `formattedDob`)
- `dateOfExpiry` (and `formattedExpiry`)
- `imageData` (as a `Data`) // Face Image
- `signatureImageData` (as a `Data`) // Signature Image
- `mrzRaw`
- `county`
- `subCounty`
- `division`
- `location`
- `subLocation`

## Requirements

- iOS 13.0+
- Device with NFC capabilities (iPhone 7 or newer)
- Physical ID with NFC chip
- Entitlements: `Near Field Communication Tag Reader Session Formats`




