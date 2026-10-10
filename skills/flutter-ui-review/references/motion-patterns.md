# Motion Patterns

Motion is a construction decision, not a coat of polish. Run the sequence in order; the first two steps may correctly produce no animation. Make the call, explain it in one line, and implement it. Do not present a menu of motion options.

Abdullah AlMunaikh’s motion framework retains purposeful motion, precise ingredients, interruption, spatial consistency, and physical response. Flutter tickers and widget work run through the UI isolate and raster pipeline.

## 1. Frequency gate

| Frequency | Decision |
| --- | --- |
| 100+ times/day: command palette, shortcuts, routine toggles | No added animation. Preserve platform behavior and stop here. |
| Tens of times/day: press feedback, row selection, list navigation | Near-imperceptible feedback, under 150ms, or nothing. |
| Occasional: sheets, modals, toasts | Standard, short animation. |
| Rare / first-time: onboarding, success, celebration | The delight budget lives here. |

Keyboard-initiated actions are a disqualifier for added decorative motion. Never delay a shortcut, focus movement, or typing. Tabs are peers: do not add hierarchical slide transitions to routine tab switches. Preserve a product's intentional swipeable `TabBarView` or platform navigation rather than disabling established interaction indiscriminately.

If the request fails the gate, say which part and provide the instant state change or static affordance. Zero animation code is a successful outcome.

## 2. Name the purpose

Choose **feedback**, **spatial consistency**, **state indication**, **preventing a jarring change**, **explanation**, or **delight**. Explanation belongs to onboarding/product demonstrations; delight belongs to the rare tier. If none fits, stop. Reading and decision-making content must not move for style. Decorative pointer tracking belongs on a suitable showcase, not a banking graph.

## 3. Choose the cheapest correct tool

Use Flutter Animate for ordinary effect composition and simple implicit widgets for local target changes. Preserve suitable existing architecture without a gratuitous migration. Use Motor for physics and Heroine for shared elements; do not introduce stock `Hero`; use Heroine with Motor. Reserve manually composed `AnimationController`/`Tween` timelines and simulations for a genuinely complex custom animation mixer whose requirements the preferred tools cannot express.

| Need | Flutter tool |
| --- | --- |
| Two-state opacity, scale, color, padding, alignment | Simple implicit widgets: `AnimatedOpacity`, `AnimatedScale`, `AnimatedContainer`, `AnimatedPadding`, or `AnimatedAlign`. Choose only the property needed. |
| Keyed content replacement | `AnimatedSwitcher`, with semantic keys, an intentional exit, and no duplicate interactive outgoing controls. |
| Once-only entrance / short coordinated sequence | `flutter_animate` by default; own once-only/replay state and bypass effects under reduced motion. |
| Continuous, interruptible, gesture-driven motion | `motor` for retargetable springs and gesture momentum, with verified position/velocity units and gesture ownership. |
| List/detail continuity | `heroine` with Motor-based physics; wire its controller into the correct navigator. Do not introduce stock `Hero`. |
| Routes, sheets, menus, tooltips, tabs | The app's router; `smooth_sheets` for new modal/persistent/paged sheets; established menu, tooltip, and tab controls. Preserve navigation and dismissal behavior. |
| Refresh, collapsible header, lazy list | `RefreshIndicator`, `SliverAppBar`, `ListView.builder` / slivers, and existing `ScrollPhysics`. |
| Purposeful 3D tilt / sensor parallax | `motion`, with static reduced-motion and sensor-unavailable alternatives. Arbitrary flip/orbit choreography needs a separate verified composition. |
| Illustration or large custom scene | Existing vector-animation tooling or `CustomPainter`; use this only when illustration or the render workload calls for it. |

The [preferred toolkit](toolkit.md) supplies task-specific defaults for new features. Preserve suitable existing conventions; use SDK primitives for simple needs. Packages implement the design principle. Before introducing `flutter_animate`, `motor`, `heroine`, `smooth_sheets`, or `motion`, inspect `pubspec.yaml`, `pubspec.lock`, the project's Flutter SDK constraint, package documentation, maintenance, and supported platforms. Do not assume these packages have interchangeable spring or route APIs. No unverified package snippets belong in production.

