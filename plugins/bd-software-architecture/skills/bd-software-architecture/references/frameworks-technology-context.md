# Technology context: Frontend, CLI & cross-platform

Platform-specific architecture patterns for frontend and CLI platforms, plus cross-platform lens weighting adjustments and anti-patterns. For mobile platforms, see [frameworks-technology-mobile.md](frameworks-technology-mobile.md). For backend platforms, see [frameworks-technology-backend.md](frameworks-technology-backend.md).

## Frontend

### React (Feature-Sliced Design)

**Structure**:
```
src/
  app/            # App-wide setup, providers, routing
  pages/          # Page-level components, route definitions
  features/       # Business feature modules
  entities/       # Domain entities, shared business logic
  shared/         # Reusable UI components, utilities
```

**Platform-specific considerations**:
- **D1**: Features depend on entities and shared. Pages depend on features. No upward dependencies.
- **C3**: Custom hooks encapsulate business logic. Components focus on rendering.
- **B4**: Features should not import from other features directly — communicate through shared state or events.
- **Q1**: Business logic in hooks testable with `renderHook`. Components testable with Testing Library.

### Angular (Modules)

**Structure**:
```
src/app/
  core/           # Singleton services, guards, interceptors
  shared/         # Reusable components, directives, pipes
  features/
    auth/
      components/
      services/
      models/
      auth.module.ts
```

**Platform-specific considerations**:
- **D2**: Angular's DI system supports interface-based injection via `InjectionToken`.
- **S1**: Angular modules provide physical boundaries. `NgModule` imports define the dependency graph.
- **C4**: Module exports define the public API. Internal components not exported are encapsulated.

## CLI

**Command pattern structure**:
```
src/
  commands/        # Individual command handlers
  core/            # Shared business logic
  io/              # Input parsing, output formatting
  config/          # Configuration management
```

**Platform-specific considerations**:
- **D3**: Core business logic must not import CLI framework (Commander, Click, Cobra). Commands call core, not the other way.
- **B1**: Data flow: CLI input → command parser → use case → output formatter → CLI output. Each step has clear responsibility.
- **Q1**: Core logic testable without invoking the CLI framework. Commands testable by mocking I/O.

## Lens weighting adjustments by platform

Different platforms naturally emphasize different lenses. These adjustments affect scoring expectations, not the criteria themselves.

| Platform | Higher Weight | Lower Weight | Rationale |
|----------|:------------:|:------------:|-----------|
| **Mobile** | D3 (framework independence), Q1 (testability) | Q3 (scalability) | Framework coupling is the dominant mobile architecture risk. Scalability handled by OS/server. |
| **Backend API** | Q3 (scalability), Q4 (observability), B3 (error translation) | — | Backend systems must handle load and be debuggable in production. |
| **Frontend SPA** | B4 (feature isolation), C4 (public API) | D5 (external deps) | Feature isolation prevents UI complexity explosion. External deps managed by bundler. |
| **CLI** | D3 (framework independence), B1 (data flow) | Q3 (scalability), Q4 (observability) | CLI tools should be testable without the CLI framework. Scaling rarely applies. |
| **Microservices** | D4 (acyclicity), D5 (external deps), B4 (isolation) | S1 (physical enforcement) | Service boundaries provide physical enforcement. Dependency management across services is critical. |
| **Monolith** | S1 (physical enforcement), C4 (public API) | D5 (external deps) | Without deployment boundaries, physical structure is the only enforcement mechanism. |

## Platform-specific anti-patterns

| Platform | Anti-Pattern | Lens |
|----------|-------------|------|
| Mobile | Cubit/ViewModel/BLoC calling network directly | D1 |
| Mobile | Domain entities with serialization annotations | D3 |
| Backend | Service throwing HTTP exceptions | B3 |
| Backend | Controller containing business validation | C1 |
| Frontend | Components fetching data directly (no service layer) | D1 |
| Frontend | Cross-feature component imports | B4 |
| CLI | Business logic importing CLI framework | D3 |
| Microservices | Shared database between services | B4 |
| Microservices | Synchronous chains of 4+ service calls | Q3 |
