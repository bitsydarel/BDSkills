# Architecture Style Mapping: Functional Architecture

Maps evaluation criteria to functional architecture equivalents (Haskell, Elixir/Phoenix, Scala FP, F#, Clojure, Elm). Only criteria that differ from Clean Architecture defaults are listed — omitted criteria (D2, D4, D5, S1-S4, C2, C3, B2-B4, Q2-Q4) apply identically.

## Foundation

Three core principles — **Dependency Rule** (dependencies point inward), **Separation of Concerns** (each layer has a distinct responsibility), **Independence** (business rules exist without frameworks/UI/database) — are non-negotiable regardless of architecture style. SOLID principles apply universally — in functional languages, SRP maps to module/function focus, OCP maps to algebraic data types and pattern matching, LSP maps to type substitutability, ISP maps to focused module interfaces, and DIP maps to the pure/effectful boundary. The bar is identical.

---

## D1: Layer Separation & Dependency Direction

**Dependency Rule**: Pure functions vs effectful functions. The Dependency Rule becomes: **effects depend on pure logic, never the reverse.** Pure domain logic must not import I/O modules. Side effects are pushed to the system boundary.

- **Score 5**: Clear boundary between pure core and effectful shell. Pure functions have zero I/O imports. Effects at the outermost layer only.
- **Score 3**: Mostly separated but some domain functions perform I/O directly.
- **Score 1**: Pure and effectful code interleaved — no clear boundary (Dependency Rule violation).

## D3: Framework Independence

**Independence**: Side-effect-free core. Can domain logic run as pure functions without any runtime, framework, or I/O? In Haskell: domain logic in pure functions (no IO monad). In Elixir: domain logic without GenServer or Ecto dependencies.

- **Score 5**: Domain logic is pure — compiles and runs without any framework or runtime. All effects isolated in adapter modules.
- **Score 3**: Most domain logic pure but some functions use framework-specific types.
- **Score 1**: Domain logic depends on framework types and I/O throughout (Independence violation).

## C1: Single Responsibility & Cohesion

**SRP**: Each module groups related pure functions around one domain concept. Effect modules group related I/O operations. No module mixes domain logic with I/O — that would give it two reasons to change (SRP violation).

## C5: Domain Model Purity

**Independence + SRP**: Algebraic data types (ADTs), typed records, or immutable data structures as domain representations. Domain types carry no serialization, persistence, or framework annotations. Pattern matching covers all cases (exhaustiveness = correctness).

- **Score 5**: Domain expressed as ADTs/records with no framework dependencies. Types composable and self-documenting.
- **Score 3**: Domain types mostly pure but some carry serialization or persistence annotations.
- **Score 1**: Domain types are framework-specific structs with ORM annotations or serialization logic embedded (Independence violation).

## B1: Data Flow Traceability

**Separation of Concerns**: Input → Pure transformation pipeline → Effects at the boundary. Data flows through function composition. Each step is a pure transformation until the boundary where effects occur. Pipe operators (`|>`, `.`, `>>`) make data flow explicit.

**Violation**: Effects interspersed in the transformation pipeline. No clear point where pure logic ends and I/O begins (Separation of Concerns breakdown).

## Q1: Testability

**Consequence of all three principles**: Pure functions ARE inherently testable — input in, output out, no side effects. Score on the **clarity of the pure/effectful boundary**. If the boundary is clean, domain tests need zero mocking.

- **Score 5**: Domain logic is pure functions — tested with input/output assertions. No mocking needed. Effect boundary clear and narrow.
- **Score 3**: Most logic pure and testable. Some functions require mocking I/O dependencies.
- **Score 1**: Logic interleaved with effects — every test requires mocking I/O (all three principles violated).
