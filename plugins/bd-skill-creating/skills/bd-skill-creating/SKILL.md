---
name: bd-skill-creating
description: Step-by-step guide for creating effective agent skills following the open agent-skills standard. Use when scaffolding new skills, writing SKILL.md files, organizing reference documentation, or preparing skills for publication.
---

# Skill Creation Guide

This skill guides the creation of effective agent skills that follow the open agent-skills standard.

## Core Principles

1. **Concise is Key**: Only include context the agent does not already have.
2. **Progressive Disclosure**: SKILL.md for essentials, references for depth. See [references/progressive-disclosure.md](references/progressive-disclosure.md).
3. **Degrees of Freedom**: Match flexibility to task fragility (high/medium/low).
4. **Test with Targets**: Verify behavior with all intended agent models.

## Creation Workflow

### 1. Define Purpose & Triggers

Before writing, answer:
- **WHAT**: What capability does this skill provide?
- **WHEN**: What user requests should activate it?

### 2. Create Directory Structure

Create a directory with the skill name (lowercase, hyphens). For structure details, see [references/specification.md](references/specification.md).

### 3. Write SKILL.md

Create SKILL.md with YAML frontmatter (`name` + `description`) and markdown body. For frontmatter rules and body structure, see [references/specification.md](references/specification.md).

### 4. Organize References

Move detailed content to `references/` directory. For templates and patterns, see [references/templates.md](references/templates.md).

### 5. Validate & Publish

Run the validation checklist before publishing. See [references/validation.md](references/validation.md).

## Examples

For complete skill examples showing good and bad patterns, see [references/examples.md](references/examples.md).

## Anti-Patterns

- **Vague descriptions**: Missing WHAT or WHEN triggers
- **Information overload**: Too much content in SKILL.md without references
- **Deeply nested references**: More than one level deep
- **Time-sensitive content**: Dates, versions, "latest"
- **Platform-specific paths**: Windows backslashes, hardcoded paths
