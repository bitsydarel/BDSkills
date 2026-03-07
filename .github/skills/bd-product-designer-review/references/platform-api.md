# API / Developer Tools — Platform Heuristics

**Key references**: Stripe DX teardown, Google API Improvement Proposals (AIP), RFC 9457 Problem Details, RFC 8594 Sunset header

## Platform Complexity Checklist

A thorough API/DX review must evaluate:

- Documentation quality (3-column layout, interactive "try it", language-switching code examples, AI-readable structure)
- Error messages (RFC 9457: type/title/status/detail/instance; actionable fix suggestions; error catalogs)
- Authentication (time-to-first-authenticated-call; test/live key prefixes; multi-environment support)
- Rate limiting (X-RateLimit-* headers; Retry-After on 429; dashboard visibility; exponential backoff in SDKs)
- SDK design (idiomatic per language; type safety as priority; meaningful exceptions; backward compatibility; semver)
- API versioning (URL path most adopted; 6-month deprecation notice; `Sunset` header per RFC 8594; migration guides)
- Webhooks (exponential backoff with jitter; dead-letter queues; idempotent processing; event catalogs)
- Developer portal (guided onboarding; time-to-first-call metric; personalized dashboards; transparent pricing)
- Playground / sandbox (interactive testing; pre-populated examples; shareable sessions)
- CLI companion (for terminal-workflow developers; mirrors API capabilities)

## Dimension Interpretation Table

| Dim | Generic Meaning | API/DX Interpretation |
|-----|----------------|----------------------|
| 1 | Human-centered problem framing | Developer needs: "I want to charge a customer" not "POST /v1/payment_intents". Task-oriented, not endpoint-oriented |
| 2 | Usability & interaction quality | API ergonomics: consistent naming, predictable behavior, sensible defaults, idempotency, clear status codes |
| 3 | Information architecture | Documentation IA: getting started → tutorials → API reference → examples → migration guides. Searchable, navigable |
| 4 | Visual design & brand | Documentation design: 3-column layout, syntax highlighting, language switching, copy buttons, dark mode |
| 5 | User research & evidence | Developer research: time-to-first-call metrics, SDK analytics, developer surveys, support ticket analysis, community feedback |
| 6 | Accessibility & inclusivity | Documentation accessibility, screen reader support, keyboard navigation, API designed for diverse client capabilities |
| 7 | Service blueprint & journey | Developer journey: discover → evaluate → sign up → first call → integrate → scale → migrate versions → troubleshoot |
| 8 | Co-creation & facilitation | Community: RFC process for API changes, developer forums, open-source SDKs, public roadmap, beta programs |
| 9 | Prototyping & validation | Sandbox/playground environments, mock APIs for testing, staging environments, API explorer tools |
| 10 | Design system coherence | SDK coherence: consistent patterns across languages, API versioning strategy, backward compatibility, deprecation policy |

## Anti-Patterns (API/DX-Specific)

**1. Cryptic Errors**
- **Signs**: Generic "400 Bad Request" with no body, error codes without documentation, stack traces in production, no suggested fix, inconsistent error format across endpoints
- **Impact**: Developers waste hours debugging. Support tickets spike. Integration timeline extends. Developer trust erodes
- **Fix**: RFC 9457 Problem Details (type/title/status/detail/instance). Actionable suggestions in every error. Error catalog with searchable codes. Consistent format everywhere

**2. Documentation Drift**
- **Signs**: Code examples don't work, API behavior doesn't match docs, new parameters undocumented, deprecated features still shown, version mismatch between docs and API
- **Impact**: Documentation becomes untrusted. Developers resort to trial-and-error or reverse-engineering. Onboarding time multiplies
- **Fix**: Docs-as-code in same repo as API. Automated testing of code examples. Stripe's rule: "feature not shipped until docs written." Version-linked documentation

**3. Breaking in the Dark**
- **Signs**: API behavior changes without changelog, no deprecation warnings, no Sunset header, no migration guide, version bumps with undocumented breaking changes
- **Impact**: Production integrations break. Developer trust destroyed. Churn to competitors. "API stability" becomes an oxymoron
- **Fix**: Semantic versioning. 6-month deprecation window. `Sunset` header (RFC 8594). Migration guides. Changelog for every release. Deprecation warnings in API responses

**4. Auth Labyrinth**
- **Signs**: 10+ steps to get first API key, separate auth systems for test/live, OAuth flow required for simple use cases, no test credentials, token management unclear
- **Impact**: Time-to-first-call is the #1 predictor of API adoption. Complex auth = high drop-off. Developers evaluate within 15 minutes
- **Fix**: Test API key in 2 clicks. `sk_test_` / `sk_live_` prefix convention (Stripe pattern). Copy-pasteable quickstart. OAuth only when truly needed

**5. Undiscoverable API**
- **Signs**: No getting-started guide, API reference is auto-generated Swagger with no context, no tutorials, no code examples in target languages, no SDKs
- **Impact**: Only developers who already know the API can use it. New developer adoption stalls. Community can't self-serve
- **Fix**: 3 layers: Getting Started (5 min) → Tutorials (task-based) → API Reference (complete). Code examples in top 3-5 languages. Official SDKs. Interactive playground

## Key Heuristics

1. **Time-to-first-call is everything** — A developer should make a successful API call within 5 minutes of finding your docs
2. **Errors are features** — Every error message should tell the developer what went wrong, why, and how to fix it
3. **Docs are the product** — Documentation IS the user interface. Treat it with the same rigor as your API code
4. **Consistency is kindness** — Same naming conventions, same error format, same pagination pattern, across every endpoint
5. **Deprecate, don't delete** — Sunset headers, migration guides, deprecation warnings. Never break silently

## How Top Companies Do It

| Company | Practice |
|---------|----------|
| **Stripe** | Feature not shipped until docs written; 3-column docs; `sk_test_`/`sk_live_` key prefixes; structured errors with doc links; idempotency keys |
| **Twilio** | DX spectrum (working → seamless → magical); per-language quickstarts; helper libraries with semantic method names |
| **GitHub** | REST + GraphQL dual API; `gh` CLI with built-in JSON/JQ; automatic auth; extensive webhooks with event catalog |
| **Google Cloud** | 200+ API Improvement Proposals (google.aip.dev); ErrorInfo in every error; consistent resource-oriented design |
| **AWS** | CDK for IaC; CloudFormation IDE experience; Stack Refactoring; comprehensive SDK coverage |
| **Vercel** | Zero-config deployment; preview URLs per PR; 100K+ monthly signups; developer-first onboarding |
