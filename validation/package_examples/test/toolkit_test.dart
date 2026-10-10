import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toolkit_examples/toolkit_examples.dart';

Widget host(Widget child, {bool reduced = false}) => MaterialApp(
  theme: ThemeData(
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
  ),
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Scaffold(body: child),
  ),
);

double selectionScale(WidgetTester tester) => tester
    .widget<Transform>(
      find
          .descendant(
            of: find.byType(SelectionSpring),
            matching: find.byType(Transform),
          )
          .first,
    )
    .transform
    .storage[0];

void main() {
  testWidgets(
    'spring retargets before settling and reduced motion reaches final state',
    (tester) async {
      await tester.pumpWidget(
        host(const SelectionSpring(selected: false, child: Text('Selection'))),
      );
      await tester.pumpWidget(
        host(const SelectionSpring(selected: true, child: Text('Selection'))),
      );
      await tester.pump(const Duration(milliseconds: 40));
      final interruptedScale = selectionScale(tester);
      expect(interruptedScale, greaterThan(.92));
      expect(interruptedScale, lessThan(1));
      await tester.pumpWidget(
        host(const SelectionSpring(selected: false, child: Text('Selection'))),
      );
      expect(selectionScale(tester), closeTo(interruptedScale, .001));
      await tester.pumpAndSettle();
      final scale = tester
          .widget<Transform>(
            find
                .descendant(
                  of: find.byType(SelectionSpring),
                  matching: find.byType(Transform),
                )
                .first,
          )
          .transform
          .storage[0];
      expect(scale, closeTo(.92, .001));
      await tester.pumpWidget(
        host(
          const SelectionSpring(selected: true, child: Text('Selection')),
          reduced: true,
        ),
      );
      expect(
        tester
            .widget<Transform>(
              find
                  .descendant(
                    of: find.byType(SelectionSpring),
                    matching: find.byType(Transform),
                  )
                  .first,
            )
            .transform
            .storage[0],
        1,
      );
    },
  );
  testWidgets(
    'reduced motion skips decorative assets and leaves completion accessible',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          host(
            const Column(
              children: [
                CompletionPlayback(asset: 'assets/product-completion.json'),
                InteractiveIllustration(
                  asset: 'assets/product.riv',
                  fallback: Text('Ready'),
                ),
                DeliberateEntrance(child: Text('Welcome')),
                DecorativeTilt(enabled: true, child: Text('Place artwork')),
              ],
            ),
            reduced: true,
          ),
        );
        expect(find.bySemanticsLabel('Complete'), findsOneWidget);
        expect(find.text('Ready'), findsOneWidget);
        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('Place artwork'), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
  testWidgets('chart supplies an equivalent readable summary', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(host(const VisitsChart(), reduced: true));
      expect(
        find.bySemanticsLabel('Visits: Monday 2, Tuesday 4, Wednesday 3.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets(
    'closing and reopening a sheet retains its draft and save result',
    (tester) async {
      final draft = TextEditingController();
      String? saved;
      try {
        await tester.pumpWidget(
          host(
            Builder(
              builder: (context) => TextButton(
                onPressed: () async =>
                    saved = await showVisitNoteSheet(context, draft),
                child: const Text('Edit note'),
              ),
            ),
            reduced: true,
          ),
        );
        await tester.tap(find.text('Edit note'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('sheet_note')),
          '  Bring a sketchbook  ',
        );
        await tester.tap(find.byKey(const ValueKey('sheet_close')));
        await tester.pumpAndSettle();
        expect(saved, isNull);
        expect(draft.text, '  Bring a sketchbook  ');
        await tester.tap(find.text('Edit note'));
        await tester.pumpAndSettle();
        expect(find.text('  Bring a sketchbook  '), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('sheet_save')));
        await tester.pumpAndSettle();
        expect(saved, 'Bring a sketchbook');
        expect(find.text('Your visit note'), findsNothing);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        draft.dispose();
      }
    },
  );
}
