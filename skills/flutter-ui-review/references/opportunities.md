## Find animation opportunities: reject first

Abdullah AlMunaikh’s modified Flutter edition, based on Emil Kowalski’s original skills.

This mode proposes motion; keep source code read-only unless implementation is requested. Restraint is the premise: an interface can already have all the motion it needs. Do not audit existing transitions here unless that is also requested.

Recon the product's personality, target platforms, motion libraries, tokens, interaction frequency, and existing state transitions. Inspect callers and actual seams. Then pass every candidate through four questions in order:

1. **Frequency.** Reject keyboard-initiated actions, focus jumps, command palette transitions, and anything used 100+ times/day. Tens/day normally earns removal or only near-imperceptible feedback. Occasional modals/sheets/settings are eligible. Rare/first-time onboarding, completion, and celebration have the delight budget.
2. **Purpose.** Name one: feedback, spatial consistency, state indication, preventing a jarring change, explanation (onboarding/explanatory surfaces), or delight (rare/first-time only). “It looks cool” fails.
3. **Speed.** Can the interaction work below 300ms with the shared budgets? Press 100–160ms, tooltip/popover 125–200ms, dropdown/select 150–250ms. Modal/drawer source range is 200–500ms, but prefer below 300ms and justify a longer native/continuity transition. Deliberate holds and explanations are separate from the response animation. Slow choreography required to make the idea work fails.
4. **Function.** Will movement help the task or distract from information people read or act on? Decorative tracking may suit a rare product demonstration; moving functional charts or banking values for style fails.

Hunt for feedback gaps, teleporting state, missing spatial connections, occasional group entrances, gesture seams, and rare moments deserving delight. Clear each seam class or record a candidate. Inspect conditional widget branches, actions, accordions, lists, overlays, route changes, empty/success states, and drag handlers. Existing visible press feedback may already be enough; do not add scale reflexively. A hold-to-confirm suggestion needs an accidental-action rationale, cancel behavior, and an accessible confirmation alternative.

Flutter recipe families:

- Feedback: existing state layers or restrained `AnimatedScale`, pointer press scale `0.97`, 160ms shared ease-out when frequency permits; keyboard activation is immediate.
- State continuity: keyed `AnimatedSwitcher` or scoped transitions, `AnimatedSize` for a genuine expansion, `AnimatedList`/sliver variants for occasional insertion/removal. Layout animation is purposeful when real content size changes; profile the affected subtree.
- Spatial story: trigger-derived `Alignment` for scale; linked `CompositedTransformTarget`/`Follower` when an overlay must track a trigger; route continuity with Heroine and Motor-based physics, preserving navigator ownership.
- Gesture seams: native scroll/drag primitives first; preserve direction, velocity, work, and alternative dismissal. Use Flutter logical pixels per second and verified thresholds.
- Groups: 30–80ms short stagger with a bounded total and no blocked focus/input.

At most 5–7 opportunities for a whole app; fewer for a screen. Order by leverage, not novelty. Every suggestion needs a verified location and exact duration, curve, changed properties, reduced-motion path, and relevant input gating. Recommend a specific implementation after checking the SDK/package, not a fabricated API.

Required output:

| # | Location | Today | Purpose | Frequency | Suggested motion |
| --- | --- | --- | --- | --- | --- |

Then **Rejected candidates**: 2–5 actual considered locations with the gate that rejected each. Do not invent rejected candidates when fewer exist. Close with one short verdict: how much motion this interface needs, the highest-leverage surviving suggestion if any, and a planning/implementation handoff. Zero suggestions is a valid result.

