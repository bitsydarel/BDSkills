# Security Review — CI/CD Pipelines

## Domain context

CI/CD pipelines are high-value targets: they have write access to production, hold deployment credentials, and execute arbitrary code. Supply chain attacks (SolarWinds, CodeCov, CircleCI breach) demonstrate that compromising the build pipeline is often easier than attacking the application directly. Pipeline security is unique because it intersects code security, infrastructure security, and access management. A single compromised pipeline step can inject malicious code into every deployment.

## OWASP CI/CD Security Risks Top 10 (2022) mapping

| # | Risk | Mapped Criteria |
|---|------|----------------|
| CICD-SEC-1 | Insufficient Flow Control Mechanisms | A2, G3 |
| CICD-SEC-2 | Inadequate Identity and Access Management | A1, A2 |
| CICD-SEC-3 | Dependency Chain Abuse | A5 |
| CICD-SEC-4 | Poisoned Pipeline Execution | A3, T2 |
| CICD-SEC-5 | Insufficient PBAC (Pipeline-Based Access Controls) | A2 |
| CICD-SEC-6 | Insufficient Credential Hygiene | O3 |
| CICD-SEC-7 | Insecure System Configuration | O3 |
| CICD-SEC-8 | Ungoverned Usage of 3rd Party Services | A5 |
| CICD-SEC-9 | Improper Artifact Integrity Validation | A5, G4 |
| CICD-SEC-10 | Insufficient Logging and Visibility | O1 |

## Criterion interpretation for CI/CD

| Criterion | Pipeline-Specific Interpretation |
|-----------|--------------------------------|
| T1 | Map all pipeline triggers (push, PR, schedule, webhook), runners, artifact registries, deployment targets |
| T2 | STRIDE for pipelines: spoofing via forked PRs, tampering via cache poisoning, info disclosure via log secrets |
| T3 | Source code → build → artifact → deploy is the trust chain. Each transition is a trust boundary |
| A1 | Pipeline runners authenticate via OIDC tokens (short-lived), not static credentials. Each job gets distinct identity |
| A2 | Least-privilege per pipeline stage: build cannot deploy, test cannot access production secrets. PBAC enforcement |
| A3 | PR metadata (title, branch name, commit message) is untrusted input — never interpolate into shell commands |
| A5 | Pin all third-party actions/orbs/plugins to commit SHA, not mutable tags. Audit pipeline dependencies |
| A6 | Resource limits on runners. Timeout configuration. No unbounded artifact storage |
| O1 | Pipeline logs retained, tamper-protected, monitored for anomalies (unexpected network calls, new registries) |
| O3 | Secrets in dedicated manager (Vault, platform encrypted secrets). Never in pipeline YAML or env vars in logs |
| G3 | Pipeline config changes require code review. Branch protection rules enforced |
| G4 | Artifact signing with Sigstore/cosign. Provenance attestation (SLSA). Traceable build-to-deploy chain |

## Top 5 CI/CD-specific anti-patterns

### 1. Shared Pipeline Credentials

**Signs**: Single service account used across all pipelines and environments. Organization-level secrets accessible by every repository. Same deployment key for staging and production.

**Impact**: Compromise of any single pipeline grants access to all environments. Blast radius maximized. Audit trails cannot attribute actions to specific pipelines.

**Fix**: Use OIDC token federation (GitHub Actions OIDC, GitLab CI JWT) for short-lived, scoped tokens per job. Eliminate long-lived static credentials. Per-environment, per-pipeline credential scoping.

---

### 2. Unsigned Artifacts

**Signs**: Container images deployed by tag (`latest`) without digest verification. Binaries deployed without signature checks. No provenance attestation connecting artifact to source code.

**Impact**: Compromised registry or MITM attack substitutes malicious artifact. No verification that deployed artifact matches reviewed source. Supply chain compromise goes undetected.

