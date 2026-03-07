# Security Review — Go

## Language security profile

- **Type system**: Statically typed with strong type safety. No implicit conversions. Interface-based polymorphism is safe. No generics-related vulnerabilities (generics are compile-time only)
- **Memory model**: Garbage collected with no manual memory management. Buffer overflows prevented by slice bounds checking. However, the `unsafe` package bypasses all safety guarantees
- **Ecosystem risks**: Go modules with checksum database (sum.golang.org) provide strong supply chain integrity. However, the go.sum file must be committed and verified. Private module proxies can be misconfigured
- **Execution contexts**: Cloud-native microservices, CLI tools, infrastructure (Kubernetes, Terraform, Docker), APIs, networking tools

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Goroutine leaks (resource exhaustion) | CWE-400 | A6 |
| 2 | SQL injection via string concatenation (database/sql misuse) | CWE-89 | A3 |
| 3 | Unsafe package misuse (bypassing memory safety) | CWE-787 | A6 |
| 4 | HTTP/2 rapid reset and related protocol vulnerabilities | CWE-400 | A6 |
| 5 | Path traversal via filepath.Join with user input | CWE-22 | A3 |
| 6 | SSRF via http.Get with user-controlled URLs | CWE-918 | A3 |
| 7 | Race conditions in concurrent code (missing synchronization) | CWE-362 | A6 |
| 8 | Weak cryptography (crypto/des, md5 for security) | CWE-327 | A4 |
| 9 | Improper error handling (ignoring returned errors) | CWE-754 | A6 |
| 10 | Template injection via html/template misuse | CWE-94 | A3 |

## Threat model context

Why each vulnerability matters in Go's execution context — use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | Goroutine leaks | Leaked goroutines consume memory and OS threads indefinitely. In long-running services (Kubernetes controllers, API servers), this causes slow resource exhaustion that is hard to diagnose |
| 2 | SQL injection | database/sql supports parameterized queries, but string concatenation is still syntactically valid. Developers coming from dynamic languages may default to concatenation |
| 3 | Unsafe package misuse | unsafe.Pointer bypasses Go's type system and memory safety. In infrastructure code (container runtimes, network tools), unsafe usage can introduce C-level memory corruption |
| 4 | HTTP/2 rapid reset | Go's net/http server was vulnerable to CVE-2023-44487. Protocol-level DoS attacks bypass application rate limiting because they exhaust resources at the connection level |
| 5 | Path traversal | filepath.Join() resolves .. but does not enforce a base directory. The resolved path must be checked with strings.HasPrefix() after cleaning |
| 6 | SSRF | http.Get() with user-controlled URLs can reach internal services. Go's HTTP client follows redirects by default, enabling redirect-based SSRF even when the initial URL is validated |
| 7 | Race conditions | Go's goroutine model makes concurrent code easy to write but race conditions easy to introduce. The -race detector only catches races exercised during testing, not all possible races |
| 8 | Weak cryptography | crypto/md5 and crypto/des are available in the standard library without deprecation warnings. Developers may choose them for "non-security" uses that later become security-relevant |
| 9 | Ignored errors | Go returns errors as values, and ignoring them is syntactically valid. A swallowed error in auth, crypto, or TLS code silently degrades security to no security |
| 10 | Template injection | text/template does not escape output (unlike html/template). Using text/template for HTML output enables XSS. The difference between the two packages is a single import path |

## Secure coding checklist

- [ ] Always check returned errors — use `errcheck` linter to catch ignored errors
- [ ] Use `context.WithTimeout` / `context.WithCancel` for all goroutines to prevent leaks
- [ ] Use parameterized queries with `database/sql`: `db.QueryRow("SELECT * FROM users WHERE id = $1", id)`
- [ ] Avoid the `unsafe` package entirely in application code; restrict to low-level libraries with thorough review
- [ ] Validate file paths: `filepath.Clean` + verify prefix with `strings.HasPrefix(cleaned, baseDir)`
- [ ] Validate URLs before `http.Get`: parse with `url.Parse`, check scheme and host against allowlist
- [ ] Use `go vet`, `staticcheck`, and `-race` flag in testing
- [ ] Use `crypto/rand` for randomness, not `math/rand`
- [ ] Use `html/template` (auto-escaping) for HTML output, never `text/template` for user-facing content
- [ ] Pin Go module versions and verify checksums via `GONOSUMCHECK` / `GONOSUMDB` are not set
- [ ] Set appropriate timeouts on all `http.Server` and `http.Client` instances

## Common misconfigurations

- **net/http**: Default server with no timeouts (ReadTimeout, WriteTimeout, IdleTimeout) — vulnerable to slowloris. Default client with no timeout — goroutine leak on hung connections
- **crypto/tls**: Setting `InsecureSkipVerify: true` for convenience — disables TLS certificate validation
- **encoding/json**: Trusting client-provided JSON without size limits — large payload DoS. Missing validation after unmarshaling
- **goroutines**: Spawning goroutines without context cancellation, without WaitGroup, and without error propagation — silent failures and resource leaks

## Security tooling

- **SAST**: gosec (Go-specific security linter), staticcheck, Semgrep (Go rules), CodeQL
- **SCA**: govulncheck (official Go vulnerability checker), Snyk, Dependabot
- **Dynamic**: `-race` flag for race condition detection, go-fuzz / native fuzzing (`go test -fuzz`)
- **Runtime**: net/http middleware for rate limiting, CORS, security headers

## Code examples

### Vulnerable: SQL injection

```go
// VULNERABLE: String concatenation in SQL
func getUser(db *sql.DB, username string) (*User, error) {
    query := "SELECT * FROM users WHERE username = '" + username + "'"
    row := db.QueryRow(query)
    // Attacker sends: ' OR '1'='1' --
}
```

### Secure: Parameterized query

```go
// SECURE: Parameterized query
func getUser(db *sql.DB, username string) (*User, error) {
    row := db.QueryRow("SELECT * FROM users WHERE username = $1", username)
    var user User
    err := row.Scan(&user.ID, &user.Username, &user.Email)
    return &user, err
}
```

### Vulnerable: Goroutine leak

```go
// VULNERABLE: Goroutine without cancellation
func fetchData(url string) {
    go func() {
        resp, err := http.Get(url) // No timeout, no context
        if err != nil { return }
        defer resp.Body.Close()
        // Process...
    }() // Goroutine may hang forever
}
```

### Secure: Context-controlled goroutine

```go
// SECURE: Bounded goroutine with context
func fetchData(ctx context.Context, url string) error {
    ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
    defer cancel()

    req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
    if err != nil { return err }

    client := &http.Client{Timeout: 15 * time.Second}
    resp, err := client.Do(req)
    if err != nil { return err }
    defer resp.Body.Close()
    // Process with bounded reader: io.LimitReader(resp.Body, maxSize)
    return nil
}
```
