# Uber's Domain-Oriented Microservice Architecture (DOMA)

Uber's approach to managing microservice complexity at scale. DOMA addresses the problems that emerge when microservices grow from dozens to thousands: tangled dependencies, unclear ownership, and cascading failures. Load this file when reviewing large-scale service architectures or when evaluating domain decomposition strategies.

## Overview

DOMA organizes microservices into domains — collections of related services grouped by business capability. Each domain has a clearly defined interface (gateway) through which external consumers interact. Internal services within a domain are implementation details hidden behind the gateway.

**Key insight**: Microservices solve deployment independence but create dependency management problems at scale. DOMA applies the same principles used within a single service (encapsulation, interface segregation, dependency direction) to the *inter-service* level.

## The 5 layers

DOMA defines 5 functional layers. Dependencies flow downward — upper layers depend on lower layers, never the reverse.

```
┌─────────────────────────────────┐
│        Edge Layer               │  ← External clients, API gateways
├─────────────────────────────────┤
│     Presentation Layer          │  ← Aggregation, BFF (Backend-for-Frontend)
├─────────────────────────────────┤
│       Product Layer             │  ← Product-specific business logic
├─────────────────────────────────┤
│      Business Layer             │  ← Core business capabilities (domains)
├─────────────────────────────────┤
│    Infrastructure Layer         │  ← Platform services, storage, messaging
└─────────────────────────────────┘
```

### Edge Layer
- API gateway, authentication, rate limiting, protocol translation
- Responsibility: Expose a stable external API regardless of internal service changes
- Maps to: D5 (External Dependency Management) — the edge layer wraps the internal topology

### Presentation Layer
- Backend-for-Frontend services, aggregation services
- Responsibility: Compose responses from multiple domains for specific client needs (mobile app, web, partner API)
- Maps to: B1 (Data Flow Traceability) — the presentation layer is a clear aggregation point

### Product Layer
- Product-specific business logic that orchestrates multiple domains
- Responsibility: Implement product features by coordinating business domains
- Maps to: C3 (Use Case Composition) — product-layer services are the "use cases" at the inter-service level

### Business Layer
- Core business domains (Riders, Drivers, Trips, Payments, Pricing)
- Responsibility: Own business entities, rules, and data for one domain
- This is where DOMA's domain concept lives — each business domain is a self-contained cluster of services
- Maps to: C1 (Single Responsibility), B4 (Feature Module Isolation)

### Infrastructure Layer
- Storage services, messaging, compute platform, observability infrastructure
- Responsibility: Provide foundational capabilities that business domains build upon
- Maps to: D5 (External Dependency Management) — business domains depend on infrastructure abstractions, not implementations

## Gateway interfaces

The gateway is the *only* entry point to a domain from outside. It defines the domain's public API.

### Gateway properties
- **Single entry point**: External consumers never call internal domain services directly
- **Contract stability**: The gateway's API contract is versioned and backwards-compatible
- **Internal freedom**: Services within the domain can be refactored, split, or merged without affecting external consumers
- **Domain agnosticism**: The gateway does not expose domain-internal concepts (internal entity IDs, internal event formats, internal state machines)

### Gateway patterns

**Thin gateway** (API proxy):
- Routes requests to the appropriate internal service
- Minimal logic — just routing and basic validation
- Use when: internal services already have clean APIs

**Smart gateway** (orchestration):
- Composes responses from multiple internal services
- Handles cross-service transactions within the domain
- Use when: the domain has complex internal workflows that should be hidden from consumers

### Mapping to evaluation criteria
- **C4 (Public API & Encapsulation)**: The gateway IS the public API. Internal services are private.
- **D2 (Abstraction at Boundaries)**: The gateway is the abstraction boundary between domains.
- **B4 (Feature Module Isolation)**: Cross-domain communication ONLY through gateways enforces isolation.

## Domain agnosticism

A domain must not know about its consumers. It exposes a general-purpose interface, not consumer-specific APIs.

### Rules
1. **No consumer-specific logic in the domain**: If the Trips domain adds a field "because the mobile app needs it," domain agnosticism is violated.
2. **No consumer-specific data formats**: The domain returns its own data format. Consumers (presentation layer) transform it for their needs.
3. **No reverse dependencies**: The business layer never calls the product layer. If the business layer needs to notify consumers, it publishes events — consumers subscribe.
4. **Terminology independence**: The domain uses its own ubiquitous language. It does not adopt terminology from consuming domains.

### Mapping to evaluation criteria
- **D1 (Dependency Direction)**: Domain agnosticism IS the dependency direction rule applied at service level.
- **B2 (Data Transformation)**: Transformation happens at the gateway boundary, not inside the domain.

