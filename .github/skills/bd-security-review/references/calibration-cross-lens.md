# Calibration: Cross-lens

Complete security toolkit organized by scope — all techniques a security reviewer checks for.

## Tactical (sprint/feature level)

- STRIDE analysis per component/feature
- Input validation schema per endpoint
- Authentication and authorization checks per route
- SAST scan results in pull request
- Dependency vulnerability check in CI
- Security-relevant unit and integration tests
- Error handling review (no information leakage)
- Secure configuration for new services/containers
- Design document security section review (GSR1)
- TCB boundary verification — security primitives used, no raw operations (GSR2)
- Structural vulnerability elimination check — can a developer accidentally introduce this class? (GSR5)
- Vulnerability pattern root cause analysis for new findings (GSR7)

## Operational (release/quarter level)

- DAST or penetration testing per release
- Dependency audit and SBOM generation
- Security monitoring rule review
- Incident response playbook testing (tabletop exercise)
- Access review and permission cleanup
- Certificate rotation and key management review
- Backup verification and DR test
- Compliance evidence collection
- Binary Authorization and build provenance verification (GSR4)
- Zero trust validation — internal service auth audit, lateral movement testing (GSR3)
- Adversary kill chain detection coverage review (GSR6)
- Vulnerability recurrence rate measurement across releases (GSR7)

## Strategic (product/annual level)

- Full threat model refresh for the system
- Risk register update with DREAD re-scoring
- Regulatory compliance audit
- Security maturity assessment (BSIMM/SAMM)
- Security architecture review
- Third-party security assessment of critical vendors
- Security training program assessment
- Zero trust architecture roadmap evaluation
- TCB scope review — has the TCB grown beyond its original boundary? (GSR2)
- Adversary profile refresh — all 7 categories reassessed with threat intelligence (GSR6)
- Structural security posture assessment — which vulnerability classes are eliminated vs. still requiring developer discipline? (GSR5)
- Design document security completeness audit across all active projects (GSR1)
