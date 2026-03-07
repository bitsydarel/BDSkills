# Technology context: Keycloak — Operations & Infrastructure

Keycloak operational architecture: reverse proxy, high availability, SPI extensibility, user federation, performance tuning, and enterprise patterns. For core architecture (role, integration, flows, realm, tokens, security), see [frameworks-technology-keycloak-core.md](frameworks-technology-keycloak-core.md). For observability and anti-patterns, see [frameworks-technology-keycloak-antipatterns.md](frameworks-technology-keycloak-antipatterns.md).

## Reverse Proxy & Network Configuration

**Proxy setup** (Q3, S1):
- **`--proxy-headers` option**: set to `xforwarded` or `forwarded` — without it, Keycloak ignores X-Forwarded-* headers, producing incorrect redirect URLs, wrong scheme (http vs https) in token issuers, 403 errors
- **nginx pitfall**: use `proxy_set_header X-Forwarded-For $remote_addr;` (replace), not `proxy_add_x_forwarded_for` (append allows header spoofing)
- **Port 9000** (management/metrics): never proxy to public internet. Internal only for health checks and Prometheus scraping. Only proxy port 8443 (or 8080 for edge TLS termination)
- **Edge TLS termination**: when TLS terminates at load balancer, set `KC_HTTP_ENABLED=true` on Keycloak
- **Sticky sessions**: enable at load balancer for public-facing endpoints (hash on `AUTH_SESSION_ID` cookie). Backchannel requests (token refresh via API) cannot use sticky sessions — require proper distributed cache replication
- Anti-pattern: Not setting `--proxy-headers` (incorrect redirect URLs, wrong issuer scheme)
- Anti-pattern: Exposing management port 9000 through reverse proxy

## High Availability & Deployment

**Production infrastructure** (Q3, S3, D5):
- **Quarkus-based distribution** (since Keycloak 17) — 10x faster startup, lower memory than legacy WildFly
- **External PostgreSQL for production** — H2 is dev-only. Supported production databases: PostgreSQL 17, MySQL 8.4, MariaDB 11.4, Oracle 23.5, SQL Server 2022
- **Database connection pool**: set `db-pool-initial-size = db-pool-min-size = db-pool-max-size` (e.g., all = 20-100). Unequal values cause pool resize overhead under load. Set `db-pool-max-lifetime` < database `wait_timeout` to avoid stale connection exceptions
- **Database connection TLS**: always enable SSL/TLS for Keycloak-to-database connections
- **Infinispan clustering**: distributed caching for sessions, auth tokens, login failures. Cache encryption with AES/GCM. Configure `owners=2` for replication. JGroups discovery via DNS_PING (K8s), JDBC_PING (multi-DC), or TCPPING (cross-datacenter)
- **Kubernetes deployment**: Keycloak Operator handles rolling updates, TLS certs, StatefulSet management. Operator does NOT manage the database — provision externally. Bootstrap admin account (`temp-admin`) must be deleted after setup
- **K8s RBAC**: anyone with rights to create/edit Keycloak CRs has effective admin access — restrict namespace RBAC tightly
- **HPA**: `minReplicas: 3`, `maxReplicas: 10`, `targetCPUUtilization: 75%`. Resources: 500m-2000m CPU, 512Mi-2048Mi memory per pod
- **Multi-cluster HA**: external Infinispan per site, cross-site replication, separate load balancers. Single-cluster (multiple AZs) recommended as starting point
- **Performance benchmarks** (Keycloak 26.4): ~15 password logins/sec/vCPU, ~120 client credential grants/sec/vCPU, ~120 refresh token requests/sec/vCPU. Allocate 150% CPU headroom for spikes. JVM: G1GC, 70% heap, 300MB non-heap
- **Memory sizing**: ~1,250 MB per pod managing 10,000 cached sessions
- **Version management** (D5): pin version, subscribe to security advisories, upgrade within support window. Keycloak has frequent CVEs (e.g., 25 in 2024 including CRITICAL CVE-2024-3656)
- S3: document deployment decision in ADR — self-hosted vs managed (Red Hat SSO, Cloud-IAM, Phase Two) vs alternative IdP
- Anti-pattern: H2 database in production (Q3 — data loss on restart, no clustering)
- Anti-pattern: No Keycloak clustering (Q3+S4 — SPOF for all authentication)
- Anti-pattern: Mismatched connection pool sizes causing resize overhead
- Anti-pattern: Not testing rolling updates in staging before production

