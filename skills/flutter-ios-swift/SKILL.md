---
name: flutter-ios-swift
description: Write or review Swift used by Flutter iOS plugins, platform channels, platform views, AppDelegate integrations, and native device APIs. Use only at an iOS boundary in a Flutter app.
metadata:
  author: Abdullah
  edition: Flutter mobile
---

# Swift for Flutter iOS

Flutter mobile edition, adapted from Emil Kowalski’s design-skills. Original MIT attribution is preserved.

Apply these experience rules only when the integration changes visible UI; pure channel/data work does not trigger a design pass.

## Core experience requirements

Reuse the codebase's design-system components. Redesign them only when asked to redesign the feature; fixes must preserve their established appearance and behavior. For new UI without that system, avoid raw Material appearance and build semantic product components. Read [theme and component policy](references/theme-patterns.md) before visible UI work.

iOS is the default design target; Android adapts the product identity while retaining its own back, input, accessibility, and navigation conventions. For new or redesigned iOS 26+ tab navigation, use a real native iOS tab bar whenever supported, not a Material or custom substitute unless instructed otherwise. Native Liquid Glass is iOS 26+ only. Older iOS uses custom components when support is requested. For simple new apps, state the iOS 26+ assumption and ask how older iOS should behave before choosing its fallback or changing deployment targets. Preserve an existing design system outside a requested redesign. Follow [native integration and fallbacks](references/toolkit.md).

Microinteractions are core: provide immediate animated response and continuity for relevant actions and state changes, with interruption and reduced-motion handling. Keep mobile copy short; let layout, controls, and feedback explain the experience. Consider swipe dismissal and card-to-page continuity where they fit the task, with visible alternatives and work preservation. These rules are scoped to affected UI, not permission to redesign unrelated features.

Follow [Dart engineering](references/dart-engineering.md) and the [preferred toolkit](references/toolkit.md). Use no ink splashes or ripples; keep accessible press, focus, selection, and disabled feedback. Shared motion and appearance details live in the references rather than a second component system.

## Visual inspection for visible UI work

Before building or judging visible UI, read [theme foundations](references/theme-patterns.md). Inspect the affected screen and its opened menus in light and dark themes: compare back and action controls together, field/card separation, shape, spacing, icon weight, type, and focus/error states. For a new visual system, use greyish off-white/off-black structural surfaces; preserve an existing design system outside a requested redesign. A glass app bar does not make a stock child button or popup coherent. Check the trigger and opened overlay, not only the shell. Verify rendered control bounds against parent constraints, and scroll content beneath glass chrome while keeping initial and final controls reachable; a declared square size or transparent bar alone proves neither. Passing journey tests or analysis does not establish visual quality; report UX and visual evidence separately. If runtime inspection is unavailable, identify that limit rather than claiming a visual pass.

Reuse the existing design system and preserve architecture. Redesign components only for a requested feature redesign; report other visual opportunities without silently applying them. Keep reviews read-only unless fixes were requested. Apply this check proportionally to the affected UI, not to unrelated screens or pure non-UI bridge/data changes.

Read [ios-bridge.md](references/ios-bridge.md). Inspect the Flutter embedding, plugin registration, deployment target, Xcode/Swift toolchain, current channel schema, and app lifecycle before editing. Keep product UI and ordinary app state in Dart; Swift handles capabilities that require iOS.

Use typed bridge contracts, main-thread UI interactions, explicit async/cancellation ownership, exactly-once replies, and domain error mapping. Preserve the app’s registration and lifecycle model rather than replacing it with a standalone native app.

Run relevant Dart boundary tests and the project’s iOS build/native tests when available. State unavailable signing, runtime, device, or platform-module checks honestly. Do not silently upgrade Swift language settings or adopt unreleased syntax.

## Evidence storage

Follow [evidence policy](references/evidence-policy.md): temporary captures, automatic session reports off, and concise results in chat. Save durable reports only when requested.
