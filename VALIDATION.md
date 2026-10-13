# Validation

The suite contains five independently installable skills. Start with flutter-research-design for research-led design/build work; the other workflows have focused roles described in the README. Structural checks verify packaging, not design quality.

## Reproduce packaging checks

```bash
python3 scripts/sync_references.py --check
python3 scripts/validate_suite.py
python3 scripts/test_skill_packaging.py
python3 scripts/link_skills.py --check
```

Run the skill-creator `quick_validate.py` for each skill using a Python environment with PyYAML. The packaging tests use isolated temporary copies to check portability, source/copy drift and repair, upstream license retention, accidental evidence directories, required craft-guide reachability, generated-app isolation, and non-destructive/idempotent installation. The catalog is manifest-driven. Bundles retain their complete local guides and relevant license notices.

For changed Dart examples, use `python3 scripts/check_examples.py --flutter /path/to/project-pinned/flutter`. Optional dependency examples remain in `validation/package_examples`; run their own analyze/tests when changing those examples. The optional examples are separate from manually generated reference apps.

## Manual app trials

Use the short [to-do app prompt](validation/reference-app-prompt.md) with any agent you prefer. Choose the skill separately and ask the agent to put its output in `validation/reference_app/`. This repository does not bundle a reference app or prescribe a model, agent dispatch, or trial history.

Run the generated app's own analysis and tests, then inspect the actual experience. Keep screenshots, recordings, and logs outside the repository. Previous app results do not validate a newly generated app. Do not launch or regenerate a trial automatically as part of documentation/packaging work.

### App acceptance

- Exercise onboarding, task CRUD, navigation, local persistence, and recovery. The journey should be understandable without the agent narrating it.
- Observe press/release/cancel, completion/reopening, task insertion/removal/reflow, and onboarding transitions at normal speed. Theme fades, progress dots, and default route transitions alone do not pass the microinteraction requirement.
- Check rapid toggling, interrupted motion, reduced motion, stable focus, and semantic state. Controls remain usable while effects run. Tests should inspect meaningful intermediate states and cancellation, not merely count animation widgets.
- Inspect product components and opened menus/editors/dialogs in both themes. New UI should not expose raw Material appearance; existing design-system components must remain intact outside an authorized redesign.
- Remove redundant explanatory copy and empty-space filler while retaining clear actions, error recovery, consequences, and accessible labels. Check real content and large text.
- On iOS 26+, verify the actual native tab bar and its accessibility, per-tab state, and inset ownership. Native Liquid Glass must never run below iOS 26 or on Android. On approved older-iOS targets, verify custom components. Report unsupported/unresolved targets explicitly.
- Where swipe dismissal or card-to-page continuity is appropriate, verify forward/reverse transitions, cancellation, source scroll/identity, unsaved work, and an absent/offscreen source. Keep visible alternatives; Android system back and scroll gestures must remain functional.

Report UX, visual, motion, and platform evidence separately. A static screenshot is insufficient motion evidence; source checks cannot establish native feel.

### Routing and policy scenarios

Use these as a manual instruction review or a separately requested agent trial. Structural validators do not prove that agents follow these policies.

| Request or context | Expected behavior |
| --- | --- |
| Build a simple new app from an idea | `flutter-research-design`; state iOS 26+ assumption, ask about older iOS, research and implement meaningful interactions; keep the older-OS choice pending until answered |
| Fix a field overflow in an existing design system | `flutter-mobile-design`; reuse the field component, repair layout, preserve visual identity and existing supported OS range |
| Review a static-feeling app | `flutter-ui-review`; read-only findings about primary-task response, continuity, visual identity, and copy; no unsolicited implementation |
| Compare two task-detail flows | `flutter-prototype`; runnable alternatives with the same outcome, accessible motion, and clear tradeoffs |
| Add a Flutter platform channel | `flutter-ios-swift`; preserve typed contracts, lifecycle, and state; pure data work does not trigger UI redesign |
| Redesign a tabbed feature on iOS 26+ | Native iOS tab bar when supported; no convenience substitution with Material/custom tabs; verify OS and package capability |
| Support iOS below 26 after the user's choice | Custom product components, no native Liquid Glass or automatic stock Cupertino fallback; existing design-system constraints still apply |
| User requests an iOS 26+ minimum | Apply that explicit choice; do not ask the same support question again or invent older-OS support |

## Evidence boundaries

Keep routine results in chat and this file concise. Automatic Marionette session reports are disabled by default; opt in only for a specific investigation. Runtime evidence is temporary and is not shipped with the skills.

Widget tests can exercise state, recovery and synthetic layout configurations. They do not establish native control behavior, assistive traversal, physical fold posture, actual keyboard animation, haptics or sustained device performance. Marionette covers Flutter content; native UIKit controls need native automation and full-device captures. Debug simulator recordings do not establish profile/release performance. Report each unavailable check explicitly.
