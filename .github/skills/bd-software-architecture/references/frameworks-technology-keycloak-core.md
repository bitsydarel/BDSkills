# Technology context: Keycloak — Core Architecture

Keycloak-specific core architecture patterns: role in system architecture, integration design, authentication flows, realm configuration, token architecture, and security configuration. Load this file when the system under review uses Keycloak as its identity provider. For operational guidance (reverse proxy, HA, SPI, federation, performance, enterprise patterns), see [frameworks-technology-keycloak-operations.md](frameworks-technology-keycloak-operations.md). For observability and anti-patterns, see [frameworks-technology-keycloak-antipatterns.md](frameworks-technology-keycloak-antipatterns.md). Keycloak is an external infrastructure dependency — it maps to Lenses 1-5 (D/C/B/Q/S), not Lens 6 (DA). For security-specific OAuth 2.0/OIDC controls, see the bd-security-review skill's A1, domain-web.md, domain-api.md, and domain-distributed-systems.md.

## Keycloak's Role in System Architecture

**Authorization Server in OAuth 2.0 / OIDC** (D2, D5):
- Centralizes identity so applications never handle login forms or credential storage
- Token-based security: JWT ID Tokens + Access Tokens. Downstream services verify locally via JWK Set URI — no per-request call to Keycloak
- Zero Trust foundation: every API request carries a scoped, cryptographically verifiable token
- Supported protocols: OIDC, OAuth 2.0, SAML 2.0 — all open standards preventing vendor lock-in
- D2: Keycloak is a concrete external dependency — wrap behind an `AuthService` abstraction
- D5: vendor lock-in contained to auth adapter layer — swapping to Auth0/Cognito/Okta must not touch domain or use case code
- Anti-pattern: Importing Keycloak SDK directly in use cases/domain (D3 violation — framework in business logic)

## Integration Architecture

**Wrapping Keycloak behind abstractions** (D2, D3, D5, C4):
- Wrap Keycloak behind an `AuthService` interface — `KeycloakAuthServiceImpl` in auth adapter module
- Keycloak client libraries (`keycloak-spring-boot-starter`, `python-keycloak`, `keycloak-js`) confined to auth adapter — never imported in use cases or domain
- D3: domain models use auth concepts (`User`, `Role`, `Permission`), not Keycloak types (`KeycloakSecurityContext`, `AccessToken`)
- C4: auth module exports `AuthService` interface only — Keycloak types, token parsers, realm configs are private internals
- Use native framework OAuth2/OIDC support (Spring Security 5+, `passport-openidconnect`, etc.) rather than vendor-specific adapters
- Anti-pattern: Deprecated Keycloak Spring Adapter (D3+D5 — vendor-specific library retired in Keycloak 17, no maintenance)

## Authentication Flows & Protocol Selection

**Flow selection** (D5, S3):
- **Authorization Code Flow + PKCE** — recommended for all browser-based and mobile applications. App redirects to Keycloak, receives authorization code, exchanges on backend for tokens. PKCE mandatory for public clients (SPAs, mobile)
- **Client Credentials Grant** — M2M / service-to-service. Headless backend authenticates with client ID + secret
- **Direct Grant disabled by default** — Keycloak enables Direct Grant on new clients; immediately disable for all browser/user-facing clients. MUST NOT be used per OAuth 2.0 Security BCP
- D5: choose standard OAuth 2.0/OIDC flows to avoid protocol-level lock-in
- S3: document flow selection in an ADR
- Anti-pattern: Implicit Flow (deprecated in OAuth 2.0 Security BCP, removed from OAuth 2.1 — tokens in URL leak via browser history, logs, open redirects. CVE-2023-6927 exploited redirect URI bypass)
- Anti-pattern: Password Grant / ROPC (defeats centralized auth purpose, trains users to give credentials to client apps)
- Anti-pattern: Frontend Token Exposure — SPA storing tokens in localStorage/sessionStorage vulnerable to XSS. Use **Backend-for-Frontend (BFF) pattern**: backend acts as confidential client, manages tokens server-side, issues secure session cookies to browser

## Realm & Client Configuration

**Realm and client design** (B4, S2):
- **Realms** as logical domain boundaries — isolate users, credentials, roles, groups. Multi-tenant architecture choices:
  - One realm per tenant: clean isolation, but performance degrades beyond ~100 realms (Cloud-IAM, Phase Two documented this)
  - Organizations feature (Keycloak 25+): tenant isolation within a single realm — recommended for SaaS with many tenants
