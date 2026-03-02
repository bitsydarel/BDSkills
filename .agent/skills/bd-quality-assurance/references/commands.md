# Platform-Specific Commands

Find the commands for your specific stack below.

## Python

```xml
<steps>
  <step>
    <name>Format</name>
    <command>black . or ruff format .</command>
    <purpose>Code formatting</purpose>
  </step>
  <step>
    <name>Lint</name>
    <command>ruff check . --fix</command>
    <purpose>Linting with auto-fix</purpose>
  </step>
  <step>
    <name>Type</name>
    <command>mypy src/</command>
    <purpose>Static type checking</purpose>
  </step>
  <step>
    <name>Test</name>
    <command>pytest -v --cov</command>
    <purpose>Tests with coverage</purpose>
  </step>
  <step>
    <name>Build</name>
    <command>pip install -e .</command>
    <purpose>Verify package builds</purpose>
  </step>
</steps>

```

## TypeScript/JavaScript (Node/React/Vue)

```xml
<steps>
  <step>
    <name>Format</name>
    <command>prettier --write .</command>
    <purpose>Code formatting</purpose>
  </step>
  <step>
    <name>Lint</name>
    <command>eslint . --fix</command>
    <purpose>Linting with auto-fix</purpose>
  </step>
  <step>
    <name>Type</name>
    <command>tsc --noEmit</command>
    <purpose>Type checking (TS only)</purpose>
  </step>
  <step>
    <name>Test</name>
    <command>npm test or vitest run</command>
    <purpose>Run test suite</purpose>
  </step>
  <step>
    <name>Build</name>
    <command>npm run build</command>
    <purpose>Verify production build</purpose>
  </step>
</steps>

```

## Go

```xml
<steps>
  <step>
    <name>Format</name>
    <command>gofmt -w .</command>
    <purpose>Code formatting</purpose>
  </step>
  <step>
    <name>Lint</name>
    <command>golangci-lint run</command>
    <purpose>Comprehensive linting</purpose>
  </step>
  <step>
    <name>Type</name>
    <command>(Built into compiler)</command>
    <purpose>Automatic</purpose>
  </step>
  <step>
    <name>Test</name>
    <command>go test -v -cover ./...</command>
    <purpose>Tests with coverage</purpose>
  </step>
  <step>
    <name>Build</name>
    <command>go build ./...</command>
    <purpose>Verify compilation</purpose>
  </step>
</steps>

```

## Rust

```xml
<steps>
  <step>
    <name>Format</name>
    <command>cargo fmt</command>
    <purpose>Code formatting</purpose>
  </step>
  <step>
    <name>Lint</name>
    <command>cargo clippy</command>
    <purpose>Linting</purpose>
  </step>
  <step>
    <name>Type</name>
    <command>(Built into compiler)</command>
    <purpose>Automatic</purpose>
  </step>
  <step>
    <name>Test</name>
    <command>cargo test</command>
    <purpose>Run test suite</purpose>
  </step>
  <step>
    <name>Build</name>
    <command>cargo build</command>
    <purpose>Verify compilation</purpose>
  </step>
</steps>

```

## Mobile (Swift/Kotlin/Dart)

### Swift (iOS)
* **Format**: `swiftformat .`
* **Lint**: `swiftlint --fix`
* **Test**: `xcodebuild test`
* **Build**: `xcodebuild build`

### Kotlin (Android)
* **Format**: `ktfmt --format .`
* **Lint**: `./gradlew ktlintCheck`
* **Test**: `./gradlew test`
* **Build**: `./gradlew assembleDebug`

### Dart/Flutter
* **Format**: `dart format .`
* **Lint**: `flutter analyze`
* **Test**: `flutter test --coverage`
* **Build**: `flutter build`
