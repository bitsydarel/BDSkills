# Anti-patterns: Database Architecture (Lens 6)

Database-specific architecture failure modes. For the Shared Database Anti-Pattern (multiple services writing to the same tables), see [anti-patterns-boundary.md](anti-patterns-boundary.md). The anti-patterns below cover distinct failure modes in data model selection, consistency assumptions, partitioning, replication, and connection management.

## Database as God Object [Critical]

Using a single database to handle all data models, all access patterns, and all consistency requirements in one instance, with no evaluation of whether a different data model would better serve specific access patterns.

**Signs**:
- RDBMS stores BLOB JSON columns for document data, graph relationships as join tables with recursive path traversal queries, and time-series data as standard rows with timestamp columns
- Complex EAV (Entity-Attribute-Value) tables used as a workaround for flexible schema needs
- Full-text search implemented through LIKE queries or basic ILIKE on large tables with no search-optimized store
- Performance degrades for specific access patterns but is attributed to query tuning rather than data model mismatch
- New features shoehorned into the existing schema despite poor fit for the access pattern

**Impact**:
- Query complexity grows with each use case that does not fit the relational model
- Performance problems are addressed with indexes and query tuning rather than appropriate data models
- Schema becomes difficult to evolve as multiple use cases share the same tables with conflicting optimization needs
- Operations teams must tune a single instance for conflicting workloads (OLTP vs analytics vs search)

**Fix**:
- Identify access patterns that are a poor fit for the current database type using the data model selection guide in [frameworks-database-architecture.md](frameworks-database-architecture.md)
- Introduce purpose-specific stores at the boundary of new features (strangler fig approach)
- Define integration boundaries between stores: no cross-store joins, APIs or events between stores
- Document each store's responsibility and access patterns in ADRs

**Detection**:
- Search for EAV tables, BLOB JSON columns in relational databases, or recursive CTEs simulating graph traversal
- Check for LIKE/ILIKE queries on large text columns where full-text search would apply
- Review query execution plans: are there sequential scans on large tables that could be eliminated with a different data model?
- Ask: "What access patterns does this database handle poorly?" — any answer beyond "none" warrants investigation

---

## Implicit Consistency Assumptions [Critical]

Treating multi-system operations as if they have ACID semantics when they do not. The system behaves correctly under happy-path conditions but produces inconsistent state under partial failure.

**Signs**:
- Cross-service operations commit to each system independently without coordination (fire-and-forget HTTP calls between writes)
- No compensation logic for failure scenarios in multi-step operations
- Error handling assumes that if step N failed, steps 1 through N-1 were rolled back — they were not
- Application tests cover the success path; failure path testing is absent or minimal
- "It has never happened" justifies the lack of consistency handling

**Impact**:
- Partial failure (network timeout between writes, service crash after first commit) produces inconsistent state
- Inconsistency may be silent — no error is thrown; the system proceeds with corrupted data
- Data reconciliation after incidents requires manual intervention
- Customer-facing data (orders, payments, inventory) may show conflicting state across services

**Fix**:
- Identify every cross-service write operation and classify it by consistency requirement
- For operations requiring atomicity: implement saga with compensation steps and idempotency keys
- For operations tolerating eventual consistency: use event sourcing with idempotent consumers
- Add idempotency keys to all distributed write operations
- Test failure scenarios explicitly: what happens if step 2 of 3 fails? What if compensation fails?

**Detection**:
- Map every operation that writes to more than one database or calls more than one service's write endpoint
- For each: ask "what happens if the second write fails?" — if the answer is "we don't handle that," the pattern is present
- Check for absence of saga libraries, event stores, or compensation logic in cross-service operations
- Review incident history: have there been data consistency incidents requiring manual repair?

---

## Hot Partition Anti-Pattern [Major]

Choosing a partition/shard key that concentrates write load on a single partition, creating a write bottleneck while other partitions sit idle. Defeats the purpose of horizontal scaling.

**Signs**:
- Partition key is a monotonically increasing value (auto-increment ID, timestamp, sequential date)
- One shard handles significantly more write throughput than others (visible in per-shard database metrics)
- Write performance does not improve after adding shards
- The team is unaware of the partition key's cardinality and distribution characteristics
- Time-based queries (ORDER BY created_at) always hit the same partition

