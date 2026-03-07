# Frameworks: Compliance Standards

Cheat sheets for compliance and verification frameworks used in Lens 4 (Compliance & Governance).

## NIST Cybersecurity Framework 2.0

| Function | ID | Description | Mapped Lens |
|----------|-----|------------|-------------|
| **Govern** | GV | Establishing cybersecurity strategy, policy, and oversight | Lens 4 (G1-G4) |
| **Identify** | ID | Understanding assets, risks, and business context | Lens 1 (T1-T4) |
| **Protect** | PR | Implementing safeguards | Lens 2 (A1-A7) |
| **Detect** | DE | Discovering cybersecurity events | Lens 3 (O1-O2) |
| **Respond** | RS | Acting on detected events | Lens 3 (O2) |
| **Recover** | RC | Restoring capabilities | Lens 3 (O4) |

### Key categories per function

**GV**: GV.OC (Organizational Context), GV.RM (Risk Management Strategy), GV.RR (Roles & Responsibilities), GV.PO (Policy), GV.OV (Oversight), GV.SC (Supply Chain Risk Management)

**ID**: ID.AM (Asset Management), ID.RA (Risk Assessment), ID.IM (Improvement)

**PR**: PR.AA (Identity & Access), PR.AT (Awareness & Training), PR.DS (Data Security), PR.PS (Platform Security), PR.IR (Technology Infrastructure Resilience)

**DE**: DE.CM (Continuous Monitoring), DE.AE (Adverse Event Analysis)

**RS**: RS.MA (Incident Management), RS.AN (Incident Analysis), RS.CO (Incident Response Reporting), RS.MI (Incident Mitigation)

**RC**: RC.RP (Incident Recovery Plan Execution), RC.CO (Recovery Communication)

---

## OWASP ASVS 5.0 chapter index

| Chapter | Title | Verification Levels | Mapped Criterion |
|---------|-------|-------------------|-----------------|
| V1 | Encoding and Sanitization | L1: 7, L2: 27, L3: 3 | A3 |
| V2 | Validation and Business Logic | L1: 4, L2: 7, L3: 2 | A3, A6 |
| V3 | Web Frontend Security | L1: 8, L2: 11, L3: 10 | A7 |
| V4 | API and Web Service | L1: 2, L2: 8, L3: 5 | A3, A7 |
| V5 | File Handling | L1: 4, L2: 4, L3: 5 | A3 |
| V6 | Authentication | L1: 13, L2: 20, L3: 10 | A1 |
| V7 | Session Management | L1: 4, L2: 11, L3: 1 | A1 |
| V8 | Authorization | L1: 4, L2: 3, L3: 5 | A2 |
| V9 | Self-contained Tokens | L1: 5, L2: 4, L3: 0 | A1, A2 |
| V10 | OAuth and OIDC | L1: 4, L2: 17, L3: 7 | A1, A2 |
| V11 | Cryptography | L1: 3, L2: 14, L3: 7 | A4 |
| V12 | Secure Communication | L1: 3, L2: 8, L3: 2 | A4 |
| V13 | Configuration | L1: 1, L2: 13, L3: 6 | O3 |
| V14 | Data Protection | L1: 2, L2: 8, L3: 5 | A4, G2 |
| V15 | Secure Coding and Architecture | L1: 2, L2: 9, L3: 7 | A5, A6, T1-T4 |
| V16 | Security Logging and Error Handling | L1: 0, L2: 15, L3: 1 | A6, O1 |
| V17 | WebRTC | L1: 0, L2: 8, L3: 4 | domain-specific |

**Verification levels**:
- **L1 (Opportunistic)**: Minimum viable security — automated tools can verify most requirements. Suitable for low-risk applications.
- **L2 (Standard)**: Recommended for most applications handling sensitive data. Requires manual code review and targeted testing.
- **L3 (Advanced)**: For critical applications (financial, healthcare, infrastructure). Requires formal verification, penetration testing, and threat modeling.

**Usage**: When scoring Application Security criteria, reference the corresponding ASVS chapter and the [ASVS 5.0 Verification Rubric](frameworks-asvs-verification.md) for concrete per-chapter scoring examples. L1 compliance maps to a score of 3; L2 compliance maps to a score of 4; L3 compliance maps to a score of 5.

---

## OWASP MASVS 2.0 category index

| Category | Title | Description | Mapped Criterion |
|----------|-------|-------------|-----------------|
| MASVS-STORAGE | Data Storage | Secure handling of sensitive data on-device | A4 |
| MASVS-CRYPTO | Cryptography | Correct use of cryptographic primitives | A4 |
| MASVS-AUTH | Authentication & Authorization | AuthN/AuthZ mechanisms for mobile | A1, A2 |
| MASVS-NETWORK | Network Communication | Secure network communications | A4 |
| MASVS-PLATFORM | Platform Interaction | Secure use of platform APIs and components | domain-mobile.md |
| MASVS-CODE | Code Quality | Security-relevant code quality practices | A6 |
| MASVS-RESILIENCE | Resilience | Protection against reverse engineering | domain-mobile.md |
| MASVS-PRIVACY | Privacy | User privacy protection | G2 |

