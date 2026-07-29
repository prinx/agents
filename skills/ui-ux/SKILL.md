---
name: ui-ux
description: Fallback for user-facing interface work when frontend-design is unavailable; keep UI clear, accessible, responsive, and intentional without unnecessary design-system work.
---

# UI/UX Fallback

Use this skill only when a skill named `frontend-design` is not available. Read `core/standards/ui-design.md` for the project's design preferences before starting any UI work.

Preserve the existing application's visual and interaction conventions. A simple UI can still be polished and intentional: build the smallest interface that satisfies the approved feature with clear hierarchy, understandable labels and feedback, semantic HTML, keyboard access, visible focus, sufficient contrast, and responsive behavior at relevant sizes. Reuse existing components and styles before creating new ones.

**Follow emotional design at three levels (visceral, behavioral, reflective):**
- **Visceral**: clean, airy, intentional at first glance. No jarring colors, no clutter.
- **Behavioral**: smooth interactions, responsive feedback, effortless navigation. Buttons feel satisfying, forms are frictionless, loading states are intentional.
- **Reflective**: moments of delight that build brand loyalty. Thoughtful microcopy, satisfying completion states, a design the user would recommend.

**Key design directions (see `core/standards/ui-design.md` for full detail):**
- No AI-generated-looking UI. No dark purple, no ugly borders.
- Fonts should be inspired by the target domain of the app (music → score-like fonts, architecture → blueprint lettering, etc.)
- No boring centered hero landing pages. Be creative with layout — asymmetric, split, staggered, narrative-driven.
- White or white-variant dominated for light mode. Dark mode follows the brand.
- Google-level simplicity: straightforward, well-organized, hides complexity.
- Mobile-first. Dribbble quality bar, but unique per project.

Do not invent a design system, add decorative complexity, or expand scope with unrelated screens, states, or abstractions. Cover only the loading, empty, error, and success states the feature actually needs. If conventions are missing, choose a simple reversible presentation and note it briefly.
