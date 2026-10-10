# Flutter Mobile Design Skills

I’m Abdullah. I adapted [Emil Kowalski’s original skills](https://github.com/emilkowalski/skills) into a Flutter mobile UX, visual design, and animation skill set. I maintain this independent edition, preserving Emil’s design-engineering principles and MIT attribution while rebuilding the workflows for Flutter iOS and Android apps.

I start with helping people finish a task, understand what happened, recover from errors, and keep their work. Visual hierarchy, purposeful motion, accessible controls, and platform behavior support those goals. Mobile flows need their own design decisions.

## Four workflows

| Skill | When to use it |
| --- | --- |
| [flutter-mobile-design](skills/flutter-mobile-design/SKILL.md) | Build or improve mobile journeys, screens, components, typography, feedback, and animation |
| [flutter-ui-review](skills/flutter-ui-review/SKILL.md) | Review UX and UI, navigation, accessibility, motion, recovery, performance, or hostile data; audit and improve when requested |
| [flutter-prototype](skills/flutter-prototype/SKILL.md) | Compare requested design alternatives at the size of the question: a component or a short complete journey |
| [flutter-ios-swift](skills/flutter-ios-swift/SKILL.md) | Implement Swift plugins, channels, native views, and iOS capabilities used by Flutter |

I consolidated the suite into four independently installable workflows. All four support automatic discovery and explicit invocation. Each folder includes its own reference copies, invocation metadata, and MIT license. Agents read the small entrypoint first and load only relevant references; humans can use the same guides without installing a skill.

## A simple working process

My workflow is **understand → design the flow → build → verify**. For substantial work, I ask agents to describe the user goal, entry point, screen journey, recovery states, and completion criteria in the working response. Small repairs need less ceremony. The app’s router, backend, and state architecture stay intact while its shared theme and components improve within the requested scope.

I expect agents to improve navigation and interactions within the requested feature and explain material changes. Changes to business rules, capabilities, or scope need clarification. Ordinary implementation happens in the user’s app; prototypes are for requested exploration, and audits are for requested review.

I prioritize platform-appropriate navigation on iOS and Android with shared branding, and **phones first, then foldable phones**. Routes, selection, drafts, and scroll position should survive folding, unfolding, and resizing, with hinges and safe areas respected. Tablet checks remain separately identified. Accessibility, keyboard reachability, recovery, and reduced motion belong in the design from the start.

## Install and use

Copy any desired complete folder under `skills/` into your agent’s skill directory, such as `~/.agents/skills/`. Keep `references/`, `agents/`, and `LICENSE` together. Inspect existing installations before replacing them; editing this repository does not install anything globally.

```text
Use $flutter-mobile-design to improve this Flutter app’s save-and-return journey.
Use $flutter-mobile-design to fix the sheet’s interrupted drag and velocity handoff.
Use $flutter-ui-review to review this diff read-only for UX, accessibility, and motion.
Use $flutter-prototype to compare two ways to complete this booking flow.
Use $flutter-ios-swift to implement the iOS boundary for this Flutter plugin.
```

## Visual craft

I use **no ink splashes or ripples**. Set `NoSplash.splashFactory` and transparent `splashColor` in the shared light/dark themes, then check component overrides. Keep clear press, focus, selected, and disabled feedback.

I favor the product’s design system, useful custom components, and deliberately themed semantic framework controls. Unstyled stock Material should not define every screen. My shadow guidance adapts Emil’s cohesion and invisible-craft principles: restrained shared depth tokens for meaningful floating layers, tuned to their backdrop and light/dark appearance. Spacing, tone, or a border often supplies enough separation. See [theme and control guidance](references/theme-patterns.md).

I expect visible UI to be inspected in context, including opened menus and matching back/action controls in both themes. My structural surfaces use greyish off-white/off-black; seeded accents should not tint the canvas, cards, and fields. Shape, icon weight, typography, spacing, and state feedback must form a coherent system. I require separate UX and visual evidence, proportional to the affected screens; successful journey tests alone do not establish visual quality.

## Preferred libraries

I choose dependencies for a concrete need. My defaults are Flutter Animate for effect sequences, simple implicit widgets such as AnimatedContainer for local changes, Motor for spring motion, and Heroine for shared-element transitions. Low-level stock controllers are reserved for very complex custom animation mixers. I prefer Smooth Sheets for sheets and Motion for sensor-driven 3D effects, while preserving the project’s architecture and the general-flutter coding principles summarized in each skill. The [toolkit guide](references/toolkit.md) includes setup, platform and accessibility considerations, and SDK alternatives.

| Need | Preferred package |
| --- | --- |
| Apple-style app bars, tab bars, toolbars, and glass controls | [liquid_glass_widgets](https://pub.dev/packages/liquid_glass_widgets) |
| Interruptible springs and physics | [motor](https://pub.dev/packages/motor) |
| Effect sequences and deliberate entrances | [flutter_animate](https://pub.dev/packages/flutter_animate) |
| Shared-element continuity (use Heroine rather than the default Hero) | [heroine](https://pub.dev/packages/heroine) |
| Mobile sheets | [smooth_sheets](https://pub.dev/packages/smooth_sheets) |
| Sensor-driven 3D tilt and motion | [motion](https://pub.dev/packages/motion) |
| Custom typography, bundled for production | [google_fonts](https://pub.dev/packages/google_fonts) |
| An additional coherent icon family | [ionicons_plus](https://pub.dev/packages/ionicons_plus) |
| Charts | [fl_chart](https://pub.dev/packages/fl_chart) |
| Authored interactive animations | [rive](https://pub.dev/packages/rive) |
| Exported animation playback | [lottie](https://pub.dev/packages/lottie) |

Motion is published under GPL-3.0; the repository’s MIT license applies to this suite, not its dependencies. Verify dependency licenses for the consuming app. Liquid Glass provides Flutter-rendered Apple-style elements. Adapt Android controls to Android conventions, and check contrast, reduced-motion behavior, and rendering cost. Package versions and APIs must match the consuming project’s SDK.

## Motion and interaction coverage

Guides cover press feedback, menus, dialogs, sheets, swipes, list reflow, swaps, accordions, stagger, segmented indicators, scroll-driven headers, keyboard avoidance, routes, shared elements, haptics, vector animation, text and numbers, loading, and authored illustration. Frequency and purpose come before duration and curve. Motion must survive interruption, disposal, and reduced-motion changes; platform navigation and useful feedback remain intact. Use the [design and motion vocabulary](references/glossary.md) to describe an interaction precisely; naming an effect does not justify adding it.

## Testing and the reference app

I use [Marionette MCP](https://github.com/leancodepl/marionette_mcp) to inspect and exercise the actual running Flutter app. The [testing guide](references/marionette-testing.md) covers debug setup, selectors, recovery journeys, device configuration, reports, and the project-local CLI fallback for humans.

I keep [Places](validation/reference_app/README.md) as **one separate permanent reference app**, outside installed skill bundles. Its journey is to discover a place, open details, save a short note, find it in Saved, and edit it. Controlled local fixtures exercise loading, failure, retry, and empty states. I use it to validate the suite and demonstrate its guidance; agents do not create another mini app for every task.

[Package examples](validation/package_examples/README.md) isolate optional dependencies from the reference app. See [VALIDATION.md](VALIDATION.md) for reproducible checks, verified evidence, and checks requiring real devices.

## Maintain the suite

I maintain authoritative guides under `references/`. The [manifest](references/manifest.json) declares which guides each skill needs; ordinary local copies keep installations self-contained. Edit those guides and synchronize their packaged copies:

```bash
python3 scripts/sync_references.py --write
python3 scripts/sync_references.py --check
python3 scripts/validate_suite.py
python3 scripts/check_examples.py --flutter /path/to/project-pinned/flutter
```

I consolidated the old overlapping skills as follows:

| Previous responsibilities | Current workflow |
| --- | --- |
| Design engineering, Apple design, component/mobile animation, native UI, feedback, library selection, Dart engineering, vocabulary | flutter-mobile-design and its focused references |
| Motion review, audits, opportunities, hostile-data checks | flutter-ui-review |
| Design exploration and picker/replay | flutter-prototype |
| Flutter’s iOS integration boundary | flutter-ios-swift |

## Attribution

Original work © 2026 **Emil Kowalski**. His principles include purposeful motion, restraint, invisible craft, reviews, prototypes, and realistic stress testing. I adapted and consolidated them into mobile UX workflows, preferred Flutter tooling, accessibility, lifecycle and recovery guidance, and executable validation.

I maintain this modified edition independently under the [MIT license](LICENSE), preserved in each skill with the original author’s credit and the modification copyright notice.
