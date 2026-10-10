// Abdullah AlMunaikh: observable journeys, recovery, and adaptive continuity.
import 'dart:ui' show DisplayFeature, DisplayFeatureType, DisplayFeatureState;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mobile_reference/place_store.dart';
import 'package:flutter_mobile_reference/reference_app.dart';

Future<PlaceStore> start(WidgetTester tester) async {
  final store = PlaceStore(latency: const Duration(milliseconds: 10));
  addTearDown(store.dispose);
  await tester.pumpWidget(
    ReferenceApp(store: store, platform: TargetPlatform.android),
  );
  await tester.pumpAndSettle();
  return store;
}

Future<void> tap(WidgetTester tester, String key) async {
  final target = find.byKey(ValueKey(key));
  if (target.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      target,
      200,
      scrollable: find
          .descendant(
            of: find.byType(ListView).first,
            matching: find.byType(Scrollable),
          )
          .first,
    );
  }
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('discover, save, revisit and edit a note', (tester) async {
    await start(tester);
    await tap(tester, 'place_garden');
    await tester.enterText(
      find.byKey(const ValueKey('place_note')),
      'Bring a book',
    );
    await tap(tester, 'save_place');
    expect(find.text('Saved to your places'), findsOneWidget);
    await tap(tester, 'view_saved');
    expect(find.textContaining('Bring a book'), findsOneWidget);
    await tap(tester, 'place_garden');
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('place_note')))
          .controller!
          .text,
      'Bring a book',
    );
    await tester.enterText(
      find.byKey(const ValueKey('place_note')),
      'Bring two books',
    );
    expect(find.text('Saved to your places'), findsNothing);
    await tap(tester, 'save_place');
    await tap(tester, 'back_to_list');
    expect(find.textContaining('Bring two books'), findsOneWidget);
  });

  testWidgets('failed load retries and failed save retains the draft', (
    tester,
  ) async {
    final store = await start(tester);
    store.setFixture(Fixture.loadFailure);
    await tester.pumpAndSettle();
    expect(find.text('Places could not load'), findsOneWidget);
    await tap(tester, 'retry_load');
    await tap(tester, 'place_garden');
    store.setFixture(Fixture.saveFailure);
    await tester.pumpAndSettle();
    await tap(tester, 'place_garden');
    await tester.enterText(
      find.byKey(const ValueKey('place_note')),
      'Retain this draft',
    );
    await tap(tester, 'save_place');
    expect(find.textContaining('Your note is still here'), findsOneWidget);
    expect(store.draft(demoPlaces.first).text, 'Retain this draft');
    await tap(tester, 'save_place');
    expect(find.text('Saved to your places'), findsOneWidget);
  });

  testWidgets('view saved returns to its list and retains the Discover draft', (
    tester,
  ) async {
    final store = await start(tester);
    await tap(tester, 'place_garden');
    await tester.enterText(
      find.byKey(const ValueKey('place_note')),
      'Bring a book',
    );
    await tap(tester, 'save_place');
    await tap(tester, 'view_saved');
    await tap(tester, 'place_garden');
    await tester.enterText(
      find.byKey(const ValueKey('place_note')),
      'An unfinished edit',
    );
    await tap(tester, 'view_saved');
    expect(store.tab, 1);
    expect(store.details[1], isNull);
    expect(find.text('Good places, kept close.'), findsOneWidget);
    expect(find.textContaining('Bring a book'), findsOneWidget);
    expect(store.draft(demoPlaces.first).text, 'An unfinished edit');
    await tap(tester, 'tab_discover');
    expect(store.currentDetail?.id, 'garden');
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('place_note')))
          .controller!
          .text,
      'An unfinished edit',
    );
  });

  testWidgets(
    'empty catalogue and unmatched search offer accurate next steps',
    (tester) async {
      final store = await start(tester);
      store.setFixture(Fixture.empty);
      await tester.pumpAndSettle();
      expect(find.text('No places to explore yet'), findsOneWidget);
      expect(find.byKey(const ValueKey('empty_action')), findsNothing);
      expect(find.byKey(const ValueKey('search_places')), findsNothing);
      store.setFixture(Fixture.demo);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('search_places')),
        'not-a-place',
      );
      await tester.pumpAndSettle();
      expect(find.text('No places found'), findsOneWidget);
      await tap(tester, 'empty_action');
      expect(store.search.text, isEmpty);
      expect(find.byKey(const ValueKey('place_garden')), findsOneWidget);
    },
  );

  testWidgets(
    'tab, search, draft and detail scroll survive narrow and wide layouts',
    (tester) async {
      tester.view.physicalSize =
          const Size(390, 844) * tester.view.devicePixelRatio;
      addTearDown(tester.view.resetPhysicalSize);
      final store = await start(tester);
      await tester.enterText(
        find.byKey(const ValueKey('search_places')),
        'Garden',
      );
      await tap(tester, 'place_garden');
      await tester.enterText(
        find.byKey(const ValueKey('place_note')),
        'Unfinished note',
      );
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('save_place')),
        150,
        scrollable: find
            .descendant(
              of: find.byType(ListView).first,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      final offset = store.detailScroll(demoPlaces.first, 0).offset;
      await tap(tester, 'tab_saved');
      await tap(tester, 'tab_discover');
      expect(store.currentDetail?.id, 'garden');
      for (final size in [const Size(1100, 844), const Size(390, 844)]) {
        tester.view.physicalSize = size * tester.view.devicePixelRatio;
        await tester.pumpAndSettle();
        expect(store.draft(demoPlaces.first).text, 'Unfinished note');
        expect(store.search.text, 'Garden');
        expect(
          store.detailScroll(demoPlaces.first, 0).offset,
          closeTo(
            offset.clamp(
              0,
              store.detailScroll(demoPlaces.first, 0).position.maxScrollExtent,
            ),
            1,
          ),
        );
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('large text, RTL and keyboard insets keep recovery usable', (
    tester,
  ) async {
    tester.view.physicalSize =
        const Size(360, 800) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    final store = PlaceStore(latency: Duration.zero);
    addTearDown(store.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 800),
            textScaler: TextScaler.linear(2),
            viewInsets: EdgeInsets.only(bottom: 300),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListenableBuilder(
              listenable: store,
              builder: (_, _) => JourneyShell(store: store),
            ),
          ),
        ),
      ),
    );
    store.setFixture(Fixture.loadFailure);
    await tester.pumpAndSettle();
    await tap(tester, 'retry_load');
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('search_places')),
      100,
      scrollable: find
          .descendant(
            of: find.byType(ListView).first,
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.byKey(const ValueKey('search_places')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'an occluding hinge keeps the journey in a safe pane without losing its draft',
    (tester) async {
      tester.view.physicalSize =
          const Size(1100, 844) * tester.view.devicePixelRatio;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDisplayFeatures);
      final store = await start(tester);
      await tap(tester, 'place_garden');
      await tester.enterText(
        find.byKey(const ValueKey('place_note')),
        'Keep through a fold',
      );
      tester.view.displayFeatures = [
        const DisplayFeature(
          bounds: Rect.fromLTWH(540, 0, 20, 844),
          type: DisplayFeatureType.hinge,
          state: DisplayFeatureState.postureHalfOpened,
        ),
      ];
      await tester.pumpAndSettle();
      final detail = tester.getRect(
        find.byKey(const ValueKey('detail_content_garden')),
      );
      expect(detail.right, lessThanOrEqualTo(540));
      expect(store.currentDetail?.id, 'garden');
      expect(store.draft(demoPlaces.first).text, 'Keep through a fold');
      tester.view.resetDisplayFeatures();
      await tester.pumpAndSettle();
      expect(store.draft(demoPlaces.first).text, 'Keep through a fold');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('system back returns to the parent and preserves search', (
    tester,
  ) async {
    final store = await start(tester);
    await tester.enterText(
      find.byKey(const ValueKey('search_places')),
      'Garden',
    );
    await tap(tester, 'place_garden');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(store.currentDetail, isNull);
    expect(store.search.text, 'Garden');
    expect(find.byKey(const ValueKey('place_garden')), findsOneWidget);
  });

  test(
    'superseded fixture and disposed store cannot commit asynchronous results',
    () async {
      final store = PlaceStore(latency: const Duration(milliseconds: 5));
      await store.load();
      store.draft(demoPlaces.first).text = 'old fixture';
      final pending = store.save(demoPlaces.first);
      store.setFixture(Fixture.empty);
      await pending;
      expect(store.saved, isEmpty);
      expect(store.saving, isEmpty);
      final loading = store.load();
      store.dispose();
      await loading;
    },
  );
}
