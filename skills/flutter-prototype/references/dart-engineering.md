# Dart engineering for Flutter mobile

This language guide supports reliable interaction and smooth frames.

Design controls intentionally: reuse product components, create suitable custom components, or deliberately theme semantic SDK primitives rather than using unstyled stock Material everywhere. Disable all ink splashes/ripples with `NoSplash.splashFactory` and transparent `splashColor`, audit overrides, and retain meaningful press/focus/selection feedback. Shadows use shared restrained depth tokens only when they clarify hierarchy, following Emil’s cohesion and attention to unseen details. See [theme-patterns.md](theme-patterns.md).

## Project conventions and coding style

Apply these mobile-focused standards from the general-flutter workflow; this installed skill remains self-contained. Start with `pubspec.yaml`, `analysis_options.yaml`, `lib/`, `test/`, and code-generation configuration. Identify the package name, pinned SDK, architecture, router, state system, localization, shared theme, and generated-file patterns before editing. Project conventions take priority unless the user explicitly requests a migration.

Use English code/comments/documentation and descriptive names: PascalCase types, camelCase members, snake_case Dart paths, verb-led actions, and booleans such as `isLoading`/`canSubmit`. Keep idiomatic API/URL/ID abbreviations. Use explicit types where they clarify an API or satisfy lints, typed collections/models rather than `dynamic`, named constants for domain values, const constructors, and super parameters where applicable. Keep functions focused; do not add blank-line-heavy bodies or abstraction solely for appearance.

Use `package:<actual_name>/...` imports inside `lib/` when local conventions or `always_use_package_imports` require them; do not mix import styles for the same members. Organize imports under the project’s lint/formatter rules. Create barrels only when the project already uses them; one unrelated import needs no export layer. Prefer `color.withValues(alpha: value)` on supporting SDKs over deprecated `withOpacity`.

Keep build methods flat and readable. Do not split a simple composition into `_buildHeader()`/`_buildBody()` helpers just for organization; extract a dedicated widget for reuse, meaningful complexity, independent testing, or readability. UI renders state and sends intents; data access fetches/parses/serializes, and the existing notifier/provider/bloc/view model owns orchestration. Add repositories/domain layers only when they reduce real coupling or fit existing architecture.

For an unstructured new app, use shared `core/` and feature-scoped `features/<feature>/{data,state,ui}` boundaries as needed. Reuse existing state management. In Riverpod projects already using generation, follow annotated/generated providers and notifiers; do not add Riverpod, Freezed, a router, DI framework, or code generator gratuitously. Expose immutable UI state with the project’s established model pattern. Share code only after real reuse; keep feature transformations near feature state.

Animation coding follows this edition’s explicit choices: Flutter Animate by default for effects, or simple implicit widgets such as `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSize`, and `AnimatedAlign`. Use Motor for physics and Heroine for shared elements; do not introduce stock `Hero`. Use Smooth Sheets for sheets and Motion for purposeful 3D tilt/parallax. Low-level stock controllers, tween timelines, and simulations are reserved for very complex custom animation mixers that the preferred tools cannot express. Follow the [preferred toolkit](toolkit.md). Keep initialization, routes, assets, permissions, tokens, and operation ownership deliberate and centralized.

## Proportional validation

Format changed Dart code with the selected project SDK and run analysis plus relevant behavioral tests. Run `flutter pub get` after dependency/setup changes. Run build_runner only when the app uses generation and relevant inputs changed; inspect generated drift, imports, and part files. Do not broaden verification without a changed risk or unresolved failure. A read-only review does not authorize format/build/cache writes. Runtime checks exercise the actual app through Marionette when available; report exact commands, failures, and unperformed checks.

## Model intent and ownership

Prefer small immutable models, named parameters for semantic APIs, null safety, and exhaustive enum/sealed-state switches where supported. `final` prevents rebinding, not mutation of referenced objects. Freeze or copy collections when that is the actual contract. Dart objects do not acquire value semantics by declaring final fields; define equality intentionally where identity/value comparison matters.

Use records for small structural results, enums for closed categories, sealed classes for variants with different payloads. Avoid booleans that permit impossible combinations such as loading + successful + failed. Keep constructors validating real boundaries; use exceptions for recoverable input failures and assertions only for debug programmer invariants. Assertions are disabled in release.

