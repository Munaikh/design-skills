---
name: flutter-research-design
description: Research, design, and build or improve Flutter mobile apps and journeys using Appllama references. Start here when visual direction or interaction design must be decided; supports research-only and one-shot app requests.
metadata:
  author: Abdullah
  edition: Research-led Flutter mobile design
---

# Flutter Research Design

The default starting point for research-led Flutter app design. Combines Appllama research and app-design principles with this suite's Flutter edition of Emil Kowalski's design guidance. Preserve both MIT notices in LICENSE and LICENSE-Appllama.

## Scope and routing

Use this skill end to end; users do not need to invoke multiple design skills. Research-only requests end with findings. Design-only requests end with the requested editable artifact. Implementation requests continue through building and verification. Small code repairs with an established design belong to flutter-mobile-design; explicit reviews to flutter-ui-review; requested alternatives to flutter-prototype; Swift integration to flutter-ios-swift. These are routing descriptions, not dependencies to load together.

User intent, approved product design, and project constraints take precedence. This skill's Flutter conventions resolve conflicts with upstream platform defaults. Do not load the original Appllama design skill at runtime: its principles are adapted here and its platform-specific implementation guidance is not applicable.

## Research → decide → build → verify

1. Inspect the actual project, SDK, theme, router, state ownership and user journey. Define the design question, primary task, recovery and completion criteria briefly.
2. Read [Appllama research](references/appllama-research.md). Check live tools/credits, start from relevant user curation, inspect selected images and complete relevant flows. Scale research to the question. Preserve source IDs and separate observation from inference.
3. Read [design synthesis and quality](references/research-design-quality.md), [theme](references/theme-patterns.md) and [components](references/component-patterns.md). Explain the adopted patterns and a coherent product-specific direction. Respect requested design-first artifacts; an authorized one-shot app proceeds without an extra approval gate.
4. Implement within the requested scope using the existing architecture and shared primitives. Load only the references needed below.
5. Run appropriate analysis/tests and inspect the actual runtime. Check UX, visual quality, microinteractions, and concise copy separately, including recovery, gestures, and open overlays. Default route animations or theme changes alone do not demonstrate a lively primary journey. Follow [Marionette testing](references/marionette-testing.md); report unperformed checks honestly.

Read [evidence policy](references/evidence-policy.md) before collecting media. Default to temporary evidence and a concise result in chat, not research folders, repeated reports or session dumps in the repository. Save a prompt/report only when requested. A missing research connection does not justify fabricated evidence or abandoning unaffected work.

For new or changed interactive UI, read [motion and microinteractions](references/motion-patterns.md) and [direct mobile UX](references/mobile-ux.md); they are required foundations, not optional polish.

## Core experience requirements

Reuse the codebase's design-system components. Redesign them only when asked to redesign the feature; fixes must preserve their established appearance and behavior. For new UI without that system, avoid raw Material appearance and build semantic product components. Read [theme and component policy](references/theme-patterns.md) before visible UI work.

iOS is the default design target; Android adapts the product identity while retaining its own back, input, accessibility, and navigation conventions. For new or redesigned iOS 26+ tab navigation, use a real native iOS tab bar whenever supported, not a Material or custom substitute unless instructed otherwise. Native Liquid Glass is iOS 26+ only. Older iOS uses custom components when support is requested. For simple new apps, state the iOS 26+ assumption and ask how older iOS should behave before choosing its fallback or changing deployment targets. Preserve an existing design system outside a requested redesign. Follow [native integration and fallbacks](references/toolkit.md).

Microinteractions are core: provide immediate animated response and continuity for relevant actions and state changes, with interruption and reduced-motion handling. Keep mobile copy short; let layout, controls, and feedback explain the experience. Consider swipe dismissal and card-to-page continuity where they fit the task, with visible alternatives and work preservation. These rules are scoped to affected UI, not permission to redesign unrelated features.

Follow [Dart engineering](references/dart-engineering.md) and the [preferred toolkit](references/toolkit.md). Use no ink splashes or ripples; keep accessible press, focus, selection, and disabled feedback. Shared motion and appearance details live in the references rather than a second component system.

## Focused references

| Need | Read |
| --- | --- |
| Navigation, recovery, phones and foldables | [Mobile UX](references/mobile-ux.md) |
| Focus, semantics, text scale, RTL | [Accessibility](references/mobile-accessibility.md), [native behavior](references/native-ui.md) |
| Motion and gestures | [Motion](references/motion-patterns.md), relevant [recipes](references/recipes.md) |
| Feedback and async recovery | [Feedback](references/feedback.md) |
| Personality and restraint | [Design engineering](references/design-engineering.md) |

Deliver source changes or the requested artifact, a compact research/design rationale, checks actually run, and precise limits. Never imply commercial metrics prove a design decision or simulator evidence proves physical-device behavior.
