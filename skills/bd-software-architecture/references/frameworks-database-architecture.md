# Database Architecture Frameworks

Reference for database architecture theory, data model selection, and distributed data coordination patterns. Load this file when DA1-DA5 evaluation requires theoretical grounding, or when the system under review involves multiple databases, distributed transactions, consistency trade-off decisions, or data scalability strategy.

## CAP Theorem

In a distributed system, you can only guarantee two of three: **C**onsistency (all nodes see the same data simultaneously), **A**vailability (every request receives a response), and **P**artition tolerance (the system operates despite network failures). Since network partitions are a physical reality in distributed systems, the real choice is between CP (Consistency + Partition Tolerance) and AP (Availability + Partition Tolerance).

| Database | CAP Classification | Consistency Model | Notes |
|----------|-------------------|-------------------|-------|
| PostgreSQL (single) | CA (not distributed) | ACID | No partition tolerance as a single node |
| PostgreSQL + Streaming Replication | CP (configurable) | Strong to eventual | Synchronous replication = CP; async = AP |
| MongoDB (default) | AP | Eventual | Tunable consistency per operation |
| Cassandra | AP | Tunable eventual | Consistency level tunable per read/write |
| HBase | CP | Strong | ZooKeeper-coordinated consistency |
| DynamoDB | AP (default) | Eventual | Strong consistency available at higher cost |
| CockroachDB / Spanner | CP | Serializable | Distributed SQL with strong consistency |
| Redis (Sentinel/Cluster) | AP | Eventual | Async replication; potential data loss on failover |

**Application to DA2 scoring**: A system that explicitly documents its CAP positioning and has aligned its database choice accordingly scores 4-5 on DA2. A system that implicitly assumes strong consistency while using an AP database scores 1-2.

## PACELC Theorem

Extension of CAP for the non-partition case. Even when the system is running normally without network partitions (**E**lse), architects must still make a trade-off between **L**atency and **C**onsistency.

**Formula**: If **P**artition: choose **A**vailability or **C**onsistency; **E**lse: choose **L**atency or **C**onsistency.

| Database | Partition Case | Else Case | Notes |
|----------|---------------|-----------|-------|
| DynamoDB | AP | EL | Optimizes for low latency; eventual consistency |
| CockroachDB | CP | EC | Maintains consistency at latency cost |
| Cassandra | AP | EL | Tunable; defaults to low latency |
| Spanner | CP | EC | TrueTime gives strong consistency globally |
| PostgreSQL (single) | N/A (single node) | EC | Serializable isolation at latency cost |

**Application to DA2 scoring**: A system that explicitly documents its PACELC positioning and has aligned its consistency model accordingly scores 4-5 on DA2. A system that implicitly assumes strong consistency (EC) while using an AP database (EL by default) scores 1-2.

## ACID vs BASE

**ACID** (Atomicity, Consistency, Isolation, Durability) — properties of traditional relational database transactions. **BASE** (Basically Available, Soft state, Eventually consistent) — properties of distributed NoSQL systems optimized for scale and availability.

| Property | ACID | BASE |
|----------|------|------|
| Consistency guarantee | Strong (read committed, serializable) | Eventual (no guarantee of immediate consistency) |
| Availability | Sacrificed under partition | Maintained under partition |
| Write throughput | Lower (coordination overhead) | Higher (no global coordination) |
| Failure handling | Transaction rollback | Compensation logic, retry, idempotency |
| Appropriate for | Financial transactions, inventory, booking (double-spend prevention) | Social feeds, analytics, caching, search indexes |

**When ACID is non-negotiable**: Financial transactions (payment processing, balance updates), inventory management (double-sell prevention), booking systems (double-booking prevention), any domain where inconsistency means monetary loss or regulatory violation.

**When BASE is appropriate**: Social media feeds (stale content is acceptable), analytics pipelines (aggregate accuracy more important than individual record freshness), search indexes (eventual consistency with source of truth), caching layers (TTL-based expiry handles staleness).

## Data Model Selection Guide

