# Anti-patterns: Input Validation & Race Conditions

Security anti-patterns related to input handling, injection prevention, error disclosure, and API data exposure — with dedicated coverage of race condition vulnerabilities, where the outcome of operations depends on the timing or ordering of concurrent events. Race conditions in security contexts differ from typical concurrency bugs because they are deliberately exploitable: attackers can precisely time requests to exploit the window between a check and its corresponding action. TOCTOU (Time-of-Check to Time-of-Use) is the core vulnerability pattern.

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

## Check-Then-Act Without Atomicity — Critical

**Signs**: Business logic that reads a value, makes a decision based on it, then modifies the value in separate non-atomic steps. Checking account balance, then deducting — without holding a lock or using a database transaction with appropriate isolation level. Verifying a coupon code has not been used, then marking it as used in separate queries. Checking inventory availability, then reserving stock without `SELECT ... FOR UPDATE` or equivalent. Any pattern where the check and the action can be interleaved by another concurrent request.

**Impact**: By sending multiple simultaneous requests, an attacker exploits the gap between the check and the action. Classic examples: withdrawing more than the account balance (send 10 concurrent withdrawal requests, all pass the balance check before any deduction is committed), redeeming a single-use coupon multiple times, purchasing more inventory than available, voting multiple times in a poll, exceeding rate limits. The window may be milliseconds, but automated tools (Turbo Intruder, race-the-web) reliably exploit it.

**Fix**: Use atomic operations: `UPDATE accounts SET balance = balance - amount WHERE balance >= amount` (the check and action are one atomic SQL statement). Use database transactions with `SERIALIZABLE` isolation or `SELECT ... FOR UPDATE` to lock the row during the check-then-act sequence. Use application-level distributed locks (Redis SETNX, advisory locks) when database-level atomicity is insufficient. For idempotent operations, use unique request identifiers (idempotency keys) to detect and reject duplicate processing.

**Detection**:
- *Code patterns*: `SELECT balance` followed by separate `UPDATE balance` without a transaction or lock; `if (coupon.used == false) { ... coupon.used = true; coupon.save(); }` without atomicity; inventory check and reservation in separate queries; any read-then-write without locking
- *Review questions*: Are financial operations (balance changes, transfers, purchases) atomic? Can the same operation be executed multiple times concurrently? Are database transactions used with appropriate isolation levels?
- *Test methods*: Send 50+ concurrent identical requests using Turbo Intruder or a parallel HTTP client. Verify that the operation executes exactly once (or the correct number of times). Test coupon redemption, balance operations, and inventory operations for double-processing. Monitor database for concurrent transaction conflicts

---

## Optimistic Concurrency Without Conflict Detection — Major

**Signs**: Using optimistic concurrency control (no locks, check at commit time) without proper conflict detection and retry logic. Missing version columns or ETags for conflict detection. `UPDATE ... SET field = value` without a `WHERE version = expected_version` clause. No HTTP 409 Conflict response when concurrent modifications are detected. Silently overwriting changes made by another user or process (last-write-wins without awareness).

**Impact**: Without conflict detection, concurrent modifications silently overwrite each other. In security contexts: a security setting changed by an admin is silently reverted by a concurrent user profile update. Permission changes lost due to concurrent edits. Audit trail entries become inconsistent because they record the intent but not the actual outcome (which was overwritten). In financial systems, optimistic concurrency without detection can lead to balance inconsistencies similar to check-then-act bugs.

**Fix**: Implement version-based optimistic locking: add a `version` column (integer) or `updated_at` timestamp. On update: `UPDATE ... SET field = value, version = version + 1 WHERE id = ? AND version = ?`. If zero rows affected, the version has changed (conflict detected). Return HTTP 409 Conflict to the client with the current version for retry. For APIs, use ETags: return `ETag: "version-hash"` in GET responses, require `If-Match: "version-hash"` on PUT/PATCH, return 412 Precondition Failed on mismatch.

**Detection**:
- *Code patterns*: `UPDATE` statements without version/timestamp conflict detection; missing ETag headers in API responses; no 409 or 412 responses in API error handling; ORM `save()` calls without optimistic locking configuration; last-write-wins updates on security-sensitive fields
- *Review questions*: Do concurrent updates detect and handle conflicts? Is there a version column or ETag mechanism? What happens when two users edit the same resource simultaneously? Are security-sensitive fields (permissions, roles) protected from concurrent modification races?
- *Test methods*: Open the same resource in two browser tabs. Modify it in both tabs and save both. Check if the second save gets a conflict error or silently overwrites the first. Test with concurrent API requests modifying the same resource

---

## File System TOCTOU — Major

**Signs**: Checking file properties (permissions, existence, ownership, type) in one system call, then operating on the file in a separate system call. Using `os.path.exists()` followed by `open()`. Using `os.access()` followed by `os.open()`. Checking if a path is a regular file with `os.path.isfile()` then reading it. Checking file permissions then executing it. Any pattern where the file's state can change between the check and the use, especially in shared or temp directories.

**Impact**: An attacker replaces the file (or creates a symlink to a different file) between the check and the use. Classic attack: program checks that `/tmp/safe_file` is a regular file owned by the current user, then reads it — attacker replaces it with a symlink to `/etc/shadow` between the check and the read. In setuid programs, this enables privilege escalation. In web applications, this enables reading arbitrary files if the temp directory is shared.

