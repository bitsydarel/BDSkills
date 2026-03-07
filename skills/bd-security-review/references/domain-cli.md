# Security Review — CLI Tools

## Domain context

CLI tools run with the user's full shell permissions — they can read files, execute commands, access environment variables, and modify the system. Unlike sandboxed web or mobile apps, CLI tools inherit the user's entire permission context. CLI-specific risks include argument injection, unsafe shell expansion, environment variable manipulation, pipe/redirect vulnerabilities, and POSIX signal handling. Developer tools (package managers, build tools, linters) are particularly sensitive because they are often part of the software supply chain and may execute arbitrary code from untrusted sources.

## Framework mapping

There is no dedicated OWASP list for CLI tools. Security guidance comes from POSIX security standards, CWE entries for command injection, and supply chain security frameworks.

| Reference | Relevance | Mapped Criteria |
|-----------|-----------|----------------|
| CWE-78 (OS Command Injection) | Primary injection risk | A3 |
| CWE-88 (Argument Injection) | CLI-specific injection | A3 |
| CWE-426 (Untrusted Search Path) | PATH manipulation | O3, A6 |
| CWE-427 (Uncontrolled Search Path) | Dynamic library loading | A6 |
| SLSA / SBOM | Package manager supply chain | A5 |

## Criterion interpretation for CLI tools

| Criterion | CLI-Specific Interpretation |
|-----------|---------------------------|
| T1 | Map all input sources: command-line arguments, stdin, environment variables, config files, piped input, file arguments |
| T2 | STRIDE for CLI: argument injection as tampering, env var leakage as info disclosure, signal handling as DoS, PATH manipulation as elevation |
| T3 | Shell → CLI tool → child processes is the trust chain. Environment variables cross trust boundaries. Piped input from other commands is untrusted |
| A1 | API key/token handling for CLI tools that call services. Credential storage (not in shell history, not in plaintext config). OAuth device flow for user authentication |
| A2 | File permission checks before reading/writing. Respecting umask. No writing to world-writable locations. Privilege dropping after initialization |
| A3 | Argument parsing with validated types (no raw string expansion). Shell metacharacter escaping. Safe subprocess invocation (exec-style, not shell-style). Path traversal prevention |
| A4 | TLS for all network communication. Credential encryption in config files. No sensitive data in command-line arguments (visible in process listing output) |
| A5 | For package managers: dependency resolution security, registry authenticity. For build tools: build script safety. Plugin/extension vetting |
| A6 | Memory safety for native CLI tools. Signal handler safety (async-signal-safe functions only). Temp file creation (mkstemp, not predictable names). Resource limits |
| A7 | Clear output for security-sensitive operations. Confirmation prompts for destructive actions. No silent overwrites. Progress indicators for long operations |
| O1 | Structured output for log aggregation. Verbosity levels. Audit logging for security-relevant operations |
| O3 | Secure default configuration. Config file permissions (600/400). No world-readable credential files. XDG Base Directory compliance |

## Top 5 CLI-specific anti-patterns

### 1. Shell Injection via Arguments

