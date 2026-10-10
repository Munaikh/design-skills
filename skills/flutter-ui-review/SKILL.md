---
name: flutter-ui-review
description: Review Flutter mobile UX, navigation, accessibility, visual design, and animation. Use for diff reviews, app audits, improvement opportunities, or requested hostile-data stress testing.
metadata:
  author: Abdullah AlMunaikh
  edition: Flutter mobile UX and design
---

# Flutter UI Review

Abdullah AlMunaikh’s modified Flutter edition, based on Emil Kowalski’s design-skills. Preserve original MIT attribution. UI review includes the user’s complete task, not just visual polish.

Follow the [Flutter/Dart coding conventions](references/dart-engineering.md): inspect project truth, preserve architecture and generation patterns, keep typed readable code and flat widget composition, and validate proportionally. For Flutter-side UI, use Flutter Animate by default for effects, or simple implicit widgets such as AnimatedContainer. Use Motor for physics and Heroine for shared elements; do not introduce stock Hero. Use Smooth Sheets for sheets and Motion for purposeful 3D tilt/parallax. Reserve low-level stock controllers, tween timelines, and simulations for very complex custom animation mixers that these tools cannot express. Follow the [preferred toolkit](references/toolkit.md) for integration details.

Use no ink splashes or ripples: disable them centrally with `NoSplash.splashFactory` and transparent `splashColor`, and audit local overrides. Build intentional custom components or deliberately themed semantic primitives; do not use unstyled stock Material for everything. Preserve pressed, focused, selected, and disabled feedback. Keep shadows restrained, shared, and purposeful for hierarchy, following Emil’s cohesion and attention to unseen details. See [theme and component appearance](references/theme-patterns.md).

## Select the requested mode

| Request | Mode and reference |
| --- | --- |
| Review a diff, screen, or journey | Inspect verified locations and task completion using [Mobile UX](references/mobile-ux.md), [accessibility](references/mobile-accessibility.md), and applicable [motion standards](references/standards.md) |
| Audit an app or create/execute improvement plans | [Audit](references/audit.md), [plan template](references/plan-template.md) |
| Find places that would benefit from motion | [Opportunities](references/opportunities.md); include rejected candidates and accept zero suggestions |
| Break/test a screen with difficult content | [Hostile data](references/hostile-data.md); use isolated fixtures only when a harness is requested |

Pin the requested diff/base/head or running interaction. Inspect callers, constraints, state, navigation, and lifecycle; vet findings at their actual location. Follow project architecture and [platform conventions](references/native-ui.md). Load [motion](references/motion-patterns.md), [recipes](references/recipes.md), or [toolkit](references/toolkit.md) only when relevant.

Reviews, audits, and proposals are read-only by default, including build/cache/install writes. Connecting to an already instrumented test app is appropriate when runtime inspection is in scope; do not add instrumentation or change app data for a source-only review. Use [Marionette](references/marionette-testing.md) for authorized runtime testing. A request to fix, execute, or build an isolated stress harness authorizes that scoped work without another checkpoint.

## Review the experience

Trace entry → task → completion, including back, tabs, dismissal, permission denial, offline/retry, and interrupted input where applicable. Prioritize blocked tasks, lost work, unreachable recovery, and accessibility defects above polish. Check phone and foldable continuity, large text, RTL, keyboard clearance, and both target-platform conventions. Separate measured failures, observed interaction problems, and code-inferred risks.

For a review return **Before / After / Why**, with verified locations and a clear proposed/implemented distinction, then an impact-ordered verdict and **Block** or **Approve**. No findings means no actionable issue was confirmed within the inspected scope; it does not certify untested device behavior. Audit, opportunity, and stress modes retain their reference-specific output contracts.
