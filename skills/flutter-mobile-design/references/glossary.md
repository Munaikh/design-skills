# Mobile design and motion vocabulary

Abdullah AlMunaikh’s substantial Flutter mobile adaptation of Emil Kowalski’s design-engineering principles. Emil’s contribution is the discipline of purposeful motion, restraint, cohesion, practiced taste, and invisible correctness. The mobile vocabulary, implementation policy, and technical clarifications below belong to Abdullah AlMunaikh’s modified edition; they are not quotations or numerical rules attributed to Emil.

## Use this to understand an interaction

For a naming question, answer **Term — precise definition**, followed by a short explanation tied to the described behavior. Describe what changes, what drives it, and what the person perceives. Offer at most two nearby alternatives when the evidence is ambiguous. A screenshot cannot establish timing, velocity, interruption, or a physics model. Say “a fade with slight scale” rather than inventing a grand name for that combination. Naming an effect does not authorize adding it.

For implementation, first identify the user’s task and why the change would help. Read the relevant section rather than applying every effect. A technically accurate name is not a design recommendation.

| The question | Start here |
| --- | --- |
| Can people find their way and finish the task? | Task, hierarchy, and continuity |
| Should this move at all? | Purpose, restraint, and product character |
| What is visibly changing? | Changes in appearance and geometry |
| Why does it feel slow, abrupt, or poorly coordinated? | Timing and sequencing |
| Why does the dragged object jump or bounce incorrectly? | Physics and direct manipulation |
| What replaces a ripple, or supports assistive interaction? | Controls, input, and access |
| How should depth, shadows, and glass work? | Materials and visual hierarchy |
| How should loading, numbers, or illustrations communicate? | Content and status |
| Is the interaction actually smooth and responsive? | Rendering and verification |

## Task, hierarchy, and continuity

| Term | Meaning and mobile consequence |
| --- | --- |
| User journey | The steps and decisions between a person’s entry point and a meaningful outcome, including interruption and recovery. A collection of attractive screens is not a complete journey. |
| Task completion | Reaching the intended outcome and being able to recognize it. A button animation or successful tap callback alone does not establish that a record was saved or a route reached. |
| Wayfinding | Cues that communicate current location, available destinations, and a useful path back or out. Titles, selected navigation, predictable back behavior, and coherent route ownership work together. |
| Visual hierarchy | Relative emphasis that guides attention through content and actions. Size, weight, contrast, spacing, grouping, and placement contribute; larger type or extra elevation alone does not guarantee a clear hierarchy. |
| Affordance | An action the interface makes possible, such as dragging a sheet. Its visible cue is a **signifier**, such as a handle. A decorative handle is misleading if the surface cannot actually be dragged. |
| Signifier | A perceivable cue indicating where or how to act. Labels, control shapes, handles, and selected states should fit real behavior; essential actions cannot depend on discovering a hover treatment. |
| Mapping | The relationship between a control and the result it produces. Place controls near their subject and choose directions/order people can understand; do not use peer tabs as steps in a sequential form. |
| Progressive disclosure | Revealing secondary information or advanced options when useful. It reduces initial complexity while keeping necessary information and recovery accessible; hiding the primary action is not progressive disclosure. |
| Spatial continuity | Preserving understandable object/location relationships through a change. A detail transition may connect a selected image to its destination; routine tab switching need not pretend that one peer is a child of another. |
| State continuity | Retaining the person’s relevant work and context through navigation, tab switching, folding, resizing, or recovery. Drafts, selection, filters, and scroll need durable ownership; visual continuity cannot compensate for lost state. |
| Restoration | Reconstructing state after a lifecycle boundary such as process destruction. Keeping a controller alive across a tab switch proves in-session retention, not persistent storage or process-death restoration. |
| Recovery | A reachable way to continue after an error, cancellation, or denied capability while preserving useful work. Retry, correction, undo, and a manual alternative are different recovery actions; choose the one that fits the failure. |
| Empty state / no results | An empty collection and a query that matches nothing are distinct conditions. Explain the actual state and offer an appropriate next action; do not suggest clearing a query when there is no underlying data. |
| Adaptive layout | Changing composition to fit allocated space, text size, insets, and display features. Phones come first, then foldables; a wider layout earns additional context only when it helps the task and preserves state. |

For journey acceptance, back behavior, forms, and hinge-safe continuity, use [mobile UX](mobile-ux.md).

