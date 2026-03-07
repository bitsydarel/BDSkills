# Well-Architected Frameworks

AWS, Azure, and Google Cloud Well-Architected Frameworks mapped to this skill's 6 evaluation lenses. Load this file when reviewing cloud-deployed systems to apply industry-validated architecture review questions alongside the standard evaluation criteria.

Note: Security pillar details are handled by the bd-security-review skill. This file focuses on architecture-relevant aspects. Framework version: AWS Well-Architected November 2024 refresh.

## AWS Well-Architected Framework — 6 pillars

### Operational Excellence
Design, run, and monitor systems to deliver business value and continually improve.

**Design principles**: (1) Perform operations as code — IaC with version control, testing, automation. (2) Make frequent, small, reversible changes. (3) Refine operations procedures frequently. (4) Anticipate failure — build systems that detect and respond automatically. (5) Learn from all operational events and failures.

**Best practice areas**: Organization (structures and culture), Prepare (runbooks, playbooks, documentation), Operate (monitoring, event response, change management), Evolve (retrospectives, feedback mechanisms, tooling improvements).

### Security
Protect information, systems, and assets while delivering business value.

**Covered by**: bd-security-review skill. Architecture-relevant aspect: security controls integrated into architecture (not bolted on), identity foundation, defense in depth, data protection at rest and in transit.

### Reliability
Recover from failures and meet demand.

**Design principles**: (1) Automatically recover from failure. (2) Test recovery procedures. (3) Scale horizontally to increase aggregate availability. (4) Stop guessing capacity. (5) Manage change through automation.

**Best practice areas**: Foundations (service limits, architecture avoiding SPOFs, multi-AZ/region), Change Management (IaC, CI/CD, canary/blue-green, rollback), Failure Management (automated backups, cross-region replication, fault injection testing), Monitoring & Observability (availability tracking, MTTR, error rates, distributed tracing).

### Performance Efficiency
Use computing resources efficiently and maintain efficiency as demand changes.

**Design principles**: (1) Democratize advanced technologies — consume services rather than building. (2) Go global in minutes. (3) Use serverless architectures. (4) Experiment more often. (5) Consider mechanical sympathy — choose technologies aligned with workload characteristics.

**Best practice areas**: Selection (right resource types for compute, storage, database, network), Review (monitor metrics, identify optimization opportunities, set baselines), Optimization (caching, compression, query tuning, code profiling), Trade-offs (performance vs cost, consistency vs latency).

### Cost Optimization
Avoid unnecessary costs.

**Design principles**: (1) Implement cloud financial management. (2) Adopt a consumption model — pay only for what you use. (3) Measure and monitor efficiency. (4) Analyze and attribute expenditure. (5) Optimize over time.

**Best practice areas**: Expenditure Awareness (tagging, cost allocation, billing alerts, anomaly detection), Cost-Effective Resources (right-sizing, Reserved Instances, Spot Instances, managed services), Matching Supply with Demand (auto-scaling, scheduling non-prod environments), Optimizing Over Time (review new services, benchmark against industry).

### Sustainability
Minimize environmental impact of cloud workloads.

**Design principles**: (1) Understand your impact. (2) Establish sustainability goals. (3) Maximize utilization. (4) Anticipate and adopt efficient hardware/software. (5) Use managed services. (6) Reduce downstream impact.

**Best practice areas**: Energy Management (right-sizing, auto-scaling, Graviton processors), Workload Optimization (eliminate unused resources, Spot instances, data lifecycle policies), Data & Storage Optimization (storage classes, compression, efficient formats), Software & Architecture (caching, async patterns, minimize cross-region transfer).

---

## AWS risk classification → our scoring

AWS Well-Architected Tool classifies findings as High Risk Issues (HRI) and Medium Risk Issues (MRI) using a Likelihood × Impact matrix. Map these to our 1-5 scoring scale:

| AWS Risk Level | Our Score Range | Interpretation |
|----------------|----------------|----------------|
| **High Risk Issue (HRI)** | Score 1-2 on mapped criterion | Fundamental gap with significant negative business impact; blocks production readiness |
| **Medium Risk Issue (MRI)** | Score 3 on mapped criterion | Gap exists, core intent partially addressed but notable shortfall |
| **No Risk** | Score 4-5 on mapped criterion | Pillar addressed effectively; controls implemented and functioning |

