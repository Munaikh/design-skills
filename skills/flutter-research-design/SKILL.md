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
5. Run appropriate analysis/tests and inspect the actual runtime. Check UX and visual quality separately, including recovery and open overlays. Follow [Marionette testing](references/marionette-testing.md); report unperformed checks honestly.

Read [evidence policy](references/evidence-policy.md) before collecting media. Default to temporary evidence and a concise result in chat, not research folders, repeated reports or session dumps in the repository. Save a prompt/report only when requested. A missing research connection does not justify fabricated evidence or abandoning unaffected work.

## Flutter implementation policy

Follow the [Flutter/Dart coding conventions](references/dart-engineering.md): inspect project truth, preserve architecture and generation patterns, keep typed readable code and flat widget composition, and validate proportionally. For Flutter-side UI, use Flutter Animate by default for effects, or simple implicit widgets such as AnimatedContainer. Use Motor for physics and Heroine for shared elements; do not introduce stock Hero. Use Smooth Sheets for sheets and Motion for purposeful 3D tilt/parallax. Reserve low-level stock controllers, tween timelines, and simulations for very complex custom animation mixers that these tools cannot express. Follow the [preferred toolkit](references/toolkit.md) for integration details.

Use no ink splashes or ripples: disable them centrally with `NoSplash.splashFactory` and transparent `splashColor`, and audit local overrides. Build intentional custom components or deliberately themed semantic primitives; do not use unstyled stock Material for everything. Preserve pressed, focused, selected, and disabled feedback. Keep shadows restrained, shared, and purposeful for hierarchy, following Emil’s cohesion and attention to unseen details. See [theme and component appearance](references/theme-patterns.md).

## Focused references

| Need | Read |
| --- | --- |
| Navigation, recovery, phones and foldables | [Mobile UX](references/mobile-ux.md) |
| Focus, semantics, text scale, RTL | [Accessibility](references/mobile-accessibility.md), [native behavior](references/native-ui.md) |
| Motion and gestures | [Motion](references/motion-patterns.md), relevant [recipes](references/recipes.md) |
| Feedback and async recovery | [Feedback](references/feedback.md) |
| Personality and restraint | [Design engineering](references/design-engineering.md) |

Deliver source changes or the requested artifact, a compact research/design rationale, checks actually run, and precise limits. Never imply commercial metrics prove a design decision or simulator evidence proves physical-device behavior.
