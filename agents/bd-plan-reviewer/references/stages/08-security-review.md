# Stage 8: Security Review

Invoke skill `bd-security-review` to review this plan.

**Context Adaptation:**

| Plan Type | Typical Applicability | Notes |
|-----------|----------------------|-------|
| new-product | Full security assessment | All lenses + GSR |
| new-feature | High | Depends on feature scope and data sensitivity |
| improvement | Moderate-High | Focus on auth, input validation, data protection |
| bug-fix | Low-Moderate | Input validation, secure coding, data protection; GSR lighter unless security-adjacent |
| refactor | Moderate | Trust boundaries, supply chain, secure coding — does the refactor change security boundaries? |
| architecture-change | High | Nearly full — architecture changes affect security posture |
| infrastructure-change | High | Hardening, operations, compliance critical |
| ui-enhancement | Moderate | XSS, CSRF, clickjacking, input validation relevant |
| deprecation | Low-Moderate | Removing code may remove security controls |
| devops-tooling | Moderate-High | CI/CD pipeline security, supply chain matters |

**How to update the plan:**
- Add threat model or attack surface analysis if missing for applicable plan types
- Add authentication/authorization requirements for features handling user data or access control
- Add input validation strategy for features accepting external input
- Add data protection requirements (encryption, key management) for features handling sensitive data
- Add supply chain security considerations (dependency auditing, pinning) for new dependencies
- Add security logging and monitoring requirements for security-relevant events
- Add compliance requirements (GDPR, HIPAA, PCI DSS) if handling regulated data
- Flag security anti-patterns (trust-the-client, secret sprawl, crypto cargo cult)
- **Do NOT add:** full STRIDE analysis for cosmetic UI fixes, compliance sections for internal dev tooling with no data access, penetration test plans for documentation changes
