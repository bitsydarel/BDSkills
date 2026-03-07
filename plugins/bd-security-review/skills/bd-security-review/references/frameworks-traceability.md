# Frameworks: Traceability

Cross-reference tables for mapping findings to established frameworks and verifying coverage across domains.

## OWASP variant index

| Domain | OWASP List | Version | Reference File |
|--------|-----------|---------|---------------|
| Web Applications | Top 10 Web | 2025 | domain-web.md |
| Mobile | Mobile Top 10 | 2024 | domain-mobile.md |
| APIs | API Security Top 10 | 2023 | domain-api.md |
| Desktop | Desktop App Security Top 10 | 2021 | domain-desktop.md |
| LLM/AI | Top 10 for LLM Applications | 2025 | domain-ai-ml.md |
| ML Systems | ML Security Top 10 | 2023 | domain-ai-ml.md |
| Serverless | Serverless Top 10 | 2017 | domain-cloud-infra.md |
| Cloud-Native | Cloud-Native Security Top 10 | 2022 | domain-cloud-infra.md |
| Kubernetes | Kubernetes Top 10 | 2022 | domain-cloud-infra.md |
| Docker | Docker Top 10 | 2022 | domain-cloud-infra.md |
| CI/CD | CI/CD Security Risks Top 10 | 2022 | domain-cicd.md |
| IoT | IoT Top 10 | 2018 | domain-iot.md |
| Cross-domain | Cheat Sheet Series | 2024+ | frameworks/cheat-sheets.md |
| Cross-domain | SAMM | 2.0 | frameworks/samm-maturity.md |

---

## Framework Traceability Matrix

Maps each security review criterion to the frameworks it draws from. Use this for reporting and compliance traceability.

| Criterion | OWASP | MITRE ATT&CK | CWE | ASVS 5.0 | NIST CSF 2.0 | Cheat Sheets | SAMM Practice |
|-----------|-------|-------------|-----|----------|-------------|-------------|---------------|
| T1 | Attack Surface Analysis | TA0001 (Initial Access) | — | V15.1 | ID.AM | Attack Surface Analysis | Threat Assessment |
| T2 | Threat Modeling | — | — | V15.1 | ID.RA | Threat Modeling | Architecture Assessment |
| T3 | — | — | — | V15.2 | PR.AC (ZTA) | Microservices Security; Zero Trust Architecture | Security Requirements; Secure Architecture |
| T4 | — | Threat Groups | — | — | ID.RA | Abuse Case | Threat Assessment |
| A1 | A07:2025, API2:2023, MASVS-AUTH | TA0006 (Credential Access) | CWE-306, 287, 384 | V6, V7, V9, V10 | PR.AC | Authentication; Password Storage; Session Management | Security Requirements |
| A2 | A01:2025, API1/3/5:2023 | TA0004 (Privilege Escalation) | CWE-862, 863, 639 | V8, V9, V10 | PR.AC | Authorization; Access Control | Security Requirements |
| A3 | A05:2025 | TA0002 (Execution) | CWE-79, 89, 78, 94, 22, 434, 502 | V1, V2, V4, V5 | PR.DS | Input Validation; SQL Injection Prevention; Cross Site Scripting Prevention | Requirements-driven Testing; Security Testing |
| A4 | A04:2025 | — | CWE-327, 200 | V11, V12, V14 | PR.DS | Cryptographic Storage; Key Management; Transport Layer Security | Secure Architecture |
| A5 | A03:2025 | TA0001 (Supply Chain) | CWE-1357 | V15.2 | ID.SC | Software Supply Chain Security; Vulnerable Dependency Management | Secure Build; Environment Management |
| A6 | A10:2025 | — | CWE Top 25 (language-specific) | V2, V15.3, V16.5 | PR.IP | Error Handling; Secure Code Review | Secure Build; Defect Management |
| A7 | Clickjacking Defense | TA0001 (Phishing) | CWE-1021 | V3 | — | Clickjacking Defense; Content Security Policy; Cross-Site Request Forgery Prevention | Security Requirements |
| O1 | A09:2025 | — | — | V16.2, V16.3, V16.4 | DE.CM, DE.AE | Logging; Logging Vocabulary | Incident Management |
| O2 | — | Detection (all tactics) | — | — | RS.MA, RS.AN, RS.MI | Logging | Incident Management; Defect Management |
| O3 | A02:2025 | — | — | V13 | PR.IP | Docker Security; Kubernetes Security; Secrets Management | Secure Deployment; Environment Management |
| O4 | — | — | — | — | RC.RP | Denial of Service | Operational Management |
| G1 | — | — | — | — | GV.OC | — | Policy & Compliance |
| G2 | — | — | — | V14 (MASVS-PRIVACY) | GV.OC | User Privacy Protection | Operational Management |
| G3 | — | — | — | — | GV.RM | Secure Product Design | Strategy & Metrics; Education & Guidance |
| G4 | — | — | — | — | PR.PT | Logging; Logging Vocabulary | Operational Management |
| GSR1 | Secure Product Design | — | — | V15.1 | ID.RA, GV.RM | Threat Modeling; Secure Product Design | Architecture Assessment; Security Requirements |
| GSR2 | — | — | CWE-676, 242 | V15.3 | PR.DS | Secure Code Review | Secure Architecture; Secure Build |
| GSR3 | — | TA0008 (Lateral Movement) | — | V15.2 | PR.AC (ZTA) | Zero Trust Architecture; Microservices Security | Secure Architecture; Secure Deployment |
| GSR4 | Software Supply Chain Security | TA0001 (Supply Chain) | CWE-1357 | V15.2 | PR.IP, PR.DS | Software Supply Chain Security | Secure Build; Secure Deployment |
| GSR5 | Secure Product Design | — | CWE Top 25 | V15.3 | PR.IP | Secure Product Design; Input Validation | Secure Architecture; Defect Management |
| GSR6 | — | Threat Groups; All Tactics | — | — | ID.RA | Abuse Case; Threat Modeling | Threat Assessment |
| GSR7 | — | — | CWE Top 25 | — | ID.RA | — | Defect Management; Security Testing |
