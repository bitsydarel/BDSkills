# AWS Well-Architected Framework

AWS Well-Architected Framework (November 2024 refresh) mapped to this skill's 6 evaluation lenses. Load this file when reviewing systems deployed on AWS to apply industry-validated architecture review questions alongside the standard evaluation criteria.

Note: Security pillar details are handled by the bd-security-review skill. This file covers architecture-relevant security patterns (IAM architecture, network design, encryption architecture, Zero Trust) that affect structural quality. Framework version: AWS Well-Architected November 2024.

---

## 1. Pillars overview

### Operational Excellence

Design, run, and monitor systems to deliver business value and continually improve.

**Design principles**: (1) Organize teams around business outcomes. (2) Implement observability for actionable insights — KPIs, telemetry, workload health. (3) Safely automate where possible — rate control, error thresholds, approval gates. (4) Make frequent, small, reversible changes — reduce blast radius. (5) Refine operations procedures frequently. (6) Anticipate failure — test failure scenarios, manage risk proactively. (7) Learn from all operational events and metrics. (8) Use managed services — reduce operational burden.

**Best practice areas**: Organization (business objectives, team structure), Prepare (runbooks, CI/CD, deployment automation), Operate (monitoring, event response, change management), Evolve (retrospectives, tooling improvements).

**Key review questions**:
- How is infrastructure defined and version-controlled? (S1)
- How are operational decisions captured and discoverable? (S3)
- Can deployments be safely rolled back within minutes? (S4)
- Can a production incident be traced from symptom to root cause in < 15 minutes? (Q4)
- Are operational procedures executable and tested, not just documented? (Q1)

**Pillar anti-patterns**: Manual deployments with no IaC, no runbook automation, no post-incident reviews, tribal knowledge instead of ADRs.

---

### Security

Protect information, systems, and assets while delivering business value.

**Covered by**: bd-security-review skill for detailed assessment. Architecture-relevant aspects below in Section 4 (Security Architecture): IAM architecture, network security design, encryption architecture, Zero Trust patterns.

**Architecture-relevant design principles**: (1) Implement a strong identity foundation — least privilege, centralized identity, eliminate long-term credentials. (2) Maintain traceability — monitor, alert, and audit all actions. (3) Apply security at all layers — defense in depth. (4) Automate security best practices — IaC-enforced security controls. (5) Protect data in transit and at rest. (6) Keep people away from data — reduce manual access. (7) Prepare for security events — incident response automation.

---

### Reliability

Recover from failures and meet demand.

**Design principles**: (1) Automatically recover from failure. (2) Test recovery procedures. (3) Scale horizontally to increase aggregate availability. (4) Stop guessing capacity. (5) Manage change through automation.

**Best practice areas**: Foundations (service limits, multi-AZ/region, no SPOFs), Change Management (IaC, CI/CD, canary/blue-green, rollback), Failure Management (automated backups, cross-region replication, fault injection), Monitoring (availability tracking, MTTR, error rates, distributed tracing).

**Key review questions**:
- What is the blast radius of a single component failure? (Q2)
- Are there single points of failure at any layer? (Q3)
- Can the system auto-recover with RTO < 60 seconds? (Q3)
- Are circuit breakers and timeouts enforced at all external boundaries? (D1)
- Is the service dependency graph verified as acyclic? (D4)

**Pillar anti-patterns**: Single-AZ deployment, no circuit breakers, synchronous chains without timeouts, no chaos engineering, no failover testing.

---

### Performance Efficiency

Use computing resources efficiently and maintain efficiency as demand changes.

**Design principles**: (1) Democratize advanced technologies — consume services rather than building. (2) Go global in minutes — deploy to multiple regions. (3) Use serverless architectures. (4) Experiment more often. (5) Consider mechanical sympathy — match technology to workload characteristics.

**Best practice areas**: Selection (right resource types for compute, storage, database, network), Review (baselines, optimization opportunities), Optimization (caching, compression, query tuning, profiling), Trade-offs (performance vs cost, consistency vs latency).

**Key review questions**:
- Is the database type chosen based on access patterns, not habit? (DA1)
- Can the system handle 10x load with infrastructure changes only? (Q3)
- Are performance bottlenecks identifiable within 1 minute? (Q4)
- Are performance regressions caught automatically in CI? (S1)
- Is connection pooling sized for expected concurrency? (DA5)

**Pillar anti-patterns**: Database chosen by familiarity not access patterns, no performance baselines, no caching strategy, manual capacity planning.

---

### Cost Optimization

Avoid unnecessary costs.

**Design principles**: (1) Implement cloud financial management. (2) Adopt a consumption model — pay only for what is used. (3) Measure and monitor efficiency. (4) Analyze and attribute expenditure. (5) Optimize over time.

**Best practice areas**: Expenditure Awareness (tagging, cost allocation, billing alerts, anomaly detection), Cost-Effective Resources (right-sizing, Reserved Instances, Spot, managed services), Matching Supply with Demand (auto-scaling, scheduling), Optimizing Over Time (review new services, benchmark).

**Key review questions**:
- Are resources consumed proportional to business value? (Q3)
- Which cloud services could be replaced without changing business logic? (D5)
- Is vendor lock-in confined to thin abstraction layers? (D5)
- Can cost optimizations be adopted without architectural rewrites? (S4)
- Are unused resources detected and decommissioned within 1 week? (D5)

**Pillar anti-patterns**: No cost allocation tags, static over-provisioning, no auto-scaling, ignoring Reserved Instance recommendations, no cost anomaly detection.

---

### Sustainability

Minimize environmental impact of cloud workloads.

**Design principles**: (1) Understand impact. (2) Establish sustainability goals. (3) Maximize utilization. (4) Anticipate and adopt efficient hardware/software. (5) Use managed services. (6) Reduce downstream impact.

**Best practice areas**: Energy Management (right-sizing, auto-scaling, Graviton processors), Workload Optimization (eliminate unused resources, Spot, data lifecycle), Data & Storage Optimization (storage classes, compression, efficient formats), Software & Architecture (caching, async patterns, minimize cross-region transfer).

**Key review questions**:
- Is CPU utilization > 70% during normal operation? (Q3)
- Are idle data resources decommissioned automatically? (DA5)
- Can more efficient technologies be adopted without rewrite? (S4)

**Pillar anti-patterns**: CPU utilization < 20%, no auto-scaling, no data lifecycle policies, cross-region data transfers without justification.

---

## 2. Top 50 best practices