Keep public APIs concrete until repeated real use motivates abstraction. Prefer composition to deep inheritance. Use generics when type relationships matter; do not erase everything to `dynamic` or `Map<String, dynamic>` beyond a decoding boundary. Use private members for implementation details and const constructors where the values permit them.

## Async state is a lifecycle problem

A Future represents later completion, not cancellation or a new isolate. `async` does not offload synchronous CPU work. An awaited operation can complete after disposal, route departure, retry, or a newer request. Check mounted for widget/context use, and check operation identity for relevance; these solve different problems.

Capture an operation generation before starting work, discard stale results and stale errors, and invalidate the generation on cancellation/disposal. Cancel the underlying operation when supported; ignoring results alone does not cancel network or device work. Maintain atomic state transitions before and after suspension. Do not hold a half-mutated model while awaiting.

```dart
class LatestRequest<T> {
  int _generation = 0;
  bool _disposed = false;

  Future<void> run({
    required Future<T> Function() load,
    required void Function(T value) onValue,
    required void Function(Object error, StackTrace stack) onError,
  }) async {
    if (_disposed) return;
    final generation = ++_generation;
    late final T value;
    try {
      value = await load();
    } catch (error, stack) {
      if (!_disposed && generation == _generation) onError(error, stack);
      return;
    }
    if (!_disposed && generation == _generation) onValue(value);
  }

  void invalidate() => _generation++;
  void dispose() {
    _disposed = true;
    invalidate();
  }
}
```

This helper only suppresses stale callbacks. A real repository may already provide cancellation through its state framework; reuse that instead of introducing competing ownership. Errors thrown by `onValue` are not misclassified as loading errors.

Retain exception context and stack traces. Catch the specific recoverable boundary, report an actionable domain error, and avoid empty catches. Log non-sensitive diagnostic context; do not display raw internals or private payloads. `Future.wait` can coordinate independent operations but does not automatically cancel peers; bound large fanout and own failures.

## UI isolate and resource lifetime

Keep build, animation ticks, and gesture callbacks cheap. Use actual profile evidence before adding isolates. For expensive pure transformations use the SDK-supported isolate API, with transferable data and no BuildContext/controller/plugin state. Isolate startup and copying can cost more than small tasks; do not move a trivial formatter off-isolate.

Own controllers, focus nodes, subscriptions, timers, listeners, and platform streams. Create once, replace subscriptions in `didUpdateWidget` when ownership changes, and dispose exactly once. Stop active gesture/hold work on cancellation, inactivity, or route departure as required. `TickerMode` silences ticks while time continues; define pause/resume policy explicitly.

Never start a network call, controller, timer, or notification in build. Stable keys describe real item identity. A completion callback must not duplicate an operation during a rebuild or animation restart. Keep immutable static subtrees outside animation builders.

## Collections, text, and numbers

Use lazy widget builders for large lists and slivers. Avoid nested intrinsic sizing on long content. Choose an algorithm before micro-optimizing allocations; repeated list removal can be quadratic. Do not claim const, final, or a repaint boundary proves smooth frames.

Use grapheme-aware `characters` for initials, truncation, and animated text. Locale plural/number/date formatting belongs to the existing localization layer. Validate nonfinite doubles and unavailable values; preserve exact monetary representation in the domain rather than summing currency as approximate binary floating point.

## Testing and verification

Use `package:test` for pure Dart and `flutter_test` for widget behavior; keep the existing framework conventions. Test invariants: stale completion after retry, cancel/dispose, invalid/empty input, state restoration, and interaction alternatives. Widget tests use controlled pumps for intermediate/reversed motion; repeating animations need finite pumps rather than unconditional `pumpAndSettle`.

Analyze with the project SDK and run targeted behavioral tests. For native channels use a mock binary messenger at the Dart boundary and platform-side integration tests. Mechanical success does not prove physical gesture feel, haptic timing, or sustained raster performance.

Sources: [Dart language](https://dart.dev/language), [Dart concurrency](https://dart.dev/language/concurrency), [Flutter widget lifecycle](https://api.flutter.dev/flutter/widgets/State-class.html).
