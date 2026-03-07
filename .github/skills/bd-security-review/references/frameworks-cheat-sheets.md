# Frameworks: OWASP Cheat Sheet Remediation Index

Maps all 19 security review criteria to OWASP Cheat Sheet Series titles for remediation guidance. When a criterion scores 1-3, reference this file to recommend specific cheat sheets. For scoring criteria, see the matching `evaluation-*.md` file. For anti-pattern fixes, see the matching `anti-patterns-*.md` file.

## How to use this file

1. Load this file during **Step 8 (Produce structured output)** — after scoring is complete
2. For each criterion scoring 1-3, look up the applicable cheat sheets below
3. Include cheat sheet titles in the issue's "Recommended action" field
4. Use the score-to-depth mapping at the bottom to determine how many cheat sheets to recommend
5. Reference cheat sheets by exact title only — do not include URLs

---

## Lens 1: Threat Analysis remediation

| Criterion | Applicable Cheat Sheets | Remediation Focus |
|-----------|------------------------|-------------------|
| T1: Attack Surface & Entry Point Mapping | Attack Surface Analysis | Systematic identification of external interfaces and data ingress/egress points |
| T2: Threat Modeling (STRIDE) | Threat Modeling | Structured STRIDE application methodology per component |
| T3: Trust Boundaries & Data Flow | Microservices Security; Microservices based Security Arch Doc; Zero Trust Architecture | Cross-boundary data flow validation and zero trust enforcement |
| T4: Adversary & Risk Assessment | Vulnerability Disclosure; Abuse Case | Threat actor profiling and risk quantification using DREAD |

---

## Lens 2: Application Security remediation

| Criterion | Applicable Cheat Sheets | Remediation Focus |
|-----------|------------------------|-------------------|
| A1: Authentication & Session Management | Authentication; Password Storage; Session Management; Multifactor Authentication; Forgot Password; Credential Stuffing Prevention; Choosing and Using Security Questions; SAML Security; OAuth2; Cookie Theft Mitigation | Identity proofing, credential handling, session lifecycle, MFA |
| A2: Authorization & Access Control | Authorization; Access Control; Insecure Direct Object Reference Prevention; Mass Assignment; Transaction Authorization | Permission models, RBAC/ABAC, object-level authorization, default-deny |
| A3: Input Validation & Injection Prevention | Input Validation; SQL Injection Prevention; Cross Site Scripting Prevention; OS Command Injection Defense; File Upload; Deserialization; XML External Entity Prevention; LDAP Injection Prevention; Injection Prevention; Injection Prevention in Java; Query Parameterization; Server Side Request Forgery Prevention; DOM based XSS Prevention; DOM Clobbering Prevention; Prototype Pollution Prevention; NoSQL Security; XSS Filter Evasion | All input handling: SQL, XSS, command, path traversal, deserialization, file upload |
| A4: Data Protection & Cryptography | Cryptographic Storage; Transport Layer Security; Transport Layer Protection; Key Management; HTTP Strict Transport Security; Secrets Management; TLS Cipher String; Pinning; Database Security | Encryption at rest/transit, key management, hashing, certificate handling |
| A5: Supply Chain & Dependency Security | Software Supply Chain Security; Vulnerable Dependency Management; Third Party Javascript Management; Dependency Graph SBOM; NPM Security | Dependency auditing, pinning, SBOM, provenance verification, update policy |
| A6: Secure Coding & Error Handling | Error Handling; Logging; Secure Code Review; Secure Product Design; C-Based Toolchain Hardening | Language-specific pitfalls, error disclosure, resource management, memory safety |
| A7: UI/UX Security & Anti-Social Engineering | Clickjacking Defense; Content Security Policy; Cross-Site Request Forgery Prevention; Unvalidated Redirects and Forwards; HTML5 Security; Securing Cascading Style Sheets; HTTP Headers; AJAX Security; XS Leaks; Browser Extension Vulnerabilities | Clickjacking, phishing-resistant UI, consent patterns, dark pattern avoidance |

---

## Lens 3: Operational Security remediation

| Criterion | Applicable Cheat Sheets | Remediation Focus |
|-----------|------------------------|-------------------|
| O1: Security Logging & Monitoring | Logging; Logging Vocabulary | Audit trail completeness, log integrity, structured event taxonomy |
| O2: Incident Detection & Response | (No dedicated incident response cheat sheet — use Logging and Logging Vocabulary for detection layer; combine with NIST CSF RS functions) | Detection rules, response playbooks, escalation paths |
| O3: Infrastructure & Configuration Hardening | Docker Security; Kubernetes Security; Infrastructure as Code Security; Secrets Management; Database Security; Virtual Patching; Network Segmentation; Secure Cloud Architecture; NodeJS Docker; Serverless FaaS Security | Secrets management, least-privilege infra, CIS benchmarks, patch cadence |
| O4: Resilience, Recovery & Continuity | Denial of Service | Disaster recovery, backup verification, availability protection |

---

## Lens 4: Compliance & Governance remediation

