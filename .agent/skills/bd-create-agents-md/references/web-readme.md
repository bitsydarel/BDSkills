# Web Component Reference

Use this for any web stack (JS, Python, Rust, etc.).

## Minimal AGENTS.md Example: Single-Repo Web Project
Most web projects are NOT monorepos. Here’s a canonical AGENTS.md snippet for a single-repo web application (React, Vue, Svelte, Next.js, Flask, Django, Express, etc.):

```markdown
## Project Overview
This repository contains a single web application built with [STACK] ([FRAMEWORK], e.g., React, Vue, Next.js, Flask, Django, Svelte).

## Target Audience
Web developers and product engineers deploying, maintaining, or contributing to this site/app.

## Key Commands
- Setup: `[SETUP_COMMAND]` (e.g., `npm install`, `yarn install`, `pip install -e .`)
- Build: `[BUILD_COMMAND]` (e.g., `npm run build`, `yarn build`)
- Test: `[TEST_COMMAND]` (e.g., `npm test`, `yarn test`, `pytest`)
- Run: `[RUN_COMMAND]` (e.g., `npm start`, `yarn dev`, `python app.py`)
- Lint (optional): `[LINT_COMMAND]` (e.g., `eslint .`, `flake8 .`)

## Security
Follow [OWASP Top Ten 2025](https://owasp.org/Top10/2025/) and update dependencies regularly.
- Validate and sanitize all user input/output.
- Review for accessibility using [axe](https://www.deque.com/axe/), [eslint-plugin-jsx-a11y](https://github.com/jsx-eslint/eslint-plugin-jsx-a11y), or framework a11y tooling.

## Accessibility
- Use semantic HTML and ARIA roles ([MDN HTML](https://developer.mozilla.org/docs/Web/HTML)).
- Ensure keyboard navigation and screen reader compatibility. See [W3C WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/).

## Additional Docs
- CONTRIBUTING.md (if present)
- README.md (for project-specific notes, quirks, or conventions)
- .github/workflows/ci.yml (if present)
```

Fill `[STACK]`, `[FRAMEWORK]`, and command placeholders to match your tech stack and folder layout. If your project uses a modern meta-framework (e.g., Next.js, SvelteKit, Nuxt), update Build/Run accordingly.

---

## Setup/Build/Test Commands
- JS: `npm install`, `yarn install`, `npm run build`, `npm test`
- Python: `pip install -e .`, `pytest`
- Rust: `cargo build`, `cargo test`

## Security & Best Practices
- Validate all user input, encode all output. See [OWASP Top Ten 2025](https://owasp.org/Top10/2025/)
- Use semantic HTML ([MDN HTML](https://developer.mozilla.org/docs/Web/HTML)), responsive CSS ([MDN CSS](https://developer.mozilla.org/docs/Web/CSS)).
- Consider accessibility guidelines ([W3C WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/)).
- Follow secure dependency management, up-to-date packages.

_All guidance reviewed annually for global standard compliance. Last review: Jan 2026._

## Progressive Enhancement / Accessibility
- Use ARIA roles and ensure keyboard navigation.
- Check compatibility and responsiveness across browsers/devices.

For more, see [MDN Web Docs](https://developer.mozilla.org/en-US/)