**Bidirectional mapping**: When our review finds a score of 1-2 on a cloud-relevant criterion, note it as an "AWS HRI equivalent" in the issue rationale. When a score of 3 is found, note it as an "AWS MRI equivalent." This helps teams familiar with AWS Well-Architected understand severity in their terms.

**Verdict alignment**:

| Our Verdict | AWS Equivalent |
|-------------|---------------|
| Proceed / Meets Standards (≥80%) | Well-Architected — no HRIs, few MRIs |
| Proceed with Conditions / Needs Improvement (60-79%) | Partially Well-Architected — MRIs present, no critical HRIs |
| Rework Required / Critical Gaps (<60%) | Not Well-Architected — HRIs present across multiple pillars |

---

## Pillar → criterion mapping

Each AWS pillar maps to specific evaluation criteria across all 6 lenses. Use these tables during scoring to identify AWS-relevant findings. The "Score 5" column defines what "excellent" looks like through the AWS lens; "Score 1" defines the anti-pattern.

### Operational Excellence → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **S1** Physical Enforcement | Is infrastructure defined as code and version-controlled? | IaC manages 100% of infrastructure; CI/CD rejects non-compliant changes automatically; architecture fitness functions run on every commit | No IaC; manual deployments; no automated compliance checks |
| **S3** ADRs | How do you know you are ready to support a workload? Are operational decisions captured with rationale? | All significant operational and architecture decisions documented with context, alternatives, consequences; ADRs discoverable and cross-referenced; decisions updated when constraints change | No documentation; tribal knowledge; teams re-debate settled decisions |
| **S4** Evolutionary Readiness | Can you deploy changes safely with automated rollback? How do you practice failure? | Safe deployment codified (blue-green, canary); chaos engineering tests automated; incident learnings systematically fed into next iteration; rollback < 5 minutes | Manual deployments with manual rollback coordination; no failure testing; changes require full system redeploy |
| **Q4** Observability | Can you trace a production incident from symptom to root cause? Are operational events correlated across services? | Distributed tracing with correlation IDs; structured logging at all boundaries; incident timeline from symptom to RCA < 15 minutes; alerting on architectural degradation | No structured logging; no tracing; teams discover failures when users complain; debugging requires stepping through code |
| **Q1** Testability | Can operational scenarios (failover, scaling, updates) be tested in non-production? | Operational procedures are executable code that passes automated tests; runbook validation automated | Operational procedures are manual checklists that have never been tested |
| **DA5** Data Scalability | Can you grow data volume 10x without operational rewrites? Are database operations automated? | Data growth handled through IaC-defined sharding/replication; zero manual DB administration; scaling automated | Single database instance; manual scaling; no awareness of data volume growth |

### Reliability → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **Q2** Change Isolation | What is the blast radius of a single component failure? Are failure domains isolated? | Blast radius ≤ 1 service; auto-isolation of failed instances; cross-AZ redundancy for all stateful components; circuit breakers at all external boundaries | Every failure cascades system-wide; no isolation between components; single AZ deployment |
| **Q3** Scalability | How does the system recover from component failures automatically? Are there single points of failure? Is capacity provisioned based on demand? | Auto-recovery with RTO < 60 seconds; no SPOFs; horizontal scaling without code changes; resilience patterns (circuit breakers, timeouts, fallbacks) at all external boundaries | Everything synchronous, stateful, monolithic; no auto-recovery; SPOFs at every layer; manual capacity provisioning |
| **Q4** Observability | How do you track KPIs like RTO/RPO? Can you detect failures before customers do? Are SLOs defined? | Real-time SLO tracking; automated alerting at 80% error budget burn; MTTR < 5 minutes; SLOs defined for all critical paths | No SLOs; failures discovered via customer complaints; no health monitoring beyond basic uptime |
| **D1** Layer Separation | Can failures propagate across service boundaries? Are circuit breakers and timeouts enforced at all boundaries? | No cascading failures; all external calls have timeouts/retries/fallbacks; dependency graph enforced with no bypasses | Failures propagate freely; no timeouts; synchronous call chains with no circuit breakers |
| **D4** DAG Enforcement | Is the service dependency graph acyclic? How do you prevent circular service calls? | Dependency graph verified as DAG in CI; circular calls detected and rejected; deployment order derived from dependency graph | Circular dependencies between services; mutual synchronous calls; deployment order unpredictable |
| **DA2** Consistency | What consistency guarantees does each data domain need? How does the system behave during network partitions? | CAP/PACELC positioning documented per data domain; partition behavior is a design decision; compensation strategies for eventual consistency tested; consistency SLOs monitored | No awareness of consistency trade-offs; ACID assumed everywhere including distributed scenarios; untested partition behavior |
| **DA4** Distributed Coordination | How are cross-service data operations coordinated? Are compensation steps defined for failures? | All cross-service operations use saga/CQRS/event sourcing; no 2PC; compensation steps for every failure scenario tested; idempotency enforced | Distributed transactions (2PC/XA) used; or no coordination at all — services commit independently with no consistency guarantees |

