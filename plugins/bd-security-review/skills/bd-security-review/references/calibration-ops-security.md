# Calibration: Operational Security (Lens 3)

What good operational security looks like — reference examples for scoring O1-O4.

## O1: Immature security logging (Score 1-2)

- Only application logs (request/response) — no security-specific events.
- Logs on the application server — attacker deletes them first.
- No alerting — someone checks logs manually "when there is a problem."
- No defined log taxonomy — security events, application errors, and debug output mixed in one stream.
- PII freely present in logs (full email addresses, IP addresses, session tokens).
- Log retention: "whatever the disk holds."

## O1: Adequate security logging (Score 3)

- Authentication events (success, failure, lockout) logged. Logs shipped to centralized storage (ELK) but not tamper-protected.
- No defined security event taxonomy — security events mixed with application logs, distinguished only by log level or ad-hoc tags.
- PII partially scrubbed (emails masked, but full IPs retained in security logs). Session tokens occasionally appear in debug logs.
- Alerting set up for failed login spikes but not for other security events (privilege escalation, bulk data access, config changes).
- Log retention defined (90 days) but not enforced automatically — old logs deleted manually when disk fills up.

## O1: Mature security logging (Score 4-5)

- Security events defined and logged with structured taxonomy:
  - Authentication: success, failure, lockout, MFA challenge, password reset
  - Authorization: denied access, privilege changes, role assignments
  - Data: sensitive data access, bulk export, schema changes
  - Admin: configuration changes, deployment events, secret rotation
  - Network: unusual traffic patterns, new connections, TLS errors
- Logs shipped to SIEM (Splunk, Elastic, Datadog) within seconds.
- Log storage: immutable, tamper-evident, 12-month retention.
- PII scrubbed from logs (emails hashed, IPs masked in non-security contexts).
- CSP violation reports (report-uri/report-to) collected and triaged.

## O2: Immature incident response (Score 1-2)

- Incident response: "Call the CTO." No documented escalation path.
- No detection rules — relying on users to report issues. Breaches found via Twitter, not monitoring.
- Post-incident process: fix the immediate issue, no root cause analysis, no tracked remediation.
- No regular exercises. The team has never practiced responding to a security incident.
- Mean time to detect (MTTD): unknown. Mean time to respond (MTTR): unknown.

## O2: Adequate incident response (Score 3)

- Incident response plan exists in Confluence. Escalation path: on-call engineer -> team lead -> CTO. No security-specific escalation.
- No formal detection rules beyond CloudWatch alarms for infrastructure metrics. Security events detected by manual log review or user reports.
- No tabletop exercises conducted. The team has discussed "what would we do if" informally but never practiced a full scenario.
- Post-incident reviews happen for major incidents but findings not systematically tracked — action items assigned in Slack, some completed, some forgotten.
- MTTD and MTTR not measured. Anecdotally, the last incident took 6 hours to detect and 2 days to fully remediate.

## O2: Mature incident response (Score 4-5)

- Detection rules mapped to MITRE ATT&CK: credential stuffing (T1110), lateral movement (T1021), data exfiltration (T1041).
- Alert triage SLA: critical <15 min, high <1 hour, medium <4 hours.
- Incident response plan: documented, tested quarterly via tabletop exercises.
- Escalation path clearly defined: on-call engineer → security team lead → CISO → legal/comms. Pager rotation active.
- Response playbooks for top scenarios: data breach, account takeover, ransomware, DDoS, insider threat, supply chain compromise.
- Post-incident reviews with tracked remediation items. Lessons learned feed back into detection rules and playbooks.
- MTTR measured and tracked. Target: <4 hours for critical security incidents.

## O3: Immature infrastructure hardening (Score 1-2)

- Default configurations everywhere. SSH on port 22 with password auth. Unnecessary services running.
- Secrets in environment variables, docker-compose files, or `.env` files committed to git.
- Patching reactive — only after an incident or CVE makes the news.
- No infrastructure scanning. No CIS Benchmarks applied. "It works, so we don't touch it."
- Direct SSH access to production servers is the primary troubleshooting method. Anyone with the key can connect.

## O3: Adequate infrastructure hardening (Score 3)

