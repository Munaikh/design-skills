# Flutter mobile design engineering

Adapted from Emil Kowalski’s craft principles. Use this reference for screen composition and interaction decisions; [motion-patterns.md](motion-patterns.md) and [recipes.md](recipes.md) cover construction.

## Craft is a practiced discipline

Taste comes from studying great work, understanding its purpose, and iterating. Inspect actual interactions and constraints. Unseen details compound: good timing, predictable exits, clear labels, stable layouts, and recovery preserve trust. Visual beauty helps when it makes a useful product cohesive.

Choose a visual thesis rooted in the product: calm reading, efficient task completion, expressive media, or playful discovery. Use real content and suitable existing design-system decisions. Keep structural surfaces greyish off-white/off-black as this edition requires; product character comes through deliberate typography, imagery, accent, composition, and behavior rather than a colored canvas or repetitive rounded-card grid.

## Human needs and principles

Serve safety/predictability, understanding, achievement, and joy.

1. **Purpose:** Spend attention on the task; omit features and decoration without a reason.
2. **Agency:** Preserve choices, cancellation, undo, drafts, and a clear exit.
3. **Responsibility:** Ask for necessary permissions in context; protect work and private data.
4. **Familiarity:** Respect mobile navigation, gestures, controls, and recognizable metaphors.
5. **Flexibility:** Adapt to window constraints, language, ability, input, and context.
6. **Simplicity:** Make hierarchy and the common path clear; hidden controls are not automatically simple.
7. **Craft:** Deliberate type, color, spacing, icons, materials, and behavior earn trust.
8. **Delight:** A coherent useful experience produces delight; confetti cannot repair a broken task.

Every screen should answer where the person is, what they can do, where they can go, and how they can leave. Use proximity to group related content; name destinations specifically. Status, completion, warning, and error each need an appropriate surface.

## Visual system before features

Extend the nearest shared theme for semantic colors, type, spacing, radii, elevation, and motion. Connect custom tokens to framework control themes. Derive hierarchy from weight, size, tracking, leading, contrast, and spacing together. Inspect light/dark and high contrast with actual content, including images.

The canvas and structural surface roles stay neutral: no pure white/black, cream backgrounds, or seed-derived green/purple fills on cards, fields, dialogs, and menus. Choose deliberate grey tones and verify the rendered result, including elevation tint and glass compositing. Accent colors serve actions, selection, or emphasis; semantic status colors communicate real state. A technically readable accent tint is not automatically a suitable structural background.

Prefer system typography unless the product chooses another face. Bundle needed font assets and retain their licenses. At large text, reflow the layout rather than shrink the type. Use directional padding and alignment. Let controls grow to fit translated labels; preserve 44 logical-pixel iOS and 48 Android touch targets, with 48 a useful shared floor.

Use whitespace and grouping before adding boxes. A card indicates a meaningful unit, not a default wrapper for every paragraph. Materials explain hierarchy: floating surfaces need contrast over their actual backdrop, a bounded filter if useful, and a solid fallback. A shape decoration and its clip must agree. Use the project’s shape system or supported superellipse primitives.

Reuse the existing design system; redesign its components only when asked to redesign the feature. For new UI without that system, avoid raw Material appearance and create product-specific components over accessible semantic foundations. Follow the native iOS 26+ tab-bar and older-OS custom-component policy in [toolkit](toolkit.md). Remove ink splashes/ripples through the shared theme and audit local overrides; preserve immediate pressed feedback, visible focus, selection, cancellation, and disabled behavior.

Shadows are part of that same invisible craft: use a coherent set of restrained depth tokens to explain floating layers, not to decorate every card. Let spacing, tone, or a border do the work when they communicate the hierarchy better. Tune against the actual surface, backdrop, and light/dark theme, and measure expensive effects. This is a Flutter adaptation of Emil’s cohesion principles, not a numerical shadow formula from the original guide.

Read [theme-patterns.md](theme-patterns.md) and [component-patterns.md](component-patterns.md) for concrete examples.

## Required visual sweep

For a visible feature, inspect its screen and the controls it reveals before declaring completion. Open menus and sheets; compare back and trailing actions together; inspect field labels, borders, radii, icon weight, typography, alignment, and spacing at actual phone size. Check light/dark and large text, including focused/error states and the actual keyboard. An iOS glass shell does not style a stock Material child or its popup for you.

Preserve business behavior, route ownership, and durable state while fixing visual defects within the requested scope. An existing design system is a constraint: do not redesign it without a feature-redesign request. Read-only review still reports findings rather than editing them. Keep visual and UX acceptance separate: completing a journey cannot excuse mismatched controls or weak surface separation, and an attractive screenshot cannot excuse lost work.

