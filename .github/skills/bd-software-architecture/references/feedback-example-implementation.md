# Feedback example: Implementation review

A complete scored example reviewing an existing "User Authentication Feature" implementation. Demonstrates proper use of the feedback template for implementation reviews, including the compliance checklist and outcome confirmation.

---

## Architecture Review: User Authentication Feature

**Review mode**: Implementation
**System complexity**: Standard
**Technology stack**: Kotlin / Spring Boot / PostgreSQL / Redis
**Codebase reference**: `features/auth/`

---

### Lens 1: Dependency Architecture — 16/25

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| D1: Layer Separation | 3 | Layers exist (controller → service → repository) but `AuthController` directly calls `UserRepository` for the "check email exists" endpoint, bypassing the service layer. 2 out of 8 endpoints skip the service layer. |
| D2: Abstraction at Boundaries | 4 | `UserRepository` interface defined in the service package. `TokenStore` interface abstracts Redis. `PasswordEncoder` interface abstracts BCrypt. Consistent use of interfaces at data boundaries. |
| D3: Framework Independence | 2 | `User` domain entity annotated with `@Entity`, `@Table`, `@Column` (JPA). `AuthService` uses `@Transactional` annotation. Domain logic cannot be tested without Spring context. |
| D4: Dependency Graph Acyclicity | 4 | No circular dependencies between features. Auth feature depends on `shared/email` (for validation) and `shared/crypto` (for hashing). No reverse dependencies detected. |
| D5: External Dependency Management | 3 | Redis wrapped behind `TokenStore` interface — good. However, BCrypt is used directly in `AuthService` via `BCryptPasswordEncoder` import. JWT library (`io.jsonwebtoken`) imported directly in `TokenService` without an abstraction. |

### Lens 2: Component Design — 15/25

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| C1: Single Responsibility | 3 | `AuthService` handles login, registration, password reset, token refresh, and email verification — 5 responsibilities. Should be split into focused use cases. `UserRepository` is well-focused. |
| C2: Repository vs Service Clarity | 3 | `UserRepository` is data-oriented (CRUD). However, `AuthService` mixes orchestration (login flow) with capability (token generation, password hashing). Token management should be a separate service. |
| C3: Use Case Composition | 2 | No explicit use case classes. `AuthService` methods ARE the use cases, but they share private methods (`validatePassword`, `generateTokenPair`), creating implicit composition through shared state. Extracting use cases would clarify responsibilities. |
| C4: Public API & Encapsulation | 4 | Feature exposes `AuthService`, `User` (entity), `AuthenticationResult` (response type). Internal components (`UserRepository`, `TokenStore`, DTOs) are package-private. Barrel file pattern via Kotlin `internal` visibility. |
| C5: Domain Model Purity | 3 | `User` entity has JPA annotations (same as D3 finding — shared root cause). However, the entity does contain domain logic: `User.isEmailVerified()`, `User.canResetPassword()` — domain behavior exists but is polluted with framework annotations. |

### Lens 3: Data Flow & Boundaries — 11/20

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| B1: Data Flow Traceability | 3 | Main login flow: Controller → AuthService → UserRepository + TokenStore → Response. Traceable. However, the "check email" endpoint goes Controller → UserRepository directly, creating an undocumented shortcut. Password reset flow involves 3 services with unclear sequencing. |
| B2: Data Transformation | 2 | JPA `User` entity (with `@Entity`) is passed from repository through service to controller, where it is mapped to `UserResponse` DTO. The JPA entity travels through all layers — it IS the domain model AND the database model. No separation between persistence model and domain model. |
| B3: Error Translation | 3 | `UserNotFoundException` and `InvalidCredentialsException` are domain exceptions thrown by `AuthService`. Controller translates via `@ControllerAdvice`. However, `AuthService` catches `DataIntegrityViolationException` (Spring/JPA) — a vendor exception in the service layer. Should be caught at the repository level. |
| B4: Feature Module Isolation | 3 | Other features access auth through `AuthService` public API. However, `features/profile` imports `User` entity directly from `features/auth/domain/User` — deep import into auth's internal structure. Profile should receive a `UserInfo` value object through auth's public API. |

### Lens 4: Quality Attributes — 11/20

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| Q1: Testability | 2 | All tests are `@SpringBootTest` integration tests requiring database and Redis. Test suite takes 45 seconds. No unit tests for business logic because `AuthService` depends on JPA entities and `@Transactional`. Root cause: D3 (framework in domain). |
| Q2: Modifiability | 3 | Replacing Redis (via `TokenStore` interface) would be one-module change — good. Replacing PostgreSQL would require changing the `User` entity annotations AND the domain logic (due to JPA coupling). Replacing JWT library would require changing `TokenService`. |
| Q3: Scalability & Performance | 3 | Redis for token storage supports horizontal scaling. Session-less JWT design enables stateless scaling. However, no rate limiting on login endpoint and no mention of brute force protection at the architecture level. |
| Q4: Observability | 3 | Spring Actuator provides basic health checks. Login failures logged with user context. However, no structured logging format. No distributed tracing. No metrics on authentication latency or failure rates. Cannot correlate a failed login with downstream effects. |

