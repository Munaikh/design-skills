# Validating the Flutter mobile edition

This edition has four independently installable skills. Authoritative reference guides live under `references/`; the manifest declares ordinary packaged copies. Structural checks prove consistency, not design superiority. Runtime smoke tests prove only the observed journeys and conditions.

## Latest verified state

The latest completed checks on 10 October 2026 are:

- All four skill-creator validations, the suite validator, and canonical/packaged reference checks passed.
- The SDK fixture analyzed **12 unique Dart examples** cleanly and passed **17 tests**.
- The reference app analyzed cleanly and passed **12 tests**, including rendered glass geometry, full scroll viewport, content-owned clearance, and synthetic keyboard insets.
- The unchanged preferred-library fixture's latest completed run analyzed cleanly and passed **4 tests**.
- iOS Marionette checks on iPhone 18 Pro/iOS 27 verified both themes, 48×48 back/menu controls, the 402×874 scroll viewport, fixed chrome after scrolling, and a final action reachable above the tabs. Demo data and media overrides were restored.

Actual software-keyboard movement, Android runtime behavior, physical fold posture, assistive traversal, composited contrast, and sustained performance remain unverified. Local screenshots and logs are intentionally ignored under `validation/reports/`; they are not shipped evidence links. The phase records below explain which checks were run at each stage.

## Reproduce the checks

Use the project-pinned Flutter/Dart SDK. The fixtures were validated with Flutter 3.47.7 and Dart 3.13.5 on 10 October 2026.

```bash
python3 scripts/sync_references.py --check
python3 scripts/validate_suite.py
python3 scripts/check_examples.py --flutter /path/to/project-pinned/flutter
cd validation/reference_app
flutter pub get
flutter analyze
flutter test
flutter run -d <ios-simulator-id>
```

The standard-library suite validator checks the exact catalog, frontmatter, automatic invocation metadata, author/license credit, standalone local links, fences, source/copy consistency, and prohibited authored implementation files/content. Migration prose may discuss web interfaces; it cannot carry over web implementation guidance. Generated build/cache directories and runtime reports are excluded. Third-party transitive dependency names in mobile lockfiles are not authored implementation content.

The example checker extracts unique complete Dart blocks from canonical guides into a temporary SDK-only package. It resolves cached dependencies offline, analyzes, and runs the [recipe behavior tests](validation/recipes_test.dart), retaining its source manifest in the temporary directory. Package-dependent examples live in a separate [toolkit fixture](validation/package_examples/README.md): run `flutter pub get`, `flutter analyze`, and `flutter test` there. Do not add its full dependency list to a product.

The skill-creator `quick_validate.py` additionally checks all four entrypoints; it needs PyYAML. Use a suitable Python environment rather than changing global Python installations.

## Coverage and evidence

The SDK recipes cover bounded signed projection, resistance, threshold hysteresis, stale async results/disposal, hidden-state interaction/semantics, reversal, reduced motion, capped entrances without replay, spring position/velocity continuity, decorative semantics, accessible explicit removal, canceled swipe, and theme interpolation. Low-level controller examples are advanced mechanics references; normal app work follows the preferred library/implicit-widget defaults.

The reference app exercises discovery, saving, returning and editing a note; failed load retry; failed save retaining a draft; tab and search retention; width changes and reading-position restoration; an occluding hinge; large text, RTL and keyboard insets; system back; and stale/disposed async work. These widget fixtures simulate relevant conditions. They do not reproduce a physical foldable or certify assistive traversal.

Marionette tests run against the debug app on an iOS simulator. Use its current WebSocket VM service URI:

```bash
python3 scripts/test_reference_journey.py --uri <vm-service-uri> \
  --device "iPhone simulator" --output /tmp/places-journey
```

The runner reads controls before acting, verifies content postconditions, captures screenshots and runtime logs, and restores fixtures/device overrides. It uses the project-local Marionette CLI when the MCP connection is unavailable. Each CLI invocation has its own server session; the runner preserves step logs and writes one aggregate report. Reports are local artifacts under `validation/reports/` or a supplied output directory, outside installed bundles.

## Revision and blind-trial method

For a skills-only revision, change skill entrypoints, canonical references, packaged copies, and isolated documentation-example checks. Keep the reference app unchanged in that phase; compare its tracked files against the checkpoint before reporting completion. Subsequent authorized implementation trials may change the app.

Validate the neutral theme example in both brightness modes: structural surface roles and component fills remain grayscale without pure white/black, ordinary foreground and muted text meet 4.5:1 on their intended surfaces, and the field focus color meets 3:1. These tests cover declared colors, not translucent glass, every component state, or visual composition.

For an independent blind trial, use a fresh agent with no conversation history, memory lookup, old reports, or defect hints. Give it the current skill, reference app location, and normal implementation task. Evaluate its actual diff and iOS Simulator evidence through Marionette: separate UX outcomes from visual quality, capture open overlays and both themes, and identify untested states. Keep any known-defect evaluator checklist out of the agent brief. Record subsequent evaluator feedback separately; work after that feedback is an informed iteration rather than a fresh blind result.

## Platform limits

Android runtime testing is not part of this iOS-focused run. Hardware fold posture, actual keyboard movement, interactive/predictive back feel, haptic delivery, VoiceOver/TalkBack traversal, native permission surfaces, and sustained rendering performance require separate evidence from supported devices. The Swift bridge example needs the consuming Flutter iOS module and native tests; the reference app’s iOS host build does not validate every documented bridge.

