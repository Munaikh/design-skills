## Prototype genuinely different directions

Use when the user explicitly requests variants or an exploration. Size the prototype to the design question: one component for a local interaction, or a complete short journey when navigation, recovery, or task completion is the question. State the bounded task and give every variant the same entry point and completion criteria. Keep production source unchanged during exploration; use isolated fixtures and fake side effects. A normal implementation task builds directly in the user’s app and does not require a prototype app. Integrate only the selected variant; an explicit prior selection already supplies the choice.

1. Restate the task or component, its entry point, where it lives, and how completion will be recognized.
2. Inspect SDK, project structure, shared tokens, neighbors, sizes, inputs, product personality, and state architecture. With no app, create a small runnable Flutter prototype project with a restrained neutral palette, one accent, and platform text; exercise the actual mobile widget behavior.
3. Default to **three variants**, up to five for a requested wide exploration. Before coding, give each a meaningful name and named axis: layout, density, personality, motion story, or interaction model. Three accent colors are one direction. Every variant must be defensible on its own and meet the same craft/accessibility bar.
4. Build an isolated prototype entry point or dev-only route, one file per variant plus a harness. Production code must not import from prototypes. Use realistic content and working interactions; no dead buttons, lorem ipsum, or imagined behavior.
5. Render **one variant at a time, full size, in realistic surroundings**. A toast needs a page; a button needs its form. Thumbnail comparisons distort the interaction. Switching is instant because it happens frequently. A keyed subtree `(variant, replayCounter)` re-creates the variant for entrance replay without restarting the entire app.
6. Run each variant, exercise every action, inspect exceptions/overflow/semantics, and capture each when tooling permits. Mechanical validation cannot certify feel; record what was actually seen.

Required handoff table:

| # | Variant | Axis | When it's the right choice | Its cost |
| --- | --- | --- | --- | --- |

Give the running target/entry point and picker shortcuts. Let the user choose when the task is exploration. Do not pre-pick a favorite unless asked; recommend from product purpose and frequency when asked. If variants converge during implementation, cut one and state why. `riff <variant>` creates fresh directions around it. `keep <variant>` integrates following local conventions and removes the prototype surface; retain the harness if requested.

### Fixed Flutter picker contract

The picker is harness chrome, not a contestant. Keep this appearance stable rather than applying the app's brand tokens. Use the fixed Flutter harness style rather than treating it as product design advice.

- Floating dark pill, bottom-center, 24 logical pixels outside the safe area content edge; move to top-center only when the preview occupies the bottom-center. Allow safe-area/keyboard clearance and scrolling/adaptive wrapping when names do not fit; no clipped or inaccessible picker.
- Background greyish off-black (`#171717`) at 0.82 opacity, off-white (`#EEEEEE`) inset/hairline border at 0.08, restrained dark shadows (blur 24/offset 8/opacity 0.24 and blur 6/offset 2/opacity 0.12). These are harness defaults adapted to this edition's neutral-surface policy. Use a clipped 12-sigma `BackdropFilter` only if it performs; the source saturation effect has no required one-property Flutter equivalent.
- Outer padding 4, gap 2, pill-shaped corners. Neutral platform font, text size 13. Active text white, inactive white at 0.55, actual hover white at 0.85. Preserve visible focus with a white 0.4 outline, 2 logical pixels thick and offset 2.
- Active highlight white at 0.12. Source visual rows are 28 high with 12 horizontal padding; **expand hit targets to platform/accessibility minima** instead of using undersized targets. Divider 1×16 with 4 horizontal margin; replay has 10 horizontal padding and text/icon size 14.
- Initial highlight settles without animation. Eligible pointer switching may move the highlight over 250ms with `Cubic(0.23, 1, 0.32, 1)` as orientation feedback; the preview itself switches instantly. Keyboard switching and reduced-motion settings keep highlight and preview instant. Hardware keyboard switching stays immediate.
- Show replay and divider only when at least one variant has replayable motion. Expose “Replay animation (R)” to semantics and a tooltip. Exactly one item is selected in semantics at all times.
- Number keys `1–N` and left/right arrows switch; `R` replays. Ignore shortcuts inside text editing or when modifiers are held. Use scoped `Shortcuts`/`Actions`/focus routing and do not steal keys from the preview's fields or menus.
- Preserve selection across restarts using route restoration or an explicit local harness setting. Clamp invalid indices to variant one. Do not introduce persistent dependencies solely for a picker.
- Dispose each variant's controllers, listeners, subscriptions, and owned overlays on remount. Replay resets prototype state only; it must not issue real network actions or duplicate production operations.


Use [mobile UX](mobile-ux.md) to define journey acceptance and [Marionette](marionette-testing.md) to exercise each runnable variant. Keep a selected direction’s real navigation, work preservation, and recovery behavior when integrating.
