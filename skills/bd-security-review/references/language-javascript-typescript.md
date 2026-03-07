# Security Review — JavaScript / TypeScript

## Language security profile

- **Type system**: JS dynamically typed; TS adds static types but compiles away at runtime — type safety is a development-time guarantee only
- **Memory model**: Garbage collected, no direct memory access — buffer overflows are not a concern, but prototype pollution and type coercion are
- **Ecosystem risks**: npm is the largest package registry (2M+ packages) with frequent typosquatting, dependency confusion, and supply chain attacks (ua-parser-js, event-stream, Polyfill.io)
- **Execution contexts**: Browser (XSS surface), Node.js (server-side, file system access), Deno/Bun (alternative runtimes with different security models), Electron (full OS access)

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Cross-Site Scripting (XSS) — DOM, reflected, stored | CWE-79 | A3 |
| 2 | Prototype Pollution — modifying Object.prototype via user input | CWE-1321 | A3 |
| 3 | Server-Side Request Forgery via URL parsing | CWE-918 | A3 |
| 4 | npm Supply Chain (typosquatting, dependency confusion, CDN hijack) | CWE-1357 | A5 |
| 5 | Insecure Deserialization (JSON.parse with reviver, dynamic code evaluation) | CWE-502 | A3 |
| 6 | NoSQL Injection (MongoDB operator injection via objects) | CWE-943 | A3 |
| 7 | Path Traversal via improper path joining | CWE-22 | A3 |
| 8 | ReDoS (Regular Expression Denial of Service) | CWE-1333 | A6 |
| 9 | Insecure Randomness (Math.random for security purposes) | CWE-338 | A4 |
| 10 | Template Injection (server-side and client-side template engines) | CWE-94 | A3 |

## Threat model context

Why each vulnerability matters in JavaScript/TypeScript execution contexts — use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | XSS (DOM, reflected, stored) | JavaScript runs in the user's browser with full access to the page DOM, cookies, and session tokens. XSS enables account takeover, data theft, and UI manipulation without compromising the server |
| 2 | Prototype Pollution | Modifying Object.prototype affects every object in the application. A single polluted property (isAdmin: true) can bypass authorization checks across the entire codebase |
| 3 | SSRF | Node.js HTTP libraries follow redirects and resolve internal hostnames. User-controlled URLs can scan internal networks, access cloud metadata (169.254.169.254), or reach internal services |
| 4 | npm Supply Chain | npm's 2M+ package ecosystem is the largest attack surface for supply chain compromises. A single malicious dependency (event-stream, ua-parser-js, polyfill.io) affects millions of downstream projects |
| 5 | Insecure Deserialization | JSON.parse() with custom revivers or libraries like serialize-javascript can run code. Combined with prototype pollution, deserialization becomes an RCE vector |
| 6 | NoSQL Injection | MongoDB accepts objects as query operators ({$ne: null}). Without schema validation, user input can manipulate query logic to bypass authentication or extract data |
| 7 | Path Traversal | path.join() with .. sequences can escape intended directories. In file-serving endpoints, this exposes source code, configuration files, and secrets |
| 8 | ReDoS | Backtracking regex engines in JavaScript can be forced into exponential processing time with crafted input. A single endpoint with a vulnerable regex becomes a DoS vector |
| 9 | Insecure Randomness | Math.random() uses a PRNG seeded from a predictable source. Tokens, passwords, or IDs generated with it are predictable to an attacker who can observe outputs |
| 10 | Template Injection | Server-side template engines (EJS, Pug, Handlebars) that render user input as templates enable RCE. Client-side template injection enables XSS |

## Secure coding checklist

- [ ] Use context-aware output encoding for XSS prevention (not just HTML escaping — handle URL, JS, CSS contexts)
- [ ] Freeze prototypes where possible (`Object.freeze(Object.prototype)`) or use `Object.create(null)` for maps
- [ ] Use `new URL()` for URL parsing and validate schema and host before making requests
- [ ] Pin npm dependencies with lock file integrity hashes (`npm ci`, not `npm install`)
- [ ] Use `crypto.randomUUID()` or `crypto.getRandomValues()` — never `Math.random()` for security
- [ ] Parameterize all database queries (Prisma, Knex, TypeORM) — no string concatenation
- [ ] Use `path.resolve()` and validate resolved paths are within expected directories
- [ ] Set Content-Security-Policy with nonce-based scripts, no unsafe-inline / unsafe-eval directives
- [ ] Use `===` for comparisons (avoid type coercion vulnerabilities)
- [ ] Validate regex complexity or use RE2 for user-provided patterns
- [ ] TypeScript: enable `strict` mode, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`
- [ ] Never use dynamic code execution functions with untrusted input — use JSON.parse for data parsing

## Common misconfigurations

- **Express.js**: Missing `helmet` middleware (security headers), no rate limiting, `trust proxy` misconfigured, error handler leaking stack traces
- **Next.js**: Server actions without authentication checks, API routes without authorization, getServerSideProps leaking props to client, middleware bypass via direct API access
- **React**: Setting innerHTML via React's unsafe HTML injection prop with unsanitized input, sensitive data in client-side state/context, exposed API keys in client bundle
- **Node.js**: Using shell-mode subprocess execution with user input (always use `execFile` or `spawn` with argument arrays), dynamic code execution with user-controlled strings, `require()` with user-controlled paths

## Security tooling

- **SAST**: Semgrep (JS/TS rules), ESLint security plugins (eslint-plugin-security, @typescript-eslint), CodeQL
- **SCA**: npm audit, Snyk, Socket.dev (supply chain focus), Dependabot
- **DAST**: OWASP ZAP, Burp Suite
- **Runtime**: Helmet (Express security headers), csurf (CSRF), express-rate-limit, DOMPurify (XSS sanitization)

## Code examples

### Vulnerable: Prototype pollution via merge

```javascript
// VULNERABLE: Deep merge allows __proto__ pollution
function deepMerge(target, source) {
  for (const key in source) {
    if (typeof source[key] === 'object') {
      target[key] = deepMerge(target[key] || {}, source[key]);
    } else {
      target[key] = source[key];
    }
  }
  return target;
}
// Attacker sends: {"__proto__": {"isAdmin": true}}
```

### Secure: Protected merge with key validation

```javascript
// SECURE: Block prototype-polluting keys
function safeMerge(target, source) {
  for (const key of Object.keys(source)) {
    if (key === '__proto__' || key === 'constructor' || key === 'prototype') continue;
    if (typeof source[key] === 'object' && source[key] !== null && !Array.isArray(source[key])) {
      target[key] = safeMerge(target[key] || Object.create(null), source[key]);
    } else {
      target[key] = source[key];
    }
  }
  return target;
}
// Better: Use a well-tested library like lodash.merge (which protects against this)
```

### Vulnerable: NoSQL injection

```javascript
// VULNERABLE: MongoDB operator injection
app.post('/login', async (req, res) => {
  const user = await db.collection('users').findOne({
    username: req.body.username,
    password: req.body.password  // Attacker sends: {"$ne": null}
  });
});
```

### Secure: Input validation with schema

```javascript
// SECURE: Validate input types before query
import { z } from 'zod';
const loginSchema = z.object({
  username: z.string().min(1).max(100),
  password: z.string().min(8).max(128),
});

app.post('/login', async (req, res) => {
  const { username, password } = loginSchema.parse(req.body);
  const user = await db.collection('users').findOne({ username });
  const valid = await bcrypt.compare(password, user.passwordHash);
});
```