**Fix**: Operate on file descriptors (handles) instead of file paths. Open the file first, then check properties on the open file descriptor using `fstat()` instead of `stat()`. Use `O_NOFOLLOW` to prevent following symlinks. Use `mkstemp()` or `tempfile.NamedTemporaryFile()` for secure temporary file creation (creates and opens atomically). On Linux, use `openat2()` with `RESOLVE_NO_SYMLINKS` and `RESOLVE_BENEATH`. Avoid operations in shared writable directories (`/tmp`) when possible — use per-user temporary directories.

**Detection**:
- *Code patterns*: `os.path.exists(path)` followed by `open(path)`; `os.access(path)` followed by `os.open(path)`; `stat()` followed by `open()` on the same path; file operations in `/tmp` or other world-writable directories without atomic creation; check-then-use patterns on file paths in any language
- *Review questions*: Are file property checks and file operations performed atomically (on the same file descriptor)? Are temporary files created securely (mkstemp/NamedTemporaryFile)? Are file operations in shared directories protected against symlink attacks?
- *Test methods*: Identify check-then-use file operation patterns. Attempt symlink replacement between check and use in a test environment. Verify temporary file creation uses atomic methods. Check if file operations use `O_NOFOLLOW` or equivalent

---

## Rate Limit Race — Major

**Signs**: Rate limiting implemented by reading the current count, comparing it to the limit, and then incrementing — as separate non-atomic operations. Rate limit counter stored in application memory (not shared across instances). Rate limiting applied after request processing begins (not at the entry point). No sliding window or token bucket implementation — simple counter reset on a fixed interval.

**Impact**: By sending a burst of concurrent requests, all requests pass the rate limit check before any of them increment the counter. A rate limit of 10 requests per minute can be bypassed by sending 100 concurrent requests — all 100 read the counter as 0, pass the check, and then increment it. This bypasses brute-force protection (password guessing), API abuse prevention, and DoS mitigation. The bypass is proportional to the server's concurrency capacity.

**Fix**: Use atomic increment operations for rate limiting: Redis `INCR` + `EXPIRE` (atomic), database `UPDATE count = count + 1 WHERE count < limit` (atomic), or in-memory atomic counters with proper locking. Implement the token bucket or sliding window algorithm. Apply rate limiting at the earliest possible point (reverse proxy, API gateway, load balancer) before the request reaches application code. Use a distributed rate limiter for multi-instance deployments (Redis-based or centralized).

**Detection**:
- *Code patterns*: Rate limit check as `if (getCount() < limit) { increment(); process(); }` without atomic operations; rate limit state in application memory (not shared across instances); rate limit counter with simple interval reset; rate limiting middleware that executes after request processing starts
- *Review questions*: Is the rate limit check-and-increment atomic? Is the rate limit state shared across all application instances? What algorithm is used (simple counter, sliding window, token bucket)? At what layer is rate limiting applied?
- *Test methods*: Send a burst of concurrent requests (50-100) within a single rate limit window. Count how many succeed — if more than the limit, the race condition exists. Test across multiple endpoints that share rate limits. Test after a rate limit reset boundary

---

## Distributed Double-Spend — Critical

**Signs**: Financial or resource-allocation operations that are atomic within a single database or service but not across distributed components. Microservice architectures where a payment service and an inventory service make independent decisions without distributed coordination. Event-driven systems where the same event can be processed by multiple consumers without idempotency. Message queues that deliver the same message to multiple consumers or redeliver on failure without deduplication.

**Impact**: In distributed systems, atomicity is not guaranteed across service boundaries. An attacker exploits this by triggering the same operation across multiple services simultaneously. Examples: purchasing an item where the payment service and inventory service each succeed independently but together create an inconsistent state (charged twice, or charged but no inventory deducted). Gift card balance spent simultaneously across two microservices that each check balance independently. Loyalty points redeemed on two orders processed by different service instances.

**Fix**: Implement idempotency keys for all financial operations — store the key with the transaction and reject duplicates. Use the Saga pattern with compensating transactions for distributed operations. Implement distributed locks (Redis Redlock, ZooKeeper, etcd) for operations that must be globally atomic. For event-driven systems, ensure exactly-once processing: use consumer group coordination, deduplication tables, or transactional outbox pattern. Design for at-least-once delivery with idempotent consumers.

**Detection**:
- *Code patterns*: Financial operations without idempotency keys; distributed operations without Saga or 2PC coordination; message consumers without deduplication logic; balance checks in separate services without distributed locking; missing `ON CONFLICT` or `INSERT ... ON DUPLICATE KEY` for idempotency enforcement
- *Review questions*: Are financial operations idempotent (safe to retry)? Is there distributed coordination for cross-service operations? Can the same event be processed twice by different consumers? Are idempotency keys used for payment and resource allocation?
- *Test methods*: Send duplicate requests with the same idempotency key and verify only one processes. Trigger the same event simultaneously across multiple service instances. Test payment + inventory operations with concurrent requests to identify inconsistent states. Simulate message redelivery and verify idempotent processing

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Trust the Client | Critical | A2: Authorization, A3: Input Validation | Both |
| Input Validation Theater | Major | A3: Input Validation | Both |
| Error Message Oracle | Major | A6: Secure Coding | Implementation |
| Oversharing APIs | Minor | A4: Data Protection | Implementation |
| Check-Then-Act Without Atomicity | Critical | A6: Secure Coding | Both |
| Optimistic Concurrency Without Conflict Detection | Major | A6: Secure Coding | Implementation |
| File System TOCTOU | Major | A6: Secure Coding | Implementation |
| Rate Limit Race | Major | A6: Secure Coding | Implementation |
| Distributed Double-Spend | Critical | A6: Secure Coding | Both |
