# Security Review — Mobile Applications

## Domain context

Mobile applications run on user-controlled devices in hostile environments: rooted/jailbroken devices, untrusted networks, physically accessible hardware. Unlike web apps, mobile apps ship their code to the user (reverse-engineerable), store data on-device (extractable), and interact with platform APIs (camera, location, contacts) that carry significant privacy implications. The app store distribution model adds supply chain considerations (code signing, review process), while platform fragmentation (Android versions, iOS versions) creates inconsistent security baselines.

## OWASP Mobile Top 10 (2024) mapping

| OWASP # | Risk | Mapped Criteria |
|---------|------|----------------|
| M1:2024 | Improper Credential Usage | A1: Authentication |
| M2:2024 | Inadequate Supply Chain Security | A5: Supply Chain |
| M3:2024 | Insecure Authentication/Authorization | A1, A2: Auth/Authz |
| M4:2024 | Insufficient Input/Output Validation | A3: Input Validation |
| M5:2024 | Insecure Communication | A4: Data Protection |
| M6:2024 | Inadequate Privacy Controls | G2: Privacy by Design |
| M7:2024 | Insufficient Binary Protections | A6: Secure Coding |
| M8:2024 | Security Misconfiguration | O3: Infrastructure Hardening |
| M9:2024 | Insecure Data Storage | A4: Data Protection |
| M10:2024 | Insufficient Cryptography | A4: Data Protection |

## Criterion interpretation for mobile applications

| Criterion | Mobile-Specific Interpretation |
|-----------|-------------------------------|
| T1 | Map IPC entry points (intents, URL schemes, deep links), exported components, local storage, network endpoints |
| T2 | STRIDE including device-local threats: physical access, reverse engineering, rooted device, malicious apps on same device |
| T3 | Device → network → server is first boundary. On-device: app sandbox → OS → hardware is second. Keychain/Keystore as trust anchor |
| A1 | Biometric auth with fallback. Credential storage in Keychain (iOS) / Android Keystore. No credentials in app binary. Certificate pinning |
| A2 | Server-side authorization for all operations. Client-side checks are UX only. Deep link authorization |
| A3 | Validate all inputs from IPC (intents, URL schemes), clipboard, local files, QR codes. WebView JavaScript interface restrictions |
| A4 | Certificate pinning. No sensitive data in backups, screenshots, pasteboard. Keychain/Keystore for secrets. No data in app logs |
| A5 | Third-party SDK audit (analytics, ads, crash reporting). App store review. Code signing verification. No malicious SDK telemetry |
| A6 | Anti-tampering (integrity checks). Obfuscation for sensitive logic. No debug flags in release builds. Memory-safe handling of credentials |
| A7 | Permission request context (explain why camera/location is needed). No unnecessary permissions. Privacy labels accurate |
| O1 | Client-side security events forwarded to backend. Jailbreak/root detection logged. Unusual device behavior flagged |
| O3 | App Transport Security (iOS) / Network Security Config (Android). No cleartext traffic. Debug/test builds not distributed |

## Top 5 mobile-specific anti-patterns

### 1. Insecure Local Storage

**Signs**: Sensitive data stored in SharedPreferences (Android) or UserDefaults (iOS) — both unencrypted by default. SQLite databases with PII not encrypted. Credentials in plist files. Data persisting in backup files.

**Impact**: Any physical access or device backup extraction exposes all locally stored data. Rooted/jailbroken devices can read any app's sandbox.

**Fix**: Use Android Keystore / iOS Keychain for credentials and keys. Use encrypted databases (SQLCipher, Realm encryption). Exclude sensitive data from backups (`android:allowBackup="false"`, iOS `isExcludedFromBackup`).

---

### 2. Missing Certificate Pinning

**Signs**: App trusts any CA-signed certificate. No certificate pinning implementation. Pinning implemented but no fallback rotation mechanism. Test mode disables pinning in production builds.

