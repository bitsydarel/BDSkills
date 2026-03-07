# Anti-patterns: Component Design (Lens 2)

Architecture failure modes related to component responsibility, naming, composition, and domain model design. Each pattern includes Signs, Impact, Fix, and Detection guidance.

---

## Logic in Presentation [Critical]

Business decisions, validation rules, or data transformation logic placed in the presentation layer (views, controllers, state management) instead of in use cases. The UI becomes the application — business logic is untestable, unreusable, and changes with every UI redesign.

**Signs**:
- View/controller files contain `if/else` chains that make business decisions (e.g., "if user has premium account AND trial not expired AND region allows feature, show button")
- State management (BLoC, Redux, ViewModel) contains business logic beyond UI state orchestration
- Business validation rules duplicated across multiple UI components
- Presentation components directly call repositories or data sources, bypassing use cases
- Business logic changes require modifying UI files
- The same business rule is implemented differently in different UI components

**Impact**:
- Business logic is coupled to the UI framework — untestable without UI testing tools
- Rules cannot be reused across different interfaces (web, mobile, CLI, API)
- UI redesigns risk breaking business logic
- Business rule changes require finding and updating every UI component that implements them
- No single source of truth for business rules — duplicated logic drifts out of sync

**Fix**:
- Extract all business decisions into use cases
- Presentation layer should only: receive user input, call use cases, display results
- State management should orchestrate UI state transitions, not business logic
- If a `if/else` in the UI references domain concepts (accounts, permissions, business rules), it belongs in a use case

**Detection**:
- Review presentation files for domain-specific conditionals (business entity references, permission checks, calculation logic)
- Count lines of business logic in presentation vs use case layers — the ratio reveals the problem
- Ask: "If I rewrote the UI from scratch, would I need to re-implement any business rules?" If yes, logic is in presentation
- Check if UI tests verify business outcomes rather than display behavior

---

## God Repository [Major]

A single repository that handles all data operations for a feature (or worse, for multiple features). Grows unbounded, mixes concerns, and becomes a maintenance bottleneck.

**Signs**:
- A repository with 10+ public methods covering unrelated data operations
- Repository file exceeds 300+ lines
- Repository handles data for multiple domain entities
- Repository methods have mixed concerns: some do CRUD, some do search, some do aggregation, some do caching coordination
- Multiple developers frequently editing the same repository file (merge conflicts)
- Repository name is generic (`DataRepository`, `AppRepository`, `MainRepository`)

**Impact**:
- Single Responsibility Principle violated — the repository has many reasons to change
- Changes to one data operation risk breaking unrelated operations
- Testing requires mocking the entire repository interface, even when testing a single use case
- Cognitive load to understand the repository increases with every added method
- Merge conflicts increase as multiple developers work on different operations in the same file

**Fix**:
- Split by domain entity: `UserRepository`, `OrderRepository`, `PaymentRepository`
- Split by operation type if a single entity has too many operations: `UserQueryRepository`, `UserCommandRepository`
- Each repository should have 3-7 focused methods
- If a repository coordinates data from multiple sources for a single entity, that is appropriate — but it should not span multiple entities

**Detection**:
- Count public methods per repository: >10 is a warning sign
- Count domain entities referenced per repository: >1 is a warning sign
- Check file size: >300 lines suggests mixed concerns
- Review git blame: if the repository is edited in most PRs, it may be a God Repository

---

## Use Case for Formatting [Minor]

Creating use cases for operations that are not business intentions — formatting helpers, DTO transformations, or shared implementation details masquerading as use cases.

**Signs**:
- Use case names describe technical operations, not business intentions: `FormatDateUseCase`, `ConvertCurrencyDisplayUseCase`, `MapUserToCardUseCase`
- Use case contains only data transformation logic with no business rules
- Use case is only called by other use cases as a shared helper, never by presentation directly
- Use case does not interact with any repository, service, or external system
- Removing the use case would not affect any business capability

