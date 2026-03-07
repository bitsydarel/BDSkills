# Technology context: Keycloak — Observability & Anti-Patterns

Keycloak testability, observability, and comprehensive anti-pattern reference. For core architecture (role, integration, flows, realm, tokens, security), see [frameworks-technology-keycloak-core.md](frameworks-technology-keycloak-core.md). For operational guidance (reverse proxy, HA, SPI, federation, performance, enterprise patterns), see [frameworks-technology-keycloak-operations.md](frameworks-technology-keycloak-operations.md).

## Testability & Evolvability

**Test strategy** (Q1, Q2, S4):
- Q1: mock `AuthService` for unit tests — no Keycloak dependency. `dasniko/testcontainers-keycloak` for integration tests with real Keycloak + custom SPI extensions loaded via `withProviderClassesFrom("target/classes")`
- Q2: swap Keycloak for Auth0/Cognito → only auth adapter + DI config changes. If use cases change, the abstraction leaks
- S4: new auth methods (SAML, WebAuthn, social login) added by extending `AuthService` implementations + Keycloak configuration — no modification of business logic (OCP)
- **SPI upgrade strategy**: pin Keycloak version in `pom.xml`, follow Upgrading Guide per version, run Testcontainers integration tests on every Keycloak version upgrade, maintain compatibility matrix, depend only on `keycloak-server-spi` (public)
- **Keycloak 26+ backward compatibility**: breaking changes in minor releases are opt-in, deprecations happen in minor releases but removals wait until next major version. At least two releases (~6 months) before breaking changes take effect

## Observability & Monitoring

**Operational visibility** (Q4):
- Enable `KC_HEALTH_ENABLED=true` and `KC_METRICS_ENABLED=true`
- Metrics endpoint on port 9000 (internal only): Prometheus/Micrometer-compatible
- Critical KPIs: login failures/min (brute force indicator), auth response time p95/p99, CPU/memory per pod, DB connection pool usage, cache hit rates, failed token validation rate, active sessions count
- Grafana dashboards available (official Keycloak dashboard ID 10441)
- Keycloak 26.2+ enhanced observability with service-level indicators
- OpenTelemetry integration for distributed tracing across Keycloak and downstream services
- Event-driven analytics: Event Listener SPI → Kafka/ELK/Splunk for real-time SIEM feeds, anomaly detection, CRM/HR sync on user lifecycle events

## Common Keycloak anti-patterns

Architecture-relevant anti-patterns specific to Keycloak deployments:

| Anti-Pattern | Criterion | Impact |
|---|---|---|
| **Integration & Dependency** | | |
| Keycloak SDK imported in use cases/domain | D3 | Framework in business logic; cannot swap IdP |
| Deprecated Keycloak Spring Adapter | D3 + D5 | Vendor lock-in via retired library; no maintenance since v17 |
| Tight coupling to `keycloak-server-spi-private` | D3 + D5 | Internal APIs break on every major version |
| Raw Keycloak tokens flowing into use cases | B2 + B3 | No boundary transformation; vendor types leak across layers |
| Keycloak product name in public URLs | S2 | Leaks technology choice; complicates migration |
| **Protocol & Flow** | | |
| Implicit Flow (tokens in URL) | D5 + cross-ref | Deprecated; tokens leak via browser history, logs (CVE-2023-6927) |
| Password Grant / ROPC / Direct Grant | D5 + cross-ref | Defeats centralized auth; exposes credentials to client apps |
| Frontend SPA storing tokens directly | Q3 + cross-ref | Tokens exposed to XSS; use BFF pattern |
| Distributed Introspection Bottleneck | Q3 + B1 | Per-request IdP call = latency + SPOF at scale |
| **Realm & Client Configuration** | | |
| Reusing Master realm for applications | S2 + cross-ref | Administrative exposure; violates isolation |
| Full Scope Allowed = ON (default) | B4 + cross-ref | All roles from all clients leaked into every token |
| Missing audience (`aud`) validation | B4 + cross-ref | Token for Client A accepted by Client B's API |
| `offline_access` scope for user-facing apps | cross-ref | Tokens survive logout and server restart |
| Permissive redirect URIs (wildcards) | cross-ref | Open redirect attacks; token interception (CVE-2023-6927) |
| One realm per tenant at scale >100 | Q3 | Startup/admin degradation; use Organizations feature |
| **Token Architecture** | | |
| Access token lifespan > SSO session idle | B1 + cross-ref | Breaks session lifecycle hierarchy |
| No refresh token rotation | cross-ref | Stolen refresh token usable indefinitely |
| Long-lived access tokens (hours/days) | cross-ref | Cannot revoke without key rotation |
| **SPI & Extensibility** | | |
| Combined ProviderFactory+Provider in one class | C1 | Lifecycle collision; `close()` releases shared resources after first request |
| Creating heavy objects per request in `create()` | Q3 | File descriptor exhaustion; 1000 HTTP clients/sec under load |
| Blocking I/O in Event Listener `onEvent()` | Q3 + C1 | Adds latency to every login/event-generating operation |
| Direct DB access bypassing Keycloak JPA | D3 + Q3 | Split transactions; connection pool exhaustion |
| Storing all events in Keycloak database | Q3 | `event_entity` barely indexed; bottleneck under load |
| ShadowJar/fat JAR bundling | D3 | `ServiceConfigurationError` from conflicting `META-INF/services` |
| Thread-unsafe state in ProviderFactory | Q3 | Race conditions across request threads |
| Missing input validation in custom authenticators | cross-ref | SQL/LDAP injection, SSRF via custom auth forms |
| Missing audit events in custom SPIs | Q4 | Custom actions invisible to event listeners and compliance |
| Missing authorization in custom REST endpoints | cross-ref | Unauthenticated API endpoints on Keycloak |
| Editable identity-linking attributes in User Storage | cross-ref | Users can impersonate other accounts |
| Protocol mapper with blocking external API call | Q3 + B1 | Adds latency to every token issuance |
| **Infrastructure & Operations** | | |
| Embedded H2 database in production | Q3 | Data loss on restart; no clustering; no HA |
| No clustering for production | Q3 + S4 | SPOF for all authentication; no failover |
| Mismatched DB pool sizes (initial ≠ min ≠ max) | Q3 | Pool resize overhead under load |
| Not setting `--proxy-headers` | Q3 | Incorrect redirect URLs, wrong issuer scheme |
| Management port 9000 exposed publicly | cross-ref | Health/metrics endpoint accessible to attackers |
| Admin console on same hostname as login | cross-ref | Admin API internet-reachable |
| Brute force protection disabled (default) | cross-ref | Unlimited login attempts; credential stuffing |
| Audit events disabled (default) | Q4 | No login/admin event records; forensics impossible |
| Plain LDAP without TLS for federation | cross-ref | Credentials transmitted in cleartext |
| No Keycloak version pinning/upgrade plan | D5 + S3 | frequent CVEs (e.g., 25 in 2024); unpatched = exploitable |
| Not running `kc.sh build` after adding SPI JARs | S1 | Provider not registered; silent failure |
| WildFly-based Keycloak in new deployments | Q3 + D5 | Legacy; 2x memory, 2x startup vs Quarkus |
| **Configuration Management** | | |
| Manual realm configuration (no GitOps) | S3 + Q4 | Configuration drift; no audit trail; no rollback |
| Realm export/import without validation | S1 | Silent data loss; secrets not exported by default |
| No Testcontainers in CI for SPI extensions | Q1 | SPI breaks on Keycloak upgrade discovered in prod |
