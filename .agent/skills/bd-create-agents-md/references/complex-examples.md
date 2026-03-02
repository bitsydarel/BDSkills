# Complex AGENTS.md Examples

*All guidance and links reviewed annually for compliance with global standards. Last review: Jan 2026.*

This file provides advanced AGENTS.md examples for monorepos and multi-language projects.

**Quick primer:** Most repositories are single-project. Only use monorepo samples if your codebase manages more than one independent app, package, or deployable component, and shares configuration (like a workspace or root build).

- If unsure, start with minimal examples from the web/mobile/server references—they are simpler, easier to maintain, and more universally agent-friendly.
- Monorepos usually also define shared CI/CD workflows. Link to your `.github/workflows/ci.yml` or monorepo-specific workflows as appropriate.

Use the samples below if you have multiple platforms, packages, or languages in one repo.

---

## Python Monorepo (Poetry)
```markdown
## Project Overview
Multi-package Python workspace using Poetry.

## Key Commands
- Setup: `poetry install`
- Run: `poetry run <package>`
- Test: `pytest <package>`
```
See [Poetry Workspaces](https://python-poetry.org/docs/master/workspaces/)

---

## Rust Monorepo (Cargo Workspaces)
```markdown
## Project Overview
Rust monorepo for CLI and web services.

## Key Commands
- Setup: `cargo build --workspace`
- Test: `cargo test --workspace`
```
See [Cargo Workspaces](https://doc.rust-lang.org/cargo/reference/workspaces.html)

---

## JS Monorepo (Yarn/NPM Workspaces)
```markdown
## Project Overview
Monorepo with React frontend and Node.js backend.

## Key Commands
- Setup: `yarn install --workspaces`
- Run Frontend: `yarn workspace web start`
- Run Backend: `yarn workspace api start`
- Test: `yarn test`
```
See [OWASP Top Ten 2025](https://owasp.org/Top10/2025/)
