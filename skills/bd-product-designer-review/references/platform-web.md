# Web Applications — Platform Heuristics

**Key references**: Google Core Web Vitals, WCAG 2.2, Lighthouse, MDN Web Docs

## Platform Complexity Checklist

A thorough web review must evaluate:

- Responsive breakpoints (480 / 768 / 1024 / 1280 / 1536px)
- Core Web Vitals (LCP < 2.5s, INP < 200ms, CLS < 0.1)
- Cross-browser compatibility (Blink / WebKit / Gecko engines)
- Internationalization (RTL layouts, text expansion 30-200%, `Intl` API)
- Form UX (inline validation on blur, `autocomplete` attributes, multi-step patterns)
- URL-as-UX (every meaningful state shareable/bookmarkable, deep linking)
- PWA capabilities (service workers, offline-first, installability)
- Loading states (skeleton screens perceived 30% faster than spinners per research)
- WCAG 2.2 compliance (focus management, dragging alternatives, 24x24px minimum target)
- SEO (semantic HTML, structured data, server-side rendering for critical content)
- Performance budgets (JS bundle < 200KB gzipped for mobile, critical CSS inlined)

## Dimension Interpretation Table

| Dim | Generic Meaning | Web Interpretation |
|-----|----------------|-------------------|
| 1 | Human-centered problem framing | Is the web app solving a real user need? Are mental models based on web behavior (tabs, bookmarks, back button)? |
| 2 | Usability & interaction quality | Responsive usability: works across breakpoints, form validation, loading/error states, keyboard navigation |
| 3 | Information architecture | URL structure as IA: every state has a URL, breadcrumbs, search, tree-tested navigation, deep links |
| 4 | Visual design & brand | Responsive visual hierarchy, dark mode support, consistent spacing/typography across breakpoints |
| 5 | User research & evidence | A/B testing at scale, analytics-informed design, Core Web Vitals monitoring, real user monitoring (RUM) |
| 6 | Accessibility & inclusivity | WCAG 2.2 AA: focus management, keyboard navigation, screen reader semantics, contrast, target sizes, dragging alternatives |
| 7 | Service blueprint & journey | Full web journey: landing → onboarding → core task → cross-tab/device → email notification → return visit |
| 8 | Co-creation & facilitation | User feedback mechanisms, beta programs, public roadmaps, community forums |
| 9 | Prototyping & validation | Browser-based prototypes, progressive enhancement, feature flags for controlled rollout |
| 10 | Design system coherence | Design tokens (CSS custom properties), responsive component library, cross-browser consistency |

## Anti-Patterns (Web-Specific)

**1. Desktop-First Neglect**
- **Signs**: Layout breaks below 1024px, touch targets too small on mobile browsers, hover-dependent interactions, no responsive testing
- **Impact**: 60%+ of web traffic is mobile; desktop-first means majority of users get a degraded experience
- **Fix**: Design mobile-first, enhance for desktop. Test at all breakpoints. Replace hover with tap-friendly alternatives

**2. SPA Amnesia**
- **Signs**: Browser back button breaks, URLs don't reflect app state, refresh loses context, can't share deep links, no browser history entries
- **Impact**: Violates fundamental web contract — URLs are the web's superpower. Users can't bookmark, share, or navigate naturally
- **Fix**: Every meaningful state has a URL. Push browser history entries. Handle back/forward. Support deep linking

**3. Form Fatigue**
- **Signs**: 15+ fields on one page, no inline validation, validation only on submit, no autocomplete attributes, no multi-step chunking
- **Impact**: High abandonment rates. Users lose work on validation failure. Mobile form entry is especially painful
- **Fix**: Progressive disclosure (multi-step forms), inline validation on blur, proper `autocomplete` attributes, save-as-you-go

**4. Performance Blindness**
- **Signs**: No Core Web Vitals monitoring, LCP > 4s, JS bundle > 500KB, no performance budget, layout shifts on load
- **Impact**: Every 100ms of latency costs 1% conversion (Amazon). Users abandon slow sites; Google ranks them lower. Mobile on 3G is worst case
- **Fix**: Performance budgets in CI. Monitor CWV in production (CrUX data). Lazy-load below-fold content. Code-split by route

**5. SEO Invisibility**
- **Signs**: Client-side rendering only, no semantic HTML, missing meta tags, no structured data, JavaScript-dependent content
- **Impact**: Search engines can't index content effectively. Content marketing and organic traffic suffer. Social sharing previews broken
- **Fix**: Server-side render critical content. Use semantic HTML (`<article>`, `<nav>`, `<main>`). Add Open Graph tags. Implement structured data

## Key Heuristics

1. **URL is UX** — Every meaningful state must be represented in the URL; shareable, bookmarkable, deep-linkable
2. **Progressive enhancement** — Core functionality works without JS; enhance with JS. Works on slow connections
3. **Performance is a feature** — LCP < 2.5s, INP < 200ms, CLS < 0.1. Skeleton screens over spinners
4. **Responsive by default** — Design for the smallest screen first, enhance for larger. No breakpoint is optional
5. **The browser is your platform** — Respect back/forward, browser zoom, text-only mode, reader mode, print stylesheets

## How Top Companies Do It

| Company | Practice |
|---------|----------|
| **Google** | PageSpeed Insights / Lighthouse as standard; CrUX field data for real-user performance; HEART framework for UX metrics |
| **Netflix** | Personalized thumbnails via A/B testing; 2000+ taste communities for content UX; streaming quality adaptation |
| **Meta** | React + rem units for font scaling; CSS-in-JS for dark mode theming; intensive A/B testing platform |
| **Spotify** | CEF-based web player; Encore design system with web-specific components; responsive grid for library views |
| **Airbnb** | DLS tokens → responsive components; image optimization pipeline; skeleton loading throughout |
