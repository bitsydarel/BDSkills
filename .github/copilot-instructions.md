# BD Skills

Agent skills repository following the open agent-skills standard.

Edit skills ONLY in `skills/<skill-name>/` - all other locations are auto-generated.

## Skill Structure

Each skill directory:
```
skill-name/
├── SKILL.md           # Required - main instructions (<500 lines)
├── references/        # Optional - detailed docs loaded on demand
├── scripts/           # Optional - executable code (Python, Bash, JS)
└── assets/            # Optional - templates, images, schemas
```

Naming: lowercase, hyphens only, directory name must match `name` in frontmatter.

## Commands

```bash
./scripts/sync-skills.sh          # Sync to all agent tools
./scripts/sync-skills.sh --status # Check sync status
./scripts/setup.sh                # Initial setup (installs git hooks)
```

Git hooks auto-sync on checkout/pull/merge.

## References

- Spec: https://agentskills.io/specification
- Best practices: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
