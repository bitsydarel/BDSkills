# Calibration: Structural Integrity (Lens 5)

Weak/adequate/strong examples for criteria S1-S4. Use when uncertain about a score boundary. For full scoring criteria, see [evaluation-structural-integrity.md](evaluation-structural-integrity.md).

---

## S1: Physical Structure Enforces Rules

### Weak (Score 1-2)

Architecture rules exist only in a wiki page or team memory:
- "Don't import from other features' internal directories" — documented in Confluence, last updated 18 months ago
- No lint rules, no build checks, no module visibility settings
- Violations accumulate silently — discovered months later during code archaeology
- New developers do not know the rules exist

### Adequate (Score 3)

Some enforcement but partial coverage:
- Directory structure reflects the architecture (feature folders with layer subdirectories)
- One or two lint rules exist (e.g., "no circular imports")
- Most rules enforced through code review, not automation
- Violations caught inconsistently — depends on reviewer familiarity

### Strong (Score 4-5)

Automated enforcement in CI/CD:
```yaml
# CI pipeline — architecture fitness functions
- name: Check dependency direction
  run: archunit-test --rule "domain/ must not import from data_sources/"
- name: Check no circular dependencies
  run: deptry --no-cycles
- name: Check public API discipline
  run: lint --rule "cross-feature imports must use barrel files"
- name: Check framework independence
  run: grep -r "import django" domain/ use_cases/ && exit 1 || exit 0
```

**Why strong**: Violations fail the build. New developers cannot accidentally break architecture rules. The enforcement evolves with the architecture — new rules added as new patterns are established.

### Boundary

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| How are rules enforced? | Wiki / team memory | Code review + some lint rules | CI/CD pipeline + automated tests |
| What happens when a rule is violated? | Nothing, until someone notices | Caught in review ~50% of the time | Build fails immediately |
| Can a new developer violate rules? | Easily | Possible if reviewer misses it | Impossible (build rejects) |

---

## S2: Naming & Convention Consistency

### Weak (Score 1-2)

```
user_repo.py
PaymentRepository.py
NotifService.py
auth_manager.py
data_helper.py
handle_orders.py
misc_utils.py
```

Different naming patterns, inconsistent casing, ambiguous names. Cannot determine component role from name.

### Adequate (Score 3)

```
user_repository.py
payment_repository.py
notification_service.py      # Consistent pattern...
auth_handler.py              # ...but "handler" instead of "service"
order_data_manager.py        # "manager" ambiguity
```

Mostly consistent with a few deviations. Pattern is recognizable but has exceptions.

### Strong (Score 4-5)

```
user_repository.py
payment_repository.py
notification_service.py
authentication_service.py
get_user_profile_use_case.py
login_use_case.py
api_user_data_source.py
postgres_order_data_source.py
```

**Why strong**: Pattern `{qualifier}_{component_type}.py` is consistent everywhere. Component type (`repository`, `service`, `use_case`, `data_source`) immediately communicates architectural role. New files follow the pattern naturally.

---

## S3: Architecture Decision Records

### Weak (Score 1-2)

No decision documentation. Architecture decisions live in:
- Slack messages from 2 years ago (unsearchable)
- PR descriptions that nobody references after merge
- The memory of the original developer (who may have left)

**Symptom**: "Why do we use Redis here instead of the database cache?" — asked every 3 months by different people, answered differently each time. (Groundhog Day anti-pattern)

### Adequate (Score 3)

Some ADRs exist but incomplete:

```markdown
# ADR-003: Use PostgreSQL for persistence

## Decision
We will use PostgreSQL.

## Status
Accepted
```

**Why adequate**: The decision is recorded, but there is no context (why PostgreSQL?), no alternatives considered (why not MongoDB? why not SQLite?), and no consequences documented. When someone asks "why PostgreSQL," the ADR answers "because we decided to" — not helpful.

### Strong (Score 4-5)

```markdown
# ADR-003: Use PostgreSQL for persistence

## Status
Accepted (2024-03-15)

## Context
Our application requires ACID transactions for payment processing
and complex relational queries for reporting. Expected data volume
is 10M records in year 1, growing to 100M by year 3.

## Options Considered
1. **PostgreSQL** — Full ACID, mature, strong ecosystem, team expertise
2. **MongoDB** — Flexible schema, good for document-heavy workloads
3. **SQLite** — Simple, zero config, but single-writer limitation

## Decision
PostgreSQL. ACID transactions are non-negotiable for payment processing.
Team has 5+ years of PostgreSQL expertise. Relational queries needed
for financial reporting. MongoDB's flexible schema is not valuable
when our domain model is well-defined.

## Why Not MongoDB
Document model would require denormalization for financial reports.
Eventual consistency is unacceptable for payment state. Team would
need training on a new technology with no clear benefit.

## Why Not SQLite
Single-writer limitation blocks concurrent payment processing.
Cannot scale horizontally. Not suitable for production workloads
at our expected volume.

## Consequences
- Must manage PostgreSQL infrastructure (RDS or self-hosted)
- Schema migrations required for model changes (managed via Alembic)
- Team can leverage existing PostgreSQL expertise
```

**Why strong**: Captures context, all options, rationale for the choice AND rationale for rejecting alternatives. Future team members understand not just what was decided but why — and can evaluate whether the original constraints still hold.

---

## S4: Evolutionary Architecture Readiness

### Weak (Score 1-2)

**Scenario**: Add a new "Loyalty Points" feature.

Required changes: Modify OrderUseCase to add points calculation, modify UserRepository to store points, modify PaymentService to apply discounts, modify 3 existing domain models, update 12 existing test files.

**Why weak**: Adding a new feature requires modifying existing features. No extension point exists. The new feature cannot be developed independently — it is woven into existing code.

### Adequate (Score 3)

**Same scenario**: Add a new "Loyalty Points" feature.

Required changes: Create new `loyalty/` feature folder following existing pattern. Modify OrderUseCase to call LoyaltyService (2 lines added). Modify User domain model to add points field.

**Why adequate**: New feature follows the existing pattern but still requires modifying existing components. The architecture mostly accommodates change but with some coupling.

### Strong (Score 4-5)

**Same scenario**: Add a new "Loyalty Points" feature.

Required changes: Create new `loyalty/` feature folder. Register loyalty event listener for order completion events. No modification to existing features — loyalty feature subscribes to events published by the order feature.

**Why strong**: New feature added by creating new files only. Existing code unchanged. The event system provides an extension point. Feature development time is consistent regardless of how many features already exist.

### Boundary

| Question | Score 2 | Score 3 | Score 4 |
|----------|---------|---------|---------|
| Adding a feature modifies existing features? | Extensively | 1-2 minor modifications | No modifications (extension only) |
| Is the pattern for new features clear? | No | Mostly, but variations exist | Yes, documented and consistent |
| Is feature development time increasing? | Noticeably | Slightly | Stable |
