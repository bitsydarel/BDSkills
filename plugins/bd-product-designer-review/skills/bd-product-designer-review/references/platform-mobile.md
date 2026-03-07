# Mobile Applications — Platform Heuristics

**Key references**: Apple HIG (+ Liquid Glass 2025), Material Design 3, Hoober thumb research, WCAG 2.2 mobile guidance

## Platform Complexity Checklist

A thorough mobile review must evaluate:

- Screen sizes (320pt small phones → 1366pt tablets)
- Foldable postures (folded / flat / tabletop / book; hinge no-fly zone)
- Width size classes (Compact / Medium / Expanded on Android; Compact / Regular on iOS)
- OEM fragmentation (Samsung One UI Viewing/Interaction Area split, Xiaomi HyperOS, Huawei HMS without GMS)
- OS version fragmentation (target current API level; support 2-3 versions back)
- Dark mode (3 states: Light / Dark / System; avoid pure black `#000`)
- Dynamic Type / text scaling (iOS: 12 type sizes; Android: up to 200%; WCAG 1.4.4)
- Accessibility (VoiceOver / TalkBack, Switch Control, 44pt / 48dp touch targets, 4.5:1 contrast)
- Gesture navigation (edge-to-edge on Android 15+; safe areas for notch / Dynamic Island / punch-hole)
- Orientation + foldable posture changes
- Input methods (touch, stylus, keyboard, mouse on iPad, voice)
- Multi-window (iPad Split View / freeform, Samsung DeX)
- Performance (cold start < 2s, 60 FPS / 16ms frame budget)
- Offline-first (local-first, sync-later architecture)
- Push notification UX (never on first launch; reciprocity principle; 2-5/week)
- Deep linking (Universal Links / App Links, deferred deep links)
- ASO (7 seconds on product page; screenshots as first UX interaction)

## Dimension Interpretation Table

| Dim | Generic Meaning | Mobile Interpretation |
|-----|----------------|---------------------|
| 1 | Human-centered problem framing | Mobile-specific context: one-handed use, interrupted sessions, on-the-go, varying connectivity |
| 2 | Usability & interaction quality | Touch/gesture quality: thumb zones (75% thumb-driven per Josh Clark), 44pt/48dp targets, gesture conventions, haptic feedback |
| 3 | Information architecture | Mobile IA: bottom nav (3-5 items), tab structure, search prominence, deep link support, breadcrumb alternatives |
| 4 | Visual design & brand | Platform visual conventions: HIG/Material compliance, Dynamic Type support, dark mode, adaptive layouts, safe areas |
| 5 | User research & evidence | Mobile-specific testing: on-device observation (not desktop emulators), diverse device testing, field studies in real contexts |
| 6 | Accessibility & inclusivity | VoiceOver/TalkBack compliance, Switch Control support, Dynamic Type to 200%, 4.5:1 contrast, 44pt/48dp touch targets |
| 7 | Service blueprint & journey | Mobile journey: app store → install → first launch → permission grants → onboarding → daily use → notification → deep link re-entry |
| 8 | Co-creation & facilitation | Beta testing (TestFlight/Play Console), in-app feedback, app store reviews as user signal |
| 9 | Prototyping & validation | On-device prototype testing (not just screen shares), real gesture interaction, diverse device testing |
| 10 | Design system coherence | Cross-platform consistency (iOS/Android), platform-specific adaptations (bottom sheets on iOS, dialogs on Android), adaptive components |

## Anti-Patterns (Mobile-Specific)

**1. Platform Denial**
- **Signs**: iOS app uses Material Design components (or vice versa), custom navigation ignoring platform patterns, non-native gestures, Android app with iOS-style back arrows
- **Impact**: Users have built platform muscle memory. Violating conventions creates friction on every interaction. App feels foreign
- **Fix**: Follow HIG for iOS, Material for Android. Share design system tokens but adapt components to platform conventions. Use platform navigation patterns

