# Calibration: Quality Attributes (Lens 4)

Weak/adequate/strong examples for criteria Q1-Q4. Use when uncertain about a score boundary. For full scoring criteria, see [evaluation-quality-attributes.md](evaluation-quality-attributes.md).

---

## Q1: Testability

### Weak (Score 1-2)

```python
class ProcessPaymentUseCase:
    def execute(self, order_id):
        db = PostgresDB("postgres://prod/orders")    # Hardcoded DB connection
        order = db.query("SELECT * FROM orders WHERE id = %s", order_id)
        stripe = StripeClient(os.environ["STRIPE_KEY"])  # Real payment provider
        stripe.charge(order["amount"])
        db.execute("UPDATE orders SET status = 'paid' WHERE id = %s", order_id)
```

**Why weak**: Testing this use case charges a real credit card and modifies a real database. No DI, no interfaces, no way to isolate. Test setup requires full infrastructure.

### Adequate (Score 3)

```python
class ProcessPaymentUseCase:
    def __init__(self, db: PostgresDB, stripe: StripeClient):
        self.db = db        # Injected but concrete types
        self.stripe = stripe

    def execute(self, order_id):
        order = self.db.query("SELECT * FROM orders WHERE id = %s", order_id)
        self.stripe.charge(order["amount"])

# Test: requires mocking concrete PostgresDB and StripeClient — fragile
```

**Why adequate**: DI present so you can pass test instances, but dependencies are concrete types. Mocking requires matching the concrete class interface exactly. Database query format leaks into tests.

### Strong (Score 4-5)

```python
class ProcessPaymentUseCase:
    def __init__(self, order_repo: OrderRepository, payment_service: PaymentService):
        self.order_repo = order_repo      # Interface
        self.payment_service = payment_service  # Interface

    def execute(self, order_id: OrderId) -> PaymentResult:
        order = self.order_repo.get(order_id)
        result = self.payment_service.charge(order.total)
        if result.success:
            order.mark_paid()
            self.order_repo.save(order)
        return result

# Test: simple fakes, no infrastructure, runs in milliseconds
def test_successful_payment():
    repo = FakeOrderRepository([Order(id=1, total=Money(100))])
    payment = FakePaymentService(always_succeeds=True)
    use_case = ProcessPaymentUseCase(repo, payment)
    result = use_case.execute(OrderId(1))
    assert result.success
    assert repo.saved_orders[0].is_paid
```

---

## Q2: Modifiability & Change Isolation

### Weak (Score 1-2)

**Scenario**: Switch from REST API to GraphQL for user data.

Files changed: `user_controller.py`, `user_use_case.py`, `user_repository.py`, `user_service.py`, `user_tests.py`, `order_use_case.py` (imports user DTO types), `dashboard_view.py` (references API response format).

**Why weak**: 7+ files across 4 layers and 2 features. The data source format leaked everywhere. Blast radius is unpredictable.

### Strong (Score 4-5)

**Same scenario**: Switch from REST API to GraphQL for user data.

Files changed: `graphql_user_data_source.py` (new file), `di_config.py` (swap binding).

**Why strong**: Only the data source implementation and DI wiring change. All consumers depend on the interface, which stays the same. Blast radius: 2 files, both in the data source/config layer.

### Boundary

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| Files changed for data source swap | 7+ across layers | 3-5, mostly in data layer | 1-2, only adapter + DI config |
| Can you predict which files will change? | No | Mostly | Yes, precisely |
| Do changes cascade to other features? | Yes | Sometimes | Never |

---

## Q3: Scalability & Performance Design

### Weak (Score 1-2)

- No performance targets for any operation
- All external calls synchronous with no timeouts
- Single database for all features, no connection pooling
- No caching anywhere
- "Performance is fine" based on developer laptop testing

### Adequate (Score 3)

- Response time targets exist for homepage load
- Database connection pooling configured
- Some caching for expensive queries
- No load testing, no resilience patterns for external services
- Performance is "probably fine" based on staging testing

### Strong (Score 4-5)

- Performance budgets: p99 < 200ms for critical paths, p95 < 100ms
- Circuit breakers on all external service calls with fallback responses
- Caching strategy documented: L1 (in-memory, 30s TTL), L2 (Redis, 5min TTL)
- Load testing validates architecture under 3x expected peak
- Architecture supports scaling the bottleneck independently (database read replicas, service horizontal scaling)
- Timeouts configured for every external dependency

---

## Q4: Observability & Debuggability

### Weak (Score 1-2)

```python
# No logging, no tracing, no monitoring
class ProcessOrderUseCase:
    def execute(self, order):
        try:
            self.order_repo.save(order)
            self.payment_service.charge(order.total)
        except Exception:
            pass  # Silently swallowed — no log, no alert, no trace
```

**Why weak**: When this fails in production, the team discovers it from user complaints. No telemetry, no way to diagnose without reproducing locally.

### Adequate (Score 3)

```python
import logging
logger = logging.getLogger(__name__)

class ProcessOrderUseCase:
    def execute(self, order):
        logger.info(f"Processing order {order.id}")
        try:
            self.order_repo.save(order)
            self.payment_service.charge(order.total)
        except Exception as e:
            logger.error(f"Order failed: {e}")  # Logged but no context
            raise
```

**Why adequate**: Logging present but unstructured. No correlation IDs, no boundary-crossing traces. Can identify that a failure occurred but not always trace it across layers.

### Strong (Score 4-5)

```python
class ProcessOrderUseCase:
    def execute(self, order, trace_id: str):
        self.logger.info("order.processing.start",
            order_id=order.id, trace_id=trace_id, amount=order.total)
        try:
            self.order_repo.save(order)
            self.logger.info("order.saved", order_id=order.id, trace_id=trace_id)
            result = self.payment_service.charge(order.total)
            self.logger.info("payment.completed",
                order_id=order.id, trace_id=trace_id, status=result.status)
        except DomainException as e:
            self.logger.error("order.processing.failed",
                order_id=order.id, trace_id=trace_id, error=str(e), error_type=type(e).__name__)
            raise
```

**Why strong**: Structured logging with trace IDs at every boundary crossing. Can trace a request from API entry through use case to data source and back. Dashboards show per-layer error rates and latency.
