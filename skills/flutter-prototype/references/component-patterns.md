# Flutter component craft

Read for composition, reusable widgets, adaptive layouts, materials, controls, and typography. Build with the shared theme in [theme-patterns.md](theme-patterns.md). Use the established product language; do not impose an Apple aesthetic on every Flutter app.

## Component choice and identity

Use the codebase's design-system components as-is unless the user asks to redesign the feature. Extend a missing capability consistently; do not replace an existing component because another style seems more attractive. For new UI without a system, compose semantic product components instead of exposing raw Material defaults. Design their density, geometry, type, icons, press/selection response, and opened states together. Keep component APIs semantic and business state outside animation code.

Native iOS tab bars take precedence over custom styling for new or redesigned tab navigation; follow [toolkit](toolkit.md). Consider a tappable card that expands into its detail page and reverses on dismissal, maintaining content identity and route ownership. This is useful continuity, not a requirement to wrap every row in a card.

## Composition and reusable boundaries

- Start from the primary task, content hierarchy, and current state. One dominant visual idea per screen; each major section gets one job.
- Prefer spacious hierarchy, purposeful imagery, strong type, and a few useful surfaces to an indiscriminate card grid. Let spacing and grouping do more work than decoration.
- Compose the first visible area from real app state, navigation, content, or actions. Onboarding or explanatory content can be expressive; a working screen should help people work.
- Extract a public widget when a section is reusable, visually meaningful, independently testable, or complex enough to deserve a name. Avoid `_buildHeader()`/`_buildBody()` sprawl and giant widgets with many unrelated configuration flags.
- Keep APIs semantic and typed. Keep transient press/animation state local; keep business state in the project's established state layer. Stable identity belongs in keys derived from content IDs, not list index or newly generated values.
- Start with the existing product controls, router, icon system, and sheets. Do not assemble every screen from unstyled stock Material. Use deliberate custom components or themed semantic primitives, preserving focus, semantics, shortcuts, cancellation, and familiar navigation. Disable ink splashes and ripples centrally and in any overriding component; keep useful press and focus feedback.
- Use existing product or platform icons. If a new app needs an alternate set, `ionicons_plus` is the preferred alternate family (exported class `Ionicons`); verify the symbol and installed API. Do not add a dependency for one decorative glyph when a fitting existing icon is available.

