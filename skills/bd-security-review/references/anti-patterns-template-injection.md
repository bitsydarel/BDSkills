# Anti-patterns: Template Injection

Security anti-patterns related to server-side and client-side template injection (SSTI/CSTI). Template injection occurs when user-controlled input is embedded into a template source string that is then compiled and executed by the template engine, rather than passed as safe data context. Each pattern includes signs to look for, its impact, and a concrete fix.

## User Input in Template Source — Critical

**Signs**: User input concatenated directly into a template string before compilation. Code paths like `render_template_string("Hello " + user_input)` instead of `render_template("hello.html", name=user_input)`. String formatting applied to template source: `template_src = f"Dear {user_input}, ..."` then passed to a template engine. Any call to `Template(user_controlled_string)` in Jinja2, Freemarker `new Template("name", new StringReader(user_input))`, or equivalent in other engines. The first form compiles user input as Jinja2 code; the second renders it as data.

**Impact**: Full server-side code execution. In Python/Jinja2, attackers access `os.popen`, `subprocess`, or read arbitrary files. In Java/Freemarker, attackers reach `Runtime.exec()`. Complete server compromise: remote code execution, data exfiltration, lateral movement. This is consistently rated critical because template engines operate with the full privileges of the application process.

**Fix**: Never concatenate user input into template source. Always pass user data as template context variables. Use pre-compiled templates loaded from files on disk. If dynamic template generation is required, use a logic-less template engine (Mustache, Handlebars in strict mode) that cannot execute arbitrary code. Audit all calls to template compilation functions (`Template()`, `render_template_string()`, `from_string()`) for user-controlled input.

**Detection**:
- *Code patterns*: `Template(user_input)` or `render_template_string(... + user_input)`; `from_string()` calls with non-static arguments; string concatenation or f-strings producing template source; `new Template("name", new StringReader(request.getParameter(...)))` in Java
- *Review questions*: Is the template source string ever constructed using user input? Are there any calls to template compilation functions that accept dynamic strings rather than static file paths?
- *Test methods*: Inject `{{7*7}}` into every user input field and check if `49` appears in the response. Search codebase for all template compilation entry points and trace their arguments back to user input. Use SSTI polyglot strings: `${{<%[%'"}}%\.`

---

## Sandbox Escape Blindness — Critical

**Signs**: Reliance on template engine sandboxing (e.g., Jinja2 `SandboxedEnvironment`) as the sole mitigation while still allowing user input in template source. No awareness of documented escape techniques for the specific engine in use. Security reviews that mark template injection as mitigated because "the sandbox prevents code execution." No testing of sandbox escape payloads during penetration tests.

**Impact**: Every major template engine has documented sandbox escape chains. Jinja2: `''.__class__.__mro__[1].__subclasses__()` traverses the Python object hierarchy to reach `subprocess.Popen` or `os.popen`. Freemarker: `"freemarker.template.utility.Execute"?new()("id")` reaches command execution. Twig: `_self.env.registerUndefinedFilterCallback("system")` then `_self.env.getFilter("id")`. Velocity: `#set($runtime=$class.forName("java.lang.Runtime"))` to get runtime execution. Sandbox escapes achieve full RCE, making the sandbox a speed bump rather than a barrier.

**Fix**: Do not allow user input in template source, even with sandboxing. If absolutely unavoidable: use the most restrictive sandbox mode available, keep the template engine updated to the latest version (escape techniques are patched regularly), monitor security advisories for your specific engine, and consider switching to logic-less template engines (Mustache, Handlebars strict mode) that have no code execution capability by design. Layer defenses: sandbox + allowlisted template functions + restricted Python builtins.

**Detection**:
- *Code patterns*: `SandboxedEnvironment` or equivalent used with user-controlled template source; sandbox configuration that allows access to `__class__`, `__mro__`, `__subclasses__`, `__globals__`; template engine version with known unpatched escape techniques
- *Review questions*: If user input reaches the template engine, has the sandbox been tested against known escape payloads for this specific engine and version? When was the template engine dependency last updated?
- *Test methods*: Test with engine-specific escape payloads: Jinja2 `{{''.__class__.__mro__[1].__subclasses__()}}`, Freemarker `${"freemarker.template.utility.Execute"?new()("id")}`, Twig `{{_self.env.registerUndefinedFilterCallback("system")}}{{_self.env.getFilter("id")}}`. Use tools like tplmap for automated testing

---

## Template Engine Detection Failure — Major

**Signs**: Security review or penetration test that uses only one type of template injection polyglot (e.g., only `{{7*7}}`) without confirming the template engine in use. Vulnerability reports that say "not vulnerable to SSTI" based on testing with the wrong syntax. No enumeration of template engines from project dependencies, file extensions, or framework defaults.

**Impact**: Different engines use different expression syntax, and testing with the wrong polyglot misses the vulnerability entirely. Jinja2/Twig use `{{7*7}}` (returns `49`). Freemarker uses `${7*7}`. Mako uses `${7*7}` but also supports embedded Python blocks. ERB uses `<%= 7*7 %>`. Smarty uses `{7*7}`. Velocity uses `#set($x=7*7)$x`. Pug/Jade uses `#{7*7}`. A Freemarker injection tested only with `{{7*7}}` will appear safe because Freemarker ignores double-brace syntax.

**Fix**: Before testing for SSTI, identify the template engine from project dependencies (pom.xml, requirements.txt, package.json, Gemfile), file extensions (`.j2`, `.jinja2`, `.ftl`, `.ftlh`, `.vm`, `.erb`, `.twig`, `.pug`, `.ejs`, `.hbs`), framework documentation, and configuration files. Test with engine-specific polyglots. Use the universal detection sequence: `${{<%[%'"}}%\.` which triggers syntax errors or output differences across multiple engines simultaneously.

