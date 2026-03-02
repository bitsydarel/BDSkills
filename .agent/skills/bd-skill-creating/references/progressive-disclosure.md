# Progressive Disclosure Patterns

How to structure skills so agents load content efficiently.

## Why Progressive Disclosure

Skills load content in stages to minimize token usage:

| Level | When Loaded | Token Cost | What Goes Here |
|-------|-------------|------------|----------------|
| **Metadata** | Always (startup) | ~100 tokens | `name` and `description` only |
| **Instructions** | When triggered | <5000 tokens | SKILL.md body |
| **Resources** | As needed | Unlimited | Files in references/, scripts/, assets/ |

**Key insight**: Only SKILL.md content enters the context window when triggered. Reference files load only when the agent reads them.

## SKILL.md Content Guidelines

SKILL.md should contain **only essential content**:

```xml
<WhatBelongsInSkillMd>
  <Include>1-2 sentence introduction</Include>
  <Include>Core principles (3-5 bullet points)</Include>
  <Include>Workflow overview (1 line per step)</Include>
  <Include>Links to references for details</Include>
  <Include>Anti-patterns list (brief)</Include>
</WhatBelongsInSkillMd>

<WhatBelongsInReferences>
  <Move>Detailed specifications</Move>
  <Move>Complete examples with code</Move>
  <Move>Step-by-step tutorials</Move>
  <Move>API references</Move>
  <Move>Checklists and validation rules</Move>
  <Move>Templates</Move>
  <Move>Before/after comparisons</Move>
</WhatBelongsInReferences>
```

## Pattern 1: Overview + Links

SKILL.md provides overview, links to details.

**SKILL.md:**
```markdown
## Workflow

1. **Analyze input** - Understand the data format
2. **Process data** - Apply transformations
3. **Validate output** - Verify results

For detailed steps, see [references/workflow-details.md](references/workflow-details.md).
```

**references/workflow-details.md:**
```markdown
# Workflow Details

## Step 1: Analyze Input

[Detailed instructions, code examples, edge cases...]

## Step 2: Process Data

[Detailed instructions, code examples, edge cases...]
```

## Pattern 2: Domain-Specific References

Organize references by domain to load only relevant content.

**Directory structure:**
```
my-skill/
├── SKILL.md
└── references/
    ├── finance.md      # Finance-specific guidance
    ├── sales.md        # Sales-specific guidance
    └── marketing.md    # Marketing-specific guidance
```

**SKILL.md:**
```markdown
## Domain Guides

Select the guide for your domain:
- **Finance**: See [references/finance.md](references/finance.md)
- **Sales**: See [references/sales.md](references/sales.md)
- **Marketing**: See [references/marketing.md](references/marketing.md)
```

When user asks about sales data, agent loads only `sales.md`.

## Pattern 3: Conditional Details

Basic content inline, advanced content linked.

**SKILL.md:**
```markdown
## Basic Usage

Use the default configuration for most cases:
```python
process(data)
```

## Advanced Configuration

For custom configurations, see [references/advanced-config.md](references/advanced-config.md).
```

## Pattern 4: Checklist in Reference

Keep checklists in references, not SKILL.md.

**Bad (in SKILL.md):**
```markdown
## Validation Checklist

- [ ] Check field A
- [ ] Verify condition B
- [ ] Confirm requirement C
- [ ] Validate constraint D
- [ ] Test scenario E
... (50 more items)
```

**Good (SKILL.md links to reference):**
```markdown
## Validation

Run the validation checklist before publishing. See [references/validation.md](references/validation.md).
```

## Line Count Guidelines

| File Type | Target | Maximum |
|-----------|--------|---------|
| SKILL.md | <100 lines | 500 lines |
| Reference file | <100 lines | 200 lines |

**If SKILL.md exceeds 100 lines**, look for content to move:
- Detailed examples → `references/examples.md`
- Specifications → `references/specification.md`
- Checklists → `references/checklist.md`

## Self-Check Questions

Before finalizing, ask:

1. **Is this essential for triggering?** → Keep in SKILL.md
2. **Is this detailed guidance?** → Move to references/
3. **Will every use need this?** → Keep in SKILL.md
4. **Is this domain-specific?** → Split into domain references
5. **Is this a long list/table?** → Move to references/

## Anti-Patterns

```xml
<ProgressiveDisclosureAntiPatterns>
  <AntiPattern name="Monolithic SKILL.md">
    <Sign>SKILL.md over 200 lines with no references</Sign>
    <Fix>Split detailed content into references/</Fix>
  </AntiPattern>

  <AntiPattern name="Inline Checklists">
    <Sign>Long checklists directly in SKILL.md</Sign>
    <Fix>Move to references/checklist.md</Fix>
  </AntiPattern>

  <AntiPattern name="Duplicate Content">
    <Sign>Same information in SKILL.md and references</Sign>
    <Fix>Keep summary in SKILL.md, details in references</Fix>
  </AntiPattern>

  <AntiPattern name="Deep Nesting">
    <Sign>references/sub/deep/file.md</Sign>
    <Fix>Flatten to references/file.md</Fix>
  </AntiPattern>

  <AntiPattern name="No Links">
    <Sign>References exist but SKILL.md doesn't link to them</Sign>
    <Fix>Add explicit links in relevant sections</Fix>
  </AntiPattern>
</ProgressiveDisclosureAntiPatterns>
```
