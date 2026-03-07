# Calibration: Database Architecture — Distributed Data Coordination (DA4)

Weak/adequate/strong examples for criterion DA4. Use when uncertain about a score boundary (2 vs 3, 3 vs 4). For full scoring criteria, see [evaluation-database-architecture.md](evaluation-database-architecture.md). For other database calibration criteria: [calibration-da1-data-model.md](calibration-da1-data-model.md) (DA1), [calibration-da2-consistency.md](calibration-da2-consistency.md) (DA2), [calibration-da3-data-isolation.md](calibration-da3-data-isolation.md) (DA3), [calibration-da5-data-scalability.md](calibration-da5-data-scalability.md) (DA5).

## DA4: Distributed Data Coordination

### Weak (Score 1-2)

```python
# XA distributed transaction spanning two databases
with xa_transaction(order_db, inventory_db) as txn:
    order_db.execute("INSERT INTO orders ...", txn)
    inventory_db.execute("UPDATE inventory SET qty = qty - 1 ...", txn)
    txn.prepare()  # 2-phase commit — distributed transaction
    txn.commit()
# If coordinator crashes after prepare() but before commit(),
# both databases are locked until recovery
```

**Why weak**: Two-phase commit creates a blocking coordinator. If the coordinator crashes after `prepare()` but before `commit()`, both databases are locked until recovery. Under network partition, this sacrifices availability for consistency — creating a distributed monolith. The system cannot scale the order and inventory databases independently.

### Adequate (Score 3)

```python
class PlaceOrderSaga:
    def execute(self, order):
        try:
            self.order_repo.create(order)
            self.inventory_client.reserve(order.items)
            self.payment_client.charge(order.total)
        except PaymentError:
            self.inventory_client.release(order.items)
            self.order_repo.cancel(order.id)
        except InventoryError:
            self.order_repo.cancel(order.id)
        # Primary compensation works, but:
        # - What if inventory release fails?
        # - No idempotency keys — retry may double-charge
        # - No saga log — coordinator crash loses state
```

**Why adequate**: Saga pattern implemented for the happy path and primary failure cases. No 2PC, which is good. But compensation is not idempotent (retrying could double-charge), there is no saga log (coordinator crash loses state), and edge case failures during compensation are unhandled.

### Strong (Score 4-5)

```python
class PlaceOrderSaga:
    """Orchestrated saga with persistent saga log and idempotent steps."""

    def execute(self, order_id: str):
        saga = self.saga_store.create_or_resume(order_id)

        if saga.step_not_completed("reserve"):
            self.inventory_client.reserve(
                order.items, idempotency_key=f"{order_id}-reserve"
            )
            saga.mark_completed("reserve")

        if saga.step_not_completed("charge"):
            result = self.payment_client.charge(
                order.total, idempotency_key=f"{order_id}-charge"
            )
            if not result.success:
                self._compensate(saga, order_id)
                return
            saga.mark_completed("charge")

        if saga.step_not_completed("confirm"):
            self.order_repo.confirm(order_id)
            saga.mark_completed("confirm")

    def _compensate(self, saga, order_id: str):
        if saga.step_completed("reserve"):
            self.inventory_client.release(
                order.items, idempotency_key=f"{order_id}-release"
            )
        self.order_repo.cancel(order_id)
        saga.mark_compensated()
```

**Why strong**: Saga state persisted in a saga store — survives coordinator crash. Every step uses idempotency keys — safe to retry. Compensation is also idempotent. The saga can be resumed from any point after a crash. No distributed transactions.

### Boundary

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| Are distributed transactions (2PC/XA) present? | Yes, actively used | No 2PC, but tight synchronous coordination | No 2PC; saga or event-based coordination |
| Are compensation steps defined for failures? | None or incomplete | Primary failure cases handled | All failure cases including compensation failures |
| Is saga state persisted and resumable? | No persistence | Partial — some state tracked | Full saga log with resume capability |