---

## Regulatory decision tree

Use these trigger conditions to determine which regulations apply to the review target. Check each trigger — regulations are additive (multiple can apply simultaneously).

### Data type triggers

| Data Type Present | Regulation Triggered | Key Requirements |
|------------------|---------------------|-----------------|
| Payment card numbers (PAN, CVV, expiry) | **PCI DSS 4.0** | Cardholder data environment scoping, network segmentation, encryption, access controls, vulnerability management, monitoring |
| Protected health information (PHI) | **HIPAA** (US) | Administrative/physical/technical safeguards, BAAs with vendors, breach notification within 60 days, minimum necessary standard |
| Personal data of EU/EEA residents | **GDPR** | Lawful basis, data minimization, purpose limitation, DPIA for high-risk processing, DPO appointment, 72-hour breach notification |
| Personal data of California residents | **CCPA/CPRA** | Right to know, right to delete, right to opt-out of sale, no discrimination for exercising rights, data processing agreements |
| Personal data of UK residents | **UK GDPR** | Mirrors EU GDPR with UK-specific supervisory authority (ICO). Requires UK representative if no UK establishment |
| Children's data (under 13 US, under 16 EU) | **COPPA** (US) / **GDPR Art 8** (EU) | Verifiable parental consent, data minimization, no behavioral advertising to children |
| Biometric data | **BIPA** (Illinois) / **GDPR Art 9** | Informed written consent before collection, retention schedule, prohibition on selling biometric data |
| Financial records | **SOX** (public companies), **GLBA** (financial institutions) | Internal controls over financial reporting, safeguarding customer financial information |

### Sector triggers

| Sector | Regulation Triggered | Key Requirements |
|--------|---------------------|-----------------|
| Healthcare / health tech | **HIPAA**, **HITECH** | PHI protection, breach notification, BAAs, audit controls |
| Financial services / fintech | **PCI DSS**, **SOX**, **GLBA**, **PSD2** (EU) | Payment security, financial reporting controls, strong customer authentication |
| Government / public sector | **FedRAMP** (US), **FISMA**, **IL2-IL6** | Security authorization, continuous monitoring, FIPS-validated cryptography |
| Education | **FERPA** (US) | Student record protection, directory information opt-out, parental access rights |
| Telecommunications | **CPNI rules** (FCC) | Customer proprietary network information protection |
| Critical infrastructure | **NERC CIP** (energy), **TSA directives** (pipeline) | Operational technology security, incident reporting |

### Market / customer triggers

| Market Condition | Regulation / Standard Triggered | Key Requirements |
|-----------------|-------------------------------|-----------------|
| Enterprise B2B customers | **SOC 2 Type II** (expected, not legally required) | Trust service criteria: security, availability, processing integrity, confidentiality, privacy |
| Publicly traded company | **SOX** | Internal controls, audit trail, financial reporting integrity |
| Operating in multiple countries | **Applicable privacy law per jurisdiction** | Map each jurisdiction's requirements — GDPR, CCPA, LGPD (Brazil), PIPL (China), PDPA (Singapore/Thailand) |
| Accepting online payments | **PCI DSS 4.0** | Even through payment processors — SAQ at minimum, client-side script integrity (Req 6.4.3) |
| Processing insurance claims | **State insurance regulations**, **HIPAA** (if health) | Data protection specific to insurance, PHI handling if health-related |

### Decision flow

1. **Inventory data types**: List all data the system collects, processes, stores, or transmits
2. **Check data triggers**: For each data type, identify triggered regulations
3. **Check sector triggers**: Based on the industry/sector of the organization
4. **Check market triggers**: Based on customer types, markets, and business model
5. **Union all triggers**: The system must comply with ALL triggered regulations simultaneously
6. **Identify conflicts**: Some regulations have conflicting requirements (e.g., GDPR right to erasure vs. SOX retention). Document conflicts and resolve with legal counsel
7. **Map to controls**: For each triggered regulation, verify corresponding technical controls exist (use the scoring criteria in Lens 4)

### Common multi-regulation combinations

| Combination | Why It Happens | Watch For |
|------------|---------------|-----------|
| GDPR + PCI DSS | E-commerce serving EU customers | PCI requires card data retention for disputes; GDPR requires minimization — resolve with tokenization |
| HIPAA + SOC 2 | Health SaaS with enterprise customers | HIPAA BAAs required with all sub-processors. SOC 2 Type II expected by customers |
| GDPR + CCPA | Global SaaS with US and EU users | Different definitions of "personal data." CCPA includes household data; GDPR requires explicit consent for certain processing |
| PCI DSS + SOX | Public fintech company | PCI scopes cardholder data; SOX scopes financial reporting. Overlapping controls on access management and audit trails |
| GDPR + COPPA | Platform accessible to children in EU and US | GDPR Art 8 age threshold (16, member states may lower to 13); COPPA threshold is 13. Apply the stricter rule per jurisdiction |
