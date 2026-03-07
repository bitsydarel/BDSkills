# Domain classification guide

Use this guide to classify review targets and determine which domain reference(s) to load.

## Domain classification

When the review target spans multiple domains or is ambiguous, use this table:

| If the target... | Primary Domain | Also Load |
|-----------------|---------------|-----------|
| Is a web app with API backend | Web | API |
| Is a mobile app with API backend | Mobile | API |
| Is a microservices system | Distributed Systems | Cloud & Infrastructure, API |
| Is an ML model serving API | AI/ML | API, Cloud & Infrastructure |
| Deploys via CI/CD pipeline | (Primary domain) | CI/CD |
| Has IoT devices with cloud backend | IoT | Cloud & Infrastructure, API |
| Is a developer CLI tool | CLI | (add CI/CD if it interacts with pipelines) |
| Is a desktop app with web sync | Desktop | API, Web |
| Is a serverless application | Cloud & Infrastructure | API |

## Multi-domain review guidance

When reviewing a system that spans multiple domains:

1. **Load all relevant domain files** — Read the primary domain file first, then supplementary ones.
2. **Union the criteria interpretations** — If two domains weight the same criterion differently, use the stricter interpretation.
3. **Combine anti-patterns** — Check domain-specific anti-patterns from all loaded domains.
4. **Key controls are additive** — If both web and mobile domain files specify key controls, check all of them.
5. **Use the most demanding standard** — If the target is subject to both OWASP Web and OWASP API, check both lists.

## Multi-domain conflict resolution

When domain files give contradictory guidance, apply these resolution rules:

### Resolution rules

1. **Stricter control wins** — If Domain A requires TLS 1.3 and Domain B accepts TLS 1.2, enforce TLS 1.3. Security controls are resolved by taking the maximum.
2. **Broader scope wins** — If Domain A's attack surface includes browser-side threats and Domain B focuses on server-side only, the review must cover both. Attack surface is the union of all domains.
3. **Domain-specific criteria stay domain-specific** — Mobile certificate pinning is not required for the web dashboard. API rate limiting rules apply to the API, not the desktop client's local operations. Apply domain-specific controls to their respective domain boundaries.
4. **Shared components inherit the strictest domain** — An authentication service shared between web and mobile must meet the stricter requirement from either domain. Shared databases, API gateways, and auth services are evaluated against the most demanding consumer.
5. **Weighting conflicts use the primary domain** — When two domains suggest different weighting for the same criterion, use the primary domain's weighting for the overall score but note the secondary domain's perspective in the rationale.
6. **Anti-pattern overlap merges context** — If the same anti-pattern appears in two domain files with different descriptions, combine the signs, impacts, and detection methods from both.

### Common multi-domain scenarios

| Scenario | Domains | Key Conflict Points | Resolution |
|---------|---------|-------------------|------------|
| Mobile app + REST API | Mobile, API | Mobile requires certificate pinning; API requires rate limiting. Both need auth but mobile has biometric options | Apply cert pinning to mobile client, rate limiting to API. Auth evaluation covers both password and biometric paths |
| SPA + GraphQL API | Web, API | Web CSP conflicts with GraphQL introspection. Web XSS protections vs API query complexity limits | CSP applies to the SPA. Disable GraphQL introspection in production. Apply both XSS protections and query complexity limits |
| Microservices + CI/CD | Distributed Systems, CI/CD | Service mesh mTLS vs pipeline secret management. Container image signing spans both domains | mTLS evaluated under Distributed Systems. Pipeline secrets under CI/CD. Image signing evaluated once and referenced by both |
| IoT + Cloud + Mobile app | IoT, Cloud, Mobile | Device firmware updates, cloud API security, mobile app cert pinning. Three different auth models | Each domain's auth model evaluated separately. Shared backend API evaluated against the strictest consumer. Device-cloud trust boundary gets special attention |
| ML API + Web dashboard | AI/ML, Web, API | Model inference endpoint security, web dashboard auth, API rate limiting. Data privacy spans all three | Model-specific threats (adversarial input, data poisoning) under AI/ML. Dashboard under Web. API security for inference endpoint. Privacy evaluated holistically |
| Desktop app + Web sync + API | Desktop, Web, API | Local data encryption (desktop), CORS (web), API auth tokens. Update mechanism spans desktop and API | Desktop local security evaluated separately. CORS under Web. API auth is shared — evaluate once. Update mechanism requires code signing (desktop) and TLS (API) |

### Domain boundary identification

For each domain boundary in a multi-domain system, document:

1. **What crosses the boundary**: Data types, control messages, authentication tokens
2. **Trust level change**: Does data move from trusted to untrusted or vice versa?
3. **Validation required**: What validation must occur at this boundary?
4. **Applicable domain file**: Which domain's criteria govern this boundary?

Example for a mobile app with API backend:
- **Mobile → API boundary**: Auth tokens, user input, file uploads cross this boundary. Trust transitions from untrusted (device) to server-side. The API domain file governs validation. Certificate pinning (mobile domain) protects the transport.
- **API → Database boundary**: Queries, PII data. Trust transitions from application to data store. The primary domain file governs. Parameterized queries and encryption at rest required.
