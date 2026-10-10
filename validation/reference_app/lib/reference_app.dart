// Abdullah AlMunaikh's phone-first reference experience.
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'place_store.dart';

class ReferenceApp extends StatefulWidget {
  const ReferenceApp({super.key, this.store, this.platform});
  final PlaceStore? store;
  final TargetPlatform? platform;
  @override
  State<ReferenceApp> createState() => _ReferenceAppState();
}

class _ReferenceAppState extends State<ReferenceApp> {
  late final PlaceStore store = widget.store ?? PlaceStore();
  @override
  void initState() {
    super.initState();
    store.load();
  }

  @override
  void dispose() {
    if (widget.store == null) store.dispose();
    super.dispose();
  }

  ThemeData theme(Brightness brightness) {
    const corners = BorderRadius.all(Radius.circular(20));
    const restingFieldBorder = OutlineInputBorder(
      borderRadius: corners,
      borderSide: BorderSide.none,
    );
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF35634A),
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      platform: widget.platform,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF8F7F3)
          : const Color(0xFF151C18),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(borderRadius: corners),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: restingFieldBorder,
        enabledBorder: restingFieldBorder,
        disabledBorder: restingFieldBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: corners,
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: corners,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: corners,
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: const RoundedRectangleBorder(borderRadius: corners),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textTheme:
          Typography.material2021(
            platform: widget.platform ?? defaultTargetPlatform,
          ).englishLike.apply(
            bodyColor: scheme.onSurface,
            displayColor: scheme.onSurface,
          ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Places — Abdullah AlMunaikh',
    debugShowCheckedModeBanner: false,
    theme: theme(Brightness.light),
    darkTheme: theme(Brightness.dark),
    // Select one safe region for an occluding hinge. State lives above it.
    builder: (context, child) => DisplayFeatureSubScreen(
      anchorPoint: Directionality.of(context) == TextDirection.ltr
          ? Offset.zero
          : const Offset(double.maxFinite, 0),
      child: child!,
    ),
    home: ListenableBuilder(
      listenable: store,
      builder: (_, _) => JourneyShell(store: store),
    ),
  );
}

class JourneyShell extends StatefulWidget {
  const JourneyShell({super.key, required this.store});
  final PlaceStore store;
  @override
  State<JourneyShell> createState() => _JourneyShellState();
}

class _JourneyShellState extends State<JourneyShell> {
  final navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  PlaceStore get store => widget.store;

