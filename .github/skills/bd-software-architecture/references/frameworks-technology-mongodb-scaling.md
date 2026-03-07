# Technology context: MongoDB — Replication & Sharding

MongoDB high availability, replication, and horizontal scaling patterns. For data modeling, indexing, and storage engine, see [frameworks-technology-mongodb-data-design.md](frameworks-technology-mongodb-data-design.md). For transactions, security, backup, and deployment, see [frameworks-technology-mongodb-operations.md](frameworks-technology-mongodb-operations.md).

## High Availability & Replication

**Replica sets** (DA5):
- A replica set consists of a primary node (handles all writes) and one or more secondary nodes (replicate the primary's oplog asynchronously)
- **Minimum production topology**: 3 data-bearing members (primary + 2 secondaries) for automatic failover with majority voting
- **Automatic failover**: If the primary becomes unavailable, secondaries hold an election and promote a new primary. Failover typically completes within 10-30 seconds
- **Oplog**: A capped collection (`local.oplog.rs`) that records all write operations. Size the oplog to maintain a replication window that exceeds your longest expected maintenance downtime

**Write concern** (DA5):
- `w: 1` (default): Acknowledged by primary only — fast but risks data loss if primary fails before replication
- `w: "majority"`: Acknowledged after a majority of voting members confirm the write — durable, survives primary failure. Use for any data that cannot be lost
- `j: true`: Primary writes to on-disk journal before acknowledging — protects against primary crash between acknowledgment and journal flush
- Anti-pattern: Using `w: 0` (unacknowledged) for important data — fire-and-forget writes can be silently lost

**Read preferences** (DA5):
- `primary` (default): All reads from primary — strongest consistency
- `primaryPreferred`: Reads from primary unless unavailable, then secondary
- `secondary` / `secondaryPreferred`: Offloads read traffic from primary — introduces eventual consistency (reads may return stale data due to replication lag)
- `nearest`: Routes to the lowest-latency member — beneficial for globally distributed deployments
- Anti-pattern: Single MongoDB instance without replication for production workloads — no failover, no read scaling, unacceptable availability risk
- Anti-pattern: Using arbiters in production topologies — an arbiter participates in elections but holds no data, reducing data redundancy. Prefer a full data-bearing member

## Scalability & Sharding

**Shard key selection** (DA5):
- **Cardinality**: High cardinality prevents jumbo chunks. Low cardinality (e.g., boolean, enum with few values) creates upper bounds on data distribution
- **Frequency**: Avoid fields where a few values represent the majority of documents — causes hot shards
- **Monotonicity**: Avoid monotonically increasing keys (timestamps, auto-increment IDs) with ranged sharding — all writes concentrate on the shard owning the upper range. Use hashed sharding or a compound key with a high-cardinality prefix
- **Query isolation**: Choose a shard key that allows `mongos` to route queries to a single shard (targeted queries) rather than broadcasting to all shards (scatter-gather)
- The shard key is immutable after collection creation (MongoDB 5.0+ supports `reshardCollection` but it is an expensive operation)

**Sharding strategies** (DA5):

| Strategy | Mechanism | Best For |
|----------|-----------|----------|
| Ranged | Documents grouped by contiguous shard key ranges | Range queries, time-series with compound keys |
| Hashed | Shard key hashed for even distribution | High-cardinality monotonic fields (ObjectId, timestamp); write throughput |
| Zone (Tag-Aware) | Admin assigns key ranges to named zones mapped to specific shards | Geographic data locality, regulatory data residency, tiered storage |

**Sharded cluster components** (DA5):
- **Shard servers**: Each shard is itself a replica set — holds a partition of the data
- **Config servers (CSRS)**: Replica set storing cluster metadata (chunk-to-shard mapping, zone assignments). Must be a 3-member replica set minimum
- **`mongos` routers**: Stateless query routers — cache metadata from config servers, route client queries to the correct shard(s). Deploy multiple `mongos` instances for HA. Options: co-located on application servers (local hop), dedicated instances, or on shard hosts
- **Balancer**: Background process on the config server primary that migrates chunks from overloaded shards to underloaded shards. Respects zone ranges

**Cross-shard considerations** (DA4):
- Cross-shard queries (scatter-gather) are significantly slower than targeted queries — design shard keys to minimize scatter
- Cross-shard transactions use a two-phase commit protocol — higher latency and lock contention than single-shard transactions
- Anti-pattern: Premature sharding — exhaust vertical scaling, read replicas, indexing optimizations, and working set tuning before introducing sharding complexity
- Anti-pattern: Monotonic shard keys with ranged sharding — causes "hot shard" where one shard receives all writes
- Anti-pattern: Dual-writes to MongoDB and another system (cache, message broker) without distributed transaction management — one write can fail silently, causing permanent data inconsistency
