# Technology context: Backend

Platform-specific architecture patterns for backend platforms and how the 5 evaluation lenses adapt. Load this file when the system under review targets a backend platform. For mobile, frontend, CLI, and cross-platform lens weighting, see [frameworks-technology-context.md](frameworks-technology-context.md).

## Spring Boot (Java/Kotlin)

**Typical structure**:
```
com.example.app/
  controller/        # REST controllers (presentation)
  service/           # Business logic (use cases)
  repository/        # Data access (Spring Data interfaces)
  model/             # Domain entities
  dto/               # Request/response DTOs
  config/            # Spring configuration
```

**Platform-specific considerations**:
- **D3**: Domain models should be POJOs/data classes — minimize JPA annotations in the domain layer. Consider separate JPA entities in the data layer.
- **D2**: Service interfaces defined in the domain/service package. Implementations can live alongside or in a separate `impl` package.
- **B3**: Controllers catch domain exceptions and translate to HTTP responses via `@ControllerAdvice`. Services should not throw `HttpException`.
- **S1**: ArchUnit tests can physically enforce dependency rules in CI. This is the gold standard for S1 score 5.

**Common anti-patterns**:
- `@Entity` JPA annotations on domain models (framework in domain)
- Service methods throwing `ResponseStatusException` (HTTP in business logic)
- Controllers containing business validation logic

## Django (Python)

**Standard Django structure**:
```
project/
  app_name/
    models.py      # Django ORM models (domain + data combined)
    views.py       # Request handling (presentation)
    serializers.py # DRF serializers (DTOs)
    urls.py        # Routing
    admin.py       # Admin interface
```

**Clean Architecture adaptation**:
```
project/
  app_name/
    domain/          # Pure Python entities, use case interfaces
    use_cases/       # Business logic
    data/            # Django models, repositories
    presentation/    # Views, serializers
```

**Platform-specific considerations**:
- **D3**: Django's default pattern couples domain models to ORM. Clean separation requires explicit effort — separate domain entities from Django models.
- **C1**: Django's `models.py` often accumulates business logic via model methods. Extract to use cases.
- **B2**: DRF serializers are DTOs. Domain entities should be separate from `models.Model` subclasses where practical.
- **Q1**: If domain models extend `models.Model`, all tests require database. Pure domain entities enable unit testing without Django test runner.

**Scoring adjustment**: Django projects that intentionally use the "fat models" pattern should be scored within Django's conventions, not penalized for not following Clean Architecture. Evaluate whether the chosen pattern is consistently applied and whether boundaries exist at the app level.

## Express / NestJS (Node.js)

**NestJS structure**:
```
src/
  modules/
    auth/
      auth.controller.ts   # HTTP handling
      auth.service.ts       # Business logic
      auth.module.ts        # DI module
      dto/                  # Request/response DTOs
      entities/             # Domain/ORM entities
```

**Platform-specific considerations**:
- **D2**: NestJS uses decorators for DI (`@Injectable`). Ensure domain logic is testable without the NestJS runtime.
- **C4**: NestJS modules provide natural encapsulation. Evaluate whether modules export minimal public API.
- **B4**: Cross-module imports should use the module's exported providers, not deep file imports.
- **S1**: ESLint with `eslint-plugin-boundaries` or `eslint-plugin-import` can enforce module boundaries.

## Go (Service structure)

**Typical structure**:
```
cmd/
  server/main.go      # Entry point
internal/
  domain/             # Business entities, interfaces
  usecase/            # Business logic
  handler/            # HTTP/gRPC handlers
  repository/         # Data access implementations
pkg/                  # Shared libraries
```

**Platform-specific considerations**:
- **D1**: Go's package visibility (`internal/`) provides built-in physical enforcement. Unexported symbols are inaccessible outside the package.
- **D2**: Interfaces defined where they are used (consumer-side), not where they are implemented — Go convention aligns perfectly with DIP.
- **S1**: Go's package system naturally scores higher on S1 due to built-in visibility enforcement.
- **C4**: `internal/` directories physically prevent external access. No barrel files needed.