The transferable taste principles are intentional composition, consistent shape/type/icon choices, readable contrast, restrained materials, and attention to small states. Apply them to mobile tasks and constraints; do not import marketing-page structures, arbitrary font rotation, decorative motion quotas, or simulated design randomization.

## Motion decision order

1. **Coverage and frequency:** Microinteractions are core. Cover the affected press, selection, completion, content changes, and navigation/dismissal states. Frequent actions use short, subtle, interruptible feedback; never delay activation or typing. Preserve established platform transitions and gesture physics. A new app must demonstrate useful primary-task response beyond theme or default route animations.
2. **Purpose:** Feedback, spatial consistency, state indication, preventing a jarring change, explanation, or rare delight. Movement that makes information harder to read fails.
3. **Tool and property:** Existing components first. Flutter Animate for effect sequences, implicit widgets for simple targets, Motor for physics, Heroine for shared elements, Smooth Sheets for sheets, and Motion for purposeful 3D tilt. Low-level controllers/tweens are for genuinely complex custom mixers, not ordinary choreography. Prefer visual transforms when layout should stay fixed, and use real size transitions for genuine reflow.
4. **Curve and timing:** Strong ease-out for response; ease-in-out for on-screen movement; linear for honest constant progress. Default added UI motion below 300ms. Shared curves are `Cubic(0.23, 1, 0.32, 1)`, `Cubic(0.77, 0, 0.175, 1)`, and the sheet curve `Cubic(0.32, 0.72, 0, 1)`.
5. **Interruption and exit:** Retarget from current position and preserve velocity for physical objects. Follow the arrival path back out. Never restart at zero for every toggle.
6. **Accessibility and lifecycle:** Reduced motion, semantics, focus, cancellation, app inactivity, and disposal ship with the interaction.

Press feedback starts on touch-down, but actions commit only after valid activation. Scale `0.97` in about 120ms only when it helps; keep hit geometry stable. Anchored surfaces originate at their trigger; centered dialogs stay centered. Entrances use plausible `0.9–0.97` scale when scaling has purpose, never zero. Pure fades and immediate changes are valid.

## Physical continuity

A dragged object tracks 1:1 after the gesture wins, preserving grab offset and active pointer. On release use signed recent velocity in logical pixels/second. Choose a permitted snap point from momentum projection; a fast short flick should work. Resist soft boundaries progressively. Cancel when ownership is lost; do not let a sheet steal its list’s scroll or the route’s back gesture.

Springs need current position and velocity; a spring label does not prove continuity. Use independent axes where velocities differ. Default to critical damping, and reserve subtle bounce for momentum or a product’s playful moments. Flutter’s duration/bounce constructor is SDK-dependent, and perceived duration is not exact settling time.

## Coherent component behavior

Make public widget APIs typed and semantic. Keep transient visual state local and business state in the app’s state layer. Excellent defaults beat endless options. Use stable content keys, an obvious host for shared feedback, deduplicated events, and predictable update/dismiss behavior. Readability and recovery survive dismissal of a transient message.

Retain outgoing content long enough to render an exit, while preventing unavailable controls from receiving input, focus, or duplicate semantics. Keep one interactive source for clipped duplicate visual layers. A hold fill may use 2 seconds linear and cancel in 200ms ease-out; provide an accessible alternative and commit only once per uninterrupted hold.

Use short 30–80ms stagger only for occasional bounded groups; never delay primary actions or replay entrances during lazy-list recycling. Tooltip discovery on a tablet pointer can have an initial delay and then a shared warm session. Touch and assistive users need independent access.

## Rendering evidence

Flutter animation ticks run on the UI isolate and rendered layers cost raster time. Transforms avoid changing layout, but opacity, blur, masks, shadows, clips, and 3D are not free. Narrow rebuilds, reuse static children, lazily build lists, and measure purposeful size changes. A small local blur may bridge a difficult crossfade after identity and timing are fixed; no blur radius guarantees performance.

Profile UI and raster frames under realistic navigation, media loading, and state updates on a supported device. Budget about 16.7ms at 60Hz and 8.3ms at 120Hz. Inspect frame percentiles and missed frames, not just an average. Use a physical device for gesture feel and haptic timing.

## Review and iteration

Use a Before / After / Why table for code review, cite actual locations, and separate proposals from implemented changes. Prefer deletion, reduction, corrected timing/origin, continuity, and smaller frame work before adding effects. Inspect at normal speed and 2–5× duration, then restore timing. Controlled widget pumps help verify cancellation and intermediate states; screenshots cannot establish physical feel. Review with fresh eyes when practical, without postponing an authorized deliverable.
