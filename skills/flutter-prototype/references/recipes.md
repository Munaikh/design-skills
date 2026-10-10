# Flutter Animation Recipes

Start with [motion-patterns.md](motion-patterns.md)'s ordered gate. These are Abdullah AlMunaikh’s Flutter mobile adaptations, chosen by purpose rather than added indiscriminately. Reuse the app's component, theme, route, and motion tokens. The Dart blocks below are independent component/helper examples; their local curve constants demonstrate the exact source values. Move those constants into the shared motion module in a real app. For normal features use Flutter Animate or simple implicit widgets, Motor + Heroine for physics/shared elements, Smooth Sheets for sheets, and Motion for 3D tilt. The SDK-only examples include simple implicit-widget fallbacks and advanced mechanics for genuinely complex custom mixers; they do not override those defaults.

## Button press

Use the project's semantic button. When the frequency gate allows pointer press feedback, scale its visual content to `0.97` in 100–150ms; scale the label and icon together. Observe its existing pressed state through `WidgetStatesController` or a project abstraction instead of nesting a competing `GestureDetector` around a functioning button. Restore on cancellation as well as release. Flutter's states-controller documentation warns that notifications may occur during build; defer any listener-driven `setState` appropriately. [Flutter states controller](https://api.flutter.dev/flutter/widgets/WidgetStatesController-class.html)

Keep a stable, sufficiently large hit region outside the scaled visual so shrinkage does not lose the press. Retain native Enter/Space activation, disabled semantics, focus outline, and pointer cancellation. Track pointer-origin activation if adding scale so a keyboard shortcut still follows the no-added-motion gate. Disable ink splashes/ripples through the shared theme and any component overrides; preserve deliberate pressed, hover, and focus feedback. Reduced motion uses the stable visual state with color/contrast feedback.

## Dropdown, popover, menu, select

Start with the existing menu/select component or `MenuAnchor`, not an arbitrary overlay. Keep selection, keyboard traversal, dismissal, focus restoration, and accessibility roles. If customizing the transition is necessary, use a fade plus `0.95 → 1` scale in 150–200ms using the strong ease-out. Compute an `Alignment` from the actual trigger within the panel's coordinate space; do not hardcode center for a trigger-anchored surface. Clamp the alignment when placement flips at viewport edges. Reduced motion uses a short fade or an instant opening.

## Tooltip

Use `Tooltip` and the app's tooltip convention. Retain hover, focus/help, and long-press behavior that fits the target platforms. Its initial delay prevents accidental activation; a toolbar may deliberately use a shared warm state so neighboring tooltips appear immediately after the first. A shared warm tooltip session needs explicit state. If you implement it, own and dispose the shared timer and do not shorten messages for assistive users. The custom visual transition, when needed, is `0.97 → 1` + fade over 125ms; skip motion in the warm path.

## Modal, drawer, and sheet

Prefer the router's dialog/sheet route. A modal may enter centered from `0.96` scale with a synchronized scrim fade around 250ms. A noninteractive custom drawer follows the source drawer curve, but a draggable sheet needs a velocity-aware spring rather than replayed timing. Enter/exit use the same spatial path. Keep barrier labels, focus containment, escape/Back, visible dismissal, safe areas, and unsaved-work policy.

Use `smooth_sheets` for new sheet flows through the existing navigator. Verify scroll coordination, keyboard dismissal, safe areas, barriers, reduced motion, and back behavior against the installed version. Preserve a working existing `showModalBottomSheet` integration when replacing it is outside scope; it is not a native `UISheetPresentationController`. For scrolling detents, `DraggableScrollableSheet` must give its supplied `ScrollController` to the inner scrollable. Do not add another vertical pan recognizer to the list. `useSafeArea` on the modal function protects top/left/right; handle the bottom safe area and keyboard deliberately. On supported SDKs `sheetAnimationStyle: AnimationStyle.noAnimation` is an explicit reduced-motion option. Respect the route's supported customization API instead of assuming a `curve` parameter exists. [Flutter bottom-sheet route](https://api.flutter.dev/flutter/material/showModalBottomSheet.html)

Expanded image/card pages may use the app's verified draggable-page component. Do not drag-dismiss a consequential form without a recoverable work policy. A close button, semantic dismiss action, and system Back must share the same route/pop decision.

## Retargetable fade with real hidden-state behavior

For a surface that stays mounted and has no need to delay removal until an exit finishes, native `AnimatedOpacity` retargets the fade. This complete wrapper removes unavailable content from hit testing and semantics immediately. Pass `animate: false` for keyboard-origin or frequency-gated changes. Its caller moves focus to a valid destination before hiding focused content; the wrapper cannot guess that destination.

```dart
import 'package:flutter/widgets.dart';

class FadeVisibility extends StatelessWidget {
  const FadeVisibility({
    super.key,
    required this.visible,
    required this.child,
    this.animate = true,
  });

  final bool visible;
  final Widget child;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return IgnorePointer(
      ignoring: !visible,
      child: ExcludeSemantics(
        excluding: !visible,
        child: ExcludeFocus(
          excluding: !visible,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: reduced || !animate
                ? Duration.zero
                : const Duration(milliseconds: 180),
            curve: const Cubic(0.23, 1, 0.32, 1),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

Opacity zero alone does not prevent taps. If the widget must be removed after exit, use a keyed `AnimatedSwitcher` or the preferred effect package’s completion/lifecycle contract. Do not conditionally remove it before it can exit. Rapid toggling must retarget; do not call `forward(from: 0)` for every toggle. [Flutter content switching](https://api.flutter.dev/flutter/widgets/AnimatedSwitcher-class.html)

## Toast / status message

Use `ScaffoldMessenger` / the project's notification system before inventing an overlay queue. Preserve assistive reading time, action access, safe-area placement, cancellation, and replacement behavior. For a custom toast, enter from the bottom and exit to the bottom, with small translation + fade, up to 300ms entering and about 20% faster exiting. Keep route and keyboard insets in its placement. A repeated trigger updates from the current presentation; stacking requires intentional reflow and stable IDs. Tune fade against reflow by eye, then review with fresh eyes.

## Accordion / collapse

Use the existing disclosure widget, or a short `AnimatedSize` + `ClipRect`/size-transition composition. Height genuinely changes the widget layout here, so its cost is justified; use 200ms strong ease-out and keep the animated subtree small. Measure/layout actual content rather than assuming a default-text-scale height. Collapsed content leaves focus traversal and semantics. Expansion state must remain accessible even when the animation is removed. Never animate a large scrolling page's height for decoration.

## Once-only capped stagger

Use only for a short, occasionally seen group of supporting visuals; primary actions remain static and usable outside the entrance. Do not pass essential interactive controls into an initially invisible group. Stagger 30–80ms, not every lazy row in a feed. This complete group uses a 50ms stagger, caps at four sections, and never restarts on rebuild/provider refresh. Pass `animate: false` when activation originated from the keyboard or the session's entrance already completed. Each entrance lasts 180ms; the four-section composition finishes in 330ms, an intentional aggregate delay rather than a 330ms per-element transition. Reduce the group or remove stagger when that delay harms the task. If it must remain once-only across route remounts, keep a completed flag in durable route/session state and omit the wrapper on subsequent visits.

```dart
import 'dart:async';
import 'package:flutter/widgets.dart';

class CappedEntrance extends StatefulWidget {
  const CappedEntrance({super.key, required this.children, this.animate = true});
  final List<Widget> children;
  final bool animate;
  @override
  State<CappedEntrance> createState() => _CappedEntranceState();
}

class _CappedEntranceState extends State<CappedEntrance> {
  final List<Timer> _timers = [];
  final Set<int> _revealed = {};
  bool _started = false;
  bool _complete = false;

  void complete() {
    for (final timer in _timers) { timer.cancel(); }
    _timers.clear();
    _complete = true;
    _started = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.animate || MediaQuery.disableAnimationsOf(context)) {
      complete();
    } else if (!_started) {
      _started = true;
      for (var index = 0; index < widget.children.length && index < 4; index++) {
        final section = index;
        _timers.add(Timer(Duration(milliseconds: section * 50), () {
          if (mounted) setState(() => _revealed.add(section));
        }));
      }
      final lastDelay = (widget.children.length - 1).clamp(0, 3) * 50;
      _timers.add(Timer(Duration(milliseconds: lastDelay + 180), () {
        if (mounted) setState(complete);
      }));
    }
  }

  @override
  void didUpdateWidget(CappedEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.animate) complete();
  }

  @override
  void dispose() {
    for (final timer in _timers) { timer.cancel(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.children.length <= 4);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var index = 0; index < widget.children.length; index++)
        TweenAnimationBuilder<double>(
          key: ValueKey(index),
          tween: Tween(begin: 0, end: _complete || _revealed.contains(index) ? 1 : 0),
          duration: _complete ? Duration.zero : const Duration(milliseconds: 180),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: widget.children[index],
          builder: (_, progress, child) {
            final visibleProgress = _complete ? 1.0 : progress;
            return Opacity(opacity: visibleProgress,
              child: Transform.translate(offset: Offset(0, 8 * (1 - visibleProgress)), child: child));
          },
        ),
    ]);
  }
}
```

Give children stable semantic keys when identities can change. This recipe is a short composed group, not a lazy-list animation solution; do not use it to replay entrances on row recycling or sort/filter updates. Stable content should already be visible on routine visits.

## Hold to confirm

A hold interaction is optional, not an accessibility substitute for an explicit confirmation/undo flow. Use it only where the risk and task justify it; provide an equivalent keyboard and assistive action that presents the same clear consequence before committing.

Use Flutter Animate or a simple implicit progress presentation for the fill, with an explicit hold/cancellation state machine: **2 seconds, linear** while held; cancellation returns toward zero over **200ms strong ease-out**. Only a genuinely complex custom mixer warrants manual controller composition. Render the fill with a clipped or painted overlay, not layout expansion of the whole control. Own the active pointer and recognize a genuine hold; cancel on drag-away, pointer cancel, losing focus, becoming disabled, app inactivity, or route departure. Do not commit on every frame or every status notification: arm once per uninterrupted hold, consume that arming on completion, and keep the operation idempotent. Announce the consequence/action, not every percentage. Reduced motion keeps necessary progress readable without scale or spatial motion.

## Tab / segmented indicator and clipped active text

Do not slide peer screens to decorate routine tab selection. A tab indicator may move if the frequency gate permits it: use the existing tab/segmented component first, and 250ms strong ease-in-out for occasional selection changes.

For the fork's synchronized text/background technique, paint an active-style copy of the tab labels over the inactive row and clip it to the selected tab's measured rect. `ClipRect` + `CustomClipper<Rect>` is the Flutter equivalent of the inset mask. The active copy is **visual only**, wrapped in `IgnorePointer`, `ExcludeSemantics`, and `ExcludeFocus`; one underlying control tree owns selected state, focus, tap, and keyboard actions. Measure after layout, invalidate on resize/text-scale/locale/direction changes, and interpolate the rect from its current value. Do not use a scale transform that turns pill corners into ovals.

```dart
import 'package:flutter/widgets.dart';

