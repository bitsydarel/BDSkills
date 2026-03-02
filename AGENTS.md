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

## Agent Structure

Edit agents ONLY in `agents/<agent-name>/` - all other locations are auto-generated.

Each agent directory:
```
agent-name/
├── AGENT.md           # Required - agent system prompt (<500 lines)
└── references/        # Optional - detailed orchestration docs
```

Agents are prompt-only orchestrations that coordinate multiple skills.
Synced as flat `<name>.md` files to platform agent directories.

```bash
./scripts/sync-agents.sh          # Sync agents to all agent tools
./scripts/sync-agents.sh --status # Check agent sync status
```

## References

- Spec: https://agentskills.io/specification
- Best practices: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
