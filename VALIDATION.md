# Validating Abdullah AlMunaikh’s Flutter mobile edition

This edition has four independently installable skills. Authoritative reference guides live under `references/`; the manifest declares ordinary packaged copies. Structural checks prove consistency, not design superiority. Runtime smoke tests prove only the observed journeys and conditions.

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

## Platform limits

Android runtime testing is not part of this iOS-focused run. Hardware fold posture, actual keyboard movement, interactive/predictive back feel, haptic delivery, VoiceOver/TalkBack traversal, native permission surfaces, and sustained rendering performance require separate evidence from supported devices. The Swift bridge example needs the consuming Flutter iOS module and native tests; the reference app’s iOS host build does not validate every documented bridge.

Production fonts and Rive/Lottie artwork are product inputs. API analysis, semantic chart summaries, and reduced-motion fallbacks do not prove authored asset playback, offline font rendering, sensor-driven Motion behavior, or shared-element flights in every navigator. Google Fonts and Smooth Sheets compatibility releases are pinned in the fixture because newer releases use different UI types; verify the target app rather than floating versions.

For performance, capture UI/raster timings in profile mode and check feel in release mode on supported physical devices. Record device/refresh rate, workload, missed frames and percentiles. Read-only reviews do not authorize builds or cache writes.

## Verified result

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
