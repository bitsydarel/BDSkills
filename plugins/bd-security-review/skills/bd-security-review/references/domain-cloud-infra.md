# Security Review — Cloud & Infrastructure

## Domain context

Cloud infrastructure runs in shared, multi-tenant environments where misconfiguration is the #1 cause of breaches. This domain covers IaaS, PaaS, serverless, containers (Docker), and orchestration (Kubernetes). The security model shifts from perimeter-based to identity-based: there is no firewall protecting your cluster — IAM policies, network policies, and workload identity are your security boundary. Ephemeral resources, infrastructure-as-code, and immutable deployments change how hardening, secrets management, and incident response work.

## OWASP coverage

This domain covers 4 OWASP lists because they are all cloud infrastructure deployment models.

### OWASP Cloud-Native Application Security Top 10 (2022)

| # | Risk | Mapped Criteria |
|---|------|----------------|
| CNAS-1 | Insecure Cloud, Container or Orchestration Configuration | O3 |
| CNAS-2 | Injection Flaws | A3 |
| CNAS-3 | Improper Authentication & Authorization | A1, A2 |
| CNAS-4 | CI/CD Pipeline & Software Supply Chain Flaws | A5 |
| CNAS-5 | Insecure Secrets Storage | O3 |
| CNAS-6 | Over-Permissive or Insecure Network Policies | T3 |
| CNAS-7 | Using Components with Known Vulnerabilities | A5 |
| CNAS-8 | Improper Assets Management | T1 |
| CNAS-9 | Inadequate Compute Resource Quota Limits | A6 |
| CNAS-10 | Ineffective Logging & Monitoring | O1 |

### OWASP Kubernetes Top 10 (2022)

| # | Risk | Mapped Criteria |
|---|------|----------------|
| K01 | Insecure Workload Configurations | O3 |
| K02 | Supply Chain Vulnerabilities | A5 |
| K03 | Overly Permissive RBAC Configurations | A2 |
| K04 | Lack of Centralized Policy Enforcement | G3 |
| K05 | Inadequate Logging and Monitoring | O1 |
| K06 | Broken Authentication Mechanisms | A1 |
| K07 | Missing Network Segmentation Controls | T3 |
| K08 | Secrets Management Failures | O3 |
| K09 | Misconfigured Cluster Components | O3 |
| K10 | Outdated and Vulnerable Kubernetes Components | A5 |

### OWASP Docker Top 10 (2022)

| # | Risk | Mapped Criteria |
|---|------|----------------|
| D01 | Secure User Mapping | A2 |
| D02 | Patch Management Strategy | A5 |
| D03 | Network Segmentation and Firewalling | T3 |
| D04 | Secure Defaults and Hardening | O3 |
| D05 | Maintain Security Contexts | O3 |
| D06 | Protect Secrets | O3 |
| D07 | Resource Protection | A6 |
| D08 | Container Image Integrity | A5 |
| D09 | Follow Immutable Paradigm | O3 |
| D10 | Logging | O1 |

### OWASP Serverless Top 10 (2017)

| # | Risk | Mapped Criteria |
|---|------|----------------|
| SAS-1 | Function Event-Data Injection | A3 |
| SAS-2 | Broken Authentication | A1 |
| SAS-3 | Insecure Serverless Deployment Configuration | O3 |
| SAS-4 | Over-Privileged Function Permissions | A2 |
| SAS-5 | Inadequate Function Monitoring and Logging | O1 |
| SAS-6 | Insecure 3rd Party Dependencies | A5 |
| SAS-7 | Insecure Application Secrets Storage | O3 |
| SAS-8 | DoS & Financial Resource Exhaustion | A6 |
| SAS-9 | Functions Execution Flow Manipulation | A3 |
| SAS-10 | Improper Exception Handling and Verbose Error Messages | A6 |

## Criterion interpretation for cloud & infrastructure

| Criterion | Cloud-Specific Interpretation |
|-----------|------------------------------|
| T1 | Map all exposed services, load balancers, API gateways, storage endpoints, serverless function triggers, K8s ingresses |
| T2 | STRIDE per cloud service: IAM as identity, network policies as authorization, encrypted storage as confidentiality |
| T3 | VPC/network boundaries, service mesh mTLS, namespace isolation, workload identity federation as trust boundaries |
| T4 | Cloud-specific threat actors: insider with console access, compromised CI/CD, stolen cloud credentials |
| A1 | Workload identity (not long-lived keys). Service account authentication. IAM federation. No shared credentials |
| A2 | IAM least privilege per service. K8s RBAC per namespace. Pod security standards. No wildcard permissions |
| A3 | Serverless function input validation. Container image content validation. IaC template injection prevention |
| A4 | Encryption at rest (KMS-managed keys). TLS for all internal communication. Secrets in vault, not env vars |
| A5 | Base image provenance. Container registry scanning. SBOM for container images. Binary authorization before deploy |
| A6 | Resource quotas and limits per container/function. Request/memory limits. Timeout configuration. No unbounded scaling |
| A7 | Cloud console access warnings for destructive operations. Cost anomaly alerts as security signals |
| O1 | Cloud audit logs (CloudTrail, Audit Logs). K8s audit logs. Container stdout/stderr to centralized logging |
| O2 | Cloud-native detection (GuardDuty, Security Command Center). K8s runtime security (Falco). Alert on IAM changes |
| O3 | CIS Benchmarks for cloud/K8s/Docker. IaC scanning (tfsec, checkov). No SSH to containers. Immutable infrastructure |
| O4 | Multi-region/multi-AZ deployment. Backup verification. Chaos engineering (Chaos Monkey). DR runbooks tested |
| G1 | Cloud compliance programs (SOC 2, ISO 27001 for cloud). Data residency requirements mapped to regions |
| G2 | Data classification per storage service. Retention policies on buckets/databases. No PII in logs |
| G3 | Cloud security policy enforcement (OPA/Gatekeeper, AWS Config Rules, Azure Policy). IaC review process |
| G4 | Cloud audit trail immutability. Change management via IaC PRs. No manual console changes in production |

