---
name: flutter-mobile-design
description: Implement or repair Flutter UI when the visual direction and journey are already established. Use for focused layout, component, and motion changes; use flutter-research-design when design decisions or reference research are needed.
metadata:
  author: Abdullah
  edition: Flutter mobile UX and design
---

# Flutter Mobile Design

For a new app or an open-ended redesign, start with flutter-research-design. This skill handles implementation of an established direction.

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

## Understand → design the flow → build → verify

Start with the user's task and the actual app: project instructions, SDK pin, dependencies, theme, controls, router, state ownership, and existing tests. For substantial work, give a short UX brief: goal, entry point, primary journey, recovery states, and observable completion. Keep it in the working response; separate documents are for complex flows or requested handoffs. Small repairs do not need a full journey map.

Design for mobile use, not a scaled-down web interface. Preserve product intent and familiar platform behavior. Improve navigation and interaction within the requested feature; explain material changes. Ask before changing business rules, removing capabilities, or expanding the assignment. Follow existing backend and state-management architecture.

Build concrete work within the authorized scope. Ordinary work goes directly into the user's app; do not create a separate demo or run an unsolicited prototype/audit stage. For visible UI work, also read [component patterns](references/component-patterns.md); load other references for the task:

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
- Implement purposeful microinteractions and continuity in the affected journey. Frequency limits amplitude and duration, not the need for feedback. Keep actions immediate, preserve platform navigation, and retarget gestures from current position and velocity. Justify static treatment per interaction; respect reduced motion.
- Own tickers, async operations, subscriptions, focus, and overlays. Handle interruption, disposal, reduced motion, large text, RTL, keyboard, and hidden-state semantics.
- Measure UI and raster work when performance matters. Glass, blur, opacity, clips, and transforms still need evidence.

Deliver the implementation, brief flow/design rationale, checks actually run, and precise remaining limits. Format/analyze with the project SDK and run relevant behavioral tests. Use Marionette on the actual running app when available; report unavailable runtime checks honestly. Device feel, assistive navigation, haptics, and sustained performance require their own evidence.

## Evidence storage

Follow [evidence policy](references/evidence-policy.md): temporary captures, automatic session reports off, and concise results in chat. Save durable reports only when requested.
