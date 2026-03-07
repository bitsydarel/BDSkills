# Security Review — Swift

## Language security profile

- **Type system**: Strong static typing with optionals (nil safety), value types (structs/enums), and protocol-oriented design. Type safety prevents many vulnerability classes at compile time
- **Memory model**: Automatic Reference Counting (ARC) — no garbage collection pauses, but retain cycles can cause memory leaks. No manual memory management in safe Swift, but `UnsafePointer`/`UnsafeBufferPointer` bypass safety
- **Ecosystem risks**: Swift Package Manager (SPM) is the primary dependency manager. Apple's ecosystem is relatively controlled but third-party packages are community-audited. CocoaPods and Carthage are legacy alternatives with weaker security
- **Execution contexts**: iOS/iPadOS apps, macOS apps, watchOS/tvOS, server-side Swift (Vapor), system utilities

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Keychain misuse (wrong access control, not using kSecAttrAccessibleWhenUnlockedThisDeviceOnly) | CWE-522 | A4 |
| 2 | App Transport Security (ATS) bypass (NSAllowsArbitraryLoads in Info.plist) | CWE-319 | A4 |
| 3 | WebView vulnerabilities (WKWebView JavaScript bridge, universal links) | CWE-79 | A3 |
| 4 | Insecure data storage (UserDefaults for sensitive data, unencrypted Core Data) | CWE-312 | A4 |
| 5 | Deep link / URL scheme injection (unvalidated parameters from external URLs) | CWE-601 | A3 |
| 6 | Jailbreak detection bypass (runtime manipulation via Frida/Cycript) | CWE-693 | A6 |
| 7 | Biometric auth bypass (fallback to weak passcode, no server-side verification) | CWE-287 | A1 |
| 8 | Clipboard data exposure (UIPasteboard accessible by other apps) | CWE-200 | A4 |
| 9 | Screenshot/background snapshot leaking sensitive data | CWE-200 | A4 |
| 10 | Insufficient certificate pinning (or no pinning, or only pinning leaf cert) | CWE-295 | A4 |

## Threat model context

Why each vulnerability matters in Swift execution context -- use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | Keychain misuse | The Keychain is the only secure storage on iOS/macOS. Wrong access control flags make secrets readable even when the device is locked, exposing tokens to physical attackers or backup extraction |
| 2 | ATS bypass | Disabling App Transport Security allows cleartext HTTP traffic. On untrusted networks, all API communication becomes interceptable |
| 3 | WebView vulnerabilities | WKWebView with JavaScript bridges exposes native methods to web content. A compromised web page can invoke native functions or steal data from the app |
| 4 | Insecure data storage | UserDefaults and unencrypted Core Data store data as plaintext files. On jailbroken devices or via iTunes backup, app data stored outside the Keychain is trivially readable |
| 5 | Deep link injection | URL schemes and universal links receive input from any app or website. Without validation, a malicious deep link can trigger sensitive actions by crafting URL parameters |
| 6 | Jailbreak detection bypass | Runtime manipulation tools can hook and modify any method at runtime. Jailbreak detection that relies on file checks or API calls is bypassable, making it a speed bump, not a barrier |
| 7 | Biometric auth bypass | LocalAuthentication returns a simple boolean -- without server-side verification, an attacker with runtime access can force the result to true. Biometric auth must gate access to a Keychain item, not just a UI check |
| 8 | Clipboard exposure | UIPasteboard is shared between apps on iOS. Sensitive data copied to clipboard is readable by any app, including malicious ones, for up to 3 minutes |
| 9 | Screenshot/background snapshot | iOS captures a screenshot when the app enters background for the task switcher. If the screen shows sensitive data, it is stored as an image accessible via backup or jailbreak |
| 10 | Insufficient certificate pinning | Without certificate pinning, any CA-trusted certificate is accepted. A compromised CA or corporate proxy can intercept all HTTPS traffic between the app and its backend servers |

