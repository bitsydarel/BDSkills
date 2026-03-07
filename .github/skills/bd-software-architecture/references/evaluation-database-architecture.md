# Evaluation: Database Architecture (Lens 6)

Scoring rubric for criteria DA1-DA5. Each criterion includes proposal questions (forward-looking), implementation-compliance questions (did the build match the plan?), and implementation-results questions (what does the running system show?). Integrates CAP theorem, PACELC, ACID/BASE trade-offs, database-per-service patterns, CQRS, saga pattern, and data scalability strategy. Scoring follows the 1-5 scale defined in [evaluation-scoring.md](evaluation-scoring.md).

## DA1: Data Model Selection & Justification

**What it evaluates**: Whether the system selects the database type that best fits the access patterns, query shape, and consistency requirements — and explicitly justifies that selection against alternatives. Covers relational, document, key-value, column-family, graph, and NewSQL models. When multiple data models coexist (polyglot persistence), each must be independently justified and their interaction boundaries defined.

*Integrates ATAM quality attribute scenarios for performance efficiency and maintainability.*

### Proposal questions
- Does the design specify which database type(s) are used and why?
- Are access patterns (query shape, read/write ratio, join complexity) documented to justify the choice?
- If multiple databases are used (polyglot persistence), is each justified independently?
- Are the query patterns unsuitable for the chosen database identified and addressed?

### Implementation-compliance questions
- Does the implemented data model match the proposed design?
- Are there ad hoc query patterns that contradict the chosen database type (e.g., complex joins in a document store)?
- If polyglot persistence is used, are the integration boundaries between databases clearly defined?
- Are schema design decisions (normalization level, index strategy, partition key selection) intentional and documented?

### Implementation-results questions
- Do query performance profiles match expectations for the chosen data model?
- Has the team encountered access patterns that are awkward for the chosen model?
- Would a different data model significantly simplify the access layer?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Database type explicitly justified against access patterns and alternatives. Polyglot persistence (if used) has each store independently justified with defined integration boundaries. Schema design decisions documented. No impedance mismatch between query patterns and data model. ADR exists for the choice |
| 4 | Database type well-matched to access patterns with clear rationale. One or two minor mismatches that are acknowledged. Polyglot persistence documented at a high level. Schema design intentional though not fully documented |
| 3 | Database type is reasonable for the domain but selection justification is thin or missing. Access patterns mostly fit the model but some awkward queries exist. Polyglot persistence (if used) not fully justified or integration boundaries unclear |
| 2 | Database type appears to be a default choice without analysis of access patterns. Significant impedance mismatch between queries and data model (e.g., heavy relational queries in a document store, or graph traversal in a relational DB without graph extensions). No justification documented |
| 1 | No evidence of data model selection reasoning. Database chosen arbitrarily or by habit. Severe impedance mismatch causing complex workarounds. Multiple databases used without any coordination strategy |

---

## DA2: Consistency & Trade-off Awareness

**What it evaluates**: Whether the system's consistency requirements are explicitly positioned within the CAP theorem and PACELC theorem trade-offs, with ACID vs BASE decisions made intentionally. Strong consistency requirements must be architecturally enforced; eventual consistency must be acknowledged with compensation strategies.

*Maps to ISO 25010: Reliability (Availability), Performance Efficiency.*

### Proposal questions
- Does the design explicitly state the required consistency level for each data domain?
- Are CAP theorem trade-offs (Consistency vs Availability under Partition) documented for distributed components?
- Is the choice between ACID transactions and BASE eventual consistency justified?
- Are PACELC trade-offs (Partition case: CA; Else: Latency vs Consistency) considered for geo-distributed or high-throughput components?

### Implementation-compliance questions
- Do transaction boundaries match the stated consistency requirements?
- Are eventual consistency scenarios handled with explicit compensation logic?
- Is the isolation level configured in the database consistent with the stated requirements?
- Are there places where stronger consistency is assumed but not guaranteed by the chosen database?

