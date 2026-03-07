# Anti-patterns: Input Validation & Insecure File Upload

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure — with dedicated coverage of insecure file upload vulnerabilities, where insufficient validation of uploaded files allows attackers to place executable content, malicious archives, or oversized payloads on the server. File upload is a persistent attack vector because it combines multiple validation challenges: extension, content type, file content, filename, size, and storage location must all be validated correctly.

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

## Extension-Only Validation — Critical

**Signs**: File upload validation checks only the file extension (`.endsWith('.jpg')`, `.split('.').pop()`) without verifying file content. Blocklist of dangerous extensions (`.php`, `.exe`, `.jsp`) instead of an allowlist of permitted ones. Extension check applied to the last extension only, missing double extensions (`shell.php.jpg`). No verification of MIME type or magic bytes. Relying on the client-sent `Content-Type` header for validation.

**Impact**: Attackers rename executable files to bypass extension checks: `webshell.php` becomes `webshell.php.jpg` (Apache may execute this with misconfigured handlers), or `webshell.php%00.jpg` (null byte injection in older systems truncates to `.php`). Polyglot files that are valid as both images and executable code pass extension checks while remaining executable. Without magic byte verification, a file with `.jpg` extension containing PHP code will be served and executed by misconfigured servers.

**Fix**: Validate using multiple layers: extension allowlist (not blocklist), MIME type verification from the file content (not the client-sent header), and magic byte validation. Use a library to detect actual file type from content (python-magic, file-type for Node.js, Apache Tika for Java). Reject files that fail any validation layer. Store uploaded files with server-generated names and extensions, not user-provided ones. Never rely on a single validation method.

**Detection**:
- *Code patterns*: `filename.endsWith('.jpg')` or `filename.split('.').pop()` as sole validation; blocklist of extensions instead of allowlist; no magic byte or content-type-from-content check; `request.files[0].content_type` used for validation (client-controlled)
- *Review questions*: Is file type validated by content (magic bytes) or only by extension? Is the extension check an allowlist or a blocklist? Is the client-sent Content-Type header trusted?
- *Test methods*: Upload a PHP/JSP file renamed to `.jpg` and check if the server accepts it. Upload a polyglot file (valid JPEG header + embedded code). Test double extensions (`.php.jpg`). Test null byte injection in filename if applicable

---

## Upload-to-Execution Directory — Critical

**Signs**: Uploaded files stored in a directory served by the web server with execution enabled. Upload directory inside the web root (`public/uploads/`, `static/uploads/`, `wwwroot/uploads/`). No server configuration to disable script execution in the upload directory. Uploaded files accessible via a direct URL that triggers server-side processing (e.g., `https://app.com/uploads/shell.php`).

**Impact**: If an attacker uploads a web shell (PHP, JSP, ASPX, or any server-side script) to a directory where the web server executes scripts, they gain remote code execution on the server. This is the most direct file upload exploitation path. The attacker uploads a script, accesses it via URL, and gains a command shell on the server. This enables: data exfiltration, lateral movement, persistence, and full server compromise.

**Fix**: Store uploaded files outside the web root entirely. Serve files through a controller/handler that reads the file content and sets appropriate headers (Content-Type, Content-Disposition: attachment). If files must be in the web root, disable all script execution in the upload directory (Apache: `php_flag engine off` or `RemoveHandler .php`; Nginx: `location /uploads { deny all; }`). Use a separate storage service (S3, GCS, Azure Blob) with no execution capability. Serve files from a separate domain (e.g., `uploads.example.com`) with no server-side scripting configured.

**Detection**:
- *Code patterns*: Upload path inside web root (`os.path.join(app.static_folder, 'uploads')`); no web server configuration disabling execution in upload directory; direct URL mapping to uploaded files without a serving controller; uploaded files served with original filename and extension
- *Review questions*: Where are uploaded files stored relative to the web root? Can uploaded files be accessed directly via URL? Is script execution disabled in the upload directory? Are files served through a controller or directly by the web server?
- *Test methods*: Upload a server-side script (PHP, JSP, ASPX) and attempt to access it via URL. Check if the server executes the script or returns it as a download. Verify web server configuration for the upload directory. Check if the upload directory is inside the document root

---

## Filename Trust — Major

**Signs**: Using the original filename provided by the client for storage. Storing files as `uploads/{original_filename}` without sanitization. Accepting filenames with path separators (`../`, `..\\`), null bytes, or special characters. No protection against filename collisions (a new upload with the same name overwrites the previous file). Filenames containing characters that are problematic on certain filesystems (Windows reserved names, Unicode normalization issues).

**Impact**: Path traversal via filename: `../../etc/cron.d/backdoor` places a file outside the upload directory. Filename overwrite: uploading `index.html` or `.htaccess` replaces critical application files. Null byte injection: `shell.php%00.jpg` may truncate to `shell.php` on some systems. Cross-site scripting via filename: filenames displayed in the UI without encoding can inject JavaScript. Denial of service: extremely long filenames or filenames with special Unicode characters can cause filesystem errors.