### Infrastructure (1-5)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 1 | IaC for all infrastructure | Define 100% of infrastructure with CloudFormation, CDK, or Terraform. Version-control all templates. No manual console changes. | S1 | Critical |
| 2 | Multi-AZ deployment | Deploy all stateful and stateless components across at least 2 Availability Zones. Use AZ-aware load balancing. | Q2, Q3 | Critical |
| 3 | Multi-region DR strategy | Define RPO/RTO targets. Implement cross-region replication for critical data. Test failover annually minimum. | Q3, DA2 | Major |
| 4 | Immutable deployments | Replace instances rather than updating in-place. Use AMI-based or container-based deployments. No SSH into production. | S4 | Major |
| 5 | Environment parity | Staging mirrors production architecture. IaC parameters differentiate environments, not separate templates. | S1, Q1 | Major |

### Compute (6-10)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 6 | Right-size instances | Use AWS Compute Optimizer recommendations. Review instance families quarterly. Match instance type to workload profile. | Q3 | Major |
| 7 | Graviton adoption | Use Graviton (ARM) instances for 20-40% better price-performance. Validate application compatibility. | Q3 | Minor |
| 8 | Spot Instances for fault-tolerant workloads | Use Spot for batch processing, CI/CD, stateless workers. Implement graceful interruption handling (2-minute warning). | Q3 | Minor |
| 9 | Auto-scaling with target tracking | Configure target-tracking scaling policies. Set scale-out threshold at 70% CPU or custom application metrics. Pre-warm for predictable spikes. | Q3 | Critical |
| 10 | Container vs serverless selection | Use Lambda for event-driven, < 15 min execution. Use ECS/EKS for long-running, high-throughput. Document selection rationale in ADR. | DA1, S3 | Major |

### Data (11-15)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 11 | Database-per-service | Each service owns its database. No cross-service direct DB access. Shared data accessed through owning service's API. | DA3 | Critical |
| 12 | Polyglot persistence with justification | Choose database type based on access patterns (relational, document, key-value, graph). Document selection rationale in ADR. | DA1, S3 | Major |
| 13 | Data lifecycle policies | Define TTL, archival, and deletion policies for all data stores. Automate transitions between storage tiers (S3 Intelligent-Tiering). | DA5 | Major |
| 14 | Backup strategy with tested recovery | Automated backups with cross-region replication. Test recovery quarterly. Document RPO/RTO per data store. | DA2 | Critical |
| 15 | Encryption at rest for all data stores | Enable default encryption (SSE-S3, RDS encryption, DynamoDB encryption). Use KMS CMK for sensitive data. No unencrypted data stores. | DA2 | Critical |

### Networking (16-20)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 16 | VPC design with subnet tiers | Public subnets (ALB only), private subnets (applications), isolated subnets (databases). No direct internet access for application or data tiers. | D1, B4 | Critical |
| 17 | PrivateLink for AWS service access | Use VPC endpoints (Interface/Gateway) for S3, DynamoDB, SQS, SNS, KMS. Eliminate NAT Gateway costs and internet traversal. | D5 | Major |
| 18 | Transit Gateway for multi-VPC | Centralize VPC-to-VPC and on-premises connectivity. Avoid mesh peering. Route tables enforce network boundaries. | D1 | Major |
| 19 | Global Accelerator for latency-sensitive APIs | Use Global Accelerator or CloudFront for global user bases. Anycast IPs route to nearest edge. | Q3 | Minor |
| 20 | DNS architecture with Route 53 | Health-checked routing policies (failover, weighted, latency-based). Private hosted zones for internal service discovery. | Q3 | Major |

### Security (21-25)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 21 | Least-privilege IAM policies | No wildcard (*) actions or resources in production. Use IAM Access Analyzer to validate. Scope policies to specific resources. | D5 | Critical |
| 22 | IAM Roles instead of access keys | Use IAM Roles for EC2, ECS tasks, Lambda. Eliminate long-term access keys. Use OIDC federation for CI/CD (GitHub Actions). | D3, D5 | Critical |
| 23 | Secrets Manager for all credentials | No hardcoded credentials. Rotate secrets automatically. Use Secrets Manager or SSM Parameter Store with KMS encryption. | D5 | Critical |
| 24 | Network segmentation with Security Groups | Security Groups as primary firewall. Principle of least access — allow only required ports/protocols. Reference Security Groups by ID, not CIDR. | B4, D1 | Critical |
| 25 | Encryption in transit everywhere | TLS 1.2+ for all API calls, inter-service communication, and database connections. Certificate management via ACM. | DA2 | Critical |

### Observability (26-30)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 26 | CloudWatch custom metrics and alarms | Define business-level metrics (orders/sec, error rate by feature). Alert on anomalies, not just thresholds. Use composite alarms. | Q4 | Critical |
| 27 | X-Ray distributed tracing | Instrument all services with X-Ray SDK or OpenTelemetry. Trace requests across API Gateway → Lambda/ECS → DynamoDB/RDS. Correlation IDs at all boundaries. | Q4 | Major |
| 28 | Structured logging with Log Insights | JSON-structured logs with trace IDs, request IDs, user context. Use CloudWatch Logs Insights for queries. Centralize cross-account logs. | Q4 | Major |
| 29 | Operational dashboards | Per-service dashboards showing latency (P50/P95/P99), error rate, throughput, saturation. Executive dashboard for SLO compliance. | Q4 | Major |
| 30 | SLO tracking and error budgets | Define SLOs for critical paths. Track error budget burn rate. Alert at 80% budget consumption. Policy for exceeded budgets. | Q4, Q3 | Major |

### Deployment (31-35)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 31 | Blue/green deployments | Use CodeDeploy or ALB weighted target groups. Zero-downtime deployments. Instant rollback by switching traffic. | S4 | Major |
| 32 | Canary releases | Route 1-5% of traffic to new version. Monitor error rates and latency. Auto-rollback on anomaly detection. | S4 | Major |
| 33 | Feature flags | Decouple deployment from release. Use LaunchDarkly, AWS AppConfig, or CloudWatch Evidently. Kill switch for all new features. | S4 | Minor |
| 34 | Rollback automation | Automated rollback triggered by CloudWatch alarm (error rate > threshold). Rollback time < 5 minutes. No manual intervention required. | S4 | Critical |
| 35 | CI/CD pipeline with architecture gates | Pipeline includes unit tests, integration tests, architecture fitness functions (dependency checks, lint rules), security scanning, performance baselines. | S1, Q1 | Major |

### Cost (36-40)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 36 | Reserved Instances / Savings Plans | Commit to 1-year or 3-year for steady-state workloads. Target > 80% coverage of baseline compute. Review quarterly. | Q3 | Major |
| 37 | Comprehensive tagging strategy | Tag all resources with: Environment, Service, Owner, CostCenter, Project. Enforce via AWS Organizations SCP or Config rules. | S1 | Major |
| 38 | Right-sizing with Compute Optimizer | Review Compute Optimizer recommendations monthly. Automate right-sizing for non-production. Track cost-per-transaction trend. | Q3 | Major |
| 39 | Auto-scaling to zero for non-production | Schedule non-prod environments to scale down nights/weekends. Use Lambda or Step Functions for scheduling. | Q3 | Minor |
| 40 | Cost anomaly detection | Enable AWS Cost Anomaly Detection. Configure alerts for >10% daily increase. Review anomalies within 24 hours. | D5 | Major |

