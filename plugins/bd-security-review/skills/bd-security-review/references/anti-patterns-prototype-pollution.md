# Anti-patterns: Prototype Pollution

Security anti-patterns related to JavaScript prototype pollution vulnerabilities. Prototype pollution occurs when an attacker can inject properties into `Object.prototype`, affecting all objects in the application. This class of vulnerability is unique to JavaScript's prototype-based inheritance and can escalate from a seemingly minor property injection to remote code execution through gadget chains. Each pattern includes signs to look for, its impact, and a concrete fix.

## Recursive Merge Without Prototype Guard — Critical

**Signs**: Deep merge, deep clone, or deep set utility functions that follow `__proto__` and `constructor.prototype` property paths when merging objects. Custom recursive merge functions that do not check for `__proto__`, `constructor`, or `prototype` keys before assignment. Use of vulnerable library versions: lodash.merge (pre-4.17.12), jQuery.extend with deep=true (pre-3.4.0), hoek.merge (pre-5.0.3), defu (pre-fix versions), deepmerge without custom merge options. Any function that recursively assigns properties from one object to another without key filtering.

**Impact**: An attacker sends JSON like `{"__proto__": {"isAdmin": true}}` which pollutes `Object.prototype` for all objects in the Node.js process. Every plain object created after pollution inherits `isAdmin: true`. This affects all request handlers, all users, all sessions in the same process. The pollution persists until the process restarts. In server-side JavaScript, a single polluted property can compromise the entire application.

**Fix**: Use `Object.create(null)` for merge targets (no prototype chain to pollute). Filter `__proto__`, `constructor`, and `prototype` keys in all merge functions before property assignment. Update vulnerable libraries to patched versions. Use `Map` instead of plain objects for dynamic key-value storage. Validate that incoming JSON keys do not contain prototype-polluting property names at the API boundary. Consider using `Object.freeze(Object.prototype)` in controlled environments.

**Detection**:
- *Code patterns*: Custom recursive merge/clone functions without `__proto__` key filtering; `lodash.merge`, `lodash.defaultsDeep`, `jQuery.extend(true, ...)` with unvalidated user input; any function that does `target[key] = source[key]` in a recursive loop without checking `key === '__proto__'` or `key === 'constructor'`
- *Review questions*: Do any merge/clone/set utilities accept user-controlled input? Do they filter prototype-polluting keys? Are library versions patched for known prototype pollution CVEs?
- *Test methods*: Send `{"__proto__": {"polluted": true}}` to API endpoints that accept JSON. After the request, check if `({}).polluted === true` in the server process. Use prototype pollution scanners (ppmap, ppfuzz). Audit all recursive object manipulation functions

---

## Query String to Object Deserialization — Major

**Signs**: Parsing URL query strings into nested JavaScript objects without blocking prototype-polluting keys. The `qs` library (before 6.10.3) supported `a[__proto__][isAdmin]=true` syntax that created nested objects including `__proto__` properties. Custom query string parsers that support bracket notation (`a[b][c]=value`) without key filtering. Form data parsers and GraphQL argument parsers that deserialize structured data from strings into nested objects.

**Impact**: An attacker crafts a URL like `?__proto__[isAdmin]=true` or `?constructor[prototype][isAdmin]=true` that pollutes `Object.prototype` when the query string is parsed. This is exploitable via GET requests, making it easier to trigger (can be embedded in links, images, or redirects). The pollution affects all objects in the process, identical to JSON-based pollution.

**Fix**: Use query string parsers that block `__proto__` access: `qs` version >= 6.10.3 with `allowPrototypes: false` (the default in newer versions). Validate parsed query parameter keys before use. Use `URLSearchParams` instead of `qs` for flat (non-nested) parameters. If nested query parameters are required, apply the same `__proto__`/`constructor`/`prototype` key filtering used for JSON merge operations.

**Detection**:
- *Code patterns*: `qs.parse()` without `allowPrototypes: false` option; custom query string parsers supporting bracket notation without key filtering; `req.query` in Express (which uses `qs` internally — check Express/qs version); form body parsers that create nested objects from flat form data
- *Review questions*: Which query string parser is in use and what version? Does it support nested object creation from bracket notation? Are parsed keys validated before use?
- *Test methods*: Send requests with `?__proto__[polluted]=true` and `?constructor[prototype][polluted]=true` in the query string. Check if `({}).polluted === true` after the request. Test with both GET and POST form-encoded bodies. Verify `qs` version in package-lock.json

---

## Plain Object for Lookup Maps — Major

**Signs**: Using `{}` (plain objects with `Object.prototype` in their prototype chain) as lookup maps, configuration objects, feature flag stores, permission maps, or role-based access control stores. Code that checks `if (config[key])` or `if (permissions[role])` without `hasOwnProperty` verification. Default values derived from property access on plain objects: `const value = options.timeout || 5000`.

**Impact**: If prototype pollution occurs anywhere in the application (via any of the other patterns), plain objects used as lookup maps "inherit" the polluted properties. Example: if `Object.prototype.isAdmin = true` via pollution, then `({}).isAdmin === true` — breaking every authorization check that uses falsy-default patterns like `if (user.isAdmin)`. Feature flags, configuration options, and permission checks all silently return attacker-controlled values. This is the mechanism by which prototype pollution becomes exploitable.

