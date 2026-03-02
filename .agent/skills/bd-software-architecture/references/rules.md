# Rules & Policies

## Non-Negotiable Rules

1. **Presentation layer MUST call use cases only.**
2. **Use cases MUST be the only entry point** into business operations.
3. **Dependencies MUST flow one-way (inward).**
4. **Domain models and use cases MUST be framework-agnostic.**
5. **DTOs MUST NOT cross architectural boundaries.**
6. **Repositories/Services MUST consume and return domain models.**
7. **Feature modules MUST NOT create cycles** (DAG only).
8. **Cross-feature imports MUST go through public API.**

## Anti-Patterns (NEVER use)

- **Deep imports**: Importing internal paths instead of public API.
- **Leaking DTOs**: Returning DTOs from repositories/services.
- **Logic in presentation**: Business decisions in UI/handlers.
- **God repositories**: One repository doing everything.
- **Hard dependencies**: Instantiating implementations directly (use DI).
- **Use case for formatting**: Extracting non-business logic as use cases.
- **Framework in domain**: Domain models importing HTTP/DB/UI libraries.