### Resilience (41-45)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 41 | Circuit breakers at all external boundaries | Implement circuit breaker pattern (open/half-open/closed) for all external service calls. Use libraries (Resilience4j, Polly) or service mesh (App Mesh, Istio). | D1, Q2 | Critical |
| 42 | Bulkhead isolation | Isolate failure domains with separate thread pools, connection pools, or compute resources per external dependency. One dependency failure must not exhaust shared resources. | Q2 | Major |
| 43 | Retries with exponential backoff and jitter | All external calls use retry with exponential backoff + full jitter. Cap retries (3-5 max). No retry storms. Idempotency required for retried operations. | D1 | Critical |
| 44 | Chaos engineering | Regular fault injection testing (AWS Fault Injection Simulator). Simulate AZ failure, service degradation, network partitions. Document findings and fixes. | Q3, S4 | Major |
| 45 | Multi-AZ for stateful services | RDS Multi-AZ, ElastiCache Multi-AZ, EFS, DynamoDB (automatic). Stateful services must survive single-AZ failure with zero data loss. | DA2, Q3 | Critical |

### Sustainability (46-50)

| # | Practice | Description | Criterion | Severity |
|---|----------|-------------|-----------|----------|
| 46 | Resource utilization targets | Set CPU > 70%, memory > 60% utilization targets for production. Monitor and right-size to meet targets. | Q3 | Minor |
| 47 | Graviton for all compatible workloads | Migrate EC2, RDS, ElastiCache, Lambda to Graviton where supported. 20-40% better energy efficiency. | Q3 | Minor |
| 48 | Data lifecycle with storage tiering | S3 Intelligent-Tiering for variable access patterns. Glacier for archives > 90 days. Delete expired data automatically. | DA5 | Minor |
| 49 | Serverless for bursty workloads | Use Lambda, Fargate, Aurora Serverless for workloads with variable demand. Scale to zero when idle. No idle infrastructure cost. | Q3 | Minor |
| 50 | Minimize cross-region data transfer | Co-locate compute and data in same region. Use CloudFront for content delivery. Use VPC endpoints to avoid internet traversal. | Q3 | Minor |

---

## 3. Anti-patterns

### Compute anti-patterns

| Anti-Pattern | Signs | Impact | Fix | Criterion | Severity |
|-------------|-------|--------|-----|-----------|----------|
| Single-AZ deployment | All instances in one AZ; no AZ-awareness in ASG | AZ failure = total outage | Multi-AZ ASG with AZ-balanced placement | Q2, Q3 | Critical |
| Monolithic Lambda | Single Lambda function > 100MB, > 5 min execution, handles multiple concerns | Cold start > 5s, timeout failures, impossible to debug | Split by business capability, one function per use case | C1, Q3 | Major |
| No auto-scaling | Fixed instance count; manual capacity changes | Over-provisioned (waste) or under-provisioned (outage) during demand spikes | Target-tracking ASG policies on application metrics | Q3 | Critical |
| Over-provisioned instances | CPU < 20% consistently; Compute Optimizer flags downsizing | 2-5x cost waste | Right-size monthly using Compute Optimizer data | Q3 | Major |
| Missing health checks | No ALB health checks; no readiness/liveness probes on ECS/EKS | Unhealthy instances receive traffic; cascading failures | Configure health checks at ALB, target group, and container level | Q4 | Critical |

### Data anti-patterns

| Anti-Pattern | Signs | Impact | Fix | Criterion | Severity |
|-------------|-------|--------|-----|-----------|----------|
| Shared database between services | Multiple services write to same RDS schema; cross-service foreign keys | Changes to one service break others; deployment coupling; no independent scaling | Database-per-service; API for cross-service data access | DA3 | Critical |
| Wrong database type | Relational DB for time-series data; DynamoDB for complex joins | Poor performance, complex workarounds, impedance mismatch | Choose DB by access pattern (DA1); document rationale in ADR | DA1 | Major |
| No connection pooling | Each request creates new DB connection; connection count = request count | Connection exhaustion under load; DB CPU wasted on connection management | RDS Proxy or application-level pool (HikariCP, pgBouncer) | DA5 | Critical |
| DynamoDB hot partition | Sequential partition key (auto-increment ID, timestamp); single item > 10KB | Throttling on hot partition; capacity wasted; 3000 RCU / 1000 WCU per partition limit | Distribute partition key (composite key, UUID); write sharding | DA5 | Major |
| No data lifecycle policy | All data stored indefinitely; no TTL, archival, or deletion | Storage costs grow linearly; query performance degrades; compliance risk | Define retention policies; automate with DynamoDB TTL, S3 lifecycle, RDS snapshot retention | DA5 | Major |

### Networking anti-patterns

| Anti-Pattern | Signs | Impact | Fix | Criterion | Severity |
|-------------|-------|--------|-----|-----------|----------|
| Flat VPC without subnet tiers | All resources in public subnets; no private/isolated subnets | Databases accessible from internet; lateral movement risk; no network segmentation | Three-tier subnets (public/private/isolated); NACLs + SGs | D1, B4 | Critical |
| Missing VPC endpoints | All AWS API calls traverse NAT Gateway and internet | Latency, cost (NAT Gateway $0.045/GB), security exposure | VPC endpoints for S3, DynamoDB, SQS, SNS, KMS, ECR | D5 | Major |
| No API throttling | API Gateway or ALB without rate limiting; no WAF | Abuse, cost explosion, resource exhaustion | API Gateway throttling + WAF rate rules + Shield | Q3 | Major |
| Direct public IP on compute | EC2 instances with public IPs; no bastion or SSM | Attack surface; no audit trail; manual SSH access | SSM Session Manager; remove public IPs; use ALB | D1 | Critical |

### Security anti-patterns

| Anti-Pattern | Signs | Impact | Fix | Criterion | Severity |
|-------------|-------|--------|-----|-----------|----------|
| Over-permissive IAM | Policies with `*` actions or resources; `AdministratorAccess` on application roles | Privilege escalation; blast radius of credential compromise = entire account | Least-privilege policies; IAM Access Analyzer; scope to specific resources | D5 | Critical |
| Hardcoded credentials | AWS access keys in code, environment variables, or config files | Credential leakage via git history, logs, error messages | IAM Roles for compute; Secrets Manager for external credentials | D3, D5 | Critical |
| Missing encryption | Unencrypted EBS volumes, S3 buckets, RDS instances | Data exposure; compliance violations | Default encryption via SCP; KMS CMK for sensitive data | DA2 | Critical |
| No WAF or Shield | Public-facing APIs without AWS WAF; no DDoS protection | SQL injection, XSS, DDoS, bot attacks | WAF with managed rule groups; Shield Advanced for critical workloads | Q3 | Major |

