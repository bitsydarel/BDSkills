# Architecture Style Mapping: Event-Driven / CQRS / Event Sourcing

Maps evaluation criteria to event-driven equivalents. Only criteria that differ from Clean Architecture defaults are listed — omitted criteria (D4, D5, S1-S4, B4, Q2-Q4) apply identically.

## Foundation

Three core principles — **Dependency Rule** (dependencies point inward), **Separation of Concerns** (each layer has a distinct responsibility), **Independence** (business rules exist without frameworks/UI/database) — are non-negotiable regardless of architecture style. SOLID principles apply universally. Event-driven architectures separate command, query, and event-handling concerns. "Layers" become "sides" and "flows" but the principles are identical.

---

## D1: Layer Separation & Dependency Direction

**Dependency Rule + SRP**: Command side, Query side, and Event handling are separate concerns (SRP). Command handlers depend on domain aggregates, not on projections or read models. Query handlers depend on read models, not on command-side objects. Dependencies flow inward: handlers depend on domain, domain depends on nothing.

**Violation**: A handler that reads a projection to make a command-side decision (Separation of Concerns violation). An aggregate that imports the event store client (Dependency Rule violation).

## D2: Abstraction at Boundaries

**DIP**: Event store interface, message bus interface, projection store interface. Concrete implementations (Kafka, EventStoreDB, PostgreSQL) behind abstractions. Domain aggregates depend on event abstractions, not on specific infrastructure.

**Violation**: Aggregate directly calls Kafka producer. Command handler instantiates a concrete EventStoreDB client (DIP violation).

## D3: Framework Independence

**Independence**: Aggregates and domain logic should process commands and emit events as pure functions: `(state, command) → events`. No event store, message bus, or framework imports in domain code.

- **Score 5**: Domain logic is `(state, command) → events` — pure, testable, no infrastructure.
- **Score 3**: Domain logic mostly pure but some aggregates reference event store directly.
- **Score 1**: Domain logic interleaved with event store operations and message bus calls.

## C2: Repository vs Service Clarity

**SRP + ISP**: Event store (persists events), Projection (builds read models), Saga/Process Manager (coordinates workflows) — each is a distinct component type with a single responsibility. Mixing these responsibilities violates SRP.

- Event store = persistence of state changes
- Projection = derived read model (unique to event-driven)
- Saga = workflow coordination

## C3: Use Case Design & Composition

**SRP + OCP**: Sagas coordinate multiple aggregates across a workflow. Choreography lets aggregates react to each other's events without a central coordinator. Composition should be explicit, traceable, and shallow — same principles as use case composition. A saga that grows to orchestrate dozens of steps may violate SRP.

## B1: Data Flow Traceability

**Separation of Concerns**: Command → Command Handler → Aggregate → Events → Event Store → Projections → Read Model. Write path and read path are independently traceable. Event chains should be followable: which event triggers which handler?

**Violation**: Events trigger handlers that trigger events in undocumented chains. No way to trace a command to its eventual read model updates (Separation of Concerns breakdown).

## B3: Error Translation & Propagation

**Separation of Concerns + DIP**: Within an aggregate, domain exceptions are appropriate. Across aggregates, errors become compensation events. Dead letter queues capture unprocessable events. Infrastructure errors (Kafka timeouts, serialization failures) translated at the adapter boundary.

- **Score 5**: Aggregate-internal errors use domain exceptions. Cross-aggregate failures use compensation events. Dead letter queues monitored. Error lineage traceable through correlation IDs.
- **Score 3**: Some error translation, but compensation events inconsistent.
- **Score 1**: Infrastructure errors bubble up as raw exceptions. No compensation events. Failed events disappear.

## Q1: Testability

**Consequence of all three principles + DIP**: Aggregates tested as `(state, command) → events`. Projections tested as `(events) → read model`. Sagas tested as `(events) → commands`. All testable with in-memory implementations — no infrastructure needed.

- **Score 5**: All components testable with in-memory implementations. Aggregate tests are pure function tests. No infrastructure required.
- **Score 3**: Most tests use in-memory stores but some require running message bus.
- **Score 1**: Tests require full event infrastructure (Kafka, EventStoreDB) running.
