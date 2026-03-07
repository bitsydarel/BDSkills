# Calibration: Cross-Lens

Guidance for scoring findings that span multiple evaluation lenses. Use when a single architectural issue affects criteria across different lenses. For amplification rules and severity escalation, see [evaluation-scoring.md](evaluation-scoring.md).

---

## When a finding spans multiple lenses

A single architectural issue often manifests across multiple lenses. The key question: **is this one root cause producing multiple symptoms, or are these genuinely independent issues?**

### Same root cause → score at the root, note in other lenses

When a dependency violation (Lens 1) directly causes a testability problem (Lens 4), score the root cause in Lens 1 and note the consequence in Lens 4's rationale. Do not double-penalize the same issue.

**Example**: Framework imports in domain models (D3: score 2) makes domain logic untestable without framework boot (Q1). Score D3 as the root cause. In Q1's rationale, note "Q1 score depressed by D3 violation — framework coupling prevents isolated testing." Score Q1 based on how well the team has mitigated the testability impact despite the root cause.

### Independent issues → score independently

When two lenses reveal genuinely different problems that happen to coexist, score them independently.

**Example**: Inconsistent naming (S2: score 2) AND missing error translation (B3: score 2). These are unrelated issues — fixing naming does not fix error translation. Score both independently.

---

## Cross-lens amplification examples

### Example 1: Dependency violation + untestable architecture

**D3 (Framework Independence): Score 2** — Domain models extend Django's `models.Model`. Use cases import Django ORM queryset methods.

**Q1 (Testability): Score 2** — Cannot test any use case without Django test runner. Test suite takes 4 minutes. Tests require database migrations.

**Amplification**: These share a root cause — framework in domain. Per the amplification rules in [evaluation-scoring.md](evaluation-scoring.md), D3 + Q1 both scoring ≤ 2 amplifies to Critical severity. The system is not just poorly structured AND untestable — the structural failure directly causes the testability failure.

**Reviewer action**: Report as a single Critical finding with both criterion references: "D3 + Q1: Framework coupling in domain models prevents isolated testing."

### Example 2: No enforcement + existing violations

**S1 (Physical Enforcement): Score 2** — Architecture rules exist in a wiki but no automated checks. No lint rules, no CI/CD architecture tests.

**D1 (Layer Separation): Score 2** — Multiple outward dependencies exist: use cases importing data source implementations, presentation calling repositories directly.

**Amplification**: S1 + D1 amplifies to Critical. The architecture has violations AND nothing prevents more violations from being added. This is worse than either issue alone — it is an architecture in active decay.

**Reviewer action**: Report the amplified finding and prioritize S1 remediation first (add enforcement), then fix existing D1 violations. Enforcement prevents regression; fixing violations without enforcement just delays the same outcome.

### Example 3: Component design + boundary erosion (no amplification)

**C1 (Single Responsibility): Score 3** — Most components well-focused, but 2 repositories contain business validation logic.

**B2 (Data Transformation): Score 3** — DTOs mostly contained but one repository returns a partially-mapped object.

**Assessment**: Both score 3 but they are related symptoms of the same area (the repository layer is accumulating inappropriate responsibilities). Note the pattern in the review but do not amplify — score 3 in both is "adequate with gaps," which correctly represents the situation. The finding is "Repository layer is accumulating responsibilities beyond data coordination" — address both in the same recommendation.

---

## Dependency-floor rule

When Lens 1 (Dependency Architecture) scores below 50% (< 13/25), all other lens criteria are capped at 4. The rationale:

**Why**: If dependency direction is fundamentally broken, other architectural qualities are built on a compromised foundation. A system with clean component design but broken dependency direction will degrade rapidly — the clean design cannot sustain itself when dependencies flow the wrong way.

**When to apply**: Calculate Lens 1 total. If it is 12 or below (< 50%), review all other lens scores and cap any score above 4 at 4. Note in the review: "Dependency-floor rule applied — Lens 1 below 50% caps other lenses."

**Example**: A system scores D1:2, D2:2, D3:3, D4:2, D5:3 = 12/25 (48%). Even if Q1 was assessed at 5 (excellent testability through clever workarounds), it is capped at 4 because the dependency foundation is weak — the testability is fragile and will erode as the dependency violations compound.

---

## Worked example: E-commerce system scored across all 5 lenses

**System**: Order processing feature in a Django application.

| Criterion | Score | Observation |
|-----------|-------|-------------|
| D1 | 2 | Views call repositories directly, bypassing use cases |
| D2 | 3 | Some interfaces exist at data source boundary but not consistently |
| D3 | 2 | Domain models are Django ORM models with framework annotations |
| D4 | 4 | No circular imports between features |
| D5 | 3 | Stripe SDK wrapped in a service but boto3 used directly in use cases |
| **Lens 1** | **14/25** | 56% — above dependency-floor threshold |
| C1 | 3 | Most components focused but OrderManager mixes concerns |
| C2 | 2 | "Manager" and "Helper" classes with unclear roles |
| C3 | 3 | Use cases exist but some are formatting helpers |
| C4 | 2 | No barrel files; features import from each other's internals |
| C5 | 2 | Domain models are Django models (same as D3 root cause) |
| **Lens 2** | **12/25** | 48% |
| B1 | 3 | Main flow traceable but some views bypass use cases (same as D1) |
| B2 | 2 | Django model instances passed through all layers (ORM model IS the DTO) |
| B3 | 2 | Use cases catch `IntegrityError` and `Http404` directly |
| B4 | 2 | Features import from each other's `models.py` and `views.py` |
| **Lens 3** | **9/20** | 45% |
| Q1 | 2 | All tests require Django test runner + database |
| Q2 | 3 | Most changes contained to one app but shared models create coupling |
| Q3 | 3 | Database connection pooling configured; no other scaling strategy |
| Q4 | 2 | Print statements for debugging; no structured logging |
| **Lens 4** | **10/20** | 50% |
| S1 | 1 | No enforcement — rules exist nowhere |
| S2 | 2 | Inconsistent naming across apps |
| S3 | 1 | No ADRs, no design docs |
| S4 | 3 | New features follow the Django app pattern consistently |
| **Lens 5** | **7/20** | 35% |

**Cross-lens observations**:
- D3 (framework in domain) → C5 (impure models) → Q1 (untestable): Same root cause, three symptoms. Report once as Critical.
- D1 (layer violations) + S1 (no enforcement): Amplified to Critical — violations exist AND nothing prevents more.
- Lens 5 at 35% triggers weakest-link rule → **automatic Rework Required**.
- S1 score of 1 triggers critical override → cannot receive "Proceed" regardless.

**Total**: 52/110 (47%) — **Rework Required** (below 60% threshold, Lens 5 below 40%, two criteria scored 1).

**Key recommendation**: Start with S1 (add basic enforcement) and D3 (extract pure domain models). These address the root causes that cascade into most other findings.