### Performance Efficiency → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **Q3** Scalability | Are compute resources right-sized? Can you handle 10x load with infrastructure changes only? Is caching used effectively? | Performance budget defined for critical paths; architecture supports 10x growth without code changes; cache hit rates > 85%; load testing validates peak behavior | No performance budget; cannot scale; no caching; performance problems require rewrite |
| **Q4** Observability | Can you identify performance bottlenecks? Do you have performance baselines and alerting on degradation? | Continuous performance monitoring; automated alerts on degradation (> 10% vs baseline); bottleneck identifiable within 1 minute | No performance monitoring; bottlenecks discovered in production incidents |
| **DA1** Data Model | Is the database type chosen based on access patterns? Could query patterns be optimized without data model redesign? | Data model choice justified against access patterns; query optimization headroom < 20%; ADR exists for database selection | Database chosen by habit; severe impedance mismatch between queries and data model; complex workarounds |
| **DA5** Data Scalability | Is connection pooling sized for expected concurrency? Is sharding strategy defined for growth? | Connection pools sized with concurrency model; sharding strategy includes partition key rationale and hot-partition mitigation; replication lag monitored | No connection pooling; no read replicas; no awareness of data volume growth |
| **S1** Physical Enforcement | Are performance regressions caught automatically? Do fitness functions include performance gates? | Automated performance testing in CI; build fails on regression > 5% over baseline | No performance testing; regressions discovered in production |

### Cost Optimization → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **Q3** Scalability | Are resources consumed proportional to business value? Can idle capacity be deprovisioned automatically? | Auto-scaling policies tuned to eliminate idle capacity; cost per transaction decreasing as volume increases; serverless used for bursty workloads | Static over-provisioning; cost grows linearly with zero efficiency gain; no auto-scaling |
| **DA5** Data Scalability | Could data tier cost be reduced by a different model? Is storage consumption tracked and optimized? | Storage cost optimized with lifecycle policies; replication factor balanced between durability and cost; data retention policies enforced automatically | All data stored in expensive tiers indefinitely; no lifecycle policies; redundant replication |
| **S4** Evolutionary Readiness | Can you adopt cost-optimization improvements without architectural rewrites? | Architecture separates stateless (serverless-ready) from stateful; cost improvements adoptable within a sprint; new instance types deployable via config change | Architecture prevents adopting cheaper technologies; every optimization requires months of rework |
| **D5** External Dependencies | Are you paying for cloud services you don't use? Is vendor lock-in confined? | No orphaned resources; vendor lock-in isolated to thin abstraction layer; managed services wrapped behind interfaces | Unused resources accumulating; deep vendor lock-in across all layers; switching cost prohibitive |

### Sustainability → criteria

| Criterion | AWS Review Question | Score 5 (Excellent) | Score 1 (Missing) |
|-----------|-------------------|---------------------|-------------------|
| **Q3** Scalability | Is resource utilization high? Could the system run on fewer servers? | CPU utilization > 70% during normal operation; memory utilization > 60%; auto-scaling matches demand precisely | Utilization < 20%; massive over-provisioning; idle resources running 24/7 |
| **DA5** Data Scalability | Are idle data resources decommissioned? Is data replication minimal for required durability? | Replication factor optimized; automated cleanup of expired data; storage classes matched to access frequency | All data replicated maximally; no cleanup; hot storage for cold data |
| **S4** Evolutionary Readiness | Can you adopt more efficient technologies without architectural rewrites? | Abstraction boundaries enable swapping inefficient components for efficient ones (e.g., x86 → Graviton); technology evaluation cadence established | Locked to specific hardware/runtime; no abstraction; technology changes require rewrite |

