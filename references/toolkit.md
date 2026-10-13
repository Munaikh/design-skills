# Preferred Flutter toolkit

Use this capability map for new mobile features. Preserve suitable product components and existing dependencies first. Use Flutter Animate for effect composition, simple implicit widgets for local targets, Motor for physics, Heroine for shared elements, Smooth Sheets for sheets, and Motion for purposeful 3D tilt. Handwritten controller/tween timelines are reserved for genuinely complex custom mixers. Preserve suitable existing architecture without a gratuitous replacement. Do not install the whole list into an app. Review SDK constraints, lockfile, actual API, license, platform support, lifecycle, and accessibility before adopting a dependency.

Design controls intentionally: reuse product components, create suitable custom components, or deliberately theme semantic SDK primitives rather than using unstyled stock Material everywhere. Disable all ink splashes/ripples with `NoSplash.splashFactory` and transparent `splashColor`, audit overrides, and retain meaningful press/focus/selection feedback. Shadows use shared restrained depth tokens only when they clarify hierarchy, following Emil’s cohesion and attention to unseen details. See [theme-patterns.md](theme-patterns.md).

| Need | Preferred choice | Scope and existing-project guidance |
| --- | --- | --- |
| Native iOS 26+ app bars, tab bars, toolbars and glass controls | [native_liquid_glass](https://pub.dev/packages/native_liquid_glass) | Gate to iOS 26+ and verified package support; custom product components for approved older-iOS support |
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

## Platform and component precedence

Reuse the app's existing design-system components and behavior. Only redesign them when asked to redesign the feature. For new UI without that system, default to iOS and adapt to Android; native iOS chrome and custom product content serve different purposes.

For new or redesigned tab navigation on iOS 26 or newer, always use a real native iOS tab bar where supported. Prefer an existing native integration, then the verified `native_liquid_glass` tab bar. Do not substitute Material navigation or a custom icon row for convenience or novelty unless instructed otherwise. Native Liquid Glass is allowed only on iOS 26+; require both the OS/platform condition and the installed package's availability check. Never render native Liquid Glass on older iOS or Android. This rule does not authorize replacing an existing design-system tab bar during an unrelated fix.

On iOS below 26, use custom product components when older-OS support is requested, not default Material or Cupertino chrome and not a simulated Liquid Glass shell. Reuse the existing design system outside requested redesigns. Android uses its own branch with the same product identity and Android back/input/accessibility conventions.

For a simple new app with no declared support matrix, state an iOS 26+ design assumption and ask how older iOS should behave: support it with custom components, or intentionally target iOS 26+ only. Continue independent iOS 26+ work while waiting, but do not implement a guessed older-OS fallback or change deployment targets without the answer. If unanswered, report older-OS behavior as unresolved; do not claim it is supported. Existing projects retain their declared support range, and a previously supplied answer remains authoritative. If native integration is unavailable on an otherwise supported iOS 26+ target, report the concrete limitation and get direction before substituting custom or Material tab navigation.

Preserve each tab's stack, selection, scroll, accessibility labels, and safe-area ownership. Never let unsupported native widgets silently remove navigation.

## Native Apple navigation

Use [native_liquid_glass](https://pub.dev/packages/native_liquid_glass) for iOS 26+ navigation/control chrome only. It embeds native views through `UiKitView`; `LiquidGlassTabBar` hosts UIKit tabs, `LiquidGlassNavigationBar` hosts a navigation bar, and `LiquidGlassMenu` presents a native menu. Flutter still owns routes, selection, drafts, and content. The package is MIT; inspect the consuming app's pinned version and toolchain before adoption. Verified 0.3.1 requires Dart 3.11 and Flutter 3.41.2 or newer. No package-wide wrapping or initialization layer is required.

**Availability:** iOS 26+ provides the glass appearance. Upstream documentation describes ordinary native styling on older iOS, but the verified 0.3.1 Dart widgets gate native view creation on `NativeLiquidGlassUtils.supportsLiquidGlass` and otherwise return an empty `SizedBox`, including older iOS and Android. This getter is synchronous and lazily checks the OS version; there is no public initialization call. For declared supported targets where it is false, supply the custom product-component path chosen under the policy above. For a new app with undecided older-OS support, keep that choice pending instead of guessing a fallback. Do not lower or raise the app's deployment target merely to hide this limitation; verify the actual locked release and test supported older devices.

Use `LiquidGlassNavigationBar` with `LiquidGlassNavBarItem` for coordinated leading/trailing actions, `LiquidGlassTabBar` with `LiquidGlassTabItem` for peer destinations, and `LiquidGlassButton` or `.icon` for suitable standalone actions. Icons use `NativeLiquidGlassIcon`; prefer fitting SF Symbols on iOS. Item IDs identify callbacks, not router destinations by themselves. Keep labeled back/close and correct dismissal/focus return; do not rebuild native controls as anonymous Flutter tap regions.

The following API outline is not a complete runnable app. Branch to custom product components on Android and on older iOS when that support has been decided and keep callbacks in the existing state/router layer:

```text
LiquidGlassNavigationBar(
  title: 'Discover',
  brightness: Theme.of(context).brightness,
  leadingItems: const [LiquidGlassNavBarItem(id: 'back', label: 'Back')],
  onItemTapped: handleNavigationAction,
)
LiquidGlassTabBar(
  items: const [
    LiquidGlassTabItem(label: 'Discover', icon: NativeLiquidGlassIcon.sfSymbol('compass')),
    LiquidGlassTabItem(label: 'Saved', icon: NativeLiquidGlassIcon.sfSymbol('bookmark')),
  ],
  currentIndex: selectedIndex,
  onTabSelected: selectTab,
)
LiquidGlassMenu(
  label: 'Actions',
  items: const [LiquidGlassMenuItem(id: 'save', title: 'Save')],
  onItemSelected: handleMenuAction,
)
```

### Menus, appearance, and geometry

`LiquidGlassMenu` uses a plain system `UIButton` trigger; its popup is native, but the trigger is **not automatically a matching glass button**. Verified 0.3.1 offers no custom trigger builder. Use at most one native menu trigger per screen because repeated instances interfere with gestures. Where a coherent glass-trigger composition is required, use a verified accessible integration or a deliberate styled fallback rather than placing competing tap layers around the trigger. Preserve debug/scenario actions and inspect both the closed trigger and opened menu. Do not assume an icon-only control has a meaningful native accessibility name: test VoiceOver, use a useful visible label where possible, and verify any native accessibility bridge without duplicating activation or semantics.

The tab bar mirrors `Theme.of(context).brightness`; the navigation bar follows device appearance unless its `brightness` is supplied. Other controls must be checked against native appearance individually. Test app/device theme disagreement as well as matching light/dark modes; a Flutter foreground token does not prove native title/icon contrast. Keep structural Flutter surfaces and fallbacks greyish off-white/off-black; system-driven native material and content imagery are not seed-tinted card backgrounds.

Verify actual platform-view dimensions, hit regions, safe-area ownership, title fit, and large-text layout. Native navigation defaults to 44 logical pixels (96 for a large title), while tab-bar layout includes material overflow beyond its configured height; inspect the selected version rather than sharing one assumed bar height. Keep scrolling content behind chrome in paint order, with initial/final clearance inside scroll content. Use Flutter scaffold extension or a deliberate stack where appropriate; do not put outer bar-sized padding around the viewport and mistake an empty strip for scroll-behind glass. Keep platform views late in paint order and avoid overlapping Flutter decorations above them; those create extra compositing surfaces.

### Overlay ownership and rendering

In verified 0.3.1 the controls observe `ModalRoute.isCurrent` to suppress covered views. An optional `LiquidGlassNavigatorObserver` handles popup routes; inspect existing navigator integration before adding observers, especially nested navigators. Custom overlays and transitions inside the same route need explicit ownership through `NativeLiquidGlassLifecycle.suppressGlassEffects()` / `unsuppressGlassEffects()`. The counter is global and reference-counted: balance each acquired suppression exactly once in `try/finally`, including cancellation, errors, and disposal. Start the protected scope before awaiting suppression because its counter increments before the native call completes. Avoid duplicate manual ownership, unbounded delays, and native-channel calls on unsupported targets; release after the actual overlay/transition lifecycle finishes.

One or two native chrome views per screen is a reasonable starting point, not a performance guarantee. Avoid one per repeated row, profile real-device compositing, and verify overlays cannot paint above or leak behind modal content. Native controls retain system behavior but still need app-level reduced-motion, contrast, large-text, semantics, cancellation, and navigation checks. Screenshots and simulator timings do not establish hardware performance or accessible interaction.

The package also offers sheets and spring helpers; these do **not** replace this edition's Smooth Sheets, Motor, Flutter Animate, Heroine, or Motion defaults. Use them only for a justified native capability within the existing architecture.

Sources: [package documentation](https://pub.dev/packages/native_liquid_glass), [maintainer source](https://github.com/tienanh306201z/native_liquid_glass), and the consuming app's resolved source. Documentation and Dart implementation can disagree; record which version and path established a claim.

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
