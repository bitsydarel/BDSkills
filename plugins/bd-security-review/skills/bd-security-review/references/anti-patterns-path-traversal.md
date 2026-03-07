# Anti-patterns: Input Validation & Path Traversal

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure — with dedicated coverage of path traversal (directory traversal), where user-controlled file paths escape the intended directory to access arbitrary files on the filesystem. Path traversal remains prevalent because developers underestimate the diversity of bypass techniques: encoding variants, platform-specific separators, symlink resolution, and archive extraction all create unexpected escape routes from constrained directories.

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

## Blocklist-Based Path Sanitization — Critical

**Signs**: Stripping `../` sequences from user input before constructing file paths. Using string replacement to remove traversal sequences: `path.replace('../', '')`, `path.replaceAll('\\.\\./', '')`. Blocklist of dangerous path components without canonicalization. Filtering `..` but not checking the resolved path against the intended base directory. Single-pass replacement that can be bypassed by nesting: `....//` becomes `../` after one replacement pass.

**Impact**: Path traversal blocklists are fundamentally unreliable. Bypass techniques include: encoding variants (`%2e%2e%2f`, `%252e%252e%252f` for double encoding, `..%c0%af` for overlong UTF-8), nested sequences (`....//` becomes `../` after filtering), platform-specific separators (`..\\` on Windows, `..\` mixed separators), null byte injection (`../../../etc/passwd%00.jpg` in languages with C-string handling), and Unicode normalization attacks. A single missed variant grants full filesystem read access.

**Fix**: Never filter or sanitize path traversal sequences — instead, resolve the final path and validate it. Canonicalize the path (`os.path.realpath()` in Python, `Path.toRealPath()` in Java, `fs.realpathSync()` in Node.js) and then check that it starts with the intended base directory. This is the only reliable approach because canonicalization handles all encoding, normalization, and resolution automatically.

**Detection**:
- *Code patterns*: `input.replace('../', '')` or `input.replaceAll('\\.\\./', '')`; regex-based path filtering; blocklists of traversal sequences; path validation without canonicalization; string prefix check on non-canonicalized paths
- *Review questions*: Is path validation based on filtering dangerous sequences or validating the resolved path? Is the path canonicalized before the base directory check?
- *Test methods*: Test with encoding variants: `%2e%2e%2f`, `%252e%252e%252f`, `..%c0%af`. Test with nested sequences: `....//`, `..././`. Test with mixed separators on Windows: `..\\`, `..\\/`. Test with null bytes if applicable. Verify that the final resolved path stays within the intended directory

---

## Relative Path Trust — Critical

**Signs**: Constructing file paths by concatenating a base directory with user-supplied input without canonicalization. Code like `base_dir + '/' + user_input` where `user_input` is validated only by checking it does not contain `../`. String prefix checks performed on the raw (non-resolved) path. Accepting paths that contain symlinks, junctions, or hardlinks without resolving them first. Using `path.join()` without subsequent canonicalization — `path.join('/uploads', '../../../etc/passwd')` resolves to `/etc/passwd` in most implementations.

**Impact**: `path.join()` and string concatenation do not guarantee the result stays within the base directory. `path.join('/safe/uploads', '../../../etc/passwd')` produces `/etc/passwd`. A string prefix check on the joined path catches obvious cases but fails when the path contains symbolic links (the prefix check sees `/safe/uploads/link/file` but the symlink points to `/etc/`). Without canonicalization, the validation operates on a path that does not represent the actual filesystem location.

**Fix**: Canonicalize the path after joining: `os.path.realpath(os.path.join(base, user_input))` then verify it starts with `os.path.realpath(base)`. In Java: `Paths.get(base, userInput).toRealPath()` then `startsWith(Paths.get(base).toRealPath())`. The canonicalization resolves symlinks, normalizes separators, and eliminates `.` and `..` components. Both the base and the result must be canonicalized for the prefix check to be reliable.

**Detection**:
- *Code patterns*: `os.path.join(base, user_input)` without subsequent `realpath()`; `Paths.get(base, input).toString()` without `toRealPath()`; string `startsWith()` check on non-canonicalized paths; `path.resolve()` in Node.js without follow-up containment check
- *Review questions*: Is the constructed file path canonicalized before the base directory check? Are both the constructed path and the base directory canonicalized? Does the path resolution follow symlinks?
- *Test methods*: Submit paths with `../` sequences and verify rejection. Create a symlink inside the upload directory pointing outside and verify the application follows canonicalized paths. Test `path.join()` behavior with absolute paths in user input (e.g., `/etc/passwd` as user input may override the base on some platforms)

---

## Symlink Blind Spot — Major

**Signs**: Path traversal validation that does not resolve symbolic links before checking containment. Upload directories where users can create files without symlink restrictions. File serving logic that checks the path string but follows symlinks when reading the file. Container volume mounts or shared filesystems where symlinks can point across mount boundaries. No use of `O_NOFOLLOW` or equivalent when opening files.

**Impact**: An attacker creates a symbolic link inside the allowed directory that points to a sensitive file outside it. The path check sees `/uploads/user123/profile.jpg` (inside the uploads directory) but the symlink resolves to `/etc/shadow`. The file is read and served through the legitimate path. This bypasses all path string-based validation because the path itself is valid — only the resolution is malicious. On Linux, symlinks in `/proc/self/` provide access to environment variables, file descriptors, and memory.

**Fix**: Resolve symlinks before path validation using `os.path.realpath()` or `Path.toRealPath()`. Set `O_NOFOLLOW` flag when opening files to prevent following symlinks at the final path component. On Linux, use `openat2()` with `RESOLVE_NO_SYMLINKS` for comprehensive symlink restriction. Restrict symlink creation in upload directories using filesystem-level controls. Mount upload directories with `nosymfollow` option if supported. Verify that the resolved path (not just the string path) resides within the intended directory.

**Detection**:
- *Code patterns*: `open(path)` without `O_NOFOLLOW`; path containment checks without `realpath()` resolution; upload directories without symlink restrictions; file serving that does not resolve symlinks before the access control check
- *Review questions*: Does the file access code resolve symlinks before checking containment? Can users create files (including symlinks) in the upload directory? Is `O_NOFOLLOW` or equivalent used when opening user-referenced files?
- *Test methods*: Create a symlink in the upload directory pointing to `/etc/passwd` and attempt to read it through the application. Test with `/proc/self/environ` symlink targets. Verify that `realpath()` is called before the containment check. Check if the filesystem supports and enforces symlink restrictions

---

## Zip Slip — Major

**Signs**: Archive extraction (ZIP, TAR, JAR, WAR, CPIO, 7z) that writes files to disk without validating extracted file paths against the intended destination directory. Using library defaults for extraction without path validation. Extracting archives uploaded by users or received from untrusted sources. Code that calls `ZipFile.extractall()`, `TarFile.extractall()`, or equivalent without checking member paths for traversal sequences.

**Impact**: An attacker crafts an archive containing entries with traversal paths like `../../../etc/cron.d/malicious` or `../../.ssh/authorized_keys`. When extracted, these paths resolve outside the intended directory, overwriting arbitrary files. This enables: remote code execution (overwriting web shells, cron jobs, SSH keys, application code), configuration tampering, and persistence. The Zip Slip vulnerability (Snyk, 2018) affected thousands of projects across all major languages and frameworks because most archive libraries extract to the provided path without validation.

**Fix**: Before writing each extracted file, resolve its full path and verify it starts with the intended extraction directory (canonicalized prefix check). Python: for each member in `ZipFile`, check `os.path.realpath(os.path.join(dest, member.filename)).startswith(os.path.realpath(dest))`. Java: canonicalize the entry path and verify containment. Reject any archive entry with a path that escapes the destination. Use `TarFile.extractall(filter='data')` in Python 3.12+ for automatic safety. Never use `extractall()` without per-entry validation on older versions.

**Detection**:
- *Code patterns*: `ZipFile.extractall()` or `TarFile.extractall()` without per-entry path validation; archive extraction without canonicalized path containment check; `entry.getName()` in Java used directly for file creation without traversal check
- *Review questions*: Does the archive extraction code validate each entry's path before writing? Is the validation based on canonicalized path containment? Are all archive formats handled (ZIP, TAR, JAR, WAR, 7z)?
- *Test methods*: Create a ZIP file with an entry named `../../../tmp/zipslip_test.txt` and upload it. Check if the file appears at `/tmp/zipslip_test.txt`. Use evilarc or zipslip tools to generate test archives. Test with TAR, JAR, and other supported formats separately

---

## Platform-Agnostic Path Handling — Major

**Signs**: Path traversal protection written for one OS but deployed on another. Checking for `/` separators only (misses `\` on Windows). Checking for `\` separators only (misses `/` on Linux). Case-sensitive path comparison on Windows (where the filesystem is case-insensitive). Not accounting for Windows-specific path features: drive letters (`C:\`), UNC paths (`\\server\share`), device names (`CON`, `NUL`, `AUX`, `COM1`), alternate data streams (`file.txt::$DATA`), and 8.3 short names (`PROGRA~1`).

**Impact**: Cross-platform applications frequently have path traversal vulnerabilities on the platform they were not primarily developed on. A Linux-developed application deployed on Windows may accept `..\\` because it only filters `../`. Windows-specific features create additional attack surface: reserved device names (`CON`, `NUL`, `COM1`, `LPT1`) can cause denial of service when used as filenames, UNC paths can trigger SMB authentication to attacker-controlled servers (NTLM hash capture), alternate data streams hide data within existing files, and 8.3 short names bypass long-name-based filters.

**Fix**: Use the platform's canonical path resolution for all validation — it handles separators, case sensitivity, and special names automatically. On Windows: additionally block reserved device names, UNC paths, alternate data streams, and validate against 8.3 short name equivalents. Use framework-provided file path validation when available. Test path validation on every target platform. When writing cross-platform code, use `os.path` (Python), `java.nio.file.Path` (Java), or `path` (Node.js) — never string manipulation for path handling.

**Detection**:
- *Code patterns*: Path separator hardcoded as `/` or `\\` instead of using `os.sep` or `path.sep`; case-sensitive path comparison on Windows; no check for UNC paths, device names, or alternate data streams; path validation using string manipulation instead of platform APIs
- *Review questions*: Does the path validation work correctly on all target platforms? Does it handle Windows-specific features (UNC, device names, ADS, 8.3 names)? Is the path separator handling platform-independent?
- *Test methods*: On Windows: test with `..\\`, UNC paths (`\\\\attacker\\share\\file`), device names (`CON`, `NUL`), alternate data streams (`file.txt::$DATA`), 8.3 names. On Linux: test with null bytes (if applicable), symlinks, paths with spaces and special characters. Test the same application on both platforms with identical payloads

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
| Blocklist-Based Path Sanitization | Critical | A3: Input Validation | Both |
| Relative Path Trust | Critical | A3: Input Validation | Both |
| Symlink Blind Spot | Major | A3: Input Validation | Implementation |
| Zip Slip | Major | A3: Input Validation | Both |
| Platform-Agnostic Path Handling | Major | A3: Input Validation | Both |
