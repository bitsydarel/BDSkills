# Anti-patterns: Supply Chain

Security anti-patterns related to dependency management, software supply chain, and provenance verification. Each pattern includes signs to look for, its impact, and a concrete fix.

## Dependency Graveyard — Major

**Signs**: Package lock files with dependencies last updated 12+ months ago. No automated dependency scanning in CI/CD. `npm audit` / `pip audit` / `cargo audit` not run regularly. Transitive dependencies with known critical CVEs. Forked libraries maintained internally without upstream sync.

**Impact**: Known vulnerabilities persist in production (Log4Shell, XZ Utils backdoor, Polyfill.io supply chain attack). Attack surface grows silently as new CVEs are published for stale dependencies. Upgrading becomes progressively harder, creating a vicious cycle of "too risky to update."

**Fix**: Integrate SCA tools (Dependabot, Snyk, Renovate) in CI/CD with blocking on critical/high CVEs. Define a patch SLA: critical CVEs within 48 hours, high within 1 week. Generate SBOM and review quarterly. Pin dependencies with hash verification.

**Detection**:
- *Code patterns*: Lock file (`package-lock.json`, `poetry.lock`, `go.sum`) with last modification >6 months ago; `npm audit` / `pip audit` not in CI/CD pipeline; forked repositories in dependency list
- *Review questions*: When was the last dependency update? Are there known critical CVEs in the dependency tree? Are forked dependencies synced with upstream?
- *Test methods*: Run `npm audit` / `pip audit` / `cargo audit` and check for critical/high findings. Check lock file git history for last update date. Scan for dependencies with no releases in 12+ months

---

## Supply Chain Ignorance — Major

**Signs**: No SBOM or dependency inventory. Packages installed from unofficial registries or forks. No lock file hash verification. Transitive dependencies not audited. Build pipeline fetches dependencies at build time from public registries without caching or verification.

**Impact**: Supply chain attacks (XZ Utils backdoor, event-stream, ua-parser-js, Polyfill.io CDN hijack, PyPI typosquatting) compromise the application through trusted dependencies. A single compromised package in the dependency tree gives the attacker full code execution.

**Fix**: Generate and maintain SBOM (SPDX or CycloneDX). Verify dependency provenance (SLSA, Sigstore). Cache dependencies in private registries. Audit transitive dependencies, not just direct ones. Monitor for package takeover advisories. Use lock files with integrity hashes.

**Detection**:
- *Code patterns*: No SBOM generation in build pipeline; `npm install` (not `npm ci`) in CI; packages from unofficial registries; no lock file hash verification; CDN scripts without SRI attributes
- *Review questions*: Is there a software bill of materials? Are dependencies fetched from verified sources? Are lock file hashes checked during builds?
- *Test methods*: Verify lock file integrity hashes are present. Check CI/CD for `npm ci` vs `npm install`. Scan for third-party scripts loaded without SRI. Look for dependency confusion risks (internal package names matching public registry)

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Dependency Graveyard | Major | A5: Supply Chain | Implementation |
| Supply Chain Ignorance | Major | A5: Supply Chain | Both |
