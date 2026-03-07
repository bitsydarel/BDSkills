# Anti-patterns: Input Validation & XSS

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure — with dedicated coverage of advanced Cross-Site Scripting (XSS) patterns that go beyond basic reflected XSS. Modern XSS exploits leverage rendering context confusion, DOM manipulation, mutation-based parser differentials, and framework-specific escape hatches. These patterns persist because developers assume framework auto-escaping is comprehensive when it only covers the HTML body context.

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

## Output Encoding Context Confusion — Critical

**Signs**: Applying HTML entity encoding universally regardless of the rendering context. HTML-encoding data that is inserted into JavaScript contexts (inline scripts, event handlers, JSON embedded in HTML). Using the same encoding function for HTML attributes, URL parameters, CSS values, and JavaScript strings. Encoding for HTML body context but inserting into an unquoted HTML attribute. Trusting that framework auto-escaping handles all contexts (it only handles HTML body).

**Impact**: HTML entity encoding prevents XSS in the HTML body context but is ineffective or bypassable in other contexts. In JavaScript context: `&quot;` is still interpreted as a quote by the JavaScript parser — the HTML entity is decoded before JavaScript runs. In URL context: HTML encoding does not prevent `javascript:` protocol handlers. In CSS context: expression functions and url() values are unaffected by HTML encoding. In unquoted HTML attributes: spaces and other characters break out of the attribute without needing quotes. Each rendering context has its own set of dangerous characters and requires its own encoding scheme.

**Fix**: Apply context-specific output encoding. HTML body: HTML entity encoding (`&`, `<`, `>`, `"`, `'`). HTML attribute (quoted): HTML attribute encoding. JavaScript: JavaScript string escaping (hex encode all non-alphanumeric characters, or use `JSON.stringify()`). URL parameter: URL percent encoding. CSS: CSS hex encoding. Use established encoding libraries: OWASP Java Encoder, DOMPurify for HTML sanitization, built-in framework encoders. Never insert user data into contexts that cannot be safely encoded: inline JavaScript blocks, CSS expression values, or script tag bodies.

**Detection**:
- *Code patterns*: Single encoding function used across all contexts; user data in `onclick`, `onload`, or other event handler attributes; user data inside inline script tags; user data in `style` attributes or style tags; HTML-encoded data in JavaScript template literals or JSON-in-HTML
- *Review questions*: Are different encoding functions used for HTML body, attributes, JavaScript, URLs, and CSS? Is user data ever placed in inline JavaScript, event handlers, or CSS?
- *Test methods*: Identify all locations where user data is rendered. For each, determine the rendering context and test with context-specific payloads. Test HTML attribute context with `" onmouseover=alert(1) x="`. Test JavaScript context with string-breaking characters. Test URL context with `javascript:` protocol

---

## DOM XSS Blind Spot — Critical

**Signs**: Security review that only checks server-side output encoding, ignoring client-side JavaScript that manipulates the DOM with user-controlled data. No review of JavaScript code for dangerous sink functions. User input flowing from URL fragments (`location.hash`), URL parameters (`location.search`), `document.referrer`, `window.name`, or `postMessage` events into DOM manipulation functions. Single-page applications (SPAs) that perform all rendering client-side.

**Impact**: DOM-based XSS runs entirely in the browser — the malicious payload never reaches the server, bypassing all server-side XSS protections (WAF, server-side encoding, CSP nonce for server-rendered scripts). The attack flow: user-controlled source (URL fragment, postMessage data) flows through JavaScript code into a dangerous sink (innerHTML, outerHTML, document.write, insertAdjacentHTML, jQuery `.html()`, `.append()`, Angular security trust bypass, React refs with raw HTML insertion). Server-side logging never sees the payload because it exists only in the URL fragment or client-side state.

**Fix**: Audit all JavaScript code for source-to-sink data flows. Use `textContent`/`innerText` instead of `innerHTML` when inserting user data. Use `createElement` + `textContent` instead of HTML string construction. In React: never use refs to set innerHTML; use JSX expressions which are auto-escaped. In Angular: never use security trust bypass methods with user data. In Vue: use `v-text` instead of `v-html` for user data. Implement Trusted Types API (`Content-Security-Policy: require-trusted-types-for 'script'`) to block dangerous sink usage at the browser level.

