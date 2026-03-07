# Security Review — Kotlin

## Language security profile

- **Type system**: Strong static typing with null safety built into the type system (nullable `T?` vs non-nullable `T`). Eliminates NullPointerException at compile time for most cases
- **Memory model**: JVM garbage collection (Android: ART). No manual memory management. Kotlin/Native uses ARC for non-JVM targets. Interop with Java inherits Java's security profile
- **Ecosystem risks**: Uses Maven Central / Google's Maven repo for dependencies. Gradle build scripts (build.gradle.kts) execute arbitrary Kotlin code. Android-specific risks from APK reverse engineering and Google Play distribution
- **Execution contexts**: Android apps (primary), server-side (Ktor, Spring Boot), Kotlin Multiplatform (KMP), scripting

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Intent injection / exported component abuse (Android) | CWE-926 | A3 |
| 2 | Insecure SharedPreferences (sensitive data in plaintext XML) | CWE-312 | A4 |
| 3 | WebView JavaScript interface exploitation | CWE-79 | A3 |
| 4 | Content Provider path traversal | CWE-22 | A3 |
| 5 | Broadcast receiver spoofing (unprotected receivers) | CWE-862 | A2 |
| 6 | Insecure network communication (cleartext traffic, no cert pinning) | CWE-319 | A4 |
| 7 | Unsafe deserialization (Parcelable, Serializable from untrusted Intent) | CWE-502 | A3 |
| 8 | SQL injection via raw ContentResolver queries | CWE-89 | A3 |
| 9 | Logging sensitive data (Log.d with PII, tokens, credentials) | CWE-532 | A6 |
| 10 | Hardcoded secrets in APK (API keys, crypto keys discoverable via decompilation) | CWE-798 | A4 |

## Threat model context

Why each vulnerability matters in Kotlin execution context -- use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | Intent injection | Android components with exported=true receive Intents from any app on the device. An attacker app can invoke exported Activities/Services with crafted extras, triggering privileged actions without user interaction |
| 2 | Insecure SharedPreferences | SharedPreferences stores data as plaintext XML in the app sandbox. On rooted devices or via ADB backup, all stored tokens and user data are immediately readable |
| 3 | WebView JavaScript interface | Methods annotated with @JavascriptInterface are callable from any JavaScript in the WebView. If the WebView loads untrusted content, malicious scripts gain access to native Android APIs |
| 4 | Content Provider path traversal | A Content Provider that serves files based on URI paths without validation allows .. traversal. Any app on the device can read arbitrary files from the vulnerable app private storage |
| 5 | Broadcast receiver spoofing | Unprotected broadcast receivers accept Intents from any app. An attacker can spoof system or internal broadcasts to trigger actions, modify state, or extract data from the receiving app |
| 6 | Insecure network communication | Cleartext HTTP traffic is interceptable on shared networks. Missing certificate pinning allows corporate proxies and compromised CAs to intercept HTTPS traffic via man-in-the-middle attacks |
| 7 | Unsafe deserialization | Parcelable/Serializable data from untrusted Intents can trigger arbitrary code if custom deserialization logic exists. Kotlin interop with Java means Java deserialization gadget chains also apply |
| 8 | SQL injection | Raw queries via ContentResolver or SQLiteDatabase with string concatenation bypass Room parameterized safety. Kotlin string templates make concatenation syntactically natural and easy to misuse |
| 9 | Logging sensitive data | Log.d() and Log.v() output is readable via logcat by any app on older Android versions, and by ADB on all versions. Logged tokens or PII are exposed to developers, testers, and attackers |
| 10 | Hardcoded secrets | APK files are trivially decompilable with jadx. API keys or credentials in source code are discoverable by anyone who downloads the app from the Play Store |

## Secure coding checklist

