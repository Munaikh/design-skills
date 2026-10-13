// Abdullah AlMunaikh: observable journeys, recovery, and adaptive continuity.
import 'dart:ui' show DisplayFeature, DisplayFeatureType, DisplayFeatureState;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mobile_reference/place_store.dart';
import 'package:flutter_mobile_reference/reference_app.dart';
import 'package:native_liquid_glass/native_liquid_glass.dart';

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
  testWidgets(
    'unsupported iOS keeps accessible fallback and content-owned clearance',
    (tester) async {
      tester.view.physicalSize =
          const Size(402, 874) * tester.view.devicePixelRatio;
      tester.view.padding = FakeViewPadding(
        top: 62 * tester.view.devicePixelRatio,
        bottom: 34 * tester.view.devicePixelRatio,
      );
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetViewInsets);
      final store = PlaceStore(latency: Duration.zero);
      addTearDown(store.dispose);
      await tester.pumpWidget(
        ReferenceApp(store: store, platform: TargetPlatform.iOS),
      );
      await tester.pumpAndSettle();
      final list = find.byKey(const ValueKey('place_list_0'));
      final appBar = find.byKey(const ValueKey('fallback_app_bar'));
      final tabs = find.byKey(const ValueKey('fallback_tabs'));
      expect(tester.getRect(list).top, 0);
      expect(tester.getRect(list).bottom, tester.getRect(tabs).bottom);
      final listPadding = tester.widget<ListView>(list).padding! as EdgeInsets;
      expect(listPadding.top, tester.getRect(appBar).bottom + 24);
      expect(listPadding.bottom, tester.getSize(tabs).height + 24);
      expect(
        tester.getSize(find.byKey(const ValueKey('test_scenarios'))),
        const Size(journeyToolbarExtent, journeyToolbarExtent),
      );
      await tap(tester, 'place_garden');
      expect(
        tester.getSize(find.byKey(const ValueKey('back_to_list'))),
        const Size(journeyToolbarExtent, journeyToolbarExtent),
      );
      final detail = find.byKey(const ValueKey('detail_content_garden'));
      expect(tester.getRect(detail).top, 0);
      store
          .detailScroll(demoPlaces.first, 0)
          .jumpTo(
            store.detailScroll(demoPlaces.first, 0).position.maxScrollExtent,
          );
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byKey(const ValueKey('view_saved'))).bottom,
        lessThan(tester.getRect(tabs).top),
      );
      tester.view.viewInsets = FakeViewPadding(
        bottom: 300 * tester.view.devicePixelRatio,
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(detail).height, 574);
      await Scrollable.ensureVisible(
        tester.element(find.byKey(const ValueKey('place_note'))),
        alignment: 0.35,
      );
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byKey(const ValueKey('place_note'))).bottom,
        lessThanOrEqualTo(tester.getRect(tabs).top),
      );
      store
          .detailScroll(demoPlaces.first, 0)
          .jumpTo(
            store.detailScroll(demoPlaces.first, 0).position.maxScrollExtent,
          );
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byKey(const ValueKey('view_saved'))).bottom,
        lessThan(tester.getRect(tabs).top),
      );
      store.setFixture(Fixture.loadFailure);
      await tester.pumpAndSettle();
      final retry = find.byKey(const ValueKey('retry_load'));
      final recoveryViewport = find.ancestor(
        of: retry,
        matching: find.byType(SingleChildScrollView),
      );
      expect(tester.getRect(recoveryViewport).top, 0);
      expect(tester.getSize(recoveryViewport).height, 574);
      expect(
        tester.getRect(retry).top,
        greaterThan(tester.getRect(appBar).bottom),
      );
      expect(tester.getRect(retry).bottom, lessThan(tester.getRect(tabs).top));
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets(
    'fallback fixture popup dismisses before detail and retains draft',
    (tester) async {
      await start(tester);
      expect(find.byType(LiquidGlassNavigationBar), findsNothing);
      expect(find.byType(LiquidGlassTabBar), findsNothing);
      await tap(tester, 'place_garden');
      await tester.enterText(
        find.byKey(const ValueKey('place_note')),
        'Keep this draft',
      );
      await tap(tester, 'test_scenarios');
      for (final fixture in Fixture.values) {
        expect(find.byKey(ValueKey('fixture_${fixture.name}')), findsOneWidget);
      }
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('fixture_demo')), findsNothing);
      expect(find.byKey(const ValueKey('place_note')), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('place_note')))
            .controller!
            .text,
        'Keep this draft',
      );
      await tap(tester, 'back_to_list');
      expect(find.byKey(const ValueKey('place_list_0')), findsOneWidget);
    },
  );

  testWidgets('saved rows expose their status without relying on the icon', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await start(tester);
    await tap(tester, 'place_garden');
    await tap(tester, 'save_place');
    await tap(tester, 'back_to_list');
    final row = find.byKey(const ValueKey('place_garden'));
    expect(tester.getSemantics(row).label, contains('Saved'));
    semantics.dispose();
  });

  testWidgets('wide short detail keeps its secondary panel usable', (
    tester,
  ) async {
    tester.view.physicalSize =
        const Size(1100, 230) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await start(tester);
    await tap(tester, 'place_garden');
    expect(tester.takeException(), isNull);
  });

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
