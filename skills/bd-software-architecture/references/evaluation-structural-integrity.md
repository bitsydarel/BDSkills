# Evaluation: Structural Integrity (Lens 5)

Scoring rubric for criteria S1-S4. Integrates architecture fitness functions (Neal Ford), Netflix Conformity Monkey, Google design doc review practices, and ADR methodology. Scoring follows the 1-5 scale defined in [evaluation-scoring.md](evaluation-scoring.md).

## S1: Physical Structure Enforces Rules

**What it evaluates**: Whether directory layout, module visibility, and build configuration physically prevent dependency violations — not just document them as conventions. Architecture rules that rely solely on developer discipline erode over time. Physical enforcement makes violations impossible or immediately visible.

*Integrates: Architecture Fitness Functions (atomic, triggered), Netflix Conformity Monkey (automated compliance checking), static code analysis for architecture (ArchUnit, deptry, Modularity Maturity Index).*

### Proposal questions
- Does the design specify how architectural rules will be enforced beyond documentation?
- Are there plans for lint rules, module visibility settings, or build-time checks?
- Is the directory structure designed to make violations physically difficult?
- Are fitness functions or automated architecture checks planned for CI/CD?

### Implementation-compliance questions
- Does the module/package structure physically prevent incorrect imports?
- Are there lint rules, ArchUnit tests, or build configurations that catch dependency violations?
- Does CI/CD include architecture compliance checks?
- Is the enforcement automated or manual?

### Implementation-results questions
- When a developer accidentally creates a dependency violation, does the build catch it?
- Have violations been caught by automated checks before reaching code review?
- Is the enforcement comprehensive (all rules) or partial (only some rules)?
- How is new architecture evolution reflected in updated enforcement rules?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Architecture rules enforced by build system, lint rules, or architecture test framework (ArchUnit, deptry). CI/CD rejects violations. Directory structure makes invalid imports impossible. Fitness functions run on every commit. Conformity checks are automated |
| 4 | Most architecture rules enforced automatically. Directory structure supports enforcement. Key rules (dependency direction, public API boundary) checked in CI. Some rules rely on code review rather than automation |
| 3 | Some enforcement exists (e.g., lint rule for specific imports, module visibility for key modules) but coverage is partial. Most rules enforced through code review and developer discipline. Directory structure supports the architecture but does not prevent violations |
| 2 | Architecture rules documented but enforcement is entirely manual. Directory structure suggests the architecture but does not prevent violations. Violations are caught inconsistently during code review. No automated checks |
| 1 | No enforcement mechanism. Architecture rules may be documented in a wiki that nobody reads. Directory structure does not reflect architectural intent. Violations accumulate silently. No code review for architecture compliance |

---

## S2: Naming & Convention Consistency

**What it evaluates**: Whether layers, components, and files follow consistent naming conventions that make their role immediately apparent. A developer should be able to determine a component's layer, responsibility, and relationships from its name and location without reading implementation code.

### Proposal questions
- Does the design specify naming conventions for layers, components, and files?
- Are naming conventions consistent across features?
- Do names communicate the component's role in the architecture (e.g., `UserRepository`, `PaymentService`, `LoginUseCase`)?

### Implementation-compliance questions
- Do component names follow consistent patterns across features (e.g., all repositories end in `Repository`, all use cases in `UseCase`)?
- Do file names and directory names match the naming convention?
- Can a developer identify a component's architectural role from its name alone?
- Are there naming inconsistencies between features (e.g., `UserRepo` vs `PaymentRepository`)?

### Implementation-results questions
- Can a new developer navigate the codebase and identify component types from names alone?
- When searching for a component, do naming conventions help predict the file name and location?
- Are there naming conflicts or ambiguities that cause confusion?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | Consistent naming conventions across all features and layers. Component names immediately communicate their role (`LoginUseCase`, `UserRepository`, `PaymentService`, `ApiUserDataSource`). File names match class/module names. Naming convention documented and new features follow it automatically |
| 4 | Naming mostly consistent with a few minor variations. New developers can identify component types from names. One or two features use slightly different naming but the pattern is recognizable |
| 3 | Naming conventions exist but are applied inconsistently. Some features follow the pattern, others use abbreviations or alternative naming. Developers familiar with the project can navigate but newcomers may struggle |
| 2 | Naming is inconsistent across features. Mixed conventions (some use `Repository`, others `Repo`, others `Store`). Component names do not reliably indicate their architectural role. Developers must read code to understand component purposes |
| 1 | No naming conventions. Component names are arbitrary (`DataHelper`, `AppManager`, `Stuff`). File organization does not follow a pattern. Developers cannot predict where to find functionality or what a component does from its name |

---

## S3: Architecture Decision Records