**2. Desktop Miniaturization**
- **Signs**: Desktop layout squeezed onto mobile, tiny touch targets, dense information layouts, horizontal scrolling, hover-dependent features
- **Impact**: Unusable on actual devices. Touch targets too small for fingers. Content unreadable. Users pinch-zoom constantly
- **Fix**: Design for mobile context first. 44pt/48dp minimum touch targets. Prioritize content ruthlessly. Use progressive disclosure for density

**3. Notification Spam**
- **Signs**: Permission request on first launch, 10+ notifications per day, non-actionable alerts, no notification preferences, marketing push disguised as transactional
- **Impact**: Users disable all notifications (or uninstall). App loses its most valuable engagement channel. Trust erodes
- **Fix**: Demonstrate value before requesting permission (reciprocity). 2-5 notifications per week max. Every notification must be actionable. Granular preferences

**4. Gesture Mystery**
- **Signs**: Core actions require undiscoverable gestures, no visual affordances for swipe/long-press/pinch, gestures conflict with system gestures (edge swipe), no alternative tap paths
- **Impact**: Users never discover features. System gesture conflicts break navigation. Only power users can access functionality
- **Fix**: Gestures as accelerators, never as sole path. Visible affordances (swipe indicators). Avoid edge gestures that conflict with system back/home. Tutorial on first use for non-obvious gestures

**5. Permission Ambush**
- **Signs**: All permissions requested at launch, no explanation before system dialog, permissions requested before user understands value, unnecessary permissions
- **Impact**: Users deny reflexively. App loses access to critical capabilities. Trust deficit from first interaction
- **Fix**: Request permissions in-context when first needed. Show value proposition before system dialog. Explain why in plain language. Graceful degradation when denied

## Key Heuristics

1. **Thumb zone first** — 75% of interactions are thumb-driven. Primary actions in easy-reach zone (Samsung One UI codifies Viewing Area top / Interaction Area bottom)
2. **Touch targets are sacred** — 44pt (iOS) / 48dp (Android) minimum. No exceptions for "fitting more on screen"
3. **Design for interruption** — Sessions are short and interrupted. Auto-save, preserve state, easy re-orientation
4. **Platform conventions are law** — Follow HIG on iOS, Material on Android. Share tokens, adapt components
5. **Accessibility is table stakes** — VoiceOver/TalkBack must work. Dynamic Type to 200%. 4.5:1 contrast minimum

## Mobile Quantitative Standards

| Standard | iOS | Android | Source |
|----------|-----|---------|--------|
| Touch target | 44pt minimum | 48dp minimum | Apple HIG / Material 3 |
| Contrast ratio | 4.5:1 (text), 3:1 (large) | 4.5:1 (text), 3:1 (large) | WCAG 2.2 AA |
| Text scaling | Dynamic Type 12 sizes | Up to 200% | WCAG 1.4.4 |
| Cold start | < 2s | < 2s | Industry benchmark |
| Frame rate | 60 FPS (16ms budget) | 60 FPS (16ms budget) | Platform standard |
| Body text | 17pt minimum | 14-16sp minimum | HIG / Material 3 |
| Line length | 45-75 characters | 45-75 characters | Readability research |
| Bottom nav items | 3-5 | 3-5 | HIG / Material 3 |

## How Top Companies Do It

| Company | Practice |
|---------|----------|
| **Apple** | HIG + Liquid Glass (2025); 44pt targets mandatory; Dynamic Type required for App Store approval; clarity/deference/depth principles |
| **Google** | Material 3 Expressive (tested with 18,000+ users); adaptive layouts with size classes; Core App Quality Guidelines |
| **Spotify** | Encore cross-platform components; adaptive corner radius by screen size; platform-specific navigation patterns |
| **Netflix** | A/B tests every change; adaptive bitrate streaming; AI subtitle positioning; personalized content thumbnails |
| **Airbnb** | DLS tablet layouts with focus views/modals/2-column grids; consistent token system across iOS and Android |
| **Meta/Instagram** | Reels-first navigation reflecting 50%+ time in Reels/DMs; adaptive layout for foldables |