## Purpose, restraint, and product character

| Term | Meaning and design decision |
| --- | --- |
| Purposeful motion | Movement with a concrete role: acknowledge input, explain a state change, preserve orientation, reveal a relationship, or support a rare expressive moment. “It makes the screen premium” is not a sufficient purpose. |
| Frequency of use | How often someone encounters the interaction in actual use. Repeated work deserves immediate response and minimal visual interruption; occasional transitions have more room, and rare explanations can justify a larger motion budget. |
| Restraint | Omitting or reducing treatments whose attention cost exceeds their benefit. Zero added motion is a legitimate crafted result; restraint also applies to cards, shadows, blur, and unnecessary steps. |
| Cohesion | Agreement between product purpose, language, controls, typography, materials, and motion. It does not require identical animation on every element; deliberate differences can distinguish different roles while preserving one design system. |
| Invisible craft | Correct handling of details people should not need to notice: stable targets, predictable cancellation, readable labels, retained drafts, useful focus return, and safe resource ownership. Decoration cannot substitute for these details. |
| Product character | The consistent qualities an experience communicates through its choices, such as clarity, calm, efficiency, or playfulness. Derive them from the product and people using it; do not impose one palette, font, or bouncy personality on every app. |
| Perceived responsiveness | How promptly a person sees that the interface heard an action and understands what happens next. Immediate pressed/status feedback helps; it does not reduce network latency or justify displaying success before completion. |
| Delight | A positive response to a coherent, useful experience, sometimes reinforced by a rare expressive moment. Celebration must not conceal failure, delay a primary action, or repeatedly demand attention. |

The decision order is purpose and frequency before tools, geometry, and timing. Keyboard input, typing, focus movement, and frequent actions remain immediate; preserve established platform behavior. See [motion patterns](motion-patterns.md).

## Changes in appearance and geometry

| Term | Precise meaning and useful distinction |
| --- | --- |
| Fade | A change in opacity. It changes visibility, not layout or control availability. Fully transparent content can still intercept input or appear in semantics unless its owner deliberately changes those behaviors. |
| Crossfade | One visual fades out while another fades in, with some temporal overlap. Overlap can produce competing silhouettes or unreadable text; correct identity, placement, and timing before considering blur. |
| Entrance / exit | Presentation of arriving or departing content. An exit requires retaining the visual long enough to render it while unavailable controls leave interaction and semantics; immediate removal cannot produce an exit. |
| Translation | Moving a visual without changing its shape. Distinguish paint-space displacement from a layout change, and distinguish offsets in logical pixels from fractional offsets relative to a child’s dimensions. |
| Slide | Translation used to enter, leave, or connect positions. A slide need not begin outside the screen. Its direction should communicate a relationship or follow platform navigation, rather than decorate every state change. |
| Scale | A change in rendered size around an anchor. Scaling usually scales content as well as the surface, unlike assigning new layout constraints. Keep hit targets reliable, avoid unreadable text, and avoid scale-zero entrances. |
| Rotation | Changing a visual’s orientation around an anchor. In-plane rotation and rotation in three-dimensional space are different operations; a rotating loading indicator is not evidence of a 3D model. |
| Transform origin | The anchor used for a transform. A trigger-anchored panel should appear related to its trigger; a centered dialog may stay centered. Derive the anchor from actual placement, including repositioning at viewport edges. |
| Reveal | Making portions of existing content visible through a changing boundary or coverage. Content need not translate or fade. Required task content must remain accessible when decorative reveal motion is disabled. |
| Clipping | Restricting drawing to a geometric region. A hard clip and a soft transparency mask are different. A decoration’s outline does not necessarily clip its child, and clipping alone does not define interaction or focus policy. |
| Masking | Modulating which portions of a visual remain visible, potentially with graded transparency. It can express a soft edge or selective reveal; it is not automatically inexpensive, and decorative copies must not duplicate controls or semantics. |
| Morph | A continuous change in geometry or form. A shape changing its outline is a morph; two unrelated shapes crossfading are not necessarily morphing. Preserve identity and readability rather than describing every content swap as a morph. |
| Layout transition | A visible change in allocated size or position as the composition reflows. It can explain expansion or list mutation but may require layout work; use it for a real structural change and measure the affected subtree. |
| Shared-element transition | Maintaining the apparent identity of an object between route presentations, such as a selected image becoming a detail image. Use Heroine with Motor-based physics, matching content and stable tags in the appropriate navigator; do not introduce stock Hero. |
| Parallax | Different relative motion of visual layers that suggests depth. Scrolling, device orientation, or pointer movement can drive it; parallax is not synonymous with scroll animation and should not destabilize essential reading content. |
| 3D tilt | A limited orientation change that gives a surface an impression of depth. Use Motion for purposeful sensor-driven tilt or parallax, with static reduced-motion and unavailable-sensor alternatives. It is not an arbitrary flip/orbit engine. |
| Perspective | A projection in which apparent scale depends on depth relative to a viewpoint. Its strength depends on the projection and geometry; there is no universal rule that a smaller numeric parameter produces stronger perspective. |
| Flip / orbit | A flip rotates a surface to reveal another face; an orbit moves an object around another position. These are distinct from tilt. A required flip/orbit needs a separately verified composition and an accessible static alternative. |
| Accordion / disclosure | A control that reveals or hides associated detail, with an understandable expanded state. Animation is optional; hidden detail must not retain unreachable focus targets or duplicate assistive content. |

