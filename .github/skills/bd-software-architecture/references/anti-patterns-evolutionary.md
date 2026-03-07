# Anti-patterns: Structural Integrity (Lens 5)

Architecture failure modes related to structural enforcement, decision documentation, evolutionary readiness, and long-term maintainability. Each pattern includes Signs, Impact, Fix, and Detection guidance.

---

## Big Ball of Mud [Critical]

No discernible architecture. Code is organized arbitrarily with no consistent structure, no layer separation, and no module boundaries. The system works through accidental coupling rather than intentional design. Named by Brian Foote and Joseph Yoder (1997).

**Signs**:
- No consistent directory structure — files organized by convenience, not by architectural role
- Any file can import any other file — no dependency constraints
- Business logic, data access, and UI code mixed in the same files
- No separation between features — all code shares the same namespace/package
- New developers cannot determine where to put new code
- "It works but nobody knows how" — the system's behavior is emergent, not designed

**Impact**:
- Every change is high-risk — blast radius is unpredictable
- Cognitive load is maximum — understanding any part requires understanding the whole
- Testing is impossible without the full system running
- Onboarding takes months instead of weeks
- Technical debt compounds exponentially — each addition makes the structure worse
- Eventually, the team discusses rewriting the system from scratch

**Fix**:
- Start with the Strangler Fig pattern: identify a feature boundary and extract it into a clean module with proper layers
- Introduce architecture incrementally — do not attempt a full rewrite
- Establish module boundaries with lint rules or physical structure before refactoring business logic
- Create ADRs for the target architecture and migration plan
- Prioritize extraction by business value: start with the features that change most frequently

**Detection**:
- Draw the dependency graph — if it looks like a mesh (every node connected to every other node), it is a Big Ball of Mud
- Ask: "Where does a new feature go?" If there is no clear answer, there is no architecture
- Attempt to test one component in isolation — if it requires loading the entire codebase, the architecture is absent

---

## Architecture Astronaut [Major]

Over-engineered architecture that introduces layers, abstractions, and patterns far beyond what the problem requires. The architecture serves the architect's ambition, not the team's needs. Named by Joel Spolsky (2001).

**Signs**:
- 6+ layers of abstraction for a CRUD application
- Abstract factories, dependency injection, event sourcing, CQRS, and microservices in a 5-person project
- New team members need weeks to understand the architecture before making any change
- Adding a simple field requires touching 8+ files across multiple layers
- Architecture conversations dominate sprint planning
- Generic patterns used for everything (e.g., event bus for synchronous method calls)
- The architecture is discussed more than the product

**Impact**:
- Development velocity is slow — simple changes take disproportionate effort
- Cognitive overhead is high — the architecture is harder to understand than the business logic
- The team spends more time maintaining the architecture than building features
- Abstractions obscure rather than clarify the codebase
- New team members are intimidated and confused