## SPI Architecture & Extensibility

**Service Provider Interface design** (D2, D3, D5, C1, C4, S4):
- **Two-object model**: ProviderFactory (server-scoped singleton, manages heavy shared resources in `init()`) + Provider (request-scoped lightweight object created per `KeycloakSession`). This separation is the most critical SPI design principle
- **Key SPI types**: Authenticator SPI (custom login flows), User Storage SPI (external user stores), Event Listener SPI (audit/webhooks), Protocol Mapper SPI (custom token claims), Required Action SPI (post-auth steps), REST Resource SPI (custom endpoints), Identity Provider SPI (custom IdPs), Theme SPI (multi-tenant theming), Policy SPI (custom authorization), Action Token SPI (magic links), Vault SPI (secrets), Credential SPI (custom MFA), Token Exchange SPI
- **Deployment model (Quarkus, v17+)**: JARs in `providers/` directory, `kc.sh build` after adding new JARs (ahead-of-time compilation), no hot deployment of Java code
- **Configuration**: `spi-{spi-name}--{provider-id}--{property}` in keycloak.conf or `KC_SPI_*` env vars. Vault references (`${vault.key}`) for secrets
- **Provider priority**: override built-ins via `order()` method returning higher value than built-in implementation
- D2: SPI implementations are concrete dependencies — contain behind adapter layer
- D3: custom SPIs must not import `keycloak-services` or `keycloak-server-spi-private` (internal APIs). Depend only on `keycloak-server-spi` (public). Internal APIs break across major versions
- D5: SPI extensions contained to auth infrastructure module — business logic unaware of SPI existence
- C1: each SPI provider has single responsibility — authenticator handles auth, event listener handles events, protocol mapper handles claims
- C4: SPI implementations are private internals of the auth module — never exported
- S4: new capabilities (custom MFA, federation, analytics) added by implementing new SPIs — no modification of existing code (OCP)

**SPI best practices** (enterprise-validated):
- Initialize heavy resources (HTTP clients, connection pools, thread pools) in `ProviderFactory.init()`, inject into providers — never create per-request
- Event listeners: enqueue work to async executor, execute after Keycloak transaction commits — never block `onEvent()` with synchronous I/O (Phase Two pattern: transaction-committed scheduling)
- User Storage SPI: choose import vs non-import strategy based on scale. Import strategy causes multiple DB writes per first login — problematic above 100K users
- Protocol mappers: cache external API responses per user session (`userSession.setNote()`) — mappers run on every token issuance critical path
- REST Resource SPI: **must** implement authorization checks manually — Keycloak does NOT auto-enforce admin access on custom endpoints
- Use `JpaEntityProvider` for custom DB tables — never create separate JDBC connections (bypasses Keycloak transaction management)
- Test with `dasniko/testcontainers-keycloak` — the community standard for SPI integration testing
- Never forward events to Keycloak's own database at scale — `event_entity` table is barely indexed, `admin_event_entity` is not indexed at all (official warning)

**SPI anti-patterns:**
- Combined ProviderFactory+Provider in one class → lifecycle collision, `close()` ambiguity, shared resources released after first request
- Creating heavy objects (HTTP clients, JDBC connections) per request in `create()` → file descriptor exhaustion under load
- Blocking I/O in Event Listener `onEvent()` → adds latency to every login/event-generating operation
- Direct database access bypassing Keycloak's JPA `EntityManager` → split transactions, connection pool exhaustion
- Tight coupling to internal APIs (`keycloak-services`, `keycloak-server-spi-private`) → breaks on every major version (WildFly→Quarkus migration, RESTEasy Classic→Reactive migration, model interface changes)
- Thread-unsafe state in ProviderFactory (the singleton) instead of Provider (per-request) → race conditions
- ShadowJar/fat JAR bundling → `ServiceConfigurationError` from conflicting `META-INF/services` files
- Missing input validation in custom authenticators → injection vectors (SQL, LDAP, SSRF)
- Storing all events in Keycloak database → performance bottleneck (barely indexed tables)
- Missing audit event emission in custom SPIs → custom actions invisible to event listeners

