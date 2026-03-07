# Anti-patterns: Man-in-the-Middle (MITM)

Security anti-patterns related to man-in-the-middle vulnerabilities in network communication. MITM attacks occur when an attacker positions themselves between two communicating parties, intercepting and potentially modifying traffic. These anti-patterns cover TLS misconfiguration, certificate validation failures, transport security gaps, and missing mutual authentication that enable network-level interception. Each pattern includes signs to look for, its impact, and a concrete fix.

## Disabled Certificate Validation — Critical

**Signs**: Explicitly disabling TLS certificate verification in HTTP clients. Python: `requests.get(url, verify=False)` or `urllib3.disable_warnings()` to suppress InsecureRequestWarning. Node.js: `process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'` or setting `rejectUnauthorized: false` in HTTPS agent options. Java: custom `TrustManager` that accepts all certificates (`X509TrustManager` with empty `checkServerTrusted` method). Go: `tls.Config{InsecureSkipVerify: true}`. Ruby: `OpenSSL::SSL::VERIFY_NONE`. C#: `ServicePointManager.ServerCertificateValidationCallback = (s, cert, chain, errors) => true`. Often introduced as a "temporary fix" for certificate errors during development and never removed.

**Impact**: With certificate validation disabled, the application accepts any certificate — including an attacker's self-signed certificate — without verification. Any network-level attacker (same WiFi, compromised router, ISP-level, BGP hijacking) can intercept all traffic. Credentials, API keys, personal data, and session tokens are exposed in plaintext to the attacker. This completely negates TLS encryption because the application cannot distinguish the legitimate server from an attacker's proxy.

**Fix**: Fix the root certificate issue instead of disabling validation. Common root causes and their fixes: expired certificate (renew it), self-signed certificate (use a proper CA), missing intermediate certificate (configure the full certificate chain on the server), outdated CA bundle (update the system CA store or bundle). Never deploy code with verification disabled. Add linting rules and CI checks to flag these patterns: `verify=False`, `rejectUnauthorized`, `InsecureSkipVerify`, custom `TrustManager`, `VERIFY_NONE`. Treat any disabled certificate validation as a build-breaking finding.

**Detection**:
- *Code patterns*: `verify=False` in Python requests/urllib3; `rejectUnauthorized: false` in Node.js; `InsecureSkipVerify: true` in Go; `X509TrustManager` with empty `checkServerTrusted` in Java; `VERIFY_NONE` in Ruby; `ServerCertificateValidationCallback` returning `true` in C#; `NODE_TLS_REJECT_UNAUTHORIZED=0` in environment
- *Review questions*: Is certificate validation disabled anywhere in the codebase, including test utilities, scripts, or development configurations? Are there suppressed certificate warnings? Do any HTTP clients use custom trust managers?
- *Test methods*: Search the entire codebase for certificate validation disable patterns in all supported languages. Use a MITM proxy (mitmproxy, Burp Suite) with a non-trusted certificate and verify the application rejects the connection. Check CI/CD environment variables for `NODE_TLS_REJECT_UNAUTHORIZED` or equivalent. Run static analysis tools configured to flag disabled certificate validation

---

## Self-Signed Certificates in Production — Critical

**Signs**: Production services using self-signed certificates because "it is internal" or "it is encrypted so it is secure." Certificate warnings dismissed or suppressed in production monitoring. No certificate expiration monitoring. Certificates with unreasonably long validity periods (10+ years). No Certificate Revocation List (CRL) or Online Certificate Status Protocol (OCSP) support. Developers trained to click through certificate warnings.

**Impact**: Self-signed certificates cannot be revoked if the private key is compromised — there is no revocation mechanism. They provide no identity verification — an attacker's self-signed certificate is indistinguishable from the legitimate one. They train users and developers to accept certificate warnings, weakening security culture. Internal services communicating with self-signed certificates are vulnerable to any attacker who gains network access (lateral movement after initial compromise). The "it is internal" argument fails because internal networks are the primary target after perimeter breach.