### Lens 5: Structural Integrity — 10/20

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| S1: Physical Enforcement | 2 | Kotlin `internal` visibility used for some components. However, no ArchUnit tests or lint rules to enforce layer separation. The controller → repository shortcut (D1 finding) proves that convention-only enforcement is insufficient. |
| S2: Naming Consistency | 3 | Services use `*Service` suffix. Repositories use `*Repository`. Controllers use `*Controller`. However, `AuthService` vs `TokenService` — one is feature-scoped, the other is capability-scoped, but naming does not distinguish them. DTOs inconsistently named: `LoginRequest`, `UserResponse`, `TokenPairDto`. |
| S3: Architecture Decision Records | 2 | No ADRs found. Why JWT over sessions? Why Redis over database for tokens? Why BCrypt over Argon2? These decisions have security and performance implications but no documented rationale. |
| S4: Evolutionary Readiness | 3 | Adding a new auth method (OAuth, SSO) would require modifying `AuthService` — no strategy pattern or extension point. However, the `TokenStore` interface suggests awareness of extensibility for storage backends. |

### Lens 6: Database Architecture — 12/25

| Criterion | Score | Rationale |
|-----------|:-----:|-----------|
| DA1: Data Model Selection | 3 | PostgreSQL for user data (relational — appropriate for structured user records with ACID needs) and Redis for token storage (key-value — appropriate for ephemeral, high-read tokens). Both choices are sensible but neither is explicitly justified. No documentation of why PostgreSQL over alternatives, or why Redis over database-backed token storage. |
| DA2: Consistency & Trade-off Awareness | 2 | PostgreSQL provides ACID for user data. Redis token store uses eventual consistency across replicas. No documentation of what happens during the consistency window: if a token is revoked in PostgreSQL (user password change) but Redis still serves the cached token, the user remains authenticated. No TTL or invalidation strategy documented. |
| DA3: Data Isolation & Ownership | 3 | Auth feature owns the `users` table and Redis token namespace. However, the Profile feature imports the `User` entity directly (B4 finding), suggesting shared database model access rather than API-mediated reads. Token data properly isolated in Redis. |
| DA4: Distributed Data Coordination | 2 | Two data stores (PostgreSQL + Redis) involved in the login flow: user lookup (PostgreSQL) then token storage (Redis). No coordination strategy documented. If Redis write fails after successful PostgreSQL authentication, the user is authenticated but has no token. No compensation or retry strategy. |
| DA5: Data Scalability Strategy | 2 | No mention of PostgreSQL connection pooling, indexing strategy for user lookups (email uniqueness, login queries), Redis memory limits, or token eviction policy. No growth projections for user base or concurrent session count. |

---

### Overall Score

| Lens | Score | Max | % |
|------|:-----:|:---:|:-:|
| 1. Dependency Architecture | 16 | 25 | 64% |
| 2. Component Design | 15 | 25 | 60% |
| 3. Data Flow & Boundaries | 11 | 20 | 55% |
| 4. Quality Attributes | 11 | 20 | 55% |
| 5. Structural Integrity | 10 | 20 | 50% |
| 6. Database Architecture | 12 | 25 | 48% |
| **Total** | **75** | **135** | **56%** |

**Verdict**: **Critical Gaps**

Total score 56% is below the 60% (81/135) threshold. No individual lens below 40% (weakest-link not triggered). No criterion scored 1 (critical override not triggered). The score is close to the threshold — addressing the top 3 findings (JPA in domain, persistence model separation, ArchUnit enforcement) plus database coordination gaps would bring the score above 60%.

---

### Architecture Compliance Checklist (Implementation Only)

| Check | Status | Notes |
|-------|:------:|-------|
| Dependencies flow inward (no outward violations) | Partial | Controller → Repository shortcut violates dependency direction |
| Domain models free of framework imports | No | JPA annotations on `User` entity |
| Cross-feature imports use public API only | Partial | Profile feature imports `User` entity directly |
| Error types defined at domain level | Yes | `UserNotFoundException`, `InvalidCredentialsException` |
| All components testable in isolation | No | All tests require Spring context + database |
| Architecture rules enforced in CI/CD | No | No ArchUnit or lint rules |
| ADRs exist for significant decisions | No | No ADRs found |
| Data model selection justified against access patterns | No | PostgreSQL and Redis choices not documented |
| Consistency requirements documented (CAP/PACELC positioning) | No | No consistency guarantees for PostgreSQL-Redis interaction |
| Each database/schema has a single owner (no shared writes) | Partial | Auth owns users table and Redis; Profile accesses User entity directly |
| Cross-service data operations use saga/CQRS (no 2PC) | No | No coordination between PostgreSQL and Redis operations |
| Data scaling strategy documented with growth projections | No | No connection pooling, indexing, or Redis memory configuration documented |

---

