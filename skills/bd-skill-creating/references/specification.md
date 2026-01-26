# Agent Skills Specification

Complete specification for SKILL.md files and skill directory structure.

## YAML Frontmatter

### Required Fields

```yaml
---
name: skill-name
description: What this skill does. Use when [trigger conditions].
---
```

| Field | Constraints |
|-------|-------------|
| `name` | 1-64 chars, lowercase letters/numbers/hyphens only, must match directory name, no consecutive hyphens, cannot start/end with hyphen |
| `description` | 1-1024 chars, non-empty, describes WHAT + WHEN, third person voice |

### Optional Fields

```yaml
---
name: skill-name
description: Description here.
license: Apache-2.0
compatibility: Requires git and docker
metadata:
  author: org-name
  version: "1.0"
allowed-tools: Bash(git:*) Read
---
```

| Field | Constraints |
|-------|-------------|
| `license` | License name or reference to bundled file |
| `compatibility` | 1-500 chars, environment requirements |
| `metadata` | Key-value pairs for custom properties |
| `allowed-tools` | Space-delimited list (experimental) |

## Name Field Rules

**Valid patterns:**
- `pdf-processing` (gerund with hyphen)
- `data-analysis` (noun phrase)
- `code-review` (action phrase)

**Invalid patterns:**
- `PDF-Processing` (uppercase)
- `-pdf` (starts with hyphen)
- `pdf--processing` (consecutive hyphens)
- `pdf_processing` (underscores)
- `pdf.processing` (dots)

**Naming convention**: Prefer gerund form (verb + -ing) for clarity.
- `processing-pdfs` instead of `pdf-processor`
- `analyzing-data` instead of `data-analyzer`

## Description Field Rules

Must include:
1. **WHAT**: Capabilities the skill provides
2. **WHEN**: Trigger conditions for activation

**Good example:**
```yaml
description: Extracts text and tables from PDF files, fills forms, merges documents. Use when working with PDFs or when the user mentions document extraction.
```

**Bad examples:**
```yaml
description: Helps with PDFs.                    # Too vague
description: I can help you process documents.  # First person
description: You can use this for documents.    # Second person
```

## Directory Structure

```
skill-name/                    # Must match frontmatter name
├── SKILL.md                   # Required, <500 lines
├── references/                # Optional
│   ├── guide.md               # One topic per file
│   └── api.md                 # One level deep only
├── scripts/                   # Optional
│   ├── helper.py              # Self-contained code
│   └── validate.sh            # Clear error messages
└── assets/                    # Optional
    ├── template.json          # Static resources
    └── schema.yaml            # Lookup tables, schemas
```

## Progressive Disclosure

Skills load content in stages:

| Level | When Loaded | Token Cost | Content |
|-------|-------------|------------|---------|
| Metadata | Always (startup) | ~100 tokens | `name` and `description` |
| Instructions | When triggered | <5000 tokens | SKILL.md body |
| Resources | As needed | Unlimited | Files in references/, scripts/, assets/ |

**Guidelines:**
- Keep SKILL.md under 500 lines
- Move detailed content to references/
- Keep reference files focused (<100 lines each)
- Use relative paths for linking

## File References

Always use forward slashes:
- `[guide](references/guide.md)` (correct)
- `[guide](references\guide.md)` (wrong)

Keep references one level deep:
- `SKILL.md → references/topic.md` (correct)
- `SKILL.md → references/sub/topic.md` (avoid)