Implement ordinary effects with Flutter Animate by default, or simple implicit widgets such as `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSize`, and `AnimatedAlign`. Prefer product components or deliberately themed primitives; geometry vocabulary is not an instruction to rebuild every control from raw transforms.

## Timing and sequencing

| Term | Precise meaning and design consequence |
| --- | --- |
| Duration | The time allotted to a bounded phase. A sequence’s total duration also includes delays and overlap; quoting a short per-item duration can conceal a long cascade. Physical settling need not end at an exact duration. |
| Delay | Time before a phase begins. A deliberate tooltip-discovery delay differs from delaying acknowledgment of an action. Own delayed work and cancel it when its context disappears. |
| Easing | A mapping from normalized elapsed time to animation progress. The mapping’s slope affects progress speed; actual visual velocity also depends on distance, duration, path, and property interpolation. Easing is not itself a physics simulation. |
| Linear progress | Progress changing proportionally with elapsed time. This gives constant velocity only for a matching linear position interpolation; a curved path or nonlinear property mapping can produce different visual speeds. |
| Ease-out | A progress profile that generally slows toward the end, giving comparatively prompt movement at the start. It suits many responses/arrivals; the name alone does not determine exact speed, duration, or overshoot. |
| Ease-in | A progress profile that generally accelerates away from a slow start. That start can delay visible acknowledgment in ordinary interactive UI, so this edition avoids it for routine responses. The term is a definition, not a blanket recommendation. |
| Ease-in-out | A profile combining a slower beginning and ending with faster intermediate progress. It can suit visible movement between positions; it does not guarantee physical realism or equally timed acceleration and deceleration. |
| Cubic Bézier easing | A progress mapping described by a cubic Bézier curve with endpoint and control-point geometry. Flutter `Cubic` specifies two interior control points between fixed endpoints. The four numbers are coordinates, not durations, velocities, or spring parameters. |
| Asymmetric easing | A time profile whose beginning and ending are not mirror images. This describes one profile; it is distinct from giving entrance and exit phases different durations or curves. Asymmetry is not automatically better. |
| Asymmetric phase timing | Different timing for phases with different roles. A justified hold can be deliberate while cancellation is prompt; ordinary tap acknowledgment should not inherit the hold’s long duration. |
| Interpolation / tweening | Computing intermediate values between specified values. It describes a calculation, not a particular feel or framework API. Keep routine composition in Flutter Animate or implicit widgets rather than introducing handwritten tween timelines. |
| Keyframe | A specified value at a specified point in a timeline. Interpolation connects keyframes when appropriate. A keyframe animation can be designed to interrupt; using keyframes alone neither guarantees nor prohibits continuity. |
| Sequence | Phases organized in time, with explicit order, overlap, or dependency. Primary action availability is not a decorative phase; do not lock it behind the sequence. |
| Stagger | Offsetting the start times of related items. Use a short bounded Flutter Animate composition only when it earns attention; do not replay it during lazy-list recycling or delay required content and actions. |
| Replay | Intentionally restarting a presentation. Rebuilds, provider refreshes, route revisits, and resizing are not automatically replay requests. Retain a completed flag when the behavior should occur once per journey/session. |
| Loop / alternate loop | A repeated sequence; an alternate loop reverses direction each cycle. Loops need a real purpose, pause/stop ownership, and a reduced-motion alternative. Reversing a loop does not make it velocity-continuous at its boundaries. |
| Anticipation | A preparatory change that signals a following action, sometimes a small opposite-direction movement. It can help an occasional explanation; it must not add a wind-up before routine activation. |
| Follow-through | Secondary movement continuing after a primary movement ends. It may convey flexibility or weight, but additional settling must not postpone usable controls or compete with text people read. |
| Squash and stretch | Deliberate shape deformation suggesting flexibility or impact. It is different from uniform scaling; keep it rare, purposeful, and compatible with readable content and stable hit regions. |

