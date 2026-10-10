# Places — Flutter UX reference app

This is a separate, permanent example for validating the design-skills repository. It stays outside installed skills. It demonstrates a complete mobile journey with deterministic local data: Discover → place details → save a note → Saved → edit the note. It has no live backend; saves survive navigation and resizing within a session, and restart resets the demo.

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d <ios-or-android-device-id>
```

Use the project-pinned SDK. The committed dependency lock was validated with Flutter 3.47.7 / Dart 3.13.5. iOS uses Liquid Glass navigation elements; Android uses Material navigation. State lives above adaptive layouts and per-tab navigators. Phones are the first target; wide foldable windows gain context without losing drafts, navigation, or scroll. An occluding hinge selects a safe pane.

The debug “Test scenarios” menu offers Reset demo, Load failure, Save failure, and Empty places. Failure occurs once so a retry can succeed. No live records are involved. The fixtures and Marionette binding are debug-only. Widget tests pump the app without calling its instrumented `main`.

## Runtime testing with Marionette

Start the app and use its printed VM service URI. MCP is preferred when configured; a project-local CLI is pinned to match `marionette_flutter`:

```bash
dart run marionette_cli:marionette help-ai
python3 ../../scripts/test_reference_journey.py --uri <vm-service-uri> --output /tmp/places-journey
```

The runner verifies postconditions and writes command evidence plus screenshots. Test on iOS and Android phones. Use `set-device-config` for large text and dark mode; change emulator/window posture separately for folding or hinge checks. Actual screen-reader navigation, keyboard motion, predictive back, haptics, and sustained performance need their own device evidence.

Repository attribution and MIT license apply.
