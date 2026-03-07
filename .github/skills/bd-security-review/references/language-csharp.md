# Security Review — C#

## Language security profile

- **Type system**: Strong static typing with nullable reference types (NRT) in C# 8+. NRT helps prevent NullReferenceException at compile time when enabled
- **Memory model**: .NET garbage collection with managed memory. `unsafe` keyword and `Span<T>` / `stackalloc` can introduce memory safety issues. P/Invoke to native code inherits C/C++ risks
- **Ecosystem risks**: NuGet is the primary package manager. .NET ecosystem is generally well-maintained, but supply chain attacks via NuGet packages have occurred. MSBuild project files can execute arbitrary code during build
- **Execution contexts**: ASP.NET Core web apps/APIs, desktop (WPF, WinForms, MAUI), Unity games, Azure Functions, Blazor (WASM), Windows services

## Top 10 vulnerabilities

| # | Vulnerability | CWE | Criterion |
|---|--------------|-----|-----------|
| 1 | Unsafe deserialization (BinaryFormatter, Json.NET TypeNameHandling) | CWE-502 | A3 |
| 2 | SQL injection via string concatenation (ADO.NET, raw EF queries) | CWE-89 | A3 |
| 3 | Cross-site scripting in Razor views (using Html.Raw with untrusted data) | CWE-79 | A3 |
| 4 | CSRF in ASP.NET (missing anti-forgery token validation) | CWE-352 | A1 |
| 5 | Path traversal via Path.Combine with user input | CWE-22 | A3 |
| 6 | XXE via XmlDocument or XmlTextReader with default settings | CWE-611 | A3 |
| 7 | Insecure cryptography (MD5, SHA1, DES, hardcoded keys) | CWE-327 | A4 |
| 8 | Information leakage via detailed error pages (DeveloperExceptionPage in prod) | CWE-209 | A6 |
| 9 | Mass assignment via model binding (over-posting) | CWE-915 | A2 |
| 10 | ViewState tampering (legacy ASP.NET WebForms) | CWE-642 | A3 |

## Threat model context

Why each vulnerability matters in C# execution context -- use these to explain risk to non-security reviewers.

| # | Vulnerability | Why Dangerous |
|---|--------------|---------------|
| 1 | Unsafe deserialization | BinaryFormatter is deprecated for security -- it allows arbitrary type instantiation from serialized data, enabling RCE. Json.NET with TypeNameHandling.Auto has the same problem, as attacker-controlled type names resolve to dangerous .NET types |
| 2 | SQL injection | ADO.NET and raw EF Core queries accept string concatenation, making injection syntactically easy. C# string interpolation looks clean but is just as dangerous as concatenation |
| 3 | XSS in Razor | Razor views auto-encode by default, but Html.Raw() bypasses encoding entirely. Developers use Html.Raw() for formatting and accidentally pass user-controlled content through it |
| 4 | CSRF | ASP.NET MVC requires explicit anti-forgery token validation per action. Missing ValidateAntiForgeryToken on a single POST endpoint allows cross-site form submissions that perform actions as the authenticated user |
| 5 | Path traversal | Path.Combine with relative segments resolves outside the base directory. The .NET Path API does not enforce containment -- manual prefix validation after GetFullPath() is required |
| 6 | XXE | XmlDocument and XmlTextReader process external entities by default in older .NET Framework versions. A single XML endpoint without DtdProcessing.Prohibit can read local files or trigger SSRF |
| 7 | Insecure cryptography | .NET includes MD5, SHA1, DES, and TripleDES without compile-time warnings. Developers choose them for compatibility or simplicity, and the code compiles without any indication of weakness |
| 8 | Information leakage | UseDeveloperExceptionPage() in production exposes full stack traces, source code snippets, and environment variables. A single unhandled exception reveals internal implementation details to attackers |
| 9 | Mass assignment | ASP.NET model binding maps all matching request fields to model properties. Without DTOs or Bind attributes, an attacker adds IsAdmin=true to a form POST and the framework sets it automatically |
| 10 | ViewState tampering | Legacy ASP.NET WebForms stores page state in a hidden ViewState field. Without MAC validation, attackers modify serialized ViewState to change application logic or trigger deserialization attacks |

