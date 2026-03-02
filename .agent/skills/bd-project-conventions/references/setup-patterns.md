# Setup and Configuration Patterns

## Environment Configuration

### File Pattern
1. **Template**: `.env.example` (Committed. Contains keys + dummy values).
2. **Local**: `.env` (Ignored. Contains real values).
3. **Gitignore**: Add `.env`, `.env.local`, `.env.*.local`.

### What to Include
- **Include**: Database URLs, API Keys (local), Feature Flags, Service Endpoints.
- **Exclude**: Hardcoded secrets, Production secrets in dev files.

### Loading Variables

```xml
<Platforms>
  <Platform name="Python">
    <Method>python-dotenv or environs</Method>
  </Platform>
  <Platform name="Node.js">
    <Method>dotenv package</Method>
  </Platform>
  <Platform name="Flutter">
    <Method>flutter_dotenv or envied or dart-defines</Method>
  </Platform>
  <Platform name="Go">
    <Method>godotenv or viper</Method>
  </Platform>
</Platforms>

```

## Dependency Management

### Lock Files
Always commit lock files for reproducible builds.

```xml
<LockFiles>
  <Platform name="Python">
    <LockFile>requirements.lock / poetry.lock</LockFile>
    <UpdateCommand>pip-compile / poetry lock</UpdateCommand>
  </Platform>
  <Platform name="Node.js">
    <LockFile>package-lock.json</LockFile>
    <UpdateCommand>npm install</UpdateCommand>
  </Platform>
  <Platform name="Flutter">
    <LockFile>pubspec.lock</LockFile>
    <UpdateCommand>flutter pub get</UpdateCommand>
  </Platform>
  <Platform name="Go">
    <LockFile>go.sum</LockFile>
    <UpdateCommand>go mod tidy</UpdateCommand>
  </Platform>
  <Platform name="Swift">
    <LockFile>Package.resolved</LockFile>
    <UpdateCommand>swift package resolve</UpdateCommand>
  </Platform>
  <Platform name="Rust">
    <LockFile>Cargo.lock</LockFile>
    <UpdateCommand>cargo update</UpdateCommand>
  </Platform>
</LockFiles>

```

## Troubleshooting

### Common Import Errors

```xml
<ImportErrors>
  <Error>
    <Type>Module not found</Type>
    <LikelyCause>Package not installed in editable mode</LikelyCause>
    <Solution>pip install -e .</Solution>
  </Error>
  <Error>
    <Type>Cannot resolve</Type>
    <LikelyCause>Missing __init__.py</LikelyCause>
    <Solution>Add empty __init__.py files</Solution>
  </Error>
  <Error>
    <Type>Circular import</Type>
    <LikelyCause>Modules importing each other</LikelyCause>
    <Solution>Restructure or use lazy imports</Solution>
  </Error>
  <Error>
    <Type>No module named X</Type>
    <LikelyCause>Wrong environment</LikelyCause>
    <Solution>Activate correct venv/node_modules</Solution>
  </Error>
</ImportErrors>

```

### Common Build Errors

```xml
<BuildErrors>
  <Error>
    <Type>Version mismatch</Type>
    <LikelyCause>Lock file out of sync</LikelyCause>
    <Solution>Delete lock, reinstall</Solution>
  </Error>
  <Error>
    <Type>Missing dependency</Type>
    <LikelyCause>Not in requirements</LikelyCause>
    <Solution>Add and reinstall</Solution>
  </Error>
  <Error>
    <Type>Platform-specific</Type>
    <LikelyCause>OS-specific package</LikelyCause>
    <Solution>Use conditional dependencies</Solution>
  </Error>
</BuildErrors>

```