### Cost anti-patterns

| Anti-Pattern | Signs | Impact | Fix | Criterion | Severity |
|-------------|-------|--------|-----|-----------|----------|
| No cost allocation tags | Resources untagged or inconsistently tagged; cost attribution impossible | Cannot identify cost drivers; optimization efforts unfocused | Enforce tagging via SCP; tag compliance > 95% | S1 | Major |
| On-demand for steady-state | 100% on-demand for workloads running 24/7 | 40-72% overspend vs Reserved/Savings Plan pricing | Reserved Instances or Savings Plans for baseline; Spot for variable | Q3 | Major |
| Idle resources accumulating | Unused EBS volumes, unattached EIPs, stopped instances with volumes | Silent cost leak; typical 15-30% of cloud spend is waste | AWS Trusted Advisor; Cost Explorer anomaly detection; weekly cleanup | D5 | Major |

### Observability anti-patterns

| Anti-Pattern | Signs | Impact | Fix | Criterion | Severity |
|-------------|-------|--------|-----|-----------|----------|
| No distributed tracing | Cannot trace request across services; debugging requires log correlation by timestamp | MTTR > 30 minutes; impossible to identify latency source in microservices | X-Ray or OpenTelemetry; correlation IDs at all boundaries | Q4 | Major |
| Missing CloudWatch alarms | No alarms on error rates, latency P99, queue depth, DLQ messages | Failures discovered by users; no proactive detection | Alarms on all SLIs; composite alarms for complex conditions | Q4 | Critical |

### Deployment anti-patterns

| Anti-Pattern | Signs | Impact | Fix | Criterion | Severity |
|-------------|-------|--------|-----|-----------|----------|
| Manual deployments | Console clicks; SSH + git pull; no CI/CD pipeline | Inconsistent environments; no audit trail; rollback requires manual steps | CodePipeline/GitHub Actions; IaC for all resources; automated rollback | S1, S4 | Critical |
| No rollback strategy | Deploy-forward only; rollback = re-deploy previous version manually | Failed deployments cause extended outages; pressure to "fix forward" under duress | Blue/green or canary with automated rollback on alarm | S4 | Critical |

---

## 4. Security architecture

### IAM architecture patterns

**Role-based access**: Define IAM Roles per application component (one role per ECS task definition, one per Lambda function). Each role has exactly the permissions needed for that component's operations. Use IAM policy conditions (aws:SourceVpc, aws:PrincipalTag) to further restrict.

**Cross-account**: Use AWS Organizations with SCPs (Service Control Policies) to enforce guardrails. Separate accounts for: production, staging, security/audit, shared services, sandbox. Cross-account access via IAM Role assumption with external ID.

**Federation**: Use IAM Identity Center (SSO) for human access. OIDC federation for CI/CD (GitHub Actions, GitLab CI). Eliminate long-term access keys entirely.

### Network security architecture

**VPC design**:
- Public subnets: ALB/NLB only, NAT Gateway
- Private subnets: Application tier (ECS/EKS/EC2), Lambda in VPC
- Isolated subnets: RDS, ElastiCache, OpenSearch — no internet route
- Security Groups: stateful, reference by SG ID for inter-tier access
- NACLs: stateless, subnet-level, deny rules for known-bad CIDRs
- VPC Flow Logs: enabled on all VPCs, exported to CloudWatch/S3

**AWS WAF**: Deploy on ALB, API Gateway, CloudFront. Managed rule groups (Core Rule Set, SQL injection, known bad inputs). Custom rules for application-specific threats. Rate-based rules for DDoS mitigation.

**AWS Shield**: Standard (automatic L3/L4 DDoS protection) for all resources. Shield Advanced for critical workloads (L7 DDoS, cost protection, DDoS response team).

### Data protection architecture

**KMS key hierarchy**: AWS managed keys (default) → Customer managed keys (CMK) → Custom key stores (CloudHSM). Use CMK for: sensitive PII, financial data, regulated data. Key policies restrict which roles can encrypt/decrypt.

**Encryption at rest**: RDS (TDE or storage encryption), DynamoDB (AWS owned or CMK), S3 (SSE-S3 default, SSE-KMS for sensitive), EBS (encrypted by default via account setting), EFS (encryption at rest enabled at creation).

**Encryption in transit**: TLS 1.2+ enforced on all ALB listeners. ACM-managed certificates with auto-renewal. RDS SSL/TLS connections enforced via parameter group (rds.force_ssl = 1). VPC endpoint traffic stays on AWS backbone.

### Zero Trust on AWS

- No public IPs on compute instances — all access via ALB/API Gateway or SSM
- VPC endpoints for all AWS service access — no internet traversal for API calls
- Service mesh (App Mesh or Istio on EKS) for mutual TLS between services
- IAM authentication for all inter-service calls (SigV4, IAM auth for API Gateway)
- No bastion hosts — SSM Session Manager for administrative access

### Secrets management

**Secrets Manager**: Database credentials, API keys, OAuth tokens. Automatic rotation with Lambda rotation functions. Cross-account sharing via resource policies. Caching with SDK client-side cache (reduces API calls).

**SSM Parameter Store**: Configuration values, feature flags, non-sensitive parameters (Standard tier, free). SecureString type for sensitive values (uses KMS). Hierarchical path organization (/prod/myapp/db/password).

### Container security

- ECR image scanning (on-push and continuous with Amazon Inspector)
- ECS/EKS: IAM Roles for Tasks/Pods (no shared node-level credentials)
- EKS Pod Security Standards: restricted or baseline profile
- Image signing with Sigstore/Notation via ECR
- No privileged containers; read-only root filesystem where possible
- Network policies (EKS) or Security Groups (ECS) for pod-to-pod isolation

### Compliance integration

- AWS Config Rules: automated compliance checks against architecture rules
- Security Hub: aggregated security findings from GuardDuty, Inspector, Config, Macie
- GuardDuty: threat detection for account compromise, instance compromise, S3 data exfiltration
- CloudTrail: audit log for all API calls — enabled in all regions, immutable log storage

---

## 5. Threat analysis

### STRIDE mapping to AWS services

| Threat | AWS Exposure | Mitigation |
|--------|-------------|------------|
| **Spoofing** | Stolen IAM credentials, assumed roles, forged API requests | MFA, short-lived STS tokens, IAM conditions (source IP, VPC), CloudTrail monitoring |
| **Tampering** | Modified S3 objects, altered Lambda code, changed security groups | S3 Object Lock, code signing (Lambda), Config rules for drift detection, CloudTrail integrity validation |
| **Repudiation** | Disabled CloudTrail, deleted logs, no audit trail | CloudTrail in all regions with S3 immutable storage, CloudWatch Logs retention, cross-account log delivery |
| **Information Disclosure** | Public S3 buckets, unencrypted data, overly broad IAM policies | S3 Block Public Access (account level), encryption at rest/transit, Macie for PII detection |
| **Denial of Service** | Resource exhaustion, bill shock, service limits | Shield Advanced, WAF rate limiting, API Gateway throttling, service quotas, auto-scaling |
| **Elevation of Privilege** | IAM policy escalation, cross-account role chaining, container escape | IAM Access Analyzer, permission boundaries, SCP guardrails, EKS pod security |