## Secure coding checklist

- [ ] Never use BinaryFormatter — it is deprecated for security. Use System.Text.Json or Json.NET with `TypeNameHandling.None`
- [ ] Use parameterized queries: `SqlCommand` with parameters, EF Core LINQ, or Dapper parameterized queries — never string concatenation
- [ ] Razor views auto-encode by default — never use `@Html.Raw()` with untrusted data. Use Content Security Policy
- [ ] Enable anti-forgery tokens: `[ValidateAntiForgeryToken]` on all POST actions, `@Html.AntiForgeryToken()` in forms
- [ ] Validate file paths: `Path.GetFullPath()` + verify starts with expected base directory
- [ ] Use `XmlReaderSettings { DtdProcessing = DtdProcessing.Prohibit }` for XML parsing
- [ ] Use `System.Security.Cryptography` with AES-GCM, RSA-OAEP, SHA-256+. Avoid MD5, SHA1, DES, TripleDES
- [ ] Use `app.UseExceptionHandler()` in production, never `app.UseDeveloperExceptionPage()`
- [ ] Use `[Bind]` attribute or DTOs to prevent mass assignment — never bind directly to domain models
- [ ] Enable nullable reference types (`<Nullable>enable</Nullable>`) in all projects
- [ ] Use `SecureString` for in-memory credential handling where applicable
- [ ] Configure HTTPS redirection: `app.UseHttpsRedirection()` and HSTS: `app.UseHsts()`

## Common misconfigurations

- **ASP.NET Core**: Developer exception page in production, CORS allowing all origins, missing HTTPS redirection, authentication middleware ordered incorrectly
- **Entity Framework**: Logging SQL queries with sensitive data (`EnableSensitiveDataLogging` in prod), lazy loading exposing excessive data, raw SQL without parameterization
- **Identity**: Default password policy too weak, missing account lockout, no MFA enforcement, cookie without Secure/HttpOnly/SameSite
- **Configuration**: Connection strings in appsettings.json committed to git, secrets not using User Secrets or Azure Key Vault, `ASPNETCORE_ENVIRONMENT=Development` in production

## Security tooling

- **SAST**: Roslyn Analyzers (Microsoft.CodeAnalysis.Security), Semgrep (.NET rules), SonarQube (C# plugin), CodeQL
- **SCA**: dotnet-outdated, NuGet Audit (`dotnet restore --audit`), Snyk, Dependabot
- **DAST**: OWASP ZAP, Burp Suite
- **Runtime**: ASP.NET Core Data Protection API, Microsoft.AspNetCore.Authentication, Azure Key Vault

## Code examples

### Vulnerable: SQL injection with ADO.NET

```csharp
// VULNERABLE: String concatenation in SQL
public User GetUser(string username)
{
    var sql = $"SELECT * FROM Users WHERE Username = '{username}'";
    using var cmd = new SqlCommand(sql, connection);
    // Attacker sends: ' OR '1'='1' --
}
```

### Secure: Parameterized query

```csharp
// SECURE: Parameterized query
public User GetUser(string username)
{
    var sql = "SELECT * FROM Users WHERE Username = @username";
    using var cmd = new SqlCommand(sql, connection);
    cmd.Parameters.AddWithValue("@username", username);
    // Or with EF Core: context.Users.Where(u => u.Username == username)
}
```

### Vulnerable: Mass assignment

```csharp
// VULNERABLE: Binding directly to domain model
[HttpPost]
public IActionResult UpdateProfile(User user)
{
    // Attacker adds IsAdmin=true to form POST
    _context.Users.Update(user);
    _context.SaveChanges();
}
```

### Secure: DTO with explicit binding

```csharp
// SECURE: DTO limits bindable properties
public record UpdateProfileDto(string DisplayName, string Email);

[HttpPost]
[ValidateAntiForgeryToken]
public IActionResult UpdateProfile(UpdateProfileDto dto)
{
    var user = _context.Users.Find(User.GetUserId());
    user.DisplayName = dto.DisplayName;
    user.Email = dto.Email;
    // IsAdmin cannot be set — not in DTO
    _context.SaveChanges();
}
```
