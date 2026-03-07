# Security Review — Desktop Applications

## Domain context

Desktop applications run with the user's full OS permissions, have direct file system access, and persist between sessions. Unlike sandboxed web or mobile apps, desktop apps can read/write arbitrary files, spawn processes, access hardware, and interact with other applications. Electron-based apps inherit both web and desktop attack surfaces. Auto-update mechanisms, plugin systems, and local data storage create unique security challenges. The OWASP Desktop App Security Top 10 (2021) is the primary reference.

## OWASP Desktop App Security Top 10 (2021) mapping

| OWASP # | Risk | Mapped Criteria |
|---------|------|----------------|
| DA1:2021 | Injections | A3: Input Validation |
| DA2:2021 | Broken Authentication | A1: Authentication |
| DA3:2021 | Sensitive Data Exposure | A4: Data Protection |
| DA4:2021 | Improper Cryptography Usage | A4: Data Protection |
| DA5:2021 | Improper Authorization | A2: Authorization |
| DA6:2021 | Security Misconfiguration | O3: Infrastructure Hardening |
| DA7:2021 | Insecure Communication | A4: Data Protection |
| DA8:2021 | Poor Code Quality | A6: Secure Coding |
| DA9:2021 | Using Components with Known Vulnerabilities | A5: Supply Chain |
| DA10:2021 | Insufficient Logging and Monitoring | O1: Security Logging |

## Criterion interpretation for desktop applications

| Criterion | Desktop-Specific Interpretation |
|-----------|-------------------------------|
| T1 | Map IPC mechanisms, file format handlers, protocol handlers (custom URI schemes), network listeners, plugin interfaces |
| T2 | STRIDE including local threats: malicious files opened by the app, DLL hijacking, local privilege escalation |
| T3 | App process → OS → network boundaries. Plugin/extension system as trust boundary. Auto-update channel as trust crossing |
| A1 | Local credential storage (OS keychain, Credential Manager). License validation. SSO integration for enterprise |
| A2 | File system permissions for app data. Admin vs user mode operations. Plugin permission model |
| A3 | File format parsing (document, image, media). Protocol handler input. Clipboard data. Command-line arguments |
| A4 | Local data encryption (SQLite encryption, credential storage). TLS for all network communication. Code signing |
| A5 | Auto-update mechanism security (signed updates, HTTPS, rollback). Plugin/extension marketplace vetting |
| A6 | Memory safety (especially C/C++ apps). DLL loading security. Process isolation. Crash handling without info leakage |
| A7 | Update prompts must be distinguishable from phishing. Permission escalation dialogs clear and non-deceptive |
| O1 | Local security event logging. Crash reporting without sensitive data. Enterprise deployment audit trail |
| O3 | Installer security (no temp file vulnerabilities). Default permissions. Auto-update configuration |

## Top 5 desktop-specific anti-patterns

### 1. DLL/Dylib Hijacking

**Signs**: Application loads DLLs from the current working directory or user-writable paths before system paths. No DLL load path hardening. Missing code signing verification for loaded libraries.

**Impact**: Attacker places a malicious DLL in a location the application searches first, gaining code execution with the application's permissions. Common initial access technique (MITRE T1574.001).

**Fix**: Use absolute paths for library loading. On Windows: use `SetDllDirectory("")` to remove CWD from search path, enable SafeDllSearchMode. On macOS: use `@rpath` with restricted paths. Verify code signatures of loaded libraries.

---

### 2. Insecure Auto-Update

**Signs**: Update mechanism over HTTP (not HTTPS). Downloaded updates not signature-verified. No rollback mechanism. Update server compromise leads to arbitrary code execution on all clients.

**Impact**: Man-in-the-middle attackers serve malicious updates to all users. Compromised update server is a supply chain attack affecting the entire user base (NotPetya spread via M.E.Doc updates).

**Fix**: HTTPS for update checks and downloads. Code-sign all updates and verify signatures before installation. Implement certificate pinning for update server. Provide rollback capability. Use framework-specific secure update mechanisms (Sparkle for macOS, Squirrel for Electron).

---

### 3. Local Data Exposure

**Signs**: Sensitive data stored in plaintext config files, SQLite databases, or log files. Application data in user-readable directories without encryption. Credentials in registry entries or plist files.

**Impact**: Any local access (malware, shared computer, stolen laptop without FDE) exposes all application secrets. Enterprise applications may store tokens granting access to organizational resources.

**Fix**: Encrypt sensitive local data using OS-provided mechanisms (DPAPI on Windows, Keychain on macOS, Secret Service on Linux). Never store credentials in plaintext config files. Use file system permissions to restrict access. Clear sensitive data from memory after use.

---

### 4. Electron Security Misconfig

**Signs**: `nodeIntegration: true` in renderer processes. `contextIsolation: false`. No sandbox enabled. `webSecurity: false`. Loading remote content in main window without content security policy.

**Impact**: XSS in an Electron renderer process gains full Node.js access — read/write file system, execute commands, access network. Electron security misconfiguration turns a web vulnerability into full system compromise.

**Fix**: `nodeIntegration: false`, `contextIsolation: true`, `sandbox: true` for all renderer processes. Use `contextBridge` for preload scripts. Enable `webSecurity`. CSP for all loaded content. Validate all IPC messages between main and renderer processes.

---

### 5. Unsafe File Format Parsing

**Signs**: Custom parsers for complex file formats (PDF, Office, media) without fuzzing. No sandboxing for file parsing. Parser written in memory-unsafe language without bounds checking.

**Impact**: Maliciously crafted files trigger buffer overflows, use-after-free, or integer overflows in parsers, leading to code execution. File format vulnerabilities are among the most exploited attack vectors for desktop apps.

**Fix**: Use well-maintained parsing libraries (not custom implementations). Fuzz all file format parsers. Sandbox file parsing in a separate process with restricted permissions. Validate file structure before deep parsing. Set resource limits for parsing operations.

---

## Key controls checklist

- [ ] Code signing for application and all distributed components
- [ ] Secure auto-update mechanism (HTTPS + signature verification + rollback)
- [ ] DLL/dylib load path hardening
- [ ] Sensitive data encrypted using OS credential storage (Keychain, DPAPI, Secret Service)
- [ ] Electron: nodeIntegration disabled, contextIsolation enabled, sandbox enabled
- [ ] File format parsers fuzzed and sandboxed
- [ ] IPC mechanisms authenticated and input-validated
- [ ] No sensitive data in logs, crash reports, or temp files
- [ ] TLS for all network communication with certificate validation
- [ ] Plugin/extension system with permission model and signature verification
- [ ] Installer does not create world-writable directories or temp files
- [ ] Memory safety protections (ASLR, DEP, stack canaries enabled)

## Company practices

- **Microsoft**: SDL for all desktop products, MSRC for vulnerability response, Defender for Endpoint integration, strict code signing
- **Apple**: Gatekeeper and Notarization required, App Sandbox for Mac App Store, hardened runtime
- **Spotify**: Electron security hardening, automated security testing, centralized update mechanism
- **1Password**: Memory-safe Rust core, process isolation for sensitive operations, security audits by third parties

## Tools and standards

- **SAST**: Semgrep, CodeQL, PVS-Studio (C/C++)
- **DAST**: Fuzzing (AFL++, libFuzzer), process monitor, API monitor
- **Electron**: Electronegativity (security checker), electron-builder security
- **Standards**: OWASP Desktop Top 10 2021, CWE memory safety entries, platform-specific security guidelines
