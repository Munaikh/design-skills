# Test mobile journeys with Marionette

Abdullah AlMunaikh’s runtime verification workflow. Use [Marionette MCP](https://github.com/leancodepl/marionette_mcp) as the preferred way to inspect and interact with the actual running Flutter app after feature/UI changes, reproduce bugs, and verify recovery. The reference app is a repository fixture; ordinary projects test their own app directly.

## Establish the target and prepare only when authorized

Inspect app entrypoint, selected SDK, dependency lock, device, and run configuration. Prefer exposed Marionette MCP tools. In a shell-only environment use the same project's Dart CLI and run its `help-ai` once for the installed command syntax. Match the bridge version to `marionette_flutter`; do not retry an incompatible session indefinitely.

For implementation/runtime testing, add `marionette_flutter` to the target app when missing. Initialize `MarionetteBinding` before other plugins that install a binding, gated on `kDebugMode`. Release initializes the ordinary Flutter binding. Tests use app widgets/a separate entrypoint so `flutter_test` owns its binding. Hot restart after changing `main()`; hot reload does not re-run initialization. A read-only source review does not authorize dependency or instrumentation changes.

Configure only the custom primitives that need discovery. `MarionetteConfiguration.isInteractiveElement` and `extractText` receive an `Element`; inspect `element.widget`, including enabled state. Register custom glass controls/tabs where default traversal misses them, preserve meaningful `Semantics`, and use stable keys. Leave traversal stopping unset unless measured costs justify it; never hide scrollable descendants. Set a `LogCollector` so `get_logs` returns actual diagnostics. An empty unconfigured collector is not proof of an error-free app.

Opt into `MarionetteDeviceConfig` under the same debug gate for text-scale, bold-text, and theme sweeps. This changes app media configuration, not hardware dimensions or fold posture. Emulator resizing/hinge tests and hardware assistive traversal need separate checks. Setup: [binding](https://github.com/leancodepl/marionette_mcp/blob/main/docs/flutter-setup.md), [custom controls/logs](https://github.com/leancodepl/marionette_mcp/blob/main/docs/configuration.md).

## Drive and verify the user’s goal

Connect using the VM service URI from this app's `flutter run` output. Select the intended device explicitly when several apps are running. Treat the URI as a temporary debug credential; do not commit it or include its token in reports.

Inspect `get_interactive_elements` before choosing a selector and after navigation/layout changes. Prefer stable keys, then supported identifiers/text; coordinates are a last resort. Exercise the task's entry, normal path, user-visible completion, back/tab behavior, and relevant interruption/recovery. Inspect the resulting content/state after each meaningful action. A successful tap alone does not prove that saving, navigation, or recovery occurred.

For the reference app, browse → detail → enter a note → save → open Saved → edit; separately trigger load/save failure and retry without losing work. For the user's app, use its actual journey and authorized test data. Restore media/fixture overrides after sweeps, preserve user/live data, and disconnect or clean up only the session you own.

## Humans and CLI fallback

Use a project-local pinned bridge where possible. From an app with `marionette_cli` as a dev dependency:

```bash
dart run marionette_cli:marionette help-ai
dart run marionette_cli:marionette --uri "$TASK_VM_URI" get-interactive-elements
dart run marionette_cli:marionette --uri "$TASK_VM_URI" tap --key save_place
dart run marionette_cli:marionette --uri "$TASK_VM_URI" get-logs
```

`TASK_VM_URI` is the URI from the current run, not a saved endpoint. Use the installed CLI help if options differ. The CLI can capture screenshots and perform hot reload/restart. [CLI documentation](https://github.com/leancodepl/marionette_mcp/blob/main/docs/cli.md)

## Evidence and limits

Enable session reports explicitly with `MarionetteConfiguration(enableSessionReports: true)`. Record scenario, SDK/package versions, platform/device/window, steps, observed outcome, screenshots/logs, failures, restored overrides, and checks not run. The MCP session creates its own directory; the agent writes the narrative report. Reconnecting starts a new session. CLI invocations can create separate directories even with the same title; a scripted run should collect its own aggregate report instead of assuming title-based reuse. [Session reports](https://github.com/leancodepl/marionette_mcp/blob/main/docs/session-reports.md)

Marionette is runtime exploration/smoke evidence, not a deterministic CI replacement or a performance profiler. Retain relevant unit/widget/integration tests for regressions. A VM service is unavailable in release builds. Profile UI/raster frames with Flutter tooling separately; physical devices establish gesture feel, haptics, native permission UI, fold posture, and VoiceOver/TalkBack behavior. If no suitable runtime/bridge/device is available, finish the unaffected checks and report the exact unperformed journey instead of claiming success or substituting screenshots as proof.
