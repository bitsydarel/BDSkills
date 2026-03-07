# Calibration: Database Architecture — Data Scalability Strategy (DA5)

Weak/adequate/strong examples for criterion DA5. Use when uncertain about a score boundary (2 vs 3, 3 vs 4). For full scoring criteria, see [evaluation-database-architecture.md](evaluation-database-architecture.md). For other database calibration criteria: [calibration-da1-data-model.md](calibration-da1-data-model.md) (DA1), [calibration-da2-consistency.md](calibration-da2-consistency.md) (DA2), [calibration-da3-data-isolation.md](calibration-da3-data-isolation.md) (DA3), [calibration-da4-distributed-coordination.md](calibration-da4-distributed-coordination.md) (DA4).

## DA5: Data Scalability Strategy

### Weak (Score 1-2)

```python
# Direct connection, no pool, single instance
import psycopg2

db = psycopg2.connect("postgres://localhost/app")  # New connection per import

class OrderRepository:
    def save(self, order):
        cursor = db.cursor()  # Shared connection, no pool
        cursor.execute("INSERT INTO orders ...", order.to_dict())
        db.commit()

    def find_all(self, page, size):
        cursor = db.cursor()
        cursor.execute(
            "SELECT * FROM orders ORDER BY created_at DESC LIMIT %s OFFSET %s",
            (size, page * size),
        )
        return cursor.fetchall()
        # With 10M orders, this full-table sort becomes catastrophic
```

**Why weak**: Single database connection (no pooling). Single instance handles all load. No read/write separation despite the workload being read-heavy. The `ORDER BY ... OFFSET` pattern degrades catastrophically at scale. No awareness of data volume growth implications.

### Adequate (Score 3)

```python
from psycopg2 import pool

connection_pool = pool.ThreadedConnectionPool(
    minconn=5, maxconn=20, dsn="postgres://localhost/app"
)
# Pool configured but: no read replicas despite 80% read workload
# No documented scaling strategy or growth projections

class OrderRepository:
    def save(self, order):
        conn = connection_pool.getconn()
        try:
            conn.cursor().execute("INSERT INTO orders ...", order.to_dict())
            conn.commit()
        finally:
            connection_pool.putconn(conn)

    def find_by_user(self, user_id):
        conn = connection_pool.getconn()
        try:
            return conn.cursor().execute(
                "SELECT * FROM orders WHERE user_id = %s", (user_id,)
            ).fetchall()
        finally:
            connection_pool.putconn(conn)
```

**Why adequate**: Connection pooling is configured (good). But there are no read replicas despite 80% read workload. No documented scaling strategy — the team would need to react when performance degrades. Pool size appears to be a guess (5-20) rather than calculated from concurrency requirements.

### Strong (Score 4-5)

```python
write_pool = ConnectionPool(PRIMARY_DSN, min_size=5, max_size=20)
read_pool = ConnectionPool(REPLICA_DSN, min_size=10, max_size=50)  # Read-heavy

class OrderRepository:
    """
    Scaling strategy (ADR-012):
    - Current: vertical scaling until 1M orders / 500 QPS
    - Threshold: at 1M orders, partition by user_id (hash, 4 partitions)
    - Read replicas: 2 async replicas, max acceptable lag 5s for user-facing queries
    - Connection pool: sized for 200 concurrent requests (4 app instances x 50 connections)
    """

    def save(self, order):
        with write_pool.connection() as conn:  # Writes to primary
            conn.execute("INSERT INTO orders ...", order.to_dict())

    def find_by_user(self, user_id):
        with read_pool.connection() as conn:  # Reads from replica
            # Acceptable replication lag for this query: < 5 seconds
            # (order history view — not time-critical)
            return conn.execute(
                "SELECT * FROM orders WHERE user_id = %s ORDER BY created_at DESC LIMIT 20",
                (user_id,),
            ).fetchall()

    def find_recent_order(self, user_id):
        with write_pool.connection() as conn:  # Reads from PRIMARY
            # Read-your-writes: user just placed an order, needs to see it immediately
            return conn.execute(
                "SELECT * FROM orders WHERE user_id = %s ORDER BY created_at DESC LIMIT 1",
                (user_id,),
            ).fetchone()
```

**Why strong**: Read/write pool separation with intentional routing. Read-your-writes consistency handled by routing recent-order queries to primary. Scaling strategy documented with explicit thresholds (1M orders triggers partitioning). Connection pool sized based on concurrency model (200 concurrent requests). Replication lag bound defined (5 seconds) for user-facing queries.

### Boundary

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| Is connection pooling configured? | No pool or single shared connection | Pool exists but not sized intentionally | Pool sized based on concurrency model |
| Are read replicas used for read-heavy workloads? | No replicas where traffic justifies them | Replicas exist but routing is not intentional | Read/write routing with lag-aware query placement |
| Is the scaling strategy documented? | No strategy exists | Basic measures in place (pooling) but no plan | Documented with thresholds and growth projections |