### Common attack vectors

**Credential compromise**: Leaked access keys in git repositories, phishing for console access, metadata service exploitation (IMDSv2 required to mitigate). Mitigation: eliminate long-term keys, enforce IMDSv2, monitor with GuardDuty.

**Network exposure**: Public security groups, misconfigured NACLs, open management ports (SSH/RDP). Mitigation: Security Hub checks, VPC Flow Log analysis, no public IPs on compute.

**Data exfiltration**: Public S3 buckets, overly broad S3 policies, unmonitored DNS tunneling. Mitigation: S3 Block Public Access, Macie classification, GuardDuty DNS anomaly detection, VPC Flow Logs.

**Supply chain**: Compromised container images, malicious Lambda layers, typosquatting packages. Mitigation: ECR scanning, image signing, Lambda code signing, private package repositories.

**Insider threat**: Over-privileged IAM users, insufficient access logging, long-lived credentials. Mitigation: least privilege, CloudTrail monitoring, access reviews, credential rotation.

### Container/EKS threat model

Cluster compromise via: unauthenticated API server, RBAC misconfiguration, pod escape (privileged containers), image vulnerabilities. Mitigate with: private API endpoint, fine-grained RBAC, pod security standards, runtime security (GuardDuty for EKS), network policies.

### Serverless (Lambda) threat model

Function compromise via: dependency vulnerabilities, injection through event data, over-privileged execution role. Mitigate with: minimal IAM role per function, input validation, dependency scanning (Inspector), Lambda layers pinned to version, reserved concurrency limits.

### API Gateway security

Authentication (Cognito, Lambda authorizer, IAM), request validation (model schemas), throttling (account and API level), WAF integration, mutual TLS for B2B APIs, resource policies for cross-account access control.

### S3 security

Block Public Access at account level. Bucket policies with explicit deny for non-SSL requests. Object Lock for compliance (WORM). Access logging enabled. Server access logging or CloudTrail data events for audit. MFA Delete for versioned buckets.

---

## 6. Data architecture

### Database selection guide

| Service | Type | Best For | Access Pattern | Criterion |
|---------|------|----------|---------------|-----------|
| **Aurora** | Relational (MySQL/PostgreSQL) | OLTP with high throughput, read replicas | Complex queries, joins, transactions, up to 128TB | DA1 |
| **RDS** | Relational | Standard OLTP, single-region | SQL, joins, ACID transactions | DA1 |
| **DynamoDB** | Key-value / Document | Single-digit-ms latency at any scale | Key-based lookups, denormalized data, < 400KB items | DA1 |
| **ElastiCache** | In-memory (Redis/Memcached) | Caching, session storage, leaderboards | Key-based, sub-ms latency, volatile data | DA1, Q3 |
| **Redshift** | Columnar warehouse | Analytics, BI, large-scale aggregations | Complex analytical queries on TB-PB data | DA1 |
| **Neptune** | Graph | Social networks, knowledge graphs, fraud detection | Graph traversals, relationship queries | DA1 |
| **Timestream** | Time-series | IoT telemetry, DevOps metrics, application logs | Time-range queries, downsampling, retention policies | DA1 |
| **MemoryDB** | Durable in-memory (Redis) | Microservice state, session stores requiring durability | Redis API with durability guarantees | DA1 |
| **DocumentDB** | Document (MongoDB-compatible) | MongoDB workloads on AWS | MongoDB query API, JSON documents | DA1 |
| **Keyspaces** | Wide-column (Cassandra-compatible) | Cassandra migrations to managed service | CQL queries, wide-column data model | DA1 |
| **OpenSearch** | Search / Analytics | Full-text search, log analytics, observability | Text search, aggregations, dashboards | DA1 |
| **QLDB** | Ledger | Audit trails, supply chain, financial records | Immutable, cryptographically verifiable history | DA1 |

### Data lake architecture

S3 as central data lake storage → Glue for ETL and Data Catalog → Athena for serverless SQL queries → Lake Formation for governance (fine-grained access control, cross-account sharing). Bronze/silver/gold tiering: raw ingestion → cleaned/validated → aggregated/modeled. Use Parquet/ORC for analytical workloads. Partitioning by date/region for query performance.

### Event-driven data architecture

**EventBridge**: Central event bus for application events. Schema registry for event contracts. Event rules route to Lambda, SQS, Step Functions. Cross-account event routing.

**Kinesis Data Streams**: Real-time streaming at scale. Enhanced fan-out for parallel consumers. Retention up to 365 days. Use for: click streams, IoT telemetry, real-time dashboards.

**SQS**: Decoupling between services. Standard (at-least-once, best-effort ordering) vs FIFO (exactly-once, ordered). Dead-letter queues for failed messages. Long polling to reduce cost.

**SNS**: Fan-out pub/sub. Message filtering by attributes. Combine with SQS for reliable fan-out (SNS → multiple SQS queues).

### CQRS / Event Sourcing on AWS

Command side: API Gateway → Lambda/ECS → DynamoDB/Aurora for writes. Events published to EventBridge or Kinesis. Event store: DynamoDB (with stream) or Kinesis Data Streams (retention = event log). Query side: Lambda consumer → materialized views in DynamoDB/ElastiCache/OpenSearch. Eventual consistency accepted; propagation typically < 1 second.

### Data replication and consistency

- Aurora Global Database: < 1 second cross-region replication, RPO < 1 second
- DynamoDB Global Tables: multi-region, multi-active, eventual consistency (typically < 1 second)
- S3 Cross-Region Replication: async, eventual consistency, for DR and compliance
- ElastiCache Global Datastore: cross-region read replicas, < 1 second lag

### Backup and disaster recovery

| DR Strategy | RTO | RPO | AWS Implementation |
|------------|-----|-----|-------------------|
| Backup & Restore | Hours | Hours | AWS Backup, S3 cross-region, RDS snapshots |
| Pilot Light | 10-30 min | Minutes | Core infra running in DR region, scale up on failover |
| Warm Standby | Minutes | Seconds | Scaled-down copy in DR region, Route 53 failover |
| Multi-Site Active/Active | < 1 min | Near-zero | Multi-region deployment, DynamoDB Global Tables, Aurora Global |

### Data governance

Lake Formation: column-level and row-level security on data lake. Glue Data Catalog: centralized metadata. Macie: PII discovery and classification. S3 Object Lock: compliance retention (WORM). CloudTrail data events: audit trail for all data access.