- Secrets in HashiCorp Vault but rotation is manual and overdue (last rotation 10 months ago). Some non-critical secrets still in environment variables.
- CIS Benchmarks downloaded but only partially applied. Team addressed critical items, deferred "nice to haves" indefinitely.
- Infrastructure scanning via Checkov runs locally by the DevOps lead, not integrated in CI. Findings addressed ad-hoc.
- Patching happens monthly without SLA. Critical CVEs get emergency patches, but the definition of "critical" is informal.
- SSH access to production restricted to a bastion host with key-based auth, but direct access still possible for troubleshooting. Sessions not recorded.

## O3: Mature infrastructure hardening (Score 4-5)

- CIS Benchmarks applied for the cloud provider, Kubernetes, and Docker. Compliance measured and reported.
- Secrets in Vault/KMS with automated rotation. Secret injection at runtime — never in code, env vars, or config files.
- Automated infrastructure scanning (tfsec, checkov) in CI/CD — critical findings block deployment.
- Patch SLA enforced: critical within 48 hours, high within 1 week. Compliance tracked in dashboard.
- Immutable infrastructure: no SSH to production. All changes via IaC (Terraform/Pulumi) through PR review.
- Infrastructure drift detection: automated alerts when runtime config diverges from IaC definition.
- Unused ports and services closed. Network segmentation enforced. Non-production environments have equivalent hardening or synthetic data.

## O4: Immature resilience (Score 1-2)

- Backups: "The cloud provider handles that." Never restore-tested.
- No formal DR plan. RPO/RTO not defined. "We will figure it out when it happens."
- No circuit breakers — a single slow downstream service cascades to full outage.
- Single points of failure: one database instance, one deployment region, one person who knows the recovery process.
- Graceful degradation not designed — when a dependency is down, users see raw 500 errors or infinite loading.

## O4: Adequate resilience (Score 3)

- DR plan documented with RPO of 4 hours, RTO of 8 hours. Plan reviewed annually but never tested end-to-end.
- Backups configured (daily automated snapshots) but restore never tested. Team assumes backups work because the job reports success.
- Circuit breakers on payment service but not on other downstream dependencies. Retry logic exists but without jitter, risking thundering herd.
- Single-region deployment with multi-AZ. No cross-region failover capability.
- Graceful degradation partially designed — main user flows show friendly error pages, but admin and reporting features surface raw errors when dependencies are down.

## O4: Mature resilience (Score 4-5)

- DR plan with defined RPO (e.g., 1 hour) and RTO (e.g., 4 hours). Tested annually with documented results.
- Backups verified via automated restore tests at least quarterly. Restore time measured against RTO.
- Circuit breakers on all critical downstream dependencies. Retry with exponential backoff and jitter.
- Multi-AZ or multi-region deployment. No single points of failure for critical paths.
- Chaos engineering practiced: monthly failure injection (Chaos Monkey/Litmus), annual DR test with region failover.
- Graceful degradation designed: when Stripe is down, show "payments temporarily unavailable" with queued retry, not a 500 error.
- Runbooks for top failure scenarios tested by on-call engineers, not just written and filed away.

## Comparison table

| Criterion | Immature (Score 1-2) | Adequate (Score 3) | Mature (Score 4-5) |
|-----------|---------------------|-------------------|-------------------|
| O1: Logging | Application logs only, local server, no alerting | Auth events logged, centralized but not tamper-proof, partial PII scrubbing, limited alerting | Security event taxonomy, SIEM integration, PII scrubbed, <15min MTTD |
| O2: Incident Response | "Call the CTO," no detection rules, no exercises | IR plan exists, basic escalation path, no exercises, post-incident reviews for major incidents only | MITRE-mapped detection, tested playbooks, <4hr MTTR, post-incident reviews |
| O3: Hardening | Default configs, secrets in env vars, manual patching | Vault for secrets (manual rotation), partial CIS Benchmarks, local scanning, monthly patching | CIS Benchmarks, vault-managed secrets, IaC-only changes, automated scanning |
| O4: Resilience | "Cloud provider handles it," untested backups, SPOFs | DR plan documented, daily backups (untested restore), partial circuit breakers, single-region multi-AZ | Tested DR with met RPO/RTO, chaos engineering, circuit breakers, graceful degradation |