- [ ] Set `android:exported="false"` for all Activities/Services/Receivers unless intentionally public
- [ ] Use EncryptedSharedPreferences (Jetpack Security) instead of SharedPreferences for sensitive data
- [ ] WebView: set `webSettings.javaScriptEnabled = false` when not needed, use `@JavascriptInterface` with minimal surface, validate message origins
- [ ] Content Providers: validate URI paths, use `android:permission` for access control, never expose file:// URIs
- [ ] Use `LocalBroadcastManager` or explicit broadcasts instead of implicit broadcasts for internal communication
- [ ] Enable Network Security Config with certificate pinning: `<pin-set>` in `network_security_config.xml`
- [ ] Use Room database with parameterized queries — never raw SQL with string concatenation
- [ ] Remove all `Log.d` / `Log.v` calls with sensitive data in release builds (use Timber with release-mode no-op tree)
- [ ] Never hardcode secrets in source — use Android Keystore, encrypted config, or server-side secrets
- [ ] Enable ProGuard/R8 obfuscation for release builds
- [ ] Implement SafetyNet/Play Integrity API for device attestation
- [ ] Use AndroidKeyStore for cryptographic operations — keys are hardware-backed on supported devices

## Common misconfigurations

- **AndroidManifest**: Activities exported by default when intent filters are declared, missing `android:permission` on Content Providers, `android:debuggable="true"` in release, `android:allowBackup="true"` exposing app data
- **Network Security Config**: `cleartextTrafficPermitted="true"`, certificate pins not set, debug-overrides leaking into production builds
- **Gradle/Build**: Signing keys in gradle.properties (committed to git), build variants sharing the same signing key, minSdkVersion too low (missing security features)
- **ProGuard/R8**: Insufficient obfuscation rules, keep rules exposing internal APIs, missing obfuscation for sensitive classes

## Security tooling

- **SAST**: Android Lint (security checks), Semgrep (Kotlin rules), MobSF, Detekt (with security rule set)
- **DAST**: Frida, objection, drozer (component testing), mitmproxy/Charles (network interception)
- **Binary**: jadx (APK decompilation), apktool, dex2jar, APK Analyzer (Android Studio)
- **SCA**: Dependabot, Snyk, OWASP Dependency-Check (Gradle plugin)
- **Standards**: OWASP MASVS 2.0, OWASP MASTG, Android Security Best Practices

## Code examples

### Vulnerable: Exported Activity with Intent data trust

```kotlin
// VULNERABLE: Activity exported and trusts Intent data
// AndroidManifest: <activity android:name=".TransferActivity" android:exported="true">
class TransferActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        val amount = intent.getStringExtra("amount") // Untrusted from external app
        val recipient = intent.getStringExtra("recipient")
        performTransfer(amount!!, recipient!!) // No validation, no auth check
    }
}
```

### Secure: Protected Activity with validation

```kotlin
// SECURE: Not exported, with input validation and re-authentication
// AndroidManifest: <activity android:name=".TransferActivity" android:exported="false">
class TransferActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Verify user is authenticated
        if (!AuthManager.isAuthenticated()) {
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
            return
        }
        val amount = intent.getStringExtra("amount")?.toBigDecimalOrNull()
        val recipient = intent.getStringExtra("recipient")?.takeIf { it.length <= 100 }
        if (amount == null || amount <= BigDecimal.ZERO || recipient == null) {
            showError("Invalid transfer parameters")
            finish()
            return
        }
        // Require biometric re-authentication for financial operations
        biometricPrompt.authenticate(promptInfo)
    }
}
```

### Vulnerable: SharedPreferences for tokens

```kotlin
// VULNERABLE: Plaintext storage of auth token
val prefs = getSharedPreferences("auth", MODE_PRIVATE)
prefs.edit().putString("token", authToken).apply()
// Stored as plaintext XML, readable on rooted devices
```

### Secure: EncryptedSharedPreferences

```kotlin
// SECURE: Encrypted storage with Jetpack Security
val masterKey = MasterKey.Builder(context)
    .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
    .build()
val encryptedPrefs = EncryptedSharedPreferences.create(
    context, "secure_auth", masterKey,
    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
)
encryptedPrefs.edit().putString("token", authToken).apply()
```