---

## 7. Performance architecture

### Caching strategies

| Layer | Service | Use Case | TTL Strategy |
|-------|---------|----------|-------------|
| Edge | CloudFront | Static assets, API responses, dynamic content | Cache-Control headers; invalidation on deploy |
| API | API Gateway cache | Frequent identical API calls | Stage-level cache; TTL 5-300s; cache key = method + path + params |
| Application | ElastiCache Redis | Session state, computed results, rate limiting | TTL based on data staleness tolerance; write-through or cache-aside |
| Database | DAX (DynamoDB) | DynamoDB read-heavy workloads | Microsecond reads; item cache + query cache; TTL 5 min default |
| DNS | Route 53 | DNS resolution caching | TTL 60-300s for dynamic; 86400s for static |

### Compute optimization

- **Graviton**: 20-40% better price-performance for compatible workloads (most Linux-based). Available for EC2, RDS, ElastiCache, Lambda.
- **Spot Instances**: Up to 90% discount for fault-tolerant workloads. Use Spot Fleet or ASG mixed instances. Handle 2-minute interruption notice gracefully.
- **Lambda provisioned concurrency**: Pre-initialize execution environments for latency-sensitive functions. Cost: pay for provisioned capacity even when idle.
- **ECS/EKS right-sizing**: Use Kubernetes VPA recommendations or ECS service auto-scaling. Container CPU/memory requests = P99 of actual usage.

### Database performance optimization

- **Aurora read replicas**: Up to 15 read replicas with < 20ms lag. Reader endpoint for load distribution. Auto-scaling replicas based on CPU.
- **DynamoDB adaptive capacity**: Automatic redistribution of throughput to hot partitions. On-demand mode for unpredictable workloads. DAX for microsecond read latency.
- **RDS Proxy**: Connection pooling for Lambda (prevents connection exhaustion). IAM authentication. Multi-AZ failover transparent to application.
- **Query optimization**: RDS Performance Insights for slow query identification. DynamoDB contributor insights for hot key detection.

### Network performance

- **Global Accelerator**: Anycast IPs route traffic to nearest AWS edge. TCP/UDP optimization. Automatic failover between regions. 60% latency improvement for global users.
- **PrivateLink**: Private connectivity to AWS services without internet. Predictable latency. No data processing charges (vs NAT Gateway).
- **CloudFront**: 450+ edge locations. Origin Shield for cache hit improvement. Lambda@Edge / CloudFront Functions for edge compute.

### Application-level patterns

- **Async processing**: SQS + Lambda for decoupled processing. Step Functions for workflow orchestration. EventBridge for event-driven choreography.
- **Batch processing**: AWS Batch for large-scale compute jobs. Step Functions for complex ETL pipelines. Spot Instances for cost optimization.
- **Connection pooling**: RDS Proxy for serverless workloads. Application-level pools (HikariCP for Java, pgBouncer for PostgreSQL) with pool size = (2 * CPU cores) + effective_spindle_count.

---

## 8. AWS-specific tools and lenses

### AWS Well-Architected Tool

The AWS Well-Architected Tool (WA Tool) in the AWS Management Console provides a structured review process. Create a workload, answer pillar-specific questions, and receive automated risk assessments. Findings classified as High Risk Issues (HRI) and Medium Risk Issues (MRI) using a Likelihood x Impact matrix. Up to 20 lenses can be applied per workload. Improvement plans generated with prioritized recommendations.

### AWS Trusted Advisor

Automated checks across 5 categories: Cost Optimization, Performance, Security, Fault Tolerance, Service Limits. Business/Enterprise Support required for full checks. Key checks: idle resources, security group rules, IAM usage, service limit utilization, RDS idle instances.

### Official Well-Architected Lenses

| Lens | Domain | Key Findings When Applied |
|------|--------|--------------------------|
| **Serverless** | Lambda, API Gateway, Step Functions | Cold start optimization, function granularity, event source mapping, idempotency |
| **SaaS** | Multi-tenant applications | Tenant isolation strategy, noisy neighbor prevention, tenant-aware observability, metering |
| **Machine Learning** | ML lifecycle | Training infrastructure, model versioning, feature stores, inference optimization |
| **Generative AI** | LLM-based applications | RAG architecture, prompt management, model selection, guardrails, cost per inference |
| **Data Analytics** | Data lakes, ETL, streaming | Data quality, catalog governance, query optimization, streaming vs batch |
| **IoT** | Device management, telemetry | Device provisioning, edge compute, telemetry ingestion, OTA updates |
| **HPC** | Parallel computing | Cluster placement groups, EFA networking, FSx for Lustre, job scheduling |
| **Financial Services** | Regulated workloads | Compliance controls, audit trails, data residency, operational resilience |
| **Games** | Game infrastructure | Matchmaking latency, session management, player data, real-time communication |
| **Hybrid Networking** | On-premises ↔ cloud | Direct Connect, Transit Gateway, VPN, DNS resolution, bandwidth planning |
| **Container** | ECS/EKS workloads | Image management, cluster sizing, service mesh, pod security, observability |

### Custom lenses

Organizations can create custom lenses encoding internal best practices, compliance requirements, and governance standards. Custom lenses use the same HRI/MRI risk framework. Shareable across AWS accounts via RAM (Resource Access Manager).

---

## 9. Measurable outcomes

### Operational Excellence outcomes

| Metric | Score 5 | Score 4 | Score 3 | Criterion |
|--------|---------|---------|---------|-----------|
| IaC coverage (% of infrastructure) | 100% | ≥ 90% | ≥ 70% | S1 |
| Rollback time after failed deployment | < 5 min (automated) | < 15 min | < 30 min | S4 |
| Incident detection to RCA documented | < 2 hours | < 4 hours | < 8 hours | S3, Q4 |
| Deployment frequency | Multiple times/day | Weekly | Monthly | S4 |
| Runbook automation rate | ≥ 90% executable | ≥ 70% | ≥ 50% | Q1 |
| Mean time to detect (MTTD) | < 1 min | < 5 min | < 15 min | Q4 |

### Reliability outcomes

| Metric | Score 5 | Score 4 | Score 3 | Criterion |
|--------|---------|---------|---------|-----------|
| MTTR (auto-recovery) | < 60s | < 5 min | < 15 min | Q3 |
| SLO compliance (% hours met) | > 99.95% | > 99.9% | > 99% | Q4 |
| Blast radius (max services affected) | 1 service | 2-3 services | 4+ services | Q2 |
| Failover testing frequency | Monthly | Quarterly | Annual | Q3, S4 |
| Cascading failure scenarios | Zero (circuit breakers everywhere) | Contained to 1 layer | Multiple layers affected | D1 |
| Recovery point objective (achieved) | < 1 min | < 15 min | < 1 hour | DA2 |