**Detection**:
- *Code patterns*: `element.innerHTML = userInput`; `jQuery.html(userInput)`; `document.write(userInput)`; reading from `location.hash`, `location.search`, `document.referrer`, or `window.name` and passing to DOM sinks; `postMessage` event handlers that trust message data without origin validation
- *Review questions*: Has client-side JavaScript been audited for source-to-sink data flows? Are DOM manipulation functions using safe alternatives (textContent vs innerHTML)? Does the application use Trusted Types?
- *Test methods*: Use DOM XSS scanners (Semgrep DOM XSS rules, DOM Invader in Burp Suite). Inject payloads via URL fragments and parameters. Test postMessage handlers with crafted messages from different origins. Search JavaScript for all uses of dangerous sinks and trace data sources

---

## Sanitizer Bypass via Mutation XSS — Major

**Signs**: Using HTML sanitization (DOMPurify, Bleach, HtmlSanitizer) to clean user HTML before insertion, but the sanitized HTML is re-parsed by a different parser with different parsing rules. Sanitizing HTML on the server (using a library parser) and serving it to a browser (which uses a different parser). Sanitizing HTML and inserting it via innerHTML into a context that triggers browser parsing quirks (mutation). Using outdated sanitizer library versions with known mutation XSS bypasses.

**Impact**: Mutation XSS (mXSS) exploits the difference between how the sanitizer parses HTML and how the browser renders it. The sanitizer sees safe HTML, but when the browser re-parses the sanitized output, DOM mutations create code that runs. Parser differentials between server-side libraries and browsers are the root cause. Classic examples involve noscript tag parsing differences, math/svg namespace confusion, and encoding edge cases where sanitizer and browser disagree on the parse tree.

**Fix**: Keep sanitizer libraries updated to the latest version (mXSS bypasses are patched regularly). DOMPurify is the most resilient against mXSS because it runs in the browser's own parser. Prefer client-side sanitization with DOMPurify over server-side sanitization with a different parser. When server-side sanitization is required, use a sanitizer that emulates browser parsing behavior. Set DOMPurify `RETURN_DOM` or `RETURN_DOM_FRAGMENT` instead of string output to avoid re-parsing. Implement Trusted Types as a defense-in-depth layer.

**Detection**:
- *Code patterns*: Server-side HTML sanitization followed by client-side innerHTML insertion; outdated sanitizer library versions; sanitizer output inserted into contexts that trigger re-parsing; custom HTML sanitizers (never as robust as DOMPurify)
- *Review questions*: Is the HTML sanitizer running in the same parser environment as the browser? When was the sanitizer library last updated? Are there known mXSS bypasses for the current version?
- *Test methods*: Test with known mXSS payloads for the specific sanitizer in use. Check sanitizer version against CVE databases. Test sanitized output by inserting via innerHTML and checking for mutations. Use DOMPurify's test suite payloads against custom or alternative sanitizers

---

## Framework Trust Escalation — Major

**Signs**: Using framework escape hatches that bypass built-in XSS protection. React: using refs to set innerHTML on DOM elements (bypassing JSX auto-escaping) or using the dangerouslySetInnerHTML prop. Angular: calling security trust bypass methods (bypassSecurityTrustHtml, bypassSecurityTrustUrl) with user-controlled data. Vue: using `v-html` directive with user input. Svelte: using `{@html userInput}`. These escape hatches exist for legitimate use cases (rendering trusted rich text) but are dangerous when applied to untrusted data.

**Impact**: Modern frameworks provide XSS protection by default — JSX auto-escapes in React, Angular sanitizes by default, Vue uses `v-text` safely. The escape hatches bypass these protections entirely. Developers use them because "the HTML is already sanitized" (but the sanitization may be incomplete) or "it comes from our database" (but the database may contain stored XSS payloads). A single use of an escape hatch with user data creates an XSS vulnerability despite the framework's built-in protections.

