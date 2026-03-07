# Technology context: PostgreSQL

PostgreSQL-specific architecture patterns and how the evaluation lenses adapt. Load this file when the system under review uses PostgreSQL as its primary database. For general database architecture theory (CAP, PACELC, data model selection), see [frameworks-database-architecture.md](frameworks-database-architecture.md). For security-specific PostgreSQL controls, see the bd-security-review skill's `language-postgresql.md`.

## Performance & Query Optimization

**Connection management** (DA5):
- Use connection pooling — never open per-request connections to PostgreSQL directly
- **PgBouncer pool modes**: `transaction` mode for most web workloads (connections returned after each transaction), `session` mode when using prepared statements or LISTEN/NOTIFY, `statement` mode only for simple autocommit queries (no multi-statement transactions)
- **Sizing formula**: `max_connections` = (pooler connections × number of pooler instances) + administrative headroom. Default PostgreSQL `max_connections = 100` is rarely appropriate for production — but increasing it without pooling wastes shared memory per-connection
- **Serverless/Lambda**: Use Amazon RDS Proxy or equivalent managed connection pooler to prevent connection storms from cold starts
- Anti-pattern: Opening a new connection per request without pooling — leads to connection exhaustion under load and wastes ~10MB per idle connection

**Smart indexing** (DA1):
- **B-tree** (default): Range queries, equality, ORDER BY, UNIQUE constraints — the right choice for most columns
- **GIN** (Generalized Inverted Index): Full-text search (`tsvector`), JSONB containment (`@>`), array operations — required for `WHERE jsonb_column @> '{"key": "value"}'`
- **pg_trgm + GIN/GiST**: Fuzzy text matching with `LIKE '%pattern%'`, `similarity()`, `ILIKE` — enables fast fuzzy search without application-level alternatives
- **BRIN** (Block Range Index): Naturally ordered data (timestamps, sequential IDs) in large tables — orders of magnitude smaller than B-tree with near-equivalent read performance
- **Partial indexes**: `CREATE INDEX ... WHERE status = 'active'` — index only the rows that matter, reducing index size and write overhead
- Anti-pattern: Creating an index on every column — each index slows INSERT/UPDATE/DELETE and consumes disk. Profile with `EXPLAIN (ANALYZE, BUFFERS)` before adding indexes

**Query performance monitoring** (Q4):
- **`pg_stat_statements`** (always enable): Tracks execution statistics for all SQL queries — cumulative time, calls, rows, block I/O. The single most important PostgreSQL extension for performance
- **`auto_explain`**: Logs execution plans for slow queries automatically when `auto_explain.log_min_duration` threshold is exceeded
- **`EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)`**: Per-query execution plan with actual timing and buffer usage — essential for index selection validation

**Table partitioning** (DA5):
- **Native declarative partitioning** (PG10+): `PARTITION BY RANGE`, `PARTITION BY HASH`, `PARTITION BY LIST` — partition pruning happens automatically in query planning
- Use for tables exceeding tens of millions of rows where queries consistently filter on the partition key (timestamps, tenant IDs)
- Partition maintenance: automate partition creation for time-based partitions (daily/monthly), drop old partitions instead of DELETE for instant space reclamation
- Anti-pattern: Partitioning small tables — adds complexity with no performance benefit. Partition only when sequential scans or VACUUM on the full table become problematic

**Denormalization trade-offs** (DA1):
- Justified when read-heavy with predictable access patterns (dashboards, reporting, materialized aggregates)
- Implement via materialized views (`REFRESH MATERIALIZED VIEW CONCURRENTLY`) or trigger-maintained summary tables
- Anti-pattern: Unmanaged denormalized data without refresh mechanisms — leads to data inconsistency with no detection

## Scalability & High Availability

