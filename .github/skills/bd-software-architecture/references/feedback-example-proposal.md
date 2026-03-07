# Feedback example: Proposal review

A complete scored example reviewing a "Payment Processing Feature" proposal. Demonstrates proper use of the feedback template for proposal reviews.

---

## Architecture Review: Payment Processing Feature

**Review mode**: Proposal
**System complexity**: Standard
**Technology stack**: Python / Django / Celery / Stripe API
**Reviewer note**: This review evaluates the proposed architecture. No implementation exists yet.

---

### Lens 1: Dependency Architecture — 18/25

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| D1: Layer Separation | 4 | Proposal shows clear layer separation: views → use cases → repositories → data sources. Dependency direction correct. Minor gap: proposal mentions "service layer" without clarifying its position relative to use cases. |
| D2: Abstraction at Boundaries | 4 | Repository interfaces defined in the domain layer. Stripe dependency wrapped behind `PaymentGateway` interface. Deducted for not specifying how webhook handlers interact with use cases. |
| D3: Framework Independence | 3 | Domain entities described as plain Python classes. However, proposal references Django signals for payment status updates — this couples domain events to Django's signal mechanism. |
| D4: Dependency Graph Acyclicity | 4 | Feature dependency diagram shows DAG: `payments → orders (read-only)`, `notifications → payments (event-based)`. No cycles detected. |
| D5: External Dependency Management | 3 | Stripe wrapped behind interface. However, Celery task definitions are placed in the domain layer proposal — Celery is infrastructure and should be in the data/infrastructure layer. |

### Lens 2: Component Design — 17/25

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| C1: Single Responsibility | 4 | Use cases well-scoped: `ProcessPaymentUseCase`, `RefundPaymentUseCase`, `HandleWebhookUseCase`. Each handles one business intention. |
| C2: Repository vs Service Clarity | 3 | `PaymentRepository` for persistence and `PaymentGateway` for Stripe are properly separated. However, a `PaymentManager` class is proposed with unclear responsibility — appears to mix orchestration with payment state management. |
| C3: Use Case Composition | 3 | `ProcessPaymentUseCase` calls `PaymentGateway` then `PaymentRepository`. Shallow composition. However, `HandleWebhookUseCase` is described as calling `ProcessPaymentUseCase` — this creates a use-case-calling-use-case pattern that should be clarified. |
| C4: Public API & Encapsulation | 4 | Proposal defines a clear public API: `PaymentService` (use case facade), `Payment` (domain entity), `PaymentStatus` (enum). Internal components (repository, gateway, DTOs) marked as private. |
| C5: Domain Model Purity | 3 | `Payment` entity is a plain dataclass. However, `PaymentStatus` transitions are described using Django FSM library annotations — framework in the domain model. |

### Lens 3: Data Flow & Boundaries — 13/20

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| B1: Data Flow Traceability | 4 | Main flow documented: API request → view → use case → gateway (Stripe) → repository (save) → response. Webhook flow: Stripe → webhook view → use case → repository. Both traceable. |
| B2: Data Transformation | 3 | Proposal mentions `StripePaymentDto` for Stripe API responses mapped to domain `Payment`. However, no mention of how Django model instances relate to domain entities — risk of ORM model leaking through layers. |
| B3: Error Translation | 3 | Proposal handles `StripeError` in the gateway and translates to `PaymentFailedException`. However, no mention of how Celery task failures translate to domain errors — what happens when a background payment task fails? |
| B4: Feature Module Isolation | 3 | Payments feature communicates with Orders through an `OrderReader` interface. However, the notification mechanism uses Django signals — any feature can listen to payment signals, creating implicit coupling. |

### Lens 4: Quality Attributes — 13/20

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| Q1: Testability | 4 | Use cases testable with mock `PaymentGateway` and `PaymentRepository`. Domain entities are pure dataclasses. Webhook handling testable with mock requests. |
| Q2: Modifiability | 3 | Replacing Stripe with another payment provider requires implementing `PaymentGateway` — good. However, changing the async mechanism from Celery to another system would require changes in the domain layer due to Celery task definitions there. |
| Q3: Scalability & Performance | 3 | Async payment processing via Celery handles load spikes. However, no mention of idempotency for webhook handling — Stripe sends duplicate webhooks, and without idempotency the system may process payments twice. |
| Q4: Observability | 3 | Proposal mentions logging payment state transitions. No mention of distributed tracing across the async boundary (Celery task → webhook → use case). Payment reconciliation observability not addressed. |

### Lens 5: Structural Integrity — 12/20

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| S1: Physical Enforcement | 3 | Proposal shows directory structure with layer separation. No mention of lint rules or CI checks to enforce dependency direction. |
| S2: Naming Consistency | 4 | Consistent naming: `*UseCase`, `*Repository`, `*Gateway`, `*Dto`. Clear role identification from names. |
| S3: Architecture Decision Records | 2 | Proposal describes decisions (why Celery for async, why Stripe gateway pattern) in the design doc body. No structured ADR format. Why not a direct synchronous flow? Why not a message queue instead of Celery? Alternatives not formally evaluated. |
| S4: Evolutionary Readiness | 3 | Adding a new payment provider follows the `PaymentGateway` interface pattern. However, adding a new payment flow (subscriptions, installments) would require modifying `ProcessPaymentUseCase` — no extension point for payment flow types. |