**Fix**: Treat all framework escape hatches as security-sensitive and require security review. React: if raw HTML must be rendered, sanitize with DOMPurify first. Angular: never call trust bypass methods with data that originates from user input, even if transformed. Vue: use `v-text` for user data; if `v-html` is needed, sanitize with DOMPurify first. For all frameworks: implement Trusted Types to enforce sanitization at the browser level. Add linting rules to flag escape hatch usage in code review.

**Detection**:
- *Code patterns*: React refs with `element.innerHTML`; Angular DomSanitizer bypass calls with user-controlled input; Vue `v-html` bound to user-controlled data; Svelte `{@html ...}` with user data; React dangerouslySetInnerHTML prop with unsanitized input
- *Review questions*: Are framework XSS escape hatches used anywhere in the codebase? If so, does the data flow through sanitization (DOMPurify) before reaching the escape hatch? Is there a linting rule flagging escape hatch usage?
- *Test methods*: Search codebase for all escape hatch patterns. Trace data sources for each occurrence — if any source is user-controlled (even indirectly via database), it is a finding. Test with XSS payloads in the data that flows to escape hatches. Verify sanitization occurs before the escape hatch, not after

---

## CSP as Silver Bullet — Major

**Signs**: Deploying Content Security Policy (CSP) as the sole XSS mitigation instead of combining it with proper output encoding. CSP headers that include `unsafe-inline` (negating most XSS protection). CSP with `unsafe-eval` (allowing code generation from strings). CSP with overly broad source allowlists (e.g., `*.googleapis.com` which hosts user-uploaded content). CSP in report-only mode permanently (never enforced). No CSP reporting endpoint configured to detect violations.

**Impact**: CSP is a defense-in-depth layer, not a replacement for output encoding. `unsafe-inline` effectively disables CSP's XSS protection — inline scripts and event handlers still run. Even strict CSP can be bypassed via: JSONP endpoints on allowed domains, Angular/Vue template injection on allowed CDN origins, base tag injection to redirect script loads, and CSS-based data exfiltration. CSP does not prevent DOM XSS from sources like `location.hash`. Relying solely on CSP while leaving encoding gaps creates a false sense of security.

**Fix**: Implement CSP as one layer in a defense-in-depth strategy alongside proper output encoding. Use strict CSP: `script-src 'nonce-{random}'` or `script-src 'strict-dynamic'` with nonces. Remove `unsafe-inline` and `unsafe-eval`. Avoid domain-based allowlists — use nonces or hashes. Deploy CSP in report-only mode first, then enforce after reviewing reports. Configure CSP reporting to detect violations. Combine with Trusted Types for DOM XSS prevention. Keep CSP as lean as possible — every additional allowed source is potential bypass.

**Detection**:
- *Code patterns*: CSP header containing `unsafe-inline` or `unsafe-eval`; domain-based allowlists in CSP instead of nonces; CSP in report-only mode without a planned enforcement date; no CSP report-uri or report-to configured; output encoding missing or incomplete despite CSP being deployed
- *Review questions*: Does CSP use nonces/hashes or domain allowlists? Are `unsafe-inline` and `unsafe-eval` present? Is CSP in enforcement mode? Is output encoding implemented independently of CSP? Are CSP violation reports monitored?
- *Test methods*: Analyze CSP header with Google CSP Evaluator or CSP Scanner. Test for XSS bypasses using allowed domains (check for JSONP endpoints, open redirects, or user-uploaded content on allowed origins). Verify that removing CSP still does not enable XSS (output encoding should be the primary defense). Check CSP reporting for violations

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
| Output Encoding Context Confusion | Critical | A3: Input Validation | Both |
| DOM XSS Blind Spot | Critical | A3: Input Validation | Implementation |
| Sanitizer Bypass via Mutation XSS | Major | A3: Input Validation | Implementation |
| Framework Trust Escalation | Major | A3: Input Validation | Implementation |
| CSP as Silver Bullet | Major | A7: UI/UX Security | Both |
