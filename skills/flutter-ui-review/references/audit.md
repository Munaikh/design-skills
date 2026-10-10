# Mobile UX, UI, and motion audit

### 1. Recon

Map Flutter SDK constraints, declared target platforms, motion packages and locked versions, routing, shared theme/motion tokens, controllers, gesture handlers, accessibility paths, and product personality. Build a frequency map and trace the primary user journeys. Inspect entry/completion, back/tab/modal behavior, draft retention, error/retry, and phone/foldable continuity. Inspect visual craft as a separate required pass, not an optional reward after functional checks. Preserve architecture and useful conventions; do not assume seed colors or stock controls are an approved design direction.

Search with `rg` for `AnimationController`, `Animated`, `Tween`, `Curve`, `Duration`, `Transform`, `Opacity`, `Hero`, `animate`, `Spring`, `onPan`, `onHorizontalDrag`, `onVerticalDrag`, `disableAnimations`, `accessibleNavigation`, and `Semantics`. Also inspect `splashFactory`, `splashColor`, `InkWell`, `InkResponse`, `ButtonStyle`, `BoxShadow`, and elevation overrides against [theme-patterns.md](theme-patterns.md). Check custom/themed control coherence, retained state feedback, and whether depth clarifies hierarchy. Inspect callers and state lifecycles, not just matching lines. Search `pubspec.yaml` and lockfiles for existing packages before recommending any dependency.

Inspect actual screenshots in both themes and open affected menus, popovers, and sheets. Compare top-bar leading/trailing controls and their overlays as one system. Trace `ColorScheme.fromSeed`, surface/container roles, field/card fills, and surface tint to catch accent leakage into structural backgrounds. Require greyish off-white/off-black neutrals, readable actual contrast, purposeful accent, consistent shapes/icons/type/spacing, and quiet but distinguishable field states. Do not hide a debug menu or remove an action to evade this inspection. Use [native UI](native-ui.md) and [accessibility](mobile-accessibility.md).

### 2. Audit categories

Include UX/task completion, navigation, forms/recovery, adaptive continuity, accessibility, and visual composition/control/surface coherence alongside the motion categories below. Use [mobile UX](mobile-ux.md) and [review standards](standards.md).

1. Purpose and frequency.
2. Easing and duration.
3. Physicality and origin.
4. Interruptibility and deliberate/response timing.
5. Rendering performance and rebuild scope.
6. Accessibility and input modes.
7. Cohesion and tokens.
8. Missed opportunities, evaluated through the reject-first gate in [opportunities.md](opportunities.md).

For a substantial audit, use read-only agents by category or app area when delegation is authorized by the user or applicable instructions. Each brief includes the absolute path to this reference and category, recon facts, scope/ref, token conventions, frequency assumptions, and a requirement for verified locations plus evidence, no implementation. Respect available concurrency.

| Effort | Coverage | Finding emphasis |
| --- | --- | --- |
| Quick | High-traffic components | Approximately five HIGH findings if justified; do not pad |
| Standard | All interactive UI | Full vetted table |
| Deep | Whole product including explanatory surfaces | Full table plus LOW polish items |

### 3. Vet and prioritize

Re-read every cited location yourself. Reject by-design, duplicate, misattributed, or exempt findings. Order by impact divided by effort, with critical access/recovery failures first.

| # | Severity | Category | Location | Finding | Fix summary |
| --- | --- | --- | --- | --- | --- |

**HIGH**: feel-breaking response, keyboard/high-frequency motion, verified jank, harmful state/recovery behavior. **MEDIUM**: noticeably wrong origin, restart jumps, missing reduced-motion path. **LOW**: justified polish or token consolidation. These labels do not downgrade an accessibility defect that prevents task completion.

List 2–4 missed opportunities separately only if they survive the gate; zero is valid. For an audit alone, stop after the report. For an audit plus planning request, write the requested plans; if selection was left open, present the reviewable table and let the user choose. In an explicitly noninteractive planning task, default to the top 3–5 by leverage and state the selection. Do not invent a permission checkpoint when the user already selected fixes or authorized execution.

Report UX and visual design verdicts independently, with inspected states and gaps. Visual-policy failures belong in the findings even when task completion succeeds; rank them by actual impact. During authorized implementation, fix in-scope defects proactively without changing business rules, removing capabilities, or replacing the existing architecture. Keep a read-only audit read-only.

### 4. Self-contained plans

One plan per selected finding, monotonic `NNN-short-slug.md` in the existing plans location. Merge only findings sharing the same files and fix pattern. Include a commit stamp; use “not a Git checkout” when applicable. Update the plans README with number, title, severity, status, execution order, and dependencies.

Every plan stands alone for an executor with no conversation context:

```markdown
# NNN — <Imperative title>

- Status: TODO
- Commit: <current immutable commit>
- Severity: HIGH | MEDIUM | LOW
- Category: <audit category>
- Estimated scope: <files and approximate size>

## Problem
Exact file paths and verified lines, current Dart excerpts, observable harm.

## Target
Exact final state, properties, curves, durations, alignment, reduced-motion
branch, gesture coordinate units and velocity behavior where relevant.
Inline the target Dart; do not say “use the easing above”.

## Repo conventions to follow
Shared token location, architecture/state ownership, one verified exemplar,
SDK/package constraints, and accessible interaction expectations.

## Steps
Ordered concrete edits; one file and resulting behavior per step.

## Boundaries
Out-of-scope files and behaviors; no new dependencies unless named;
preserve semantics, dismissal alternatives, and in-progress work.
If current code no longer matches the commit/excerpt, inspect the drift and
report material mismatches before improvising outside the specified scope.

## Verification
Mechanical: exact project-appropriate format/analyze/test commands and
expected results, run during execution (not the read-only audit).
Feel check: exact interaction, rapid reversal/repeated triggers, slow-motion
inspection, reduced motion, keyboard/pointer/touch, focus/semantics, and
real-device gesture checks. Name which checks require a running app.
Performance: profile-mode device and DevTools UI/raster frame checks when
the finding concerns rendering; preserve a before/after trace if possible.
Done when: observable completion criteria and any unverified limits.
```

Invocation equivalents: a category focus audits only that category after recon; `plan <description>` writes a scoped plan after sufficient inspection; `execute <plan>` implements and reviews; `reconcile` verifies current code, marks completed plans DONE, updates stale locations, and retires fixed findings. Do not mark plans done from a claimed fix alone.

## Verification tools and limits

Use the Flutter Inspector's slow animations control, or a temporary debug-only `timeDilation` during authorized execution, to inspect origins, opacity, sync, and end states. Remove temporary settings and restore normal speed. Use widget tests with controlled pumps to inspect intermediate and interrupted states; do not blindly `pumpAndSettle` a deliberately repeating animation. Capture screenshots or recorded frames when useful. For real performance, profile on the declared device class; debug speed is not release evidence. A 60Hz frame budget is approximately 16.7ms and a 120Hz budget 8.3ms, not a fixed universal 16ms rule.

Official Flutter references: [Performance best practices](https://docs.flutter.dev/perf/best-practices), [DevTools Performance view](https://docs.flutter.dev/tools/devtools/performance), [Rendering performance](https://docs.flutter.dev/perf/rendering-performance), [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html), [AnimationBehavior](https://api.flutter.dev/flutter/animation/AnimationBehavior.html), [Reduced-motion query](https://api.flutter.dev/flutter/widgets/MediaQuery/disableAnimationsOf.html).
