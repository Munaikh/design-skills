## Make Flutter feel native on the declared platform

Abdullah AlMunaikh’s modified Flutter edition, based on Emil Kowalski’s original skills.

The user's real device is the source of truth for touch feel, keyboard, system insets and navigation. A simulator/widget test is useful evidence, not proof of hardware feel. Apply each fix where its reason applies; support touch and pointer together rather than guessing from width or user-agent/device names.

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

