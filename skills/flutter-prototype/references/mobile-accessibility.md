# Accessible Flutter mobile interaction and recovery

Abdullah AlMunaikh’s acceptance guide for meaningful mobile UI changes. Use the relevant checks for the requested feature; preserve the app’s established controls and accessibility architecture.

## Meaning is part of the component

Prefer a semantic platform/product control over a bare tap region. Icon actions need a localized label; selected, disabled, expanded, busy, and error states must be understandable without color. Keep one semantic source for an interaction even when several visual layers animate. Exclude decorative copies and unavailable outgoing controls from focus, hit testing, and semantics.

A keyboard `FocusNode` and assistive accessibility focus are distinct. Requesting input focus alone does not prove VoiceOver/TalkBack moved to the intended recovery control. Inspect the semantics tree and exercise the actual assistive navigation path when claiming that behavior. Avoid announcing every animation tick or progress pixel.

Use 48 logical pixels as a useful common minimum tappable area, respecting the target platform’s rules and actual layout. Hit areas must fit within a hittable parent and not overlap neighboring actions. Scaling a visual should not shrink its reliable touch region. Support cancellation rather than activating an irreversible operation on raw touch-down.

## Text, contrast, and direction

Honor system text scaling; do not clamp it globally to conceal overflow. At large text, allow multiline labels, taller controls, wrapping actions, and simpler composition. Test actual platform scaling as well as a controlled `TextScaler.linear(2)` fixture; the latter does not reproduce every nonlinear system setting.

Check meaningful contrast in light, dark, and high-contrast themes over actual backgrounds. Error/success uses wording and recognizable status in addition to hue. Use directional padding and alignment, mirror directional symbols appropriately, and verify mixed RTL/LTR identifiers remain readable and copyable. Critical values cannot disappear into ellipsis with only a pointer tooltip as the reveal path.

## Reduced motion and material preferences

Read `MediaQuery.disableAnimationsOf(context)` in a dependency-aware place and respond when it changes during flight. Replace nonessential travel, scaling, rotation, parallax, bounce, and loops with static state or a short meaningful fade/color response. Preserve honest progress and usable actions. Do not substitute a permanent spinner or hide content entirely.

`accessibleNavigation` and high contrast are separate signals. Flutter has no universal reduced-transparency query; use an explicit app setting or a supported native bridge when the feature requires it. Floating translucent surfaces need a legible solid fallback. Haptics are supplemental; visual/semantic state must stand alone.

## Focus, dismissal, and recovery

When a route, menu, sheet, or row disappears, move focus to a useful surviving target and preserve position. A retry/discard flow should:

1. Keep the person’s draft, selected item, and nearby list position unless the action intentionally changes them.
2. Identify the next enabled control after the mutation; a disabled or removed action is not a recovery target.
3. Reveal that target using the existing scrollable where needed, with immediate movement under reduced motion.
4. Transfer the appropriate input focus, preserve a coherent semantics order, and announce the resulting state once.
5. Handle a second failure or cancellation without jumping back to the top or losing other pending work.

Validate recovery in a scrolled multi-item list, with multiple failures and intervening disabled actions. A debug label or successful callback is insufficient evidence that the control is actually visible and reachable.

Dialogs/sheets preserve an accessible exit and return to a useful trigger or fallback if the trigger vanished. System back, iOS interactive back, Android predictive back, close button, and drag dismissal should agree with the same unsaved-work policy. Use the app’s route ownership and supported `PopScope` semantics rather than an animation that traps the route.

## Feedback and time

Inline errors stay associated with the field/task and offer a clear next action. Transient notices cannot be the sole record of an actionable failure. Complex messages and undo actions need enough reading/interaction time; preserve framework accessible-navigation behavior and define persistence explicitly in a custom host.

Routine status does not steal focus. Announce meaningful changes at a reasonable rate, deduplicate repeated async events, and keep a stable operation identity. Cancel stale operations/listeners and timers at the owned lifecycle boundary. A timeout while the app is inactive must not make unique recovery disappear unseen.

## Evidence

Widget tests can verify semantic labels/actions, traversal exclusions, large-text constraints, deterministic reduced-motion state, and recovery logic. Integration and device checks establish actual VoiceOver/TalkBack traversal, hardware keyboard behavior, gestures, keyboard clearance, and platform back. Report which were performed. Do not equate a screenshot, focus flag, or animation completion with accessible task completion.

Sources: [Flutter accessibility](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility), [Flutter gestures](https://docs.flutter.dev/ui/interactivity/gestures), [Flutter semantics](https://api.flutter.dev/flutter/semantics/SemanticsNode-class.html).
