# Security Review — Java

## Language security profile

- **Type system**: Statically typed with strong type checking. Generics with type erasure can lead to unchecked cast vulnerabilities at runtime
- **Memory model**: Garbage collected with JVM memory management. No direct buffer overflows, but unsafe deserialization and JNDI injection are critical risks
- **Ecosystem risks**: Maven Central is generally well-governed, but Log4Shell (CVE-2021-44228) demonstrated how a single transitive dependency can compromise millions of applications. Gradle/Maven plugins execute arbitrary code
- **Execution contexts**: Enterprise web (Spring, Jakarta EE), Android (see lang-kotlin.md), microservices, big data processing, desktop (Swing/JavaFX)

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Unsafe deserialization (ObjectInputStream with untrusted data) | CWE-502 | A3 |
| 2 | JNDI Injection (Log4Shell, InitialContext.lookup with user input) | CWE-74 | A3 |
| 3 | XML External Entity (XXE) injection via DocumentBuilder, SAXParser | CWE-611 | A3 |
| 4 | SQL Injection via string concatenation in JDBC | CWE-89 | A3 |
| 5 | Server-Side Request Forgery via URL/HttpURLConnection | CWE-918 | A3 |
| 6 | Expression Language injection (Spring EL, OGNL in Struts) | CWE-917 | A3 |
| 7 | Insecure cryptography (weak algorithms, ECB mode, hardcoded keys) | CWE-327 | A4 |
| 8 | Path traversal via File constructor with user input | CWE-22 | A3 |
| 9 | Dependency vulnerabilities (transitive deps, Log4j-scale risks) | CWE-1357 | A5 |
| 10 | Information leakage via stack traces and error messages | CWE-209 | A6 |

## Threat model context

Why each vulnerability matters in Java's execution context — use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | Unsafe deserialization | Java's ObjectInputStream.readObject() triggers gadget chains in the classpath (Commons Collections, Spring). Log4Shell was a deserialization variant — this class of bug enables RCE at scale |
| 2 | JNDI Injection | JNDI lookups with user-controlled input can load remote classes via LDAP/RMI. Log4Shell demonstrated how a single log statement can become an RCE vector affecting millions of applications |
| 3 | XXE | Java's default XML parsers (SAXParser, DocumentBuilder) process external entities unless explicitly disabled. This is a configuration problem — secure defaults must be set per parser instance |
| 4 | SQL injection | JDBC allows raw SQL via Statement. Even with ORMs, HQL/JPQL injection is possible when queries are built with string concatenation |
| 5 | SSRF | Java's HttpURLConnection and URL class follow redirects and resolve internal DNS. Cloud metadata endpoints and internal services are reachable from user-controlled URLs |
| 6 | Expression Language injection | Spring EL and JSP EL evaluate expressions from user input, enabling RCE. Expressions look like template variables and are easily overlooked in code review |
| 7 | Weak cryptography | Java includes deprecated algorithms (DES, MD5, SHA-1) and developers use them because they are available. Cipher.getInstance("DES") compiles without warnings |
| 8 | Path traversal | java.io.File and Paths.get() resolve .. sequences. Combined with file upload or download features, this exposes the entire filesystem |
| 9 | Dependency vulnerabilities | Java's deep transitive dependency trees (Maven/Gradle) make CVEs hard to track. Log4Shell sat in transitive dependencies of thousands of projects |
| 10 | Information disclosure | Spring Boot Actuator endpoints expose heap dumps, environment variables, and configuration. Enabled by default in some versions, accessible without authentication |

## Secure coding checklist

- [ ] Never deserialize untrusted data via ObjectInputStream — use JSON (Jackson, Gson) with type restrictions
- [ ] Disable JNDI lookups in logging configuration; upgrade Log4j to 2.17+ or later
- [ ] Disable external entities in XML parsers: `setFeature("http://apache.org/xml/features/disallow-doctype-decl", true)`
- [ ] Use PreparedStatement for all SQL — never concatenate user input into queries
- [ ] Validate and allowlist URLs before creating connections — check scheme and host
- [ ] Avoid Spring EL evaluation with user input; use property placeholders instead
- [ ] Use strong cryptography: AES-256-GCM, RSA-OAEP, Argon2; avoid DES, MD5, SHA1 for security
- [ ] Validate file paths with `Path.normalize().startsWith(basePath)` pattern
- [ ] Use `dependencyCheck` (OWASP) or Snyk in Maven/Gradle builds
- [ ] Configure error handlers to return generic messages; log details server-side only

## Common misconfigurations

- **Spring Boot**: Actuator endpoints exposed without authentication, CORS allow all origins, CSRF disabled for REST APIs without understanding implications, debug endpoints in production
- **Spring Security**: Overly permissive SecurityFilterChain, missing method-level security annotations, form login CSRF misconfiguration
- **Jakarta EE**: Default servlet container configurations, web.xml without security constraints, JNDI datasource with hardcoded credentials
- **Jackson**: Polymorphic deserialization enabled (`enableDefaultTyping`) — allows RCE via gadget chains

## Security tooling

- **SAST**: SpotBugs + FindSecBugs, Semgrep (Java rules), CodeQL, Checkmarx
- **SCA**: OWASP Dependency-Check, Snyk, Dependabot, Renovate
- **DAST**: OWASP ZAP, Burp Suite
- **Runtime**: Spring Security, Apache Shiro, ESAPI, BouncyCastle (crypto)

## Code examples

### Vulnerable: SQL injection with JDBC

```java
// VULNERABLE: String concatenation in SQL
public User findUser(String username) {
    String sql = "SELECT * FROM users WHERE username = '" + username + "'";
    return jdbcTemplate.queryForObject(sql, new UserRowMapper());
    // Attacker sends: ' OR '1'='1' --
}
```

### Secure: PreparedStatement

```java
// SECURE: Parameterized query
public User findUser(String username) {
    String sql = "SELECT * FROM users WHERE username = ?";
    return jdbcTemplate.queryForObject(sql, new UserRowMapper(), username);
}
```

### Vulnerable: XXE via DocumentBuilder

```java
// VULNERABLE: Default XML parser allows external entities
DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
DocumentBuilder builder = factory.newDocumentBuilder();
Document doc = builder.parse(userInput); // XXE: reads local files, SSRF
```

### Secure: Disabled external entities

```java
// SECURE: Disable all external entity processing
DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
DocumentBuilder builder = factory.newDocumentBuilder();
Document doc = builder.parse(userInput);
```