**Fix**: Generate a random filename (UUID) on the server and maintain a mapping to the original filename in the database. If the original filename must be preserved, apply strict allowlist sanitization (`[a-zA-Z0-9._-]` only, maximum length, no path separators). Use the original filename only for display purposes, never for storage. Implement collision detection. Store the content type and original filename as metadata, separate from the file system name.

**Detection**:
- *Code patterns*: `file.save(os.path.join(upload_dir, file.filename))` using original filename; no filename sanitization function; `secure_filename()` used but path validation missing; filename used in URL without encoding
- *Review questions*: Are uploaded files stored with the original filename or a server-generated name? Is the filename sanitized? Can a filename contain path separators? Is there collision protection?
- *Test methods*: Upload files with path traversal filenames (`../../../tmp/test.txt`). Upload files with special characters and null bytes in the name. Upload two files with the same name and check for overwrite. Upload a file named `.htaccess` or `web.config`

---

## Client-Side Content-Type Trust — Major

**Signs**: Validating uploaded file type by reading the `Content-Type` header from the HTTP request (set by the client) instead of inspecting the file content. Using `request.files[0].content_type` or `request.content_type` as the authoritative file type. MIME type check using only the client-sent header without cross-referencing against magic bytes. Anti-virus or image processing applied based on the client-declared type, potentially skipping analysis for "safe" types.

**Impact**: The `Content-Type` header is entirely client-controlled — an attacker can set it to any value using a proxy or custom request. Uploading a PHP web shell with `Content-Type: image/jpeg` bypasses any validation that checks only the header. The server stores and potentially serves the file as an image despite it being executable code. This is one of the most common file upload validation bypasses because developers trust the HTTP header without realizing it is attacker-controlled.

**Fix**: Determine the file type from the file content using magic byte analysis (python-magic, file-type, Apache Tika, libmagic). Cross-reference the detected content type against the expected type. Ignore the client-sent Content-Type header for security decisions — use it only as a hint. When serving files, set the Content-Type header based on the server-detected type, not the original upload header. Validate that the detected type matches the allowed types for the upload endpoint.

**Detection**:
- *Code patterns*: `request.files['file'].content_type` or `request.content_type` used for validation decisions; no file content inspection (no python-magic, file-type, or Tika usage); Content-Type from upload stored and re-used when serving the file
- *Review questions*: Is file type determined from file content or from the client-sent Content-Type header? Is magic byte analysis performed on every upload? Is the client-sent Content-Type header used when serving files back to users?
- *Test methods*: Upload a PHP file with `Content-Type: image/jpeg` and verify the server rejects it based on content analysis. Upload a valid JPEG with `Content-Type: application/x-php` and verify the server accepts it based on content (not header). Check what Content-Type is returned when serving uploaded files

---

## Missing Post-Upload Processing — Major

**Signs**: Uploaded files served directly to other users without any processing, re-encoding, or scanning. No anti-virus scan on uploaded files. Images served as-is without re-encoding (which strips embedded scripts and metadata). Documents (PDF, Office) served without scanning for macros or embedded exploits. No size limit enforcement, or limits checked only client-side. No rate limiting on upload endpoints. No metadata stripping (EXIF data with GPS coordinates served to all users).

**Impact**: Without post-upload processing, uploaded files become a vector for: stored XSS via SVG files with embedded JavaScript, malware distribution via infected documents, information disclosure via EXIF metadata (GPS location, device info, timestamps), denial of service via ZIP bombs or decompression bombs, resource exhaustion via extremely large files, and social engineering via legitimate-looking malicious documents shared through the platform.

**Fix**: Process all uploads before serving: re-encode images (strips embedded scripts and metadata), scan documents with anti-virus (ClamAV or cloud-based scanning), strip EXIF/metadata from images before serving, reject SVG uploads or sanitize them rigorously. Enforce file size limits server-side (not just client-side). Rate limit upload endpoints. Store files in quarantine until processing completes. For high-security environments, convert documents to PDF/image format before serving. Set `Content-Disposition: attachment` for all downloads to prevent browser rendering.

**Detection**:
- *Code patterns*: Uploaded files served directly without re-encoding or scanning; no anti-virus library or service integration; images stored and served without metadata stripping; no file size limit in server-side code (only `maxFileSize` in frontend); SVG files accepted without sanitization
- *Review questions*: Are uploaded files processed (re-encoded, scanned, stripped) before being served to other users? Is there anti-virus scanning on uploads? Are image metadata (EXIF) stripped? Are SVG uploads sanitized or rejected?
- *Test methods*: Upload an SVG with embedded JavaScript and check if it renders. Upload a large file (100MB+) and check for server-side size enforcement. Upload an image with EXIF GPS data and check if metadata is served. Upload a known EICAR test file and check for AV scanning. Check Content-Disposition header on served files

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
| Extension-Only Validation | Critical | A3: Input Validation | Both |
| Upload-to-Execution Directory | Critical | A3: Input Validation, O3: Infrastructure | Both |
| Filename Trust | Major | A3: Input Validation | Implementation |
| Client-Side Content-Type Trust | Major | A3: Input Validation | Implementation |
| Missing Post-Upload Processing | Major | A3: Input Validation, A6: Secure Coding | Both |
