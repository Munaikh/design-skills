// Abdullah AlMunaikh's isolated, task-specific package compositions.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:motor/motor.dart';
import 'package:heroine/heroine.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_plus/ionicons_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as rive;
import 'package:motion/motion.dart' as tilt;
import 'package:smooth_sheets/smooth_sheets.dart' as sheets;

/// Call once at startup only when decorative motion is allowed. Set enabled
/// below after successful initialization, and retain a static fallback on error.
Future<void> initializeDecorativeTilt() => tilt.Motion.instance.initialize();

/// Device tilt never carries essential information or hides interactive labels.
class DecorativeTilt extends StatefulWidget {
  const DecorativeTilt({super.key, required this.enabled, required this.child});
  final bool enabled;
  final Widget child;

  @override
  State<DecorativeTilt> createState() => _DecorativeTiltState();
}

class _DecorativeTiltState extends State<DecorativeTilt> {
  // One controller per visible decoration; this type owns no disposable ticker.
  final controller = tilt.MotionController(maxAngle: .1, damping: .3);

  @override
  Widget build(BuildContext context) =>
      !widget.enabled ||
          MediaQuery.disableAnimationsOf(context) ||
          !TickerMode.valuesOf(context).enabled
      ? widget.child
      : tilt.Motion.only(controller: controller, child: widget.child);
}

/// The feature owns this draft controller and disposes it when the feature ends.
/// Closing the sheet preserves its draft; saving returns the trimmed value.
Future<String?> showVisitNoteSheet(
  BuildContext context,
  TextEditingController draft,
) {
  final reduced = MediaQuery.disableAnimationsOf(context);
  return Navigator.of(context).push(
    sheets.ModalSheetRoute<String>(
      transitionDuration: reduced
          ? Duration.zero
          : const Duration(milliseconds: 250),
      barrierLabel: 'Close note editor',
      builder: (context) => sheets.Sheet(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Your visit note',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const ValueKey('sheet_note'),
                    controller: draft,
                    minLines: 2,
                    maxLines: 4,
                    maxLength: 160,
                    decoration: const InputDecoration(labelText: 'Note'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const ValueKey('sheet_save'),
                    onPressed: () =>
                        Navigator.of(context).pop(draft.text.trim()),
                    child: const Text('Save note'),
                  ),
                  TextButton(
                    key: const ValueKey('sheet_close'),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close editor'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Keep the selected state readable even when motion is disabled.
class SelectionSpring extends StatelessWidget {
  const SelectionSpring({
    super.key,
    required this.selected,
    required this.child,
  });
  final bool selected;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final target = selected ? 1.0 : .92;
    if (MediaQuery.disableAnimationsOf(context))
      return Transform.scale(scale: target, child: child);
    return SingleMotionBuilder(
      value: target,
      motion: const CupertinoMotion.smooth(),
      builder: (_, value, child) => Transform.scale(scale: value, child: child),
      child: child,
    );
  }
}

class DeliberateEntrance extends StatelessWidget {
  const DeliberateEntrance({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => MediaQuery.disableAnimationsOf(context)
      ? child
      : child
            .animate()
            .fadeIn(duration: 180.ms)
            .slideY(
              begin: .04,
              end: 0,
              duration: 220.ms,
              curve: Curves.easeOut,
            );
}

/// Register this observer on the navigator that owns both matching tags.
HeroineController sharedElementObserver() => HeroineController();
Widget sharedPlaceImage(BuildContext context, Object tag, Widget image) =>
    MediaQuery.disableAnimationsOf(context)
    ? image
    : Heroine(tag: tag, child: image);

/// Production apps declare the licensed font assets in their pubspec.
/// Disable network fetching before constructing a theme. Missing assets are an
/// integration error: bundle every weight used before calling this function.
TextTheme bundledBrandTypography(TextTheme base) {
  GoogleFonts.config.allowRuntimeFetching = false;
  return GoogleFonts.interTextTheme(base);
}

Widget savedIcon() =>
    const Icon(Ionicons.bookmark_outline, semanticLabel: 'Saved places');

class VisitsChart extends StatelessWidget {
  const VisitsChart({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Visits: Monday 2, Tuesday 4, Wednesday 3.',
    child: ExcludeSemantics(
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 2,
            minY: 0,
            maxY: 5,
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [FlSpot(0, 2), FlSpot(1, 4), FlSpot(2, 3)],
              ),
            ],
          ),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 200),
        ),
      ),
    ),
  );
}

/// Product-owned local files only. The final state communicates success.
class CompletionPlayback extends StatelessWidget {
  const CompletionPlayback({super.key, required this.asset});
  final String asset;
  @override
  Widget build(BuildContext context) {
    const fallback = Icon(
      Icons.check_circle_outline,
      semanticLabel: 'Complete',
    );
    if (MediaQuery.disableAnimationsOf(context)) return fallback;
    return Semantics(
      label: 'Complete',
      child: ExcludeSemantics(
        child: Lottie.asset(
          asset,
          repeat: false,
          errorBuilder: (_, _, _) => fallback,
        ),
      ),
    );
  }
}

/// Reduced motion never opens an asset. An asset-specific child owns the file.
class InteractiveIllustration extends StatelessWidget {
  const InteractiveIllustration({
    super.key,
    required this.asset,
    required this.fallback,
  });
  final String asset;
  final Widget fallback;
  @override
  Widget build(BuildContext context) => MediaQuery.disableAnimationsOf(context)
      ? fallback
      : _IllustrationAsset(
          key: ValueKey(asset),
          asset: asset,
          fallback: fallback,
        );
}

class _IllustrationAsset extends StatefulWidget {
  const _IllustrationAsset({
    super.key,
    required this.asset,
    required this.fallback,
  });
  final String asset;
  final Widget fallback;
  @override
  State<_IllustrationAsset> createState() => _IllustrationAssetState();
}

class _IllustrationAssetState extends State<_IllustrationAsset> {
  late final rive.FileLoader loader;
  @override
  void initState() {
    super.initState();
    loader = rive.FileLoader.fromAsset(
      widget.asset,
      riveFactory: rive.Factory.rive,
    );
  }

  @override
  void dispose() {
    // The builder owns its controller. Dispose the file after its descendant
    // controller has unmounted and any in-flight load has finished.
    unawaited(
      Future.wait<void>([
        loader.file().then<void>((_) {}, onError: (Object _, StackTrace _) {}),
        WidgetsBinding.instance.endOfFrame,
      ]).then((_) => loader.dispose()),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return rive.RiveWidgetBuilder(
      fileLoader: loader,
      builder: (_, state) => switch (state) {
        rive.RiveLoaded() => rive.RiveWidget(controller: state.controller),
        rive.RiveLoading() || rive.RiveFailed() => widget.fallback,
      },
    );
  }
}