**Fix**: Use `Object.create(null)` for all lookup maps (creates objects with no prototype chain). Use `Map` and `Set` for collections and lookup tables. When accessing properties on plain objects, use explicit `hasOwnProperty` checks: `if (Object.prototype.hasOwnProperty.call(obj, key))`. Use optional chaining with nullish coalescing (`obj?.key ?? default`) instead of falsy-default patterns (`obj.key || default`).

**Detection**:
- *Code patterns*: `const map = {}` used as a lookup table; `if (config[key])` without `hasOwnProperty` check; `options.property || defaultValue` patterns for configuration; role/permission checks using plain object property access without ownership verification
- *Review questions*: Are lookup maps, configuration objects, and permission stores created with `Object.create(null)` or as `Map` instances? Do property access patterns use `hasOwnProperty` checks?
- *Test methods*: Pollute `Object.prototype` with test properties in a test environment and verify that authorization checks, feature flags, and configuration lookups are not affected. Audit all plain object property access patterns in security-critical code paths

---

## Pollution-to-Gadget Escalation Ignorance — Major

**Signs**: Dismissing prototype pollution as low-impact ("it just sets a property on Object.prototype") without mapping how polluted properties affect downstream code. No analysis of gadget chains — code paths where polluted properties are consumed to achieve code execution or other high-impact outcomes. Security reviews that rate prototype pollution as informational or low severity without gadget analysis.

**Impact**: Known gadget chains escalate prototype pollution to remote code execution. Template engines: Pug checks `block.mode` property (pollutable to execute arbitrary code), EJS checks `settings['view options']` and `client` properties, Handlebars accesses `constructor` property. Process spawning: `child_process.spawn` checks `shell` and `env` properties on options objects — polluting `shell: true` and `env.NODE_OPTIONS` enables code execution. HTTP libraries: polluting `headers` or `agent` properties on request options. Authentication: polluting `role`, `isAdmin`, or `verified` properties on user objects.

**Fix**: Treat prototype pollution as high severity by default — assume gadget chains exist until proven otherwise. Audit all downstream code for property lookups that could be affected by prototype pollution, especially in template engines, process spawning, HTTP clients, and authentication middleware. Run prototype pollution gadget chain scanners (ppfuzz, pp-finder, server-side-prototype-pollution). Harden critical code paths with explicit `hasOwnProperty` checks.

**Detection**:
- *Code patterns*: Template engine usage (Pug, EJS, Handlebars, Nunjucks) with default configurations; `child_process.spawn` or `child_process.fork` with options objects that could inherit polluted properties; HTTP client calls with options objects; authentication/authorization checks without `hasOwnProperty`
- *Review questions*: If `Object.prototype` were polluted with arbitrary properties, which code paths would be affected? Are template engines, process spawning, or HTTP clients used with options objects that could inherit polluted values?
- *Test methods*: Use pp-finder or server-side-prototype-pollution to automatically discover gadget chains. Manually pollute `Object.prototype` in a test environment and trace which application behaviors change. Test known gadget chains for each template engine and framework in use

---

## Dependency Audit Blind Spot — Major

**Signs**: Not scanning npm dependencies specifically for prototype pollution vulnerabilities. Relying solely on `npm audit` which may not flag prototype pollution as high severity or may miss it in transitive dependencies. No review of new dependencies for deep merge, deep clone, or deep set patterns. No pinning of transitive dependency versions. Using `npm install` without `--ignore-scripts` review.

**Impact**: Many libraries silently introduce vulnerable deep merge functions in transitive dependencies that are not visible in direct dependency review. Prototype pollution CVEs are frequently discovered in widely-used packages (lodash, minimist, yargs-parser, set-value, mixin-deep). Patch versions of libraries can introduce new recursive object manipulation code. A single vulnerable transitive dependency compromises the entire application.

**Fix**: Use dedicated prototype pollution scanners alongside standard `npm audit`: run `npx npm-audit-resolver`, check Snyk or Socket.dev for prototype pollution-specific advisories. Review new dependencies for deep merge/clone/set patterns before adoption. Pin transitive dependencies with `package-lock.json` and review changes on update. Use `npm ls` to audit the full dependency tree. Consider using `Object.freeze(Object.prototype)` in application startup as a defense-in-depth measure.

**Detection**:
- *Code patterns*: `package.json` dependencies with known prototype pollution history (lodash < 4.17.12, minimist < 1.2.6, yargs-parser < 13.1.2, set-value < 3.0.1, mixin-deep < 1.3.2); unpinned transitive dependencies; `package-lock.json` not committed to version control
- *Review questions*: When was the last `npm audit` run? Are there any known prototype pollution CVEs in the dependency tree? Are transitive dependencies pinned? Has Socket.dev or Snyk been used to scan for prototype pollution specifically?
- *Test methods*: Run `npm audit` and filter for prototype pollution CVEs. Use `npx check-my-deps` or Socket.dev CLI for deep dependency analysis. Search `node_modules` for recursive merge/clone functions. Run ppfuzz against the application with all endpoints

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|-------------------|------------|
| Recursive Merge Without Prototype Guard | Critical | A3: Input Validation, A6: Secure Coding | Implementation |
| Query String to Object Deserialization | Major | A3: Input Validation | Implementation |
| Plain Object for Lookup Maps | Major | A6: Secure Coding | Implementation |
| Pollution-to-Gadget Escalation Ignorance | Major | A6: Secure Coding | Both |
| Dependency Audit Blind Spot | Major | A6: Secure Coding | Both |