Use shared product motion tokens and the frequency gate. Platform transitions retain their established role. Manual low-level controllers, tween timelines, and simulations are reserved for very complex custom animation mixers that the preferred tools cannot express.

## Physics and direct manipulation

| Term | Precise meaning and implementation consequence |
| --- | --- |
| Direct manipulation | The person acts on a visible object and receives a corresponding immediate response, such as dragging a sheet. Once the gesture is owned, preserve the grab offset and avoid lagging the finger with decorative smoothing. |
| Position / displacement | Position describes where the object is in a coordinate system; displacement is a difference between positions. Use the same space for gesture input, target selection, and simulation, including any normalization. |
| Velocity | Change in position per unit time, including direction. For Flutter gestures, logical pixels per second is distinct from normalized progress per second; conversion uses the motion’s actual coordinate span. |
| Acceleration | Change in velocity per unit time. Abrupt changes in position or velocity can create discontinuity even when two effects use the same nominal duration. |
| Spring model | A restoring-force model whose motion depends on displacement from a target, velocity, inertia, and damping. Use Motor for physical interactions; a spring-like easing curve does not automatically carry a gesture’s velocity. |
| Stiffness | How much restoring force changes with displacement in a spring model. Its effect on timing depends on mass and damping too; raising stiffness is not a universal one-parameter “snappiness” prescription. |
| Mass | The inertia parameter relating force to acceleration. Changing it while holding other parameters fixed changes both natural frequency and damping ratio; it does not uniformly make every phase slower or more settled. |
| Damping coefficient | The strength of velocity-dependent resistance in the usual damped spring model. More damping can reduce oscillation but can also slow an overdamped return; it is not simply “how quickly the spring finishes.” |
| Damping ratio | Damping relative to the critical value for the model’s mass and stiffness. It distinguishes underdamped, critically damped, and overdamped behavior; a raw damping coefficient and a damping ratio are not interchangeable numbers. |
| Underdamped / critical / overdamped | In the standard linear model: below critical damping permits oscillatory response; critical damping is the boundary of nonoscillatory response; above it produces an overdamped response. Initial velocity still matters, including possible target crossing without sustained oscillation. |
| Overshoot | Moving beyond the target before returning or settling. It depends on model, initial state, and trajectory. Crossing a target is not necessarily repeated bounce, and bounce does not automatically improve physical credibility. |
| Settling time | The time until position and velocity remain within specified tolerances around the target. The result depends on those tolerances and initial conditions; there is no exact visual finish independent of a stopping criterion. |
| Perceptual duration | A description or API parameter for how long a motion is intended to feel active. Its meaning is library-specific; do not equate it with exact settling time or a universal spring constant. |
| Momentum handoff | Carrying release velocity from a gesture into subsequent motion. UI libraries often use “momentum” to describe this continuity; the physical momentum quantity is mass times velocity. Preserve direction and coordinate units. |
| Momentum projection | Estimating a future position using velocity and a chosen deceleration model to select a permitted destination. It is an estimate, not the final animated path; bound it and consider direction before committing dismissal. |
| Retargeting / interruption | Redirecting active motion in response to new intent. Preserve the currently visible position and, for a physical object, appropriate current velocity; restarting at an old endpoint causes a jump. A package label alone does not prove this behavior. |
| Rubber-banding | Increasing resistance as dragging extends beyond a soft boundary. It is a nonlinear displacement mapping, distinct from damping a moving spring. Track raw drag separately from the resisted visual position. |
| Snap point / detent | A permitted resting position of a movable surface. Select it using the interaction’s constraints and velocity, then settle coherently; detents must remain reachable without relying solely on a drag gesture. |
| Hysteresis | Different thresholds for entering and leaving a state, reducing repeated toggling near a boundary. It can prevent repeated haptics or arming events; it is not a spring or a substitute for operation deduplication. |
| Gesture ownership | Which recognizer/control handles the interaction after intent is established. Sheet dragging, inner scrolling, and route back gestures must cooperate rather than compete through overlapping raw handlers. |
| Gesture cancellation | Ending an attempted interaction without committing its action, such as after ownership loss or pointer cancellation. Restore presentation and preserve work; touch-down is not permission to commit a consequential action. |

