# Security Review — Python

## Language security profile

- **Type system**: Dynamically typed with optional type hints (mypy, pyright). Type hints are advisory only — no runtime enforcement
- **Memory model**: Garbage collected with reference counting. No direct memory access, but C extensions can introduce memory safety issues
- **Ecosystem risks**: PyPI has experienced typosquatting campaigns, malicious packages, and dependency confusion attacks. Setup scripts execute arbitrary code during installation
- **Execution contexts**: Web backends (Django, Flask, FastAPI), data science/ML, CLI tools, automation scripts, serverless functions

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Unsafe deserialization (loading untrusted serialized objects) | CWE-502 | A3 |
| 2 | Command injection via subprocess with shell=True | CWE-78 | A3 |
| 3 | SQL injection via string formatting in queries | CWE-89 | A3 |
| 4 | Server-Side Template Injection (Jinja2, Mako) | CWE-94 | A3 |
| 5 | Path traversal via os.path.join with absolute paths | CWE-22 | A3 |
| 6 | PyPI supply chain attacks (typosquatting, setup.py code execution) | CWE-1357 | A5 |
| 7 | SSRF via requests library with user-controlled URLs | CWE-918 | A3 |
| 8 | XML External Entity injection (XXE) via xml.etree | CWE-611 | A3 |
| 9 | Insecure temp file creation (predictable names) | CWE-377 | A6 |
| 10 | Dynamic code execution with untrusted input | CWE-94 | A3 |


## Threat model context

Why each vulnerability matters in Python's execution context — use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | Unsafe deserialization | Deserializing untrusted data with unsafe methods runs arbitrary code. An attacker controlling serialized input achieves remote code execution with no exploit development needed |
| 2 | Command injection (shell=True) | Python subprocess with shell=True passes input to the system shell, allowing command chaining. Common in automation scripts that process filenames or user queries |
| 3 | SQL injection | Python string formatting in SQL queries is syntactically natural, making injection easy to introduce accidentally. ORMs prevent this only when used correctly |
| 4 | Server-Side Template Injection | Jinja2 templates can access Python object tree, enabling sandbox escape and RCE. Often missed because template injection looks like XSS |
| 5 | Path traversal | os.path.join("/safe", "/etc/passwd") returns /etc/passwd because absolute paths override the base. This surprises developers who assume join always concatenates |
| 6 | Supply chain attacks | PyPI setup scripts run arbitrary code during installation. A typosquatted package runs attacker code on developer machines and CI systems before any security scan |
| 7 | SSRF | The requests library follows redirects by default and supports file:// protocol. User-controlled URLs can reach internal services or read local files |
| 8 | XXE | Python built-in XML parsers process external entities by default. Parsing untrusted XML can read local files or trigger SSRF |
| 9 | Insecure temp files | tempfile.mktemp() returns a predictable filename, enabling symlink attacks. On shared systems, an attacker can predict the path and replace the file |
| 10 | Dynamic code execution | Dynamic code evaluation functions with user input provide direct code execution. Often found in admin panels, template engines, or data processing pipelines |

## Secure coding checklist

- [ ] Never deserialize untrusted data with unsafe methods — use JSON or validated schemas instead
- [ ] Use `subprocess.run()` with argument lists, never `shell=True` with user input
- [ ] Use parameterized queries (SQLAlchemy bind params, Django ORM) — no f-strings or .format() in SQL
- [ ] Use Jinja2 sandboxed environment for user-controlled templates, or avoid user template input entirely
- [ ] Validate file paths: `os.path.realpath()` + check prefix is within allowed directory
- [ ] Pin dependencies with `pip-compile` or `poetry.lock` with hash verification
- [ ] Validate URLs with `urllib.parse.urlparse()` — check scheme and host before requests
- [ ] Use `defusedxml` instead of `xml.etree.ElementTree` for XML parsing
- [ ] Use `tempfile.mkstemp()` / `tempfile.NamedTemporaryFile()` — never predictable temp file names
- [ ] Enable Bandit and Semgrep in CI for Python-specific security scanning
- [ ] Use `secrets` module for cryptographic randomness, not `random`

## Common misconfigurations

- **Django**: `DEBUG = True` in production, `SECRET_KEY` in source code, `ALLOWED_HOSTS = ['*']`, missing CSRF middleware, raw SQL queries bypassing ORM
- **Flask**: Debug mode in production (interactive debugger accessible), missing CSRF protection, secret key hardcoded, no rate limiting
- **FastAPI**: Missing authentication dependency on routes, Pydantic models not validating all fields, CORS allow all origins
- **General**: `requirements.txt` without pinned versions, `setup.py` running arbitrary code on install, `.env` files in git

## Security tooling

- **SAST**: Bandit (Python-specific), Semgrep (Python rules), Pylint security checks, pyright/mypy (type safety)
- **SCA**: pip-audit, Safety, Snyk, Dependabot
- **DAST**: OWASP ZAP, Burp Suite
- **Runtime**: django-csp (Content Security Policy), django-axes (brute force protection), Flask-Talisman (security headers)

## Code examples

### Vulnerable: Command injection

```python
# VULNERABLE: shell=True with user input
import subprocess
def search_files(pattern):
    result = subprocess.run(f"grep -r {pattern} /data", shell=True, capture_output=True)
    return result.stdout
# Attacker sends pattern="; cat /etc/passwd"
```

### Secure: Argument list subprocess

```python
# SECURE: Argument list prevents injection
import subprocess
def search_files(pattern):
    result = subprocess.run(
        ["grep", "-r", pattern, "/data"],
        capture_output=True, text=True, timeout=30
    )
    return result.stdout
```

### Vulnerable: SQL injection via f-string

```python
# VULNERABLE: String formatting in SQL
def get_user(username):
    cursor.execute(f"SELECT * FROM users WHERE username = '{username}'")
    # Attacker sends: ' OR '1'='1
```

### Secure: Parameterized query

```python
# SECURE: Parameterized query
def get_user(username):
    cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
    # Or with SQLAlchemy: session.query(User).filter(User.username == username)
```
