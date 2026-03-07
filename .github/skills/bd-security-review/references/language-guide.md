# Language selection guide

Use this guide when reviewing polyglot systems to determine which language reference(s) to load.

## Multi-language guidance

When reviewing a polyglot system (e.g., Python backend + TypeScript frontend + Go microservices):

1. **Load all relevant language files** — Read the primary language file first, then supplementary ones.
2. **Union the vulnerability checklists** — Check secure coding items from all loaded languages.
3. **Cross-language boundaries are trust boundaries** — Data crossing from one language runtime to another (e.g., Go service sending JSON to Python consumer) should be validated on both sides.
4. **Tooling must cover each language** — Verify SAST/SCA tools are configured for every language in the stack, not just the primary one.
5. **Use the strictest standard** — If one language's checklist requires parameterized queries and another doesn't mention it, apply the stricter requirement.

## Polyglot evaluation methodology

Follow these 6 steps when reviewing a multi-language codebase:

### Step 1: Language inventory

List every language in the stack with its role and attack surface exposure:

| Language | Role | Exposure Level | Primary Threats |
|----------|------|---------------|----------------|
| TypeScript | Frontend SPA | Direct user interaction | XSS, prototype pollution, client-side logic bypass |
| Python | API backend | Network-exposed | Injection, deserialization, SSRF |
| Go | Internal microservices | Internal network only | Goroutine leaks, race conditions, SSRF via internal APIs |
| Rust | Performance-critical module | Called via FFI | Unsafe block misuse, FFI boundary issues |

### Step 2: Cross-language boundary mapping

Identify every point where data crosses language runtime boundaries. Each crossing is a trust boundary requiring validation.

| Boundary | Data Exchanged | Serialization Format | Validation Required |
|---------|---------------|---------------------|-------------------|
| TypeScript → Python (HTTP) | User input, auth tokens | JSON | Schema validation on Python side (Pydantic/Zod) |
| Python → Go (gRPC) | Processed data, internal tokens | Protobuf | Protobuf schema enforces types; validate business logic |
| Go → Rust (FFI) | Raw bytes, pointers | C ABI | Rust unsafe block must validate all inputs from Go |
| Python → Database | Queries, PII | SQL/ORM | Parameterized queries, no raw SQL |

### Step 3: Vulnerability deduplication

Some vulnerabilities appear in multiple language files (SQL injection, path traversal, SSRF). Deduplicate but check language-specific variants:

- **SQL injection**: Python uses `%s` placeholders, Go uses `$1`, TypeScript ORMs use `?`. Verify the correct parameterization syntax for each language.
- **Path traversal**: Python's `os.path.join` silently accepts absolute paths. Go's `filepath.Join` resolves `..`. Each has different gotchas.
- **SSRF**: Python's `requests` follows redirects; Go's `http.Get` follows redirects; each has different default behaviors for protocol handling.

### Step 4: Tooling coverage verification

For each language in the stack, verify that security tooling is configured and running:

| Tooling Category | Must Cover Each Language | Verification |
|-----------------|------------------------|-------------|
| **SAST** | Language-specific rules (Bandit for Python, gosec for Go, ESLint security for JS/TS) | Check CI/CD config for per-language SAST steps |
| **SCA** | Language-specific package manager (pip-audit, npm audit, govulncheck, cargo audit) | Check that each package manager's audit runs in CI |
| **Type checking** | Where available (mypy, tsc, go vet) | Type checking catches classes of bugs before runtime |
| **Secrets scanning** | Language-agnostic (GitLeaks, TruffleHog) | One scan covers all languages |
| **DAST** | Language-agnostic (targets running application) | One DAST scan covers the exposed surface |

**Coverage gap rule**: If any language in the stack lacks SAST or SCA coverage, flag it as an A6 scoring deduction. A polyglot system is only as secure as its least-scanned language.

### Step 5: Cross-language attack chains

Evaluate whether vulnerabilities in one language can chain with another:

| Attack Chain | How It Works | Detection |
|-------------|-------------|-----------|
| Frontend XSS → Backend SSRF | XSS in TypeScript frontend injects a request to the Python backend with an attacker-controlled URL, triggering SSRF | Review frontend output encoding AND backend URL validation |
| API injection → Internal service compromise | SQL injection in Python API extracts internal service credentials, used to access Go microservices | Review both SQL parameterization AND internal service auth |
| Deserialization → FFI exploit | Unsafe deserialization in Python creates malformed data passed to Rust via FFI, triggering unsafe block vulnerability | Review deserialization validation AND FFI input validation |
| Supply chain → Cross-language pivot | Compromised npm package in frontend build exfiltrates environment variables containing backend API keys | Review supply chain controls for ALL languages, not just the primary one |

### Step 6: Consolidated scoring

When scoring criteria for a polyglot system:

- **A3 (Input Validation)**: Score based on the weakest language's input handling. If Python endpoints use parameterized queries but one Go service uses string concatenation, A3 scores reflect the Go gap.
- **A5 (Supply Chain)**: Score based on the weakest language's dependency management. All package managers must have SCA configured.
- **A6 (Secure Coding)**: Score based on union of all language-specific findings. Each language's secure coding checklist must be satisfied.
- **General rule**: A criterion's score reflects the weakest language implementation unless the weak language has limited exposure (e.g., internal-only Rust module with no user input).