**Read replica scaling** (DA5):
- **Streaming replication**: WAL-based physical replication to hot standby replicas
- **`synchronous_commit` modes**: `on` (default, waits for local WAL flush), `remote_apply` (waits for replica to apply — strongest consistency), `off` (async, ~10ms write speedup but data loss risk on crash)
- **Monitoring**: `pg_stat_replication` — track `replay_lag`, `write_lag`, `flush_lag` per replica. Alert on lag exceeding application-tolerable staleness
- **Read-your-writes routing**: Route reads that follow a write to the primary within a session, or use `synchronous_commit = remote_apply` for critical replicas. Application-level routing is required — PostgreSQL does not provide this natively
- Anti-pattern: Sending all traffic to the primary when read replicas are available, or sending write-dependent reads to a lagging replica

**Database sharding** (DA5):
- **Citus extension**: Distributed PostgreSQL — transparent sharding with distributed queries, tenant isolation, and reference tables
- **Application-level sharding**: Route by shard key in application code — simpler to start but requires careful cross-shard query handling
- Cross-shard joins are expensive or impossible — design the data model so that queries stay within a single shard
- Anti-pattern: Premature sharding — exhaust vertical scaling (bigger instance, connection pooling, read replicas, indexing) before adding sharding complexity

**Multi-AZ deployments** (DA5):
- **Synchronous standby** (`synchronous_standby_names`): Zero-data-loss failover with commit latency cost
- **Managed services**: RDS Multi-AZ (synchronous block-level replication), Aurora PostgreSQL (shared distributed storage with 6-way replication), Azure Flexible Server HA
- Document RPO/RTO targets explicitly. Synchronous replication achieves RPO=0 but increases write latency. Async replication offers lower latency but RPO > 0

**MVCC and isolation levels** (DA2):
- **READ COMMITTED** (default): Each statement sees a new snapshot — suitable for most OLTP workloads
- **REPEATABLE READ**: Transaction sees a consistent snapshot from start — use for reports that must be self-consistent. Serialization failures require application retry logic
- **SERIALIZABLE** (SSI): Full serializability via predicate locking — the safest level but requires retry logic for serialization failures. Use for financial transactions or invariant enforcement
- **VACUUM implications**: Long-running transactions hold back VACUUM, causing table bloat. Separate analytics (long queries) from OLTP (short transactions) — use read replicas for analytics or set `idle_in_transaction_session_timeout`
- Anti-pattern: Running long-running analytical queries on the OLTP primary — holds back autovacuum, causes table and index bloat, degrades write performance

## Security Configuration (architectural decisions)

Security configuration items relevant to architecture decisions. For detailed security controls, vulnerability analysis, and secure coding checklists, see the bd-security-review skill's `language-postgresql.md`.

**Authentication architecture** (DA2, cross-ref bd-security-review):
- **`pg_hba.conf`**: Never use `trust` authentication — enforce `scram-sha-256` for all connections. `md5` is deprecated (vulnerable to replay attacks)
- **IAM authentication**: In cloud environments (AWS, GCP, Azure), prefer IAM-based authentication over static database passwords. Architecture decision: IAM eliminates credential rotation burden but adds IAM dependency

**Encryption** (DA2, cross-ref bd-security-review):
- **TLS**: Set `ssl = on` in `postgresql.conf`, enforce via `hostssl` entries in `pg_hba.conf`. Verify with `sslmode=verify-full` in connection strings
- **Column-level encryption**: `pgcrypto` extension for encrypting sensitive columns at rest — architecture trade-off: adds complexity to queries but enables field-level access control

**Audit logging** (Q4, cross-ref bd-security-review):
- **`pgaudit`** extension: Structured audit logging for DDL and DML — required for compliance (SOC 2, PCI DSS, HIPAA)
- **`log_statement`**: Set to `ddl` at minimum for production. `all` for high-security environments
- **`log_min_duration_statement`**: Log slow queries — set to application-appropriate threshold (e.g., 200ms)

## Backup & Disaster Recovery

