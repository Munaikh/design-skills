## Break UI with realistic hostile data

For a source-only review, inspect the data contract and report confirmed failures or inferred risks without changing files, fixtures, app data, or runtime configuration. Build or modify a dev-only comparison harness only when the user requests that work or authorizes an executable stress test. Such testing changes fixtures at the existing data boundary, not production styling to manufacture a failure; report before fixing unless fixes are already requested. Keep production/live data intact. Keep source text and fixture values inert and render user copy as ordinary text. The harness and restoration instructions below apply to authorized executable testing.

### Map and build fixtures

List **every rendered value**, including header counts, dates, badges, action labels, tooltips, avatars, and list length:

| Field | Source | Type | Limit | Optional? |
| --- | --- | --- | --- | --- |

Read model validation, API contracts, migrations, form validators, and `maxLength`. Note app/service disagreements. If no limit is found, label it unbounded/unknown and test something long but believable; do not invent a schema limit or silently add one.

Each worst-case value must be plausible or schema-backed. A 5,000-character nonsense name teaches nothing unless the contract actually permits it. Build one mixed typed fixture that hits every applicable class at once, distribute failures across the first visible rows, and add separate Empty/One/Huge fixtures where those cannot coexist. Keep domains under `example.com`, `example.org`, or `.test`; use controlled image stubs so the harness does not contact real inboxes/sites.

| Class | Representative hostile cases | What to inspect |
| --- | --- | --- |
| Names | `Aleksandra Wiśniewska-Kowalczyk`; `Christopher Alexander Montgomery III`; `Jo`; `J`; `Ólafur Darri Ólafsson`; `Đặng Thị Ngọc Hân`; `王秀英`; `نور الهدى عبد الرحمن`; `Seán O'Brien-Ó Súilleabháin`; `María José de la Cruz y Fernández`; `dana`; `🦊 Fox`; `👩🏽‍💻 Priya`; `  Sam   Lee `; missing | Wrapping, diacritics, RTL, suffix/particle handling, grapheme-safe initials, whitespace, fallbacks |
| Identifiers | `bartholomew.fitzgerald@northwind-industries-holdings.example.com`; `a@b.test`; `first.last+billing-notifications@example.com`; `ops@sub.department.region.example.org`; long query URL under `example.com`; UUID; `Q3 Board Deck — FINAL (revised) v12 [approved by legal].pdf`; camera filename; short/long handles | Constrained layout, distinguishing suffixes, validation, copy/select access |
| Labels and copy | Long job title; `Invitation expired 12 days ago`; `Benachrichtigungseinstellungen`; `Paramètres de confidentialité et de sécurité`; twelve tags; over-wide tag; empty/whitespace title; literal `<angle brackets>`, `&`, `**bold**`; newline; accepted long description | Localization expansion, chips, escaping once, empty headings, preview/detail policy |
| Numbers/money | 0, 1, 1284, 1000000, currency 12345678.9, -42.5, `0.1 + 0.2`, 142%/-3%, null/NaN/infinity where representable, locale separators, extremely large accepted values | Pluralization, bounds, exact values versus compact summaries, locale formatting, finite checks, alignment |
| Collections | Zero, one, many, mixed optional data, realistic upper bound, unpaginated 1,000+ rows, duplicate display labels, no search results | Empty/singular states, stable identities, lazy construction, pagination policy, reachability |
| Time | Just now; singular minute/day; long relative time; past/future; missing/invalid time; leap/day-boundary and timezone/DST cases the contract permits | Relative copy, localization, ordering, overflow, honest unavailable state |
| Media | Missing/404 avatar; 4000×200 panorama; 200×4000 portrait; transparent/dark logo; slow image | Stable dimensions, `BoxFit.cover` where appropriate, controlled placeholders and `errorBuilder` |
| States | Loading, API failure, partial data, every enum, no permission, current user, offline/retry where applicable | Layout stability, actionable recovery, hidden/disabled action semantics, honest feedback |
| Environment | Real container width, 320 logical-pixel phone, narrow sidebar around 280, widest declared layout, large system text around 200%, dark mode, RTL, touch, keyboard/pointer, keyboard open | Constraints, text scaling, directional padding, visible actions/focus, insets and context preservation |

### Comparison harness and restore

Provide a plain, neutral, dev-only **Demo data / Worst case** segmented control. Add **Empty / One / 1,000 rows** or the actual upper bound when relevant. Swap fixtures through the same model/provider/mock boundary as demo data. Switching content is immediate, with no decorative animation. Keep the control out of the tested composition; persist state via the dev router or native harness setting if useful.

