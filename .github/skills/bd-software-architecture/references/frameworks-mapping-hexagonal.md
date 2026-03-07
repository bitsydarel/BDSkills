# Architecture Style Mapping: Hexagonal / Ports & Adapters

Maps evaluation criteria to Hexagonal Architecture equivalents. Only criteria that differ from Clean Architecture defaults are listed — omitted criteria (D3, D4, D5, S1-S4, C1, C3, C5, B2-B4, Q1-Q4) apply identically.

## Foundation

Three core principles — **Dependency Rule** (dependencies point inward), **Separation of Concerns** (each layer has a distinct responsibility), **Independence** (business rules exist without frameworks/UI/database) — are non-negotiable regardless of architecture style. SOLID principles apply universally. Hexagonal Architecture is the closest sibling to Clean Architecture — most criteria map directly. The key difference is vocabulary: "ports" and "adapters" replace "layers" and "boundaries."

---

## D1: Layer Separation & Dependency Direction

**Dependency Rule**: Driving Adapter → Driving Port → Application Core → Driven Port → Driven Adapter. The application core depends on nothing external — all dependencies point inward through ports. The "layers" are: adapters (outer) → ports (boundary) → application core (inner).

**Violation**: Application core imports an adapter directly (Dependency Rule violation). A driven adapter is called without going through its port (bypasses the boundary contract).

## D2: Abstraction at Boundaries

**DIP + ISP**: Ports ARE the interfaces. Driving ports define how the outside world interacts with the application (ISP: each port is a focused interface). Driven ports define how the application interacts with the outside world. Adapters implement ports. This is DIP in its purest form.

- **Score 5**: All cross-boundary communication goes through explicitly defined ports. Adapters are pluggable — swapping a database adapter requires zero changes to the core.
- **Score 3**: Ports exist but some adapters bypass them for convenience.
- **Score 1**: No port abstraction — core directly imports adapter implementations (DIP violation).

## C2: Repository vs Service Clarity

**SRP + ISP**: Driven ports (outgoing — database, messaging, external APIs) vs Driving ports (incoming — HTTP, CLI, events). Each port has a single, focused responsibility (ISP). The distinction is between what the application **provides** (driving) and what it **requires** (driven).

**Violation**: A single port that mixes data access, messaging, and external API concerns (ISP violation).

## B1: Data Flow Traceability

**Separation of Concerns**: Driving Adapter → Driving Port → Application Core → Driven Port → Driven Adapter. Multiple entry points (driving adapters) and multiple exit points (driven adapters) — each path through the hexagon should be consistent and traceable.

**Violation**: Some features bypass ports. Different driving adapters reach the core through inconsistent paths (Separation of Concerns breakdown).
