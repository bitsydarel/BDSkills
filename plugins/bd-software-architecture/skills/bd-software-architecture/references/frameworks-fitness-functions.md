# Architecture fitness functions

Comprehensive reference for automated architecture enforcement, based on Neal Ford's Evolutionary Architecture concepts. Fitness functions are objective, measurable assessments of architecture characteristics — they turn architecture rules from aspirational guidelines into verifiable constraints.

## What are fitness functions

An architecture fitness function is any mechanism that provides an objective integrity assessment of an architecture characteristic. Named by analogy with evolutionary computing — just as genetic algorithms use fitness functions to evaluate candidate solutions, architecture fitness functions evaluate whether the system upholds its architectural contract.

**Key idea**: If you cannot measure it, you cannot enforce it. Fitness functions make architecture rules falsifiable — they either pass or they fail.

## Classification

### By scope

| Type | Definition | Example |
|------|-----------|---------|
| **Atomic** | Tests a single architecture characteristic in isolation | "No circular imports between modules" |
| **Holistic** | Tests the interaction of multiple characteristics | "Response time under load stays within budget while maintaining data consistency" |

### By trigger

| Type | Definition | Example |
|------|-----------|---------|
| **Triggered** | Runs on a specific event (commit, deploy, PR) | ArchUnit test in CI that checks dependency direction on every commit |
| **Continual** | Runs continuously in production | Monitoring alert when cross-service latency exceeds threshold |

### By method

| Type | Definition | Example |
|------|-----------|---------|
| **Static** | Analyzes code without executing it | Import analysis, coupling metrics, dead code detection |
| **Dynamic** | Requires running code or system | Load testing, chaos engineering, contract tests |
| **Automated** | Runs without human intervention | CI/CD pipeline checks |
| **Manual** | Requires human judgment | Architecture review boards, code review |

## Concrete examples with tools

### Dependency direction checks

Verify that dependencies flow inward — no outward violations from domain/use cases to infrastructure.

**Tools by ecosystem**:
- **Java/Kotlin**: ArchUnit — `noClasses().that().resideInAPackage("..domain..").should().dependOnClassesThat().resideInAPackage("..infrastructure..")`
- **Python**: deptry, import-linter — define forbidden import rules
- **Dart/Flutter**: dependency_validator, custom lint rules
- **JavaScript/TypeScript**: eslint-plugin-import with `no-restricted-imports`, eslint-plugin-boundaries
- **Go**: Go's package visibility (unexported symbols) provides built-in enforcement

**Implementation pattern**:
```yaml
# CI/CD pipeline
- name: Architecture dependency check
  run: |
    # Verify domain layer has no infrastructure imports
    ! grep -r "import.*infrastructure\|import.*database\|import.*http" src/domain/
    # Verify use cases do not import presentation
    ! grep -r "import.*presentation\|import.*views\|import.*controllers" src/use_cases/
```

### Coupling metrics

Measure how tightly modules are connected.

| Metric | Formula | What It Means | Target |
|--------|---------|--------------|--------|
| **Afferent Coupling (Ca)** | Number of external modules that depend on this module | How many modules would be affected if this module changes | Lower is better for volatile modules |
| **Efferent Coupling (Ce)** | Number of external modules this module depends on | How many modules affect this module when they change | Lower is better for stable modules |
| **Instability (I)** | Ce / (Ca + Ce) | 0 = maximally stable, 1 = maximally unstable | Domain modules near 0, adapter modules near 1 |
| **Abstractness (A)** | Abstract types / Total types | Ratio of interfaces to concrete classes | Balance between 0 and 1 |

**Ideal**: Stable modules (low I) should be abstract (high A). Unstable modules (high I) should be concrete (low A). Modules that are both stable AND concrete are pain points — hard to change but many depend on them.

### Build time as architecture signal

Increasing build time often indicates growing coupling:
- Modules that take longer to compile than expected may have too many dependencies
- Incremental build that rebuilds most of the codebase indicates poor module boundaries
- Build time regression after a change suggests the change increased coupling

**Fitness function**: Track build time per commit. Alert when incremental build time increases by >20% without a corresponding increase in code size.

### API contract tests

Verify that a service's API contract is maintained across changes.