### Outcome Confirmation (Implementation Only)

| Expected Outcome | Achieved? | Evidence |
|-----------------|:---------:|---------|
| Auth logic independent of web framework | Partial | Service layer exists but JPA couples domain to Spring |
| Token storage swappable | Yes | `TokenStore` interface with Redis implementation |
| Auth feature isolated from other features | Partial | Public API exists but `User` entity leaks to profile feature |
| Login flow testable without infrastructure | No | All tests require database + Redis |
| Database choices justified against requirements | No | PostgreSQL and Redis assumed, not explicitly justified |
| Data consistency guarantees documented | No | No documented strategy for PostgreSQL-Redis consistency window |
| Data scaling ready for growth | No | No connection pooling, indexing, or memory management configured |

---

### Architecture Proposal

**Proposed adjustments to the existing architecture**:

1. **Extract pure domain models** → Create `UserEntity` (JPA, data layer) separate from `User` (domain, pure Kotlin). Repository maps between them. This immediately unlocks unit testing and decouples domain from JPA.

2. **Split AuthService into focused use cases** → `LoginUseCase`, `RegisterUseCase`, `ResetPasswordUseCase`, `RefreshTokenUseCase`. Each with a single responsibility and clear dependencies.

3. **Add ArchUnit tests** → Enforce: "domain package has no Spring/JPA imports", "controllers do not import repositories", "features do not import other features' internal packages."

---

### Issues

**Critical**:
1. **[D3 + Q1] JPA annotations in domain model (cross-lens amplification)** — `User` entity has `@Entity`, `@Table`, `@Column`. Domain logic cannot be tested without Spring/JPA context. D3 score 2 + Q1 score 2 = Critical amplification. *Root cause*: No separation between persistence model and domain model. *Fix*: Create separate `UserEntity` (JPA) in data layer and `User` (plain Kotlin) in domain. Repository maps between them.

**Major**:
2. **[D1] Controller bypasses service layer** — `AuthController` calls `UserRepository` directly for "check email" endpoint. *Fix*: Route through `CheckEmailExistsUseCase`.
3. **[B2] JPA entity leaks through all layers** — Same `User` object flows from database to HTTP response. *Fix*: Repository returns domain `User`; controller maps to `UserResponse` DTO.
4. **[C1] AuthService has 5 responsibilities** — Login, registration, password reset, token refresh, email verification. *Fix*: Extract into individual use case classes.
5. **[S1 + D1] No enforcement with existing violations (cross-lens amplification)** — Architecture rules exist by convention only AND violations already exist. *Fix*: Add ArchUnit tests to prevent regression, then fix existing violations.

**Minor**:
1. **[S2] Inconsistent DTO naming** — `LoginRequest` vs `TokenPairDto` — mixed naming conventions. *Fix*: Standardize on `*Request`/`*Response` for API DTOs.
2. **[S3] Missing ADRs** — Key decisions (JWT, Redis, BCrypt) undocumented. *Fix*: Retroactively document decisions with rationale.
3. **[D5] Direct JWT library usage** — `io.jsonwebtoken` imported directly in `TokenService`. *Fix*: Wrap behind `TokenEncoder` interface for substitutability.
4. **[DA2] Token revocation consistency gap** — No strategy for invalidating Redis-cached tokens when user credentials change in PostgreSQL. *Fix*: Document token invalidation flow; consider Redis key deletion on password change or short TTL with refresh rotation.
5. **[DA4] No PostgreSQL-Redis coordination** — Login flow spans two data stores without compensation strategy for partial failures. *Fix*: Document failure modes (Redis write failure after auth success) and implement retry or fallback.
6. **[DA5] Missing data scaling fundamentals** — No connection pooling config, index strategy, or Redis memory/eviction policy. *Fix*: Configure HikariCP pool sizing, add indexes for email lookups, set Redis maxmemory with allkeys-lru eviction.

---

### Strengths

1. **Interface discipline at data boundaries**: `TokenStore`, `UserRepository`, and `PasswordEncoder` interfaces demonstrate understanding of DIP at data boundaries.
2. **Domain exceptions**: `UserNotFoundException` and `InvalidCredentialsException` are domain-level, not framework-level — proper error modeling.
3. **Clean dependency graph**: No circular dependencies between features. Auth feature has clear, one-directional relationships with shared modules.
4. **Package-private encapsulation**: Kotlin `internal` visibility used to encapsulate internal components — shows awareness of public API discipline.

---

### Top Recommendation

**Separate persistence models from domain models.** The JPA `User` entity serving as both database model and domain model is the root cause of three major findings: framework coupling (D3), untestable architecture (Q1), and DTO leaking (B2). Creating a separate `UserEntity` for JPA and a pure `User` domain class is a single change that addresses three issues and raises the total score above the Proceed threshold.

---

### Key Question

> "Can you write a test for the login flow that runs in under 1 second without any database or Redis?"

If the answer is no, the architecture has a testability problem rooted in framework coupling. The separation of persistence and domain models is the architectural change that makes this possible.