**Detection**:
- *Code patterns*: Template file extensions in the project (`.j2`, `.ftl`, `.vm`, `.erb`, `.twig`, `.ejs`); template engine imports in code (`from jinja2 import`, `import freemarker`, `require('ejs')`, `require('pug')`); framework-default template engines (Flask defaults to Jinja2, Spring Boot defaults to Thymeleaf, Rails defaults to ERB)
- *Review questions*: Which template engine(s) does this project use? Have SSTI tests used engine-specific payloads rather than generic ones? Are multiple template engines in use (e.g., Jinja2 for backend, Handlebars for email)?
- *Test methods*: Enumerate all template engines from dependency files. Use the detection decision tree: inject `${7*7}` — if `49` appears, test for Freemarker vs Mako vs Thymeleaf; inject `{{7*7}}` — if `49` appears, test for Jinja2 vs Twig vs Nunjucks. Use tplmap or SSTImap for automated engine fingerprinting

---

## Client-Side Template Injection Dismissal — Major

**Signs**: Security review treats client-side template injection (CSTI) in AngularJS or Vue.js as identical to reflected XSS and applies the same mitigations. CSTI findings downgraded because "it is just XSS." CSP deployed as mitigation without recognizing that CSTI runs within the framework's allowed origin. AngularJS applications still using versions prior to 1.6 without sandbox escape awareness.

**Impact**: CSTI differs from reflected XSS in critical ways. CSP bypass: the template engine JavaScript runs on the allowed origin, so CSP does not block its execution. Scope access: CSTI runs within the framework's scope, accessing `$scope` variables, component data, and application state that regular XSS cannot reach. AngularJS pre-1.6 has documented sandbox escape payloads (`{{constructor.constructor('return this')()}}`). Vue.js: using `v-html` with user data or compiling user strings as templates via `new Vue({template: userInput})` enables arbitrary JavaScript execution within the Vue instance context.

**Fix**: Never compile user-controlled content as client-side templates. In Angular (2+): use Ahead-of-Time (AOT) compilation; avoid `bypassSecurityTrust*` methods. In AngularJS: upgrade to 1.6+ (sandbox removed entirely, making the risk explicit); use `ng-bind` instead of `{{}}` interpolation for user data. In Vue.js: never pass user input to `template` option or `v-html`; use `v-text` for user data. Implement CSP with `'strict-dynamic'` and nonce-based script loading.

**Detection**:
- *Code patterns*: AngularJS `$compile` or `$interpolate` called with user input; Vue `v-html` bound to user-controlled data; `new Vue({template: userInput})`; AngularJS version < 1.6 in package.json; `bypassSecurityTrustHtml()` in Angular 2+
- *Review questions*: Does any user-controlled data flow into client-side template compilation? Is AngularJS version pre-1.6? Does the CSP policy account for CSTI (where the template engine runs on the allowed origin)?
- *Test methods*: Inject `{{constructor.constructor('return document.domain')()}}` in AngularJS apps. Inject template expressions into all user input fields rendered by the framework. Test with CSP enabled to verify CSTI bypasses it. Use DOM XSS scanners that understand framework-specific sinks

---

## Indirect Template Injection via Stored Data — Major

**Signs**: User input stored in a database, file, or cache is later retrieved and processed by a template engine. Email notification templates that include user-supplied fields (name, address, company name) rendered through a template engine. PDF generation services that render stored user profile data through templates. Report generation that processes stored form submissions as template source. CMS content authored by users and rendered through a server-side template engine.

**Impact**: The injection is not visible in the input handling code — it activates asynchronously when the template engine processes stored data. A user registers with the name `{{config.SECRET_KEY}}` and the injection triggers when a notification email is rendered. Stored SSTI can persist across sessions, affect multiple users (e.g., a malicious profile name rendered in admin reports), and is harder to detect because the injection point and execution point are in different code paths, potentially different services.

**Fix**: Sanitize data at output time (when rendering templates), not just at input time. Enable autoescaping in all template engines (`Jinja2: autoescape=True`, Twig: `autoescape: true`, Freemarker: `output_format="HTML"`). Flag any template rendering of user-controlled stored data for security review. Use pre-compiled templates with context variables for all rendering that includes user data. Never use `render_template_string()` or equivalent with data retrieved from storage.

**Detection**:
- *Code patterns*: Database queries or cache reads whose results are passed to template compilation functions; email rendering code that builds template strings from stored user data; PDF generation using template engines with user-stored content; `render_template_string(stored_data)` or `Template(db_record.field)`
- *Review questions*: Does any stored user data flow into template compilation (not just template context)? Are email/PDF/report templates rendered with user-supplied stored values as template source rather than context variables?
- *Test methods*: Store template injection payloads (`{{7*7}}`, `${7*7}`) in user profile fields, form submissions, and other persistent inputs. Trigger all downstream rendering processes (email notifications, PDF generation, report exports) and check for payload execution. Map all data flows from storage to template rendering

---

## Summary

| Pattern | Severity | Primary Criterion | Applies To |
|---------|----------|-------------------|------------|
| User Input in Template Source | Critical | A3: Input Validation | Both |
| Sandbox Escape Blindness | Critical | A3: Input Validation | Implementation |
| Template Engine Detection Failure | Major | A3: Input Validation | Both |
| Client-Side Template Injection Dismissal | Major | A3: Input Validation | Implementation |
| Indirect Template Injection via Stored Data | Major | A3: Input Validation | Both |
