# Mobile Component Reference

Agnostic setup for iOS, Android, and multi-platform.

## Minimal AGENTS.md Example: Single-Repo Mobile Project
Most mobile projects use a single repository per app/platform. Use this universal AGENTS.md template for iOS (Swift), Android (Kotlin), Flutter, or React Native:

```markdown
## Project Overview
This repository contains a [PLATFORM] mobile app ([LANGUAGE/FRAMEWORK], e.g., iOS/Swift, Android/Kotlin, Flutter/Dart, React Native/JS/TS) for [PURPOSE/PRODUCT].

## Target Audience
Mobile developers, QA testers, release/CI engineers, and (if open source) outside contributors.

## Key Commands
- Setup: `[SETUP_COMMAND]` (e.g., `pod install`, `./gradlew assemble`, `flutter pub get`, `npm install`)
- Build: `[BUILD_COMMAND]` (e.g., `xcodebuild -scheme <scheme>`, `./gradlew assembleDebug`, `flutter build`, `npx react-native run-ios`)
- Test: `[TEST_COMMAND]` (e.g., `xcodebuild test`, `./gradlew test`, `flutter test`, `npm test`)
- Run: `[RUN_COMMAND]` (e.g., `flutter run`, `npx react-native run-android`, open in Xcode/Android Studio)
- Lint (optional): `[LINT_COMMAND]` (e.g., `swiftlint`, `ktlint`, `flutter analyze`, `eslint .`)

## Security
Follow [OWASP MASVS 2.0 (2024)](https://owasp.org/mas) and minimize app permissions.
- Always enable Proguard/obfuscation for Android and Flutter release builds.
- Strip debug symbols in iOS release/archive builds.
- Store secrets using platform APIs (Keychain, Keystore).

## Additional Docs
- CONTRIBUTING.md (if present)
- README.md (for build targets, troubleshooting, OTA update details, etc.)
- .github/workflows/ci.yml (if present)
```

Fill `[PLATFORM]`, `[LANGUAGE/FRAMEWORK]`, `[PURPOSE/PRODUCT]`, and command placeholders as appropriate. Mention `README.md` for project-specific notes where applicable.

---

## Setup/Build/Test Commands
- iOS (Swift): `pod install`, `xcodebuild`
- Android (Kotlin): `./gradlew assemble`, `./gradlew test`
- Flutter: `flutter pub get`, `flutter run`, `flutter test`

## Security & Best Practices
- Use platform APIs for secure storage and data protection.
- Implement biometric auth, PIN management, and session security.
- Network security: TLS/SSL, certificate pinning for all requests.
- Regularly update dependencies, minimize permissions.
- Detect and prevent reverse engineering (obfuscation, minimize debug info).
- Validate every user input and API call.

For standards, see:
- [OWASP MASVS 2.0 (2024)](https://owasp.org/mas)
- [Android Guide](https://developer.android.com/guide)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)

_All guidance continuously reviewed for compliance. Last annual update: Jan 2026._
