# Skill Templates

Ready-to-use templates for creating new skills.

## SKILL.md Template

```markdown
---
name: [skill-name]
description: [What this skill does - be specific]. Use when [trigger conditions - list specific scenarios].
---

# [Skill Title]

[1-2 sentence introduction explaining the skill's purpose.]

## Core Principles

1. **[Principle 1]**: [Brief explanation]
2. **[Principle 2]**: [Brief explanation]
3. **[Principle 3]**: [Brief explanation]

## Workflow

### 1. [First Step]
[Instructions for step 1]

### 2. [Second Step]
[Instructions for step 2]

### 3. [Third Step]
[Instructions for step 3]

## Reference Documentation

- **[Topic 1]**: See [references/topic1.md](references/topic1.md)
- **[Topic 2]**: See [references/topic2.md](references/topic2.md)

## Anti-Patterns

- **[Anti-pattern 1]**: [Why to avoid]
- **[Anti-pattern 2]**: [Why to avoid]
```

## Reference File Template

```markdown
# [Topic Title]

[Brief introduction - what this reference covers.]

## [Section 1]

[Content with examples]

## [Section 2]

[Content with code blocks or tables]

## Quick Reference

[Summary table or checklist]
```

## Frontmatter Templates

### Minimal (Required Fields Only)

```yaml
---
name: my-skill-name
description: Performs X and Y tasks. Use when the user asks about X or needs Y.
---
```

### Standard (Common Fields)

```yaml
---
name: my-skill-name
description: Performs X and Y tasks. Use when the user asks about X or needs Y.
metadata:
  author: your-org
  version: "1.0"
---
```

### Complete (All Fields)

```yaml
---
name: my-skill-name
description: Performs X and Y tasks. Use when the user asks about X or needs Y.
license: Apache-2.0
compatibility: Requires Python 3.9+ and pandas
metadata:
  author: your-org
  version: "1.0"
  tags: data,analysis
allowed-tools: Bash(python:*) Read Write
---
```

## Directory Structure Template

```
my-skill-name/
├── SKILL.md              # Main instructions
├── references/
│   ├── quickstart.md     # Getting started guide
│   ├── api.md            # API/method reference
│   └── examples.md       # Usage examples
├── scripts/              # (if needed)
│   └── helper.py
└── assets/               # (if needed)
    └── template.json
```

## Description Patterns

### Domain Skill
```yaml
description: Analyzes [domain] data, generates reports, identifies patterns. Use when working with [domain] files, [format] data, or when the user mentions [keywords].
```

### Process Skill
```yaml
description: Guides the [process] workflow from start to finish. Use when the user needs to [action] or asks about [topic].
```

### Tool Skill
```yaml
description: Integrates with [tool] to perform [actions]. Use when the user mentions [tool] or needs to [specific capability].
```
