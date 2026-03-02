# Structure Patterns

Select the pattern matching the active project type.

## Mobile & Client

### Flutter (Dart)
```text
/lib
  /common              # Shared foundations
  /authentication      # Feature
  /settings            # Feature
  /orders              # Feature

```

### Android (Kotlin)

Use Gradle modules or folders to represent feature boundaries.

```text
/ (repo root)
  /app                 # Android application
  /common              # Shared foundations
  /authentication      # Feature module
  /settings            # Feature module

```

### iOS (Swift)

Use Swift packages (preferred) or Xcode modules/targets.

```text
/ (repo root)
  /App                 # iOS application target
  /Common              # Shared foundations
  /Authentication      # Feature package/target
  /Settings            # Feature package/target

```

## Backend

### Python

Use packages/modules for feature boundaries.

```text
/src
  /common              # Shared foundations
  /authentication      # Feature
  /orders              # Feature
  /payments            # Feature
/tests
  /authentication
  ...

```

### Node.js/TypeScript

Use folders or npm workspaces.

```text
/src
  /common              # Shared foundations
  /authentication      # Feature
  /orders              # Feature

```

### Go

Use packages within `internal/`.

```text
/cmd
  /server              # Entry point
/internal
  /common              # Shared foundations
  /authentication      # Feature
  /orders              # Feature

```

## Web

### React/Vue/Angular

Use feature folders within `src`.

```text
/src
  /common              # Shared foundations
  /authentication      # Feature
  /dashboard           # Feature
  /settings            # Feature

```