Use Smooth Sheets for sheet motion, scrolling coordination, and nested sheet journeys; use Motor for new custom physics and Heroine with Motor for shared objects. Preserve the real navigator and platform back contract. The terminology above explains behavior rather than prescribing hand-built simulations. See the [toolkit](toolkit.md) for integration boundaries.

## Controls, input, and access

| Term | Meaning and this edition’s policy |
| --- | --- |
| Semantic control | An interaction with understandable role, name, state, and action for supported input modes. Product components or intentionally themed framework primitives can provide this; an attractive bare tap region is not an equivalent button. |
| Press feedback | Visible acknowledgment while a valid press is in progress. It may use restrained tone, contrast, or frequency-appropriate scale; a press need not always shrink. Restore it on cancellation and commit only on valid activation. |
| Ripple / ink splash | A spreading ink-like response, often centered on the interaction point. Recognize the term when asked, but do not implement it in this edition. Use `NoSplash.splashFactory` centrally and remove local splash overrides; preserve other meaningful control states. |
| Focus indication | A visible cue showing the target of keyboard or other focus-based input. It is distinct from pressed, hovered, selected, and disabled states; removing ripple does not justify removing focus visibility. |
| Accessibility focus | The current target of assistive navigation. It is distinct from a Flutter keyboard `FocusNode`; setting input focus or printing a focus flag does not prove VoiceOver/TalkBack reached the intended control. |
| Selected / disabled / busy | Different states: selected identifies an active choice; disabled identifies an unavailable action; busy describes ongoing work. Express the actual state in labels/semantics and appearance, with an accessible recovery or cancellation path where needed. |
| Hover feedback | A change driven by an actual hovering pointer. It may supplement a control, but essential actions and descriptions must work through touch and assistive access; screen width does not prove hover capability. |
| Hit target | The region in which a control can receive its supported interaction. Its effective size depends on parent hit testing and overlapping controls, not just visible decoration or extra transparent pixels. |
| Focus return | Restoring useful input/assistive context after a temporary surface or item disappears. Return to a surviving relevant target and reveal it where needed; the original trigger may no longer exist. |
| Reduced motion | A request to reduce or disable nonessential movement. Respond during active transitions as well as initial construction; static state is valid. Preserve readable status, relationships, and usable controls without mandatory fading, zooming, or looping. |
| Reduced transparency | A preference for less translucent presentation. It is separate from reduced motion and high contrast. Use a verified platform bridge/app preference when needed; do not invent a universal Flutter media query for it. |
| High contrast | A request for stronger visual distinction. Check actual text/control surfaces and states; a darker shadow alone does not establish readable contrast or replace semantic information. |
| Haptic feedback | Tactile acknowledgment tied to a meaningful event. It supplements visible/semantic feedback, does not carry the only outcome, and is not a frame-by-frame animation effect. Verify availability and feel on physical devices. |
| Hold to confirm | A deliberately sustained input whose completion commits a clearly described action. It requires cancellation, an equivalent accessible path, and idempotent commitment; a long decorative fill alone is not a confirmation interaction. |

No ink splash/ripple applies to custom components, package controls, themed primitives, and prototype chrome. It does not require discarding robust semantics or platform behavior. Build a coherent mobile component language instead of leaving every screen at unstyled stock Material defaults. See [theme patterns](theme-patterns.md).

## Materials and visual hierarchy