---

## AWS-specific review questions by lens

Use these questions during Steps 3-8 of the review workflow when the system is cloud-deployed. Each question references the AWS pillar it stems from.

### Lens 1: Dependency Architecture

| Criterion | Question | AWS Pillar |
|-----------|----------|-----------|
| D1 | Can a failure in Service X propagate to Service Y? What is the circuit breaker and timeout strategy at each boundary? | Reliability |
| D1 | Are all external service calls wrapped in retry/timeout/fallback logic? What happens when a dependency is unavailable for 5 minutes? | Reliability |
| D3 | Can the business logic run without the cloud SDK (AWS SDK, client libraries)? Is the cloud provider abstracted? | Cost (vendor lock-in) |
| D4 | Is the service dependency graph verified as acyclic? How do you prevent circular service-to-service calls? | Reliability |
| D5 | Which cloud services could be replaced by alternatives without changing business logic? What is the switching cost? | Cost |

### Lens 2: Component Design

| Criterion | Question | AWS Pillar |
|-----------|----------|-----------|
| C1 | If an external API (payment gateway, notification service) fails, which components in the codebase propagate that error? Is the failure contained to one component? | Reliability |
| C3 | Can you add a new cloud integration (new database, new queue) by adding a new module, or must you modify existing use cases? | Operational Excellence |
| C4 | Is the public API of each feature module independent of the cloud provider? Could the module work on a different cloud? | Cost (portability) |

### Lens 3: Data Flow & Boundaries

| Criterion | Question | AWS Pillar |
|-----------|----------|-----------|
| B1 | Trace a customer write from API Gateway to persistent storage. Where could it fail silently? Where is data lost without notification? | Reliability |
| B2 | Are cloud-specific DTOs (DynamoDB AttributeValue, S3 ObjectMetadata) contained within adapter layers, or do they leak into business logic? | Operational Excellence |
| B3 | When a downstream AWS service times out (SQS, DynamoDB, S3), does the architecture translate that to a domain exception, or do raw AWS SDK errors propagate to the caller? | Operational Excellence |
| B4 | Can Feature A be deployed independently of Feature B? Do they share any infrastructure (database, queue, S3 bucket) that creates implicit coupling? | Reliability |

### Lens 4: Quality Attributes

| Criterion | Question | AWS Pillar |
|-----------|----------|-----------|
| Q1 | Can the business logic be tested without AWS services running (LocalStack, mocks, or fakes)? How long does the test suite take? | Operational Excellence |
| Q2 | What is the blast radius of a single component failure? If one AZ goes down, how many features are affected? | Reliability |
| Q3 | At what load does the system hit a bottleneck that requires architectural changes (not just scaling instances)? | Performance |
| Q3 | If traffic increases 10x, does cost increase 10x (linear), or does utilization improve (sub-linear)? What is the cost efficiency curve? | Cost |
| Q4 | Can you identify a production incident's root cause (e.g., "DynamoDB throttling in feature X") within 5 minutes using logs and traces alone? | Reliability |

### Lens 5: Structural Integrity

| Criterion | Question | AWS Pillar |
|-----------|----------|-----------|
| S1 | Does the CI/CD pipeline reject a commit that violates layer separation or introduces a direct cloud SDK import in the domain layer? | Operational Excellence |
| S1 | Are infrastructure changes (CloudFormation, Terraform) reviewed with the same rigor as application code changes? | Operational Excellence |
| S3 | When a high-severity production incident occurred, was the decision to implement a workaround captured as an ADR with rationale? | Reliability |
| S4 | If AWS releases a new service or instance type that is 20% cheaper or faster, can you adopt it without architectural refactoring? | Cost |

### Lens 6: Database Architecture

| Criterion | Question | AWS Pillar |
|-----------|----------|-----------|
| DA1 | Why this database service (RDS, DynamoDB, ElastiCache, Redshift, Neptune)? What access patterns drove the choice? Is there an ADR? | Performance |
| DA2 | If a region becomes unavailable, does your data model support failover? What is your RPO and RTO for data? | Reliability |
| DA3 | Can Feature A write to Feature B's DynamoDB table or RDS schema? How is cross-feature data access controlled? | Operational Excellence |
| DA4 | When Feature A updates Customer data and Feature B reads it, what happens during a network partition? Is there a saga or event-based coordination? | Reliability |
| DA5 | At 10x current data volume, does your partition key strategy still distribute load evenly? What is the rebalancing cost? | Performance |
| DA5 | Are read replicas used with awareness of replication lag? What is the acceptable staleness for each read path? | Performance |

