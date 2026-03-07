# Architecture styles

Reference for major architecture styles and how they map to the skill's 5 evaluation lenses. Load this file when the system under review follows a specific style, or when evaluating which style fits a given context.

## Hexagonal Architecture (Ports & Adapters)

**Origin**: Alistair Cockburn (2005). The application sits at the center, surrounded by ports (interfaces defining how the application interacts with the outside world) and adapters (implementations that connect ports to real infrastructure).

**Key principles**:
- The application is unaware of what drives it (driving adapters: UI, CLI, API) or what it drives (driven adapters: DB, API clients, file systems)
- Ports are application-owned interfaces; adapters implement ports or call ports
- Driving ports: how external actors interact with the app (e.g., `OrderService` interface)
- Driven ports: how the app interacts with external systems (e.g., `OrderRepository` interface)

**Mapping to evaluation lenses**:
- D1/D2: Ports = abstraction at boundaries. Adapters are the outermost layer
- B2: Data transformation happens in adapters (DTO ↔ domain mapping)
- Q1: Application testable by replacing adapters with test doubles through ports
- S1: Port/adapter structure can be physically enforced through module boundaries

**Strengths**: Clear separation of concerns, highly testable, symmetric treatment of driving and driven sides.
**Weaknesses**: Can feel over-engineered for simple CRUD apps. Port/adapter naming can confuse teams unfamiliar with the pattern.

**When to use**: Systems with multiple entry points (API + CLI + event consumer) or multiple output targets (SQL + NoSQL + external APIs). Systems where testability is critical.

## Onion Architecture

**Origin**: Jeffrey Palermo (2008). Concentric layers with dependencies pointing inward. Structurally identical to Clean Architecture with different naming.

**Layer mapping**:

| Onion | Clean Architecture | Responsibility |
|-------|-------------------|---------------|
| Domain Model | Domain Models | Core business entities |
| Domain Services | Use Cases | Business operations |
| Application Services | Repositories/Services | Coordination, capability wrapping |
| Infrastructure | Data Sources | Frameworks, drivers, external systems |
| UI | Presentation | User interface, API controllers |

**Key difference from Clean Architecture**: Onion Architecture emphasizes that the domain model is at the center and everything else is infrastructure. Clean Architecture adds more specific component type distinctions (repository vs service, use case vs domain service).

## CQRS (Command Query Responsibility Segregation)

**Origin**: Greg Young, based on Bertrand Meyer's CQS principle. Separate the read model (queries) from the write model (commands). Each can have its own data model, storage, and optimization strategy.

**Key principles**:
- Commands: change state, return void or acknowledgment. Validated strictly.
- Queries: read state, return data. Optimized for read performance.
- Read and write models can differ: write model is normalized for integrity, read model is denormalized for performance.

**Mapping to evaluation lenses**:
- C1: Use cases naturally split into command handlers and query handlers — clear SRP
- C3: Commands and queries are distinct use case types with different composition rules
- B1: Data flow splits into command flow and query flow — both should be traceable
- Q3: Read side can scale independently from write side

**When to use**: Systems with significantly different read and write patterns. High-read, low-write systems. Systems needing different read and write optimization strategies.
**When to avoid**: Simple CRUD where read/write complexity is symmetric. Adding CQRS to a simple system is the Architecture Astronaut anti-pattern.

## Event-Driven Architecture

**Key patterns**:
- **Event Sourcing**: Store events (facts) instead of current state. Rebuild state by replaying events.
- **Pub/Sub**: Components publish events; interested components subscribe. Loose coupling through asynchronous messaging.
- **Saga/Choreography**: Multi-step business processes coordinated through events rather than central orchestration.

**Mapping to evaluation lenses**:
- D4: Event-driven naturally creates a DAG — publishers do not know subscribers
- B3: Error handling becomes event-based — compensation events instead of exceptions
- B4: Features communicate through events, not direct imports — strong isolation
- Q3: Asynchronous processing enables scaling and resilience
- Q4: Event streams provide built-in audit trail and observability

