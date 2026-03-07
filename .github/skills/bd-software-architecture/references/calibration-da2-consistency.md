# Calibration: Database Architecture — Consistency & Trade-off Awareness (DA2)

Weak/adequate/strong examples for criterion DA2. Use when uncertain about a score boundary (2 vs 3, 3 vs 4). For full scoring criteria, see [evaluation-database-architecture.md](evaluation-database-architecture.md). For other database calibration criteria: [calibration-da1-data-model.md](calibration-da1-data-model.md) (DA1), [calibration-da3-data-isolation.md](calibration-da3-data-isolation.md) (DA3), [calibration-da4-distributed-coordination.md](calibration-da4-distributed-coordination.md) (DA4), [calibration-da5-data-scalability.md](calibration-da5-data-scalability.md) (DA5).

## DA2: Consistency & Trade-off Awareness

### Weak (Score 1-2)

```python
# Distributed inventory system — no consistency model documented
# Each service commits independently

class OrderService:
    def place_order(self, order):
        self.order_db.save(order)                        # PostgreSQL commit
        self.inventory_service.reduce(order.items)       # HTTP call — may fail
        self.payment_service.charge(order.total)         # HTTP call — may fail
        # If payment fails after inventory reduced: no compensation
        # If network fails between commits: inconsistent state silently
        return {"status": "success"}  # Reported as success regardless
```

**Why weak**: No consistency model. The operation spans three systems with no coordination. Failures produce inconsistent state silently — the order is saved, inventory reduced, but payment may fail leaving orphaned records. The team may believe they have ACID semantics because each individual commit is ACID, but the cross-service operation is not.

### Adequate (Score 3)

```python
class PlaceOrderSaga:
    def execute(self, order):
        try:
            order_id = self.order_repo.save(order)
            self.inventory_service.reserve(order.items, order_id)
            self.payment_service.charge(order.total, order_id)
        except PaymentFailedException:
            self.inventory_service.release(order.items, order_id)
            self.order_repo.cancel(order_id)
        except InventoryUnavailableException:
            self.order_repo.cancel(order_id)
        # Missing: what if compensation itself fails?
        # Missing: network timeout between steps — partial execution not detected
        # Missing: CAP positioning not documented
```

**Why adequate**: Saga pattern recognized and partially implemented. Primary failure scenarios compensated. But compensation itself can fail, network timeouts are not handled, and the consistency model (CAP/PACELC positioning) is not documented. The team understands eventual consistency exists but has not formalized the guarantees.

### Strong (Score 4-5)

```python
class PlaceOrderSaga:
    """
    Orchestrated saga. Idempotency key enforced at every step.
    Each step uses the order_id as idempotency key — re-executing
    the same step with the same key is safe (idempotent).

    CAP positioning: AP during partition (orders can be placed,
    inventory/payment reconcile asynchronously).
    PACELC: Partition -> Availability; Else -> Latency (async).
    Eventual consistency window: < 30 seconds (monitored via metrics).
    """
    def execute(self, order, idempotency_key: str):
        with self.saga_log.step("reserve_inventory", idempotency_key) as step:
            if not step.already_executed:
                self.inventory_service.reserve(order.items, idempotency_key)

        with self.saga_log.step("charge_payment", idempotency_key) as step:
            if not step.already_executed:
                result = self.payment_service.charge(order.total, idempotency_key)
                if not result.success:
                    raise PaymentFailedException(result.reason)

        with self.saga_log.step("confirm_order", idempotency_key) as step:
            if not step.already_executed:
                self.order_repo.confirm(order, idempotency_key)

    def compensate(self, order, idempotency_key: str, failed_at_step: str):
        # Compensation is also idempotent — safe to retry
        if failed_at_step == "charge_payment":
            self.inventory_service.release(order.items, idempotency_key)
        self.order_repo.cancel(order, idempotency_key)
```

**Why strong**: Idempotency enforced at every step (safe to retry). Compensation is also idempotent. CAP and PACELC positioning documented in code comments. Eventual consistency window is defined (< 30 seconds) and monitored. A new team member can immediately understand the consistency guarantees.

### Boundary

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| Are consistency requirements documented? | Not at all | Implicitly understood by the team | Explicitly stated per data domain |
| Are compensation strategies defined? | None | Primary failure cases only | All failure scenarios including compensation failures |
| Is idempotency enforced for distributed operations? | No | Partially (some steps) | Yes, at every step including compensation |