**Fix**: Sign all artifacts (cosign for containers, gitsign for commits). Pin image references to digests (`image@sha256:...`). Enforce signature verification in deployment stage. Generate SLSA provenance.

---

### 3. Pipeline Code Injection

**Signs**: Pipeline YAML interpolates `${{ github.event.pull_request.title }}` or branch names directly into shell commands. Fork PRs trigger workflows with access to repository secrets. `pull_request_target` used without understanding implications.

**Impact**: Attacker submits PR with crafted title that executes arbitrary code on CI runner, exfiltrating secrets or modifying artifacts. Full pipeline compromise from a single malicious PR.

**Fix**: Never interpolate external input directly into `run:` steps — use environment variables. Block fork PRs from accessing secrets. Audit all `pull_request_target` usage. Validate all pipeline inputs.

---

### 4. Secret Sprawl in Pipelines

**Signs**: Secrets hardcoded in pipeline YAML. Build logs expose secrets via `set -x` or debug output. Secrets in unencrypted build caches. Env vars containing secrets visible in pipeline UI.

**Impact**: Anyone with pipeline log access sees secrets. Git history preserves secrets in YAML. Build cache extraction reveals credentials.

**Fix**: Dedicated secrets manager with audit logging. Masked variables in CI platforms. Pre-commit hooks with detect-secrets/truffleHog. Rotate any secret that appeared in logs immediately.

---

### 5. No Build Reproducibility

**Signs**: Two builds from same commit produce different outputs. Dependencies pulled without pinned versions or checksums. Non-deterministic build ordering. No SLSA provenance attestation.

**Impact**: Cannot verify deployed artifact corresponds to reviewed source. Provenance attestations unreliable. Difficult to audit what was actually deployed.

**Fix**: Pin all build-time dependencies with cryptographic checksums. Use hermetic build tools (Bazel, Nix). Generate SLSA provenance attestations. Target SLSA Level 2 minimum.

---

## Key controls checklist

- [ ] Pipeline jobs use OIDC tokens — no long-lived static credentials
- [ ] Secrets in dedicated manager with audit logging, never in pipeline YAML
- [ ] Third-party actions/plugins pinned to immutable commit SHAs
- [ ] Branch protection requires review for pipeline configuration changes
- [ ] Fork PRs cannot access repository secrets
- [ ] Pipeline inputs (PR metadata, env vars) never interpolated into shell commands
- [ ] All build artifacts signed (cosign/Notary) with verification before deployment
- [ ] SLSA provenance attestations generated for production artifacts
- [ ] Pipeline logs retained 90+ days, tamper-protected
- [ ] Alerting on anomalous pipeline behavior (unexpected network calls, new registries)
- [ ] SCA runs on every build — critical CVEs block production promotion
- [ ] Runners are ephemeral — not reused across jobs or tenants

## Company practices

- **Google**: Binary Authorization for K8s deployments, SLSA framework originated internally, Bazel for hermetic builds, Borg-integrated deployment with approval gates
- **Netflix**: Spinnaker with security gates between environments, pipeline config as code with PR review, immutable infrastructure deployment, automated canary analysis
- **Microsoft**: Azure DevOps service connection scoping per pipeline, protected environment approvals, required reviewers on deployment stages
- **GitHub**: Actions OIDC federation, minimum-permission GITHUB_TOKEN, environment protection rules, all actions pinned to SHA references internally

## Tools and standards

- **Pipeline Hardening**: step-security/harden-runner (network egress monitoring), allstar (OpenSSF policy enforcement)
- **Artifact Signing**: Sigstore/cosign (keyless signing), gitsign (commit signing), Notary v2 (OCI artifacts)
- **SCA in CI**: Dependabot, Snyk, Trivy, syft+grype (SBOM generation + scanning)
- **Standards**: SLSA (supply chain levels), CIS Software Supply Chain Security Guide, NIST SP 800-204D, OpenSSF Scorecard
