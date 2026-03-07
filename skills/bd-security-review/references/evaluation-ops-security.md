# Lens 3: Operational Security (/20)

Scoring criteria for the 4 Operational Security dimensions. For scoring scale and verdict thresholds, see [evaluation-scoring.md](evaluation-scoring.md).

---

## O1: Security Logging & Monitoring

**Proposal questions**: Are security-relevant events defined for logging (auth, authz, data access, admin actions)? Is log integrity protected? Is SIEM or centralized logging planned? Are PII scrubbing rules defined for logs?

**Implementation-Compliance questions**: Are all specified security events actually logged? Are logs shipped to centralized storage with tamper protection? Are alerting rules configured for critical events?

**Implementation-Results questions**: Are alerts firing and being triaged? What is the mean time to detect (MTTD) for security events? Are log retention requirements met?

**Scoring**:
- **5 (Excellent)**: Comprehensive security event logging with defined taxonomy. SIEM-integrated with tamper-proof storage. PII scrubbed from logs. Alerts tuned with <15min MTTD for critical events. Retention requirements met and verified.
- **4 (Good)**: Security events logged and shipped to centralized storage. Alerting configured for critical events. PII scrubbing in place. Minor gaps in alert tuning (some noise) or log coverage for lower-priority events.
- **3 (Adequate)**: Security logging present but missing centralization, alerting, or log integrity protection. Some security events logged but no defined taxonomy. PII scrubbing partial.
- **2 (Weak)**: Basic application logging only. Security events mixed with debug logs. No centralized storage. No alerting on security events. PII present in logs.
- **1 (Missing)**: No security logging or all events in a single unstructured debug log.

**Quality check**: Verify these events are logged: failed authentication, authorization denial, privilege escalation, admin action, sensitive data access. Confirm logs are shipped to a tamper-resistant store.

### O1 security event taxonomy

Comprehensive list of security events that should be logged. Use this to evaluate O1 coverage — a Score 5 system logs events from all 5 categories; Score 3 covers Authentication and Authorization; Score 1-2 covers few or none.

**Category 1: Authentication events**
1. Successful login (user ID, timestamp, IP, user agent, auth method)
2. Failed login (username attempted, timestamp, IP, failure reason)
3. Account lockout triggered (username, lockout duration, trigger count)
4. MFA challenge issued (user ID, method: TOTP/SMS/WebAuthn)
5. MFA challenge success/failure (user ID, method, failure reason if applicable)
6. Password change (user ID, timestamp, initiated by: user/admin/reset)
7. Password reset requested (email/username, timestamp, IP)
8. Session created/destroyed (session ID hash, user ID, creation/destruction reason)
9. Token refresh (user ID, old token hash, new token hash, timestamp)

**Category 2: Authorization events**
10. Access denied — insufficient permissions (user ID, resource, action attempted, required permission)
11. Privilege escalation — role change (user ID, old role, new role, changed by, timestamp)
12. Object-level authorization failure (user ID, object ID, object type, action)
13. API key created/revoked (key hash, created by, scope, expiration)
14. Service account action (service ID, action, target resource)

**Category 3: Data access events**
15. Sensitive data accessed (user ID, data type: PII/PCI/PHI, record count, access reason)
16. Bulk data export (user ID, record count, export format, destination)
17. Data subject request received (request type: access/deletion/portability, subject ID)
18. Data deletion executed (data type, record count, deletion method, requested by)
19. Database schema change (change type, table/column, executed by, timestamp)
20. Encryption key rotation (key ID, old key version, new key version, rotated by)

**Category 4: Administrative events**
21. Configuration change (setting name, old value hash, new value hash, changed by)
22. Deployment event (version, environment, deployed by, deployment method)
23. Secret rotation (secret ID, rotated by, rotation method)
24. Infrastructure change (resource type, change type: create/modify/delete, changed by)
25. Firewall/security group rule change (rule description, changed by, timestamp)
26. User/service account created or deleted (account type, created/deleted by)

**Category 5: Anomaly events**
27. Rate limit exceeded (IP, endpoint, request count, time window)
28. Unusual traffic pattern detected (source IP, pattern type, baseline deviation)
29. Failed TLS handshake (source IP, failure reason, cipher attempted)
30. CSP violation report (violated directive, blocked URI, document URI)
31. Unexpected cross-service communication (source service, destination service, expected: yes/no)
32. Geographic anomaly (user ID, login location, previous location, time between logins)

**Scoring guide for event coverage**:

| Events Logged | O1 Score Impact |
|--------------|----------------|
| All 5 categories with centralized storage and alerting | Supports Score 5 |
| Categories 1-3 with centralized storage | Supports Score 4 |
| Categories 1-2 with centralized storage | Supports Score 3 |
| Category 1 only, or logging without centralization | Score 2 |
| No security-specific event logging | Score 1 |