## Secure coding checklist

- [ ] Store secrets in Keychain with `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` and `kSecAttrAccessControl` for biometric
- [ ] Never set `NSAllowsArbitraryLoads` to true in production — configure ATS exceptions per-domain if needed
- [ ] WKWebView: disable `javaScriptEnabled` when not needed, validate origin in `WKScriptMessageHandler`, restrict navigation
- [ ] Never store sensitive data in UserDefaults, plist files, or unencrypted databases — use Keychain or encrypted Core Data
- [ ] Validate all deep link / universal link parameters: check scheme, host, and path. Require re-auth for sensitive destinations
- [ ] Implement certificate pinning with TrustKit or URLSession delegate, pin public key hashes (not certificates)
- [ ] Use `UIScreen.main.snapshotView` or `applicationWillResignActive` to hide sensitive content from task switcher
- [ ] Set `UIPasteboard.general.items = []` or use app-specific pasteboard for sensitive copy operations
- [ ] Use `CryptoKit` for cryptographic operations — never implement custom crypto
- [ ] Enable hardened runtime and library validation for macOS apps
- [ ] Implement App Attest (DeviceCheck framework) for server-side device integrity verification

## Common misconfigurations

- **Info.plist**: ATS disabled globally, overly broad URL scheme registration, missing required privacy usage descriptions, background modes enabled unnecessarily
- **Keychain**: Using `kSecAttrAccessibleAlways` (accessible even when locked), not setting `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` for background access, shared Keychain groups too broad
- **WKWebView**: JavaScript enabled with `WKUserContentController` exposing native methods, allowing navigation to arbitrary URLs, not validating message handler origins
- **Entitlements**: Unnecessary entitlements (keychain sharing, app groups) expanding attack surface, iCloud backup including sensitive data

## Security tooling

- **SAST**: Semgrep (Swift rules), SwiftLint (with security-focused custom rules), Xcode Analyzer
- **DAST**: Frida (runtime manipulation), objection (runtime analysis), SSL Kill Switch 2, Charles Proxy
- **Binary**: class-dump-swift, Hopper Disassembler, MachO View
- **Standards**: OWASP MASVS 2.0, OWASP MASTG, Apple Platform Security Guide

## Code examples

### Vulnerable: Insecure Keychain access

```swift
// VULNERABLE: Accessible even when device is locked
let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrAccount as String: "authToken",
    kSecValueData as String: tokenData,
    kSecAttrAccessible as String: kSecAttrAccessibleAlways // BAD: always accessible
]
SecItemAdd(query as CFDictionary, nil)
```

### Secure: Properly protected Keychain

```swift
// SECURE: Only accessible when device is unlocked, this device only
let access = SecAccessControlCreateWithFlags(
    nil,
    kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
    .biometryCurrentSet, // Require biometric auth
    nil
)
let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrAccount as String: "authToken",
    kSecValueData as String: tokenData,
    kSecAttrAccessControl as String: access!,
    kSecUseAuthenticationContext as String: LAContext()
]
SecItemAdd(query as CFDictionary, nil)
```

### Vulnerable: Deep link without validation

```swift
// VULNERABLE: No validation of deep link parameters
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    if url.host == "transfer" {
        let amount = url.queryParameters["amount"]! // Crash on nil
        let to = url.queryParameters["to"]!
        performTransfer(amount: amount, to: to) // No auth check
    }
    return true
}
```

### Secure: Validated deep link with re-authentication

```swift
// SECURE: Validate parameters and require re-authentication
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    guard url.scheme == "myapp",
          url.host == "transfer",
          let amountStr = url.queryParameters["amount"],
          let amount = Decimal(string: amountStr),
          amount > 0,
          let to = url.queryParameters["to"],
          to.count <= 100 else {
        return false
    }
    // Require re-authentication for financial operations
    authenticateUser { success in
        if success { self.performTransfer(amount: amount, to: to) }
    }
    return true
}
```
