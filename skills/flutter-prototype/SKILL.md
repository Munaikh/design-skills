---
name: flutter-prototype
description: Explore requested Flutter mobile design alternatives through working components or complete short journeys, compare tradeoffs, and integrate the selected direction.
metadata:
  author: Abdullah
  edition: Flutter mobile UX and design
---

# Flutter Prototype

Modified Flutter edition, based on Emil Kowalski’s design-skills. Preserve original MIT attribution.

For new or changed interactive UI, read [motion and microinteractions](references/motion-patterns.md) and [direct mobile UX](references/mobile-ux.md); they are required foundations, not optional polish.

## Core experience requirements

Reuse the codebase's design-system components. Redesign them only when asked to redesign the feature; fixes must preserve their established appearance and behavior. For new UI without that system, avoid raw Material appearance and build semantic product components. Read [theme and component policy](references/theme-patterns.md) before visible UI work.

iOS is the default design target; Android adapts the product identity while retaining its own back, input, accessibility, and navigation conventions. For new or redesigned iOS 26+ tab navigation, use a real native iOS tab bar whenever supported, not a Material or custom substitute unless instructed otherwise. Native Liquid Glass is iOS 26+ only. Older iOS uses custom components when support is requested. For simple new apps, state the iOS 26+ assumption and ask how older iOS should behave before choosing its fallback or changing deployment targets. Preserve an existing design system outside a requested redesign. Follow [native integration and fallbacks](references/toolkit.md).

Microinteractions are core: provide immediate animated response and continuity for relevant actions and state changes, with interruption and reduced-motion handling. Keep mobile copy short; let layout, controls, and feedback explain the experience. Consider swipe dismissal and card-to-page continuity where they fit the task, with visible alternatives and work preservation. These rules are scoped to affected UI, not permission to redesign unrelated features.

Follow [Dart engineering](references/dart-engineering.md) and the [preferred toolkit](references/toolkit.md). Use no ink splashes or ripples; keep accessible press, focus, selection, and disabled feedback. Shared motion and appearance details live in the references rather than a second component system.

## Visual inspection for visible UI work

Before building or judging visible UI, read [theme foundations](references/theme-patterns.md). Inspect the affected screen and its opened menus in light and dark themes: compare back and action controls together, field/card separation, shape, spacing, icon weight, type, and focus/error states. For a new visual system, use greyish off-white/off-black structural surfaces; preserve an existing design system outside a requested redesign. A glass app bar does not make a stock child button or popup coherent. Check the trigger and opened overlay, not only the shell. Verify rendered control bounds against parent constraints, and scroll content beneath glass chrome while keeping initial and final controls reachable; a declared square size or transparent bar alone proves neither. Passing journey tests or analysis does not establish visual quality; report UX and visual evidence separately. If runtime inspection is unavailable, identify that limit rather than claiming a visual pass.

Reuse the existing design system and preserve architecture. Redesign components only for a requested feature redesign; report other visual opportunities without silently applying them. Keep reviews read-only unless fixes were requested. Apply this check proportionally to the affected UI, not to unrelated screens or pure non-UI bridge/data changes.

Use this workflow when alternatives or exploration are requested. Ordinary build/fix work goes directly into the user's app without an unsolicited prototype stage.

Read [prototype](references/prototype.md) for the variant/picker contract and [mobile UX](references/mobile-ux.md) for task acceptance. Match the prototype to the question: a component for local craft, a complete short journey for navigation or task completion. Preserve existing architecture and use realistic deterministic fixtures.

Default to three meaningfully different directions, each named by its actual design axis. Every direction must reach the same task outcome and meet the same access/craft bar. An isolated Dart entrypoint, dev-only route, or temporary mobile app keeps exploration separate from production; do not issue real side effects. Picker switching is immediate and does not steal input from forms.

For visible variants, read [components](references/component-patterns.md) before implementing. Load [design engineering](references/design-engineering.md), matching [recipes](references/recipes.md), [feedback](references/feedback.md), [accessibility](references/mobile-accessibility.md), [platform behavior](references/native-ui.md), and [toolkit](references/toolkit.md) only as needed. [Case studies](references/case-studies.md) support product-specific personality.

Use [Marionette](references/marionette-testing.md) to exercise runnable variants when available. Return **# / Variant / Axis / When it wins / Cost**, entrypoint/running target, actual checks, and unverified limits. Let the user choose unless a direction was already selected. `riff` explores around a direction; `keep` integrates it using production conventions and removes the harness unless retention was requested.

## Evidence storage

Follow [evidence policy](references/evidence-policy.md): temporary captures, automatic session reports off, and concise results in chat. Save durable reports only when requested.
