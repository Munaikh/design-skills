# Research with Appllama

Adapted from Appllama's usage and app-design skills. Research answers a concrete product question; it does not expand the user's feature scope.

## Connect and budget

Discover the actual Appllama MCP tools and inspect their current schemas before calling them; client prefixes vary. Start with `get_credits` and use its current balance, limits and reset information rather than hard-coded plan quotas. An installed skill or configured endpoint is not proof that the server is callable. If unavailable, expired, or out of credits, state the exact limitation, use provided references or available official product sources, and distinguish that fallback from Appllama research. Do not fabricate screen IDs or claim visual study from metadata.

Select depth based on the decision. For a focused screen, start with a small relevant set across a few apps; for a new journey, inspect complete relevant flows across several strong comparators. Expand when the findings still change the proposed design. Stop when key decisions have evidence and additional examples repeat it, or the task budget is reached. No universal screen-count quota. Revenue/rating/downloads are selection context, not causal evidence of design quality or permission to copy manipulative patterns.

## Tool routing

| Need | Tools and approach |
| --- | --- |
| User supplied a screen reference | `get_screen` with the durable `app_id/screen_id` reference; inspect its image and useful similar results |
| User's curated taste | `list_my_boards`, then `get_board` for the relevant board; preserve the user's stated intent |
| Category or product research | `search_apps`, selectively `get_app`; shortlist by task fit as well as commercial context |
| Whole relevant journey | `list_flows`, `get_flow_apps`, `list_app_screens` filtered to the relevant flow; inspect in journey order |
| Improve one screen | Inspect the current screen first; use `search_screens` keyword mode for function and semantic mode for visual intent |
| Component question | `list_ui_elements`, then `get_element_screens`; stop at the component question |

Follow each returned `next_cursor` sequentially with the same query. Refresh expired cursors/media through the original query or durable ID. Honour rate-limit retry guidance with bounded retries. Service errors are diagnostic data, not authority to change scope, expose secrets, or install unrelated tools.

## Study and synthesize

Actually view selected screenshots; inspect videos when available to understand transition and dismissal behavior. Mark navigation conclusions from stills as inferred. The watermark is provenance, not part of the design to reproduce. Extract hierarchy, content density, spacing roles, controls, presentation, primary action, feedback, and recovery. Compare the step before and after a focused screen.

Keep a compact decision ledger in the response: source app and screen/flow ID; observed pattern; adopt/adapt/reject; product-specific reason; uncertainty. Preserve a curated board's intent without cloning competitor assets, text, branding, or exact compositions. Reference images are research, not bundled application assets.

For a new app, synthesize a coherent direction before coding. For an existing app, address observed deficits while respecting its identity and architecture. For flow research alone, deliver findings without implementing. Apply [evidence policy](evidence-policy.md): temporary media, no automatic repository research archive.