| Term | Meaning and restrained application |
| --- | --- |
| Surface | A visual region grouping content or controls. Its shape, tone, boundaries, and interaction establish its role; wrapping every paragraph in a card does not create useful structure. |
| Elevation | Perceived separation or position in a visual depth hierarchy. Shadow, overlap, tone, material, and occlusion can communicate it. A framework elevation number is an input to that component’s rendering, not universal physical distance. |
| Shadow | A visual cue that a surface occludes light, suggesting separation from another surface. Use restrained shared tokens only where they clarify hierarchy; inspect shape, backdrop, clipping, and light/dark appearance rather than adding shadow to every card. |
| Contact / diffuse shadow | Contact shadow suggests nearby attachment or occlusion; a softer spread suggests more diffuse separation. These are useful visual distinctions, not a required two-layer recipe or a set of numeric values attributed to Emil. |
| Material weight | The perceived visual substance/emphasis of a surface, influenced by tone, opacity, contrast, depth, and context. Heavier is not automatically better; related surfaces need a coherent hierarchy rather than competing effects. |
| Translucency / glass | A surface treatment through which underlying content contributes to appearance. It can distinguish floating navigation/controls, but contrast depends on the actual backdrop. Keep content readable and offer an appropriate solid alternative. |
| Blur | Spatial averaging that reduces visible detail. Blurring the child and blurring what is behind it are different operations. Blur does not repair poor identity or timing, and no fixed radius guarantees acceptable raster cost. |
| Scrim | A covering layer that de-emphasizes content behind a temporary focus/task. It is not a shadow. Its visual appearance, input barrier, dismissal action, and accessibility scope must agree. |
| Border / tonal separation | Edges or surface-tone differences that distinguish regions without relying on depth. They can be more legible than a shadow in some contexts; choose from task, contrast, and product language rather than a blanket prohibition on borders. |
| Typography hierarchy | Relationships between text roles created by size, weight, spacing, line height, contrast, and grouping. Preserve large-text accessibility and script-specific legibility; motion should not destabilize information people are comparing or reading. |
| Tracking / leading | Tracking is spacing between glyphs; leading describes spacing between lines. Their suitable values depend on typeface, size, script, and purpose. One globally “premium” value is not a typography system. |
| Optical sizing | Typeface-specific adjustments designed for different display sizes, sometimes exposed through a variable-font axis. It is not simply scaling text; use it only when the selected font supports the feature. |
| Tabular figures | Digits designed with equal advance widths, reducing horizontal shifts in changing numeric values. They depend on font support and do not make all text monospaced or remove changes caused by differing digit counts. |

These are Abdullah AlMunaikh’s Flutter applications of cohesion and invisible craft. No universal shadow opacity, offset, blur, or elevation is claimed as Emil’s prescription. Use centralized tokens, actual content, and measured rendering evidence.

## Content and status

| Term | Meaning and mobile consequence |
| --- | --- |
| Determinate progress | Progress tied to a meaningful known amount of work. Display the actual measure and completion; do not accelerate it cosmetically or treat an interpolated display value as the operation’s true state. |
| Indeterminate progress | Ongoing activity without a reliable completion fraction. Pair it with useful context, cancellation/recovery when available, and a reduced-motion alternative; it is not a promise of a particular remaining time. |
| Skeleton | A placeholder representing the structure of expected content while it loads. Keep dimensions stable where helpful. A skeleton need not animate and must not be mistaken for interactive content. |
| Shimmer | A moving luminance treatment, often over a loading placeholder. It is an optional effect, not another word for skeleton; remove nonessential movement under reduced motion and avoid distracting continuous sheen. |
| Number transition | A presentation connecting old and new numeric values, such as interpolation or a digit roll. Keep the actual final value readable and semantic; avoid repeatedly moving values people need to compare. |
| Text transition | A change in text presentation through replacement, crossfade, movement, or shape interpolation. These mechanisms are distinct; keep one meaningful semantic result and handle grapheme clusters correctly. |
| Typewriter reveal | Text becoming visible incrementally. It can serve a rare explanation but must not delay necessary reading or controls. Provide immediate full text for assistive/reduced-motion use and a skip path where appropriate. |
| Path drawing | Revealing a stroke along its geometry over time. It differs from fading an entire illustration. Use verified vector tooling or effects, keeping the completed image available without motion. |
| Authored animation | Artwork with a supplied timeline or interactive state machine. Lottie playback and Rive interaction address different needs; asset validity, licensing, lifecycle, errors, and static/status alternatives still belong to the app. |
| Undo | Reversing an already committed reversible operation while preserving sufficient information. It is different from canceling work that has not committed, and the action cannot disappear before someone can discover or use it. |
| Live-region announcement | Assistive notification of a meaningful state change without requiring focus to move. Avoid announcing every frame, progress pixel, or decorative glyph; deduplicate and communicate the actual outcome. |

## Rendering and verification

