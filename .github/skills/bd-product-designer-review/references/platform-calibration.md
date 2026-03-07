# Product Designer Review — Platform-Specific Calibration Anchors

Platform-specific scoring anchors for the top 2-3 weighted dimensions per platform. See [calibration-frameworks.md](calibration-frameworks.md) for generic scoring anchors and [platform-overview.md](platform-overview.md) for platform context.

## CLI / Terminal

**Dim 2 — Command Ergonomics**
- **5**: clig.dev compliant; composable output (stdout data, stderr status); actionable error messages with fix suggestions; `--json`/`--format` for machine consumption; `isatty()` detection
- **3**: Reasonable command names; some error messages vague; output parseable but no structured format; color used but NO_COLOR not respected
- **1**: Unparseable output; silent failures (exit 0 on error); flags conflict or overlap; no help text for common errors

**Dim 3 — Command Hierarchy**
- **5**: Logical verb-noun subcommand tree; comprehensive `--help` at every level; shell completion for bash/zsh/fish; man pages; discoverability via `commands`/`help` subcommand
- **3**: Flat command structure with reasonable naming; `--help` exists but sparse; no shell completion; some commands hard to discover
- **1**: No subcommand structure; 30+ top-level flags; no `--help`; undiscoverable features require reading source code

**Dim 10 — Consistency**
- **5**: Uniform verb vocabulary (list/get/create/delete); same flag names for same concepts everywhere; consistent output format (tables/JSON); consistent error format
- **3**: Mostly consistent naming with some exceptions; output format varies between commands; errors usually have messages but format differs
- **1**: Mix of verbs for similar ops (get/show/describe/list/fetch); flags renamed across commands; some output JSON, some plain text, some neither

## Web Applications

**Dim 2 — Responsive Usability**
- **5**: Mobile-first design; works at all breakpoints (480-1536px); inline form validation on blur; skeleton loading; Core Web Vitals met (LCP < 2.5s, INP < 200ms, CLS < 0.1); keyboard navigation complete
- **3**: Responsive but with some breakpoint issues; forms work but validation only on submit; loading states exist but inconsistent; CWV partially met
- **1**: Desktop-only layout; breaks below 1024px; forms lose data on error; no loading states; CWV failing; keyboard navigation broken

**Dim 3 — URL/IA**
- **5**: Every meaningful state has a URL; deep links work; breadcrumbs; tree-tested navigation; search with filters; back/forward works correctly; SEO-friendly
- **3**: Main views have URLs but modals/filters/pagination state lost on refresh; navigation reasonable but not user-tested; basic search
- **1**: SPA with single URL; refresh loses all context; no deep linking; navigation reflects org chart; no search

**Dim 6 — WCAG 2.2**
- **5**: WCAG AA met on all flows; AAA on critical flows; focus management correct; 24x24px minimum targets; dragging alternatives; tested with screen readers and assistive tech
- **3**: WCAG A met; some AA gaps; basic keyboard nav works; contrast mostly compliant; not tested with assistive technology
- **1**: No accessibility consideration; keyboard navigation broken; insufficient contrast; no alt text; form errors not announced

## Mobile Applications

**Dim 2 — Touch/Gesture**
- **5**: 44pt/48dp touch targets everywhere; thumb zone optimized (primary actions in easy reach); gesture conventions followed; haptic feedback; edge-to-edge with proper safe areas; works on foldables
- **3**: Touch targets mostly adequate with some undersized; bottom nav exists but some actions in top corners; standard gestures supported; safe areas mostly handled
- **1**: Touch targets < 30pt; primary actions require two-hand reach; custom gestures with no affordances; content overlaps notch/Dynamic Island; breaks on foldables

**Dim 6 — Accessibility**
- **5**: Full VoiceOver/TalkBack traversal; Dynamic Type to 200% without layout breaks; Switch Control support; 4.5:1 contrast; custom actions for complex gestures; tested on-device with assistive tech
- **3**: VoiceOver/TalkBack partially works; Dynamic Type supported but some elements clip at large sizes; contrast mostly compliant; not tested with real assistive tech users
- **1**: VoiceOver/TalkBack unusable; fixed font sizes; contrast violations on key screens; no accessibility labels; decorative images not hidden

**Dim 4 — Platform Visual Conventions**
- **5**: Follows HIG (iOS) / Material 3 (Android); proper dark mode (3 states, no pure black); adaptive layouts for all size classes; platform-specific components (bottom sheets/dialogs); safe areas correct
- **3**: Generally follows platform conventions with some cross-platform components; dark mode works but some inconsistencies; handles most screen sizes
- **1**: iOS app using Android components (or vice versa); no dark mode; single layout for all screen sizes; ignores platform navigation patterns

## IDE Plugin Extensions

**Dim 2 — Non-Disruptive**
- **5**: All operations via Command Palette + shortcuts; cancellable with CancellationToken; progress in Status Bar; never steals editor focus; activation < 100ms
- **3**: Most actions in Command Palette; some operations block briefly; progress shown but not always cancellable; occasional focus theft
- **1**: Modal dialogs for routine tasks; uncancellable long operations; steals editor focus; slow activation; freezes editor during processing

