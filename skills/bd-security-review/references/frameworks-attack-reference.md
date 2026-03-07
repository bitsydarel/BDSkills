# Frameworks: Attack Reference

Cheat sheets for attack classification frameworks used in Lens 2 (Application Security).

## MITRE ATT&CK Enterprise — 14 Tactics

| ID | Tactic | Description | Key Techniques to Check |
|----|--------|-------------|------------------------|
| TA0001 | Initial Access | How attackers get in | Phishing, public-facing app exploits, supply chain |
| TA0002 | Execution | How code runs | Command injection, scripting, serverless execution |
| TA0003 | Persistence | How they stay | Web shells, account creation, scheduled tasks |
| TA0004 | Privilege Escalation | How they get higher access | Exploitation, access token manipulation, sudo abuse |
| TA0005 | Defense Evasion | How they avoid detection | Log tampering, obfuscation, masquerading |
| TA0006 | Credential Access | How they steal credentials | Brute force, credential dumping, keylogging |
| TA0007 | Discovery | How they learn the environment | Network scanning, account discovery, cloud enumeration |
| TA0008 | Lateral Movement | How they spread | Pass-the-hash, SSH, service exploitation |
| TA0009 | Collection | How they gather target data | Data staging, email collection, screen capture |
| TA0010 | Exfiltration | How they steal data | C2 channels, cloud storage, DNS tunneling |
| TA0011 | Command & Control | How they communicate | HTTPS tunneling, domain fronting, encrypted channels |
| TA0040 | Impact | How they cause damage | Data destruction, ransomware, defacement |
| TA0042 | Resource Development | Pre-attack preparation | Domains, accounts, tools, exploits |
| TA0043 | Reconnaissance | Pre-attack intelligence | Scanning, OSINT, phishing for information |

**Usage**: Map detection rules to tactics. Ensure monitoring covers at least TA0001, TA0004, TA0006, TA0008, TA0010 (the critical kill chain stages).

---

## CWE Top 25 (2025) quick reference

| Rank | CWE-ID | Weakness | Mapped Criterion |
|------|--------|----------|-----------------|
| 1 | CWE-79 | Cross-site Scripting (XSS) | A3 |
| 2 | CWE-89 | SQL Injection | A3 |
| 3 | CWE-352 | Cross-Site Request Forgery (CSRF) | A1 |
| 4 | CWE-862 | Missing Authorization | A2 |
| 5 | CWE-787 | Out-of-bounds Write | A6 |
| 6 | CWE-22 | Path Traversal | A3 |
| 7 | CWE-416 | Use After Free | A6 |
| 8 | CWE-125 | Out-of-bounds Read | A6 |
| 9 | CWE-78 | OS Command Injection | A3 |
| 10 | CWE-94 | Code Injection | A3 |
| 11 | CWE-120 | Classic Buffer Overflow | A6 |
| 12 | CWE-434 | Unrestricted File Upload | A3 |
| 13 | CWE-476 | NULL Pointer Dereference | A6 |
| 14 | CWE-121 | Stack-based Buffer Overflow | A6 |
| 15 | CWE-502 | Deserialization of Untrusted Data | A3 |
| 16 | CWE-122 | Heap-based Buffer Overflow | A6 |
| 17 | CWE-863 | Incorrect Authorization | A2 |
| 18 | CWE-20 | Improper Input Validation | A3 |
| 19 | CWE-284 | Improper Access Control | A2 |
| 20 | CWE-200 | Sensitive Info Exposure | A4 |
| 21 | CWE-306 | Missing Authentication | A1 |
| 22 | CWE-918 | Server-Side Request Forgery (SSRF) | A3 |
| 23 | CWE-77 | Command Injection | A3 |
| 24 | CWE-639 | Auth Bypass via User Key | A2 |
| 25 | CWE-770 | Resource Allocation Without Limits | A6 |

**Usage**: When reviewing code, cross-reference findings against this list. If a finding maps to a CWE Top 25 entry, it automatically qualifies as Major severity or higher.