**Fix**:
- Apply YAGNI (You Aren't Gonna Need It): remove abstractions that do not serve a current, concrete need
- Count files touched per typical feature change — if >5 for a simple CRUD operation, simplify
- Ask for each abstraction: "What concrete problem does this solve today?" Remove abstractions that solve hypothetical future problems
- Match architecture complexity to system complexity — a Simple system does not need Enterprise architecture

**Detection**:
- Count layers: >4 for a standard application warrants scrutiny
- Count files per simple feature change: >5 suggests over-engineering
- Review abstractions: are they solving real problems or hypothetical ones?
- Ask developers: "If you could remove one layer, which would it be and why?" — the consensus reveals the unnecessary layer

---

## Premature Abstraction [Minor]

Creating abstractions (interfaces, base classes, generic frameworks) before the need is proven by at least two concrete use cases. The abstraction often does not fit when the second case arrives, requiring a rewrite of both the abstraction and its first consumer.

**Signs**:
- Interfaces with exactly one implementation (and no plan for a second)
- Base classes created "for extensibility" with one subclass
- Generic framework code written for a single use case
- Abstractions that were designed to handle cases that never materialized
- Comments like "this will be useful when we add X" where X has no timeline

**Impact**:
- Unnecessary indirection makes the code harder to follow
- The abstraction may not fit the second use case when it arrives (wrong assumption about the axis of variation)
- Maintenance cost of the abstraction plus its single consumer is higher than the concrete version would be
- Can evolve into Architecture Astronaut when compounded across the codebase

**Fix**:
- Wait for two or three concrete cases before abstracting (Rule of Three)
- Replace premature abstractions with concrete implementations — abstract when the second use case arrives
- If an interface has one implementation and no concrete plan for more, consider removing it
- Exception: interfaces required for dependency injection are justified even with one implementation (they enable testing)

**Detection**:
- Search for interfaces with exactly one implementation (exclude DI-motivated interfaces)
- Review base classes with one subclass — are they justified by testing needs?
- Check git history: how old is the abstraction, and has a second use case ever appeared?

---

## Documentation Drift [Minor]

Architecture documentation (diagrams, ADRs, wikis, design docs) no longer matches the implemented system. Developers rely on code reading rather than documentation, and new team members are misled by outdated docs.

**Signs**:
- Architecture diagrams show layers, components, or boundaries that do not exist in code
- ADRs describe decisions that have been superseded without updating the record
- Wiki pages reference deprecated patterns or technologies
- New developers are confused because documentation contradicts code
- Team members say "ignore that wiki page, it is outdated"
- README architecture section describes the initial plan, not the current state

**Impact**:
- Documentation is worse than no documentation — it actively misleads
- New team members learn the wrong architecture, then must unlearn it
- Audits and compliance reviews produce incorrect conclusions
- Architecture reviews based on documentation miss the actual state

**Fix**:
- Treat documentation as code: review it in PRs, update it when code changes
- ADRs should be immutable — when a decision is superseded, add a new ADR referencing the old one (Status: Superseded by ADR-042)
- Keep architecture documentation close to the code (in the repo, not a separate wiki)
- Use architecture fitness functions that validate documentation against code structure
- Reduce documentation to what is actively maintained — less but accurate is better than comprehensive but wrong

**Detection**:
- Compare architecture diagrams to actual module structure — do they match?
- Check ADR dates: are there recent ADRs, or did documentation stop years ago?
- Ask a recent hire: "Was the documentation helpful or misleading?"

---

## Lava Flow [Major]

Dead code, deprecated patterns, and abandoned experiments remain in the codebase because nobody is sure whether they are still needed. Named for code that has "cooled and hardened" — once flowing, now immovable and surrounded by new growth.

**Signs**:
- Files or modules with no references from the active codebase
- Multiple versions of the same pattern coexisting (old pattern and new pattern)
- Comments like "TODO: remove after migration" from years ago
- Conditional logic for features that were never launched or have been removed
- Developers are afraid to delete code because "it might be used somewhere"
- Configuration flags for long-completed A/B tests

**Impact**:
- Cognitive load increases — developers must determine which code is active vs dead
- Build times increase with dead code
- Security vulnerabilities in dead code are still exploitable if the code is compiled/deployed
- Code navigation is harder — search results include irrelevant dead code
- New developers study abandoned patterns thinking they are current

**Fix**:
- Use dead code analysis tools to identify unreferenced files, functions, and classes
- Delete dead code — version control preserves history if it is ever needed
- When migrating patterns, set a timeline for removing the old pattern and enforce it
- Remove feature flags for completed experiments
- Document in ADRs when old patterns are superseded, and schedule removal

**Detection**:
- Run dead code analysis (tree-shaking, unreferenced symbol detection)
- Search for TODO comments older than 6 months
- Look for multiple implementations of the same concept (old and new)
- Check feature flags: are any for experiments that concluded months/years ago?

---

## API Versioning Neglect [Major]

No strategy for evolving public APIs (between features, between services, or external). Breaking changes are introduced without versioning, backward compatibility, or migration paths. Consumers break on every update.

**Signs**:
- Public API changes break consumers without warning
- No API versioning scheme (URL versioning, header versioning, semantic versioning)
- Breaking changes committed without a migration guide or deprecation period
- Multiple features broken by a single API change
- No distinction between public and internal APIs — everything is treated as internal
- Consumers pin to specific implementations because the API is unstable

**Impact**:
- Consumers cannot update independently — they must coordinate with every API change
- Trust in the API erodes — consumers avoid updating
- Feature teams are blocked by uncoordinated API changes
- In distributed systems, synchronized deployments become necessary (distributed monolith symptom)

**Fix**:
- Define clear public API boundaries for each feature and service
- Implement an API versioning strategy (semantic versioning for libraries, URL/header versioning for HTTP APIs)
- Follow a deprecation policy: announce deprecation, provide migration path, remove after grace period
- Use contract tests to verify API compatibility between consumers and providers
- Treat internal public APIs (between features) with the same discipline as external APIs

**Detection**:
- Review recent changes to public APIs: were consumers notified? Were breaking changes versioned?
- Check for contract tests or API compatibility checks in CI/CD
- Ask: "Can Feature A update its API without coordinating with Feature B?" If not, versioning is neglected
