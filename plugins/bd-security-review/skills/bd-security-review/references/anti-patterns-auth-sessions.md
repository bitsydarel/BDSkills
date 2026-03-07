# Anti-patterns: Authentication & Sessions

Security anti-patterns related to authentication, session management, and access control. Each pattern includes signs to look for, its impact, and a concrete fix.

## Auth Bypass Backdoor — Major

**Signs**: Debug endpoints that skip authentication (`/api/debug/*`). Test accounts with known credentials in production. Feature flags that disable auth for "internal" users. API endpoints accessible without authentication that were "meant to be internal." Health check endpoints that expose sensitive system information.

**Impact**: Attackers discover debug/test endpoints through scanning, source code review, or error messages. A single unauthenticated endpoint can serve as the initial foothold for lateral movement. "Internal" is not a security boundary — any endpoint on the network is a target.

**Fix**: Remove all debug endpoints and test accounts from production builds. Require authentication for every endpoint — if something is truly public, document it explicitly. Use feature flags from a secure configuration service, not code. Health checks should return only status (200/503), not system details.

**Detection**:
- *Code patterns*: Routes matching `/debug/*`, `/test/*`, `/internal/*` without auth middleware; hardcoded credentials or test accounts (`admin/admin`, `test@test.com`); feature flags that disable authentication checks
- *Review questions*: Are there any endpoints accessible without authentication that are not explicitly documented as public? Do build artifacts differ between test and production (removal of debug endpoints)?
- *Test methods*: Run URL enumeration against the deployment (gobuster, ffuf). Search codebase for hardcoded credentials. Verify all `/api/*` routes require authentication by calling without tokens

---

## Session Immortality — Major

**Signs**: Session tokens that never expire. Refresh tokens with no rotation or revocation mechanism. "Remember me" sessions lasting months without re-authentication. No session invalidation on password change. Active sessions not visible to users in their security settings.

**Impact**: Stolen session tokens remain valid indefinitely. A single cookie theft via XSS gives permanent account access. Compromised devices remain authenticated after the user changes their password. No mechanism to force logout compromised sessions.

**Fix**: Set appropriate session timeouts (15-30 min for sensitive operations, 24h for general use). Rotate refresh tokens on each use (one-time use). Invalidate all sessions on password change. Implement session listing and remote revocation. Re-authenticate for sensitive actions (payment, settings change).

**Detection**:
- *Code patterns*: Session cookie without `Max-Age` or `Expires`; refresh token endpoint that returns the same token (no rotation); no session invalidation in password-change handler
- *Review questions*: What is the maximum session lifetime? Are sessions invalidated when the user changes their password? Can users see and revoke active sessions?
- *Test methods*: Authenticate, wait past the stated session timeout, and verify the session is rejected. Change password and verify all other sessions are invalidated. Check if refresh tokens are single-use

---

## Permission Creep — Major

**Signs**: Users accumulate permissions over time as they change roles but permissions are never revoked. Service accounts with admin access "because it was easier." IAM policies with `*` resource or `*` action. No periodic access reviews. Shared credentials between team members.

**Impact**: Blast radius of any compromised account is maximized. A compromised low-privilege user account may have accumulated admin permissions over years. Insider threat risk multiplied. Violates least privilege, a foundational security principle.

**Fix**: Implement quarterly access reviews with mandatory revocation of unused permissions. Use just-in-time (JIT) access for elevated privileges. Enforce least-privilege IAM policies with specific resources and actions. Alert on any `*` permissions in new policies. Require individual credentials — never shared accounts.

**Detection**:
- *Code patterns*: IAM policies with `"Resource": "*"` or `"Action": "*"`; no access review job or cron; service accounts with admin-level permissions
- *Review questions*: When was the last access review? How are permissions revoked when someone changes roles? Are there service accounts with permissions broader than needed?
- *Test methods*: Query IAM for policies with wildcard resources/actions. List all service accounts and compare their permissions to their actual usage. Check for accounts not used in 90+ days

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Auth Bypass Backdoor | Major | A1: Authentication | Implementation |
| Session Immortality | Major | A1: Authentication | Both |
| Permission Creep | Major | A2: Authorization | Implementation |