### Implementation-results questions
- Have consistency anomalies (dirty reads, lost updates, phantom reads) occurred in production?
- Is the system's behavior under network partitions tested and understood?
- Does the team know which operations are guaranteed ACID and which are eventually consistent?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Consistency requirements explicitly stated per data domain. CAP positioning documented — partition behavior is a known design decision, not a surprise. ACID vs BASE choice justified with compensation strategies for eventual consistency. Isolation levels configured intentionally. Consistency SLOs defined and monitored |
| 4 | Consistency requirements documented for critical paths. CAP trade-offs understood and most decisions intentional. Eventual consistency handled in main paths. One or two edge cases where consistency guarantees are unclear |
| 3 | Core consistency requirements understood but not formally documented. ACID used for primary transactions; eventual consistency in secondary flows without explicit compensation in all cases. CAP positioning implicit rather than explicit |
| 2 | Consistency requirements assumed rather than specified. ACID and BASE mixed without clear boundaries. Eventual consistency scenarios exist without compensation strategies. The team cannot reliably state what consistency guarantees the system provides |
| 1 | No awareness of consistency trade-offs. ACID transactions assumed everywhere (even in distributed scenarios where they cannot be guaranteed) or eventual consistency used everywhere without understanding the implications. Consistency anomalies possible in critical paths |

---

## DA3: Data Isolation & Ownership

**What it evaluates**: Whether each database (or schema/table set) has a single owning service or feature, with no shared write access across ownership boundaries. Data sovereignty — the principle that data is governed by the service that owns it — is enforced architecturally. Applies at all scales from modular monolith (schema-per-module) to microservices (database-per-service).

*Maps to ISO 25010: Maintainability (Modifiability). Integrates the Shared Database anti-pattern (already flagged in [anti-patterns-boundary.md](anti-patterns-boundary.md) — this criterion evaluates the positive case).*

Note: This criterion does NOT duplicate D1-D5. D5 (External Dependency Management) evaluates how third-party libraries are wrapped. DA3 evaluates data ownership boundaries specifically — which service can write to which data store, and whether that boundary is enforced.

### Proposal questions
- Does the design identify the owner of each database, schema, or table?
- Does each service/feature write only to its own data store?
- Is cross-boundary data access routed through the owning service's API?
- For shared data needs, is the access pattern defined (read replicas, event propagation, API calls)?

### Implementation-compliance questions
- Is there any direct write access to another service's/feature's data store from outside the owner?
- Are schema migrations owned by a single team?
- Do cross-service read needs use the owning service's API or a read model, not direct database access?
- Are foreign keys or table joins that span ownership boundaries present in the schema?

### Implementation-results questions
- When a schema changes, which teams require coordination?
- Have there been data integrity conflicts from competing writes to shared tables?
- Can each service's database schema be evolved independently?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Every table/collection has a single documented owner. No cross-service write access to shared tables. Cross-boundary reads use API calls or dedicated read models. Schema migrations are owned by single teams. Data ownership documented and enforced through access controls |
| 4 | Data ownership clearly established for most stores. One or two shared read patterns where direct database access is used for performance but no shared writes exist. Schema ownership clear with rare cross-team coordination |
| 3 | Data ownership conceptually understood but not formally documented. Some services read directly from other services' tables for practical reasons. No shared writes but shared schemas create implicit coupling. Schema changes sometimes require cross-team coordination |
| 2 | Multiple services write to shared tables. No formal data ownership. Schema changes require coordination across multiple teams. Data integrity maintained through application-level coordination rather than ownership boundaries |
| 1 | No concept of data ownership. Multiple services freely read and write to the same tables. Schema changes break multiple services unpredictably. Data integrity depends on coordinated deployments. Classic shared database anti-pattern |

---

## DA4: Distributed Data Coordination

**What it evaluates**: Whether cross-service data operations are coordinated using architecturally sound patterns — specifically saga (choreography or orchestration), CQRS, or event sourcing — rather than distributed transactions. Distributed transactions (2PC) are a distributed monolith signal. This criterion only applies to systems with multiple data stores; Simple and Standard single-database systems are not expected to address this criterion.

*Maps to ISO 25010: Reliability. Integrates [frameworks-architecture-styles.md](frameworks-architecture-styles.md) CQRS and Event-Driven sections.*

### Proposal questions
- Does the design identify all cross-service data operations that span multiple databases?
- Is each multi-database operation implemented using saga, CQRS, or event sourcing — not 2-phase commit?
- Are compensation transactions defined for saga rollback scenarios?
- Is the saga orchestration vs choreography trade-off explicitly evaluated?

