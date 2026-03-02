# IDE Plugin Extensions — Platform Heuristics

**Key references**: VS Code UX Guidelines, JetBrains Plugin SDK docs, GitHub Copilot / GitLens / Cursor patterns

## Platform Complexity Checklist

A thorough IDE plugin review must evaluate:

- View placement (Activity Bar / Sidebar / Panel / Editor / Status Bar)
- Status Bar usage (minimal; no warning colors except exceptional cases)
- Command Palette registration (category prefix: `MyPlugin: Action Name`)
- Editor decorations (code lenses, gutter icons — subtle and dismissible)
- Notifications (limit count; prefer in-context progress over modal notifications)
- Performance (activation events; never `*` activation; `CancellationToken` support; bundle with esbuild/webpack)
- Theme integration (dark / light / high contrast; use theme variables, never hardcoded colors)
- Settings contribution (JSON schema; workspace vs user scope; sensible defaults)
- Marketplace UX (description starts with verb+noun; high-quality screenshots; conventional repo)
- Multi-IDE support considerations (VS Code / JetBrains / Neovim)

## Dimension Interpretation Table

| Dim | Generic Meaning | IDE Plugin Interpretation |
|-----|----------------|-------------------------|
| 1 | Human-centered problem framing | Does the plugin solve a real developer workflow problem? Is it modeled after how developers actually work in the editor? |
| 2 | Usability & interaction quality | Non-disruptive: works through Command Palette and shortcuts; doesn't block the editor; cancellable operations |
| 3 | Information architecture | Panel/sidebar/command organization: discoverable commands, logical grouping, progressive disclosure, tree views |
| 4 | Visual design & brand | Host theme integration: uses editor theme colors, consistent iconography, no visual clutter in the editor |
| 5 | User research & evidence | Developer testing in real workflows, marketplace ratings/reviews, telemetry (opt-in), issue tracker analysis |
| 6 | Accessibility & inclusivity | High contrast theme support, keyboard-only navigation, screen reader labels on custom views |
| 7 | Service blueprint & journey | Plugin lifecycle: discover → install → first use → configure → daily workflow → update → troubleshoot |
| 8 | Co-creation & facilitation | Open-source community, extension API contribution, user-configurable behavior, plugin interoperability |
| 9 | Prototyping & validation | Beta/pre-release channels, feature flags, insider builds for early feedback |
| 10 | Design system coherence | Host UI fidelity: uses native VS Code/JetBrains components, follows host UX patterns, not a web app embedded in IDE |

## Anti-Patterns (IDE Plugin-Specific)

**1. Editor Hijack**
- **Signs**: Plugin steals focus from the editor, blocks typing, uncancellable long-running operations, modal dialogs for non-critical actions
- **Impact**: Developers lose flow state — the most expensive resource in software development. Plugin becomes an obstacle, not a tool
- **Fix**: All operations cancellable (`CancellationToken`). Progress in Status Bar or Panel, not modals. Never steal editor focus without explicit user action

**2. Kitchen Sink Settings**
- **Signs**: 50+ configuration options, no sensible defaults, required configuration before first use, settings require documentation to understand
- **Impact**: Setup friction kills adoption. Users never discover optimal configuration. Support burden from misconfiguration
- **Fix**: Zero-config first use with sensible defaults. Progressive disclosure: basic → advanced settings. Workspace-aware defaults

**3. Notification Flood**
- **Signs**: Frequent modal notifications, information messages for routine operations, notification on every save/build/action, no way to silence
- **Impact**: Notification fatigue; users learn to dismiss all notifications including important ones. Disrupts coding flow
- **Fix**: Reserve notifications for errors and actionable items. Use Status Bar for routine status. Batch related notifications. Respect `do not disturb`

**4. Reinventing Host UI**
- **Signs**: Custom webview UI for tasks that native components handle, non-standard tree views, custom input modals instead of QuickPick, custom status indicators
- **Impact**: Breaks visual consistency with the IDE. Ignores theme changes. Breaks keyboard navigation. Feels like a foreign app embedded in the editor
- **Fix**: Use native components: TreeView, QuickPick, InputBox, StatusBarItem, CodeLens. Only use WebView for truly custom visualizations with no native equivalent

**5. Context Ignorance**
- **Signs**: Plugin operates identically regardless of file type, project structure, or workspace state. No awareness of language, framework, or project conventions
- **Impact**: Irrelevant suggestions, wrong-context actions, noise. Developer must manually filter plugin behavior for their current task
- **Fix**: File-type and workspace-aware activation (`activationEvents`). Adapt behavior to detected language/framework. Scope actions to relevant contexts

## Key Heuristics

1. **Be invisible until needed** — The best plugins don't feel like plugins; they feel like the IDE got smarter
2. **Command Palette is your front door** — Every action accessible via Command Palette with a clear category prefix
3. **Respect the host** — Use native components, follow host theme, honor host keyboard shortcuts
4. **Performance is trust** — Slow activation or operations erode trust instantly. Bundle, lazy-load, cancel
5. **Progressive disclosure** — Zero-config first use → discoverable features → power-user customization

## How Top Companies Do It

| Company | Practice |
|---------|----------|
| **GitHub Copilot** | Ghost text inline suggestions; Tab/Esc/Ctrl+Right partial accept; next edit predictions; inline chat (Cmd+I); minimal UI, maximal context |
| **GitLens** | 3 organized sidebars; progressive disclosure (simple → detailed); drag-and-drop view customization; native tree views |
| **Cursor** | Cmd+K inline edits; Composer Agent for multi-file; aggregated diff views; visual editor integration; context-aware suggestions |
| **Docker DX** | Inline vulnerability checks; Dockerfile linting; follows native VS Code UI patterns; contextual actions on Dockerfiles |
