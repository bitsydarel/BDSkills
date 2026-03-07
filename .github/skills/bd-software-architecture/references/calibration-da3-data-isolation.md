# Calibration: Database Architecture — Data Isolation & Ownership (DA3)

Weak/adequate/strong examples for criterion DA3. Use when uncertain about a score boundary (2 vs 3, 3 vs 4). For full scoring criteria, see [evaluation-database-architecture.md](evaluation-database-architecture.md). For other database calibration criteria: [calibration-da1-data-model.md](calibration-da1-data-model.md) (DA1), [calibration-da2-consistency.md](calibration-da2-consistency.md) (DA2), [calibration-da4-distributed-coordination.md](calibration-da4-distributed-coordination.md) (DA4), [calibration-da5-data-scalability.md](calibration-da5-data-scalability.md) (DA5).

## DA3: Data Isolation & Ownership

### Weak (Score 1-2)

```python
# In user_service/repositories/profile_repo.py
class ProfileRepository:
    def get_user_with_orders(self, user_id):
        # Directly queries the orders table — owned by order_service
        return self.db.execute("""
            SELECT u.*, o.total, o.status
            FROM users u
            JOIN orders o ON o.user_id = u.id
            WHERE u.id = %s
        """, user_id)

    def get_user_spending_stats(self, user_id):
        # Also reads from payments table — owned by payment_service
        return self.db.execute("""
            SELECT SUM(p.amount) as total_spent
            FROM payments p
            WHERE p.user_id = %s AND p.status = 'completed'
        """, user_id)
```

**Why weak**: `user_service` directly queries `orders` and `payments` tables, which are owned by `order_service` and `payment_service` respectively. A schema change in `orders` breaks `user_service` without coordination. No data ownership boundary exists — any service can query any table.

### Adequate (Score 3)

```python
# Data ownership is conceptually understood but not enforced
# user_service reads from orders table "for performance" but doesn't write to it

class ProfileRepository:
    def get_user_with_orders(self, user_id):
        user = self.user_db.execute("SELECT * FROM users WHERE id = %s", user_id)
        # Direct read from orders table — not through order_service API
        # Team knows this is "not ideal" but it's faster than an API call
        orders = self.shared_db.execute(
            "SELECT total, status FROM orders WHERE user_id = %s", user_id
        )
        return UserProfile(user=user, recent_orders=orders)
```

**Why adequate**: No shared writes — user_service only reads from orders. The team understands the coupling ("not ideal"). But the direct read creates implicit coupling: a schema change in orders requires updating user_service. Not formally documented; the boundary is aspirational, not enforced.

### Strong (Score 4-5)

```python
# In user_service/repositories/profile_repo.py
class ProfileRepository:
    def __init__(self, user_db, order_service_client: OrderServiceClient):
        self.user_db = user_db
        self.order_service = order_service_client  # Goes through order_service's API

    def get_user_profile(self, user_id):
        user = self.user_db.execute("SELECT * FROM users WHERE id = %s", user_id)
        # Fetches order summary through the API, not the database
        order_summary = self.order_service.get_summary_for_user(user_id)
        return UserProfile(user=user, order_summary=order_summary)
```

**Why strong**: Each service reads only its own tables directly. Cross-service data access goes through the owning service's API. A schema change in `orders` only requires updating `order_service` — `user_service` is insulated by the API contract. Data ownership is clear and enforced.

### Boundary

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| Does each service write only to its own tables? | Multiple services write to shared tables | No shared writes but shared reads exist | Each service writes AND reads only its own tables (cross-service via API) |
| Are schema migrations owned by a single team? | Schema changes require multi-team coordination | Mostly single-team but some shared schemas | Every schema has a single owner |
| Is data ownership documented? | No concept of ownership | Understood informally | Formally documented with enforcement |