Production fonts and Rive/Lottie artwork are product inputs. API analysis, semantic chart summaries, and reduced-motion fallbacks do not prove authored asset playback, offline font rendering, sensor-driven Motion behavior, or shared-element flights in every navigator. Google Fonts and Smooth Sheets compatibility releases are pinned in the fixture because newer releases use different UI types; verify the target app rather than floating versions.

For performance, capture UI/raster timings in profile mode and check feel in release mode on supported physical devices. Record device/refresh rate, workload, missed frames and percentiles. Read-only reviews do not authorize builds or cache writes.

## Earlier skills-only verification

On 10 October 2026, after the visual-guidance revision, all four skill-creator checks and suite/source-copy checks passed. The isolated SDK fixture analyzed **12 unique Dart examples** cleanly and passed **17 tests**, including the new light/dark neutral-surface and actual text/focus contrast checks. The reference app and package-example app were unchanged from local checkpoint `3b619fa`; no app runtime test or screenshot was produced during this revision. Earlier app results below describe their historical runs, not acceptance of the revised visual guidance.

A fresh read-only agent received only the mobile-design skill, app location, and evaluation scope, with no history, memory lookup, prior reports, or defect hints. It independently identified the seeded/tinted structural surfaces and mixed stock controls inside the iOS glass app bar. It also distinguished source-confirmed issues from unmeasured contrast, uninspected runtime appearance, and inferred recovery/adaptive risks. At that stage, this supported instruction discoverability; implementation quality still required the later app changes and Marionette screenshot checks.

## Glass geometry and viewport followup

The later app followup corrected the 48×44 rendered glass controls by sharing a 48-point toolbar/control extent. It enabled full-size scrolling behind glass chrome and moved clearance into scroll content, with keyboard resizing owned once. All 12 reference-app tests and final analysis passed. Marionette measured 48×48 back/menu controls and a 402×874 viewport in both themes, with the last action fully above the tab bar. The retained local report is `validation/reports/glass-geometry-followup-20261010/REPORT.md`, with screenshots, measurements, restoration, and capture limits. Actual software-keyboard inspection was unavailable after Device Hub computer use was not approved; the synthetic 300-point keyboard-inset regression passed.

The skill correction makes parent constraints, actual rendered geometry, scroll-behind behavior, and content-owned clearance explicit across all four entrypoints and relevant references. Installed package comments about automatic spacers are checked against implementation rather than repeated as a guarantee. Suite/source-copy and all four skill-creator checks passed after this guidance change.

## Initial validation and intermediate checks

On 10 October 2026:

- Four skill entrypoints passed skill-creator validation; the exact catalog, standalone references, automatic metadata, attribution, license, fence and content checks passed.
- The SDK fixture analyzed **12 unique Dart blocks** and passed **16 behavioral tests**.
- The reference app analyzed cleanly and passed **7 journey/state/adaptive tests**. Its iOS host built and ran on the **iPhone 17 Pro simulator, iOS 27**.
- The preferred-library fixture analyzed cleanly and passed **4 widget tests**, including spring interruption, reduced-motion alternatives, a semantic chart summary, and sheet close/reopen/save draft retention.
- The final iOS Marionette report passed with **118 CLI commands, 118 preserved server step-log lines, and 9 screenshots**. It verified discovery, note save/edit/back, failed load retry, failed save retaining the draft/retry, empty state, and a 2× text/bold/dark-mode journey. Runtime logs contained no new reported Flutter exception or overflow. Overrides and fixtures were restored. Final local evidence: `validation/reports/ios-journey-fixed-20261010/report.md`.

The later no-splash/custom-control theme update was hot-reloaded successfully and all three fixtures were reanalyzed: 16 SDK recipe tests, 7 reference journey tests, and 4 package tests passed again. A separate brief Marionette check on the **iPhone 18 Pro simulator, iOS 27** passed Discover → details → Back with **9 preserved server steps and 2 screenshots**, without changing notes, fixtures, or device settings. Captured logs contained no exception or overflow. Evidence: `validation/reports/no-splash-smoke-20261010/report.md`. This check confirms those captured states; it does not establish transient ripple behavior across every third-party component or replace the earlier full-journey report.

The final field-theme revision shares one 20-point corner token across fields, cards, and buttons, with filled resting fields and explicit focus/error outlines. Its canonical Dart example and reference app were reanalyzed cleanly and the 16 recipe plus 7 journey tests passed again. The **iPhone 18 Pro/iOS 27** field check passed **17 Marionette steps and 5 screenshots**, inspecting resting Search, resting note, and focused note before restoring Discover without modifying input. Captured logs contained no Flutter exception or overflow. Evidence: `validation/reports/field-theme-smoke-20261010/report.md`; its `05-search-after-submit.png` shows the actual resting Search state. Screenshots do not certify measured contrast, transient ripple behavior, or physical keyboard movement. The rewritten glossary and all four packaged policy guides passed final structure/content/link and source-copy checks.

| Package | Resolved fixture version |
| --- | --- |
| liquid_glass_widgets | 1.11.1 |
| marionette_flutter / marionette_cli | 0.7.0 |
| motor | 1.1.0 |
| flutter_animate | 4.5.2 |
| heroine | 0.7.2 |
| smooth_sheets | 1.2.1 (SDK UI compatibility pin) |
| motion | 2.0.2 |
| google_fonts | 8.2.1 (SDK UI compatibility pin) |
| ionicons_plus | 0.2.5 |
| fl_chart | 1.2.0 |
| rive | 0.14.11 |
| lottie | 3.6.1 |

These checks do not establish a universal design ranking or compatibility with every Flutter release. Initial test/runner failures were corrected and rerun; the final result above refers to the corrected artifacts.
