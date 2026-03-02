# Output Template — Plan Reviewer Agent

Use this structure for the final output after all 10 review stages complete. The template adapts based on plan scope (see Output Depth Rule in AGENT.md).

---

## Verdict (First Line — Always)

The very first line of output. Uses a markdown header for prominence across CLI, IDE, and mobile:

```
## Verdict: [Ready | Conditionally Ready | Not Ready] (X/10 passed)
```

**Verdict criteria:**
- **Ready** — No NEEDS WORK or FAIL ratings; no unresolved CRITICAL OPEN ISSUES
- **Conditionally Ready** — All CONDITIONAL PASS or better; or minor open issues remain
- **Not Ready** — Any FAIL rating, or multiple NEEDS WORK ratings, or unresolved CRITICAL OPEN ISSUES

---

## Context Summary

A single natural language line immediately after the verdict. Derived from the Context Block Summary field:

```
Reviewing as: [natural language summary from Context Block]
```

Example: "Reviewing as: a bug fix for login button alignment in an existing mobile app with active users"

If context was revised after the 10-stage review (see Phase 3 in AGENT.md), include:

```
**Context revision:** Originally classified as [original]. After review, reclassified as [revised] because [reason].
```

---

## Section 1: Executive Summary

Scaled by plan scope:
- **Isolated-change:** 3-5 lines
- **Cross-cutting / full-product:** Full summary
- **System-wide:** Full summary + cross-reviewer dependency analysis

```markdown
# Plan Review — Executive Summary

**Plan:** [Plan title or one-line description]
**Date:** [Review date]

## Confidence
- **X/10 passed** (Y with full applicability, Z with partial)
- Applicable reviewer profile: N reviewers fully applicable, M with limited applicability

## Top Strengths
1. [Strength from reviewer X]
2. [Strength from reviewer Y]
3. [Strength from reviewer Z]

## Top Remaining Risks
1. [Risk or open issue — severity — owning reviewer]
2. [Risk or open issue — severity — owning reviewer]
3. [Risk or open issue — severity — owning reviewer]

## Issue Summary
- Critical: [count] (resolved: [count] / open: [count])
- Major: [count]
- Minor: [count]
- Open Issues: [count] (marked inline with **[OPEN ISSUE]**)
- Critical Open Issues: [count] (marked inline with **[CRITICAL OPEN ISSUE]**)
- Conflicts: [count] (marked inline with **[CONFLICT]**)
```

---

## Section 2: Improved Plan

This is the **primary deliverable** — the full plan text after all 10 reviewers have made their improvements. Wrap in a fenced code block for one-click copy in IDE panels:

````
```markdown
[Complete improved plan text here]
```
````

**Guidelines:**
- Preserve the original plan's structure and headings
- Additions from reviewers should be integrated naturally, not appended as comments
- **Do NOT add sections for N/A dimensions** — no buyer personas for internal tools, no GTM for bug fixes
- Inline markers use **bold** for visibility:
  - **[OPEN ISSUE: description]**
  - **[CRITICAL OPEN ISSUE: description — requires action outside this review]**
  - **[CONFLICT: Stage N said X, Stage M says Y]**
- Do not include reviewer attribution within the plan text itself (that goes in the audit trail)

**Skip this section entirely** if all 10 reviewers pass with no changes (the original plan needs no improvement).

---

## Section 3: Review Audit Trail

Use **vertical list format** (renders at any width — CLI, IDE, mobile). Group by applicability.

### Fully Applicable Reviewers

Reviewers where most dimensions (>50%) applied:

```
**1. Leadership** — PASS (6/6 applicable)
  Changes: Added outcome-based OKRs, risk assessment section
  Issues: 0 critical, 1 major (resolved), 0 minor

**2. Product Manager** — CONDITIONAL PASS (7/7 applicable)
  Changes: Added problem statement, success metrics with targets
  Issues: 0 critical, 2 major (1 resolved, 1 open), 1 minor
```

### Partially Applicable Reviewers

Reviewers where fewer dimensions (≤50%) applied:

```
**3. Product Marketing** — PASS (1/10 applicable)
  N/A: Market understanding, positioning, competitive, GTM, sales, measurement, pricing, channel, evidence (bug fix context)
  Changes: Added customer impact note for support team
  Issues: 0 critical, 0 major, 0 minor
```

### Rating Scale

- **PASS** — No critical or major issues on applicable dimensions; plan is strong
- **CONDITIONAL PASS** — Major issues found but resolved during review; plan is now acceptable
- **NEEDS WORK** — Major issues remain on applicable dimensions that could not be fully resolved inline
- **FAIL** — Critical unresolved issues on applicable dimensions; plan should not proceed without significant rework

### Compressed Output (Isolated-Change Scope)

For `isolated-change` scope, only show full entries for reviewers that made changes or found issues. Summarize the rest:

```
Reviewers with no applicable findings: Product Marketing, Product Designer, Product Owner (all confirmed N/A for this plan context)
```

---

## Verdict (Repeated)

Repeat the verdict before Next Steps so users scrolling through long output in IDE panels can find it:

```
## Verdict: [Ready | Conditionally Ready | Not Ready] (X/10 passed)
```

---

## Section 4: Next Steps

Actionable guidance for what to do after reading this review:

```markdown
## Next Steps

### Before Using This Plan
1. Resolve all **[OPEN ISSUE]** markers — these are inline items the review could not fully address
2. Resolve all **[CRITICAL OPEN ISSUE]** markers — these require action outside this review (e.g., user research, data gathering, stakeholder alignment)
3. For any **[CONFLICT]** markers — review both perspectives and choose the approach that fits your context

### Re-Review Recommended If
- [Condition, e.g., "Significant scope changes are made after resolving open issues"]
- [Condition, e.g., "Architecture approach changes based on conflict resolution"]

### Ready to Implement If
- All markers resolved
- No NEEDS WORK or FAIL ratings remain
- Acceptance criteria are testable
```

---

## Section 5: Context-Appropriate Omissions

List what was intentionally NOT added to the plan, with reasons tied to context. This prevents users from thinking the review missed something:

```markdown
## Context-Appropriate Omissions

The following were intentionally not added to the plan based on the detected context ([plan type]):

- **Buyer personas** — N/A: internal tool, no external customers
- **Go-to-market strategy** — N/A: bug fix, no launch needed
- **Pricing and packaging** — N/A: architecture change, no pricing impact
- **Full service blueprint** — N/A: isolated UI fix, limited user journey impact
```

Only include this section if there are meaningful omissions to document (typically for bug fixes, refactors, infrastructure changes where many PMM/Designer dimensions are N/A).

---

## Condensed Output Variant

When **all 10 reviewers pass with no changes**, produce a minimal output:

```
## Verdict: Ready (10/10 passed)

Reviewing as: [context summary]

All 10 reviewers found no issues requiring plan changes. The plan is ready for implementation as-is.

### Audit Summary
**1. Leadership** — PASS (N/N applicable) | **2. PM** — PASS (N/N) | **3. PMM** — PASS (N/N) | **4. BA** — PASS (N/N) | **5. Designer** — PASS (N/N) | **6. PO** — PASS (N/N) | **7. Architect** — PASS (N/N) | **8. Test** — PASS (N/N) | **9. QA** — PASS (N/N) | **10. Clean Code** — PASS (N/N)

No next steps required. Proceed to implementation.
```
