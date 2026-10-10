# Product personality and motion

These translate the source's examples and cohesion principle into Flutter decisions, not templates to copy. Derive the visual thesis from actual app identity and content. Keep the same motion tokens across related components.

## Fast repeated productivity

The source's Raycast example opens without choreography because it is used hundreds of times a day. A Flutter command palette, shortcut, peer-tab switch, or repeated selection should be immediate. Preserve standard platform navigation and scrolling; remove added decorative motion. Keep focus and active-state contrast clear. Do not hide work behind an entrance sequence.

In form-heavy apps, validate inline and keep error recovery near the field. Make saving and completion legible without moving the user's input target or dropping their draft. A calm aesthetic can support trust, but calm is not the only acceptable brand.

## Cohesive transient feedback

The original feedback-component lesson is a whole coherent experience: excellent defaults, easy adoption, invisible edge-case handling, memorable identity, and motion matching personality. Port the behavior into the project's `ScaffoldMessenger` or overlay service, with the existing Flutter primitives. An elegant notification can use gentler timing than a crisp dashboard if the wait does not impede the task. Keep enter/exit paths consistent, support interruption, and pause or persist meaningful feedback when the app is inactive.

Do not copy the source's download count as a timeless claim. The reusable lesson is the quality of the component, not its current popularity.

## Touchable cards and media

For a gallery or media app, the content is the visual identity. Keep chrome quiet and preserve continuity from thumbnail to detail with stable Heroine tags and Motor-based physics. Dismiss along the spatially consistent path; hand off release velocity into a spring and let a re-grab interrupt it. Give an explicit accessible close action as well as a gesture. Avoid replaying entrance choreography on every lazy-grid rebuild.

The source's Dynamic Island example illustrates responsive physical state changes, not permission to reproduce Apple branding. Use continuity only where it helps someone understand a changing surface.

## Information and finance

The source contrasts decorative pointer tracking with a functional banking graph: moving information someone is reading or acting on is harmful. In a Flutter information dashboard, favor stable values, numeric alignment, strong grouping, and semantic status colors. Do not spring live data merely to make the screen feel alive. If an interpolation helps understanding, expose the actual value and honor reduced motion. Dark/light and high-contrast states need deliberate testing.

## Rare first-use delight

Onboarding, explanatory demonstrations, and meaningful celebrations have a larger motion budget because they are rare. Match easing, type, materials, and motion character to the intended emotion. Stagger lightly; keep actions usable from the start; let people skip or reduce motion. Delight comes from getting the other design principles right, not from adding confetti to an unresolved task.

## Fresh eyes

The source's list opacity/height example has no universal formula: tune the coupled change until it feels right. Use `AnimatedSize` or a suitable list transition when real reflow is necessary, isolate the affected subtree, and measure it. Review at normal speed, then slow motion/frame by frame, then again with fresh eyes. A screenshot or passing widget test cannot verify physical feel on hardware.
