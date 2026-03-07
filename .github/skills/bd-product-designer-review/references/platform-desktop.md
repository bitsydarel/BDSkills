# Desktop Applications — Platform Heuristics

**Key references**: Apple HIG macOS (+ Liquid Glass 2025), Fluent Design 2, Electron / Tauri benchmarks

## Platform Complexity Checklist

A thorough desktop review must evaluate:

- macOS specifics (vibrancy, menu bar as primary command interface, Dock integration, Handoff/Universal Control, Liquid Glass 2025)
- Windows specifics (Fluent Design 2, Mica/Acrylic materials, WinUI 3, Snap Layouts, 8px rounded corners)
- Linux specifics (GTK vs Qt, tiling WM compatibility, no standard HIG)
- Per-monitor DPI awareness (`WM_DPICHANGED`; never cache DPI values)
- Keyboard shortcuts (OS-standard compliance, customizable keybindings, international keyboard layouts)
- Menu bar / toolbar design (primary command discoverability, context menus)
- Multi-window management (main window, inspectors, palettes, preferences)
- System integration (file system, clipboard, drag-and-drop, notifications)
- Framework tradeoffs (Electron: 200-300MB / 1-2s startup vs Tauri: 10MB / <500ms; V8 snapshots for optimization)
- Auto-update mechanism (non-disruptive, background download, restart prompt)

## Dimension Interpretation Table

| Dim | Generic Meaning | Desktop Interpretation |
|-----|----------------|----------------------|
| 1 | Human-centered problem framing | Does the app solve a task that benefits from persistent, focused desktop use? Not a website in a window? |
| 2 | Usability & interaction quality | Keyboard-first: comprehensive shortcuts, menu bar navigation, Cmd/Ctrl patterns, drag-and-drop, multi-window |
| 3 | Information architecture | Menu/toolbar IA: logical menu hierarchy, toolbar for frequent actions, sidebar for navigation, window management patterns |
| 4 | Visual design & brand | OS-native visual language: Fluent on Windows, HIG on macOS. Vibrancy/Mica/Acrylic materials. Platform typography |
| 5 | User research & evidence | Desktop workflow observation: long sessions, multi-monitor setups, keyboard-heavy workflows, power user patterns |
| 6 | Accessibility & inclusivity | OS accessibility APIs (NSAccessibility/UIA), keyboard-only operation, high contrast, screen reader, zoom, reduced motion |
| 7 | Service blueprint & journey | Desktop lifecycle: download → install → first run → import/migrate → daily use → sync → update → uninstall |
| 8 | Co-creation & facilitation | Beta channels, crash reporting, telemetry (opt-in), community forums, plugin ecosystem |
| 9 | Prototyping & validation | Platform-native prototypes, cross-platform testing (macOS/Windows/Linux), DPI testing, multi-monitor testing |
| 10 | Design system coherence | OS toolkit compliance: native dialogs, system fonts, DPI awareness, platform file picker, color picker, print dialog |

## Anti-Patterns (Desktop-Specific)

**1. Web-in-a-Window**
- **Signs**: No native menu bar, web-style navigation (back/forward buttons), browser-like tabs instead of native tabs, no keyboard shortcuts, no drag-and-drop, web loading spinners
- **Impact**: Users expect desktop behavior (menu bar, Cmd+S, drag files). Web-in-a-window feels cheap, slow, and foreign. Misses desktop advantages
- **Fix**: Implement proper menu bar. Support OS keyboard shortcuts. Use native dialogs (file picker, print). Add drag-and-drop. Respect OS dark mode/accent color

**2. Menu Bar Desert**
- **Signs**: Empty or minimal menu bar, all actions behind hamburger menus or sidebars, no keyboard accelerators shown in menus, undiscoverable features
- **Impact**: Desktop users rely on menu bar for discoverability (especially macOS where it's always visible). Missing menus = hidden functionality
- **Fix**: Comprehensive menu bar with logical grouping. Show keyboard accelerators. Include standard menus (File, Edit, View, Window, Help). Context menus for right-click

**3. Single Window Tyranny**
- **Signs**: App forces all content into one window, no inspector/panel/palette support, can't view two documents side by side, no multi-monitor awareness
- **Impact**: Desktop's advantage is space — multiple windows, monitors, split views. Single-window apps waste this advantage and frustrate power users
- **Fix**: Support multiple windows. Detachable panels/inspectors. Multi-monitor awareness. Remember window positions and sizes per monitor

**4. Update Interruption**
- **Signs**: Forced updates that block work, restart required immediately, update downloads during active use causing performance degradation, no rollback
- **Impact**: Users lose work, flow state broken, trust eroded. Enterprise users especially frustrated by forced restarts during critical tasks
- **Fix**: Background download. Prompt to restart at natural break points. Never force-restart. Provide rollback capability. Update on next launch if preferred

**5. File System Ignorance**
- **Signs**: No native file picker, can't drag files onto app, doesn't respect OS file associations, custom file browser instead of native dialog, no recent files
- **Impact**: Desktop users have muscle memory for file operations. Custom file dialogs break expectations, lack features (favorites, tags, search), and feel untrusted
- **Fix**: Use native file picker. Support drag-and-drop from Finder/Explorer. Register file type associations. Integrate with recent files. Respect OS file metadata

## Key Heuristics

1. **Keyboard is king** — Every action has a keyboard shortcut. Menu bar shows accelerators. Customizable keybindings
2. **Native first, cross-platform second** — Use OS toolkit, dialogs, and conventions. Platform parity ≠ platform uniformity
3. **Respect the window manager** — Multiple windows, remember positions, multi-monitor DPI, Snap Layouts (Windows), Spaces (macOS)
4. **Performance earns trust** — Startup < 1s (native) or < 2s (Electron). Responsive to input. Background processing doesn't block UI
5. **Integrate, don't isolate** — File system, clipboard, notifications, Handoff, system search (Spotlight/Start), auto-update

## How Top Companies Do It

| Company | Practice |
|---------|----------|
| **Slack** | Single-process Redux model cut memory 50%; Unified Grid for Enterprise; native menus and notifications per platform |
| **Spotify** | Migrated to CEF-based web UI for consistency; Encore design system adapts to desktop; keyboard shortcuts for playback |
| **Apple** | macOS HIG with Liquid Glass (2025); native Cocoa components; Handoff between devices; Spotlight integration |