## Extension mechanisms

DOMA defines two extension types for customizing domain behavior without modifying the domain itself.

### Logic extensions
- The domain defines extension points (hooks, plugins, strategies)
- Consumers register custom logic that the domain executes at defined points
- Example: The Pricing domain defines a `PricingStrategy` interface. The Uber Eats product registers a `FoodDeliveryPricingStrategy`. The Pricing domain is unaware of Uber Eats — it just executes the registered strategy.

### Data extensions
- The domain allows consumers to attach arbitrary metadata to domain entities
- The domain stores and returns the metadata but does not interpret it
- Example: The Trips domain allows attaching `metadata: Map<String, Any>` to a trip. The Uber Eats product attaches `{"food_order_id": "123"}`. The Trips domain stores it but has no knowledge of food orders.

### Mapping to evaluation criteria
- **S4 (Evolutionary Readiness)**: Extension mechanisms enable adding features without modifying core domains — the OCP at service level.
- **D2 (Abstraction at Boundaries)**: Extension points are abstractions that decouple domain from consumer.

## Blast radius evaluation

DOMA uses "blast radius" as a key review dimension: *if this service fails, what is affected?*

### Blast radius categories

| Category | Definition | Example |
|----------|-----------|---------|
| **Domain-contained** | Failure affects only services within the same domain | Internal caching service fails → domain falls back to database |
| **Cross-domain** | Failure affects services in other domains | Pricing gateway down → Trips cannot calculate fares |
| **User-facing** | Failure directly affects end users | Edge gateway down → all API calls fail |
| **Cascading** | Failure propagates through multiple domains | Payment service slow → Trips block waiting → Driver dispatch queues build up |

### Blast radius evaluation questions
- What is the blast radius of a single service failure within this domain?
- Can a failure in this domain cascade to other domains?
- Are there circuit breakers between domains?
- Does the gateway provide fallback responses when internal services fail?
- Are dependencies between domains asynchronous (events) or synchronous (API calls)?

### Mapping to evaluation criteria
- **Q2 (Modifiability & Change Isolation)**: Blast radius of a code change should be contained to one domain.
- **Q3 (Scalability & Performance)**: Blast radius of a performance degradation should be contained by bulkheads and circuit breakers.
- **B3 (Error Translation)**: Each domain gateway translates internal errors to domain-level error responses.

## When DOMA applies vs other styles

| Context | Recommended Style | Why |
|---------|------------------|-----|
| 1-5 teams, single product | Clean Architecture / Modular Monolith | DOMA overhead not justified. Module boundaries sufficient. |
| 5-20 teams, multiple products | DOMA | Multiple products need domain boundaries. Gateways manage cross-team contracts. |
| 20+ teams, platform company | DOMA + Platform teams | Infrastructure layer becomes a platform. Domain gateways are contractual boundaries. |
| Existing microservice sprawl | DOMA (retrofit) | Group existing services into domains. Add gateways. Reduce cross-service coupling. |
| Single team, microservices | Consolidate to modular monolith | DOMA does not help when there is only one team. Reduce operational complexity. |

## DOMA anti-patterns

| Anti-Pattern | Description | Fix |
|-------------|-------------|-----|
| **Leaky gateway** | Gateway exposes internal entity IDs or internal service structure | Redesign gateway to use domain-level concepts only |
| **Consumer-aware domain** | Business-layer service contains if-else for different consumers | Extract consumer logic to product layer; use extension points |
| **Shared database across domains** | Two domains read/write the same tables | Split tables by domain ownership; use events for synchronization |
| **Synchronous chain** | A → B → C → D synchronous calls across 4 domains | Introduce async events or consolidate into fewer domains |
| **Missing gateway** | External consumers call internal domain services directly | Add a gateway; migrate consumers to gateway API |

## Integration with evaluation lenses

| DOMA Concept | Primary Lens | Criteria | How It Applies |
|-------------|:---:|---------|----------------|
| Layer hierarchy | D1 | Layer separation | Dependencies flow downward through 5 layers |
| Gateway interfaces | D2, C4 | Abstraction, public API | Gateway is the boundary abstraction and public API |
| Domain agnosticism | D1, B2 | Dependency direction, data transformation | Domains don't know consumers; data transforms at gateway |
| Extension mechanisms | S4, D2 | Evolutionary readiness, abstraction | Enable feature addition without domain modification |
| Blast radius | Q2, Q3 | Change isolation, resilience | Failures contained within domain boundaries |
| Cross-domain events | D4, B4 | Acyclicity, feature isolation | Events create DAG; domains communicate asynchronously |