## Top 5 cloud-specific anti-patterns

### 1. Overprivileged IAM

**Signs**: IAM policies with `"Action": "*"` or `"Resource": "*"`. Service accounts with admin permissions. No distinction between dev and prod IAM. Long-lived access keys instead of workload identity.

**Impact**: A single compromised service or credential grants full cloud account access. Lateral movement is trivial. Blast radius of any breach is maximized to the entire cloud account.

**Fix**: Apply least-privilege IAM with specific actions and resources. Use workload identity federation (no long-lived keys). Implement permission boundaries. Audit IAM with tools like IAM Access Analyzer. Alert on any wildcard permissions.

---

### 2. Secrets in Environment Variables

**Signs**: Database passwords in Kubernetes ConfigMaps (not Secrets). API keys in docker-compose.yml committed to git. Secrets visible in `docker inspect` or `kubectl describe pod`. No external secrets management.

**Impact**: Anyone with cluster read access sees all secrets. Container orchestration logs may capture environment variables. Git history preserves secrets even after removal.

**Fix**: Use external secrets management (Vault, AWS Secrets Manager, GCP Secret Manager) with injected secrets at runtime. K8s: use External Secrets Operator or CSI Secret Store Driver. Never commit secrets to version control. Rotate all leaked secrets immediately.

---

### 3. Flat Network Architecture

**Signs**: All pods/containers can communicate with each other. No Kubernetes NetworkPolicies. No VPC segmentation between workloads. Database accessible from all services, not just those that need it.

**Impact**: Compromised container can reach any other service in the cluster. Lateral movement is unrestricted. Database accessible from any workload, not just the application tier.

**Fix**: Implement Kubernetes NetworkPolicies (default deny, explicit allow). Segment VPCs with private subnets. Use service mesh for mTLS and traffic policies. Database accessible only from application service accounts.

---

### 4. Immutable Infrastructure Bypass

**Signs**: Engineers SSH into production containers to debug. Manual configuration changes applied via kubectl exec. No IaC for infrastructure (console click-ops). Container images modified after build.

**Impact**: Configuration drift from desired state. Manual changes are unaudited and unreproducible. Security patches must be applied individually instead of redeploying. Incident forensics compromised by manual modifications.

**Fix**: No SSH to production containers. All changes via IaC (Terraform, Pulumi, CloudFormation) through PR review. Immutable container images — rebuild and redeploy, never patch in place. Use debug sidecars or ephemeral containers for troubleshooting.

---

### 5. Cloud Storage Misconfiguration

**Signs**: S3 buckets with public access. Storage accounts without encryption at rest. No access logging on storage. Overly permissive bucket policies. Lifecycle policies not set (data retained indefinitely).

**Impact**: Public storage buckets are the #1 source of cloud data breaches (Capital One, Twitch, multiple healthcare breaches). Unencrypted storage violates compliance requirements. No access logging means breaches go undetected.

**Fix**: Block public access at the account level (S3 Block Public Access, Azure storage firewall). Enable encryption at rest with customer-managed keys. Enable access logging. Set lifecycle policies for data retention. Scan for misconfigured storage with CSPM tools.

---

## Key controls checklist

- [ ] IAM least privilege — no wildcard actions or resources
- [ ] Workload identity federation — no long-lived access keys
- [ ] Kubernetes NetworkPolicies — default deny ingress and egress
- [ ] Secrets in external vault — not in env vars, ConfigMaps, or code
- [ ] Container image scanning in CI/CD (Trivy, Grype)
- [ ] IaC scanning (tfsec, checkov) with blocking on critical findings
- [ ] Pod security standards enforced (restricted profile)
- [ ] Cloud audit logs enabled and shipped to SIEM
- [ ] Storage: public access blocked, encryption at rest, access logging
- [ ] Resource quotas and limits on all containers/functions
- [ ] CIS Benchmarks applied for cloud provider, K8s, and Docker
- [ ] Immutable infrastructure — no SSH, no manual changes, IaC only

## Company practices

- **Google**: BeyondCorp zero trust, GKE Autopilot with hardened defaults, Binary Authorization for container deployments, gVisor for container sandboxing
- **Netflix**: Chaos Monkey for resilience testing, Repokid for IAM least privilege, Consoleme for cloud access management, immutable AMIs
- **Spotify**: Kubernetes hardening with OPA policies, HashiCorp Vault for secrets, IaC-only changes with Terraform, centralized cloud security monitoring
- **Microsoft**: Azure Security Defaults, Defender for Cloud (CSPM), Azure Policy for guardrails, confidential computing for sensitive workloads

## Tools and standards

- **CSPM**: Prowler (AWS), ScoutSuite (multi-cloud), Wiz, Orca
- **IaC Scanning**: tfsec, checkov, KICS, Snyk IaC
- **Container Scanning**: Trivy, Grype, Snyk Container
- **Kubernetes**: kube-bench (CIS), OPA/Gatekeeper (policy), Falco (runtime), kubeaudit
- **Standards**: CIS Benchmarks (AWS/Azure/GCP/K8s/Docker), OWASP Cloud-Native/K8s/Docker/Serverless Top 10, SLSA
