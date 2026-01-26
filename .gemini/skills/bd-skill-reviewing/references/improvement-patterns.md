# Skill Improvement Patterns

How to fix common issues found during skill reviews.

## 1. Improving Descriptions

### Problem: Vague or Missing Description

**Before:**
```yaml
description: Helps with documents.
```

**After:**
```yaml
description: Converts, merges, and extracts content from PDF, Word, and Excel files. Use when the user needs to combine documents, extract text, or convert between formats.
```

### Description Formula

```
[Action verbs] [specific objects/domains]. Use when [trigger conditions].
```

**Examples:**
```yaml
# Domain skill
description: Analyzes financial data, generates reports, identifies trends. Use when working with spreadsheets, financial files, or when the user mentions revenue, costs, or budgets.

# Process skill
description: Guides systematic code review from start to finish. Use when the user asks to review a PR, check code quality, or provide feedback on changes.

# Tool skill
description: Integrates with Git for version control operations. Use when the user mentions commits, branches, merges, or asks about Git commands.
```

### Description Checklist

- [ ] Starts with action verbs (analyzes, guides, integrates)
- [ ] Names specific objects/domains
- [ ] Includes "Use when" clause
- [ ] Lists specific trigger keywords
- [ ] Written in third person
- [ ] Under 1024 characters

---

## 2. Restructuring Overloaded Content

### Problem: SKILL.md Too Long

**Symptoms:**
- SKILL.md > 200 lines without references
- SKILL.md > 500 lines (violation)
- Dense blocks of detailed instructions

### Solution: Progressive Disclosure

**Before (single large file):**
```markdown
# My Skill
[200 lines of overview]
[300 lines of detailed API reference]
[200 lines of examples]
```

**After (split structure):**
```
my-skill/
├── SKILL.md              # ~60 lines (overview + links)
└── references/
    ├── api-reference.md  # Detailed API
    └── examples.md       # Usage examples
```

**SKILL.md becomes:**
```markdown
# My Skill

Brief overview.

## Quick Start
[Essential instructions only]

## Detailed Documentation
- **API Reference**: See [references/api-reference.md]
- **Examples**: See [references/examples.md]
```

### Content Split Guidelines

| Content Type | Where to Put It |
|--------------|-----------------|
| Overview, principles | SKILL.md |
| Quick start (essential) | SKILL.md |
| Workflow steps | SKILL.md |
| Anti-patterns | SKILL.md |
| Detailed API | references/api.md |
| Extended examples | references/examples.md |
| Domain-specific guides | references/[domain].md |

---

## 3. Fixing Reference Organization

### Problem: Deeply Nested References

**Before:**
```
skill/
└── references/
    └── advanced/
        └── details/
            └── specifics.md
```

**After:**
```
skill/
└── references/
    ├── advanced-details.md
    └── specifics.md
```

### Flattening Strategy

1. Identify all leaf files (actual content)
2. Move to `references/` root
3. Use descriptive filenames: `[category]-[topic].md`
4. Update all links in SKILL.md

**Naming flattened files:**
- `advanced/api/methods.md` → `api-methods.md`
- `guides/getting-started.md` → `getting-started.md`
- `details/edge-cases.md` → `edge-cases.md`

---

## 4. Adding Effective Examples

### Problem: Abstract Instructions Without Examples

**Before:**
```markdown
## Commit Messages
Write good commit messages that describe changes.
```

**After:**
```markdown
## Commit Messages

**Example 1:**
Input: Added user authentication with JWT
Output:
```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**Example 2:**
Input: Fixed date display bug
Output:
```
fix(reports): correct date formatting

Use UTC timestamps consistently
```
```

### Example Pattern

```markdown
## [Task Name]

**Example 1:**
Input: [What the user provides]
Output:
[Expected result with formatting]

**Example 2:**
Input: [Different scenario]
Output:
[Expected result]
```

---

## 5. Fixing Trigger Conditions

### Problem: Missing or Vague Triggers

**Before:**
```yaml
description: Processes documents.
```

**Improved with trigger analysis:**

1. **Identify use cases**: When would someone need this?
2. **List keywords**: What words would they use?
3. **Write trigger clause**: "Use when [conditions]"

**After:**
```yaml
description: Extracts text and metadata from PDF files, fills PDF forms, merges multiple PDFs. Use when working with PDF documents, when the user mentions PDFs or forms, or when document extraction is needed.
```

### Trigger Keyword Categories

| Category | Example Keywords |
|----------|------------------|
| File types | PDF, Excel, Word, JSON, CSV |
| Actions | extract, convert, merge, analyze |
| Domains | financial, legal, medical, sales |
| Objects | forms, reports, documents, data |

---

## Improvement Summary

```xml
<ImprovementPatterns>
  <Pattern name="Description">
    <Issue>Vague or missing WHAT/WHEN</Issue>
    <Fix>Use formula: [Action verbs] [objects]. Use when [triggers].</Fix>
  </Pattern>
  <Pattern name="Content">
    <Issue>SKILL.md too long</Issue>
    <Fix>Split to references/, keep SKILL.md as overview</Fix>
  </Pattern>
  <Pattern name="References">
    <Issue>Deeply nested</Issue>
    <Fix>Flatten to single level with descriptive names</Fix>
  </Pattern>
  <Pattern name="Examples">
    <Issue>Too abstract</Issue>
    <Fix>Add input/output pairs</Fix>
  </Pattern>
  <Pattern name="Triggers">
    <Issue>Missing conditions</Issue>
    <Fix>Analyze use cases, add "Use when" clause</Fix>
  </Pattern>
</ImprovementPatterns>
```
