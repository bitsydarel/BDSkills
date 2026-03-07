# Frameworks: SDL & Maturity Models

Cheat sheets for secure development lifecycle and maturity model frameworks used in Lens 4 (G3: Security Governance).

## Microsoft SDL — 10 practices

| # | Practice | Description | Security Review Check |
|---|----------|-------------|----------------------|
| 1 | Training | Provide security training to all engineers | G3: Is training current and role-specific? |
| 2 | Requirements | Define security and privacy requirements | T1-T4: Are security requirements documented? |
| 3 | Design | Perform threat modeling, attack surface analysis | T2: Is STRIDE applied? T1: Is attack surface mapped? |
| 4 | Implementation | Use approved tools, follow secure coding standards | A6: Are SAST tools integrated? |
| 5 | Verification | Perform DAST, fuzzing, and code review | A3: Is DAST/fuzzing performed? |
| 6 | Release | Create incident response plan, final security review | O2: Is IR plan documented? |
| 7 | Response | Execute incident response plan when needed | O2: Is MTTR measured? |
| 8 | Ecosystem | Secure the development ecosystem (supply chain) | A5: Is supply chain verified? |
| 9 | Operations | Monitor and respond to security events | O1: Is monitoring in place? |
| 10 | Governance | Define security policies and measure compliance | G3: Is SDL adoption measured? |

---

## BSIMM / SAMM maturity quick reference

### BSIMM (Building Security In Maturity Model) — 4 Domains, 12 Practices

| Domain | Practices |
|--------|-----------|
| Governance | Strategy & Metrics, Compliance & Policy, Training |
| Intelligence | Attack Models, Security Features & Design, Standards & Requirements |
| SSDL Touchpoints | Architecture Analysis, Code Review, Security Testing |
| Deployment | Penetration Testing, Software Environment, Configuration & Vulnerability Management |

### OWASP SAMM 2.0

For comprehensive SAMM coverage including all 15 practices, maturity levels, assessment questions, and multi-criteria mapping, see [frameworks-samm-maturity.md](frameworks-samm-maturity.md).

---

## SLSA (Supply-chain Levels for Software Artifacts)

| Level | Requirements | Mapped To |
|-------|-------------|-----------|
| SLSA 0 | No guarantees | A5 score 1 |
| SLSA 1 | Build process documented | A5 score 2 |
| SLSA 2 | Hosted build, signed provenance | A5 score 3 |
| SLSA 3 | Hardened build, verified provenance | A5 score 4-5 |

**Verification tools**: Sigstore (Cosign for signing, Fulcio for certificates, Rekor for transparency log). SBOM formats: SPDX, CycloneDX.