**When to use**: Distributed systems needing loose coupling. Systems with complex business processes spanning multiple domains. Systems needing strong audit trails.
**When to avoid**: Simple synchronous workflows. Systems where eventual consistency is unacceptable. Teams unfamiliar with async debugging.

## Microservices

**Key principles**:
- Each service owns its domain, data, and deployment lifecycle
- Services communicate through well-defined APIs (REST, gRPC, events)
- Database-per-service — no shared database access
- Independent deployment — deploy one service without coordinating others

**Mapping to evaluation lenses**:
- D4: Service dependency graph must be a DAG — no circular service calls
- D5: Each service is an external dependency to others — managed through APIs
- B4: Service boundary = feature isolation boundary (strongest possible)
- Q2: Changes contained to one service — blast radius = one deployment
- Q3: Services scale independently based on their load profile

**When to use**: Large organizations with multiple teams needing independent deployment. Systems with components requiring different scaling strategies.
**When to avoid**: Small teams (<10 developers). Systems where the domain boundaries are unclear. Early-stage products where the domain model is still evolving. See anti-pattern: Distributed Monolith in [anti-patterns-dependency.md](anti-patterns-dependency.md).

## Modular Monolith

**Key principles**:
- Single deployable with strong internal module boundaries
- Modules communicate through defined interfaces (public APIs)
- Each module owns its data (separate tables/schemas, or at least separate repositories)
- Module boundaries enforced by build system or lint rules

**Mapping to evaluation lenses**:
- C4: Module public API = feature public API (core concept)
- B4: Module boundaries = feature isolation boundaries
- D4: Module dependency graph must be acyclic
- S1: Module visibility settings enforce boundaries at build time
- Q2: Changes contained to one module while sharing the deployment pipeline

**When to use**: Teams that need strong boundaries without operational complexity of microservices. Systems where the domain model is well-understood. Organizations with 1-5 teams working on the same product.
**When to avoid**: When different modules need fundamentally different scaling strategies. When organizational boundaries demand independent deployment.

## Netflix Resilience Patterns

Patterns for building resilient distributed systems, applicable to Q3 (Scalability & Performance) and Q4 (Observability):

| Pattern | What It Does | When to Use | Lens |
|---------|-------------|-------------|------|
| **Circuit Breaker** | Stops calling a failing service; returns fallback response | External service dependencies | Q3, Q4 |
| **Bulkhead** | Isolates failure to one component; prevents cascade | Multiple independent external dependencies | Q3 |
| **Fallback** | Provides degraded but functional response when primary fails | User-facing features with external dependencies | Q3 |
| **Timeout** | Limits wait time for external calls; prevents thread exhaustion | Every external dependency call | Q3 |
| **Retry with Backoff** | Retries transient failures with exponential delay | Transient network/service failures | Q3 |

**Key insight**: These patterns are architecture-level decisions, not code-level patterns. The decision to implement circuit breakers affects data flow (B3: error translation includes fallback responses), component design (C2: resilience logic in services), and observability (Q4: circuit state must be monitored).

## Style comparison by lens

| Style | D (Dependencies) | C (Components) | B (Boundaries) | Q (Quality) | S (Structure) |
|-------|:-:|:-:|:-:|:-:|:-:|
| Clean Architecture | ★★★★★ | ★★★★ | ★★★★ | ★★★★ | ★★★ |
| Hexagonal | ★★★★★ | ★★★ | ★★★★★ | ★★★★★ | ★★★ |
| CQRS | ★★★ | ★★★★★ | ★★★ | ★★★★ | ★★★ |
| Event-Driven | ★★★★ | ★★★ | ★★★★★ | ★★★★ | ★★ |
| Microservices | ★★★★ | ★★★ | ★★★★★ | ★★★★★ | ★★★★ |
| Modular Monolith | ★★★★ | ★★★★ | ★★★★ | ★★★ | ★★★★★ |

★ = weak, ★★★ = adequate, ★★★★★ = strong. Ratings reflect the style's natural strength, not a universal score.