Flutter routes render through Flutter; they are not automatically UIKit/Android-native navigation controllers. Preserve the project's platform-aware route configuration, interactive iOS back behavior, Android predictive back, deep links, focus, and state restoration. Do not replace the navigator with a transformed `Stack` to imitate a route.

## 4. Choose properties with Flutter's actual costs

- Prefer paint-space translation/scale and carefully scoped opacity. `Transform` does not re-layout its child, but neither transform nor opacity is universally free, GPU-only, or immune to a busy Dart UI isolate.
- Avoid animating layout properties on large subtrees. Height animation is justified for an accordion; isolate and keep it short. A small out-of-flow tab indicator is another deliberate exception, not permission to animate the whole page's constraints.
- Use Flutter Animate or implicit widgets to own routine effects. For an approved complex mixer, pass static subtrees through the narrow builder/transition; do not call page-level `setState` on every tick or scroll event.
- `SlideTransition` offsets are fractions of the child's dimensions. `Transform.translate` uses logical pixels. Choose deliberately; `Offset(0, 1)` in a slide hides a sheet by its own height. Respect reading direction for horizontal paths. [Flutter SlideTransition](https://api.flutter.dev/flutter/widgets/SlideTransition-class.html)
- Never enter from scale zero. Start at `0.9–0.97` with opacity zero. Set `alignment` from the trigger's actual position for anchored panels; unanchored modals remain centered.
- Transform order matters. Compose translation and scale intentionally and test hit testing. Do not use a global theme animation to move every descendant.
- Clips, backdrop filters, shadows, overlapping opacity layers, and `saveLayer` can be expensive. Profile UI and raster time independently. `RepaintBoundary` is targeted isolation, not a blanket fix. Prefer fading a fixed blur/shadow surface to recomputing its expensive effect each frame. There is no universally safe blur radius; measure the affected surface. [Flutter performance guidance](https://docs.flutter.dev/perf/best-practices)

## 5. Use sourced curves, timings, and springs

Extend the codebase's tokens rather than creating a parallel system. The following cubic values are preserved exactly from the fork, not replaced with vaguely similar `Curves.easeOutCubic` or Material defaults. Native route defaults are exempt: do not override platform navigation merely to apply these tokens.

```dart
import 'package:flutter/animation.dart';

abstract final class MotionTokens {
  static const Curve enterExit = Cubic(0.23, 1, 0.32, 1);
  static const Curve move = Cubic(0.77, 0, 0.175, 1);
  static const Curve drawer = Cubic(0.32, 0.72, 0, 1);
  // Gentle color changes; not a default entrance.
  static const Curve color = Cubic(0.25, 0.1, 0.25, 1);
  static const Duration press = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration stagger = Duration(milliseconds: 50);
}
```

| Situation | Curve / timing |
| --- | --- |
| Enter / exit | Strong ease-out; small popover 125–200ms, dropdown 150–250ms. |
| Moving / morphing on screen | Strong ease-in-out; typically 200–250ms. |
| Hover / color | `color`; pointer-only styling, subtle and fast. |
| Constant progress | Linear. Progress must not ease. |
| Touch press | 100–150ms and scale `0.97`, only if the gate allows it. |
| Modal / sheet | Usually 200–300ms, or a velocity-aware spring; preserve route defaults. |
| Onboarding explanation | Can be longer when needed to explain. |

Never use ease-in for ordinary UI: its slow start postpones feedback. Keep added UI animation under 300ms without a concrete reason. Keep transient messages at or below 300ms and preserve platform route timings. A shared design system's validated exception may remain.

For a genuinely touchable or interruptible object, use a spring. Start with critical damping and no overshoot. Add small bounce only when the gesture carried momentum. Preserve these source intentions:

| Interaction | Apple-oriented source intention | Flutter duration/bounce starting token |
| --- | --- | --- |
| Reposition / ordinary settle | Damping ratio `1.0`, response `0.4s` | `400ms`, bounce `0` |
| Momentum / rotation | Damping ratio about `0.8`, response `0.4s` | `400ms`, bounce `0.2` |
| Momentum sheet | Damping ratio about `0.8`, response `0.3s` | `300ms`, bounce `0.2` |

Response, perceptual duration, and physical settle time are different concepts. Do not relabel response as guaranteed completion time. Flutter's documented `SpringDescription.withDurationAndBounce` provides a SwiftUI-style mapping; check the project's SDK supports it. On an older SDK use `SpringDescription.withDampingRatio` with existing sourced mass/stiffness tokens or document an explicit response-to-physics conversion. Do not invent a physics triplet to look plausible. [Flutter duration/bounce mapping](https://api.flutter.dev/flutter/physics/SpringDescription/SpringDescription.withDurationAndBounce.html), [damping ratios](https://api.flutter.dev/flutter/physics/SpringDescription/SpringDescription.withDampingRatio.html)

## 6. Interruption, gestures, and exit

- Retarget from the presentation value, never the previous target. Native implicit animations usually retarget from their current interpolation; resetting a controller to zero on every event defeats that behavior.
- Use Motor for springs and verify that retargeting preserves current position **and velocity**. Only an approved complex mixer should recreate this with a low-level `SpringSimulation`; read both values before stopping it. A spring label alone does not prove continuity. [Flutter SpringSimulation](https://api.flutter.dev/flutter/physics/SpringSimulation-class.html)
- `DragEndDetails.velocity.pixelsPerSecond` is logical pixels per second. Flutter logical pixels correspond to density-independent layout units; pass velocity in the simulation’s coordinate units, without an extra division by 1000.
- A dp-based unbounded controller takes dp/s directly. If a `0–1` controller spans `travelDp`, convert `vNormalized = vDpPerSecond / travelDp` and position likewise. Guard zero travel. The Apple example's `v / (target - current)` is for a displacement-relative API; it is **not** Flutter's universal normalization rule.
- Choose snap targets from a bounded momentum projection, not just release position. Respect velocity **sign**, cap the projection to permitted snap bounds, and protect zero-size/invalid inputs. Keep Flutter scroll momentum in its `ScrollPhysics`; custom projection belongs to the custom object, not the list.
- Preserve grab position and track 1:1 after intent is established. Flutter recognizers own slop and the gesture arena; do not intercept all raw pointer events. A sheet and its inner scroll view need explicit ownership. Prefer Smooth Sheets and its documented scroll coordination; do not attach competing vertical drags to every child. An existing `DraggableScrollableSheet` retains its supplied scroll-controller contract.
- Protect against extra pointers, cancellation, edge-back conflicts, and reversal. Prefer project/framework gesture ownership; if a custom recognizer is necessary, test active-pointer policy. A `Listener` alone does not arbitrate scrolling or produce keyboard/semantic actions. [Flutter gesture arbitration](https://docs.flutter.dev/ui/interactivity/gestures)
- Rubber-band past a soft bound with increasing resistance, then spring back. A hard stop reads as frozen. Never allow overdrag to reveal private content or commit a consequential action accidentally.
- Exit along the arrival path. Preserve an outgoing widget until its exit completes; a conditional that immediately removes it has no exit. For a reversible controller, reverse the same spatial path; choose an appropriate reversed curve deliberately rather than substituting unrelated motion.
- Do not lock out valid input for the duration of an animation. Hidden/exiting content must stop accepting input and leave semantics when it becomes unavailable; focus must have a valid destination.

## 7. Reduced motion, input, and access

Read `MediaQuery.disableAnimationsOf(context)` in a dependency-aware place. Replace translation, large scale, parallax, elastic overshoot, and continuous loops with static updates or a short fade/color change that still explains state. Static is correct when the setting requests disabling as much as possible; do not force a fade everywhere.

`MediaQuery.accessibleNavigationOf(context)` is independent: it signals assistive navigation, not a reduced-motion preference. Ensure reachable controls, adequate reading time, stable focus, and durable feedback; do not dismiss messages merely because an animation timer ended. `MediaQuery.highContrastOf(context)` requests stronger contrast. Flutter's public `MediaQueryData` has no equivalent reduced-transparency flag; use a supported platform bridge or an app preference when needed and provide a legible solid fallback. Do not pretend contrast or reduced motion is the transparency signal. [Flutter media/accessibility data](https://api.flutter.dev/flutter/widgets/MediaQueryData-class.html)

Keep touch controls usable without hover. With a tablet trackpad or hardware keyboard, `MouseRegion` or native control hover states may enhance pointer feedback, never disclose the only action. Keep focus visibly distinct; keyboard/assistive activation remains immediate. Use at least 44 logical pixels for iOS touch targets and 48 for Android where appropriate, enlarged through real layout/hit regions through an actual hittable control.

Press feedback starts on press-down; commit on a successful release. Restore appearance on cancel, drag-away, loss of focus, disabled state, route change, or disposal. Let semantic buttons own Enter/Space activation instead of adding a second raw tap handler. Keep cancellation and drag hysteresis in the existing control/recognizer when possible.

Route escape needs a visible dismissal control, correct focus return, and system Back. Use `PopScope` / form pop policy with the existing navigator to protect unsaved work. Its `canPop` must be established before the attempt for predictive back; `onPopInvokedWithResult` reports what happened. When iOS back gestures are disabled by `canPop: false`, the callback is not an alternative gesture detector. Never block every route just to play a custom exit. [Flutter PopScope](https://api.flutter.dev/flutter/widgets/PopScope-class.html)

Haptics and sound must be causal, harmonious, and useful. `HapticFeedback.selectionClick`, `lightImpact`, or `mediumImpact` can accompany detent/commit feedback once per meaningful action, not every frame or every scroll tick. Request them at the same logical event as the visual, not after settling. Flutter's platform haptic API does not promise exact same-frame delivery or a universal success/error notification API; verify on hardware and pair with visible feedback. [Flutter haptics](https://api.flutter.dev/flutter/services/HapticFeedback-class.html)

## 8. Lifecycle and validation

Create controllers once in `initState`, update configuration in `didUpdateWidget`, dispose owned controllers/listeners, and use `vsync`. Do not allocate tickers in `build`. Handle `TickerCanceled` when awaiting `.orCancel`, and check mounted before unrelated asynchronous UI updates. `TickerMode` silences tick callbacks while time still advances; it is not an app-wide pause policy. Pause nonessential loops when routes are covered or the app is inactive. Rebuilds, provider refreshes, virtualization, and orientation changes must not restart entrances. [Flutter controller lifecycle](https://api.flutter.dev/flutter/animation/AnimationController-class.html)

Use the project-pinned SDK to format changed Dart code, run static analysis, and run relevant behavioral tests. Test rapid reversal, interrupted exits, scroll-vs-drag ownership, pointer cancellation, keyboard activation, focus restoration, system Back, reduced motion, high contrast, large text, RTL, and safe areas. Test behavior, not an implementation-shaped list of curve literals.

Use Flutter DevTools frame timing in profile mode to identify UI/raster work, then feel-check a release build on the slowest supported physical device. The approximate frame budget is 16.7ms at 60Hz or 8.3ms at 120Hz; high refresh is a device/engine/platform capability, not a promise. Review at 2–5× duration or with slow animations, interrupt and reverse gestures, and look again with fresh eyes. No simulator-only result proves physical feel or haptic timing.

## Never ship

| Never | Instead |
| --- | --- |
| Decorative animation on shortcuts / 100+ per-day actions | Instant state, platform default. |
| Scale-zero entrance / ease-in UI | Scale `0.95` + fade / exact strong ease-out. |
| Handwritten controller/tween composition for ordinary effects | Flutter Animate or a simple implicit widget. |
| Introducing stock Hero for new shared elements | Heroine with Motor-based physics. |
| Restarting motion on every rebuild or lazy row mount | Stable once-only state; animate a bounded group. |
| Whole-page `setState` on every tick / scroll update | Narrow transition/builder or painter; static child. |
| “GPU-only” / “transform is free” claims | Profile Flutter UI and raster work. |
| Distance-only flick dismissal / wrong velocity units | Signed velocity-aware decision in dp/s. |
| Hard boundaries / target-value interruption | Rubber-band; current position and velocity. |
| Custom sheet stealing a list's drag / navigator's back | Existing ownership and route primitives. |
| Missing reduced motion / hover-only actions | Static or gentler equivalent; touch + keyboard parity. |
| Moving invisibly interactive or duplicate semantic controls | Explicit hit-test/semantics/focus policy. |
| Haptics as the only feedback | Visible state, one causal haptic. |

Use [recipes.md](recipes.md) for concrete component construction. Deliver code followed by the gate result, ingredients, and the precise device feel-check still needed. Do not claim unperformed validation.