**Point-in-Time Recovery (PITR)** (DA5):
- **Strategy**: `pg_basebackup` for base backups + continuous WAL archiving (to S3, GCS, or Azure Blob)
- **Tools**: pgBackRest (recommended — parallel, incremental, encryption), Barman, WAL-G
- RPO depends on WAL archiving frequency — continuous archiving achieves RPO of seconds
- Test restores regularly — an untested backup is not a backup
- Anti-pattern: Relying solely on `pg_dump` for disaster recovery — logical backups take hours to restore for large databases and miss WAL-level granularity

**Logical backups** (DA5):
- **`pg_dump`**: Per-database logical backup — portable across PostgreSQL versions, supports selective table restore
- **`pg_dumpall`**: Includes global objects (roles, tablespaces) that `pg_dump` misses — run periodically alongside per-database backups
- **Backup rotation**: Retain daily for 7 days, weekly for 4 weeks, monthly for 12 months — adjust to RPO/compliance requirements

## Cloud-Native & Kubernetes Deployment

**Managed services** (DA5):
- **Recommendation**: Use managed PostgreSQL (RDS, Aurora, Azure Database for PostgreSQL, Cloud SQL) unless specific requirements demand self-managed — offloads HA, patching, backups, and monitoring
- Evaluate managed service limitations: extension availability, major version upgrade timing, parameter group restrictions, max connections ceiling

**Kubernetes persistent storage** (DA5):
- **PersistentVolumeClaims** (PVCs): Required for data survival across pod rescheduling — use `ReadWriteOnce` access mode with a StorageClass backed by SSD (gp3, pd-ssd)
- Never use `emptyDir` or `hostPath` for PostgreSQL data in production
- Anti-pattern: Running PostgreSQL in Kubernetes without PVCs — data loss on pod restart

**Kubernetes operators** (DA5):
- **CloudNativePG**: CNCF Sandbox project — declarative PostgreSQL clusters with automated failover, backup, and connection pooling
- **Zalando Postgres Operator**: Patroni-based HA with S3 WAL archiving and connection pooling via PgBouncer sidecar
- **Crunchy Data PGO (PGO)**: Enterprise-grade operator with pgBackRest integration, monitoring, and multi-cluster support
- Operators handle leader election, replica promotion, and rolling updates — do not implement manual failover scripts in K8s

**Secrets management** (DA5, cross-ref bd-security-review):
- Store database credentials in Kubernetes Secrets (with encryption at rest via KMS) or external vault (HashiCorp Vault, AWS Secrets Manager)
- Mount credentials as environment variables or volume-mounted files — never hardcode in container images, ConfigMaps, or application code
- Rotate credentials periodically — managed services with IAM authentication simplify this

## Common PostgreSQL anti-patterns

Architecture-relevant anti-patterns specific to PostgreSQL deployments:

| Anti-Pattern | Criterion | Impact |
|-------------|-----------|--------|
| Per-request connections without pooling | DA5 | Connection exhaustion under load, ~10MB wasted per idle connection |
| Index on every column | DA1 | Degraded write performance, bloated disk usage, slower VACUUM |
| `LIKE '%pattern%'` for full-text search | DA1 | Sequential scan on every query — use GIN with `tsvector` or `pg_trgm` |
| Single instance with no replication | DA5 | Single point of failure for production workloads — unacceptable availability risk |
| Analytics queries on OLTP primary | DA2 | VACUUM stalls from long transactions, table bloat, write performance degradation |
| `trust` authentication in pg_hba.conf | Cross-ref | Unauthenticated access — see bd-security-review `language-postgresql.md` |
| Hardcoded connection strings with passwords | Cross-ref | Credential exposure — see bd-security-review `language-postgresql.md` |
| Partitioning tables with < 10M rows | DA5 | Added complexity with no measurable performance benefit |
| No `pg_stat_statements` in production | Q4 | Flying blind on query performance — no data to identify bottlenecks |
