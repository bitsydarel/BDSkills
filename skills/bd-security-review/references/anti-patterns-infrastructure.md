# Anti-patterns: Infrastructure & Operations

Security anti-patterns related to logging, monitoring, rate limiting, and production configuration. Each pattern includes signs to look for, its impact, and a concrete fix.

## Logging Blind Spots — Major

**Signs**: No security events in logs (only application errors and access logs). Authentication failures not logged. Authorization failures silently return 403 with no server-side record. Admin actions not audited. Logs stored on the same server as the application (attacker deletes evidence).

**Impact**: Breaches go undetected for months (industry median: 204 days). Incident response is impossible without evidence. Compliance violations for frameworks requiring audit trails (PCI DSS, SOC 2, HIPAA). Forensic investigation after a breach yields "we don't know what happened."

**Fix**: Define and log security events: authentication (success/failure), authorization failures, data access, admin actions, configuration changes, and privilege escalation. Ship logs to immutable centralized storage. Set up alerting for critical security events. Test that alerts fire by simulating security events.

**Detection**:
- *Code patterns*: Auth handlers without log statements; authorization middleware that returns 403 without logging; admin action handlers without audit logging; `catch` blocks that swallow errors silently
- *Review questions*: Are authentication failures logged? Are authorization denials logged? Are admin/privileged actions audited? Where are logs stored and are they tamper-protected?
- *Test methods*: Trigger a failed login and verify it appears in logs. Trigger an authorization denial and verify it is logged. Perform an admin action and verify the audit trail captures it

---

## Missing Rate Limiting — Major

**Signs**: Login endpoints without throttling. API endpoints with no request rate limits. Password reset emails triggerable without cooldown. No per-user or per-IP request limits. GraphQL endpoints allowing unlimited query depth or complexity. Account recovery flows with no cooldown.

**Impact**: Brute-force attacks on authentication succeed at scale — credential stuffing tools test thousands of credentials per minute against unthrottled login endpoints. SMS/email bombing via password reset racks up costs and harasses users. Denial of service through expensive operations (unbounded GraphQL queries, report generation, file processing). API abuse enables data scraping, enumeration, and business logic exploitation. Rate limiting is the first line of defense against automated attacks on authentication — without it, even strong password hashing is undermined by volume.

**Fix**: Implement rate limiting at multiple layers: API gateway (global), application (per-user, per-IP, per-endpoint), and resource (query complexity, file upload size). Authentication endpoints need aggressive limits: 10 attempts per 15 minutes per username, with progressive delays and CAPTCHA after 5 failures. Use sliding window or token bucket algorithms. Return 429 with Retry-After header. Log and alert on rate limit violations. For GraphQL: implement query depth limits and per-query cost analysis.

**Detection**:
- *Code patterns*: Login endpoint without rate-limiting middleware; no `express-rate-limit`, `django-ratelimit`, or equivalent; GraphQL endpoint without depth/complexity limits; password reset endpoint without cooldown
- *Review questions*: What happens if I submit 1000 login attempts in 1 minute? Is there a rate limit on password reset emails? Are GraphQL queries bounded by depth and complexity?
- *Test methods*: Send rapid requests to login endpoint and verify 429 responses after threshold. Attempt bulk password reset requests. Send deeply nested GraphQL queries and verify rejection

---

## Verbose Debug in Production — Minor

**Signs**: `DEBUG=true` or `LOG_LEVEL=debug` in production environment variables. Framework debug pages enabled (Django debug mode, Spring Boot actuator endpoints exposed). Source maps deployed to production. Detailed error pages with stack traces visible to users.

**Impact**: Debug output reveals internal architecture, database queries, environment variables, and file paths. Framework debug pages expose request parameters, session data, and system configuration. Source maps allow full source code reconstruction from production JavaScript.

**Fix**: Enforce production configuration checks in deployment pipeline. Block DEBUG mode, remove source maps, disable framework debug pages. Use environment-specific configuration with no fallback to debug mode. Add automated checks that fail deployment if debug settings are detected.

**Detection**:
- *Code patterns*: `DEBUG=True` or `DEBUG=true` in production env; `source-map` in production webpack config; framework actuator endpoints without auth; `app.use(errorHandler)` that sends `err.stack`
- *Review questions*: Is debug mode disabled in production? Are source maps deployed to production? Are framework debug endpoints (actuator, Django debug toolbar) accessible?
- *Test methods*: Check production environment variables for debug flags. Try accessing debug endpoints (`/actuator`, `/__debug__/`). Trigger a 500 error and check if the response contains stack traces

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Logging Blind Spots | Major | O1: Security Logging | Both |
| Missing Rate Limiting | Major | A6: Secure Coding | Both |
| Verbose Debug in Production | Minor | A6: Secure Coding, O3: Hardening | Implementation |