**Signs**: User-supplied arguments passed directly to shell execution functions (the `system` libc call, Python's shell=True subprocess mode, backtick evaluation in scripts). String interpolation in shell commands without escaping.

**Impact**: Attacker-controlled arguments execute arbitrary commands with the tool's permissions. Filenames containing shell metacharacters trigger code execution.

**Fix**: Use subprocess APIs with argument arrays (Python: `subprocess.run(["cmd", arg])`, Go: `exec.Command("cmd", arg)`), never shell mode with user input. Validate and sanitize all arguments. Escape shell metacharacters if shell invocation is unavoidable.

---

### 2. Environment Variable Trust

**Signs**: Security-sensitive behavior controlled by environment variables without validation. PATH, LD_PRELOAD, LD_LIBRARY_PATH, PYTHONPATH not sanitized when running with elevated privileges. Secrets read from environment variables and passed to child processes.

**Impact**: PATH manipulation causes the tool to execute attacker-controlled binaries. LD_PRELOAD injects malicious code. Environment variables leak to child processes (and their crash reports, logs, and traces).

**Fix**: Sanitize PATH and library path variables for privileged operations. Do not inherit full environment to child processes — explicitly pass only needed variables. Read secrets from files or credential stores, not environment variables.

---

### 3. Predictable Temp Files

**Signs**: Temp files created with predictable names in shared directories. Insecure temp file creation functions used instead of `mkstemp`/`mkdtemp`. Temp files created in world-writable directories without exclusive access flags. Temp files containing sensitive data not cleaned up.

**Impact**: Symlink attacks: attacker creates a symlink at the predictable path pointing to a sensitive file, and the tool overwrites it. Race conditions (TOCTOU) between temp file check and use.

**Fix**: Use `mkstemp()` / `mkdtemp()` for secure temp file creation. Set restrictive permissions (600) on temp files. Clean up temp files in all code paths (including error handling). Use O_EXCL flag for exclusive creation.

---

### 4. Credential Leakage

**Signs**: API keys/tokens passed as command-line arguments (visible in process listings, shell history). Credentials stored in plaintext config files with default permissions. Secrets logged to stdout/stderr during verbose mode.

**Impact**: Other users on the system see credentials via process listing tools or /proc/*/cmdline. Shell history files contain credentials. Verbose logging captures and persists secrets.

**Fix**: Read credentials from files, stdin, or credential helpers (git credential helpers, AWS credential chain) — never from command-line arguments. Set 600 permissions on credential files. Mask secrets in all log/debug output. Clear sensitive data from memory after use.

---

### 5. Unsafe Plugin/Extension Loading

**Signs**: Plugins loaded from user-writable directories without integrity verification. No plugin permission model. Plugins execute with full tool permissions. Auto-discovery of plugins from PATH or predefined directories.

**Impact**: Malicious plugins (placed by another user, malware, or supply chain attack) execute arbitrary code with the tool's permissions. Plugin auto-loading means the user may not even be aware a plugin is active.

**Fix**: Plugin directories with restricted permissions. Plugin signature verification before loading. Plugin permission model (network access, file access, subprocess). Explicit plugin enable (not auto-discovery). Plugin audit logging.

---

## Key controls checklist

- [ ] All subprocess invocations use argument arrays, not shell strings
- [ ] Shell metacharacters escaped or validated in all user inputs
- [ ] Environment variables sanitized for privileged operations (PATH, LD_PRELOAD)
- [ ] Credentials read from files/credential helpers, not command-line arguments
- [ ] Credential files have restrictive permissions (600)
- [ ] Temp files created with mkstemp/mkdtemp with exclusive access
- [ ] Destructive actions require explicit confirmation (--force flag or interactive prompt)
- [ ] No sensitive data in log output at any verbosity level
- [ ] TLS for all network communication with certificate verification
- [ ] Config files follow XDG Base Directory specification
- [ ] Signal handlers use only async-signal-safe functions
- [ ] Plugin/extension loading with integrity verification

## Company practices

- **GitHub**: GitHub CLI (gh) uses OAuth device flow for auth, keychain-based credential storage, structured JSON output for scripting
- **HashiCorp**: Terraform CLI with state encryption, plugin signature verification, credential helpers, sensitive value masking in output
- **Docker**: Docker CLI with credential helpers, content trust (image signing), BuildKit for secure build isolation
- **Google**: gcloud CLI with application default credentials, structured logging, project-scoped access

## Tools and standards

- **Static Analysis**: ShellCheck (shell scripts), Bandit (Python CLI), Semgrep rules for subprocess injection
- **Fuzzing**: AFL++ for native CLI tools, property-based testing for CLI argument fuzzing
- **Standards**: CWE-78/88 (command/argument injection), POSIX security guidelines, XDG Base Directory Specification
