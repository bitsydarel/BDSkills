# Server/API Component Reference

Works for REST, GraphQL, gRPC, and multi-language stacks.

## Minimal AGENTS.md Example: Single-Repo Server/API Project
Most server/API projects are single-repo services (Python, Node.js, Rust, Go, Java, etc). Use the following AGENTS.md snippet for typical API/backend scenarios:

```markdown
## Project Overview
This repository provides a [LANGUAGE/FRAMEWORK] API server (e.g., Flask, FastAPI, Django, Express, NestJS, Rust/Actix, Go/Gin, Java/Spring Boot) for [PURPOSE/DOMAIN].

## Target Audience
Backend/server engineers, SRE/devops, and (if open source) contributors.

## Key Commands
- Setup: `[SETUP_COMMAND]` (e.g., `pip install -e .`, `npm install`, `cargo build`, `go mod download`, `./gradlew build`)
- Build: `[BUILD_COMMAND]` (if separate, e.g., `go build`, `./gradlew build`, `cargo build`)
- Test: `[TEST_COMMAND]` (e.g., `pytest`, `npm test`, `cargo test`, `go test`, `./gradlew test`)
- Run: `[RUN_COMMAND]` (e.g., `python main.py`, `npm run start`, `cargo run`, `go run main.go`, `java -jar build/libs/*.jar`)
- Lint (optional): `[LINT_COMMAND]` (e.g., `black .`, `eslint .`, `gofmt`, `ktlint`, `checkstyle`)

## Security
Follow [OWASP API Top Ten 2023](https://owasp.org/www-project-api-security/), harden all endpoints, and manage environment variables/secrets externally (never commit secrets to code!).
- Implement rate limiting, input/output validation, and central error logging.
- For regulated data, include references for GDPR, HIPAA, or PCI as needed.

## Additional Docs
- CONTRIBUTING.md (if present)
- README.md (for service-specific details, entrypoints, config, etc.)
- .github/workflows/ci.yml (if present)
```

Fill `[LANGUAGE/FRAMEWORK]`, `[PURPOSE/DOMAIN]`, and command placeholders as needed. Mention `README.md` for project-specific service/config details where relevant.

---

## Setup/Build/Test Commands
- Python: `pip install -e .`, `pytest`
- Rust: `cargo build --workspace`, `cargo test`
- Node.js: `npm run build:server`, `npm test`

## Security & Best Practices
- Implement rate limiting, robust authentication, output validation.
- Use secure default configurations and actively monitor for vulnerabilities.
- Centralize logging, monitor for attack patterns.

## Standards & Compliance
- Follow [OWASP API Top Ten 2023](https://owasp.org/www-project-api-security/)
- Reference [NIST Cybersecurity Framework 2.0 (2024)](https://doi.org/10.6028/NIST.CSWP.29) for full lifecycle security controls.

For cloud or regulated scenarios, also link or reference the latest official compliance standards (GDPR, HIPAA, PCI-DSS, SOC 2). All content is reviewed annually for global compliance.