### Performance Efficiency outcomes

| Metric | Score 5 | Score 4 | Score 3 | Criterion |
|--------|---------|---------|---------|-----------|
| Bottleneck identification time | < 1 min | < 5 min | < 15 min | Q4 |
| Load scalability (no code changes) | 10x | 5x | 2x | Q3 |
| CPU utilization during peak | 60-80% (right-sized) | 40-60% | < 40% (over-provisioned) | Q3 |
| Performance regression detection | Automated in CI | Pre-release testing | Manual testing only | S1 |
| Cache hit rate (where applicable) | > 90% | > 80% | > 60% | Q3 |
| P99 latency vs baseline | Within 10% | Within 25% | Within 50% | Q3 |

### Cost Optimization outcomes

| Metric | Score 5 | Score 4 | Score 3 | Criterion |
|--------|---------|---------|---------|-----------|
| Cost per transaction trend | Decreasing | Flat | Increasing | Q3 |
| Unused resource detection time | < 1 week | < 2 weeks | < 1 month | D5 |
| Cost allocation accuracy | > 95% tagged | > 85% | > 70% | S1 |
| Reserved/Savings Plan coverage | > 80% of steady-state | > 60% | On-demand only | Q3 |
| Cost anomaly detection latency | < 24 hours | < 3 days | < 1 week | D5 |

### Sustainability outcomes

| Metric | Score 5 | Score 4 | Score 3 | Criterion |
|--------|---------|---------|---------|-----------|
| Avg CPU + memory utilization | > 70% | > 60% | > 50% | Q3 |
| Idle resource cleanup cadence | Automated weekly | Monthly | Quarterly | DA5 |
| Data lifecycle policies enforced | All stores have TTL/archival | Critical stores only | No policies | DA5 |
| Graviton adoption (% eligible workloads) | > 80% | > 50% | > 20% | Q3 |

---

## 10. Criterion mapping and review integration

### AWS risk classification → our scoring

AWS Well-Architected Tool classifies findings as High Risk Issues (HRI) and Medium Risk Issues (MRI) using a Likelihood x Impact matrix.

| AWS Risk Level | Our Score Range | Interpretation |
|----------------|----------------|----------------|
| **High Risk Issue (HRI)** | Score 1-2 | Fundamental gap with significant negative business impact; blocks production readiness |
| **Medium Risk Issue (MRI)** | Score 3 | Gap exists, core intent partially addressed but notable shortfall |
| **No Risk** | Score 4-5 | Pillar addressed effectively; controls implemented and functioning |

**Bidirectional mapping**: When the review finds a score of 1-2 on a cloud-relevant criterion, note it as an "AWS HRI equivalent" in the issue rationale. When a score of 3 is found, note it as an "AWS MRI equivalent." This helps teams familiar with AWS Well-Architected understand severity in their terms.

### Verdict alignment

| Our Verdict | AWS Equivalent |
|-------------|---------------|
| Proceed / Meets Standards (≥80%) | Well-Architected — no HRIs, few MRIs |
| Proceed with Conditions / Needs Improvement (60-79%) | Partially Well-Architected — MRIs present, no critical HRIs |
| Rework Required / Critical Gaps (<60%) | Not Well-Architected — HRIs present across multiple pillars |

### Pillar → criterion mapping

#### Operational Excellence → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **S1** Physical Enforcement | Is infrastructure defined as code and version-controlled? | IaC manages 100% of infrastructure; CI/CD rejects non-compliant changes automatically; architecture fitness functions run on every commit | No IaC; manual deployments; no automated compliance checks |
| **S3** ADRs | Are operational decisions captured with rationale? | All significant operational and architecture decisions documented with context, alternatives, consequences; ADRs discoverable and cross-referenced | No documentation; tribal knowledge; teams re-debate settled decisions |
| **S4** Evolutionary Readiness | Can changes be deployed safely with automated rollback? | Safe deployment codified (blue-green, canary); chaos engineering automated; rollback < 5 minutes | Manual deployments with manual rollback; no failure testing; full system redeploy required |
| **Q4** Observability | Can a production incident be traced from symptom to root cause? | Distributed tracing with correlation IDs; structured logging at all boundaries; RCA < 15 minutes; alerting on architectural degradation | No structured logging; no tracing; failures discovered by users |
| **Q1** Testability | Can operational scenarios be tested in non-production? | Operational procedures are executable code that passes automated tests; runbook validation automated | Manual checklists never tested |

#### Reliability → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **Q2** Change Isolation | What is the blast radius of a single component failure? | Blast radius ≤ 1 service; auto-isolation; cross-AZ redundancy; circuit breakers at all external boundaries | Every failure cascades system-wide; no isolation; single AZ |
| **Q3** Scalability | How does the system recover automatically? Are there SPOFs? | Auto-recovery RTO < 60s; no SPOFs; horizontal scaling without code changes; resilience patterns at all boundaries | Everything synchronous, monolithic; no auto-recovery; SPOFs everywhere |
| **Q4** Observability | How are KPIs like RTO/RPO tracked? | Real-time SLO tracking; automated alerting at 80% error budget burn; MTTR < 5 minutes | No SLOs; failures discovered via user complaints |
| **D1** Layer Separation | Can failures propagate across service boundaries? | No cascading failures; all external calls have timeouts/retries/fallbacks; dependency graph enforced | Failures propagate freely; no timeouts; no circuit breakers |
| **D4** DAG Enforcement | Is the service dependency graph acyclic? | Dependency graph verified as DAG in CI; circular calls detected and rejected | Circular dependencies; mutual synchronous calls; unpredictable deployment order |
| **DA2** Consistency | What consistency guarantees does each data domain need? | CAP/PACELC documented per domain; partition behavior designed; compensation strategies tested | No awareness of consistency trade-offs; ACID assumed everywhere |
| **DA4** Distributed Coordination | How are cross-service operations coordinated? | Sagas with tested compensation steps; idempotency enforced; no 2PC | Distributed transactions (2PC) or no coordination at all |

#### Performance Efficiency → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **Q3** Scalability | Are resources right-sized? Can the system handle 10x load? | Performance budget defined; 10x growth without code changes; cache hit > 85%; load testing validates peak | No performance budget; cannot scale; no caching |
| **Q4** Observability | Can performance bottlenecks be identified? | Continuous performance monitoring; automated alerts on > 10% degradation; bottleneck identifiable in < 1 min | No performance monitoring; bottlenecks discovered in production |
| **DA1** Data Model | Is the database type chosen based on access patterns? | Data model justified against access patterns; query optimization headroom < 20%; ADR for selection | Database chosen by habit; severe impedance mismatch |
| **DA5** Data Scalability | Is connection pooling sized for concurrency? | Pools sized with concurrency model; sharding strategy documented; replication lag monitored | No pooling; no replicas; no growth awareness |
| **S1** Physical Enforcement | Are performance regressions caught automatically? | Automated performance testing in CI; build fails on > 5% regression | No performance testing; regressions discovered in production |

