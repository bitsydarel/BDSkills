# Security Review — C / C++

## Language security profile

- **Type system**: Statically typed but with weak type safety — implicit conversions, void pointers, and casting bypass type checks
- **Memory model**: Manual memory management — the root cause of ~70% of security vulnerabilities in C/C++ codebases (Microsoft, Google Chrome data). No bounds checking, no use-after-free protection, no null safety by default
- **Ecosystem risks**: Package management is fragmented (Conan, vcpkg, system packages). Many critical dependencies are maintained by small teams. Build system complexity can hide security issues
- **Execution contexts**: Operating systems, embedded/IoT, browsers, databases, game engines, performance-critical libraries, cryptographic implementations

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Buffer overflow (stack and heap) | CWE-120/121/122 | A6 |
| 2 | Use-after-free | CWE-416 | A6 |
| 3 | Out-of-bounds read/write | CWE-125/787 | A6 |
| 4 | Format string vulnerabilities | CWE-134 | A3 |
| 5 | Integer overflow/underflow leading to buffer operations | CWE-190 | A6 |
| 6 | Double-free | CWE-415 | A6 |
| 7 | NULL pointer dereference | CWE-476 | A6 |
| 8 | Race conditions (TOCTOU) | CWE-367 | A6 |
| 9 | Uninitialized memory read | CWE-908 | A4 |
| 10 | Type confusion via unsafe casting | CWE-843 | A6 |

## Threat model context

Why each vulnerability matters in C/C++'s execution context — use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | Buffer overflow | Memory safety is entirely the developer's responsibility. A stack buffer overflow overwrites the return address, giving an attacker direct control of program execution — this is the classic RCE primitive |
| 2 | Use-after-free | Accessing freed memory can read stale data or, worse, write to memory now allocated to another object. Attackers exploit this for arbitrary read/write, enabling full control of the process |
| 3 | Out-of-bounds read/write | No automatic bounds checking means array accesses beyond allocated sizes succeed silently. Out-of-bounds writes corrupt adjacent memory; out-of-bounds reads leak sensitive data (Heartbleed was this class) |
| 4 | Format string vulnerabilities | User-controlled format strings in printf-family functions allow reading from and writing to arbitrary stack addresses. The %n specifier enables arbitrary memory writes from a simple string input |
| 5 | Integer overflow | Integer arithmetic silently wraps without error. When an overflowed value is used for buffer size calculation, it allocates a too-small buffer, turning a math error into a buffer overflow |
| 6 | Double-free | Freeing memory twice corrupts the heap allocator's metadata. Attackers leverage this to control the next allocation's location, enabling arbitrary write primitives |
| 7 | NULL pointer dereference | On systems without page-zero protection, dereferencing NULL maps to address zero, which attackers can control. Even with protection, it causes denial of service via crashes |
| 8 | Race conditions (TOCTOU) | Time-of-check-to-time-of-use gaps in file operations allow an attacker to swap a validated file with a malicious one. Common in setuid programs and system services |
| 9 | Uninitialized memory read | Stack and heap memory retains previous contents. Reading uninitialized variables can leak passwords, encryption keys, or pointers that defeat ASLR |
| 10 | Type confusion | Unsafe casting between incompatible types causes the program to interpret memory with incorrect layout assumptions. Attackers use this to hijack virtual function tables or corrupt object fields |

## Secure coding checklist

- [ ] Enable all compiler security flags: `-Wall -Wextra -Werror -fstack-protector-strong -D_FORTIFY_SOURCE=2 -fPIE -pie`
- [ ] Enable AddressSanitizer (ASan), UndefinedBehaviorSanitizer (UBSan) in testing
- [ ] Use safe string functions: `strncpy`, `snprintf` instead of `strcpy`, `sprintf`; or better, use `std::string` (C++)
- [ ] Validate all buffer sizes before copy/read operations — never trust external size fields
- [ ] Use smart pointers (`unique_ptr`, `shared_ptr`) in C++ — avoid raw `new`/`delete`
- [ ] Check integer overflow before arithmetic used in allocation sizes: `if (a > SIZE_MAX / b) abort()`
- [ ] Never use user-controlled format strings — always use literal format strings with `printf` family
- [ ] Use RAII pattern for resource management (C++); goto-based cleanup pattern (C)
- [ ] Run fuzzing (AFL++, libFuzzer) on all input parsing code
- [ ] Enable ASLR, DEP/NX, and stack canaries in all builds
- [ ] Use modern C++ features: `std::span` for bounds-checked arrays, `std::optional` for nullable values

## Common misconfigurations

- **Compiler flags**: Building without optimization or security flags, disabled ASLR for debugging left in release, missing stack protector
- **Memory allocators**: Using default malloc without hardened alternatives (jemalloc, scudo), no guard pages
- **Build system**: Downloading dependencies over HTTP, no checksum verification, compiling with debug symbols in release
- **Concurrency**: Missing synchronization on shared state, non-atomic flag checks, signal handlers calling non-async-safe functions

## Security tooling

- **SAST**: Coverity, PVS-Studio, Clang Static Analyzer, cppcheck, CodeQL
- **Dynamic**: AddressSanitizer (ASan), MemorySanitizer (MSan), ThreadSanitizer (TSan), UBSan
- **Fuzzing**: AFL++, libFuzzer, honggfuzz, OSS-Fuzz
- **SCA**: Conan/vcpkg audit, OSV (Open Source Vulnerabilities), Snyk for C/C++
- **Runtime**: Valgrind (memory errors), Dr. Memory, Electric Fence

## Code examples

### Vulnerable: Buffer overflow

```c
// VULNERABLE: No bounds check on copy
void process_input(const char *input) {
    char buffer[256];
    strcpy(buffer, input);  // No length check — overflow if input > 255 chars
    process(buffer);
}
```

### Secure: Bounded copy with validation

```c
// SECURE: Length validation before copy
void process_input(const char *input) {
    char buffer[256];
    size_t len = strlen(input);
    if (len >= sizeof(buffer)) {
        log_error("Input too long: %zu", len);
        return;
    }
    memcpy(buffer, input, len + 1);
    process(buffer);
}
// Even better in C++: use std::string
```

### Vulnerable: Format string

```c
// VULNERABLE: User-controlled format string
void log_message(const char *user_msg) {
    printf(user_msg);  // Attacker sends "%x%x%x%n" to read/write stack
}
```

### Secure: Literal format string

```c
// SECURE: Format string is always a literal
void log_message(const char *user_msg) {
    printf("%s", user_msg);  // User input is always a parameter, never the format
}
```
