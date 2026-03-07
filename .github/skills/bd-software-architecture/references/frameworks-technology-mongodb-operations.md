# Technology context: MongoDB — Operations & Deployment

MongoDB transactions, consistency, security configuration, backup, Kubernetes deployment, and anti-patterns. For data modeling, indexing, and storage engine, see [frameworks-technology-mongodb-data-design.md](frameworks-technology-mongodb-data-design.md). For replication and sharding, see [frameworks-technology-mongodb-scaling.md](frameworks-technology-mongodb-scaling.md).

## Transactions & Consistency

**Multi-document ACID transactions** (DA2):
- **MongoDB 4.0**: Multi-document ACID transactions on replica sets
- **MongoDB 4.2+**: Transactions extended to sharded clusters; removed 16 MB per-transaction cap (uses multiple oplog entries)
- Transactions provide all-or-nothing atomicity across multiple documents and collections within a single logical operation

**Read/write concern trade-offs** (DA2):

| Configuration | Consistency | Performance | Use Case |
|--------------|-------------|-------------|----------|
| `w: 1`, `readConcern: "local"` | Weakest — may read uncommitted data, writes may be lost | Fastest | Non-critical data, caches, counters |
| `w: "majority"`, `readConcern: "majority"` | Strong — reads only majority-committed data | Moderate overhead | Most production workloads |
| `w: "majority"`, `readConcern: "linearizable"` | Strongest — reflects all majority writes that preceded the read | Highest latency | Financial transactions, critical state |
| `readConcern: "snapshot"` (in transaction) | Transaction-scoped snapshot isolation | Transaction overhead | Multi-document operations requiring consistency |

**Causal consistency** (DA2):
- Use `client.startSession()` with `readConcern: "majority"` + `writeConcern: { w: "majority" }` to guarantee: read-your-writes, monotonic reads, monotonic writes, writes-follow-reads
- Causal consistency works across replica set members — a read on a secondary is guaranteed to see all prior writes from the same session

**Transaction limits and performance** (DA2, DA4):
- Default timeout: 60 seconds (`transactionLifetimeLimitSeconds`)
- Recommended maximum: ~1000 documents per transaction — larger batches pressure WiredTiger cache because old snapshots must be retained until commit/abort
- Cross-shard transactions add two-phase commit overhead — minimize for latency-sensitive paths
- Anti-pattern: Overusing transactions for operations that embedding would eliminate — if related data is embedded in a single document, the write is already atomic without a transaction
- Anti-pattern: Long-running transactions holding WiredTiger snapshots open — prevents cache eviction, degrades overall server performance

## Security Configuration (architectural decisions)

Security configuration items relevant to architecture decisions. For detailed security controls, vulnerability analysis, and secure coding checklists, see the bd-security-review skill's `language-mongodb.md`.

**Authentication architecture** (DA2, cross-ref bd-security-review):
- **SCRAM-SHA-256** (default since MongoDB 4.0): Preferred for all client authentication. SCRAM-SHA-1 is deprecated
- **x.509 certificates**: Preferred for internal member authentication (replica set and sharded cluster members). More secure than keyfile authentication
- **Keyfile authentication**: Shared secret for internal member auth — acceptable for development, prefer x.509 for production
- **Cloud IAM**: On MongoDB Atlas, use AWS IAM (`MONGODB-AWS` mechanism) or equivalent cloud identity for application authentication — eliminates static credential management

**Network and transport encryption** (DA2, cross-ref bd-security-review):
- Set `net.tls.mode: requireTLS` to enforce TLS on all connections
- Never expose MongoDB port (27017) to the public internet — bind to private interfaces only
- Default: `mongod` binds to `localhost` only

**Access control** (DA2, cross-ref bd-security-review):
- Enable RBAC with `--auth` flag (or `security.authorization: enabled`)
- Never use `root` or `dbOwner` roles for application service accounts — create application-specific roles with minimum required privileges
- Anti-pattern: Running MongoDB without authentication enabled — any client on the network has full access

**Client-Side Field Level Encryption (CSFLE) / Queryable Encryption** (DA2, cross-ref bd-security-review):
- **Architecture decision**: CSFLE (MongoDB 4.2+) encrypts sensitive fields in the application before sending to MongoDB — the server never sees plaintext. Uses envelope encryption with KMS (AWS KMS, Azure Key Vault, Google Cloud KMS, HashiCorp Vault)
- **Queryable Encryption** (MongoDB 6.0+ equality, 7.0+ range): Allows querying encrypted fields without decrypting on the server — data remains encrypted in memory, on disk, in transit, and in CPU
- Use for PII, financial data, health records, or any field where the database administrator should not have access to plaintext

**Server-side JavaScript** (DA2, cross-ref bd-security-review):
- Set `security.javascriptEnabled: false` in production to disable `$where`, `$function`, `$accumulator`, and `mapReduce` — these evaluate arbitrary JavaScript on the server, creating injection risk
- MongoDB 7.0+ disables server-side JavaScript by default

