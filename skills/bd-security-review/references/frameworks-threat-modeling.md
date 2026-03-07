# Frameworks: Threat Modeling

Cheat sheets for threat modeling frameworks used in Lens 1 (Threat Analysis).

## STRIDE threat modeling

| Category | Security Property | Question | Common Mitigations |
|----------|------------------|----------|-------------------|
| **S**poofing | Authentication | Can an attacker pretend to be someone/something else? | MFA, certificate auth, token validation |
| **T**ampering | Integrity | Can an attacker modify data in transit or at rest? | Digital signatures, TLS, checksums, HMAC |
| **R**epudiation | Non-repudiation | Can an attacker deny performing an action? | Audit logs, digital signatures, timestamps |
| **I**nfo Disclosure | Confidentiality | Can an attacker access data they should not see? | Encryption, access controls, data classification |
| **D**enial of Service | Availability | Can an attacker prevent legitimate access? | Rate limiting, redundancy, auto-scaling, CDN |
| **E**levation of Privilege | Authorization | Can an attacker gain higher privileges? | Least privilege, RBAC/ABAC, input validation |

**How to apply**: For each component/entry point, ask all 6 STRIDE questions. Document threats found and map each to a mitigation. Unmitigated threats become issues in the review.

---

## DREAD risk scoring

| Factor | Question | 1 (Low) | 5 (Medium) | 10 (High) |
|--------|----------|---------|------------|-----------|
| **D**amage | How bad is the impact? | Minor data exposure | Significant data breach | Full system compromise |
| **R**eproducibility | How easy to reproduce? | Requires rare conditions | Requires specific setup | Trivially reproducible |
| **E**xploitability | How easy to exploit? | Requires advanced skills | Requires moderate skill | Script kiddie can exploit |
| **A**ffected Users | How many users impacted? | < 1% of users | 1-50% of users | > 50% or all users |
| **D**iscoverability | How easy to find? | Requires source code access | Found via probing | Publicly known or obvious |

**Score calculation**: Average of all 5 factors. Total / 5 = Risk Rating.
- **High risk**: 8-10 → Immediate remediation
- **Medium risk**: 5-7 → Remediate in current cycle
- **Low risk**: 1-4 → Remediate when convenient