**Pattern**: Consumer-driven contract testing (Pact, Spring Cloud Contract). Each consumer defines the contract it expects. The provider runs these contracts in CI — if any contract breaks, the build fails.

**Maps to**: B4 (Feature Module Isolation) — contracts enforce feature boundaries, S4 (Evolutionary Architecture) — contracts enable safe API evolution.

### Dead code detection

Identify unreferenced files, functions, and modules.

**Tools**: tree-shaking analysis, coverage reports (0% coverage = likely dead code), IDE unreferenced symbol detection.

**Maps to**: Anti-pattern "Lava Flow" in [anti-patterns-evolutionary.md](anti-patterns-evolutionary.md).

## Netflix Conformity Monkey

Netflix's Conformity Monkey (part of the Simian Army) automatically checks cloud instances for conformity to architectural best practices. When an instance violates a rule (e.g., not in an auto-scaling group, missing health check), Conformity Monkey flags it.

**Architecture adaptation**: Apply the Conformity Monkey concept to any architecture. Define rules that components must conform to, then automate checking:
- Every feature module must have a public API file
- Every data source must implement a contract interface
- Every domain model file must have zero framework imports
- Every feature must have at least one unit test that runs without infrastructure

## Static code analysis for architecture

### Actual vs target architecture

Tools that parse source code to record the actual dependency graph and compare it against the intended (target) architecture:

- **Sonargraph** (Java, C#, C++): Defines target architecture as layers/modules with allowed dependencies. Visualizes actual architecture. Flags violations.
- **Structure101** (Java): Interactive architecture visualization. Define target layers, see violations in real time.
- **deptry** (Python): Detects missing, transitive, and obsolete dependencies.
- **Lattix** (multi-language): Dependency Structure Matrix (DSM) for identifying architectural patterns and violations.

**Key value**: Reveals the *actual* architecture (what the code does) vs the *target* architecture (what the documentation says). The gap between them is architectural drift — and it always grows unless actively measured.

### Modularity Maturity Index (MMI)

A composite metric that assesses the structural quality of a module system:

| Factor | What It Measures | Contribution to MMI |
|--------|-----------------|-------------------|
| Coupling | How many cross-module dependencies exist | Lower coupling → higher MMI |
| Cycles | How many circular dependencies exist | Zero cycles → highest contribution |
| Dependency Rule adherence | How many inward-dependency violations exist | Zero violations → highest contribution |
| Module size distribution | Are modules similarly sized or wildly uneven | Balanced sizes → higher MMI |

MMI is tracked over time — a declining MMI indicates architectural erosion. Use as a holistic fitness function.

## Automated continuous reviews

### Design gap detection

Use build tools to continuously identify architectural design gaps:

- **Illicit database access**: Detect when a service or module queries another module's database tables directly. Rule: "Only the owning module's repository may access table X."
- **Inappropriate shared libraries**: Detect common libraries that change too frequently — high churn in a shared library indicates it is accumulating responsibilities. Rule: "Shared libraries must change less frequently than the modules that use them."
- **Import depth violations**: Detect imports that reach too deep into another module's internal structure. Rule: "Cross-module imports must resolve to module's index/barrel file."

### CI/CD integration

Architecture fitness functions as quality gates in the deployment pipeline:

```
Commit → Lint → Unit Tests → Architecture Fitness Functions → Integration Tests → Deploy
                                    │
                                    ├── Dependency direction check
                                    ├── Circular dependency check
                                    ├── Public API boundary check
                                    ├── Framework independence check
                                    ├── Coupling metrics (fail if above threshold)
                                    └── Build time regression check
```

Architecture checks should run after unit tests (fast feedback) but before integration tests (which are slower). They should fail the build, not just warn.

## Integration with evaluation

- **S1 (Physical Structure Enforces Rules)**: Fitness functions are the gold standard for score 5. Automated enforcement in CI/CD is the difference between score 3 (convention-based) and score 5 (physically enforced).
- **Q1 (Testability)**: A fitness function can verify that all use cases are instantiable with only mock dependencies — testability as a measurable property.
- **D4 (Dependency Graph Acyclicity)**: Cycle detection tools are atomic, triggered fitness functions that prevent regressions.
- **S4 (Evolutionary Architecture Readiness)**: Fitness functions track architecture health over time — a declining MMI or increasing build time signals that the architecture is resisting evolution.
