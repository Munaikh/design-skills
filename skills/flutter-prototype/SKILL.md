---
name: flutter-prototype
description: Explore requested Flutter mobile design alternatives through working components or complete short journeys, compare tradeoffs, and integrate the selected direction.
metadata:
  author: Abdullah
  edition: Flutter mobile UX and design
---

# Flutter Prototype

Modified Flutter edition, based on Emil Kowalski’s design-skills. Preserve original MIT attribution.

Follow the [Flutter/Dart coding conventions](references/dart-engineering.md): inspect project truth, preserve architecture and generation patterns, keep typed readable code and flat widget composition, and validate proportionally. For Flutter-side UI, use Flutter Animate by default for effects, or simple implicit widgets such as AnimatedContainer. Use Motor for physics and Heroine for shared elements; do not introduce stock Hero. Use Smooth Sheets for sheets and Motion for purposeful 3D tilt/parallax. Reserve low-level stock controllers, tween timelines, and simulations for very complex custom animation mixers that these tools cannot express. Follow the [preferred toolkit](references/toolkit.md) for integration details.

Use no ink splashes or ripples: disable them centrally with `NoSplash.splashFactory` and transparent `splashColor`, and audit local overrides. Build intentional custom components or deliberately themed semantic primitives; do not use unstyled stock Material for everything. Preserve pressed, focused, selected, and disabled feedback. Keep shadows restrained, shared, and purposeful for hierarchy, following Emil’s cohesion and attention to unseen details. See [theme and component appearance](references/theme-patterns.md).

## Visual inspection for visible UI work

Before building or judging visible UI, read [theme foundations](references/theme-patterns.md). Inspect the affected screen and its opened menus in light and dark themes: compare back and action controls together, field/card separation, shape, spacing, icon weight, type, and focus/error states. Use greyish off-white/off-black structural surfaces, never pure white/black or colored canvas defaults. A glass app bar does not make a stock child button or popup coherent. Check the trigger and opened overlay, not only the shell. Verify rendered control bounds against parent constraints, and scroll content beneath glass chrome while keeping initial and final controls reachable; a declared square size or transparent bar alone proves neither. Passing journey tests or analysis does not establish visual quality; report UX and visual evidence separately. If runtime inspection is unavailable, identify that limit rather than claiming a visual pass.

Preserve architecture and approved product intent, but do not treat unfinished seed styling as an approved design system. Fix observed visual defects within authorized implementation scope; keep reviews read-only unless fixes were requested. Apply this check proportionally to the affected UI, not to unrelated screens or pure non-UI bridge/data changes.

Use this workflow when alternatives or exploration are requested. Ordinary build/fix work goes directly into the user's app without an unsolicited prototype stage.

Read [prototype](references/prototype.md) for the variant/picker contract and [mobile UX](references/mobile-ux.md) for task acceptance. Match the prototype to the question: a component for local craft, a complete short journey for navigation or task completion. Preserve existing architecture and use realistic deterministic fixtures.

Default to three meaningfully different directions, each named by its actual design axis. Every direction must reach the same task outcome and meet the same access/craft bar. An isolated Dart entrypoint, dev-only route, or temporary mobile app keeps exploration separate from production; do not issue real side effects. Picker switching is immediate and does not steal input from forms.

For visible variants, read [components](references/component-patterns.md) before implementing. Load [design engineering](references/design-engineering.md), [motion](references/motion-patterns.md), matching [recipes](references/recipes.md), [feedback](references/feedback.md), [accessibility](references/mobile-accessibility.md), [platform behavior](references/native-ui.md), and [toolkit](references/toolkit.md) only as needed. [Case studies](references/case-studies.md) support product-specific personality.

Use [Marionette](references/marionette-testing.md) to exercise runnable variants when available. Return **# / Variant / Axis / When it wins / Cost**, entrypoint/running target, actual checks, and unverified limits. Let the user choose unless a direction was already selected. `riff` explores around a direction; `keep` integrates it using production conventions and removes the harness unless retention was requested.

## Evidence storage

Follow [evidence policy](references/evidence-policy.md): temporary captures, automatic session reports off, and concise results in chat. Save durable reports only when requested.
