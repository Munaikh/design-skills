# Preferred Flutter toolkit

Use this capability map for new mobile features. Preserve suitable product components and existing dependencies first. Use Flutter Animate for effect composition, simple implicit widgets for local targets, Motor for physics, Heroine for shared elements, Smooth Sheets for sheets, and Motion for purposeful 3D tilt. Handwritten controller/tween timelines are reserved for genuinely complex custom mixers. Preserve suitable existing architecture without a gratuitous replacement. Do not install the whole list into an app. Review SDK constraints, lockfile, actual API, license, platform support, lifecycle, and accessibility before adopting a dependency.

Design controls intentionally: reuse product components, create suitable custom components, or deliberately theme semantic SDK primitives rather than using unstyled stock Material everywhere. Disable all ink splashes/ripples with `NoSplash.splashFactory` and transparent `splashColor`, audit overrides, and retain meaningful press/focus/selection feedback. Shadows use shared restrained depth tokens only when they clarify hierarchy, following Emil’s cohesion and attention to unseen details. See [theme-patterns.md](theme-patterns.md).

| Need | Preferred choice | Scope and existing-project guidance |
| --- | --- | --- |
| Apple-style app bars, tab bars, toolbars and glass controls | [liquid_glass_widgets](https://pub.dev/packages/liquid_glass_widgets) | Existing Cupertino navigation or a solid, simple platform control |
| Springs, interruptible targets, gesture momentum | [motor](https://pub.dev/packages/motor) | Use Motor for new physics; low-level simulation only for a genuinely complex custom mixer |
| Coordinated effects and entrances | [flutter_animate](https://pub.dev/packages/flutter_animate) | A simple implicit widget handles a local target; Flutter Animate is the default effect-composition tool |
| Spring-based shared-element continuity | [heroine](https://pub.dev/packages/heroine) | Use Heroine with Motor-based physics for new shared elements; do not introduce stock Hero |
| Modal, persistent, and paged sheets | [smooth_sheets](https://pub.dev/packages/smooth_sheets) | Preserve navigator/scroll ownership and an established working sheet when replacement is outside scope |
| Purposeful 3D tilt and sensor parallax | [motion](https://pub.dev/packages/motion) | Static presentation when motion is unnecessary, unavailable, or disabled; true flips/orbits need a separate verified composition |
| A product-selected Google Fonts face | [google_fonts](https://pub.dev/packages/google_fonts) | Established or system typography; bundle production fonts for offline first paint |
| A coherent alternate icon family | [ionicons_plus](https://pub.dev/packages/ionicons_plus) | Existing product, Material, or Cupertino icons fit |
| Interactive charts | [fl_chart](https://pub.dev/packages/fl_chart) | A small static indicator/custom painter with accessible values |
| Authored interactive illustrations/state machines | [rive](https://pub.dev/packages/rive) | Existing artwork or a simple controlled Flutter animation |
| Exported timeline playback | [lottie](https://pub.dev/packages/lottie) | A simple icon, painter, or SDK transition |

Package choice follows the user journey. Preserve router, business state, and platform behavior; do not reshape the product to suit a package demo. Illustrations supplement text/status and never provide the sole representation of task completion. Verify assets, errors, cancellation, disposal, reduced motion, and first-frame cost. The SDK recipe library remains a supported fallback.

## Apple-style navigation

`liquid_glass_widgets` supplies Flutter-rendered iOS-style surfaces. Use `GlassScaffold` with `GlassAppBar` and `GlassTabBar.bottom` as the primary screen pattern; `GlassToolbar` serves grouped actions. Use the package's sheets, menus, and controls when appropriate. Keep readable content and list rows opaque; glass belongs primarily to the navigation/control layer. On Android preserve Android-appropriate controls and back behavior unless the product explicitly chooses a shared glass treatment.

Treat the app bar, back control, menu trigger, and opened menu as one component family. Putting `IconButton` or `PopupMenuButton` inside `GlassAppBar` does not make their appearance or overlay glass. Prefer a matching `GlassIconButton` for back/close and `GlassMenu` with a deliberate trigger, or `GlassPullDownButton` with `GlassMenuItem` entries. Verify these APIs against the installed package before implementation. Supply meaningful localized `semanticLabel` values for icon-only controls, consistent hit regions and icon weight, and correct back/dismiss/focus-return behavior. Keep debug/scenario actions available and intentionally styled.

Inspect the opened overlay, not just its trigger: menu positioning, long labels, selected/disabled rows, safe edges, dismissal, and neutral/legible material over actual content. Wrapper keys or labels may not reach an inner actionable child; inspect the runtime tree and place stable keys on actual controls where the integration allows it. Never replace an accessible control with an unlabeled tap detector to obtain a particular appearance. Provide a coherent solid alternative rather than mixing unrelated bare controls into a glass bar.

Set all structural surfaces to deliberate greyish off-white/off-black, including scaffolds, cards, fields, menus and solid fallbacks. A seed color or default surface tint must not leak accent into the canvas. Glass can reveal underlying content, so check composited contrast rather than assigning it a nominal background color.

Check the toolbar’s constraints against its children. In installed 1.11.1, `GlassAppBar` defaults to a 44-point `toolbarHeight`; a `GlassIconButton(size: 48)` in that row is constrained to 48×44, so its oval becomes visibly flattened. Coordinate button size and toolbar height through shared geometry, then verify actual rendered width/height and hit bounds. Do not shrink the accessible target merely to hide the mismatch; allow enough toolbar space for the chosen controls and title.

For the floating glass navigation pattern, keep `GlassScaffold(extendBody: true)` so the scroll viewport extends beneath the bars. `false` deliberately confines the body between them and is appropriate only for a specifically chosen non-overlapping layout. Put initial top clearance and final bottom clearance in scroll content padding or slivers; do not wrap the whole scroll viewport in outer bar-sized padding or a redundant `SafeArea`. Clearances depend on the actual bar geometry, safe areas, and keyboard handling, applied once. Verify both initial placement and the scrolled state, including a fully reachable final action and retained scroll position. Choose edge effects for readable chrome without treating a visually empty strip as proof that content is behind glass.

Initialize the actual binding before `LiquidGlassWidgets.initialize()`, then use `LiquidGlassWidgets.wrap()`. For a `MaterialApp`, supply `brightnessResolver: Theme.maybeBrightnessOf` so glass follows the app theme. Keep app-wide glass settings central. `GlassScaffold` manages background, bar placement, and edge effects; verify who owns body-content insets in the installed implementation rather than assuming automatic spacers. In 1.11.1, `extendBody: true` positions the body full-size, but its build path does not insert the top spacer described in its comments; avoid manually stacking repeated filters around glass controls. Nested refractive wrappers can damage rendering and interaction.

The reference app exercises these APIs and journeys; a runnable fixture is not automatic evidence of finished visual craft. Inspect its child controls, opened overlays, and resolved colors against the current guidance. Verify the following names against the installed package:

```text
WidgetsFlutterBinding.ensureInitialized();
await LiquidGlassWidgets.initialize();
runApp(LiquidGlassWidgets.wrap(
  brightnessResolver: Theme.maybeBrightnessOf,
  child: const MyApp(),
));

GlassScaffold(
  extendBody: true,
  appBar: GlassAppBar(
    toolbarHeight: 48, // Match 48-point glass controls when present.
    title: const Text('Discover'),
  ),
  bottomBar: GlassTabBar.bottom(
    selectedIndex: selectedIndex,
    onTabSelected: selectTab,
    tabs: const [
      GlassTab(icon: Icon(CupertinoIcons.compass), label: 'Discover'),
      GlassTab(icon: Icon(CupertinoIcons.bookmark), label: 'Saved'),
    ],
  ),
  body: content, // Scroll viewport fills the shell; content owns bar clearance.
)
```

With Marionette, initialize `MarionetteBinding` first in debug and the normal Flutter binding otherwise; do not initialize two bindings. Use normal app widgets in unit/widget tests rather than calling the instrumented `main()`.

Check reduced motion, large text, mixed-direction labels, focus/semantics, scroll behind bars, and light/dark/high-contrast appearance. The package approximates reduced transparency using increased contrast; this is not the actual iOS setting. Use a supported native bridge or explicit app preference when exact transparency behavior is needed. Profile shaders and raster work on target devices, provide a legible lower-cost/solid fallback, and do not infer native UIKit hosting or guaranteed frame performance from an iOS-style appearance.

## Sheets that preserve the task

Use [Smooth Sheets](https://pub.dev/packages/smooth_sheets) for new modal, persistent, or multi-page sheet flows. Its documented components include `Sheet`/`SheetViewport`, `ModalSheetRoute`/`ModalSheetPage`, platform-styled modal routes, and `PagedSheet`. Integrate with the current Navigator/router rather than inventing page-index navigation. Verify the installed version’s scroll coordination, snap grid, keyboard dismissal, content scaffold, safe-area placement, barriers, and dismissal policy.

Keep drafts and selection above sheet/page transitions; protect unsaved work consistently across drag, system back, and close. Do not add competing vertical recognizers to scrolling content or apply keyboard/safe-area insets twice. Recheck compact phones, large text, and hinge-safe foldable regions. Adaptive dialog conversion is a product/layout decision, not a guaranteed package behavior. Preserve focus, labels, useful exits, and reduced-motion behavior.

## Purposeful 3D tilt

Use [Motion](https://pub.dev/packages/motion) for tilt/parallax, not as a general flip/orbit engine. Initialize `Motion.instance` once after the app binding, then compose `Motion` or `Motion.only`. Keep labels/actions legible; reduce amplitude, avoid essential reading surfaces, and return a static child under reduced motion or unavailable sensors. Pause unnecessary sensor-driven work with the app/route lifecycle. Test the mobile implementation on hardware; a simulator does not establish sensor behavior.

Verify platform setup and availability against the installed plugin; do not add a sensor permission dialog without a native requirement. Check the actual dependency license: Motion is published as GPL-3.0, while this skill edition’s own material remains MIT.

## Integration examples and maintained evidence

This repository keeps isolated, analyzed examples for the preferred packages, separate from the SDK-only recipes and the reference app. See the edition's validation guide for resolved versions and actual test results. The examples demonstrate sequence composition, motor retargeting, Heroine observer setup, sheet composition, Motion tilt/static alternatives, centralized font selection, the `Ionicons` API, semantic chart values, and owned Rive/Lottie loaders. Illustration assets and production font bundles remain product-specific inputs; analysis alone does not prove their playback or offline loading.

For `heroine`, wire `HeroineController` into the actual navigator (including relevant nested navigators). For `motor`, preserve current velocity when redirecting, with matching coordinate units. For `flutter_animate`, own autoplay/replay and reduce motion rather than replaying lazy-list entrances. Keep charts truthful; spring motion is not a reason to distort live values. Dispose authored animation loaders/controllers and preserve a static/status alternative.

Do not hard-code a floating “latest” version in skill prose. Pin resolved versions in validation fixtures, record the tested Flutter/Dart toolchain, and check the target app's compatibility before adding a library. Optional specialists such as draggable page packages require the same evidence; they are not additional default dependencies.
