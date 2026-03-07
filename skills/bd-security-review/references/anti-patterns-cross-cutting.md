# Anti-patterns: Cross-cutting

Security anti-patterns that span multiple evaluation lenses and security domains. Each pattern includes signs to look for, its impact, and a concrete fix.

## Security Theater — Critical

**Signs**: Client-side-only validation with no server-side enforcement. WAF rules that block scanner signatures but not actual attack payloads. Security headers added without understanding (CSP with `unsafe-inline unsafe-eval`). "We use HTTPS" as the entire data protection strategy. Security checkboxes completed with no evidence of testing.

**Impact**: Creates false confidence. The team believes they are protected while attack surface remains fully exposed. Auditors may pass a surface-level review, delaying discovery until an actual breach. Incident response is delayed because "we had controls in place."

**Fix**: For every security control, define what it protects against, how it is verified, and what bypasses it. Require penetration testing or DAST that validates controls actually work. Replace checkbox compliance with evidence-based verification: "Show me the test that proves this control stops this attack."

**Detection**:
- *Code patterns*: `unsafe-inline` or `unsafe-eval` in CSP headers; client-side validation without corresponding server-side check; `verify=False` or `InsecureSkipVerify: true` in TLS config
- *Review questions*: For each security control, can you show me the test that proves it works? Is there a WAF rule that was tested with actual attack payloads, not just scanner signatures?
- *Test methods*: Bypass client-side validation and submit directly to the API. Send actual attack payloads (not scanner signatures) to WAF-protected endpoints. Check if security headers are correctly configured (not just present)

---

## Inconsistent Security Levels — Minor

**Signs**: Main application has MFA but admin dashboard uses password-only. API v2 validates input but legacy v1 endpoints still active without validation. Web app uses CSP but mobile API does not enforce certificate pinning. Production environment hardened but staging has identical data with weaker controls.

**Impact**: Attackers target the weakest entry point. Legacy endpoints become the preferred attack vector. Staging environments with production data become breach targets. Security improvements in one area create false confidence while gaps persist elsewhere.

**Fix**: Apply consistent security baseline across all environments and versions. Deprecate and remove legacy endpoints. Ensure staging environments have equivalent security controls or synthetic data. Conduct security reviews for all entry points, not just the newest ones.

**Detection**:
- *Code patterns*: Different auth middleware on different route groups; legacy API versions without input validation middleware; staging environment configs with `DEBUG=true` or weaker TLS
- *Review questions*: Are all API versions (v1, v2) subject to the same security middleware? Does the admin dashboard have the same auth requirements as the main app? Does staging have production data?
- *Test methods*: List all entry points and verify each has equivalent security controls. Test legacy endpoints with the same attacks as current ones. Compare staging and production security configurations

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Security Theater | Critical | All lenses | Both |
| Inconsistent Security Levels | Minor | All lenses | Implementation |
