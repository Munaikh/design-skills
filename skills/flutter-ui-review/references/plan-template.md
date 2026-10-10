# Flutter motion implementation plan

Abdullah AlMunaikh’s modified Flutter edition, based on Emil Kowalski’s original skills.

Use one plan per repair or tightly coupled change. Each executor has no prior conversation context.

````markdown
# NNN — Imperative title

- Status: TODO
- Commit: immutable inspected revision, or not a Git checkout
- Severity: HIGH | MEDIUM | LOW
- Category: audit category
- Scope: exact files and interactions

## Problem
Verified file:line, current Dart excerpt, trigger, and observable consequence.

## Target
Exact resulting behavior, token/curve/duration, origin, input sources,
reduced-motion branch, coordinate units, lifecycle and recovery policy.
Include target Dart where it removes ambiguity.

## Existing conventions
Actual shared theme/motion file, state ownership, pinned SDK/packages,
and a verified exemplar. Reuse established APIs.

## Steps
Ordered concrete edits and resulting behavior for each file.

## Boundaries
Out-of-scope files and behavior; dependency policy; drafts/semantics/back
preservation. Inspect drift against the commit; report material mismatch.

## Verification
Exact project format/analyze/relevant-test commands and expected results.
Interaction checks: repeat, reverse, cancel, interrupt, re-grab, leave route.
Access checks: reduced motion, large text, RTL, focus and semantics.
Device checks: actual iOS/Android gestures and haptics where affected.
Profile checks: before/after UI and raster frames for performance repairs.
Done when: observable success and explicitly unverified limits.
````

Update the plans index with status, dependencies, and execution order. Mechanical checks run during execution, not a read-only audit. A claimed fix is not proof of completion.
