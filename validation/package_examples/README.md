# Abdullah AlMunaikh’s preferred-library examples

This isolated package checks composition against the committed dependency lock without adding optional libraries to the Places app. It demonstrates Motor spring interruption, Flutter Animate sequences, Heroine registration/tags, offline Google Fonts policy, Ionicons, accessible FL Chart summaries, Lottie completion fallback, owned Rive loaders, Smooth Sheets note editing, and optional Motion device tilt. Liquid Glass is exercised in the reference app.

```bash
flutter pub get
flutter analyze
flutter test
```

These examples are library functions, not another required mini app. Asset paths belong to the consuming product: declare licensed fonts, local animation files, and artwork in its pubspec. Rive playback needs initialization for the selected renderer and a valid interactive asset. No font or animation artwork is bundled here; API analysis and reduced-motion fallbacks do not prove production asset playback or offline font rendering. Check native rendering and performance in the actual app.

The fixture pins `google_fonts` to **8.2.1** to compose with Flutter SDK `TextTheme`. Version 9 migrates its typography types to separate `material_ui`/`cupertino_ui` packages; this fixture follows the SDK UI architecture. Verify the consuming project's typography API before upgrading. Disabling runtime fetching does not make missing fonts succeed: bundle every requested family, weight, and style, including its license. [Package changelog](https://pub.dev/packages/google_fonts/changelog).

Smooth Sheets is pinned to **1.2.1**, its SDK UI compatibility release; version 1.3 migrates to `material_ui`. The note editor keeps its draft controller in the owning feature, so closing the editor does not clear unfinished input. [Package changelog](https://pub.dev/packages/smooth_sheets/changelog).

Motion **2.0.2** supplies optional decorative tilt with a separate controller per element. Initialize the plugin once only when the effect is enabled; retain the flat widget if initialization fails, motion is reduced, or the subtree is inactive. Device sensor behavior and battery cost require device testing. Motion's dependency license is **GPL-3.0**; the repository's MIT license covers its own code and does not replace dependency licenses. [Package license](https://pub.dev/packages/motion/license).

Validated on Flutter **3.47.7** / Dart **3.13.5**: analysis passed and four widget tests passed. The tests check spring continuity during retargeting and final selection state, accessible reduced-motion fallbacks without opening assets or sensor widgets, a chart's readable summary, and sheet draft retention through close/reopen/save. Heroine registration, Google Fonts, Ionicons, and asset loader calls are covered by analysis; native shared-element flights, font loading, and Lottie/Rive playback still require product assets and device testing. The sheet test uses zero-duration route transitions and does not verify gesture physics or platform keyboard behavior.

Author: Abdullah AlMunaikh. Repository attribution and MIT license apply.
