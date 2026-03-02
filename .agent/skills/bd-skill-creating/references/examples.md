# Skill Examples

Good and bad examples to guide skill creation.

## Good Example: Test Design Skill

This example demonstrates proper structure, progressive disclosure, and clear triggers.

### Frontmatter

```yaml
---
name: bd-test-design
description: Comprehensive guide for designing and implementing software tests. Use when the user asks to write new tests, refactor existing tests, design test strategies, or improve code coverage for Unit, Integration, E2E, or UI automation across Web, Mobile, Backend, or AI platforms.
---
```

**Why it works:**
- Name matches directory (`bd-test-design/`)
- Description starts with WHAT (designing/implementing tests)
- Description includes WHEN (write tests, refactor, design strategies, coverage)
- Specific keywords for discoverability (Unit, Integration, E2E, UI, Web, Mobile)

### Structure

```
bd-test-design/
├── SKILL.md                      # ~55 lines
└── references/
    ├── heuristics.md             # Testing heuristics
    ├── edge-cases.md             # Edge case checklist
    ├── property-testing.md       # Property-based testing
    └── platforms.md              # Platform-specific patterns
```

**Why it works:**
- SKILL.md is concise (<500 lines)
- Detailed content in references
- One topic per reference file
- References one level deep

### SKILL.md Body Pattern

```markdown
# Test Design

This skill guides the design and implementation of comprehensive tests.

## Core Thinking
[3 key principles]

## Design Criteria
[Key techniques with examples]

### Advanced Heuristics
For complex validation logic, see [references/heuristics.md](references/heuristics.md).

## Domain & Strategy Guides
- **Property-Based Testing**: See [references/property-testing.md]
- **Edge Cases**: See [references/edge-cases.md]
- **Platform Specifics**: See [references/platforms.md]

## Anti-Patterns
[List of things to avoid]
```

---

## Bad Example: Vague Helper Skill

This example shows common mistakes to avoid.

### Bad Frontmatter

```yaml
---
name: doc-helper
description: Helps with documents.
---
```

**Problems:**
- Vague name ("helper" is non-descriptive)
- Description too short and generic
- No WHEN clause (trigger conditions missing)
- No specific keywords for discovery

### Better Version

```yaml
---
name: document-processing
description: Converts, merges, and extracts content from PDF, Word, and Excel files. Use when the user needs to combine documents, extract text, or convert between formats.
---
```

---

## Bad Example: Information Overload

### Problematic Structure

```
my-skill/
├── SKILL.md                      # 800 lines!
└── references/
    └── advanced/
        └── details/
            └── specifics.md      # 3 levels deep!
```

**Problems:**
- SKILL.md exceeds 500 line limit
- References nested too deeply
- Agent may not find deeply nested content

### Better Version

```
my-skill/
├── SKILL.md                      # ~60 lines
└── references/
    ├── quickstart.md             # Basic usage
    ├── advanced.md               # Advanced features
    └── api-reference.md          # Complete API
```

---

## Input/Output Example

**User Request:**
> "Create a skill for reviewing pull requests"

**Expected Skill Structure:**

```yaml
---
name: reviewing-pull-requests
description: Guides systematic code review of pull requests. Use when the user asks to review a PR, check code quality, or provide feedback on changes.
---
```

```markdown
# Pull Request Review

Systematic approach to reviewing code changes.

## Review Checklist
1. Understand the context
2. Check functionality
3. Evaluate code quality
4. Verify tests
5. Review documentation

## Detailed Guides
- **Code Quality**: See [references/quality.md]
- **Security Review**: See [references/security.md]

## Anti-Patterns
- Rubber-stamping without review
- Focusing only on style
- Missing security implications
```

---

## Checklist for Good Skills

```xml
<GoodSkillIndicators>
  <Item>Name uses lowercase and hyphens</Item>
  <Item>Name matches directory name</Item>
  <Item>Description under 1024 characters</Item>
  <Item>Description has WHAT clause</Item>
  <Item>Description has WHEN clause</Item>
  <Item>Description in third person</Item>
  <Item>SKILL.md under 500 lines</Item>
  <Item>References one level deep</Item>
  <Item>One topic per reference file</Item>
  <Item>Includes anti-patterns section</Item>
</GoodSkillIndicators>
```