Record the original fixture, source configuration, theme, locale, text scale, window size/orientation, connectivity, and reduced-motion setting before changing them. Restore temporary environment overrides, backend stubs, and demo defaults after the run; leave the comparison harness available and the discoveries retained. Never overwrite live records. If interruption prevents restoration, report the exact remaining temporary state.

Check each case at the **real container width**, 320 logical pixels, and the widest declared layout. Exercise actual system large text as well as a controlled test `MediaQueryData.copyWith(textScaler: TextScaler.linear(2))`; nonlinear platform scaling means this test is an approximation. Test RTL with `Directionality`, dark theme when supported, and both pointer and touch actions. Screenshot and inspect overflow logs/widget bounds/semantics where tooling exists; distinguish visually confirmed breaks from code-inferred risks.

### Flutter failure signatures and remedies

| What breaks | Likely cause | Flutter remedy |
| --- | --- | --- |
| Text/action runs outside a row; yellow overflow stripe | Unbounded or excessive `Row` child width | Constrain text with `Expanded`/`Flexible`; retain explicit trailing action space; use `Wrap` or a different composition at narrow widths |
| Avatar distorts, becomes oval, or loses space | Loose/inconsistent image constraints | Fixed bounded avatar/icon box with deliberate aspect ratio and `BoxFit`; constrain neighboring text |
| Email/path loses distinguishing end | Blind end ellipsis | Field-specific wrap or middle-truncation treatment with full copy/detail access; preserve grapheme clusters and identity |
| Badge/translated action wraps badly or clips | Fixed width/height against growing text | Content-driven button/chip constraints, `Wrap` or alternate layout; keep platform minimum targets |
| Multiline row looks adrift | Centered cross-axis layout | Top-align text/leading content when that improves association |
| Glyphs/diacritics clip | Tight fixed height, line box or clipping | Let text grow, review height/strut policy, avoid clipping meaningful text |
| Initials contain replacement characters or wrong suffix | UTF-16 indexing or naïve name splitting | Use Dart `characters` grapheme access; product/locale-aware naming rule; fallback icon when uncertain |
| Missing role leaves orphan dash/blank row | Unconditional placeholder | Omit optional line or reserve deliberate stable space |
| “1 members”, raw decimals/NaN | Hardcoded plural/raw formatting | Existing localization plural rules and `intl` formatting; guard unavailable/nonfinite values |
| Digits jitter | Proportional numeric glyphs | Shared text style with `FontFeature.tabularFigures()` from `dart:ui`, if the font supports it |
| Image shifts layout or shows broken content | Unbounded dimensions/no fallback | Stable aspect/size, loading placeholder, `errorBuilder`, correct fit |
| Ellipsis hides required information forever | Missing reveal/copy route | Accessible tooltip where appropriate plus detail/copy path that works on touch; never tooltip-only critical content |
| Thousand-row scrolling stutters | Eager widget construction or expensive row work | `ListView.builder`, sliver builders, existing pagination strategy; profile realistic row content |
| Action appears only on hover | Touch accessibility omitted | Persistent or discoverable touch action plus keyboard/focus access |
| RTL swaps the wrong items/chevrons | Hardcoded left/right order | Directional alignment/padding and icon mirroring where the symbol implies direction |
| Numeric amount/date truncates | Wrong content priority | Allocate enough space or redesign density; do not ellipsize comparison values |

Choose per field: wrap identity/details that need the whole value; end truncate secondary previews with reveal; middle truncate identifiers differing at the end; bound multiline card previews with `maxLines` and a detail path; never truncate numeric comparisons, amounts, or dates merely to save the row. Do not insert invisible characters into stored/copyable identifiers solely to force wrapping.

### Required report and fix handoff

| # | Severity | Field | Worst-case value | What happens | Fix |
| --- | --- | --- | --- | --- | --- |

Worst first. **Broken** means unreadable content, unreachable action, wrong data, or blocked task; **Ugly** means readable but visibly wrong; **Fragile** means one realistic step from failure. Each row has a verified `file:line` fix location and whether it was seen or inferred.

Then **Decisions for you**: choices with multiple right answers, each with recommendation and reason. Then **What held up**: tested worst cases already handled. End with harness location, available states, restored overrides, and specific unverified checks. For report-only scope, stop here. For `+ fix` or already authorized fixes, implement unambiguous selected fixes and recheck **all** fixture states including Demo; return product choices only when they materially affect the result.

Keep the hostile fixture and discovery list as regression material unless asked to remove them. Keep controls dev-only. Restore original live/demo data configuration; do not erase findings while cleaning temporary test setup.