---

## Measurable outcomes by pillar

Use these metrics to calibrate scores when measurable data is available. The thresholds define what "excellent" (Score 5), "good" (Score 4), and "adequate" (Score 3) look like for cloud-deployed systems.

### Operational Excellence outcomes

| Metric | Score 5 | Score 4 | Score 3 | Mapped Criterion |
|--------|---------|---------|---------|-----------------|
| IaC coverage (% of infrastructure) | 100% | ≥ 90% | ≥ 70% | S1 |
| Rollback time after failed deployment | < 5 min (automated) | < 15 min | < 30 min | S4 |
| Incident detection to RCA documented | < 2 hours | < 4 hours | < 8 hours | S3, Q4 |
| Deployment frequency | Multiple times/day | Weekly | Monthly | S4 |
| Runbook automation rate | ≥ 90% executable | ≥ 70% | ≥ 50% | Q1 |

### Reliability outcomes

| Metric | Score 5 | Score 4 | Score 3 | Mapped Criterion |
|--------|---------|---------|---------|-----------------|
| MTTR (auto-recovery) | < 60s | < 5 min | < 15 min | Q3 |
| SLO compliance (% hours met) | > 99.95% | > 99.9% | > 99% | Q4 |
| Blast radius (max services affected) | 1 service | 2-3 services | 4+ services | Q2 |
| Failover testing frequency | Monthly | Quarterly | Annual | Q3, S4 |
| Cascading failure scenarios | Zero (circuit breakers everywhere) | Contained to 1 layer | Multiple layers affected | D1 |

### Performance Efficiency outcomes

| Metric | Score 5 | Score 4 | Score 3 | Mapped Criterion |
|--------|---------|---------|---------|-----------------|
| Bottleneck identification time | < 1 min | < 5 min | < 15 min | Q4 |
| Load scalability (no code changes) | 10x | 5x | 2x | Q3 |
| CPU utilization during peak | 60-80% (right-sized) | 40-60% | < 40% (over-provisioned) | Q3 |
| Performance regression detection | Automated in CI | Pre-release testing | Manual testing only | S1 |
| Cache hit rate (where applicable) | > 90% | > 80% | > 60% | Q3 |

### Cost Optimization outcomes

| Metric | Score 5 | Score 4 | Score 3 | Mapped Criterion |
|--------|---------|---------|---------|-----------------|
| Cost per transaction trend | Decreasing | Flat | Increasing | Q3 |
| Unused resource detection time | < 1 week | < 2 weeks | < 1 month | D5 |
| Cost allocation accuracy | > 95% tagged | > 85% | > 70% | S1 |
| Reserved/Spot instance utilization | > 80% of steady-state | > 60% | On-demand only | Q3 |

### Sustainability outcomes

| Metric | Score 5 | Score 4 | Score 3 | Mapped Criterion |
|--------|---------|---------|---------|-----------------|
| Avg CPU + memory utilization | > 70% | > 60% | > 50% | Q3 |
| Idle resource cleanup cadence | Automated weekly | Monthly | Quarterly | DA5 |
| Data lifecycle policies enforced | All stores have TTL/archival | Critical stores only | No policies | DA5 |

---

## AWS Well-Architected Lenses

Lenses are domain-specific extensions to the base 6-pillar framework. Each lens adds its own questions, best practices, and improvement plans. Up to 20 lenses can be applied per workload.

### AWS-maintained lenses

| Lens | Domain | When to note in review |
|------|--------|----------------------|
| **Serverless** | Lambda, API Gateway, Step Functions architectures | System uses serverless compute for core workloads |
| **SaaS** | Multi-tenant SaaS applications | System serves multiple tenants with shared infrastructure |
| **Machine Learning** | ML lifecycle (data prep → training → inference) | System includes ML model training or inference pipelines |
| **Generative AI** | LLM-based applications, RAG, agents | System integrates foundation models or generative AI |
| **Data Analytics** | Data lakes, ETL, warehousing, streaming | System processes analytical workloads (batch or real-time) |
| **IoT** | Device management, edge computing, telemetry | System manages connected devices or ingests sensor data |
| **HPC** | High-performance computing, simulation | System runs compute-intensive parallel workloads |
| **Financial Services** | Regulatory compliance, trading, banking | System operates under financial regulation |
| **Games** | Game servers, matchmaking, player scale | System supports real-time multiplayer or large-scale player bases |
| **Hybrid Networking** | On-premises ↔ cloud connectivity | System spans on-premises and cloud environments |

