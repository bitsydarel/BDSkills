# Frameworks: Framework Scoping

How to scope security frameworks (STRIDE, DREAD, MITRE ATT&CK, CIS, ASVS) to the review target. Prevents over-application of frameworks to simple systems and under-application to critical ones. For risk level classification, see [frameworks-risk-profiles.md](frameworks-risk-profiles.md).

---

## STRIDE depth by risk level

STRIDE analysis depth should match the application's risk profile. Applying full per-component STRIDE to an internal CLI tool wastes effort; skipping it for a payment system misses critical threats.

| Risk Level | STRIDE Depth | What This Means |
|------------|-------------|-----------------|
| **Critical** | Per-component, per-entry-point | Every component and every entry point gets a full 6-category STRIDE analysis. Threat trees trace from entry to impact. Mitigations mapped to controls with test evidence |
| **High** | Per-component | Each architectural component gets STRIDE. Entry points within a component grouped. Mitigations documented and tested for high-impact threats |
| **Medium** | Per-system with component highlights | System-level STRIDE covering all 6 categories. Individual STRIDE for components handling sensitive data or authentication |
| **Low** | System-level summary | One STRIDE pass for the overall system. Focus on Spoofing and Elevation (most common for simple apps). Document but deprioritize Repudiation and Info Disclosure |

**Depth escalation rule**: If a Medium-risk system has a single Critical-risk component (e.g., a payment integration), apply Critical-depth STRIDE to that component only.

---

## DREAD scoring anchors

DREAD scores are subjective without anchors. Use these reference points to calibrate ratings consistently.

| Factor | Score 1-3 (Low) | Score 4-6 (Medium) | Score 7-9 (High) | Score 10 (Maximum) |
|--------|----------------|-------------------|------------------|--------------------|
| **Damage** | Cosmetic defect, public data exposed | Internal data exposed, limited user impact | PII/financial data exposed, account takeover | Full system compromise, data destruction, regulatory violation |
| **Reproducibility** | Requires specific timing, race condition, or environmental setup | Reproducible with custom tooling or specific knowledge | Reproducible with readily available tools | Always reproducible, no special conditions |
| **Exploitability** | Requires chained exploits, insider access, or novel research | Requires moderate skill and specific tools | Script-kiddie level: pre-built tools available | No skill required: browser DevTools or URL manipulation |
| **Affected Users** | Single user under specific conditions | Subset of users matching a profile (<10%) | Majority of active users (10-80%) | All users, including admins and service accounts |
| **Discoverability** | Requires source code access and deep system knowledge | Discoverable through targeted testing or fuzzing | Visible through automated scanning or public documentation | Obvious from public interface (login page, public API) |

**DREAD risk thresholds**:
- **1.0-3.0**: Low risk — remediate when convenient, track in backlog
- **3.1-5.0**: Medium risk — remediate within current quarter
- **5.1-7.0**: High risk — remediate within current sprint
- **7.1-10.0**: Critical risk — immediate remediation, consider hotfix

---

## MITRE ATT&CK subset by domain

Full MITRE ATT&CK has 200+ techniques. Scope to the most relevant techniques per domain to keep reviews focused.

### Web applications

| Tactic | Priority Techniques |
|--------|-------------------|
| Initial Access | T1190 (Exploit Public-Facing App), T1078 (Valid Accounts) |
| Execution | T1059.007 (JavaScript), T1203 (Client Execution) |
| Persistence | T1505.003 (Web Shell), T1078 (Valid Accounts) |
| Credential Access | T1110 (Brute Force), T1539 (Steal Web Session Cookie), T1557 (AitM) |
| Collection | T1213 (Data from Information Repositories) |

### APIs and microservices

| Tactic | Priority Techniques |
|--------|-------------------|
| Initial Access | T1190 (Exploit Public-Facing App), T1078 (Valid Accounts), T1199 (Trusted Relationship) |
| Lateral Movement | T1021 (Remote Services), T1550 (Use Alternate Auth Material) |
| Credential Access | T1528 (Steal Application Access Token), T1110 (Brute Force) |
| Exfiltration | T1041 (Exfiltration Over C2), T1567 (Exfiltration Over Web Service) |

### Cloud infrastructure

| Tactic | Priority Techniques |
|--------|-------------------|
| Initial Access | T1078.004 (Cloud Accounts), T1190 (Exploit Public-Facing App) |
| Persistence | T1098 (Account Manipulation), T1525 (Implant Container Image) |
| Privilege Escalation | T1078.004 (Cloud Accounts), T1548 (Abuse Elevation Control) |
| Defense Evasion | T1562.001 (Disable Security Tools), T1535 (Unused Cloud Regions) |
| Exfiltration | T1537 (Transfer to Cloud Account), T1567 (Exfiltration Over Web Service) |

