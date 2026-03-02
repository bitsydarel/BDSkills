# Security Guidelines

*All guidance is reviewed annually to align with the latest global standards. Last full review: Jan 2026.*

This document provides actionable summaries and official links to the newest global standards for securing web, mobile, and backend/API codebases. Always link or reference these sections in your AGENTS.md or compliance documentation.

## Web Security: OWASP Top Ten 2025
Add this block in your AGENTS.md (if relevant):

`Security: Follows OWASP Top Ten (2025) best practices. See /references/security.md`

Key risks to address:
- Injection (SQL, NoSQL, OS): Use parameterized queries, validate all inputs.
- Broken Authentication: Enforce strong authentication (MFA), store credentials securely.
- Sensitive Data Exposure: Encrypt data in transit and at rest.
- XML External Entities (XXE): Disable external entity resolution.
- Broken Access Control: Use explicit allowlists, test role boundaries.
- Security Misconfiguration: Minimize enabled services and update libraries.
- Cross-Site Scripting (XSS): Escape outputs, implement Content Security Policy (CSP).
- Insecure Deserialization: Validate/bound input, watch for data failures.
- Components w/ Known Vulnerabilities: Scan dependencies, use trusted sources.
- Insufficient Logging & Monitoring: Centralize logs, monitor for attacks.

See: [OWASP Top Ten 2025](https://owasp.org/Top10/2025/)

## Mobile Security: OWASP MASVS 2.0 (2024)
Add this block in your AGENTS.md (if relevant):

`Security: Follows OWASP MASVS 2.0 (2024) for mobile best practices. See /references/security.md`

Key recommendations:
- Secure local data storage and use platform encryption APIs.
- Enforce user authentication (biometrics, PIN).
- Always use HTTPS or certificate pinning for all network calls.
- Harden against reverse engineering (obfuscation, minimal debug info; Proguard for Android, bitcode off for iOS release).
- Validate all inputs and manage sessions securely.

See: [OWASP MASVS 2.0 (2024)](https://owasp.org/mas)

## Server/API Security: OWASP API Top Ten 2023 & NIST CSF 2.0 (2024)
Add this block in your AGENTS.md (if relevant):

`Security: Follows OWASP API Top Ten (2023) and NIST Cybersecurity Framework 2.0 (2024). See /references/security.md`

Key risks to address:
- Broken Object/User Auth: Validate endpoints and permissions for every request.
- Excessive Data Exposure: Minimize returned data, validate output format.
- Lack of Rate Limiting: Implement rate limits on all APIs.
- Security Misconfiguration: Harden and keep software up to date.
- Sensitive Data Handling: Encrypt, follow data protection regulations and avoid storing secrets in code/config.
- Logging & Monitoring: Use centralized and resilient logging.
- NIST CSF Controls: Identify, Protect, Detect, Respond, Recover.

See: [OWASP API Top Ten 2023](https://owasp.org/www-project-api-security/), [NIST CSF 2.0 (2024)](https://doi.org/10.6028/NIST.CSWP.29)

## General Compliance
Add this block in your AGENTS.md if handling regulated data:

`Compliance: This repo is subject to [COMPLIANCE REGIME(s)] and follows required regulations for PII/PHI/cardholder data. All standards are reviewed for annual completeness. See /references/security.md and [link to compliance doc if present].`

Guidance:
- If handling regulated data (e.g., PII, PHI), **reference compliance standards directly** (e.g., GDPR for EU data, HIPAA for US healthcare, PCI-DSS for payment card data).
- For enterprise and regulated settings, document review and escalation processes—reference your risk or incident response plan, and maintain an ongoing compliance update calendar.

| Data/Domain   | Add this compliance reference in AGENTS.md                |
|--------------|----------------------------------------------------------|
| EU data      | GDPR (https://gdpr.eu/)                                   |
| US healthcare| HIPAA (https://www.hhs.gov/hipaa/)                        |
| Payment/Card | PCI-DSS (https://www.pcisecuritystandards.org/)           |
| Any business | SOC 2 (https://www.aicpa.org), NIST CSF 2.0               |