**Impact**:
- Pollutes the use case layer with non-business concerns, making it harder to find real business logic
- Creates unnecessary indirection — a formatter called through a use case is harder to trace than a utility function
- Inflates the number of "use cases" giving a false sense of feature completeness
- May create unnecessary dependencies between use case modules

**Fix**:
- Move formatting logic to the presentation layer (where display formatting belongs)
- Move data mapping logic to the data source layer (where DTO ↔ Domain mapping belongs)
- If the logic is truly shared and business-relevant, it may belong in a domain model method or a domain service
- Valid use cases represent business intentions: "Login", "ProcessPayment", "GetDashboard" — not technical operations

**Detection**:
- Review use case names: do they describe what the user/system intends, or what the code does technically?
- Check if the use case interacts with any repository or service — if not, it is probably not a use case
- Ask: "Would a non-technical stakeholder recognize this as a feature?" If not, it is not a use case

---

## Golden Hammer [Major]

Applying one solution pattern to every problem. A single architecture style, design pattern, or library is used universally regardless of fitness — because the team is comfortable with it, not because it is appropriate.

**Signs**:
- Every data operation goes through a repository even when the use case interacts with a capability (should be a service)
- Every component uses the same pattern (e.g., every interaction modeled as CQRS command/query even for simple CRUD)
- Architecture decisions reference comfort ("we always do it this way") rather than fitness ("this fits because...")
- A new requirement is force-fit into the existing pattern with obvious friction
- The same library/framework is used for everything, even when better alternatives exist for specific cases

**Impact**:
- Components are misnamed and misstructured, reducing clarity
- New team members learn the wrong abstraction for the problem at hand
- The system accumulates friction from force-fitted patterns
- Innovation is suppressed — better approaches are rejected because they are unfamiliar
- Technical debt grows in the gaps between the chosen pattern and the actual requirements

**Fix**:
- For each component, ask: "Why this pattern?" — the answer should reference the problem, not team familiarity
- Match component types to their semantic meaning: data coordination → repository, capability → service, business intention → use case
- Document when a different pattern was considered and why the current one was chosen (ADR)
- Allow different patterns in different areas when the problem domain warrants it

**Detection**:
- Review the ratio of repositories to services: if everything is a repository (or everything is a service), the golden hammer is likely
- Check ADRs for pattern selection rationale — is it based on problem fitness or team comfort?
- Look for forced patterns: components whose code fights the pattern rather than fits it naturally

---

## Ambiguous Components [Minor]

Components with names that do not communicate their architectural role: "Manager", "Helper", "Handler", "Utils", "Processor". These names reveal nothing about what the component does or where it belongs in the architecture.

**Signs**:
- Class/module names include: `Manager`, `Helper`, `Utils`, `Processor`, `Handler` (when not a Presentation-layer handler), `Wrapper`, `Stuff`
- The component's name requires reading its implementation to understand its purpose
- Multiple "Manager" classes with overlapping or unclear responsibilities
- A `Utils` file that grows unbounded as a dumping ground for miscellaneous functions
- Team members disagree about what a component does based on its name

**Impact**:
- New developers cannot navigate the codebase by names alone
- Code reviews miss architectural violations because component roles are unclear
- "Manager" and "Helper" classes tend to grow into God classes because their vague names accept any responsibility
- Search and refactoring are harder when names do not communicate intent

**Fix**:
- Rename to the specific role: `UserRepository`, `PaymentService`, `LoginUseCase`, `ApiUserDataSource`
- If a component is doing too many things to have a specific name, split it into focused components first
- Establish a naming convention: `{Entity}{ComponentType}` (e.g., `OrderRepository`, `NotificationService`)
- Move utility functions to the layer they belong in — formatting to presentation, validation to domain, mapping to data source

**Detection**:
- Search the codebase for class names containing "Manager", "Helper", "Utils", "Handler", "Processor"
- Review any class whose purpose you cannot determine from its name alone
- Ask team members to describe a component's responsibility without reading the code — if they cannot, the name is ambiguous
