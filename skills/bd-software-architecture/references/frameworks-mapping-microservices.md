# Architecture Style Mapping: Microservices

Maps evaluation criteria to microservice equivalents. Only criteria that differ from Clean Architecture defaults are listed — omitted criteria (D2, D3, S1-S4, C1, C3, C5, B1-B3, Q1, Q3) apply identically.

## Foundation

Three core principles — **Dependency Rule** (dependencies point inward), **Separation of Concerns** (each layer has a distinct responsibility), **Independence** (business rules exist without frameworks/UI/database) — are non-negotiable regardless of architecture style. SOLID principles apply universally. Within each microservice, any internal architecture style can apply (Clean, MVC, hexagonal) — use the matching mapping. The criteria below address **inter-service** concerns unique to microservices. SOLID applies at the service level too: each service has a single responsibility (SRP), service contracts are focused (ISP), services depend on contract abstractions not implementations (DIP).

---

## D1: Layer Separation & Dependency Direction

**Dependency Rule**: Score dependency direction **within each service** using the service's internal architecture style. Inter-service dependency direction is evaluated through D4 (acyclicity) and D5 (external dependency management). Each service is an independent unit with its own internal layer structure.

## D4: Dependency Graph Acyclicity

**Dependency Rule at service level**: The service dependency graph must be a DAG. No circular service calls (Service A → Service B → Service A). Cycles between services indicate incorrect domain boundaries — a violation of SRP at the service level.

- **Score 5**: Service dependency graph is a strict DAG. Async events break potential cycles. Each service callable independently.
- **Score 3**: Mostly acyclic but one or two circular call paths exist for pragmatic reasons.
- **Score 1**: Services call each other in complex cycles. Cannot deploy or test any service independently.

## D5: External Dependency Management

**DIP at service level**: Other services ARE external dependencies. Each service-to-service interaction requires a defined contract (OpenAPI, protobuf, AsyncAPI). Services depend on the contract (abstraction), not on the other service's implementation (DIP). Vendor and service dependencies wrapped behind abstractions.

**Violation**: Service A imports Service B's internal types. Changing Service B's implementation breaks Service A (DIP violation at service level).

## C2: Repository vs Service Clarity

**SRP**: Within each service, the standard distinction applies. Across services: API client adapters (data-oriented — fetching from another service) vs integration services (capability-oriented — orchestrating cross-service workflows). Each has a single reason to change.

## B4: Feature Module Isolation

**Independence + SRP at service level**: Each service owns its data store, API contract, and deployment pipeline. No shared databases (Independence violation). No shared internal types across services (SRP violation — shared types create shared reasons to change).

- **Score 5**: Database-per-service strictly enforced. API contracts versioned. Services independently deployable and testable. No shared libraries beyond protocol definitions.
- **Score 3**: Mostly isolated but some services share a database or a frequently-changing shared library.
- **Score 1**: Services share databases, deploy together, share internal types. Distributed monolith.

## Q2: Modifiability & Change Isolation

**OCP + Independence at service level**: Changes to one service should not require changes to others. API contract evolution (versioning, backward compatibility) enables this. Services should be open for extension (new endpoints, new events) and closed for modification of existing contracts (OCP).

- **Score 5**: Services independently deployable. API changes backward-compatible. Consumer-driven contract tests validate compatibility.
- **Score 3**: Most services independently deployable but some changes require coordinated deployments.
- **Score 1**: All services deploy together. Any change risks breaking others.

## Q4: Observability & Debuggability

**Separation of Concerns applied to monitoring**: Distributed tracing across services. Correlation IDs propagated through all service calls. Centralized logging aggregation. Per-service health dashboards. Observability is more critical in microservices — a request spans multiple services and each must be independently observable.

- Score on whether a request can be traced end-to-end across all services it touches
