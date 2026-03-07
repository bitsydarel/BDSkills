# Calibration: Database Architecture — Data Model Selection & Justification (DA1)

Weak/adequate/strong examples for criterion DA1. Use when uncertain about a score boundary (2 vs 3, 3 vs 4). For full scoring criteria, see [evaluation-database-architecture.md](evaluation-database-architecture.md). For other database calibration criteria: [calibration-da2-consistency.md](calibration-da2-consistency.md) (DA2), [calibration-da3-data-isolation.md](calibration-da3-data-isolation.md) (DA3), [calibration-da4-distributed-coordination.md](calibration-da4-distributed-coordination.md) (DA4), [calibration-da5-data-scalability.md](calibration-da5-data-scalability.md) (DA5).

## DA1: Data Model Selection & Justification

### Weak (Score 1-2)

```python
# Using a document store (MongoDB) for heavily relational financial data
# No justification recorded anywhere

class TransactionRepository:
    def __init__(self):
        self.db = MongoClient().transactions

    def get_account_summary(self, user_id):
        # Forced to aggregate across deeply nested documents
        # because the relational model was never considered
        pipeline = [
            {"$match": {"userId": user_id}},
            {"$unwind": "$lineItems"},
            {"$lookup": {
                "from": "accounts",
                "localField": "accountId",
                "foreignField": "_id",
                "as": "account",
            }},
            {"$group": {"_id": "$category", "total": {"$sum": "$lineItems.amount"}}},
            # 20 more pipeline stages to simulate relational joins...
        ]
        return list(self.db.aggregate(pipeline))
```

**Why weak**: Severe impedance mismatch — complex financial aggregation with joins forced into a document store aggregation pipeline. No justification for the database choice exists. The data is relational (accounts, transactions, line items with foreign key relationships); the store is not. Score 1 if no rationale exists anywhere; score 2 if the team acknowledges the mismatch but has not addressed it.

### Adequate (Score 3)

```python
# PostgreSQL for an e-commerce platform — reasonable choice
# Brief comment in the README: "We use PostgreSQL for all data"
# No ADR or access pattern analysis

class ProductRepository:
    def search_by_tags(self, tags: list[str]):
        # Awkward: tag-based search with LIKE queries on a relational DB
        # Would be much better in Elasticsearch, but works for now
        conditions = " OR ".join(f"tags LIKE '%{tag}%'" for tag in tags)
        return self.db.execute(f"SELECT * FROM products WHERE {conditions}")

    def get_order_with_items(self, order_id: int):
        # Natural fit: relational join for order + items
        return self.db.execute("""
            SELECT o.*, oi.* FROM orders o
            JOIN order_items oi ON oi.order_id = o.id
            WHERE o.id = %s
        """, order_id)
```

**Why adequate**: PostgreSQL is a reasonable default for e-commerce (orders, products, users are relational). Most access patterns fit well. However, tag-based search is awkward in a relational store — a search engine would be better. The choice was not formally justified; the team landed on a reasonable default without analysis.

### Strong (Score 4-5)

```markdown
# ADR-007: PostgreSQL for order data, Redis for session cache, Elasticsearch for product search

## Context
Orders require ACID transactions (payment + inventory must be atomic).
Session data requires sub-millisecond reads, TTL-based expiry, no persistence guarantee needed.
Product search requires full-text search, faceting, and relevance ranking across 500K products.

## Decision
- PostgreSQL: ACID guarantees for order/payment operations; complex relational joins for reporting
- Redis: Key-value store for session cache; native TTL; no disk persistence needed
- Elasticsearch: Purpose-built for product search; not used for any transactional data

## Access patterns validated
Orders: write-heavy during checkout, read-heavy for history (relational joins needed) -> PostgreSQL
Sessions: write-once, read-many, expire automatically -> Redis
Products: full-text search with faceting -> Elasticsearch

## Integration boundaries
No cross-store joins. Order service reads product IDs (not documents) from search results,
then fetches order-related product data from PostgreSQL.

## Alternatives considered
- MongoDB for everything: rejected because order transactions require ACID guarantees
- PostgreSQL full-text search: rejected because faceting and relevance ranking are limited
```

**Why strong**: Each database type justified against specific access patterns. Integration boundaries defined (no cross-store joins). Alternative models considered and rejected with reasons. New team members can evaluate whether the original constraints still hold.

### Boundary

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| Is the database choice documented with rationale? | No documentation | Brief comment or implicit understanding | ADR with access pattern analysis |
| Does the data model match the access patterns? | Significant mismatch causing workarounds | Mostly matched, one or two awkward patterns | Well-matched, minor mismatches acknowledged |
| If polyglot, are integration boundaries defined? | No coordination strategy | High-level description exists | Explicit boundary rules, no cross-store joins |
