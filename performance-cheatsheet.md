# Abdullah AlMunaikh’s Flutter mobile performance cheatsheet

Measure profile-mode UI and raster frames on a supported physical device. Debug timing and package names do not prove performance. At 60Hz a frame has about 16.7ms; at 120Hz about 8.3ms.

| Symptom | Investigate and fix |
| --- | --- |
| Animation stalls during loading | UI-isolate synchronous work; narrow animation builders and offload measured heavy transformations |
| Whole screen rebuilds each tick | Local controller/listenable and static `AnimatedBuilder.child`; avoid high-level state updates |
| Large list stutters | Lazy builders/slivers, row cost, decoding, image sizing, stable keys, pagination policy |
| Raster time spikes | Opacity layers, blur, masks, shadows, clips, `saveLayer`; simplify the measured surface |
| Expansion causes many layout passes | Purposeful `AnimatedSize` in a bounded subtree; avoid intrinsics and giant animated constraints |
| Gesture jumps when re-grabbed | Current visual position and velocity; no controller reset to zero |
| Recycled rows replay entrances | Durable once-only policy; insertion/reflow animation instead of mount choreography |
| App keeps animating while inactive | Explicit route/app lifecycle policy; owned timers/controllers and cancellation |
| Image appearance shifts layout | Stable dimensions/aspect ratio, placeholders, bounded decode dimensions |
| Reduced motion still travels | Read `MediaQuery.disableAnimationsOf`; static or gentle meaningful feedback |

A `Transform` can avoid child relayout, but it is not a guarantee of off-isolate animation. Apply `RepaintBoundary` only where repaint evidence warrants isolation. Record representative before/after traces and percentile/missed-frame behavior under real interaction and loading.

Source: [Flutter performance best practices](https://docs.flutter.dev/perf/best-practices).