**Enterprise SPI patterns** (from Phase Two, Cloud-IAM, CERN, Croatia Telecom):
- Phase Two `keycloak-orgs`: single-realm multi-tenancy via Organization SPI
- Phase Two `keycloak-events`: production-grade webhooks with HMAC-SHA256 signing, exponential backoff, multi-listener support
- Kafka event listener: factory initializes Kafka `Producer` in `init()`, `onEvent()` calls non-blocking `producer.send()`
- Custom authenticator flows: risk-based step-up MFA, magic link via Action Token SPI, conditional authenticators
- External API protocol mappers: HTTP client in factory, cached responses per user session, mandatory timeouts, graceful degradation
- LDAP + custom DB hybrid federation: chain multiple User Storage providers, Keycloak loops until one returns a user
- Croatia Telecom: OAuth 1.0a compatibility layer via custom SPI, all customizations as separate plugins for clean upstream upgrades

## User Federation & Identity Brokering

**External identity integration** (D5, S4):
- **LDAP/AD federation**: use `ldaps://` or StartTLS — never plain `ldap://` (credentials in cleartext). Set edit mode to `READ_ONLY` unless write-back is required. Enable pagination for large directories (batch size 1000)
- **User Storage SPI import strategy**: on first lookup, local copy created in Keycloak JPA store. Sync via `ImportSynchronization`. Warning: "looking up a user for the first time using the import strategy will require multiple updates to the Keycloak database, which can be a big performance loss under load" (official docs)
- **User Storage SPI non-import strategy**: every lookup queries external system. No local copy. Pro: always fresh. Con: external system downtime = login failure
- **Cache policy**: `EVICT_WEEKLY`, `EVICT_DAILY`, `MAX_LIFESPAN`, or `NO_CACHE` based on data volatility
- **Identity brokering** (Social Login): Keycloak proxies authentication to external IdPs (Google, GitHub, corporate SAML/OIDC). Architecture decision: first login flow determines how external identities map to Keycloak users
- **eIDAS integration** (EU): GRNet's open-source Keycloak extension supports extended SAML 2.0 dialect for EU national eIDs
- S4: new federation providers added by extending Keycloak's User Storage SPI — no modification of existing auth logic
- Anti-pattern: User Storage SPI with import strategy but no synchronization → stale user data
- Anti-pattern: Editable identity-linking attributes → users can impersonate other accounts (official security warning)

## Performance Tuning

**JVM and resource sizing** (Q3):
- **JVM GC selection**: G1GC (default, 4-10ms pauses), ZGC (preferred for low-latency, <1ms pauses, JDK 21+), Shenandoah (1-10ms, good for cloud-native)
- **Heap sizing**: 70% of container memory limit for heap, ~300MB for non-heap. Keep `-Xms = -Xmx` to prevent heap resizing. Minimum viable pod: 1,250 MB RAM
- **DB connection pool formula**: set `db-pool-initial-size = db-pool-min-size = db-pool-max-size` (e.g., all = 20-100). Set `db-pool-max-lifetime` < database `wait_timeout`
- **Infinispan cache tuning**: `owners=2` for replication, AES/GCM cache encryption, distributed vs replicated based on cluster size. L1 cache for frequently accessed entries
- **HTTP max queued requests**: set `http-max-queued-requests` to prevent request storms
- **Authentication session limits**: `--spi-authentication-sessions-infinispan-auth-sessions-limit=100` to bound per-client auth sessions
- **Official benchmarks (Keycloak 26.4, ROSA eu-west-1)**: ~15 password logins/sec/vCPU, ~120 client credential grants/sec/vCPU, ~120 refresh token requests/sec/vCPU. DB IOPS: ~1,400 write IOPS per 100 login/logout/refresh req/sec on Aurora PostgreSQL Multi-AZ
- **Startup optimization**: Quarkus build-time configuration (`kc.sh build`) + `--optimized` flag at runtime skips provider re-scanning
- **Session scaling**: ~1,250 MB per pod managing 10,000 cached sessions. HPA: `minReplicas: 3`, `maxReplicas: 10`, `targetCPUUtilization: 75%`

