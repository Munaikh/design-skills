# Places — Flutter UX reference app

This is a separate, permanent example for validating the design-skills repository. It stays outside installed skills. It demonstrates a complete mobile journey with deterministic local data: Discover → place details → save a note → Saved → edit the note. It has no live backend; saves survive navigation and resizing within a session, and restart resets the demo.

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d <ios-or-android-device-id>
```

Use the project-pinned SDK. The committed dependency lock was validated with Flutter 3.47.7 / Dart 3.13.5. iOS 26+ uses `native_liquid_glass 0.3.1` UIKit platform views for its navigation bar and tab bar. Older iOS and Android use explicit themed Flutter navigation; the package itself renders empty widgets on unsupported targets. The scroll viewport extends behind iOS chrome, with clearance owned by scroll content rather than outer padding. State lives above adaptive layouts and per-tab navigators. Phones are the first target; wide foldable windows gain context without losing drafts, navigation, or scroll. An occluding hinge selects a safe pane.

The native navigation bar has a labelled “Test scenarios” action that opens a themed Flutter popup. The package’s standalone native menu currently lacks an explicit accessibility-label/minimum-hit-region and open/close lifecycle contract; it is not used to substitute an inaccessible nominal-size wrapper for a functioning control. Flutter popup routing supplies menu-first Back dismissal and restores the underlying detail/draft. On fallback targets the same menu uses a themed Flutter trigger. The debug menu offers Reset demo, Load failure, Save failure, and Empty places. Failure occurs once so a retry can succeed. No live records are involved. The fixtures and Marionette binding are debug-only. Widget tests pump the app without calling its instrumented `main`.

## Runtime testing with Marionette

Start the app and use its printed VM service URI. MCP is preferred when configured; a project-local CLI is pinned to match `marionette_flutter`:

```bash
dart run marionette_cli:marionette help-ai
python3 ../../scripts/test_reference_journey.py --uri <vm-service-uri> --output /tmp/places-journey
```

The runner verifies fallback Flutter-control postconditions and writes command evidence plus screenshots. On iOS 26+, native bar buttons and tabs require Simulator/device UIKit automation alongside Marionette; they are not declared Flutter-interactive and their IDs do not make synthetic Flutter taps invoke native callbacks. Marionette exercises Flutter content, fields, save/recovery and popup rows; native UI snapshots/taps and full Simulator screenshots establish UIKit chrome behavior. Hot restart or rebuild after main/plugin changes; hot reload alone does not register a native plugin. Test on iOS and Android phones. Use `set-device-config` for Flutter text-scale and dark-mode overrides; these do not change UIKit Dynamic Type or the device appearance. This app explicitly passes Flutter brightness to the native navigation bar, and the package derives native tab-bar brightness from the Flutter theme. Verify the actual native result separately. Change emulator/window posture separately for folding or hinge checks. Actual screen-reader navigation, keyboard motion, predictive back, haptics, and sustained performance need their own device evidence.

Repository attribution and MIT license apply.