### Custom lenses

Organizations can create custom lenses encoding internal best practices, compliance requirements, and governance standards. Note in the review output if a custom lens is relevant but not available for evaluation.

### Integration with review

When a Well-Architected Lens is relevant to the system being reviewed, note it in the review header (e.g., "AWS Well-Architected Lenses applicable: Serverless, SaaS"). The base 6-pillar questions in this file apply regardless; lens-specific questions extend them for the domain.

---

## Azure Well-Architected Framework — 5 pillars

Azure's pillars directly correspond to AWS. Map to the same evaluation criteria.

| Azure Pillar | AWS Equivalent | Mapped Criteria |
|-------------|----------------|----------------|
| **Reliability** | Reliability | Q2, Q3, Q4, D1, DA2 |
| **Security** | Security | Handled by bd-security-review |
| **Cost Optimization** | Cost Optimization | Q3, DA5, S4, D5 |
| **Operational Excellence** | Operational Excellence | S1, S3, S4, Q4, Q1 |
| **Performance Efficiency** | Performance Efficiency | Q3, Q4, DA1, DA5, S1 |

**Azure-specific additions**: Health modeling (Reliability — maps to Q4), Safe deployment practices (OpsExc — maps to S4), Azure Advisor integration (Cost — maps to D5 unused resource detection).

## Google Cloud Well-Architected Framework

Google Cloud organizes around 5 focus areas that map to the same criteria.

| Google Cloud Area | AWS Equivalent | Mapped Criteria |
|------------------|----------------|----------------|
| **System Design** | Reliability + Performance | Q2, Q3, D1, DA1 |
| **Operational Excellence** | Operational Excellence | S1, S3, S4, Q4 |
| **Reliability** | Reliability | Q2, Q3, Q4, DA2 |
| **Performance Optimization** | Performance Efficiency | Q3, Q4, DA1, DA5 |
| **Cost Optimization** | Cost Optimization | Q3, DA5, S4, D5 |

**Google-specific additions**: SLOs and error budgets (Reliability — maps to Q4 with measurable target: error budget burn rate < 80%), Infrastructure as code via Deployment Manager or Terraform (OpsExc — maps to S1).

---

## Review integration

### When to load this file

Load `frameworks-well-architected.md` when the system is deployed to AWS, Azure, or GCP, or when cloud infrastructure decisions are part of the review scope. Also load when the system uses managed cloud services (databases, queues, compute) whose architectural constraints affect the evaluation.

### How to integrate with the 6-lens workflow

1. **During Steps 3-8** (per-lens evaluation): Use the "AWS-specific review questions by lens" section above to supplement the standard evaluation criteria with cloud-context questions. Note the AWS pillar reference in the criterion's rationale when an AWS-specific finding is identified.

2. **During Step 9** (synthesis): Check findings against the "Measurable outcomes" tables above to calibrate scores when measurable data is available. Flag any score of 1-2 on a cloud-relevant criterion as an "AWS HRI equivalent" in the issues section.

3. **During Step 11** (output): Note applicable AWS Well-Architected Lenses in the review header. Reference AWS pillars in issue rationale where relevant (e.g., "[Q3 + AWS Reliability] System has no auto-recovery...").

### How to handle pillar conflicts

AWS pillars often have competing recommendations — reliability wants redundancy (more resources), cost optimization wants efficiency (fewer resources), sustainability wants minimal footprint. When these conflicts surface:

1. **Document the trade-off** as an S3 (ADR) finding — the team should have an explicit decision with rationale
2. **Score based on intentionality** — a system that deliberately trades cost for reliability (and documents why) scores higher than one that achieves neither
3. **Note the conflict** in the review as a finding with both pillar references: "[Q3 + AWS Reliability vs Cost] Multi-region deployment provides HA but doubles infrastructure cost. No ADR documenting this trade-off."
