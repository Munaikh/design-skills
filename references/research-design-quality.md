# From reference to Flutter experience

Adapted from Appllama's app-design principles and this suite's Flutter conventions. Use task acceptance criteria rather than claims of perfection or superiority.

## Make the direction concrete

Reuse an existing design system and redesign its components only when asked to redesign the feature. For a new app, explain the concrete component and interaction decisions, not just adjectives such as clean, neutral, or premium. iOS is the default target; follow [toolkit](toolkit.md) for native iOS 26+ tabs, custom older-iOS support, and the older-OS question for simple apps. Android adapts product identity while preserving its conventions. Keep copy direct and let controls, hierarchy, and microinteractions explain the journey.


State the journey and visual direction before implementation: primary task, hierarchy, type roles, neutral surfaces, accent roles, shape/spacing scales, icon family, and the reason it fits this product. Preserve approved branding; an unfinished seed theme is not a design decision. Keep semantic success/warning/error colors distinct from the brand accent. Consistent labels express the same intent. Assets share an intentional palette and illustration language; generate artwork only when it serves the task, and use licensed production assets.

Design substantial new journeys in the requested editable design tool before coding when the user wants design-first delivery. A one-shot implementation request authorizes choosing and implementing the direction without an extra approval stage. Keep a concise design rationale in the response instead of creating an unsolicited design document or prototype app.

## Navigation and state

For each destination specify its role (push, modal task, short sheet, tab root), entry, back/dismissal behavior, and state retained. Use the project's router; distinguish global onboarding/auth completion from contextual sign-in or unlock that should return to the initiating action. Prevent re-entering completed one-way flows without sending every completion to home. Preserve deep-link context and per-tab place. Back should dismiss transient UI before leaving; avoid trapping users. Explain unsaved-work handling and requests in flight with visible recovery.

Define loading, empty, success, failure/retry and interrupted states. Keep drafts and selection when an operation fails. Use optimistic updates only when failure is recoverable and reconciliation is safe; do not pretend an irreversible action succeeded. Preserve the app's existing server/client/local state architecture.

## Translate intent faithfully

Use semantic `ColorScheme`/`ThemeExtension` roles and `TextTheme`, appropriate Cupertino/themed controls, actual safe-area and keyboard constraints, and the project's navigation primitives. Use lazy builders/slivers for large lists, stable identity, appropriately sized images, and localized copy/numbers. Do not blindly wrap every screen in a scroll view or replace the app's state layer.

Follow the packaged toolkit: Flutter Animate/implicit widgets for local effects, Motor for interruptible physics, Heroine for shared elements, Smooth Sheets for sheets. Platform navigation remains platform-appropriate. Make microinteractions core and use frequency to tune amplitude and duration; preserve gesture position/velocity, interrupted interaction and reduced motion. Do not import another runtime's threading, input or compositing assumptions into Flutter. Profile both UI and raster work when performance is at issue.

## Verify the experience

Run the actual app, inspect light/dark and long/large text, opened menus, focus/error states, safe areas and scroll endpoints. Exercise completion, recovery, back, tab return, rapid taps, draft retention, and keyboard appearance/dismissal for the changed journey. Use Marionette for Flutter state; native controls need native automation. Capture a short flow recording when evaluating motion, watch at normal speed and inspect suspicious frames. Store it temporarily and report inability to inspect motion honestly.

Screenshots establish captured appearance, not touch behavior or frame timing. Keep UX, visual, motion and performance outcomes separate. For performance-sensitive work use measured profile UI/raster timings on the declared device and refresh rate, then release-device feel checks; debug simulator recordings do not certify sustained performance. Report untested hardware, assistive traversal, haptics and platform behavior precisely. Fix observed defects within scope and recheck affected paths; stop when acceptance criteria pass or an explicit external limit prevents further validation.