| Access Pattern | Best Model | Example Databases | When NOT to use |
|---------------|-----------|------------------|-----------------|
| Complex relational joins, ACID transactions | Relational (SQL) | PostgreSQL, MySQL, SQL Server | When write throughput > 10K/s with horizontal scale need |
| Flexible schema, nested documents, document retrieval | Document | MongoDB, Couchbase, Firestore | When relationships between documents require joins |
| High-speed key lookups, caching, TTL-based expiry | Key-Value | Redis, DynamoDB (simple), Memcached | When queries beyond key lookup are needed |
| High write throughput, time-series, wide rows | Column-Family | Cassandra, HBase, ScyllaDB | When ACID transactions are required |
| Relationship traversal, network analysis | Graph | Neo4j, Amazon Neptune, ArangoDB | When relationship data is sparse or access is non-traversal |
| Full-text search, faceting, relevance ranking | Search | Elasticsearch, OpenSearch, Algolia | When transactional consistency is required |
| Distributed SQL, horizontal scale + ACID | NewSQL | CockroachDB, Spanner, YugabyteDB | When single-region or low write throughput makes cost unjustified |
| Time-ordered append, event replay | Event Store / Time-Series | EventStoreDB, InfluxDB, TimescaleDB | When random access or mutation is the primary pattern |

**Decision process for DA1 scoring**: The reviewer should check whether the team evaluated their access patterns against this table (or equivalent analysis) and documented the rationale. A score of 5 requires explicit justification; a score of 1 indicates no analysis was performed.

## Polyglot Persistence Design Rules

Rules for evaluating systems that use multiple databases (applies to DA1 and DA3):

1. **One store per access pattern** — Each database serves a distinct access pattern. No two stores serve identical query shapes.
2. **No cross-store joins** — Integration happens at the application layer, never through database-level joins across stores.
3. **Clear ownership boundary** — Each data entity is owned by exactly one store. The owning store is authoritative; other stores hold read-only projections or cached copies.
4. **Sync strategy documented** — When data is copied between stores (e.g., event-driven replication from PostgreSQL to Elasticsearch), the sync mechanism, lag bound, and failure behavior are documented.
5. **ADR per store** — Each store in a polyglot system requires its own ADR justifying the choice.

**Anti-pattern**: A system that uses both PostgreSQL and MongoDB but accesses the same data through both stores (no clear ownership) or joins data across stores at the database level violates rules 2 and 3.

## Saga Pattern Reference

Two coordination variants for managing distributed data operations across services (applies to DA4):

### Choreography

- Services react to events published by other services
- No central coordinator
- Stronger independence — services do not know about each other
- Harder to visualize and debug the overall flow
- **When to use**: Loose coupling is paramount, services are independently deployed, teams are autonomous
- **When to avoid**: Complex flows with many steps, flows requiring centralized failure handling or visibility

### Orchestration

- Central saga orchestrator calls each service in sequence
- The orchestrator knows the full flow
- Easier to visualize and test the full saga
- More coupling to the orchestrator
- **When to use**: The flow is complex and needs to be visible in one place, failure handling requires centralized decision-making
- **When to avoid**: Simple two-service interactions, when strong team independence is required

### Saga failure handling checklist (applies to DA4 scoring)

- [ ] Is every step idempotent (safe to retry)?
- [ ] Is every step compensatable (can it be undone if a later step fails)?
- [ ] Is compensation also idempotent (safe to retry the compensation)?
- [ ] Is the saga state persisted so it survives a coordinator crash?
- [ ] Are saga timeouts defined (what happens if a step never responds)?

## Sharding and Partitioning Reference

Strategies for distributing data across multiple database instances (applies to DA5):

### Partitioning strategies

1. **Hash partitioning** — Key is hashed to determine partition. Uniform distribution but range queries expensive.
2. **Range partitioning** — Data partitioned by key range. Range queries efficient but risk hot partitions at range boundaries.
3. **Directory/lookup partitioning** — Lookup table maps keys to partitions. Flexible but introduces coordinator as single point of failure.

### Partition key selection criteria

| Criterion | Good Key | Bad Key |
|----------|---------|---------|
| Cardinality | High (UUID, user_id with millions of users) | Low (boolean, status enum, date without time) |
| Distribution | Uniformly distributed across value space | Skewed (most values cluster around a few keys) |
| Growth pattern | Stable distribution as data grows | Monotonically increasing (hot newest partition) |
| Query locality | Commonly queried together data co-located | Commonly queried data spread across shards |

### Replication topology considerations

- **Synchronous replication**: Strong consistency across replicas. Higher write latency. Use for critical data where consistency matters more than speed.
- **Asynchronous replication**: Lower write latency. Potential data loss on failover. Use when eventual consistency is acceptable.
- **Read replicas**: Route read-heavy traffic to replicas. Must account for replication lag in user-facing flows (read-your-writes consistency).
- **Multi-region replication**: Required for disaster recovery and low-latency global access. Introduces PACELC trade-offs.