## Backup & Disaster Recovery

**Logical backups** (DA5):
- **`mongodump`/`mongorestore`**: Portable across MongoDB versions, supports selective collection restore. Slow for large databases (reads all data, writes BSON files)
- **`mongoexport`/`mongoimport`**: JSON/CSV export — useful for data migration, not suitable for production backup (does not preserve all BSON types)
- Test restore time regularly — `mongorestore` on a large database can take hours

**Physical backups** (DA5):
- **Filesystem snapshots** (LVM, EBS, ZFS): Fast backup of WiredTiger data files. The journal and data files must be on the same volume for a consistent snapshot. Use `db.fsyncLock()` before snapshot if journal is on a separate volume
- **Oplog-based PITR**: Capture the oplog continuously, replay from a base backup to any point in time — achieves RPO of seconds for self-hosted deployments

**Managed backup** (DA5):
- **MongoDB Atlas**: Continuous backup with configurable PITR window (up to 7 days for M10+). Snapshots taken automatically, stored in cloud provider storage
- Anti-pattern: Relying solely on `mongodump` for large databases without testing restore time — logical backups are too slow for meaningful RTO on multi-TB databases
- Anti-pattern: No backup verification — an untested backup is not a backup

## Cloud-Native & Kubernetes Deployment

**Managed services** (DA5):
- **Recommendation**: Use MongoDB Atlas for most production deployments — offloads HA, patching, backups, monitoring, auto-scaling, and security hardening
- **Atlas features**: Auto-scaling (compute and storage), Atlas Search (Lucene-based full-text search via `$search`), Global Clusters (zone sharding with geographic data locality), serverless/Flex instances for variable workloads
- Evaluate Atlas limitations: extension/plugin ecosystem is managed, network peering/PrivateLink setup required for VPC integration, specific MongoDB version availability timeline

**Kubernetes operators** (DA5):
- **MongoDB Community Operator**: Open-source; supports replica sets, TLS, SCRAM authentication. Missing: automated backups, sharding, encryption at rest, KMS integration, audit logging
- **MongoDB Enterprise Operator**: Full-featured — backup, sharding, encryption at rest, LDAP, audit logging, Ops Manager integration. Requires Enterprise Advanced license
- Operators deploy MongoDB as StatefulSets with stable network identity and persistent storage — they handle leader election, replica promotion, and rolling updates

**StatefulSet requirements** (DA5):
- **PersistentVolumeClaims**: One PVC per pod, bound to a PersistentVolume. Use a StorageClass with `allowVolumeExpansion: true` — PVC size can only increase, never decrease
- **Pod Anti-Affinity**: Spread replica set members across nodes/zones to survive single-node failures
- **Stable network identity**: Each pod gets a predictable hostname (`mongodb-0`, `mongodb-1`, ...) for replica set member discovery

**Externalize from Kubernetes** (DA5):
- Alternative architecture: Keep the Kubernetes cluster stateless by hosting MongoDB outside the cluster (Atlas or dedicated VMs) and connecting via external service manifests
- Simplifies K8s operations — no StatefulSet management, PVC resizing, or operator upgrades to worry about
- Anti-pattern: Running MongoDB on Kubernetes without an operator or PVCs — data loss on pod restart, no automated failover
- Anti-pattern: "Distracted by Shiny" — adopting MongoDB because it is a popular NoSQL technology without evaluating whether a document model fits the application's actual access patterns. Adoption should be driven by specific needs (flexible schema, horizontal scalability, document-oriented access patterns)

## Common MongoDB anti-patterns

Architecture-relevant anti-patterns specific to MongoDB deployments:

| Anti-Pattern | Criterion | Impact |
|-------------|-----------|--------|
| Relational normalization / emulating joins across collections | DA1 | N+1 query patterns, severely degraded read performance |
| Unrestricted schema-lessness without validation | DA1 | Inconsistent data, complex query-time validation, unreliable analytics |
| Over-indexing (index on every field) | DA1 | Degraded write performance, bloated RAM usage, slower builds |
| Single instance without replication | DA5 | Single point of failure, no failover, unacceptable for production |
| Monotonic shard key with ranged sharding | DA5 | All writes concentrate on one shard — hot shard bottleneck |
| Dual-writes to MongoDB + another system without coordination | DA4 | Permanent data inconsistency if one write fails |
| Overusing multi-document transactions | DA2 | WiredTiger cache pressure, snapshot retention, degraded throughput |
| Shared integration database between microservices | DA3 | Tight coupling, cascade failures on schema change, lost service autonomy |
| No authentication enabled | Cross-ref | Unauthenticated access — see bd-security-review `language-mongodb.md` |
| Long field names in BSON documents | DA5 | Storage bloat, increased memory and bandwidth consumption |
| Manual secondary index maintenance in application code | DA1 | Race conditions, desync, intermittent write failures |
| Premature sharding before exhausting simpler optimizations | DA5 | Unnecessary operational complexity, cross-shard query overhead |
