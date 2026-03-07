# Security Review — Rust

## Language security profile

- **Type system**: Strong static typing with ownership system. The borrow checker prevents use-after-free, double-free, and data races at compile time — but `unsafe` blocks bypass all guarantees
- **Memory model**: Ownership + borrowing eliminates most memory safety bugs without garbage collection. Safe Rust prevents buffer overflows, dangling pointers, and race conditions. This is why ~70% of CVEs in C/C++ codebases simply cannot exist in safe Rust
- **Ecosystem risks**: crates.io has checksum verification but relies on community auditing. `cargo-audit` checks for known vulnerabilities. Build scripts (build.rs) execute arbitrary code during compilation
- **Execution contexts**: Systems programming, WebAssembly, embedded, CLI tools, web backends (Actix, Axum), cryptographic libraries, browser components (Firefox)

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Unsafe block misuse (bypassing borrow checker, raw pointers) | CWE-787 | A6 |
| 2 | FFI boundary vulnerabilities (calling C code, incorrect lifetimes) | CWE-120 | A6 |
| 3 | Soundness bugs (safe API allowing undefined behavior) | CWE-758 | A6 |
| 4 | Unsafe deserialization via serde with untrusted data | CWE-502 | A3 |
| 5 | Supply chain via crates.io (build.rs code execution, typosquatting) | CWE-1357 | A5 |
| 6 | Panics in production (unwrap/expect on None/Err in server code) | CWE-754 | A6 |
| 7 | Race conditions in unsafe code (bypassing Send/Sync) | CWE-362 | A6 |
| 8 | Cryptographic misuse (incorrect nonce reuse, timing attacks) | CWE-327 | A4 |
| 9 | SQL injection via raw query strings (sqlx raw queries) | CWE-89 | A3 |
| 10 | Integer overflow in release mode (wrapping, not panicking) | CWE-190 | A6 |

## Threat model context

Why each vulnerability matters in Rust's execution context — use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | Unsafe block misuse | Unsafe blocks opt out of Rust's borrow checker. A single unsafe block with a dangling pointer or buffer overflow undermines the memory safety guarantees of the entire crate |
| 2 | FFI boundary issues | Calling C libraries through FFI requires unsafe and introduces all C memory safety problems. A safe Rust API wrapping an unsafe FFI binding may propagate C vulnerabilities |
| 3 | Soundness bugs | A soundness bug in a safe API allows callers to trigger undefined behavior without writing unsafe. This breaks Rust's core safety contract and can affect any downstream user of the crate |
| 4 | Deserialization | serde with deny_unknown_fields is safe, but deserializing into types with unsafe implementations can trigger undefined behavior. Untrusted input shapes can also cause DoS via exponential parsing |
| 5 | Supply chain attacks | Crates.io dependencies are trusted code running with full process permissions. Build scripts (build.rs) run arbitrary code during compilation, before any runtime security controls apply |
| 6 | Panics in production | unwrap() and expect() on None/Err cause the current thread to panic. In server code, this terminates request handling and can be triggered deliberately by malformed input |
| 7 | Race conditions | Rust prevents data races at compile time, but logical race conditions (TOCTOU) in file operations and business logic are still possible. Send + Sync guarantees memory safety, not logical correctness |
| 8 | Cryptographic misuse | Rust's ring and rustcrypto crates are correct, but custom implementations using unsafe for performance can introduce timing side-channels or memory issues |
| 9 | SQL injection | Rust ORMs (Diesel, SQLx) prevent injection when used correctly, but raw SQL queries via query() are still possible and lack compile-time safety guarantees |
| 10 | Integer overflow | In release mode, Rust wraps on integer overflow by default (no panic). An overflow in size calculation can cause undersized buffer allocation, leading to out-of-bounds access in unsafe code |

## Secure coding checklist

- [ ] Minimize `unsafe` blocks — audit every one. Document the safety invariant each `unsafe` block relies on
- [ ] Use `#[forbid(unsafe_code)]` at crate level for application code; restrict `unsafe` to clearly bounded low-level modules
- [ ] FFI boundaries: validate all data crossing FFI, use `CString`/`CStr` correctly, never assume C function safety guarantees
- [ ] Use `cargo-audit` in CI to check for known crate vulnerabilities
- [ ] Avoid `unwrap()` and `expect()` in production server code — use `?` operator or explicit error handling
- [ ] Use `checked_add`, `checked_mul` etc. for arithmetic that may overflow, or enable overflow checks in release
- [ ] Use `sqlx::query!` macro (compile-time checked) or parameterized queries — never format strings for SQL
- [ ] Use `rand::rngs::OsRng` or `rand::thread_rng()` for cryptographic randomness
- [ ] Run `cargo clippy` with `#![warn(clippy::pedantic)]` for additional safety lints
- [ ] Audit build.rs scripts in dependencies — they execute arbitrary code at compile time
- [ ] Use `Miri` for detecting undefined behavior in test suite

## Common misconfigurations

- **Actix-Web / Axum**: Missing authentication middleware, overly permissive CORS, no rate limiting, error responses leaking internal details
- **Serde**: Deserializing untagged enums from untrusted input (DoS via exponential parsing), no size limits on deserialized collections
- **Cargo**: Not committing Cargo.lock for applications (non-reproducible builds), build.rs downloading external resources over HTTP
- **Tokio**: Spawning tasks without cancellation tokens, blocking the async runtime with synchronous code, no connection limits

## Security tooling

- **SAST**: cargo-clippy (with pedantic), cargo-audit (vulnerability DB), cargo-deny (license + advisory), Semgrep (Rust rules)
- **Dynamic**: Miri (undefined behavior detector), cargo-fuzz (libFuzzer integration), proptest (property-based testing)
- **Unsafe Auditing**: cargo-geiger (counts unsafe usage), unsafe-libyear (tracks unsafe dependency age)
- **SCA**: cargo-audit, RustSec Advisory Database, Dependabot

## Code examples

### Vulnerable: Unsafe raw pointer

```rust
// VULNERABLE: Unsafe block with incorrect lifetime assumption
fn get_reference(data: &[u8]) -> &str {
    unsafe {
        let ptr = data.as_ptr();
        let len = data.len();
        // BUG: Assumes data is valid UTF-8 without checking
        std::str::from_utf8_unchecked(std::slice::from_raw_parts(ptr, len))
    }
}
```

### Secure: Safe validation

```rust
// SECURE: Use safe API with proper error handling
fn get_reference(data: &[u8]) -> Result<&str, std::str::Utf8Error> {
    std::str::from_utf8(data) // Returns Err if not valid UTF-8
}
```

### Vulnerable: Unwrap in server code

```rust
// VULNERABLE: Server panics on unexpected input
async fn get_user(Path(id): Path<String>) -> impl IntoResponse {
    let id: i64 = id.parse().unwrap(); // Panics on non-numeric input
    let user = db.get_user(id).await.unwrap(); // Panics on DB error
    Json(user)
}
```

### Secure: Proper error handling

```rust
// SECURE: Graceful error handling with appropriate HTTP status
async fn get_user(Path(id): Path<String>) -> Result<Json<User>, AppError> {
    let id: i64 = id.parse().map_err(|_| AppError::BadRequest("Invalid user ID"))?;
    let user = db.get_user(id).await.map_err(|e| {
        tracing::error!("DB error fetching user {}: {}", id, e);
        AppError::Internal("Failed to fetch user")
    })?;
    Ok(Json(user))
}
```