### Lens 6: Database Architecture — 15/25

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| DA1: Data Model Selection | 3 | Proposal uses Django ORM (presumably relational/PostgreSQL) for payment data. Relational is appropriate for payment records requiring ACID compliance. However, the proposal does not explicitly justify the database choice or document access patterns — it's assumed, not designed. |
| DA2: Consistency & Trade-off Awareness | 2 | Payment processing requires strict ACID for charge-then-record flows. Celery introduces async processing for webhooks and status updates — when a payment status changes via Stripe webhook, there is a window of inconsistency between the gateway state and the local database. No documentation of consistency guarantees for this async path. For a payment system, this is a significant gap. |
| DA3: Data Isolation & Ownership | 3 | Payments feature accesses Orders through an `OrderReader` interface (read-only) — good boundary awareness. However, using Django ORM likely means shared database access. No mention of schema-level isolation between payments and orders data. |
| DA4: Distributed Data Coordination | N/A (5) | Single database system. Celery handles async processing but not cross-database coordination. Treated as 5 for scoring. |
| DA5: Data Scalability Strategy | 2 | No mention of indexing strategy for payment records, data retention policy (payment records grow indefinitely), connection pooling, or growth projections. Payment tables will grow continuously — no plan for managing this growth. |

---

### Overall Score

| Lens | Score | Max | % |
|------|:-----:|:---:|:-:|
| 1. Dependency Architecture | 18 | 25 | 72% |
| 2. Component Design | 17 | 25 | 68% |
| 3. Data Flow & Boundaries | 13 | 20 | 65% |
| 4. Quality Attributes | 13 | 20 | 65% |
| 5. Structural Integrity | 12 | 20 | 60% |
| 6. Database Architecture | 15 | 25 | 60% |
| **Total** | **88** | **135** | **65%** |

**Verdict**: **Proceed with Conditions**

No lens below 40% (weakest-link rule not triggered). No criterion scored 1 (critical override not triggered). Total 65% is above the 60% (81/135) threshold. However, multiple criteria at score 2-3 indicate significant areas for improvement before implementation — particularly database consistency guarantees (DA2) and scalability planning (DA5) for a payment system.

---

### Architecture Proposal

**Proposed adjustments to the architecture**:

1. **Move Celery task definitions out of domain layer** → Place in infrastructure/data layer. Use cases should trigger async operations through an abstraction (e.g., `AsyncTaskRunner` interface), not through Celery directly.

2. **Replace Django signals with explicit event contracts** → Define a `PaymentEventPublisher` interface in the domain. The infrastructure layer implements it. This makes cross-feature communication explicit and testable.

3. **Remove Django FSM from domain models** → Implement state transitions as plain domain logic. The `Payment` entity can have a `transition_to(status)` method that validates transitions without framework annotations.

---

### Issues

**Major**:
1. **[D3/C5] Django FSM in domain model** — Payment status transitions use Django FSM annotations, coupling domain logic to Django. *Fix*: Implement state machine as plain Python logic in the domain entity.
2. **[D5/Q2] Celery tasks in domain layer** — Celery task definitions in the domain create infrastructure coupling. *Fix*: Define an `AsyncTaskRunner` interface; implement with Celery in infrastructure.
3. **[B4] Django signals for cross-feature events** — Implicit coupling through Django signals. Any code can listen. *Fix*: Explicit event publisher interface with registered subscribers.
4. **[S3] Missing structured ADRs** — Design decisions explained in prose but alternatives not formally evaluated. *Fix*: Document key decisions (async strategy, payment gateway abstraction, state management) as ADRs.

**Minor**:
1. **[C2] Ambiguous PaymentManager** — Unclear responsibility. *Fix*: Rename to specific role or split into use case + service.
2. **[Q3] Missing webhook idempotency** — Duplicate webhook handling not addressed. *Fix*: Document idempotency strategy (idempotency key check before processing).
3. **[DA1] Database choice not explicitly justified** — Relational database assumed but not documented against access patterns. *Fix*: Document why relational (ACID for payment integrity) and access patterns (transaction lookup by ID, status queries, date-range reporting).
4. **[DA2] Async payment consistency undocumented** — Celery introduces eventual consistency for webhook-driven status updates without documented guarantees. *Fix*: Document the consistency window, define what "source of truth" is during async processing, add reconciliation strategy.
5. **[DA5] No data growth strategy** — Payment records grow indefinitely with no retention, archival, or indexing plan. *Fix*: Define indexing strategy, data retention policy, and connection pooling requirements.

---

### Strengths

1. **Clean dependency direction**: Layer separation is well-conceived with inward dependencies and repository interfaces in the domain.
2. **Stripe abstraction**: Payment gateway behind an interface enables provider switching — strong D5 and Q2.
3. **Well-scoped use cases**: Each use case represents a single business intention — strong C1.
4. **Traceable data flow**: Both synchronous and webhook flows are documented and traceable — strong B1.

---

### Top Recommendation

**Move all infrastructure concerns (Celery, Django signals, Django FSM) out of the domain layer.** This single change addresses the three Major findings (D3, D5, B4) and lifts scores across Dependency Architecture, Component Design, and Data Flow lenses. The domain should be pure Python — testable, portable, and framework-agnostic.

---

### Key Question

> "If Django and Celery were replaced tomorrow, which files in the payments feature would need to change?"

The answer should be: only the data/infrastructure layer files. If the answer includes domain entities or use cases, the architecture has framework coupling that should be resolved before implementation.
