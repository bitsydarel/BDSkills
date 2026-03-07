# Technology context: MongoDB — Data Design

MongoDB-specific data modeling, schema design, indexing, query performance, and storage engine patterns. Load this file when the system under review uses MongoDB and the review focuses on data model selection, indexing strategy, or storage configuration. For replication and sharding, see [frameworks-technology-mongodb-scaling.md](frameworks-technology-mongodb-scaling.md). For transactions, security, backup, and deployment, see [frameworks-technology-mongodb-operations.md](frameworks-technology-mongodb-operations.md). For general database architecture theory (CAP, PACELC, data model selection), see [frameworks-database-architecture.md](frameworks-database-architecture.md). For security-specific MongoDB controls, see the bd-security-review skill's `language-mongodb.md`.

## Data Modeling & Schema Design

**Embed vs reference decision framework** (DA1):
- **Embed** (subdocuments/arrays): Use for 1:1 and 1:few relationships where the embedded data is always accessed with the parent. Embedding provides data locality — a single read returns the complete entity. Embed when the embedded data has no independent lifecycle
- **Reference** (ObjectId links): Use for 1:many with unbounded growth, many:many relationships, or when the referenced entity is accessed independently. References require application-level joins (`$lookup` in aggregation) or multiple queries
- **Decision heuristic**: If you always need the child data when reading the parent, embed it. If the child entity has independent access patterns, reference it. If the array can grow unbounded, reference — MongoDB documents have a 16 MB BSON limit
- Anti-pattern: Relational normalization across many collections, forcing the application layer to emulate SQL JOINs with sequential queries. This produces N+1 query patterns and severely degrades read performance

**Design for access patterns** (DA1):
- Schema design in MongoDB is driven by how the application queries and writes data, not by the inherent structure of the data
- Model documents to satisfy the most frequent queries in a single read — this may mean duplicating data across documents when different access patterns need different views
- Anti-pattern: Designing the schema based on entity relationships (as in relational modeling) without considering actual query patterns

**Schema validation** (DA1):
- Use `$jsonSchema` validator on collections to enforce document structure at the database level: required fields, field types, enum values, array constraints
- `validationAction: "error"` rejects invalid documents; `validationAction: "warn"` logs violations but accepts the document
- Anti-pattern: Treating MongoDB as entirely schema-less without any validation — leads to inconsistent data, pushes validation complexity into every query and application-layer consumer

**Data isolation** (DA3):
- In microservices architectures, each service should own its own MongoDB database or at minimum its own collections. No cross-service direct database access
- Cross-service data reads go through the owning service's API, not shared collection access
- Anti-pattern: Shared integration database — using a single MongoDB database as a communication layer between services. Schema changes in one service break others; tight coupling eliminates service autonomy

## Indexing & Query Performance

**Index types** (DA1):

| Index Type | Use Case | Key Considerations |
|------------|----------|-------------------|
| Single field (B-tree) | Equality, range, sort on one field | Default; supports ascending and descending |
| Compound | Queries on multiple fields | Follow the **ESR rule**: Equality fields first, Sort fields second, Range fields last |
| Multikey | Array fields — one index entry per array element | Auto-detected; cannot compound two multikey fields |
| Text | Full-text search with stemming and stop words | One text index per collection; supports `$text` operator |
| Hashed | Even distribution for shard keys | Cannot support range queries; use for hashed sharding only |
| 2dsphere (Geospatial) | GeoJSON objects, spherical distance queries | Use for location-based queries (`$near`, `$geoWithin`) |
| TTL | Auto-expire documents after N seconds | Single-field on a date field; background thread runs every 60 seconds |
| Partial | Index only documents matching a filter expression | Smaller and faster than full indexes; use when queries always include the filter condition |
| Wildcard | Flexible/unknown field names (`$**`) | Useful when document fields are not known at design time; high storage cost |
| Sparse | Index only documents where the field exists | Superseded by partial indexes in most cases |

**Compound index design — ESR rule** (DA1):
- **E**quality fields first — fields tested with exact match (`$eq`)
- **S**ort fields second — fields used in `sort()`
- **R**ange fields last — fields tested with `$gt`, `$lt`, `$in`
- Following ESR avoids in-memory (blocking) sorts and minimizes the number of index keys scanned

**Query profiling** (Q4):
- **`explain("executionStats")`**: Verify index usage — look for `IXSCAN` (index scan) vs `COLLSCAN` (collection scan). `COLLSCAN` on large collections indicates a missing index
- **Database profiler**: Set `db.setProfilingLevel(1, { slowms: 100 })` to log queries exceeding the threshold. Level 2 logs all queries (high overhead — use only for debugging)
- **`$currentOp`**: Monitor currently running operations, identify long-running queries
- Anti-pattern: Over-indexing — each index consumes RAM (the working set of indexes should fit in memory) and slows write operations. Profile with `explain()` before adding indexes
- Anti-pattern: Building and maintaining secondary indexes manually in application code — introduces race conditions and desync. Use MongoDB's native indexing

## Storage Engine & Connection Management

**WiredTiger storage engine** (DA5):
- **Document-level locking**: Concurrent writes to different documents in the same collection do not block each other (optimistic concurrency control)
- **Compression**: `snappy` (default — fastest, moderate ratio), `zstd` (best compression ratio with good speed, MongoDB 4.2+), `zlib` (high ratio, higher CPU). Time-series collections default to `zstd`
- **Cache sizing formula**: `max(50% × (RAM - 1 GB), 256 MB)`. Must set `--wiredTigerCacheSizeGB` explicitly in containers — the default formula uses host RAM, which is incorrect when cgroups limit memory
- **Journal**: WiredTiger journals every write for crash recovery. Checkpoints every 60 seconds or when journal reaches 2 GB
- Anti-pattern: Using the deprecated MMAPv1 storage engine — lacks document-level locking, no compression, no journal-based crash recovery

**Connection pooling** (DA5):
- Drivers maintain a connection pool per `mongos`/`mongod` endpoint. Key parameters:
  - `maxPoolSize` (default 100): Maximum concurrent connections per pool
  - `minPoolSize` (default 0, driver-dependent): Minimum connections kept open — set to warm the pool at startup
  - `maxIdleTimeMS` (default 0 = no limit): Maximum idle time before a connection is closed — set explicitly (e.g., 60000-300000ms) to avoid stale connections
  - `waitQueueTimeoutMS`: Maximum time a thread blocks waiting for a pool connection
- Anti-pattern: Not setting `maxIdleTimeMS` — stale connections accumulate, consuming file descriptors and server-side connection slots
- Anti-pattern: Opening a new connection per request without reusing the driver's pool — wastes resources and risks connection exhaustion

**BSON document size** (DA5):
- Maximum document size: 16 MB (BSON limit). Design schemas to stay well under this limit
- Field names are stored in every document — short, descriptive field names reduce storage and bandwidth overhead
- Anti-pattern: Long field names (e.g., `customerFullMailingAddress` on millions of documents) — bloats storage, increases memory consumption, and wastes network bandwidth
