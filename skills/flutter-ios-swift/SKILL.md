---
name: flutter-ios-swift
description: Write or review Swift used by Flutter iOS plugins, platform channels, platform views, AppDelegate integrations, and native device APIs. Use only at an iOS boundary in a Flutter app.
metadata:
  author: Abdullah
  edition: Flutter mobile
---

# Swift for Flutter iOS

Flutter mobile edition, adapted from Emil Kowalski’s design-skills. Original MIT attribution is preserved.

Follow the [Flutter/Dart coding conventions](references/dart-engineering.md): inspect project truth, preserve architecture and generation patterns, keep typed readable code and flat widget composition, and validate proportionally. For Flutter-side UI, use Flutter Animate by default for effects, or simple implicit widgets such as AnimatedContainer. Use Motor for physics and Heroine for shared elements; do not introduce stock Hero. Use Smooth Sheets for sheets and Motion for purposeful 3D tilt/parallax. Reserve low-level stock controllers, tween timelines, and simulations for very complex custom animation mixers that these tools cannot express. Follow the [preferred toolkit](references/toolkit.md) for integration details.

Use no ink splashes or ripples: disable them centrally with `NoSplash.splashFactory` and transparent `splashColor`, and audit local overrides. Build intentional custom components or deliberately themed semantic primitives; do not use unstyled stock Material for everything. Preserve pressed, focused, selected, and disabled feedback. Keep shadows restrained, shared, and purposeful for hierarchy, following Emil’s cohesion and attention to unseen details. See [theme and component appearance](references/theme-patterns.md).

## Visual inspection for visible UI work

Before building or judging visible UI, read [theme foundations](references/theme-patterns.md). Inspect the affected screen and its opened menus in light and dark themes: compare back and action controls together, field/card separation, shape, spacing, icon weight, type, and focus/error states. Use greyish off-white/off-black structural surfaces, never pure white/black or colored canvas defaults. A glass app bar does not make a stock child button or popup coherent. Check the trigger and opened overlay, not only the shell. Verify rendered control bounds against parent constraints, and scroll content beneath glass chrome while keeping initial and final controls reachable; a declared square size or transparent bar alone proves neither. Passing journey tests or analysis does not establish visual quality; report UX and visual evidence separately. If runtime inspection is unavailable, identify that limit rather than claiming a visual pass.

Preserve architecture and approved product intent, but do not treat unfinished seed styling as an approved design system. Fix observed visual defects within authorized implementation scope; keep reviews read-only unless fixes were requested. Apply this check proportionally to the affected UI, not to unrelated screens or pure non-UI bridge/data changes.

Read [ios-bridge.md](references/ios-bridge.md). Inspect the Flutter embedding, plugin registration, deployment target, Xcode/Swift toolchain, current channel schema, and app lifecycle before editing. Keep product UI and ordinary app state in Dart; Swift handles capabilities that require iOS.

Use typed bridge contracts, main-thread UI interactions, explicit async/cancellation ownership, exactly-once replies, and domain error mapping. Preserve the app’s registration and lifecycle model rather than replacing it with a standalone native app.

Run relevant Dart boundary tests and the project’s iOS build/native tests when available. State unavailable signing, runtime, device, or platform-module checks honestly. Do not silently upgrade Swift language settings or adopt unreleased syntax.

## Evidence storage

Follow [evidence policy](references/evidence-policy.md): temporary captures, automatic session reports off, and concise results in chat. Save durable reports only when requested.
