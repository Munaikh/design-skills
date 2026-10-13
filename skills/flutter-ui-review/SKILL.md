---
name: flutter-ui-review
description: Review Flutter mobile UX, navigation, accessibility, visual design, and animation. Use for diff reviews, app audits, improvement opportunities, or requested hostile-data stress testing.
metadata:
  author: Abdullah
  edition: Flutter mobile UX and design
---

# Flutter UI Review

Modified Flutter edition, based on Emil Kowalski’s design-skills. Preserve original MIT attribution. UI review includes the user’s complete task, not just visual polish.

For new or changed interactive UI, read [motion and microinteractions](references/motion-patterns.md) and [direct mobile UX](references/mobile-ux.md); they are required foundations, not optional polish.

## Core experience requirements

Reuse the codebase's design-system components. Redesign them only when asked to redesign the feature; fixes must preserve their established appearance and behavior. For new UI without that system, avoid raw Material appearance and build semantic product components. Read [theme and component policy](references/theme-patterns.md) before visible UI work.

iOS is the default design target; Android adapts the product identity while retaining its own back, input, accessibility, and navigation conventions. For new or redesigned iOS 26+ tab navigation, use a real native iOS tab bar whenever supported, not a Material or custom substitute unless instructed otherwise. Native Liquid Glass is iOS 26+ only. Older iOS uses custom components when support is requested. For simple new apps, state the iOS 26+ assumption and ask how older iOS should behave before choosing its fallback or changing deployment targets. Preserve an existing design system outside a requested redesign. Follow [native integration and fallbacks](references/toolkit.md).

Microinteractions are core: provide immediate animated response and continuity for relevant actions and state changes, with interruption and reduced-motion handling. Keep mobile copy short; let layout, controls, and feedback explain the experience. Consider swipe dismissal and card-to-page continuity where they fit the task, with visible alternatives and work preservation. These rules are scoped to affected UI, not permission to redesign unrelated features.

Follow [Dart engineering](references/dart-engineering.md) and the [preferred toolkit](references/toolkit.md). Use no ink splashes or ripples; keep accessible press, focus, selection, and disabled feedback. Shared motion and appearance details live in the references rather than a second component system.

## Visual inspection for visible UI work

Before building or judging visible UI, read [theme foundations](references/theme-patterns.md). Inspect the affected screen and its opened menus in light and dark themes: compare back and action controls together, field/card separation, shape, spacing, icon weight, type, and focus/error states. For a new visual system, use greyish off-white/off-black structural surfaces; preserve an existing design system outside a requested redesign. A glass app bar does not make a stock child button or popup coherent. Check the trigger and opened overlay, not only the shell. Verify rendered control bounds against parent constraints, and scroll content beneath glass chrome while keeping initial and final controls reachable; a declared square size or transparent bar alone proves neither. Passing journey tests or analysis does not establish visual quality; report UX and visual evidence separately. If runtime inspection is unavailable, identify that limit rather than claiming a visual pass.

Reuse the existing design system and preserve architecture. Redesign components only for a requested feature redesign; report other visual opportunities without silently applying them. Keep reviews read-only unless fixes were requested. Apply this check proportionally to the affected UI, not to unrelated screens or pure non-UI bridge/data changes.

## Select the requested mode

| Request | Mode and reference |
| --- | --- |
| Review a diff, screen, or journey | Inspect verified locations and task completion using [Mobile UX](references/mobile-ux.md), [accessibility](references/mobile-accessibility.md), and applicable [UX, visual, and motion standards](references/standards.md) |
| Audit an app or create/execute improvement plans | [Audit](references/audit.md), [plan template](references/plan-template.md) |
| Find places that would benefit from motion | [Opportunities](references/opportunities.md); include rejected candidates and accept zero suggestions |
| Break/test a screen with difficult content | [Hostile data](references/hostile-data.md); use isolated fixtures only when a harness is requested |

Pin the requested diff/base/head or running interaction. Inspect callers, constraints, state, navigation, and lifecycle; vet findings at their actual location. Follow project architecture and [platform conventions](references/native-ui.md). Load [motion](references/motion-patterns.md), [recipes](references/recipes.md), or [toolkit](references/toolkit.md) only when relevant.

Reviews, audits, and proposals are read-only by default, including build/cache/install writes. Connecting to an already instrumented test app is appropriate when runtime inspection is in scope; do not add instrumentation or change app data for a source-only review. Use [Marionette](references/marionette-testing.md) for authorized runtime testing. A request to fix, execute, or build an isolated stress harness authorizes that scoped work without another checkpoint.

## Review the experience

Evaluate primary-task microinteractions, concise copy, component-system reuse, and the iOS 26+ native-tab-bar/older-iOS custom policy. Trace entry → task → completion, including back, tabs, dismissal, permission denial, offline/retry, and interrupted input where applicable. Prioritize blocked tasks, lost work, unreachable recovery, and accessibility defects above polish. Check phone and foldable continuity, large text, RTL, keyboard clearance, and both target-platform conventions. Separate measured failures, observed interaction problems, and code-inferred risks.

For a review return **Before / After / Why**, with verified locations and a clear proposed/implemented distinction, then an impact-ordered verdict and **Block** or **Approve**. No findings means no actionable issue was confirmed within the inspected scope; it does not certify untested device behavior. Audit, opportunity, and stress modes retain their reference-specific output contracts.

## Evidence storage

Follow [evidence policy](references/evidence-policy.md): temporary captures, automatic session reports off, and concise results in chat. Save durable reports only when requested.
