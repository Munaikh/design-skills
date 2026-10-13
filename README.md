# Flutter Mobile Design Skills

Flutter skills for direct, lively mobile experiences. iOS leads the design; Android adapts the product identity while respecting its own navigation, input, and accessibility conventions. Maintained by Abdullah, adapted from Emil Kowalski and Appllama.

## Start here

Use **[flutter-research-design](skills/flutter-research-design/SKILL.md)** for a new app, a redesign, or an experience whose direction needs deciding. It researches with Appllama, chooses a direction, builds, and verifies. Invoke one skill; you do not need to load the original Appllama skills or stack several workflows.

## Choose a skill

| What you need | Use | What it delivers |
| --- | --- | --- |
| **Start:** research, new app, or redesign | [flutter-research-design](skills/flutter-research-design/SKILL.md) | Research-informed direction and implementation; research/design-only when requested |
| **Implement:** an established design or focused repair | [flutter-mobile-design](skills/flutter-mobile-design/SKILL.md) | Production changes using the app's existing design system |
| **Review:** an app, screen, journey, or diff | [flutter-ui-review](skills/flutter-ui-review/SKILL.md) | Evidence and prioritized findings; read-only unless fixes are requested |
| **Compare:** explicitly requested design alternatives | [flutter-prototype](skills/flutter-prototype/SKILL.md) | Runnable alternatives and their tradeoffs |
| **Integrate:** Swift at a Flutter iOS boundary | [flutter-ios-swift](skills/flutter-ios-swift/SKILL.md) | Native integration, lifecycle, and bridge changes |

A broken layout does not require research. A new app does not require a separate prototype. An audit does not authorize a redesign. Swift integration is a specialist workflow, not the default way to build Flutter screens.

## Copy a starting prompt

```text
Use $flutter-research-design to build this Flutter app: [idea].
Use $flutter-mobile-design to fix [issue] using our existing components.
Use $flutter-ui-review to review [screen or diff] for UX, visual craft, copy, and microinteractions.
Use $flutter-prototype to compare two approaches to [journey].
Use $flutter-ios-swift to implement [native capability] in this Flutter app.
```

All five support automatic discovery and explicit invocation. Each installs independently with its required references. Live Appllama research needs the Appllama MCP connection; missing access must be reported, never replaced with invented research.

## What every experience should get right

- **Reuse the design system.** Use its components and behavior. Redesign them only when asked to redesign the feature. New UI without an established system should use custom semantic product components; raw Material appearance is usually suboptimal, especially for an iOS App Store product. Changing only color and radius is not a complete component design.
- **Make it alive.** Microinteractions belong in the primary journey: press/release, selection, completion, content changes, and useful transitions. Keep actions immediate and animation brief, interruptible, and accessible. A theme fade or stock route animation alone is insufficient. Preserve reduced motion and an already adequate component system.
- **Use fewer words.** Clear hierarchy, familiar controls, concise labels, and feedback should explain the app. Do not fill empty space with instructions. Keep essential recovery, consequences, consent, and accessible names.
- **Design for touch.** Consider swipe dismissal, contextual row actions, and cards that expand smoothly into detail pages. Preserve drafts, source position, cancellation, system back, and a visible alternative to gestures.
- **Verify the experience.** Inspect motion at normal speed and open menus, sheets, and dialogs in both themes. Functional tests do not prove visual quality or native feel.

### iOS versions and Android

For new or redesigned tab navigation, **iOS 26+ uses a real native iOS tab bar whenever supported**. Use native Liquid Glass only on iOS 26 or newer, with the installed integration's availability check. Do not substitute Material/custom tabs on that supported path unless instructed otherwise.

**Older iOS uses custom product components** when that support is requested; do not default to stock Material/Cupertino chrome or simulated Liquid Glass. For a simple new app, start with a stated iOS 26+ design assumption and ask how older versions should behave: custom support, or an intentional iOS 26+ minimum. Continue independent work while waiting; do not guess the fallback, alter deployment targets, or claim older-OS support without an answer. Existing apps retain their declared support range and design system outside a requested redesign.

Android adapts the product choices with its own back behavior, input, accessibility, and suitable controls. Native iOS Liquid Glass must never be used on Android. See [toolkit and compatibility policy](references/toolkit.md) for package checks and integration limits.

New visual systems use neutral structural surfaces, coherent typography and icons, purposeful depth, and no ink splashes/ripples. Existing product systems take precedence. See [theme foundations](references/theme-patterns.md), [microinteractions](references/motion-patterns.md), and [direct mobile UX](references/mobile-ux.md). Preferred libraries and their licensing notes live in the [toolkit](references/toolkit.md); install only what the app needs.

## Install and update

Link this checkout into `~/.agents/skills/`:

```bash
python3 scripts/link_skills.py --write
python3 scripts/link_skills.py --check
```

Links expose repository changes automatically. The script preserves unrelated skills and refuses to overwrite conflicting folders or links. For project-local installation, add `--dest /path/to/project/.agents/skills`. Keep this checkout at the same path while linked.

For a portable copy, copy a complete folder under `skills/`, including `references/`, `agents/`, and every `LICENSE*` file. Reinstall copies after updates. Linked installations need only the shared-reference synchronization below.

## Validate and maintain

Edit canonical guides under `references/`; the [manifest](references/manifest.json) controls their self-contained packaged copies. Then run:

```bash
python3 scripts/sync_references.py --write
python3 scripts/sync_references.py --check
python3 scripts/validate_suite.py
python3 scripts/test_skill_packaging.py
python3 scripts/link_skills.py --check
```

Use the short [to-do app idea](validation/reference-app-prompt.md) for a manual trial with any agent. Select the skill separately and ask for generated output in `validation/reference_app/`. The prompt stays simple; the skill supplies the craft expectations. [Validation guidance](VALIDATION.md) separates packaging checks from actual app acceptance. [Package examples](validation/package_examples/README.md) cover optional integration examples.

Keep screenshots, recordings, logs, and research captures in task-scoped temporary storage. Automatic Marionette reports are off by default. Routine decisions and findings stay in chat; no automatic research folders, session histories, or generated apps belong in skill bundles. Save durable reports only when requested. See [evidence policy](references/evidence-policy.md).

## Attribution

Original work © 2026 **Emil Kowalski**. His principles include purposeful motion, restraint, invisible craft, reviews, prototypes, and realistic stress testing. I adapted and consolidated them into mobile UX workflows, preferred Flutter tooling, accessibility, lifecycle and recovery guidance, and executable validation.

I maintain this modified edition independently under the [MIT license](LICENSE), preserved in each skill with the original author’s credit and the modification copyright notice.

The research workflow also adapts [Appllama's usage and app-design skills](https://github.com/Appllama/appllama-skills), reviewed from installed versions 1.1.0 and 1.3.0 on 13 October 2026. The upstream MIT notice is retained in [LICENSE-Appllama](LICENSE-Appllama) and the new skill bundle. This is an independent Flutter adaptation.
