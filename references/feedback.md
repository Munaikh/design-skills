## Flutter feedback service

Abdullah AlMunaikh’s modified Flutter edition, based on Emil Kowalski’s original skills.

Use one intended feedback host, stable identity, an update/dismiss lifecycle, and durable recovery through the existing Flutter primitive or service. A new custom stack is warranted only when the product requires it. An error, actionable recovery, or operation history must remain available beyond an ephemeral toast.

### Choose the feedback surface

- **Inline/form feedback** for errors tied to a field or context, persistent operation status, and recovery.
- **`ScaffoldMessenger` with `SnackBar`** for ordinary transient queued acknowledgment/undo. One scaffold displays one at a time; repeated calls queue. Multiple registered scaffolds under one messenger may display the same snackbar, so choose messenger scope intentionally.
- **`MaterialBanner` or existing banner** for continuing contextual notices that need space and action.
- **Dialog/sheet** only when a decision genuinely blocks progress; do not turn simple toast feedback into a modal.
- **Owned overlay service** for a requested custom stack or surface beyond the existing native primitive. Prefer existing vetted service/package first; support theme/localization/media context, focus/semantics, insets, route order and disposal explicitly.

### Service contract, not an invented package API

If a new abstraction is necessary, define typed records for message identity, semantic type (plain/success/error/info/warning/loading), title, optional detail, action/cancel behavior, duration/persistence, destination host, and callbacks. API names are project decisions, not functions promised by Flutter or a package.

| Behavior | Contract |
| --- | --- |
| Host | One app-level host per intended scope, mounted predictably; do not add a host on every route. Scoped hosts have explicit destination IDs so a message is not broadcast accidentally |
| Show | Called from activation/state-transition handlers or deduplicated listeners, never as a side effect of `build` |
| Identity | Stable ID deduplicates repeated events and updates loading → success/error; IDs also key stack motion and dismissal |
| Update | Change only specified fields, preserving identity/order/current position; define whether a meaningful update resets duration. Repeated retries must not create piles of stale messages |
| Future lifecycle | Show loading once, then update the same message from `Future` result/error. Resolve to a durable inline state as needed. Ignore late completion when its operation has been canceled/replaced; do not re-create an already dismissed toast unintentionally |
| Duration | Default informational transient duration 4 seconds when readable; longer/more complex content and actions need appropriate time or persistence. Loading persists until settlement/cancel; meaningful failure/recovery persists in the product even after the transient message closes |
| Dismiss | Single/all dismissal explicit; user, timeout, action, cancel, programmatic removal, and host disposal are distinct close reasons. Callback fires once; disposal is not a successful completion |
| Actions | Label and consequence clear; specify whether completion dismisses. Async/retry actions show their status, preserve durable context, and disable duplicate submission without trapping focus |
| Active messages | Service can expose current records to the owning host; UI does not need global widget context or static event access to inspect state |
| Theme/icons | Inherit current product theme and semantic text/icon colors; use existing icon system. Success/error do not rely on hue alone; icons may be suppressed without losing the semantic meaning |
| Tests | Stable keys/IDs and observable close reasons; widget tests for queue/update/expiry/cancel/disposal and accessibility where the service is new or changed |

Default custom-stack starting points retain the source's small scale: **at most three visible** messages, **14 logical pixels** between expanded items, **32** edge inset on roomy layouts and **16** on constrained ones, then add appropriate safe-area/keyboard clearance. Default bottom-end only when it fits the platform/task; bottom-center is often more suitable on phones. Use `AlignmentDirectional` and actual available width, with RTL-aware placement.

Collapse/expansion must work by touch and keyboard as well as hover. Offscreen/collapsed records cannot contain invisible focusable actions. Queue/coalesce beyond the visible limit; never silently discard unrecoverable errors or unique actions. Do not pile errors above a keyboard or cover the primary task. Entrance/exit and restacking must retarget from current positions and honor reduced motion; keyboard/high-frequency handling stays immediate.

### Timer and ownership lifecycle

For custom overlays, start timeout after the message is actually visible, using a remaining-duration/deadline policy. Pause while the user hovers, focuses an action, interacts/drags, or the app is not resumed; resume the remaining time rather than restarting or consuming unseen time. Honor accessible-navigation timing needs: actionable/complex feedback may need persistence. Timer policy and stack expansion must never require hover to understand a message.

Cancel timers and operation listeners on host/service disposal; remove/dispose owned `OverlayEntry`s/controllers correctly; guard asynchronous state/context access after disposal. `OverlayPortal` keeps inherited context and prevents its child outliving the portal, but its semantics can disappear if the portal owner is offscreen; root-owned feedback should not be attached to a lazily hidden list item. Handle route/modal ordering deliberately rather than assuming overlay ordering is automatic. An overlay above a modal must still respect the modal's focus barrier and accessibility scope.

Use native snackbar lifecycle where adequate rather than emulating it. `ScaffoldMessengerState.showSnackBar` returns a controller with a `closed` future/close reason; `hideCurrentSnackBar` animates out and `removeCurrentSnackBar` removes immediately. It cannot be called during `build`. On SDKs supporting `snackBarAnimationStyle`, `AnimationStyle.noAnimation` supplies an immediate path. Newer SDKs expose `SnackBar.persist` and action-dependent persistence; older supported SDKs may differ, so inspect the installed SDK before using the property. Preserve the framework's accessible-navigation behavior rather than assuming every duration expires identically.

### Accessibility and styling escalation

Do not steal focus for routine status. Expose meaningful status through framework semantics/live-region behavior at a reasonable rate, avoiding repeated announcements during every progress tick. Actions and dismissal need proper button semantics, labels, targets and focus indication; swipe is never the only way out. Ensure the full message remains readable at large text and RTL. A disappearing error must not be the only recovery instruction.

Style in order: use the existing product feedback primitive; extend centralized `SnackBarThemeData`/banner tokens; add a reusable typed wrapper for semantic variants; only then build a custom overlay when native behavior cannot meet the brief. Keep styling in the shared theme and typed component APIs. If a custom shell owns layout, it also owns the full stack/timer/accessibility contract.

Troubleshooting: no message → inspect host/messenger/descendant scaffold and event call site; duplicates → duplicate hosts or non-deduplicated listeners/build side effects; wrong theme → detached context or hard-coded style; clipped/behind modal → wrong overlay/messenger scope or placement; never closes → intended persistence, paused timer or unsettled Future; loading stuck → verify operation completion/cancellation; shows everywhere → implicit broadcast/multiple scaffold registrations; overlaps edges/keyboard → safe area and `viewInsets` measured in the actual host.

Official APIs: [ScaffoldMessenger.showSnackBar](https://api.flutter.dev/flutter/material/ScaffoldMessengerState/showSnackBar.html), [SnackBar](https://api.flutter.dev/flutter/material/SnackBar-class.html), [SnackBar.persist](https://api.flutter.dev/flutter/material/SnackBar/persist.html), [OverlayPortal](https://api.flutter.dev/flutter/widgets/OverlayPortal-class.html), [Text scaling](https://api.flutter.dev/flutter/widgets/MediaQueryData/textScaler.html).