  Widget navigator(int tab) => Navigator(
    key: navigatorKeys[tab],
    pages: [
      MaterialPage(
        key: ValueKey('home_$tab'),
        child: PlaceBrowser(store: store, tab: tab),
      ),
      if (store.details[tab] case final Place place)
        MaterialPage(
          key: ValueKey('detail_${place.id}_$tab'),
          child: PlaceDetail(store: store, place: place, tab: tab),
        ),
    ],
    onDidRemovePage: (page) {
      if (store.details[tab] case final Place place) {
        if (page.key == ValueKey('detail_${place.id}_$tab')) store.close(tab);
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    final isApple = Theme.of(context).platform == TargetPlatform.iOS;
    final title =
        store.currentDetail?.name ?? (store.tab == 0 ? 'Discover' : 'Saved');
    final back = store.currentDetail == null
        ? null
        : IconButton(
            key: const ValueKey('back_to_list'),
            tooltip: 'Back to ${store.tab == 0 ? 'Discover' : 'Saved'}',
            onPressed: () => navigatorKeys[store.tab].currentState!.pop(),
            icon: Icon(isApple ? CupertinoIcons.back : Icons.arrow_back),
          );
    final scenarioPicker = kDebugMode
        ? PopupMenuButton<Fixture>(
            key: const ValueKey('test_scenarios'),
            tooltip: 'Test scenarios',
            onSelected: store.setFixture,
            itemBuilder: (_) => Fixture.values
                .map(
                  (fixture) => PopupMenuItem(
                    key: ValueKey('fixture_${fixture.name}'),
                    value: fixture,
                    child: Text(switch (fixture) {
                      Fixture.demo => 'Reset demo',
                      Fixture.loadFailure => 'Load failure',
                      Fixture.saveFailure => 'Save failure',
                      Fixture.empty => 'Empty places',
                    }),
                  ),
                )
                .toList(),
            icon: const Icon(Icons.science_outlined),
          )
        : null;
    final body = IndexedStack(
      index: store.tab,
      children: [
        for (var i = 0; i < 2; i++)
          TickerMode(enabled: store.tab == i, child: navigator(i)),
      ],
    );
    final shell = isApple
        ? Material(
            child: GlassScaffold(
              extendBody: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: GlassAppBar(
                title: Text(title),
                leading: back,
                actions: [?scenarioPicker],
              ),
              bottomBar: GlassTabBar.bottom(
                key: const ValueKey('glass_tabs'),
                selectedIndex: store.tab,
                onTabSelected: (tab) {
                  FocusScope.of(context).unfocus();
                  store.selectTab(tab);
                },
                tabs: const [
                  GlassTab(
                    icon: Icon(CupertinoIcons.compass),
                    label: 'Discover',
                  ),
                  GlassTab(icon: Icon(CupertinoIcons.bookmark), label: 'Saved'),
                ],
              ),
              body: Material(type: MaterialType.transparency, child: body),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: back,
              actions: [?scenarioPicker],
            ),
            body: SafeArea(child: body),
            bottomNavigationBar: NavigationBar(
              selectedIndex: store.tab,
              onDestinationSelected: (tab) {
                FocusScope.of(context).unfocus();
                store.selectTab(tab);
              },
              destinations: const [
                NavigationDestination(
                  key: ValueKey('tab_discover'),
                  icon: Icon(Icons.explore_outlined),
                  label: 'Discover',
                ),
                NavigationDestination(
                  key: ValueKey('tab_saved'),
                  icon: Icon(Icons.bookmark_outline),
                  label: 'Saved',
                ),
              ],
            ),
          );
    return PopScope(
      canPop: store.currentDetail == null && store.tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (store.currentDetail != null) {
          navigatorKeys[store.tab].currentState!.pop();
        } else if (store.tab != 0) {
          store.selectTab(0);
        }
      },
      child: shell,
    );
  }
}

class PlaceBrowser extends StatelessWidget {
  const PlaceBrowser({super.key, required this.store, required this.tab});
  final PlaceStore store;
  final int tab;
  @override
  Widget build(BuildContext context) {
    if (tab == 0 && store.loadState == LoadState.loading) {
      return Center(
        child: Semantics(
          label: 'Loading places',
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (tab == 0 && store.loadState == LoadState.failed) {
      return RecoveryPanel(
        title: 'Places could not load',
        detail: 'Try again when you are ready. Your saved places are still available.',
        action: 'Try again',
        actionKey: 'retry_load',
        onPressed: store.load,
      );
    }
    if (tab == 0 && store.places.isEmpty) {
      return const RecoveryPanel(
        title: 'No places to explore yet',
        detail: 'Check back later for somewhere new to visit.',
      );
    }
    final places = tab == 0
        ? store.results
        : store.places.where((p) => store.saved.containsKey(p.id)).toList();
    return ListView(
      key: ValueKey('place_list_$tab'),
      controller: store.scroll[tab],
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          tab == 0
              ? 'Make room for a small adventure.'
              : 'Good places, kept close.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          tab == 0
              ? 'Find somewhere you would like to return to.'
              : 'Your places and notes are here whenever you need them.',
        ),
        const SizedBox(height: 24),
        if (tab == 0)
          TextField(
            key: const ValueKey('search_places'),
            controller: store.search,
            onChanged: (_) => store.refreshSearch(),
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: 'Search places',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        const SizedBox(height: 24),
        if (places.isEmpty)
          RecoveryPanel(
            title: tab == 1 ? 'Your next visit starts here' : 'No places found',
            detail: tab == 1
                ? 'Save a place from Discover, with a note for later.'
                : 'Try another search or return to all places.',
            action: tab == 1 ? 'Explore places' : 'Clear search',
            actionKey: 'empty_action',
            onPressed: () {
              if (tab == 1) {
                store.selectTab(0);
              } else {
                store.search.clear();
                store.refreshSearch();
              }
            },
          ),
        for (final place in places)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PlaceTile(
              place: place,
              note: tab == 1 ? store.saved[place.id] : null,
              saved: store.saved.containsKey(place.id),
              onTap: () {
                FocusScope.of(context).unfocus();
                store.open(place, tab);
              },
            ),
          ),
      ],
    );
  }
}

class PlaceTile extends StatelessWidget {
  const PlaceTile({
    super.key,
    required this.place,
    required this.saved,
    required this.onTap,
    this.note,
  });
  final Place place;
  final bool saved;
  final String? note;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      key: ValueKey('place_${place.id}'),
      contentPadding: const EdgeInsets.all(20),
      leading: ExcludeSemantics(child: Icon(place.icon, size: 32)),
      title: Text(place.name, style: Theme.of(context).textTheme.titleLarge),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          note != null && note!.isNotEmpty
              ? '${place.area}\n$note'
              : place.area,
        ),
      ),
      trailing: Icon(saved ? Icons.bookmark : Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class PlaceDetail extends StatefulWidget {
  const PlaceDetail({
    super.key,
    required this.store,
    required this.place,
    required this.tab,
  });
  final PlaceStore store;
  final Place place;
  final int tab;
  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  double? previousWidth;
  double readingOffset = 0;
  PlaceStore get store => widget.store;
  Place get place => widget.place;
  int get tab => widget.tab;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final controller = store.detailScroll(place, tab);
      if (previousWidth != null &&
          previousWidth != constraints.maxWidth &&
          controller.hasClients) {
        // Keep the previous reading position when all content fits after unfolding.
        if (controller.position.maxScrollExtent > 0) {
          readingOffset = controller.offset;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && controller.hasClients) {
            controller.jumpTo(
              readingOffset.clamp(0, controller.position.maxScrollExtent),
            );
          }
        });
      }
      previousWidth = constraints.maxWidth;
      final note = store.draft(place);
      final isSaving = store.saving.contains(place.id);
      final error = store.errors[place.id];
      final content = ListView(
        key: ValueKey('detail_content_${place.id}'),
        controller: store.detailScroll(place, tab),
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            height: 144,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ExcludeSemantics(
              child: Icon(
                place.icon,
                size: 64,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(place.name, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(place.area),
          const SizedBox(height: 20),
          Text(place.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 28),
          Text(
            'A note for your next visit',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('place_note'),
            controller: note,
            minLines: 2,
            maxLines: 4,
            onChanged: (_) => store.refreshSearch(),
            enabled: !isSaving,
            maxLength: 160,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Your note',
              hintText: 'What would you like to remember?',
            ),
          ),
          const SizedBox(height: 16),
          if (error != null)
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          if (store.saved[place.id] == note.text.trim() &&
              !isSaving &&
              error == null)
            Semantics(
              liveRegion: true,
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text('Saved to your places'),
              ),
            ),
          FilledButton.icon(
            key: const ValueKey('save_place'),
            onPressed: isSaving
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    store.save(place);
                  },
            icon: Icon(
              isSaving ? Icons.hourglass_top : Icons.bookmark_add_outlined,
            ),
            label: Text(
              isSaving
                  ? 'Saving…'
                  : error != null
                  ? 'Try saving again'
                  : store.saved.containsKey(place.id)
                  ? 'Update note'
                  : 'Save place',
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            key: const ValueKey('view_saved'),
            onPressed: () {
              FocusScope.of(context).unfocus();
              store.close(1);
              store.selectTab(1);
            },
            child: const Text('View saved places'),
          ),
          const SizedBox(height: 24),
        ],
      );
      final wide =
          constraints.maxWidth >= 840 &&
          MediaQuery.textScalerOf(context).scale(16) <= 24;

      return Row(
        children: [
          if (wide)
            SizedBox(
              width: 280,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your visit',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(place.area),
                    const SizedBox(height: 16),
                    const Text(
                      'Keep a useful note now, so you can pick up where you left off.',
                    ),
                  ],
                ),
              ),
            ),
          if (wide) const VerticalDivider(width: 1),
          Expanded(key: const ValueKey('detail_flow'), child: content),
        ],
      );
    },
  );
}

class RecoveryPanel extends StatelessWidget {
  const RecoveryPanel({
    super.key,
    required this.title,
    required this.detail,
    this.action,
    this.actionKey,
    this.onPressed,
  }) : assert((action == null) == (onPressed == null));
  final String title;
  final String detail;
  final String? action;
  final String? actionKey;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(detail, textAlign: TextAlign.center),
            if (action case final String label) ...[
              const SizedBox(height: 24),
              FilledButton(
                key: actionKey == null ? null : ValueKey<String>(actionKey!),
                onPressed: onPressed,
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
