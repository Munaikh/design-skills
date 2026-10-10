import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_design_examples/app_tokens.dart';
import 'package:flutter_design_examples/capped_entrance.dart';
import 'package:flutter_design_examples/fade_visibility.dart';
import 'package:flutter_design_examples/latest_request.dart';
import 'package:flutter_design_examples/removable_row.dart';
import 'package:flutter_design_examples/snap_motion.dart';
import 'package:flutter_design_examples/threshold_gate.dart';
import 'package:flutter_design_examples/visual_active_mask.dart';

Widget host(Widget child, {bool reduced = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Scaffold(body: child),
  ),
);

void main() {
  test('projection respects direction, bounds, and invalid inputs', () {
    expect(
      projectWithinBounds(
        position: 50,
        velocityDpPerSecond: 1000,
        min: 0,
        max: 100,
      ),
      100,
    );
    expect(
      projectWithinBounds(
        position: 50,
        velocityDpPerSecond: -1000,
        min: 0,
        max: 100,
      ),
      0,
    );
    expect(
      () => projectWithinBounds(
        position: 0,
        velocityDpPerSecond: 0,
        min: 0,
        max: 100,
        decelerationRate: 1,
      ),
      throwsArgumentError,
    );
    expect(
      () => projectWithinBounds(
        position: double.nan,
        velocityDpPerSecond: 0,
        min: 0,
        max: 100,
      ),
      throwsArgumentError,
    );
  });

  test('rubber band preserves sign and increasingly resists overshoot', () {
    expect(rubberBand(100, 400), greaterThan(0));
    expect(rubberBand(-100, 400), -rubberBand(100, 400));
    expect(rubberBand(200, 400), lessThan(rubberBand(100, 400) * 2));
    expect(rubberBand(100, 0), 0);
  });

  test('threshold hysteresis prevents duplicate side effects', () {
    final gate = ThresholdGate(enter: 80, exit: 60);
    expect(gate.update(79), isNull);
    expect(gate.update(80), isTrue);
    expect(gate.update(81), isNull);
    expect(gate.update(79), isNull);
    expect(gate.update(61), isNull);
    expect(gate.update(60), isFalse);
    expect(gate.update(80), isTrue);
    gate.reset();
    expect(gate.armed, isFalse);
    expect(() => ThresholdGate(enter: 60, exit: 80), throwsArgumentError);
    expect(() => gate.update(double.nan), throwsArgumentError);
  });

  test('latest request discards stale values and errors', () async {
    final latest = LatestRequest<int>();
    final old = Completer<int>();
    final current = Completer<int>();
    final values = <int>[];
    final errors = <Object>[];
    final first = latest.run(
      load: () => old.future,
      onValue: values.add,
      onError: (error, stack) => errors.add(error),
    );
    final second = latest.run(
      load: () => current.future,
      onValue: values.add,
      onError: (error, stack) => errors.add(error),
    );
    current.complete(2);
    await second;
    old.completeError(StateError('stale failure'));
    await first;
    expect(values, [2]);
    expect(errors, isEmpty);
  });

  test(
    'disposal suppresses completion without claiming cancellation',
    () async {
      final latest = LatestRequest<int>();
      final pending = Completer<int>();
      final values = <int>[];
      final run = latest.run(
        load: () => pending.future,
        onValue: values.add,
        onError: (error, stack) => fail('No callback after disposal'),
      );
      latest.dispose();
      pending.complete(1);
      await run;
      expect(values, isEmpty);
    },
  );

  testWidgets('hidden fading content cannot tap or enter semantics', (
    tester,
  ) async {
    var taps = 0;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        FadeVisibility(
          visible: false,
          child: TextButton(
            onPressed: () => taps++,
            child: const Text('Hidden action'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Hidden action'), warnIfMissed: false);
    expect(taps, 0);
    expect(find.bySemanticsLabel('Hidden action'), findsNothing);
    semantics.dispose();
  });

  testWidgets('fade reverses from presentation rather than restarting', (
    tester,
  ) async {
    final visible = ValueNotifier(false);
    await tester.pumpWidget(
      host(
        ValueListenableBuilder<bool>(
          valueListenable: visible,
          builder: (context, value, child) =>
              FadeVisibility(visible: value, child: const Text('Fade content')),
        ),
      ),
    );
    visible.value = true;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final scope = find.descendant(
      of: find.byType(FadeVisibility),
      matching: find.byType(FadeTransition),
    );
    final before = tester.widget<FadeTransition>(scope).opacity.value;
    expect(before, inExclusiveRange(0.0, 1.0));
    visible.value = false;
    await tester.pump();
    final after = tester.widget<FadeTransition>(scope).opacity.value;
    expect(after, closeTo(before, 0.001));
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.widget<FadeTransition>(scope).opacity.value, 0);
    await tester.pumpWidget(const SizedBox());
    visible.dispose();
  });

  testWidgets('reduced motion settles the fade immediately', (tester) async {
    final visible = ValueNotifier(false);
    await tester.pumpWidget(
      host(
        ValueListenableBuilder<bool>(
          valueListenable: visible,
          builder: (context, value, child) =>
              FadeVisibility(visible: value, child: const Text('Reduced')),
        ),
        reduced: true,
      ),
    );
    visible.value = true;
    await tester.pump();
    final scope = find.descendant(
      of: find.byType(FadeVisibility),
      matching: find.byType(FadeTransition),
    );
    expect(tester.widget<FadeTransition>(scope).opacity.value, 1);
    await tester.pumpWidget(const SizedBox());
    visible.dispose();
  });

  testWidgets('capped entrance completes without replay on rebuild', (
    tester,
  ) async {
    final rerender = ValueNotifier(0);
    await tester.pumpWidget(
      host(
        ValueListenableBuilder<int>(
          valueListenable: rerender,
          builder: (context, value, child) => CappedEntrance(
            children: [Text('Group $value'), const Text('Second')],
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    rerender.value++;
    await tester.pump();
    final opacity = find.descendant(
      of: find.byType(CappedEntrance),
      matching: find.byType(Opacity),
    );
    expect(opacity, findsNWidgets(2));
    expect(
      tester.widgetList<Opacity>(opacity).every((o) => o.opacity == 1),
      isTrue,
    );
    await tester.pumpWidget(const SizedBox());
    rerender.dispose();
  });

  testWidgets('changing reduced motion midflight completes the group', (
    tester,
  ) async {
    final reduced = ValueNotifier(false);
    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<bool>(
          valueListenable: reduced,
          builder: (context, value, child) => MediaQuery(
            data: MediaQueryData(disableAnimations: value),
            child: const CappedEntrance(
              children: [Text('First'), Text('Second')],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 40));
    reduced.value = true;
    await tester.pump();
    final opacity = find.descendant(
      of: find.byType(CappedEntrance),
      matching: find.byType(Opacity),
    );
    expect(opacity, findsNWidgets(2));
    expect(
      tester.widgetList<Opacity>(opacity).every((o) => o.opacity == 1),
      isTrue,
    );
    await tester.pumpWidget(const SizedBox());
    reduced.dispose();
  });

  testWidgets(
    'entrance completion and reduced motion preserve child identity',
    (tester) async {
      var initializations = 0;
      final reduced = ValueNotifier(false);
      await tester.pumpWidget(
        MaterialApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: reduced,
            builder: (context, value, child) => MediaQuery(
              data: MediaQueryData(disableAnimations: value),
              child: CappedEntrance(
                children: [
                  EntranceProbe(onInitialize: () => initializations++),
                ],
              ),
            ),
          ),
        ),
      );
      expect(initializations, 1);
      await tester.pump(const Duration(milliseconds: 40));
      reduced.value = true;
      await tester.pump();
      expect(initializations, 1);
      await tester.pump(const Duration(milliseconds: 400));
      expect(initializations, 1);
      expect(find.text('Retained child'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      reduced.dispose();
    },
  );

  testWidgets('spring retarget preserves position and velocity', (
    tester,
  ) async {
    final motion = SnapMotion(vsync: tester);
    motion.retarget(200, releaseVelocityDpPerSecond: 400, momentum: true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final current = motion.position.value;
    final speed = motion.position.velocity;
    expect(current, greaterThan(0));
    motion.retarget(0);
    expect(motion.position.value, closeTo(current, 0.001));
    expect(motion.position.velocity, closeTo(speed, 0.001));
    motion.retarget(10, reducedMotion: true);
    expect(motion.position.value, 10);
    expect(motion.position.isAnimating, isFalse);
    motion.dispose();
  });

  testWidgets('decorative active layer has no duplicate control semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        VisualActiveMask(
          activeRect: const Rect.fromLTWH(0, 0, 100, 100),
          child: TextButton(
            onPressed: () {},
            child: const Text('Decorative tab'),
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Decorative tab'), findsNothing);
    semantics.dispose();
  });

  testWidgets('explicit remove action works at large text and RTL', (
    tester,
  ) async {
    var removals = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: 320,
                child: RemovableRow(
                  id: 'row-1',
                  label: 'Aleksandra Wiśniewska-Kowalczyk',
                  confirmRemoval: () async => true,
                  onRemoved: () => removals++,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Remove'));
    await tester.pump();
    expect(removals, 1);
  });

  testWidgets('canceled swipe leaves row in the collection', (tester) async {
    var removals = 0;
    await tester.pumpWidget(
      host(
        RemovableRow(
          id: 'cancel',
          label: 'Keep this item',
          confirmRemoval: () async => false,
          onRemoved: () => removals++,
        ),
      ),
    );
    await tester.drag(find.byType(Dismissible), const Offset(-700, 0));
    await tester.pumpAndSettle();
    expect(removals, 0);
    expect(find.text('Keep this item'), findsOneWidget);
  });

  test(
    'theme interpolation retains endpoint tokens and useful middle values',
    () {
      const light = AppTokens(
        background: Colors.white,
        surface: Colors.white,
        textPrimary: Colors.black,
        textMuted: Colors.grey,
        border: Colors.grey,
        medium: 16,
      );
      const dark = AppTokens(
        background: Colors.black,
        surface: Colors.black,
        textPrimary: Colors.white,
        textMuted: Colors.grey,
        border: Colors.grey,
        medium: 24,
      );
      expect(light.lerp(dark, 0).background, light.background);
      expect(light.lerp(dark, 1).background, dark.background);
      expect(light.lerp(dark, .5).medium, 20);
    },
  );
}

class EntranceProbe extends StatefulWidget {
  const EntranceProbe({super.key, required this.onInitialize});
  final VoidCallback onInitialize;
  @override
  State<EntranceProbe> createState() => _EntranceProbeState();
}

class _EntranceProbeState extends State<EntranceProbe> {
  @override
  void initState() {
    super.initState();
    widget.onInitialize();
  }

  @override
  Widget build(BuildContext context) => const Text('Retained child');
}