### Implementation-compliance questions
- Are there any distributed transactions (2PC, XA) in use?
- Does each saga have defined compensation steps for every failure scenario?
- If CQRS is used, are command and query models kept in sync through a well-defined projection strategy?
- If event sourcing is used, is the event store append-only with defined snapshot strategy?

### Implementation-results questions
- Have saga failures produced orphaned records or inconsistent state?
- Is the eventual consistency window between command and query models acceptable for the use case?
- Can the team replay events to reconstruct state after a failure?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | All cross-service data operations use saga, CQRS, or event sourcing. No distributed transactions. Sagas have documented compensation steps for every failure scenario. Saga failure cases tested. CQRS projection lag monitored and bounded. Idempotency enforced for all event consumers |
| 4 | Cross-service operations use sagas or events. Most failure scenarios have compensation logic. One or two edge cases where compensation is incomplete. No distributed transactions. CQRS used with understood eventual consistency characteristics |
| 3 | Main cross-service paths use saga or events but some operations are not formally coordinated. Compensation logic exists for primary failure cases but edge cases may produce inconsistency. No 2PC but some tight synchronous coordination that approaches it |
| 2 | Cross-service operations mix synchronous HTTP calls with incomplete saga patterns. Some distributed transaction attempts (2PC or equivalent). Failure scenarios partially handled. Inconsistent state possible in edge cases |
| 1 | Distributed transactions (2PC, XA) used. Or: cross-service data operations simply ignore consistency — each service commits independently with no coordination. Data inconsistency in failure scenarios accepted by default. No compensation logic |

---

## DA5: Data Scalability Strategy

**What it evaluates**: Whether the architecture defines a data scaling strategy appropriate for the system's growth projections — including horizontal vs vertical scaling decisions, sharding/partitioning approach, replication topology, read replica usage, and connection pooling. This criterion does NOT require complex scaling for Simple systems; it requires that scaling decisions (even "we will scale vertically until X threshold") are intentional and documented.

*Maps to ISO 25010: Performance Efficiency (Time Behavior, Resource Utilization, Capacity). Integrates Q3 at the data layer specifically.*

Note: Q3 (Scalability & Performance Design) in Lens 4 evaluates architectural scalability broadly. DA5 narrows specifically to data layer scalability decisions — it does not duplicate Q3 but extends it to the data tier.

### Proposal questions
- Does the design specify expected data volume growth and query load projections?
- Is there a documented decision between vertical and horizontal scaling for the data tier?
- For write-heavy workloads, is sharding/partitioning strategy defined (partition key, shard count, hot-partition mitigation)?
- For read-heavy workloads, is replication topology defined (synchronous vs asynchronous replicas, read replica routing)?
- Is connection pooling configured and sized appropriately for the expected concurrency?

### Implementation-compliance questions
- Does the implemented database configuration match the scaling strategy (pool size, replica count, partition scheme)?
- Are hot partitions or write-skew risks identified and mitigated?
- Is connection pool exhaustion addressed (backpressure, queue depth limits)?
- Are read replicas used with awareness of replication lag implications for the use case?

### Implementation-results questions
- At what data volume does the current architecture require restructuring?
- Have there been connection pool exhaustion incidents?
- Is replication lag monitored and within acceptable bounds?
- As data grows, do query performance profiles degrade predictably or unexpectedly?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Data volume and query load projections documented. Vertical vs horizontal scaling decision explicit with defined threshold for switching. Sharding strategy (if applicable) includes partition key rationale and hot-partition mitigation. Replication topology documented with lag monitoring. Connection pools sized with concurrency model. Scaling assumptions tested under load |
| 4 | Scaling strategy documented for primary data stores. Read replica usage intentional with understood lag implications. Connection pooling configured. Sharding deferred with explicit threshold documented. No known architectural blockers to scaling when needed |
| 3 | Basic scaling considered (connection pooling configured, read replicas in use) but strategy not formally documented. Scaling decisions made reactively rather than proactively. Some query patterns would require restructuring under load growth |
| 2 | No documented data scaling strategy. Connection pooling may be present but not tuned. No read replicas where traffic would benefit. Sharding not considered despite projected growth. Scaling problems will require architectural changes when they arrive |
| 1 | No scaling consideration. Single database instance handles all load. No connection pooling. No read replicas. No awareness of data volume growth implications. Scaling requires a full database migration or architecture redesign |