---

## O2: Incident Detection & Response

**Proposal questions**: Is an incident response plan defined? Are detection rules mapped to known attack patterns (MITRE ATT&CK)? Are escalation paths documented? Is there a security on-call rotation?

**Implementation-Compliance questions**: Are detection rules implemented and tested? Are response playbooks practiced through tabletop exercises or game days? Is the war room process documented?

**Implementation-Results questions**: What is the mean time to respond (MTTR)? Were recent incidents handled according to playbooks? Are post-incident reviews conducted and findings tracked?

**Scoring**:
- **5 (Excellent)**: MITRE-mapped detection rules. Tested playbooks with <4hr MTTR. Regular game days and tabletop exercises. Post-incident reviews with tracked findings. Security on-call rotation operational.
- **4 (Good)**: Incident response plan with detection rules and playbooks. Tabletop exercises conducted at least annually. MTTR tracked. Post-incident reviews happen but findings tracked informally.
- **3 (Adequate)**: Incident response plan exists but untested. Detection rules present without MITRE mapping. Response relies on ad-hoc coordination rather than playbooks. No regular exercises.
- **2 (Weak)**: Incident response plan is a document nobody has read. No detection rules beyond basic monitoring. No playbooks or escalation paths. Incidents handled reactively by whoever notices.
- **1 (Missing)**: No incident response plan or detection capability.

**Quality check**: Confirm at least one playbook has been practiced (tabletop or game day) in the past year. Verify escalation path: who gets called at 3am for a security incident?

---

## O3: Infrastructure & Configuration Hardening

**Proposal questions**: Are infrastructure components specified with hardening requirements? Is secrets management defined (vault, KMS)? Are baseline configurations referenced (CIS Benchmarks)?

**Implementation-Compliance questions**: Are CIS Benchmarks or equivalent applied? Are secrets in vault with rotation? Is infrastructure scanned for misconfigurations? Are unused ports/services closed?

**Implementation-Results questions**: What do infrastructure scans report? Are there secrets exposed in environment variables, config files, or code? Is patch compliance measured?

**Scoring**:
- **5 (Excellent)**: CIS-compliant configurations. Vault-managed secrets with automated rotation. Automated config scanning (IaC security policies). Patch SLA enforced. Unused ports/services closed. Infrastructure drift detected.
- **4 (Good)**: Hardening applied following a standard (CIS or internal). Secrets in vault with rotation. Config scanning in CI/CD. Patching on schedule. Minor gaps in drift detection or non-production environments.
- **3 (Adequate)**: Hardening partially applied. Secrets in vault but no automated rotation. Config scanning manual or infrequent. Patching happens but without SLA. Some default configurations remain.
- **2 (Weak)**: Minimal hardening. Secrets in environment variables rather than vault. No config scanning. Patching reactive (only after incidents). Default configurations on multiple services.
- **1 (Missing)**: Default configurations everywhere. Secrets in code or config files. Unpatched systems. No hardening standard applied.

**Quality check**: Verify secrets are in vault/KMS (not in env vars, config files, or source). Confirm at least one infrastructure scan has been run. Check patch status of OS and runtime.

---

## O4: Resilience, Recovery & Continuity

**Proposal questions**: Is disaster recovery (DR) planned with RPO/RTO targets? Are backup procedures defined? Is graceful degradation designed? Are failure modes analyzed?

**Implementation-Compliance questions**: Are backups verified (restore tested)? Is DR plan tested at least annually? Are circuit breakers and rate limiters in place? Is chaos engineering practiced?

**Implementation-Results questions**: Has a DR test been successful? What is actual RTO in incidents? Are there single points of failure? How did the system perform during the last outage?

**Scoring**:
- **5 (Excellent)**: Tested DR with met RPO/RTO targets. Verified backups with regular restore tests. Chaos engineering practiced. Circuit breakers and rate limiters in place. No single points of failure. Annual DR tests documented.
- **4 (Good)**: DR plan with defined RPO/RTO. Backups verified at least quarterly. Circuit breakers on critical paths. DR tested at least once. Minor SPOFs identified with mitigation plans.
- **3 (Adequate)**: DR plan exists with backups but restore untested. RPO/RTO defined but not validated. Circuit breakers on some paths. No chaos engineering. Some SPOFs unaddressed.
- **2 (Weak)**: Backups configured but never tested. No formal DR plan or RPO/RTO. No circuit breakers. Graceful degradation not designed. Multiple SPOFs.
- **1 (Missing)**: No DR plan. Untested or missing backups. Critical SPOFs. No resilience mechanisms.

**Quality check**: Confirm backups have been restore-tested (date of last successful restore). Verify RPO/RTO targets exist and at least one DR test has validated them.