**Fix**: Use proper CA-signed certificates for all services, including internal ones. For internal services, deploy an internal Certificate Authority: HashiCorp Vault PKI secrets engine, AWS Private CA, step-ca (open source), or Microsoft AD Certificate Services. Automate certificate issuance and rotation with cert-manager (Kubernetes), Certbot (Let's Encrypt), or ACME protocol clients. Set certificate validity to 90 days or less (forces automation, limits exposure). Implement certificate expiration monitoring and alerting. Never accept self-signed certificates in any environment except local development.

**Detection**:
- *Code patterns*: Self-signed certificate files (check `openssl x509 -in cert.pem -noout -issuer -subject` — issuer equals subject); certificate generation scripts using `openssl req -x509` in deployment automation; hardcoded certificate acceptance in trust stores; certificates with validity > 1 year
- *Review questions*: Are any production or staging services using self-signed certificates? Is there an internal CA for internal service certificates? Are certificate lifetimes automated and short (< 90 days)? Is certificate expiration monitored?
- *Test methods*: Scan all production endpoints and check certificate chains (`openssl s_client -connect host:port`). Verify certificates are issued by a trusted CA (not self-signed). Check certificate validity periods. Verify CRL/OCSP is configured and functional. Enumerate all internal service certificates and verify CA-signed issuance

---

## HTTP Downgrade / Mixed Content — Major

**Signs**: Loading HTTP (unencrypted) resources on HTTPS pages — scripts, stylesheets, images, fonts, iframes, or API calls over HTTP. Missing `Strict-Transport-Security` (HSTS) header on HTTPS responses. HSTS header present but with short `max-age` (< 31536000), missing `includeSubDomains`, or missing `preload` directive. HTTP-to-HTTPS redirect configured at the application level but not at the infrastructure/load balancer level. No submission to the HSTS preload list. Cookies set without the `Secure` flag.

**Impact**: SSL stripping attacks (sslstrip) intercept the initial HTTP request before the 301/302 redirect to HTTPS, rewriting all subsequent HTTPS links to HTTP. Without HSTS, the browser has no way to know the site should only be accessed over HTTPS on the first visit. Mixed content on HTTPS pages leaks cookies and session tokens on the unencrypted HTTP request. A single HTTP resource loaded on an HTTPS page can be modified by an attacker to inject malicious JavaScript. Cookies without the `Secure` flag are sent over HTTP connections, exposing session tokens.

**Fix**: Set `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload` on all HTTPS responses. Submit the domain to the HSTS preload list (hstspreload.org) for browser-level enforcement. Eliminate all HTTP resources — convert all URLs to HTTPS or use protocol-relative URLs. Set the `Secure` flag on all cookies. Redirect HTTP to HTTPS at the infrastructure level (load balancer, CDN) before the request reaches the application. Use `Content-Security-Policy: upgrade-insecure-requests` as an additional layer. Configure `block-all-mixed-content` CSP directive.

**Detection**:
- *Code patterns*: `http://` URLs in HTML, CSS, JavaScript, or configuration files; missing `Strict-Transport-Security` header in server configuration; cookies set without `Secure` flag; HSTS `max-age` < 31536000; missing `includeSubDomains` or `preload` in HSTS header
- *Review questions*: Is HSTS configured with max-age >= 31536000, includeSubDomains, and preload? Is the domain on the HSTS preload list? Are all resources loaded over HTTPS? Do all cookies have the Secure flag? Is HTTP-to-HTTPS redirect handled at the infrastructure level?
- *Test methods*: Scan all pages for mixed content (browser developer tools, mixed content scanners). Check HSTS header presence and configuration (`curl -I https://domain`). Verify the domain is on the HSTS preload list. Test with sslstrip to verify HSTS prevents downgrade. Check all Set-Cookie headers for the Secure flag. Use Mozilla Observatory or similar tools for transport security scoring

---

## Improper Hostname Verification — Major

**Signs**: Custom TLS hostname verification logic that accepts any hostname or uses incorrect matching. Java: `HostnameVerifier` that returns `true` for all hostnames (`(hostname, session) -> true`). Custom SSL socket factories that skip hostname checks. Acceptance of certificates where the Common Name (CN) or Subject Alternative Name (SAN) does not match the requested hostname. Wildcard certificate matching applied to non-wildcard domains. Matching against CN only without checking SAN fields (CN is deprecated for hostname verification per RFC 6125).

**Impact**: An attacker with a valid certificate for `attacker.com` (which is trivial to obtain from any CA) can intercept connections to `your-api.com` because the application does not verify that the certificate's hostname matches the requested hostname. This completely defeats TLS endpoint authentication. The connection is encrypted (confidentiality with the attacker) but not authenticated (the client talks to the attacker, not the intended server). This is one of the most dangerous TLS misconfigurations because it is difficult to detect in testing — everything appears to work correctly.

**Fix**: Use the default hostname verifier provided by the TLS library — do not implement custom hostname verification logic. Java: use `HttpsURLConnection.getDefaultHostnameVerifier()` or the default `SSLContext`. Python: `requests` library verifies hostnames by default. Go: the default `tls.Config` verifies hostnames. If custom hostname verification is absolutely required (e.g., for certificate pinning), have the implementation security-reviewed and tested against RFC 6125 compliance. Verify both CN and SAN fields. Implement correct wildcard matching (wildcards only in the leftmost label).

**Detection**:
- *Code patterns*: Custom `HostnameVerifier` returning `true` in Java; `SSLContext` with `ALLOW_ALL_HOSTNAME_VERIFIER`; custom SSL socket factories that override hostname verification; hostname verification callbacks that always succeed; `check_hostname = False` in Python ssl module
- *Review questions*: Is hostname verification using the platform default or a custom implementation? If custom, has it been security-reviewed against RFC 6125? Does it check both CN and SAN fields? Does it handle wildcards correctly?
- *Test methods*: Connect to the application server using a valid certificate for a different domain (e.g., use `curl --resolve` to redirect to a server with a mismatched certificate). Verify the application rejects the connection. Test with a wildcard certificate to verify correct wildcard matching. Search the codebase for custom hostname verifiers

---

## Missing mTLS for Internal Services — Major

**Signs**: Internal service-to-service communication using plaintext HTTP or one-way TLS (server certificate only, no client authentication). No client certificates issued for internal services. Any process on the internal network can call any internal API without identity verification. Service identity based solely on network location (IP address, subnet) or shared secrets (API keys, bearer tokens) rather than cryptographic identity. No service mesh or mutual authentication layer.

**Impact**: In modern cloud environments, the internal network is not a trust boundary. A compromised container, lateral movement from a single breached service, or a malicious insider can reach all internal APIs without authentication. Without mutual TLS, there is no cryptographic proof of service identity — any process can impersonate any service. Network-based controls (security groups, network policies) provide defense-in-depth but are not sufficient alone. Kubernetes pod-to-pod communication without mTLS allows any compromised pod to access any service in the cluster.

**Fix**: Implement mutual TLS (mTLS) between all internal services. Use a service mesh (Istio, Linkerd, Consul Connect) to automate mTLS with zero application code changes. Issue short-lived certificates (hours, not years) from an internal CA using SPIFFE/SPIRE for workload identity. Implement service identity verification — each service has a cryptographic identity that is verified on every connection. Use network policies as a complementary control (defense-in-depth), not as the primary authentication mechanism. Rotate client certificates automatically.

**Detection**:
- *Code patterns*: Internal service URLs using `http://` instead of `https://`; HTTP clients without client certificate configuration; no client certificate files or SPIFFE trust bundles in deployment configurations; service authentication using only API keys or bearer tokens without mTLS
- *Review questions*: Do internal services communicate over mTLS? Is there a service mesh deployed? Are service identities cryptographically verified (SPIFFE/SPIRE)? Are client certificates short-lived and automatically rotated? Could a compromised service impersonate another service?
- *Test methods*: Attempt to call internal APIs without a client certificate — if successful, mTLS is not enforced. Verify that service mesh is deployed and mTLS is in strict mode (not permissive). Check certificate lifetimes for internal service certificates. Attempt to use one service's client certificate to authenticate as a different service. Run network scans for plaintext HTTP on internal service ports

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|-------------------|------------|
| Disabled Certificate Validation | Critical | A4: Data Protection, O3: Infrastructure Hardening | Both |
| Self-Signed Certificates in Production | Critical | A4: Data Protection, O3: Infrastructure Hardening | Implementation |
| HTTP Downgrade / Mixed Content | Major | A4: Data Protection, O3: Infrastructure Hardening | Both |
| Improper Hostname Verification | Major | A4: Data Protection | Implementation |
| Missing mTLS for Internal Services | Major | A4: Data Protection, O3: Infrastructure Hardening | Both |