class VisualActiveMask extends StatelessWidget {
  const VisualActiveMask({
    super.key,
    required this.activeRect,
    required this.child,
  });

  final Rect activeRect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: ExcludeFocus(
          child: ClipRect(
            clipper: _ActiveRectClipper(activeRect),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ActiveRectClipper extends CustomClipper<Rect> {
  const _ActiveRectClipper(this.rect);
  final Rect rect;

  @override
  Rect getClip(Size size) => rect.intersect(Offset.zero & size);

  @override
  bool shouldReclip(_ActiveRectClipper oldClipper) => rect != oldClipper.rect;
}
```

For a comparison slider, use the same visual clip technique to reveal one of two identically aligned images. A semantic `Slider` owns the value, keyboard adjustment, label, and accessible value; the decorative draggable divider must not be a second conflicting control. Clip/paint changes are not a claim of GPU-only execution. Static comparison remains available under reduced motion.

## Scroll reveal / collapsing header / keyboard

Scroll reveals are for rare onboarding/product demonstrations, not daily functional UI. Fire once when the relevant content enters the viewport; retain the completed flag beyond rebuilding and row virtualization. Use the project's verified visibility observer or a deliberate viewport/render calculation, after checking the actual observer API. Dispose listeners, avoid starting controllers in `build`, and avoid page-level `setState` on each scroll frame. A longer clipped reveal is an explanatory exception; bypass it under reduced motion. Never hide primary task content pending scrolling.

Use `SliverAppBar` / the existing sliver system for collapsing headers and native `ScrollPhysics` for scroll momentum. For keyboard avoidance start with `Scaffold.resizeToAvoidBottomInset`, `SafeArea`, and `MediaQuery.viewInsetsOf(context)`. Insets are not a universal frame-by-frame keyboard animation API. Do not invent a duration that claims to exactly follow a private system keyboard curve; if precise tracking is an explicit requirement, verify a platform/plugin solution on both targets.

## Drag-to-dismiss, interruption, momentum, and rubber-band

Use the existing sheet/page behavior whenever possible. Use Motor for new physical interactions. The following **advanced SDK-only mechanics helper** is reserved for a genuinely complex custom mixer and applies only to its dp-valued controller. It is deliberately not a new navigator or gesture recognizer. The gesture owner preserves grab position, settles cancellation, calls `retarget` on release, updates from a single active pointer, and renders `position` through a narrow `AnimatedBuilder`. A changed target during flight passes no velocity to preserve the current simulation velocity; a drag release passes the signed `pixelsPerSecond.dy` explicitly. The owner disposes this helper and responds to changing reduced-motion settings with `finishAt`.

```dart
import 'package:flutter/animation.dart';
import 'package:flutter/physics.dart';

double projectWithinBounds({
  required double position,
  required double velocityDpPerSecond,
  required double min,
  required double max,
  double decelerationRate = 0.998,
}) {
  if (!position.isFinite || !velocityDpPerSecond.isFinite ||
      !min.isFinite || !max.isFinite || min > max ||
      !decelerationRate.isFinite ||
      decelerationRate <= 0 || decelerationRate >= 1) {
    throw ArgumentError('Projection requires finite values and valid bounds.');
  }
  final distance = (velocityDpPerSecond / 1000) *
      decelerationRate / (1 - decelerationRate);
  return (position + distance).clamp(min, max).toDouble();
}

double rubberBand(double overshoot, double dimension) {
  if (!overshoot.isFinite || !dimension.isFinite) {
    throw ArgumentError('Rubber-band inputs must be finite.');
  }
  if (dimension <= 0) return 0;
  const resistance = 0.55;
  return overshoot * dimension * resistance /
      (dimension + resistance * overshoot.abs());
}

class SnapMotion {
  SnapMotion({required TickerProvider vsync, double initialPosition = 0})
      : position = AnimationController.unbounded(
          vsync: vsync,
          value: initialPosition,
        );

  // Position is in logical pixels, velocity is logical pixels per second.
  final AnimationController position;

  void retarget(
    double target, {
    double? releaseVelocityDpPerSecond,
    bool momentum = false,
    bool reducedMotion = false,
  }) {
    final current = position.value;
    final velocity = releaseVelocityDpPerSecond ?? position.velocity;
    position.stop();
    if (reducedMotion) {
      position.value = target;
      return;
    }
    final spring = SpringDescription.withDurationAndBounce(
      duration: const Duration(milliseconds: 400),
      bounce: momentum ? 0.2 : 0,
    );
    position.animateWith(SpringSimulation(
      spring,
      current,
      target,
      velocity,
      tolerance: const Tolerance(distance: 0.1, velocity: 0.1),
    ));
  }

  void finishAt(double target) {
    position.stop();
    position.value = target;
  }

  void dispose() => position.dispose();
}
```

The projection is the Apple source's exponential-decay estimate, using dp/s and a per-millisecond decay rate; the `/1000` belongs in that formula, **not** the spring velocity. Pick the permitted snap point nearest the bounded projected endpoint. A dismissal decision considers velocity sign and destination as well as distance: a quick reversal must not dismiss merely because absolute speed is high. Thresholds depend on surface travel and supported input; use existing validated product values rather than using a universal velocity threshold.

For a hard edge use the no-bounce spring or the existing constrained physics policy. If the object may softly overrun its bounds, track raw displacement separately and apply `rubberBand` only to overshoot; do not feed the already-damped display value back into raw drag accumulation. Unbounded controllers intentionally require an explicit reduced-motion policy. For normalized controllers, divide velocity by the **controller's fixed travel span**, not the remaining distance to the target. Zero span must settle instantly.

Check the project's Flutter SDK for `SpringDescription.withDurationAndBounce`; use the native SDK mapping when supported rather than pretending it exists on older SDKs. Check active pointer, arena wins/losses, scroll boundary handoff, press cancellation, route dismissal, orientation, reduced motion changes midflight, and re-grabbing a spring before calling the behavior verified. [Flutter spring construction](https://api.flutter.dev/flutter/physics/SpringDescription/SpringDescription.withDurationAndBounce.html)

## Shared element

Use `heroine` with Motor-based physics for persistent shared objects across routes; do not introduce stock `Hero`; use Heroine with Motor. Register `HeroineController` with the relevant navigator, use stable unique tags, and supply matching destination content on the route’s first frame. Verify the installed API, bounds, overlay compatibility, interruption, and reduced-motion bypass while preserving route/back behavior. Keep unrelated pages and 3D rotations outside the shared object. See the [toolkit](toolkit.md).

## Crossfade seam / material / optional 3D

If a crossfade shows two competing objects, first fix identity, overlap, layout, and timing. Only then consider a small **static** `ImageFiltered` blur layer faded over about 200ms; keep text legible and profile it. Avoid expensive per-frame backdrop-blur changes. High contrast and an explicit reduced-transparency preference use near-solid surfaces with clear boundaries.

For purposeful 3D tilt and sensor parallax, use `motion` with its initialization, lifecycle, and static accessibility fallback. It is not a general flip/orbit engine. A genuinely required two-sided flip is an advanced custom composition: explicitly choose and verify its implementation, swap the visible face at the midpoint, and remove the hidden face from input, focus, and semantics. Choose a perspective based on component geometry and verify it on device; explicitly control the visible face and perspective geometry. Prefer a static state or fade under reduced motion. Avoid flips for ordinary tab changes, text-heavy reading, or axis-aligned heroes. Drag rotations use independently reasoned axes and velocity-aware springs; don't replace a 2D drag with one scalar distance spring.

## Feel-check before shipping

Rapidly toggle; interrupt entry/exit; drag, flick, reverse, cancel, and re-grab midflight. Navigate away during a pending animation. Test the relevant pointer, touch, keyboard, and assistive modes, system Back, RTL, large text, reduced motion, high contrast, safe areas, and app inactivity. Profile UI/raster frames and confirm the release build's feel on a supported slow physical device. Slow motion/frame stepping is useful for spotting discontinuity, but a snippet that analyzes is not evidence that a gesture feels right.

## Swipe to remove, with an explicit action

For ordinary swipe dismissal use `Dismissible`, stable content identity, and the app’s undo/persistence flow. For revealing several row actions, use an existing verified action-pane component instead. The list owner must synchronously remove the dismissed item from its visible collection in `onRemoved`, preserve rollback data, and reconcile any server failure. Confirmation and an explicit remove action share the same consequence policy; swipe is not the sole action.

```dart
import 'package:flutter/material.dart';

class RemovableRow extends StatelessWidget {
  const RemovableRow({
    super.key,
    required this.id,
    required this.label,
    required this.confirmRemoval,
    required this.onRemoved,
  });

  final String id;
  final String label;
  final Future<bool> Function() confirmRemoval;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final colours = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      movementDuration: reduced
          ? Duration.zero
          : const Duration(milliseconds: 200),
      resizeDuration: reduced
          ? Duration.zero
          : const Duration(milliseconds: 200),
      confirmDismiss: (_) => confirmRemoval(),
      onDismissed: (_) => onRemoved(),
      background: ColoredBox(
        color: colours.errorContainer,
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Icon(Icons.delete_outline, color: colours.onErrorContainer),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          IconButton(
            tooltip: 'Remove', // Localize in the app.
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () async {
              if (await confirmRemoval() && context.mounted) onRemoved();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
```

The owner deduplicates pending confirmation/submission for the same ID and clears it on cancel. Do not accept a stale completion after a row’s identity or operation changes. This stateless example assumes stable per-ID ownership. `Dismissible` supplies its own gesture behavior; do not claim it implements every custom momentum projection. For a signature swipe-to-commit, use the earlier physics helper with an axis-specific recognizer and test vertical-scroll contention, reversal, cancellation, and signed RTL direction.

## A threshold crossing fires once, with hysteresis

For pull-to-refresh arming, a sheet detent, or slider step, perform side effects on the meaningful transition rather than every tick. Native refresh and scrolling remain first choices. The helper below emits only changes; the caller can request `HapticFeedback.selectionClick()` when it returns `true`, update visible armed state, and settle the operation when the gesture ends. Reset on cancellation. Units of threshold and value must agree.

```dart
class ThresholdGate {
  ThresholdGate({required this.enter, required this.exit}) {
    if (!enter.isFinite || !exit.isFinite || exit >= enter) {
      throw ArgumentError('Finite exit threshold must be below enter.');
    }
  }

  final double enter;
  final double exit;
  bool armed = false;

  // null means no transition; true arms and false disarms.
  bool? update(double value) {
    if (!value.isFinite) throw ArgumentError.value(value, 'value');
    final next = armed ? value > exit : value >= enter;
    if (next == armed) return null;
    armed = next;
    return next;
  }

  void reset() => armed = false;
}
```

A separate exit threshold prevents buzzing when the finger jitters at the boundary. Side effects fire from the gesture/controller owner, not from a painter or build method. Accessible users need visible arming and an equivalent explicit action. Do not announce every pixel.

## Drawing a path

A rare explanatory illustration may trace a vector path. Keep the completed path readable without animation under reduced motion. Use Flutter Animate or verified authored-vector tooling to drive ordinary traces. A genuinely complex custom mixer may drive a painter’s `repaint` listenable directly so the widget subtree need not rebuild every frame. The supplied path and color are immutable configuration; replace them with a new painter when they change.

```dart
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

class PathTracePainter extends CustomPainter {
  PathTracePainter({
    required this.path,
    required this.progress,
    required this.color,
  }) : super(repaint: progress);

  final Path path;
  final Animation<double> progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final metrics = path.computeMetrics().toList();
    final total = metrics.fold<double>(0, (sum, metric) => sum + metric.length);
    var remaining = total * progress.value.clamp(0.0, 1.0);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final metric in metrics) {
      if (remaining <= 0) break;
      final length = remaining.clamp(0.0, metric.length).toDouble();
      canvas.drawPath(metric.extractPath(0, length), paint);
      remaining -= length;
    }
  }

  @override
  bool shouldRepaint(PathTracePainter oldDelegate) =>
      path != oldDelegate.path || color != oldDelegate.color ||
      progress != oldDelegate.progress;
}
```

Scale the path to the actual bounded canvas once when geometry changes. Profile complex paths and cache immutable geometry when its measured cost warrants it. Decorative painting needs no duplicate semantics; an informative illustration gets a stable description on its owning widget. A painter must not perform mutations or network operations.

## Icons, text, values, loading, and authored illustration

Use `AnimatedIcon` with a controlled progress value for supported icon pairs, or an intentional keyed content switch for different symbols. Icon labels describe the final action, not the intermediate glyph. A controller restarts only when the semantic event requires it, and reduced motion selects the final state.

Text and number motion must preserve actual values and readability. Format localized values before presenting them, use grapheme clusters for character transitions, and use tabular figures where the font supports them. Keep the final readable value in a single semantics node; exclude outgoing decorative glyphs. Avoid per-update rolling digits for information people compare or read continuously. A brief content switch around 180ms may suffice.

For honest progress, use determinate indicators only when a valid fraction exists, clamp presentation to its range, and label the operation. Indeterminate indicators express unknown progress. Loading geometry should match final content; use static skeletons under reduced motion. Own loop cancellation when the task finishes, the route is covered, or the app is inactive. Never keep a controller repeating forever after the load has failed.

For authored vectors or state-machine illustrations, use an existing verified asset/runtime when it serves the product. Verify asset licenses, reduced-motion/static fallback, completion/cancellation, first-frame cost, renderer compatibility, and memory. Primary controls and operation status remain accessible ordinary widgets; illustration cannot be the sole feedback. Rare 3D tilt/flip/orbit needs the same frequency, reading, lifecycle, and reduced-motion gates.
