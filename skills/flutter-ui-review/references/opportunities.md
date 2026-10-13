## Find animation opportunities: feedback and continuity first

This mode proposes motion; keep source code read-only unless implementation is requested. Microinteractions are core, and an existing interface may already meet that bar. Look for missing response and continuity before considering decorative additions. Do not audit existing transitions here unless that is also requested.

Recon the product's personality, target platforms, motion libraries, tokens, interaction frequency, and existing state transitions. Inspect callers and actual seams. Then pass every candidate through four questions in order:

1. **Coverage and frequency.** Find missing press/selection/completion response, abrupt content changes, and broken gesture continuity. Frequent actions need short, subtle feedback, not a blanket animation ban. Never delay keyboard activation, focus, or typing. Reserve decorative emphasis for suitable first-use or milestone moments.
2. **Purpose.** Name one: feedback, spatial consistency, state indication, preventing a jarring change, explanation (onboarding/explanatory surfaces), or delight (rare/first-time only). “It looks cool” fails.
3. **Speed.** Can the interaction work below 300ms with the shared budgets? Press 100–160ms, tooltip/popover 125–200ms, dropdown/select 150–250ms. Modal/drawer source range is 200–500ms, but prefer below 300ms and justify a longer native/continuity transition. Deliberate holds and explanations are separate from the response animation. Slow choreography required to make the idea work fails.
4. **Function.** Will movement help the task or distract from information people read or act on? Decorative tracking may suit a rare product demonstration; moving functional charts or banking values for style fails.

Hunt for feedback gaps, teleporting state, missing spatial connections, occasional group entrances, gesture seams, and rare moments deserving delight. Clear each seam class or record a candidate. Inspect conditional widget branches, actions, accordions, lists, overlays, route changes, empty/success states, and drag handlers. Existing visible press feedback may already be enough; do not add scale reflexively. A hold-to-confirm suggestion needs an accidental-action rationale, cancel behavior, and an accessible confirmation alternative.

Flutter recipe families:

- Feedback: existing state layers or restrained `AnimatedScale`, pointer press scale `0.97`, 160ms shared ease-out where appropriate; keyboard activation is immediate.
- State continuity: keyed `AnimatedSwitcher` or scoped transitions, `AnimatedSize` for a genuine expansion, `AnimatedList`/sliver variants for occasional insertion/removal. Layout animation is purposeful when real content size changes; profile the affected subtree.
- Spatial story: trigger-derived `Alignment` for scale; linked `CompositedTransformTarget`/`Follower` when an overlay must track a trigger; route continuity with Heroine and Motor-based physics, preserving navigator ownership.
- Gesture seams: native scroll/drag primitives first; preserve direction, velocity, work, and alternative dismissal. Use Flutter logical pixels per second and verified thresholds.
- Groups: 30–80ms short stagger with a bounded total and no blocked focus/input.

At most 5–7 opportunities for a whole app; fewer for a screen. Order by leverage, not novelty. Every suggestion needs a verified location and exact duration, curve, changed properties, reduced-motion path, and relevant input gating. Recommend a specific implementation after checking the SDK/package, not a fabricated API.

Required output:

| # | Location | Today | Purpose | Frequency | Suggested motion |
| --- | --- | --- | --- | --- | --- |

Then **Rejected candidates**: 2–5 actual considered locations with the gate that rejected each. Do not invent rejected candidates when fewer exist. Close with one short verdict: how much motion this interface needs, the highest-leverage surviving suggestion if any, and a planning/implementation handoff. Zero new suggestions is valid when the inspected interactions already provide adequate feedback and continuity; it is not approval for an uninspected or inert new app.