**Dim 10 — Host Integration**
- **5**: Uses native TreeView, QuickPick, CodeLens, StatusBarItem; respects all themes (dark/light/high contrast); follows host keyboard conventions; WebView only for truly custom views
- **3**: Mix of native and custom UI; mostly respects theme colors; some keyboard conventions followed; WebView used for some things that could be native
- **1**: Entire UI is a WebView; ignores host theme; custom keyboard shortcuts conflict with host; feels like a separate app embedded in the IDE

**Dim 3 — Panel/Sidebar IA**
- **5**: Logical view grouping; category-prefixed Command Palette entries; progressive disclosure (simple → detailed); discoverable without reading docs; settings organized by scope
- **3**: Reasonable organization; Command Palette entries exist but inconsistent naming; most features discoverable; settings present but numerous
- **1**: All features in one unsorted list; Command Palette entries missing or poorly named; features hidden in settings; no logical grouping

## Desktop Applications

**Dim 2 — Keyboard-First**
- **5**: Every action has a keyboard shortcut; menu bar shows accelerators; Cmd/Ctrl standard patterns followed; customizable keybindings; keyboard-only operation fully supported
- **3**: Common actions have shortcuts; menu bar exists with some accelerators; most features keyboard-accessible; some mouse-only actions
- **1**: No keyboard shortcuts; no menu bar accelerators; core features require mouse; custom shortcuts conflict with OS

**Dim 10 — OS Toolkit Compliance**
- **5**: Native dialogs (file picker, print, color); system fonts; per-monitor DPI aware; platform file associations; drag-and-drop; system notifications; Handoff/Snap Layouts support
- **3**: Some native dialogs; mostly handles DPI; basic file associations; limited drag-and-drop; uses some native OS features
- **1**: Custom file picker; DPI unaware (blurry on HiDPI); no file associations; no drag-and-drop; ignores OS conventions

**Dim 3 — Menu/Toolbar IA**
- **5**: Comprehensive menu bar (File/Edit/View/Window/Help at minimum); context menus; toolbar for frequent actions; logical hierarchy; multi-window support
- **3**: Menu bar with main items; some context menus; limited toolbar; single-window with tabs; mostly logical organization
- **1**: No menu bar (hamburger only); no context menus; no toolbar; all navigation via sidebar; undiscoverable features

## API / Developer Tools

**Dim 2 — Consistency/Ergonomics**
- **5**: Consistent naming (snake_case or camelCase everywhere); RFC 9457 error format; sensible defaults; idempotency keys; predictable pagination; status codes match semantics
- **3**: Mostly consistent naming with exceptions; errors have messages but format varies; defaults reasonable; pagination works but inconsistent pattern
- **1**: Naming varies across endpoints; generic errors ("Bad Request"); no defaults; no idempotency; pagination format changes between resources

**Dim 3 — Documentation IA**
- **5**: 3-layer structure (Getting Started → Tutorials → Reference); interactive playground; language-switching code examples; search; migration guides; changelogs; AI-readable structure
- **3**: API reference exists; some tutorials; code examples in 1-2 languages; basic search; changelog exists but incomplete
- **1**: Auto-generated Swagger only; no tutorials; no code examples; no search; no changelog; developers resort to trial-and-error

**Dim 10 — SDK Coherence**
- **5**: Official SDKs in top 5 languages; idiomatic per language; type safety; semantic versioning; 6-month deprecation windows; Sunset headers; migration guides; backward-compatible
- **3**: SDKs in 2-3 languages; mostly idiomatic; some type safety; versioning exists but deprecation windows short; migration guidance sparse
- **1**: No official SDKs (or one language only); not idiomatic; breaking changes without warning; no versioning strategy; community SDKs are the only option

## Mobile Quantitative Standards

| Standard | Value | Source |
|----------|-------|--------|
| Touch target minimum | 44pt (iOS) / 48dp (Android) | Apple HIG / Material 3 |
| Text contrast ratio | 4.5:1 (normal text), 3:1 (large text) | WCAG 2.2 AA |
| Non-text contrast ratio | 3:1 (UI components, graphics) | WCAG 2.2 AA |
| Text scaling support | Up to 200% without loss of content | WCAG 1.4.4 |
| Cold start time | < 2 seconds | Industry benchmark |
| Frame budget | 16ms (60 FPS) | Platform standard |
| Body text minimum | 17pt (iOS) / 14-16sp (Android) | HIG / Material 3 |
| Readable line length | 45-75 characters | Readability research |
| Bottom navigation items | 3-5 | HIG / Material 3 |
| Notification frequency | 2-5 per week (non-transactional) | Industry best practice |

## CLI Technical Standards

| Standard | Value | Source |
|----------|-------|--------|
| Exit code: success | 0 | POSIX |
| Exit code: general error | 1 | POSIX |
| Exit code: misuse | 2 | Bash convention |
| Exit code: cannot execute | 126 | POSIX |
| Exit code: not found | 127 | POSIX |
| Exit code: signal N | 128 + N | POSIX |
| Color: disable env var | `NO_COLOR` | no-color.org |
| Color: force env var | `FORCE_COLOR` | Convention |
| Color: dumb terminal | `TERM=dumb` → no formatting | Convention |
| Config precedence | flags > env vars > config file > defaults | 12-Factor CLI |
| Config location | `$XDG_CONFIG_HOME/<app>/` | XDG Base Directory |
| Output: data stream | stdout | Unix convention |
| Output: status/progress | stderr | Unix convention |
| Default terminal width | 80 columns | POSIX |
