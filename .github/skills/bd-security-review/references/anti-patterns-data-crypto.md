# Anti-patterns: Data Protection & Cryptography

Security anti-patterns related to encryption, key management, data in transit, and secrets handling. Each pattern includes signs to look for, its impact, and a concrete fix.

## Crypto Cargo Cult — Critical

**Signs**: Using MD5 or SHA1 for password hashing. Hardcoded encryption keys in source code or environment variables. ECB mode for block ciphers. Custom encryption algorithms ("we XOR with a secret key"). Base64 encoding described as "encryption." Using encryption without key rotation. Storing initialization vectors alongside ciphertext without understanding why they exist.

**Impact**: Data that appears encrypted is trivially recoverable. Password databases compromised via rainbow tables or brute force. Regulatory compliance (PCI DSS, GDPR) violated despite apparent encryption. Hardcoded keys mean a single source code leak exposes all encrypted data permanently.

**Fix**: Use only approved algorithms: Argon2id/bcrypt/scrypt for passwords, AES-256-GCM for symmetric encryption, RSA-OAEP/ECDH for asymmetric. Store keys in HSM, KMS, or vault — never in code. Implement key rotation on a schedule. If anyone on the team says "we wrote our own encryption," stop and replace with a reviewed library.

**Detection**:
- *Code patterns*: `MD5`, `SHA1` (for security), `DES`, `ECB` in crypto code; encryption keys as string literals; `base64.encode` described as encryption in comments; custom XOR encryption
- *Review questions*: What algorithm is used for password hashing? Where are encryption keys stored? When were keys last rotated? Is there a custom encryption implementation?
- *Test methods*: Grep for deprecated algorithms (MD5, SHA1, DES, RC4, ECB). Search for hardcoded keys or secrets in source. Verify key management uses KMS/HSM/vault, not config files

---

## HTTPS Everywhere Myth — Major

**Signs**: TLS configured on the load balancer but internal service-to-service traffic is plaintext. Database connections without TLS. SMTP without STARTTLS. API calls to third-party services over HTTP. Certificate validation disabled in code (`verify=False`, `NODE_TLS_REJECT_UNAUTHORIZED=0`).

**Impact**: Internal network traffic is sniffable. A single compromised internal host enables man-in-the-middle attacks on all unencrypted internal traffic. Database credentials visible on the wire. TLS termination at the edge creates a false sense of security for east-west traffic.

**Fix**: Enforce TLS for all connections: external, internal service-to-service (mTLS), database, cache, message queue. Never disable certificate verification. Use service mesh (Istio, Linkerd) for automatic mTLS between microservices. Scan for plaintext protocols on internal networks.

**Detection**:
- *Code patterns*: `verify=False` (Python), `NODE_TLS_REJECT_UNAUTHORIZED=0` (Node), `InsecureSkipVerify: true` (Go); database connection strings without `sslmode=require`; internal HTTP URLs in service configs
- *Review questions*: Is TLS used for all internal service-to-service communication? Are database connections encrypted? Is certificate validation ever disabled?
- *Test methods*: Scan internal network for plaintext protocols (nmap). Check database connection strings for SSL parameters. Verify no code disables certificate validation

---

## Secret Sprawl — Major

**Signs**: API keys, database passwords, or tokens in source code, config files, environment variables in docker-compose, CI/CD pipeline definitions, or Slack messages. `.env` files committed to repositories. Secrets shared via email or chat. No central secrets management tool in use.

**Impact**: Secrets in source code persist in git history even after deletion. A single repository leak (accidental public repo, stolen laptop, compromised CI/CD) exposes all secrets. Rotation becomes impossible when secrets are hardcoded in multiple locations.

**Fix**: Adopt a secrets management solution (HashiCorp Vault, AWS Secrets Manager, 1Password Connect). Scan repositories for secrets with tools like GitLeaks, TruffleHog, or detect-secrets. Add pre-commit hooks to block secret commits. Rotate all secrets found in code immediately.

**Detection**:
- *Code patterns*: Strings matching API key patterns (`AKIA`, `sk_live_`, `ghp_`); `.env` files in git history; secrets in CI/CD pipeline definitions; `docker-compose.yml` with embedded passwords
- *Review questions*: Where are secrets stored? Has the repository been scanned for historical secret commits? Are secrets rotated on a schedule?
- *Test methods*: Run GitLeaks or TruffleHog against the repository (including history). Check CI/CD configs for embedded secrets. Verify a secrets management solution is in use

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|------------------|------------|
| Crypto Cargo Cult | Critical | A4: Data Protection | Both |
| HTTPS Everywhere Myth | Major | A4: Data Protection | Implementation |
| Secret Sprawl | Major | O3: Infrastructure Hardening | Both |