| Criterion | Applicable Cheat Sheets | Remediation Focus |
|-----------|------------------------|-------------------|
| G1: Regulatory Compliance | Third Party Payment Gateway Integration (PCI DSS context) | Regulatory mapping — for detailed frameworks see [frameworks-compliance.md](frameworks-compliance.md) |
| G2: Privacy by Design | User Privacy Protection | Data minimization, purpose limitation, consent management, right to erasure |
| G3: Security Governance & Policy | Secure Product Design; Secure Code Review | SDL practices, risk acceptance processes, security training |
| G4: Audit Trail & Accountability | Logging; Logging Vocabulary | Non-repudiation, change management, evidence preservation |

---

## Domain-specific cheat sheet supplements

When reviewing a specific domain, load the domain file from the matching `domain-*.md` file and supplement with these additional cheat sheets.

| Domain | Additional Cheat Sheets | Domain File |
|--------|------------------------|-------------|
| Web | Content Security Policy; Cross-Site Request Forgery Prevention; Cross Site Scripting Prevention; Clickjacking Defense; HTTP Strict Transport Security; HTTP Headers; HTML5 Security; AJAX Security | [domain-web.md](domain-web.md) |
| API | REST Security; REST Assessment; GraphQL; JSON Web Token for Java; Web Service Security; XML Security; gRPC Security; Mass Assignment | [domain-api.md](domain-api.md) |
| Mobile | Mobile Application Security; Pinning; Certificate and Public Key Pinning | [domain-mobile.md](domain-mobile.md) |
| Cloud/Infra | Docker Security; Kubernetes Security; Infrastructure as Code Security; Secure Cloud Architecture; Serverless FaaS Security; Network Segmentation | [domain-cloud-infra.md](domain-cloud-infra.md) |
| CI/CD | CI CD Security; Software Supply Chain Security | [domain-cicd.md](domain-cicd.md) |
| AI/ML | AI Agent Security; Secure AI Model Ops; LLM Prompt Injection Prevention; MCP Security | [domain-ai-ml.md](domain-ai-ml.md) |
| IoT | (No dedicated IoT cheat sheet — use Pinning, Transport Layer Security, and Authentication cheat sheets) | [domain-iot.md](domain-iot.md) |
| Desktop | (No dedicated desktop cheat sheet — use Cryptographic Storage, Error Handling, and Input Validation cheat sheets) | [domain-desktop.md](domain-desktop.md) |
| CLI | (No dedicated CLI cheat sheet — use OS Command Injection Defense and Input Validation cheat sheets) | [domain-cli.md](domain-cli.md) |
| Distributed Systems | Microservices Security; Microservices based Security Arch Doc; REST Security; gRPC Security | [domain-distributed-systems.md](domain-distributed-systems.md) |

---

## Language-specific cheat sheet supplements

When reviewing language-specific code, supplement with these cheat sheets alongside the language file from the matching `language-*.md` file.

| Language | Additional Cheat Sheets |
|----------|------------------------|
| Java | Injection Prevention in Java; JSON Web Token for Java; JAAS; Bean Validation |
| JavaScript/TypeScript | Nodejs Security; NPM Security; Third Party Javascript Management; Prototype Pollution Prevention; DOM Clobbering Prevention |
| Python | Django Security; Django REST Framework |
| Ruby | Ruby on Rails |
| PHP | PHP Configuration; Laravel; Symfony |
| C/C++ | C-Based Toolchain Hardening |
| C# / .NET | DotNet Security |
| Swift/Kotlin | Mobile Application Security; Pinning |

---

## Google Security Review remediation

| Criterion | Applicable Cheat Sheets | Remediation Focus |
|-----------|------------------------|-------------------|
| GSR1: Design Document Security Completeness | Threat Modeling; Secure Product Design | Structured security section with threat-to-design traceability |
| GSR2: Trusted Computing Base & Understandability | Secure Code Review; Secure Product Design | Minimize and isolate security-critical code with typed interfaces |
| GSR3: Zero Trust Architecture Validation | Zero Trust Architecture; Microservices Security; Microservices based Security Arch Doc | Eliminate network-location trust, enforce identity-based access everywhere |
| GSR4: Binary Authorization & Build Integrity | Software Supply Chain Security; CI CD Security | Deploy-time admission control, signed provenance, config-as-code |
| GSR5: Structural Security Posture | Secure Product Design; Input Validation; SQL Injection Prevention; Cross Site Scripting Prevention | Eliminate vulnerability classes structurally, secure-by-default APIs |
| GSR6: Adversary-Centric Threat Profiling | Threat Modeling; Abuse Case | Profile adversary categories, insider threat matrix, kill chain mapping |
| GSR7: Vulnerability Pattern Awareness | Secure Code Review; Vulnerability Disclosure | Root cause analysis, dominant pattern tracking, structural elimination |

---

## Score-to-depth mapping

The criterion score determines how many cheat sheets to recommend in the review output.

| Score | Recommendation Depth | Guidance |
|-------|---------------------|----------|
| 1 (Missing) | Recommend ALL applicable cheat sheets for the criterion. The work needs foundational guidance across the entire area | Include in Critical issues section |
| 2 (Weak) | Recommend the 2-3 primary cheat sheets addressing the specific gap identified | Include in Major issues section |
| 3 (Adequate) | Recommend the 1-2 cheat sheets targeting the specific scoring delta (what would move from 3 to 4) | Include in Minor issues or Suggestions section |
| 4-5 (Good/Excellent) | No cheat sheet remediation needed. Acknowledge existing controls | Omit from remediation |