**Impact**:
- Horizontal scaling adds infrastructure cost without proportional throughput improvement
- The hot partition becomes the system's write bottleneck and single point of degradation
- Shard rebalancing is expensive and operationally risky when hotspots are discovered late
- SLA violations during peak write periods that cannot be resolved by adding more shards

**Fix**:
- Choose partition keys with high cardinality and uniform distribution (e.g., user_id with UUID, geographic region + entity_id composite)
- For time-series data: use a composite key (time bucket + entity_id) to distribute time-adjacent writes across partitions
- Review partition key selection in ADRs: document why the key distributes load evenly
- Monitor per-partition write throughput — alert when any partition handles >30% of total writes in a multi-partition setup

**Detection**:
- Review the partition key for monotonic characteristics (auto-increment, timestamps as primary shard key)
- Check per-shard write metrics: is distribution uniform across partitions?
- Simulate write load with realistic data distribution — measure throughput per shard
- Ask: "If 1000 users all place orders at the same second, do all orders land in the same shard?"

---

## Read Replica Staleness Blindness [Major]

Routing reads to replicas without accounting for replication lag, producing stale reads in scenarios where the user expects to see their own writes (read-your-writes consistency).

**Signs**:
- Reads after writes routed to replicas without considering lag (e.g., user creates a record, immediately refreshes, sees old data)
- No monitoring of replication lag (replica_delay metric not tracked)
- UI displays stale data after user-initiated changes — often misattributed to "cache issues"
- "Read your own writes" consistency requirement not documented or tested
- Replication lag acceptable for analytics queries but also applied to user-facing immediate feedback paths

**Impact**:
- Users experience apparent data loss — they just saved something and it is not visible
- Support tickets for "my changes aren't saved" — which are actually replication lag
- Complex workarounds (post-write redirects, client-side caching of write result) applied without fixing the root cause
- Lagging replicas used for business-critical reporting, producing incorrect metrics during lag spikes

**Fix**:
- Classify reads by consistency requirement: "read your own writes" vs "eventually consistent acceptable"
- Route "read your own writes" reads to the primary or use a session consistency token
- Monitor replica_delay continuously; alert when lag exceeds the acceptable window for any use case
- Document the acceptable lag bound for each replica-routed read pattern

**Detection**:
- Check if replication lag is monitored: is `replica_delay` or equivalent metric tracked with alerting?
- Identify paths where a write is immediately followed by a read of the same data — are those reads routed to primary or replica?
- Simulate replication lag in integration tests — do user-facing flows behave correctly with 5 seconds of lag?
- Ask: "If replication lag reaches 30 seconds, which user-facing flows break?"

---

## Connection Pool Exhaustion [Major]

No connection pool, undersized pool, or pool configured without backpressure — causing the database to be overwhelmed during load spikes, producing cascading failures.

**Signs**:
- Database connections created per-request without pooling (each request opens and closes a connection)
- Pool size set to an arbitrary number without analysis of concurrent database operations per request
- Connection acquisition timeouts during load spikes with no backpressure (requests queue indefinitely waiting for connections)
- Database server reports "too many connections" errors at moderate load levels
- Connection pool metrics not monitored (pool utilization, wait time, timeout count)

**Impact**:
- Database server runs out of connections before the application server runs out of request-handling capacity
- Connection wait time adds unpredictable latency to all database-dependent operations
- Connection exhaustion cascades: all request handlers block waiting for connections; the application appears unresponsive
- Mean time to recovery (MTTR) is long because the failure mode (pool exhaustion) is not immediately obvious from application logs alone

**Fix**:
- Size the connection pool based on: (max_db_connections / num_application_instances) - buffer
- Implement a maximum wait time with a circuit breaker: if a connection cannot be acquired within N milliseconds, fail fast with a service-degraded response rather than queuing indefinitely
- Monitor pool utilization: alert when utilization exceeds 80%
- Use separate pools for different query priority levels (critical user-facing path vs background jobs)

**Detection**:
- Check if connection pooling is configured: is each request opening its own connection?
- Measure pool utilization under typical load: what percentage of the pool is in use?
- Load test to 2x peak load: does connection exhaustion occur?
- Review connection pool timeout settings: is there a maximum acquisition wait time with a circuit-breaker fallback?
