# Mobile user experience

Design the task and its recovery before choosing visual treatments.

## A brief proportional to the work

For substantial work, describe: who needs to do what, in which context; how they enter; the shortest understandable primary path; completion evidence; and likely interruptions/recovery. Use actual content and existing product constraints. State unknown product facts rather than inventing them. Keep this brief in the working response unless a complex flow or requested handoff needs a document. A local control repair needs only its intent and acceptance check.

Do not simply port web screens into mobile. Preserve the product's purpose while reconsidering steps, information density, navigation, one-handed use, contextual actions, permissions, and keyboard behavior. Desktop navigation, sidebars, large tables, hover discovery, and long forms need mobile-specific decisions. Avoid imposing a single mobile aesthetic or adding onboarding to a task that already works.

## Navigation is a product contract

- Define primary destinations, ownership of each tab's stack, drill-down versus temporary modal tasks, entry points/deep links, and the useful destination after completion. Tabs are peers, not steps in a wizard.
- Preserve existing router semantics. iOS back gestures, Android system/predictive back, explicit close, and modal dismissal must follow the same work-preservation policy. Do not replace a real navigator with visual swapping that breaks back or deep links.
- Retain drafts, selected records, filters, scroll position, and intended destination across route changes, tab switches, authentication/permission detours, and resizing as the product requires. Distinguish in-session continuity from process-death restoration or persisted data; test the latter before claiming it.
- Let people understand where they are and what will happen. Use recognizable action labels, useful titles, predictable grouping, and one clear primary action where appropriate. Extra steps need a reason.
- Preserve search context when returning from a result. Explain destructive actions, offer undo/recovery where appropriate, and avoid losing work on accidental dismissal.

## State, input, and recovery

Model loading, empty, no results, partial content, offline, permission denial, actionable error, cancellation, and completion where the feature actually needs them. Keep useful content usable during refresh. Place errors near their cause and preserve input on retry; a transient toast cannot be the only recovery path.

Use progressive disclosure for secondary detail rather than concealing essential actions. Forms need suitable keyboard, submit/next behavior, autofill, paste, inline validation, and a focused field/action above the keyboard. Request permission when its value is apparent, support denial, and preserve a manual alternative where available. Do not invent account/permission requirements for a task that needs neither.

Accessible task completion includes touch, screen-reader semantics, large text, RTL, focus, and keyboard input when supported. Make controls reachable and state changes understandable. Motion communicates relationship and status; it must not block interaction or turn routine work into a presentation.

## Phones first, then foldables

Use `LayoutBuilder` for allocated space and `MediaQuery` for window/insets/display features. Breakpoints follow actual content requirements, not device brands or orientation alone. Narrow phones need readable single-column flows; unfolded windows can justify a list/detail layout or navigation rail when it helps the task. Large text can require the simpler composition even in a wide window.

For hinges or display cutouts, keep controls and readable content in usable regions. Distinguish a non-occluding fold from an obstructing hinge; partition at display-feature bounds only when necessary. Keep durable state above adaptive layout boundaries so folding, unfolding, rotation, and window resizing do not recreate a draft or reset navigation. Avoid orientation locking as an overflow fix.

For new journeys or adaptive layout changes, exercise a compact phone and the relevant wide unfolded window, occluding hinge, landscape, keyboard, large-text, and RTL conditions on supported targets. Preserve selection, draft, scroll, and task completion through both directions of affected transitions. Scope small repairs to the conditions they can change, and identify unavailable device/posture checks rather than requiring an unrelated full sweep. Responsive improvements benefit tablets, but record actual tablet checks separately. Posture-specific tabletop behavior is a product requirement, not an automatic addition.

## UX acceptance

Observe whether someone can enter, identify the next action, complete the task, understand the outcome, go back, and recover without losing work. Test the real app with [Marionette](marionette-testing.md) when available, and use controlled widget tests for deterministic state/layout behavior. Compare complete tasks in working prototypes when alternatives were requested. Scope improvements to the authorized feature; explain material changes and ask before changing business rules, removing capabilities, or expanding scope.

Sources: [Flutter adaptive design](https://docs.flutter.dev/ui/adaptive-responsive), [display features](https://api.flutter.dev/flutter/widgets/MediaQueryData/displayFeatures.html), [accessibility](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility).
