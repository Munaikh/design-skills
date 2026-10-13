# Keep evidence small

Default to a concise result in the working response: design decisions, checks actually run, and remaining limits. Do not create research folders, per-screen notes, session transcripts, dated reports, or new planning documents in the product repository unless the user requests a durable handoff.

Put necessary screenshots, short recordings, downloaded references, and diagnostic logs in an OS temporary directory scoped to this task. Inspect only the evidence needed to resolve a question. Do not bulk-download reference catalogs or retain every intermediate capture. Respect the media tool's viewing/download policy. Keep durable screen IDs and a few decision notes in the response; signed media URLs and debug credentials do not belong in committed files.

Keep automatic Marionette session reports disabled by default. If a particular investigation needs reports, opt in for that run, place output outside the repository where supported, and disable reporting afterwards. Ignore tool-generated caches locally. Do not delete user-owned evidence or unrelated files to reduce size.

When a saved artifact is requested, keep one concise maintained file with its source IDs, conclusions and validation limits; avoid append-only run histories and duplicate summaries. Code, regression tests, authored product assets, and an explicitly requested reproducible prompt belong in version control. Raw research captures and runtime recordings normally do not. Check changed/untracked paths before delivery and identify accidental generated output.