### Mobile applications

| Tactic | Priority Techniques |
|--------|-------------------|
| Initial Access | T1474 (Supply Chain Compromise), T1444 (Masquerade as Legitimate App) |
| Credential Access | T1417 (Input Capture), T1634 (Credentials from Password Store) |
| Collection | T1533 (Data from Local System), T1636 (Contact/SMS/Call Log) |
| Network Effects | T1463 (Manipulate Device Communication) |

### CI/CD pipelines

| Tactic | Priority Techniques |
|--------|-------------------|
| Initial Access | T1195.002 (Supply Chain: Software Supply Chain), T1078 (Valid Accounts) |
| Execution | T1059 (Command and Scripting), T1204 (User Execution) |
| Persistence | T1098 (Account Manipulation), T1543 (Create or Modify System Process) |
| Defense Evasion | T1070 (Indicator Removal), T1036 (Masquerading) |

**Usage**: During O2 scoring, verify that detection rules cover at least the priority techniques for the application's domain. Missing coverage for priority techniques in the relevant domain lowers the O2 score.

---

## CIS Benchmark selection

CIS publishes 100+ benchmarks. Select based on the actual technology stack.

| Infrastructure Component | CIS Benchmark | Applies When |
|--------------------------|---------------|-------------|
| AWS | CIS AWS Foundations Benchmark | Any AWS deployment |
| Azure | CIS Azure Foundations Benchmark | Any Azure deployment |
| GCP | CIS Google Cloud Platform Benchmark | Any GCP deployment |
| Kubernetes | CIS Kubernetes Benchmark | Any K8s cluster |
| Docker | CIS Docker Benchmark | Containerized workloads |
| Linux | CIS Distribution Independent Linux Benchmark | Linux servers/containers |
| Nginx | CIS Nginx Benchmark | Nginx reverse proxy/web server |
| PostgreSQL | CIS PostgreSQL Benchmark | PostgreSQL databases |
| MySQL | CIS Oracle MySQL Benchmark | MySQL databases |
| MongoDB | CIS MongoDB Benchmark | MongoDB databases |

**Scoring impact**: O3 scoring references CIS compliance. At **Critical/High** risk, CIS Benchmarks for all deployed components must be applied and measured. At **Medium** risk, benchmarks for the cloud provider and primary database are expected. At **Low** risk, basic hardening without formal CIS compliance is acceptable.

---

## ASVS verification level selection

ASVS verification level maps directly to risk level from [frameworks-risk-profiles.md](frameworks-risk-profiles.md).

| Risk Level | ASVS Level | Verification Approach | Score Mapping |
|------------|-----------|----------------------|--------------|
| **Low** | L1 (Opportunistic) | Automated tools (SAST, SCA) cover most requirements | L1 compliance → Score 3 |
| **Medium** | L1+ selected L2 | Automated tools + manual review of auth, authz, and data handling | L1 full + partial L2 → Score 3-4 |
| **High** | L2 (Standard) | Manual code review + targeted testing for all L2 requirements | L2 compliance → Score 4 |
| **Critical** | L3 (Advanced) | Formal verification, penetration testing, threat modeling for L3 | L3 compliance → Score 5 |

**Partial compliance**: If an application meets L2 for 80% of chapters but has gaps in cryptography (V11) and session management (V7), score the corresponding criteria (A4, A1) lower while acknowledging overall progress. Do not award a blanket L2 score when specific chapters fail.

---

## Framework interaction rules

When multiple frameworks apply simultaneously:

1. **STRIDE informs DREAD**: Threats identified in STRIDE analysis are the inputs to DREAD scoring. Do not DREAD-score threats that were not systematically identified
2. **DREAD prioritizes MITRE mapping**: High-DREAD threats should have corresponding MITRE detection rules. Low-DREAD threats can defer detection to general monitoring
3. **CIS supports ASVS**: CIS infrastructure hardening (O3) enables ASVS application security. A hardened infrastructure with weak application controls still fails on Lens 2
4. **Risk level governs depth**: The risk profile from [frameworks-risk-profiles.md](frameworks-risk-profiles.md) determines how deep each framework is applied. Never apply Critical-depth analysis to a Low-risk tool or Low-depth analysis to a Critical-risk system
5. **Domain scopes MITRE**: Use the domain-specific MITRE subset above, not the full matrix. Add techniques only when specific threat intelligence warrants it
