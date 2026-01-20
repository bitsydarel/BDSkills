# Process Guidelines

## Pull Request Readiness

Confirm these items before creating a PR:

- [ ] All quality checks pass locally (Format, Lint, Type, Test, Build)
- [ ] Tests cover new functionality
- [ ] No unrelated changes included (atomic PRs)
- [ ] Commits are logical and atomic
- [ ] No debugging code left behind (console.log, etc)
- [ ] Documentation/Comments updated

## Commit Message Format

Follow the Conventional Commits structure:

```text
<type>(<scope>): <short description>

<body - what and why, not how>

<footer - breaking changes, issue references>

```

### Types

```xml
<Types>
  <Type name="feat">New feature</Type>
  <Type name="fix">Bug fix</Type>
  <Type name="refactor">Code restructuring (no behavior change)</Type>
  <Type name="test">Adding/updating tests</Type>
  <Type name="docs">Documentation</Type>
  <Type name="style">Formatting (no logic change)</Type>
  <Type name="chore">Build/tooling changes</Type>
</Types>

```
