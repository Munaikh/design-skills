---
name: flutter-mobile-design
description: Design and implement Flutter mobile journeys, screens, navigation, components, and purposeful animation. Use for building or improving iOS and Android experiences, including phone and foldable adaptation.
metadata:
  author: Abdullah AlMunaikh
  edition: Flutter mobile UX and design
---

# Flutter Mobile Design

Abdullah AlMunaikh’s modified Flutter edition, based on Emil Kowalski’s design-skills. Preserve original MIT attribution.

Follow the [Flutter/Dart coding conventions](references/dart-engineering.md): inspect project truth, preserve architecture and generation patterns, keep typed readable code and flat widget composition, and validate proportionally. For Flutter-side UI, use Flutter Animate by default for effects, or simple implicit widgets such as AnimatedContainer. Use Motor for physics and Heroine for shared elements; do not introduce stock Hero. Use Smooth Sheets for sheets and Motion for purposeful 3D tilt/parallax. Reserve low-level stock controllers, tween timelines, and simulations for very complex custom animation mixers that these tools cannot express. Follow the [preferred toolkit](references/toolkit.md) for integration details.

Use no ink splashes or ripples: disable them centrally with `NoSplash.splashFactory` and transparent `splashColor`, and audit local overrides. Build intentional custom components or deliberately themed semantic primitives; do not use unstyled stock Material for everything. Preserve pressed, focused, selected, and disabled feedback. Keep shadows restrained, shared, and purposeful for hierarchy, following Emil’s cohesion and attention to unseen details. See [theme and component appearance](references/theme-patterns.md).

## Understand → design the flow → build → verify

Start with the user's task and the actual app: project instructions, SDK pin, dependencies, theme, controls, router, state ownership, and existing tests. For substantial work, give a short UX brief: goal, entry point, primary journey, recovery states, and observable completion. Keep it in the working response; separate documents are for complex flows or requested handoffs. Small repairs do not need a full journey map.

Design for mobile use, not a scaled-down web interface. Preserve product intent and familiar platform behavior. Improve navigation and interaction within the requested feature; explain material changes. Ask before changing business rules, removing capabilities, or expanding the assignment. Follow existing backend and state-management architecture.

Build concrete work within the authorized scope. Ordinary work goes directly into the user's app; do not create a separate demo or run an unsolicited prototype/audit stage. Read only the references needed:

| Need | Reference |
| --- | --- |
| Substantial journey, navigation, recovery, phone/foldable layout | [Mobile UX](references/mobile-ux.md) |
| Product personality, restraint, and invisible craft | [Design engineering](references/design-engineering.md), [case studies](references/case-studies.md) |
| Shared type, color, spacing, shapes, controls | [Theme](references/theme-patterns.md), [components](references/component-patterns.md) |
| Animation or gesture work | [Motion](references/motion-patterns.md), matching [recipe](references/recipes.md) |
| Loading, error, retry, undo, or completion | [Feedback](references/feedback.md) |
| Controls, focus, dismissal, text scaling | [Accessibility](references/mobile-accessibility.md), [platform behavior](references/native-ui.md) |
| Dependencies or Apple-style navigation | [Preferred toolkit](references/toolkit.md) |
| Async state, models, resource ownership | [Dart engineering](references/dart-engineering.md) |
| Runtime journey testing | [Marionette testing](references/marionette-testing.md) |
| Naming an effect | [Motion vocabulary](references/glossary.md); answer the naming question without starting implementation |

## Craft rules

- User experience includes reaching the goal, understanding state, recovering from mistakes, and retaining work. A polished screenshot alone is insufficient.
- Phones first, then foldables. Preserve route, selection, draft, and scroll through resizing/folding; use available constraints and hinge information rather than device labels. Adapt conventions to iOS and Android with shared product identity.
- Extend the shared theme and semantic component APIs. Prefer existing components/dependencies; use the toolkit's task-specific defaults for suitable new features and SDK primitives for simple needs.
- Gate motion by frequency and purpose before curve and duration. Repeated/keyboard actions remain immediate. Preserve platform navigation; gestures retarget from current position and velocity. Zero added motion is valid.
- Own tickers, async operations, subscriptions, focus, and overlays. Handle interruption, disposal, reduced motion, large text, RTL, keyboard, and hidden-state semantics.
- Measure UI and raster work when performance matters. Glass, blur, opacity, clips, and transforms still need evidence.

Deliver the implementation, brief flow/design rationale, checks actually run, and precise remaining limits. Format/analyze with the project SDK and run relevant behavioral tests. Use Marionette on the actual running app when available; report unavailable runtime checks honestly. Device feel, assistive navigation, haptics, and sustained performance require their own evidence.