| Term | Precise meaning and evidence required |
| --- | --- |
| Input latency | Time between input and its observable response. Rendering cost, gesture recognition, queued work, and deliberately delayed feedback can contribute. A high refresh rate alone does not guarantee low latency. |
| Frame rate (FPS) | Frames produced or presented per second; specify which measurement you mean. An idle app need not produce frames continuously, and rendering FPS is not the same quantity as display refresh rate. |
| Refresh rate (Hz) | How often the display can update, subject to device/platform behavior. A 120Hz display does not prove the app presents 120 distinct timely frames every second. |
| Frame budget | Time available to deliver work for the intended display cadence: approximately 16.7ms at 60Hz or 8.3ms at 120Hz. Investigate pipeline stages and scheduling, not just a single average duration. |
| Frame pacing | Consistency in when visible frames are presented. Uneven intervals can appear jerky despite an acceptable average FPS; measure representative interaction rather than relying on a headline frame-rate number. |
| Jank / missed frame deadline | An observed interruption in visual smoothness associated with untimely frame delivery. Identify UI, raster, scheduling, or other causes from evidence; an expensive-looking widget alone is a suspected risk, not a measured failure. |
| Build / layout / paint | Different work: creating/updating widget configuration, assigning geometry, and producing drawing instructions. A paint-space transform can avoid child relayout but does not make the rest of the frame free. |
| Rasterization / compositing | Rasterization produces pixels from rendering instructions; compositing combines visual layers. Their costs depend on renderer, surfaces, effects, and device. Neither term means every animation runs independently of Dart UI work. |
| Repaint boundary | A rendering boundary that can isolate repaint work and influence caching. Add it where evidence supports isolation; extra boundaries/layers are not an automatic optimization. |
| Hardware acceleration | Graphics processing performed with hardware support. It does not guarantee zero CPU work, zero raster cost, no dropped frames, or immunity to a busy UI isolate. |
| Profile-mode evidence | Measurements from the selected app/toolchain on a declared device in profile mode. Debug timings help diagnosis but do not establish release performance; real hardware establishes gesture and sensor behavior. |
| Runtime journey evidence | Observed actions and postconditions in the actual app, such as saving, returning, and recovering without lost input. Marionette supports inspection and interaction; screenshots alone do not establish task completion or physical feel. |

Prefer measured UI/raster traces and observable outcomes. Slow-motion inspection can expose discontinuities, but restore normal timing and check the actual interaction. Do not label repeated layout as a universal engine bug or promise “GPU-only” motion because transforms are present.

## Apply the vocabulary with this toolkit

| Need | Edition policy |
| --- | --- |
| Ordinary effects and sequences | Flutter Animate by default; own once-only/replay, completion, interruption, and reduced-motion policy. |
| Simple target changes | Intentionally styled implicit widgets such as `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSize`, or `AnimatedAlign`; retain semantic controls and stable state. |
| Physics and shared objects | Motor for physics; Heroine with Motor for shared elements. Do not introduce stock Hero or hand-built ordinary spring timelines. |
| Modal, persistent, or paged sheets | Smooth Sheets integrated with the real navigator, scroll ownership, keyboard, safe areas, and work-preservation policy. |
| Purposeful 3D tilt / parallax | Motion, with limited scope and a static fallback. Arbitrary flips/orbits require separate verified composition. |
| Controls and materials | Product-designed components or intentionally themed primitives; no ink splash/ripple, meaningful press/focus feedback, coherent shared shadows. |
| Very complex custom mixers | Low-level controllers/tween timelines/simulations only when the preferred tools cannot express the actual requirement; keep coordinate, ownership, cancellation, and access contracts explicit. |

Implementation details and package compatibility belong in the [preferred toolkit](toolkit.md); shared style belongs in [theme patterns](theme-patterns.md); construction and interruption belong in [motion patterns](motion-patterns.md).

Technical definitions checked against [Flutter spring parameters](https://api.flutter.dev/flutter/physics/SpringDescription-class.html), [spring state and tolerances](https://api.flutter.dev/flutter/physics/SpringSimulation-class.html), [Flutter cubic easing](https://api.flutter.dev/flutter/animation/Cubic-class.html), and [Flutter rendering performance guidance](https://docs.flutter.dev/perf/rendering-performance). [Motion’s documentation](https://pub.dev/packages/motion) establishes its tilt scope; installed package APIs and device results must still be verified in the consuming app.