## Enterprise Architecture Patterns

**Integration patterns** (D2, D5, Q3, S1, S3):
- **API Gateway + Keycloak** (Kong, NGINX, Traefik): gateway validates JWT via JWKS endpoint, microservices receive pre-validated identity. Browser → Keycloak (authenticate) → JWT → Gateway (validate) → microservice
- **Service Mesh + Keycloak** (Istio/Envoy — NVIDIA, Red Hat reference): `RequestAuthentication` policy references Keycloak JWKS, Envoy sidecar validates JWT on every inbound request, `AuthorizationPolicy` enforces RBAC from JWT claims, mTLS between services. Zero-touch security — no auth code in app services
- **Zero Trust stack** (Keycloak 26.2+): Keycloak (IdP + token issuer) + Istio (mTLS mesh) + OPA (fine-grained authz) + Vault (secrets) + Envoy (JWT validation). Token Exchange (stable in 26.2) enables narrow, least-privilege tokens scoped to specific downstream services
- **GitOps for Keycloak config**: `keycloak-config-cli` (YAML-based declarative config, most widely used), Terraform `mrparkers/keycloak` provider (51% adoption), Keycloak Operator CRDs (`KeycloakRealmImport`), ArgoCD for K8s deployment. Split into two repos: infrastructure (pods, DB) and configuration (realms, clients, roles)
- **CI/CD pipeline pattern**: realm config exported as JSON → Git → PR triggers ephemeral Keycloak container (Testcontainers) → integration tests → on merge: config applied to production via ArgoCD
- **Multi-datacenter patterns** (Red Hat HA Guide):
  - Single-cluster multi-AZ: synchronous Infinispan replication, Aurora PostgreSQL Multi-AZ
  - Active-Active multi-region: external Infinispan with cross-DC replication (Gossip Router), <10ms latency required. Auth sessions NOT replicated by design — users re-authenticate on site failover
  - Active-Passive: primary handles traffic, passive receives DB replication only
- S3: document architecture pattern decisions in ADRs — API gateway vs service mesh, GitOps tool selection, multi-DC strategy

## Enterprise Adoption Reference

Validated production deployments (architecture evidence, not endorsements):
- **CERN**: 300K users, 13K clients. Kerberos + AD + TOTP/WebAuthn + eduGAIN federation. Migrated to K8s with externalized Infinispan. 99%+ uptime through migration
- **Hitachi**: FAPI 1.0 Advanced Final certification for Japanese banking. Client Policies feature enables single-step FAPI compliance. Mutual-TLS + PAR + JARM
- **NVIDIA**: Istio service mesh + Keycloak as OIDC provider. JWT validation at Envoy sidecar level. Used across datacenter services, NVFlare federated learning, AI workflows
- **US DoD Platform One**: Keycloak with CAC/Smart Card x509 authentication, PKI validation, Zero Trust stack
- **BRZ Austria**: 2M+ users, 130+ government services. Largest EU government Keycloak deployment
- **Deutsche Telekom / Croatia Telecom**: 20+ apps migrated, custom SPIs for OAuth 1.0a backward compatibility, all customizations as separate SPI plugins
- **SAP ecosystem**: Keycloak as external IdP for SAP BTP via OIDC/SAML, SAP Kyma Runtime deployment. Strategic migration target for SAP IDM end-of-maintenance (2028)
- **Red Hat RHBK**: Quarkus-based, FIPS 140-2 mode, pricing by CPU core (not MAU), LTS releases with security backports