- **Never use Master realm** for applications — Master is for Keycloak administration only. Application tokens from Master have administrative adjacency
- **Strictly limit redirect URIs** — exact URI matching in production. Never use wildcard `*`. CVE-2023-6927 exploited wildcard URI bypass. `http://localhost` redirect URIs are a pentest finding (token theft via local app)
- **Full Scope Allowed = OFF** — default is ON, which includes ALL user roles from ALL clients in every token. Disable and explicitly map only needed roles per client (least privilege)
- **Audience validation** — configure `aud` claim mapper per client. Without it, a token for Client A can be used against Client B's API (horizontal privilege escalation)
- **Scopes and mappers**: include only the attributes/roles the client needs. Don't leak user data via overly broad token claims
- **Client templates** for shared configuration across many clients
- Anti-pattern: Reusing Master realm (S2 — administrative exposure)
- Anti-pattern: `Full Scope Allowed = ON` (default) leaking all roles into every token
- Anti-pattern: Missing `aud` validation enabling cross-client token reuse
- Anti-pattern: `offline_access` scope granted to user-facing apps (tokens survive logout and server restart — intended for server-to-server only)
- Anti-pattern: One realm per tenant at scale >100 (performance degradation — use Organizations feature)

## Token Architecture & Data Flow

**Token lifecycle** (B1, B2, B3, Q3):
- B1: trace auth data flow — request → token validation → parsing → domain `AuthContext` → use case → response
- B2: Keycloak JWT → domain `AuthContext` at adapter boundary. Token structures never flow into use cases
- B3: catch Keycloak exceptions (`InvalidTokenException`, `TokenExpiredException`, `ServerUnavailableException`) at adapter boundary → translate to domain exceptions (`AuthenticationExpiredException`, `UnauthorizedException`)
- **JWT vs opaque tokens**: JWTs enable local validation via JWKS endpoint — no per-request Keycloak call. Opaque tokens require per-request introspection
- **Token lifetime hierarchy**: `Access Token Lifespan` < `SSO Session Idle` < `SSO Session Max`. Violating this hierarchy causes tokens valid longer than their parent session
- **Short-lived access tokens**: 5 minutes recommended (Keycloak default). Never extend to hours/days. Long-lived tokens cannot be revoked without key rotation
- **Refresh token rotation**: enable to invalidate old refresh tokens on use — detects token theft via replay
- **Signing key rotation**: rotate RSA signing keys every 3-6 months. Delete passive keys 1-2 months after creating new ones
- Anti-pattern: Distributed Introspection Bottleneck (Q3+B1 — opaque tokens forcing every microservice to call introspection endpoint). Use JWTs or Phantom Token Pattern (API gateway introspects once, forwards JWT internally)
- Anti-pattern: Leaking Keycloak product name in URLs (S2 — `/keycloak/auth` exposes vendor, complicates migration)
- Anti-pattern: Access token lifespan > SSO session idle (breaks session lifecycle)
- Anti-pattern: No refresh token rotation (stolen refresh token usable indefinitely)

## Security Configuration

Architectural security decisions relevant to Keycloak. For detailed security controls, vulnerability analysis, and secure coding checklists, see the bd-security-review skill's A1, domain-web.md, domain-api.md, and domain-distributed-systems.md.

**Admin and access controls** (cross-ref bd-security-review):
- **Admin console separation** (Red Hat recommendation): `KC_HOSTNAME_ADMIN` on separate internal hostname from public frontend. Block admin API at reverse proxy for public traffic
- **Brute force protection** — disabled by default. Must be explicitly enabled in Realm Settings > Security Defenses > Brute Force Detection
- **MFA enforcement** — TOTP, WebAuthn/FIDO2. Required for admin accounts at minimum. Architecture decision: require MFA for sensitive user operations
- **Password policies** — enforce complexity, expiration, reuse prevention, username exclusion via Admin Console
- **Event auditing** (Q4): both Login Events and Admin Events disabled by default. Must enable "Save Events" and "Save Admin Events" in Realm Settings. Critical for compliance (SOC 2, GDPR) and breach detection
- **User self-registration** — if enabled, pair with mandatory email verification. Without it: account enumeration, fake accounts, social engineering
- **Server-side JavaScript** — disable unused Keycloak execution features to reduce attack surface
- **Disable Direct Grant** on all user-facing clients immediately after creation (enabled by default in admin UI)
