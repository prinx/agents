# UI Design Standards

<!-- Project-specific design preferences. The orchestrator loads this before any UI/styling work and routes it to developer and quality. -->

## Golden rule

No AI-generated-looking UI. No generic dark purple with ugly borders. Every design must look intentional, professional, and crafted by a human who cares about detail.

## Design philosophy

- **Emotional design at all three levels.** UI must work on visceral (immediate gut reaction — look, feel, first impression), behavioral (pleasure of use — smooth, responsive, effortless), and reflective (lasting meaning — what using this product says about the user). A clean layout is not enough; the interface should feel good to interact with.
- **Google is the benchmark.** The Google homepage is straightforward, simple, well-organized, and hides enormous complexity behind a clean surface. That is the standard.
- **Dribbble-inspired, not Dribbble-copied.** Look at Dribbble for quality bar and polish, but make unique decisions per project.
- **Mobile-first.** Every layout must work beautifully on mobile before desktop.
- **White or white-variant dominated.** Light mode should be white or near-white (#FAFAFA, #F5F5F5, #FFFFFF). Color is used as accent, not as background.
- **Dark mode follows the brand.** Dark mode is not inverted light mode. It uses the brand's own colors (logo, primary palette) adapted for dark backgrounds. Dark mode should feel like the same brand at night.
- **Professional and restrained.** No gratuitous gradients, no decorative flourishes that don't serve content, no border-radius for its own sake.

## Specific rules

### Layout
- Generous whitespace. Breathing room is a feature.
- Clear visual hierarchy. The most important thing on the page should be immediately obvious.
- Consistent spacing scale. Use a defined rhythm (e.g., 4px or 8px grid).
- Full-width sections that feel grounded, not floating.

### Colors
- Primary palette: white-based for light mode, brand-appropriate dark for dark mode.
- Accent colors: used sparingly — one primary accent, one supporting accent maximum.
- Text: high contrast always. No #999 text on white backgrounds.
- Borders: subtle when present. 1px, light gray (#E0E0E0) or transparent. No thick dark borders.

### Typography
- **Fonts must be inspired by the target domain of the app.** Research the domain's visual language — if it's a music app, look at what musical scores use; if it's architecture, look at blueprint lettering; if it's finance, look at financial documents. Derive font choices from that research.
- No default "safe" system fonts (Inter, SF Pro, etc.) unless the domain genuinely calls for them.
- Type scale should be deliberate and limited (3-4 sizes max).
- Body text: readable size (16px minimum), comfortable line-height (1.5+).
- Headings: clear hierarchy, appropriate weight. No forced bold everywhere.
- No generic "clean modern font" choices. Match the brand character.

### Landing pages
- Must be unique. Not a template. Not a pattern you've seen before.
- **No centered headline + subtitle + CTA + mockup.** That is the generic pattern agents always produce. Be creative and innovative with layout: asymmetric, split-screen, staggered, grid-breaking, narrative-driven, interactive, or whatever the subject dictates.
- The hero should be the most characteristic thing in the subject's world — an interactive element, a live demo, a data visualization, a kinetic typography moment, a product demo embedded in the page. Let the subject dictate the form.
- Structure tells a story. Each section should have a reason to exist.
- No stock UI patterns (no "01/02/03" numbered steps unless the content is truly sequential).

### Authentication (login/signup)
- Very simple. Minimalist. Nothing unnecessary.
- Single focused column. One primary action.
- Social login as secondary option below the form.
- Error states must be clear and helpful.
- No decorative illustrations on auth pages unless the brand truly calls for it.

### Components
- Buttons: clear, tappable, with purposeful sizing. Primary button is the most important action.
- Forms: labels are visible, fields are tall enough to tap (48px minimum), validation is inline and immediate.
- Navigation: predictable, minimal, accessible.
- Cards/modals: subtle if used. No heavy borders or shadows.
- Lists/tables: scannable, well-spaced, with clear row separation.

### Accessibility & responsiveness
- Every interactive element must have a visible focus state.
- Touch targets: 44x44px minimum.
- Responsive: mobile, tablet, desktop. Content reflows, doesn't just scale down.
- Reduced motion respected.
- Keyboard-navigable in logical order.

## Emotional design

Beyond function, the UI must feel right. Apply Don Norman's three levels:

**Visceral — the immediate reaction (0–5 seconds):**
- Does the page feel clean, airy, and intentional at first glance?
- Would the user say "that looks nice" before they even know what it does?
- No jarring colors, no cluttered first view, no cheap visual effects.
- The first impression should communicate quality and care.

**Behavioral — the pleasure of use (during interaction):**
- Does every interaction feel smooth and responsive? No jank, no layout shifts, no confusing transitions.
- Are buttons satisfying to click? Consider subtle feedback: color change, micro-movement, state transition.
- Is the form effortless? Autofocus the first field, validate inline, show clear success/error states.
- Does navigation feel natural? The user should never think "where do I click next."
- Loading states should feel intentional, not broken — skeleton screens, not spinners.

**Reflective — the lasting meaning (after use):**
- Would the user recommend this product because of how it made them feel?
- Does the design make the user feel competent and in control?
- Is there a moment of delight — a well-crafted animation, a thoughtful microcopy, a satisfying completion state?
- The reflective level is what builds brand loyalty. A product that works well is forgotten; a product that feels good is remembered.

## Reference quality bar

Before calling UI "done", check:
1. Does this look like an AI designed it? If yes, redesign.
2. Is the most important thing on the page the most visually prominent thing? If no, fix hierarchy.
3. Does it work on a 375px screen without horizontal scroll? If no, fix responsive.
4. Does dark mode feel like the same brand, not a afterthought? If no, rework dark palette.
5. Is there anything on the page that doesn't serve the user's goal? If yes, remove it.