#### Cost Optimization → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **Q3** Scalability | Are resources proportional to business value? | Auto-scaling eliminates idle capacity; cost per transaction decreasing; serverless for bursty workloads | Static over-provisioning; linear cost growth |
| **DA5** Data Scalability | Could data costs be reduced by a different model? | Storage optimized with lifecycle policies; replication balanced; retention enforced | All data in expensive tiers indefinitely |
| **S4** Evolutionary Readiness | Can cost optimizations be adopted without rewrites? | Stateless/serverless separation; cost improvements in a sprint; new instance types via config | Architecture prevents cheaper technologies; months of rework |
| **D5** External Dependencies | Are unused cloud services eliminated? Is lock-in confined? | No orphaned resources; lock-in in thin abstraction; managed services behind interfaces | Unused resources accumulating; deep lock-in everywhere |

#### Sustainability → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **Q3** Scalability | Is resource utilization high? | CPU > 70%; memory > 60%; auto-scaling matches demand precisely | Utilization < 20%; massive over-provisioning |
| **DA5** Data Scalability | Are idle data resources decommissioned? | Replication optimized; automated cleanup; storage classes matched to access frequency | All data replicated maximally; no cleanup; hot storage for cold data |
| **S4** Evolutionary Readiness | Can more efficient technologies be adopted? | Abstraction boundaries enable swapping (e.g., x86 → Graviton); evaluation cadence established | Locked to specific hardware; no abstraction |

### AWS-specific review questions by lens

#### Lens 1: Dependency Architecture

| Criterion | Question | Pillar |
|-----------|----------|--------|
| D1 | Can a failure in Service X propagate to Service Y? What is the circuit breaker and timeout strategy at each boundary? | Reliability |
| D1 | Are all external calls wrapped in retry/timeout/fallback? What happens when a dependency is unavailable for 5 minutes? | Reliability |
| D3 | Can business logic run without the AWS SDK? Is the cloud provider abstracted? | Cost |
| D4 | Is the service dependency graph verified as acyclic? How are circular calls prevented? | Reliability |
| D5 | Which cloud services could be replaced without changing business logic? What is the switching cost? | Cost |

#### Lens 2: Component Design

| Criterion | Question | Pillar |
|-----------|----------|--------|
| C1 | If a payment gateway fails, which components propagate the error? Is failure contained to one component? | Reliability |
| C3 | Can a new cloud integration be added by adding a new module, or must existing use cases be modified? | Ops Excellence |
| C4 | Is each feature module's public API independent of the cloud provider? Could the module work on a different cloud? | Cost |

#### Lens 3: Data Flow & Boundaries

| Criterion | Question | Pillar |
|-----------|----------|--------|
| B1 | Trace a write from API Gateway to persistent storage. Where could it fail silently? Where is data lost without notification? | Reliability |
| B2 | Are cloud DTOs (DynamoDB AttributeValue, S3 ObjectMetadata) contained within adapter layers, or do they leak into business logic? | Ops Excellence |
| B3 | When a downstream AWS service times out, does the architecture translate to a domain exception, or do raw SDK errors propagate? | Ops Excellence |
| B4 | Can Feature A be deployed independently of Feature B? Do they share infrastructure that creates implicit coupling? | Reliability |

#### Lens 4: Quality Attributes

| Criterion | Question | Pillar |
|-----------|----------|--------|
| Q1 | Can business logic be tested without AWS services (LocalStack, mocks, fakes)? How long does the test suite take? | Ops Excellence |
| Q2 | What is the blast radius of a single component failure? If one AZ goes down, how many features are affected? | Reliability |
| Q3 | At what load does the system hit a bottleneck requiring architectural changes (not just scaling)? | Performance |
| Q3 | If traffic increases 10x, does cost increase 10x (linear) or improve (sub-linear)? | Cost |
| Q4 | Can a production incident's root cause be identified within 5 minutes using logs and traces? | Reliability |

#### Lens 5: Structural Integrity

| Criterion | Question | Pillar |
|-----------|----------|--------|
| S1 | Does the CI/CD pipeline reject commits that violate layer separation or import cloud SDKs in the domain layer? | Ops Excellence |
| S1 | Are infrastructure changes reviewed with the same rigor as application code? | Ops Excellence |
| S3 | When a high-severity incident occurred, was the workaround decision captured as an ADR? | Reliability |
| S4 | If AWS releases a service 20% cheaper or faster, can it be adopted without architectural refactoring? | Cost |

#### Lens 6: Database Architecture

| Criterion | Question | Pillar |
|-----------|----------|--------|
| DA1 | Why this database service (RDS, DynamoDB, ElastiCache, Redshift, Neptune)? What access patterns drove the choice? Is there an ADR? | Performance |
| DA2 | If a region becomes unavailable, does the data model support failover? What are RPO and RTO? | Reliability |
| DA3 | Can Feature A write to Feature B's DynamoDB table or RDS schema? How is cross-feature data access controlled? | Ops Excellence |
| DA4 | When Feature A updates Customer data and Feature B reads it, what happens during a network partition? | Reliability |
| DA5 | At 10x current data volume, does the partition key strategy distribute load evenly? What is rebalancing cost? | Performance |
| DA5 | Are read replicas used with awareness of replication lag? What is acceptable staleness per read path? | Performance |

### Review integration

**When to load**: Load this file when the system is deployed to AWS, when cloud infrastructure decisions are part of the review scope, or when the system uses AWS managed services (databases, queues, compute) whose architectural constraints affect evaluation.

**How to integrate with the 6-lens workflow**:
1. During Steps 3-8 (per-lens evaluation): Use the "AWS-specific review questions by lens" section to supplement standard evaluation criteria. Note the AWS pillar reference in the criterion's rationale.
2. During Step 9 (synthesis): Check findings against "Measurable outcomes" tables to calibrate scores. Flag any score of 1-2 on a cloud-relevant criterion as an "AWS HRI equivalent."
3. During Step 11 (output): Note applicable AWS Well-Architected Lenses in the review header. Reference AWS pillars in issue rationale (e.g., "[Q3 + AWS Reliability] System has no auto-recovery...").

**How to handle pillar conflicts**: AWS pillars often have competing recommendations — reliability wants redundancy (more resources), cost wants efficiency (fewer resources), sustainability wants minimal footprint. When conflicts surface:
1. Document the trade-off as an S3 (ADR) finding
2. Score based on intentionality — a system that deliberately trades cost for reliability (and documents why) scores higher than one that achieves neither
3. Note the conflict in the review: "[Q3 + AWS Reliability vs Cost] Multi-region deployment provides HA but doubles cost. No ADR documenting this trade-off."
