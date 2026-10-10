## Make Flutter feel native on the declared platform

The user's real device is the source of truth for touch feel, keyboard, system insets and navigation. A simulator/widget test is useful evidence, not proof of hardware feel. Apply each fix where its reason applies; support touch and pointer together rather than guessing from width or user-agent/device names.

## Inspect the whole navigation surface

For visible UI work, inspect the top bar with its back/close control and trailing actions together, then open the relevant menus. Check matched control shape, dimensions, icon weight, insets, title baseline, foreground contrast, and pressed/focus/disabled behavior. A platform-styled shell does not style its children or menu overlay automatically. Preserve action availability, route ownership, drafts, and accessible dismissal, including debug/fixture actions when present.

On iOS, prefer the installed `liquid_glass_widgets` app bar and coherent glass back/action controls where glass suits the feature. Its `GlassMenu` and glass button controls provide an intentional menu path; verify the installed API and actual semantics rather than wrapping an unrelated stock popup inside a glass shell. Check long menu labels, large text, safe-area anchoring, dismissal, and a legible solid fallback. On Android, use intentional product or themed Android controls with appropriate back/navigation behavior; do not impose Apple glass as a universal style. See [toolkit](toolkit.md) and [theme patterns](theme-patterns.md).

Use neutral greyish off-white/off-black structural surfaces in both themes, including cards, fields, and menu surfaces. Do not let a seed accent or elevation tint color the whole interface. Accent communicates a deliberate action/selection; semantic status colors convey meaning. Inspect actual composited contrast over glass, not merely the foreground token. Maintain no-splash feedback and shared, restrained depth.

Verify control geometry after layout: a circular button needs equal rendered width and height, not merely a square requested size. Parent toolbar constraints can compress it; adjust shared bar/control geometry rather than accepting distorted chrome. Check the actual hit region, title fit, and large-text state.

For floating glass bars, verify that the scroll viewport reaches behind the chrome. Place bar/safe-area clearance inside scroll content so initial and final items remain accessible while intermediate content can move under the bars. Outer padding, duplicate safe areas, or `extendBody: false` can create an empty reserved strip instead. Read the installed scaffold implementation and inspect a genuinely scrolled state; do not assume documentation about automatic spacers matches its build path. See [toolkit](toolkit.md).

| Symptom | Flutter port and reason |
| --- | --- |
| Hover stuck or touch action hidden | Derive hover from actual pointer enter/exit and widget interaction state; clear it on exit/cancel/unmount. Never infer mouse capability from a wide layout. Preserve visible touch and keyboard actions |
| Unwanted heavy tap flash | Disable ink splashes/ripples with the shared no-splash theme and check local overrides. Design visible pressed/focused feedback and preserve semantics; use custom product controls or deliberately themed primitives, not bare taps |
| Shell/bottom action wrong height | Use actual parent constraints with `LayoutBuilder`; inspect `MediaQuery` size/insets. Do not use a fixed screen-height assumption |
| Input/keyboard crops the task | Use `Scaffold` keyboard resize behavior and `viewInsets` deliberately; scroll focused content into view, avoid double-padding. Honor system text scaling |
| Tap feels laggy | Immediate press feedback through control states or tap-down/cancel; perform the action after recognized activation (`onTap`), not on raw pointer-down. Never trigger an irreversible action before the gesture resolves |
| Scroll conflicts or inappropriate refresh | Preserve target-platform scroll physics; use `RefreshIndicator` only where refresh is intended. Coordinate nested scrollables and sheet scrolling; do not globally suppress bounce/scroll to hide a recognizer conflict |
| Notch/home indicator overlaps content | Paint backgrounds edge-to-edge where intended, then protect interactive/content areas with `SafeArea` and appropriate padding. Account for bottom overlays and keyboard once, not twice |
| Control labels select or content cannot be copied | Keep buttons nonselectable; allow body content, addresses, error messages and identifiers to be selected/copied via `SelectionArea`/`SelectableText` or the established detail pattern |
| Carousel fights vertical page scroll | `PageView`/horizontal scrollable with native axis physics; coordinate gesture arena and sheet/content ownership. Avoid all-axis `onPan` recognizers where axis-specific drag suffices |
| Status/navigation bars clash | Use the project `AppBar.systemOverlayStyle`, `AnnotatedRegion<SystemUiOverlayStyle>` or system UI integration for legible icons and target SDK edge-to-edge behavior. Do not assume a status-bar background color is honored on every Android target |
| Back/swipe dismissal loses work | Preserve target router/back behavior, restoration and unsaved work; use current back handling APIs for the installed SDK. Expose a labeled close/back alternative to a gesture |
| Fine in a simulator, wrong on phone | Exercise a real supported iOS/Android device, keyboard open, landscape, large text, light/dark mode and gestures. Also verify native platform integration on actual hardware |

Field configuration follows intent: `keyboardType`, `textInputAction`, `autofillHints`, capitalization, autocorrect, input formatters and focus traversal. Numeric codes are not monetary amounts; keep leading zeros and paste/autofill intact. Preserve system magnification and text-size accessibility.

Respect declared target conventions and use the product’s semantic components or deliberately themed primitives. Flutter Material/Cupertino widgets are not automatically UIKit or Android native views. Native feel does not mean forcing an Apple appearance onto Android or importing Cupertino widgets indiscriminately. Report platform fixes briefly: **what was wrong**, **what changed** with locations/reason, and **what still needs hardware**. Do not claim hardware validation from simulator checks.

