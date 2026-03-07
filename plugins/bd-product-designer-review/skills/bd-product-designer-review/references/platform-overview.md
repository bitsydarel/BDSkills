# Product Designer Review — Platform-Specific Heuristics

Platform-specific interpretation overlays for the 10 evaluation dimensions. Each platform file provides complexity context, dimension reinterpretation, anti-patterns, key heuristics, and industry practices.

## Platform Quick Lookup Table

| Platform | File | Top Weighted Dimensions | Key Standards |
|----------|------|------------------------|---------------|
| [CLI / Terminal](platform-cli.md) | platform-cli.md | Dim 2 (command ergonomics), Dim 3 (command hierarchy), Dim 10 (consistency) | clig.dev, POSIX, GNU, 12-Factor CLI |
| [Web](platform-web.md) | platform-web.md | Dim 2 (responsive usability), Dim 3 (URL/IA), Dim 6 (WCAG 2.2) | Core Web Vitals, WCAG 2.2, Lighthouse |
| [Mobile](platform-mobile.md) | platform-mobile.md | Dim 2 (touch/gesture), Dim 6 (accessibility), Dim 4 (platform visual) | Apple HIG, Material Design 3, WCAG 2.2 |
| [IDE Plugin](platform-ide.md) | platform-ide.md | Dim 2 (non-disruptive), Dim 10 (host integration), Dim 3 (panel IA) | VS Code UX Guidelines, JetBrains Plugin SDK |
| [Desktop](platform-desktop.md) | platform-desktop.md | Dim 2 (keyboard-first), Dim 3 (menu/toolbar IA), Dim 10 (OS compliance) | Apple HIG macOS, Fluent Design 2 |
| [API / Developer Tools](platform-api.md) | platform-api.md | Dim 2 (consistency), Dim 3 (documentation IA), Dim 10 (SDK coherence) | Stripe DX, Google AIP, RFC 9457 |

## Platform Classification Guide

When the target platform is ambiguous, apply these decision rules:

| Ambiguous Case | Classification | Rationale |
|---------------|----------------|-----------|
| Responsive web app on mobile browser | **Web** | Browser rendering; no native APIs; evaluate responsive breakpoints |
| Electron / CEF app | **Desktop** (primary) + **Web** (secondary) | Users expect native desktop behavior; web layer is implementation detail |
| Tauri app | **Desktop** | Native shell; web renderer is internal; users see a desktop app |
| VS Code WebView panel | **IDE Plugin** | Context is the IDE host; WebView is a presentation layer within the extension |
| React Native targeting web | **Mobile** (primary) + **Web** (secondary) | Primary target is mobile; web is secondary surface |
| PWA installed on homescreen | **Web** (primary) + **Mobile** (secondary considerations) | Still browser-rendered; evaluate mobile touch ergonomics as secondary |
| CLI with TUI (e.g., `htop`, `lazygit`) | **CLI** | Terminal-rendered; keyboard-driven; evaluate with CLI heuristics |
| API with dashboard portal | **API** (primary) + **Web** (secondary for dashboard) | Core product is the API; dashboard is a companion tool |

## Multi-Platform Review Guidance

When a product targets multiple platforms:

1. **Identify the primary platform** — the surface where most users spend most time
2. **Score using primary platform heuristics** — one scorecard, primary platform interpretation
3. **Flag secondary platform gaps as issues** — note where the experience falls short on secondary surfaces
4. **Add a Cross-Platform Consistency note** evaluating:
   - Is the core mental model consistent across surfaces?
   - Are capabilities appropriately adapted (not just ported) per platform?
   - Do transitions between platforms preserve context (deep links, handoff, sync)?
   - Does the design system scale across platforms (shared tokens, platform-specific components)?

## Extensibility Note

This framework is designed to accommodate future platforms following the same per-platform structure:

- **Wearables** (watchOS, Wear OS) — glanceable, haptic, health-context
- **TV** (tvOS, Android TV, Fire TV) — 10-foot UI, D-pad navigation, lean-back
- **Voice** (Alexa, Google Assistant) — conversational UI, no visual, turn-taking
- **AR/VR** (visionOS, Quest) — spatial, gaze+gesture, 3D interaction models
- **Embedded/IoT** — constrained displays, physical controls, mesh networking

To add a new platform: create a `platform-<name>.md` file with Complexity Checklist, Dimension Interpretation Table (all 10 dims), 5 Anti-Patterns (Signs/Impact/Fix), 5 Key Heuristics, and Company Practices table. Then add it to the Quick Lookup Table above.

**Standards evolve annually** — key references to verify for currency:
- Apple HIG: updated each WWDC (June)
- Material Design: updated each Google I/O (May)
- WCAG: W3C working drafts and recommendations
- clig.dev: community-maintained, check for updates