**Impact**: Man-in-the-middle attacks on any network (public WiFi, compromised router, corporate proxy). All API traffic interceptable despite HTTPS.

**Fix**: Implement certificate pinning (pin public key hash, not certificate). Include backup pins for rotation. Use platform mechanisms: Network Security Config (Android), TrustKit (iOS). Test pinning with proxy tools.

---

### 3. Exported Component Abuse

**Signs**: Android activities/services/broadcast receivers exported without permission requirements. iOS URL schemes handling untrusted input without validation. Deep links navigating to sensitive screens without re-authentication.

**Impact**: Malicious apps invoke exported components to bypass authentication, extract data, or trigger unintended actions. Deep link injection leads users to phishing screens within the legitimate app.

**Fix**: Minimize exported components. Require signature-level permissions for inter-app communication. Validate all deep link parameters server-side. Re-authenticate for sensitive deep link destinations.

---

### 4. WebView Vulnerability

**Signs**: WebView loading untrusted content with JavaScript enabled. `addJavascriptInterface` exposing native methods to web content. WebView accessing local files (`file://` protocol enabled). No origin validation for JavaScript bridge calls.

**Impact**: XSS in WebView gains native code execution via JavaScript bridge. Local file access enables reading app sandbox. Untrusted content executes with app permissions.

**Fix**: Disable JavaScript in WebViews loading untrusted content. If JavaScript bridge is necessary, validate origin and restrict exposed methods. Disable file access. Use `@JavascriptInterface` annotation (Android) with minimal surface.

---

### 5. Over-Permissioned SDK

**Signs**: Third-party SDKs requesting broad permissions (location, contacts, camera) unrelated to their function. Analytics SDKs collecting device identifiers without disclosure. Ad SDKs exfiltrating user data. SDK behavior not audited beyond initial integration.

**Impact**: Privacy violations via undisclosed data collection. App store rejection for undeclared data usage. Regulatory penalties (GDPR, CCPA) for third-party data processing without consent. Supply chain risk from compromised SDKs.

**Fix**: Audit all third-party SDKs for permissions and data collection. Use privacy manifests (iOS) and data safety sections (Android). Isolate SDK execution where possible. Monitor SDK network traffic in testing. Review SDK updates for permission/behavior changes.

---

## Key controls checklist

- [ ] Credentials stored in Keychain (iOS) / Android Keystore, never in plaintext
- [ ] Certificate pinning with backup pins for rotation
- [ ] No sensitive data in backups, screenshots, pasteboard, or logs
- [ ] All exported components require appropriate permissions
- [ ] WebView JavaScript interface minimized and origin-validated
- [ ] App Transport Security (iOS) / Network Security Config (Android) enforced
- [ ] Third-party SDK permissions and data collection audited
- [ ] Jailbreak/root detection with appropriate response
- [ ] Obfuscation applied to release builds (ProGuard/R8 for Android)
- [ ] Deep links validated and authorization-checked server-side
- [ ] Biometric authentication implemented with secure fallback
- [ ] Privacy labels / data safety sections accurate and current

## Company practices

- **Apple**: App Store review for security, App Transport Security enforced, Privacy Nutrition Labels required, app attestation API
- **Google**: Play Integrity API for device attestation, Safety Net attestation, Play Protect scanning, data safety section enforcement
- **Netflix**: Certificate pinning with multiple backup pins, client certificate auth for premium content, device binding tokens
- **Spotify**: OAuth 2.0 with PKCE for mobile, token storage in platform Keystore, background audio session security

## Tools and standards

- **SAST**: MobSF, Semgrep (mobile rules), SwiftLint security rules
- **DAST**: Frida, objection, drozer (Android), SSL Kill Switch (iOS)
- **Reverse Engineering**: jadx, Hopper, class-dump
- **Standards**: OWASP Mobile Top 10 2024, OWASP MASVS 2.0, OWASP MASTG