Fields use the same shared shape, spacing, surface, and state colors as surrounding controls. Avoid leaving `OutlineInputBorder()` at its default while styling the rest of the app. Use a calm resting surface with deliberate focus/error treatment and persistent usable labels; see [text-field theming](theme-patterns.md#text-fields).

## Inspect the small components

For visible UI work, read this reference and [theme-patterns.md](theme-patterns.md) before choosing controls. Preserving the router and state layer does not mean preserving an unfinished seed theme. Fix visible inconsistencies within the authorized feature; a read-only review records them instead.

- Inspect the whole top bar, then open every relevant menu. Compare back, close, and action controls together: material, shape, hit region, icon family/weight, baseline, and edge inset. A glass bar containing a bare Material button and stock popup is still an incoherent bar. Debug controls must meet the same bar; hiding them is not a fix.
- Keep canvases and structural card, field, menu, and dialog surfaces greyish off-white or off-black. Do not use pure white/black, cream, or accent-tinted structural fills. Check resolved colors and surface-tint overlays rather than assuming a seeded scheme is neutral. Accent and status colors express meaningful interaction/state; photographs and illustrations retain their content colors.
- Use one documented shape scale and spacing rhythm. Components with different roles can have different radii, but the distinction needs a consistent rule. Align text, icons, and control edges optically; adding a larger radius everywhere does not establish cohesion.
- Compare cards and fields against the actual canvas in both themes. Quiet does not mean indistinguishable. Use deliberate neutral tone, spacing, or a necessary boundary before adding depth; do not make every field/card a pale accent-colored slab.
- Inspect fields empty, filled, focused, invalid, and disabled with the keyboard visible. Keep labels understandable after entry, distinguish hint from label, reserve useful helper/error space, and make focus legible. A harsh resting border or unrelated corner radius is a defect even when validation works.
- Use a coherent type hierarchy and icon family; do not fix clipping by shrinking accessible text or forcing single-line labels. Read real labels, values, and recovery copy, including long translations.

On iOS, coordinate the back control, menu trigger, and opened menu through the verified native controls in [toolkit.md](toolkit.md), with an explicit fallback on unsupported targets. `LiquidGlassMenu` has a plain native button trigger and a one-trigger-per-screen limitation; do not assume every native control shares glass styling or wrap it in competing tap layers. On Android, use deliberately styled controls with Android back/dismiss behavior. Match a platform's interaction language without copying its appearance indiscriminately across platforms.

Report visual acceptance separately from journey correctness. Include open overlays, control states, and both themes in runtime evidence; a closed-menu screenshot or passing analyzer cannot prove the menu is finished.

For floating navigation, inspect parent constraints and rendered control dimensions, then scroll under the bars. A requested square can be compressed by parent constraints; a transparent bar above an inset viewport cannot sample scrolling content. Native platform views also need deliberate paint order and verified overlay suppression. Coordinate shared geometry and inset ownership using [native UI](native-ui.md) and [toolkit](toolkit.md), with clearance inside scroll content and no duplicate safe-area padding.

## Responsive composition

Use `LayoutBuilder` for the actual available space, not a guessed device label. On wider screens add gutters, max widths, split views, stable navigation, or secondary panels rather than stretching a phone card. Reuse the same visual and motion language. Keep state, selection, scroll position, and unfinished work when the layout changes; moving a stateful subtree across branches can recreate it, so lift durable state above the adaptive boundary.

`MediaQuery.sizeOf(context)` measures the app window; `LayoutBuilder` measures the parent's allocation. Do not infer that allocation from orientation alone or lock orientation to conceal overflow. Diagnose the first constraint failure before its cascading layout errors: give scrollables bounded space, constrain fields in rows, and use flex children only under compatible bounded parents. Consult the official [responsive layout](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-build-responsive-layout/SKILL.md) and [layout diagnosis](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-fix-layout-issues/SKILL.md) skills when needed.

Use `SafeArea` for system intrusions and `MediaQuery.viewInsetsOf(context).bottom` for keyboard obstruction when custom layouts need it. Avoid applying the same inset twice when `Scaffold` already resizes. Scroll and long content need bounded parents; do not put `Spacer`/`Expanded` inside a vertically unbounded scroll view. Use slivers or lazy list/grid builders for long content.

Mobile controls need generous hit regions and feedback on touch-down; actions commit on valid release and cancel if the gesture loses. Tablet pointer and hardware keyboard users also need hover, visible focus, shortcuts, Escape, pointer drag, and scroll. Do not put essential actions behind hover. Test RTL, large text, screen readers, and long translations as layout inputs.

## Semantic buttons

The complete example below consumes the shared `FilledButtonTheme`. A framework button owns activation, disabled state, semantics, focus, and cancellation; shared theming owns appearance. Its minimum size permits the label to grow at large text sizes.

```dart
import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Widget text = Text(label);
    if (icon == null) {
      return FilledButton(
        style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
        onPressed: onPressed,
        child: text,
      );
    }
    return FilledButton.icon(
      style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
      onPressed: onPressed,
      icon: Icon(icon),
      label: text,
    );
  }
}
```

The local no-splash style keeps this independently copied example ripple-free; the shared theme still supplies shape, spacing, and state colors. Keep foreground text colors in the control theme so disabled and pressed states remain legible. Prefer small semantic variants to one giant configurable button. Icon-only controls need localized tooltips and accessible labels. Toggle chips must expose selection and activation; a decorative pill is not a working selectable control.

See [recipes.md](recipes.md) for subtle `0.97` press feedback. No ripple does not mean no feedback. Keyboard activation uses immediate feedback without decorative scale motion. Do not replace a button with a bare `GestureDetector` merely to animate it.

## Materials and hierarchy

Translucency communicates a functional floating layer over real content. For new Apple-style navigation use the [preferred toolkit](toolkit.md), including `native_liquid_glass`; for a justified custom surface use a bounded `ClipRSuperellipse` + `BackdropFilter` + translucent fill; `ImageFiltered` blurs the child itself and is a different effect. Keep contrast across changing backdrops. Heavy structural surfaces and light interactive layers have different material weight; do not stack light translucent surfaces until text loses separation.

Prefer a solid fallback for high contrast and any app/platform reduced-transparency setting. Flutter's portable `MediaQuery` does not expose a universal reduced-transparency flag; use a project setting or a verified platform bridge, never invent `MediaQuery.reduceTransparencyOf`. Retain a defined border or strong separation where required. Do not use translucency simply because it looks fashionable.

A modal task dims the background with a scrim and provides a clear way out. A parallel nonblocking panel can separate by offset/material without trapping input. Scrim taps, drag dismissal, close controls, system back, Escape, and focus restoration must agree. Protect unfinished work. Materialization can combine slight scale with changes in material weight; profile filters, and use a static blur layer or solid surface if animating blur exceeds the raster budget. Full-surface blur is not free.

## Sheets, details, and feedback

Use `smooth_sheets` for new temporary, persistent, or paged sheet tasks while retaining the current navigator/router and platform dismissal policy. Follow its installed scroll, keyboard, and safe-area APIs rather than adding competing drag recognizers. Preserve an established working sheet integration when replacement is outside scope. Flutter-rendered sheets are not automatically UIKit views.

For safe media/card expansions, use Heroine with Motor-based physics; do not introduce stock `Hero`. Preserve source identity, aspect ratio, placeholder layout, and focus. A draggable detail can be appropriate, with explicit close/back and preservation of work; it is not a default for long forms or costly dismissal. Respect the scroll/drag ownership and predictive-back guidance in [motion-patterns.md](motion-patterns.md).

Loading, empty, error, offline/interrupted, permission, completion, and destructive-action states deserve the same craft as the success screen. Give empty states one clear message, explanation, and useful optional action. Validate inline when possible. Feedback has four jobs: status, completion, warning, error. Avoid a brief toast as the sole record of a failure that needs action; see the feedback service contract in [feedback.md](feedback.md).

## Sources

- [Adaptive and responsive design](https://docs.flutter.dev/ui/adaptive-responsive)
- [Flutter accessibility](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility)
- [BackdropFilter](https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html)
- [DraggableScrollableSheet](https://api.flutter.dev/flutter/widgets/DraggableScrollableSheet-class.html)