**What it evaluates**: Whether significant architecture decisions are documented with context, options considered, rationale (*why* this option, *why not* the alternatives), and consequences. Captures the *why* behind the architecture — without ADRs, teams re-debate settled decisions (the Groundhog Day anti-pattern) and cannot evaluate whether original constraints have changed.

*Integrates: Second Law of Software Architecture ("Why is more important than how"), Google Design Doc structure (Context, Goals, Design with tradeoffs, Alternatives Considered), Five Whys root cause analysis.*

### Proposal questions
- Does the design document the rationale for key architectural choices?
- Are alternatives considered and reasons for rejection documented?
- Does the design explain *why* this architecture over the alternatives?
- Are constraints and assumptions that drive decisions explicitly stated?

### Implementation-compliance questions
- Are ADRs (or equivalent decision records) present for significant decisions?
- Do ADRs include: context, options considered, decision, rationale, and consequences?
- Can you answer "why was this approach chosen?" for major structural decisions?
- Are ADRs updated when decisions are revisited or reversed?

### Implementation-results questions
- When a new team member asks "why do we do it this way?", is the answer documented?
- Has the team re-debated a decision because the original rationale was lost?
- Are decisions traceable — can you find the ADR that explains a particular architectural choice?
- Do ADRs capture the *why not* for rejected alternatives (preventing future re-evaluation without new context)?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | ADRs exist for all significant decisions with full context, alternatives, rationale, and consequences. ADRs are discoverable and cross-referenced. Team references ADRs when questions arise. Decisions are revisited only when constraints change, with the ADR updated. No Groundhog Day debates. Google-style design doc approach for major changes |
| 4 | ADRs exist for most significant decisions. Context and rationale are documented. Some older decisions lack formal records but are understood by the team. ADRs are maintained and updated. Minimal re-debates |
| 3 | Some ADRs exist but coverage is incomplete. Major decisions are documented, but rationale is sometimes thin ("we chose X because it's better"). Some decisions undocumented. Occasional re-debates of settled questions |
| 2 | Few formal ADRs. Some decisions documented in wiki pages, PRs, or Slack messages (hard to find). Rationale often missing — decisions recorded as facts without *why*. Regular re-debates of past decisions |
| 1 | No decision documentation. Architecture decisions are tribal knowledge. Team regularly re-debates settled decisions because nobody remembers the rationale. New team members cannot understand why the architecture is the way it is. Groundhog Day anti-pattern is the norm |

---

## S4: Evolutionary Architecture Readiness

**What it evaluates**: Whether the architecture accommodates incremental change without wholesale restructuring. Feature additions should follow established patterns. The architecture should support evolution — new features, new integrations, new requirements — without requiring a rewrite.

*Integrates: Neal Ford's Evolutionary Architecture, architecture fitness functions (holistic, continual), Uber DOMA extension mechanisms.*

### Proposal questions
- Does the design consider how the architecture will evolve over the next 6-12 months?
- Are there extension points for likely future requirements?
- Can new features be added by following existing patterns without modifying the architecture?
- Does the design avoid over-engineering for speculative requirements while remaining extensible?
- Are extension points identified for likely areas of change (OCP)?
- Can new features be added without modifying existing components?

### Implementation-compliance questions
- Can a new feature be added by creating new files that follow existing patterns?
- Does adding a new feature require modifying existing features or core infrastructure?
- Are there clear patterns that new developers can follow for common additions (new data source, new use case, new feature)?
- Is the architecture flexible enough to accommodate past unplanned changes?
- Were recent features added by extension (new files, new implementations) or by modifying existing code?

### Implementation-results questions
- How long does it take to add a new feature of average complexity? Has this time increased over the last several features?
- Do new features follow the same structural pattern as existing ones?
- Have there been cases where a requirement change required restructuring rather than extension?
- Does the architecture require periodic "cleanup sprints" to remain viable?

### Scoring

| Score | Description |
|-------|-------------|
| 5 | New features follow established patterns with no architectural changes needed. Extension points exist for likely evolution areas. Architecture fitness functions track evolutionary health. Adding a feature takes consistent, predictable time. No cleanup sprints needed. Architecture has successfully accommodated unplanned requirements |
| 4 | New features mostly follow established patterns. Occasional minor adjustments to shared infrastructure needed. Feature development time is stable. Architecture has accommodated several requirement changes without restructuring |
| 3 | New features can be added but sometimes require deviations from the pattern. Architecture accommodates change but with increasing friction. Feature development time slowly growing. Occasional tech debt addressed during feature work |
| 2 | Adding features requires regular modifications to core architecture. Patterns are inconsistent — new features do not follow a clear template. Feature development time increasing noticeably. Periodic cleanup sprints needed to maintain viability |
| 1 | Architecture resists change. Every new feature requires modifying existing features and core infrastructure. No consistent patterns to follow. Feature development time grows with each addition. Regular rewrites discussed or planned. The architecture has ossified |
