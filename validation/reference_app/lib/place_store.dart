// Abdullah AlMunaikh's deterministic fixtures; no network or live records.
import 'package:flutter/material.dart';

enum LoadState { loading, ready, failed }

enum Fixture { demo, loadFailure, saveFailure, empty }

@immutable
class Place {
  const Place(this.id, this.name, this.area, this.description, this.icon);
  final String id;
  final String name;
  final String area;
  final String description;
  final IconData icon;
}

const demoPlaces = [
  Place(
    'garden',
    'Hidden Garden',
    'Southside · Quiet outdoors',
    'A sheltered green space for an unhurried afternoon. Bring a book, '
        'take a short walk, and leave yourself a note for your next visit.',
    Icons.park_outlined,
  ),
  Place(
    'gallery',
    'Riverside Gallery',
    'City centre · Art & culture',
    'A small gallery with changing exhibitions and room to explore at your own pace.',
    Icons.museum_outlined,
  ),
  Place(
    'coffee',
    'Corner Coffee',
    'West End · Coffee & conversation',
    'A comfortable stop for coffee. Save the table or time you would like to try next.',
    Icons.local_cafe_outlined,
  ),
  Place(
    'trail',
    'Woodland Trail',
    'Northside · A longer walk',
    'A gentle trail with changing views. Plan a visit that fits your energy and time.',
    Icons.forest_outlined,
  ),
  Place(
    'library',
    'Neighbourhood Library',
    'East End · Read & rest',
    'Find something new to read in a welcoming neighbourhood library.',
    Icons.local_library_outlined,
  ),
  Place(
    'market',
    'Sunday Market',
    'Southside · Local makers',
    'Meet local makers and browse at your own pace. Save a reminder for next Sunday.',
    Icons.storefront_outlined,
  ),
];

class PlaceStore extends ChangeNotifier {
  PlaceStore({this.latency = const Duration(milliseconds: 250)});
  final Duration latency;
  final search = TextEditingController();
  final scroll = [ScrollController(), ScrollController()];
  final details = <Place?>[null, null];
  final Map<String, TextEditingController> _drafts = {};
  final Map<String, ScrollController> _detailScrolls = {};
  ScrollController detailScroll(Place place, int tab) =>
      _detailScrolls.putIfAbsent("${place.id}_$tab", () => ScrollController());
  final saved = <String, String>{};
  final saving = <String>{};
  final errors = <String, String>{};
  LoadState loadState = LoadState.loading;
  int tab = 0;
  int _generation = 0;
  int _loadRequest = 0;
  bool _disposed = false;
  bool _failNextLoad = false;
  bool _failNextSave = false;
  bool _empty = false;

  List<Place> get places => _empty ? [] : demoPlaces;
  List<Place> get results => places
      .where(
        (place) => '${place.name} ${place.area}'.toLowerCase().contains(
          search.text.toLowerCase().trim(),
        ),
      )
      .toList();
  Place? get currentDetail => details[tab];
  TextEditingController draft(Place place) => _drafts.putIfAbsent(
    place.id,
    () => TextEditingController(text: saved[place.id] ?? ''),
  );

  Future<void> load() async {
    final generation = _generation;
    final request = ++_loadRequest;
    final fail = _failNextLoad;
    _failNextLoad = false;
    loadState = LoadState.loading;
    notifyListeners();
    await Future<void>.delayed(latency);
    if (_disposed || generation != _generation || request != _loadRequest) {
      return;
    }
    loadState = fail ? LoadState.failed : LoadState.ready;
    debugPrint('places_load:${loadState.name}');
    notifyListeners();
  }

  void refreshSearch() => notifyListeners();
  void selectTab(int value) {
    tab = value;
    notifyListeners();
  }

  void open(Place place, int fromTab) {
    details[fromTab] = place;
    notifyListeners();
  }

  void close(int fromTab) {
    details[fromTab] = null;
    notifyListeners();
  }

  Future<void> save(Place place) async {
    if (saving.contains(place.id) || _disposed) return;
    final generation = _generation;
    final note = draft(place).text.trim();
    if (note.characters.length > 160) {
      errors[place.id] = 'Keep your note to 160 characters.';
      notifyListeners();
      return;
    }
    final fail = _failNextSave;
    _failNextSave = false;
    saving.add(place.id);
    errors.remove(place.id);
    notifyListeners();
    await Future<void>.delayed(latency);
    if (_disposed || generation != _generation) return;
    saving.remove(place.id);
    if (fail) {
      errors[place.id] =
          'Your place was not saved. Your note is still here. Try again.';
      debugPrint('place_save:${place.id}:failed');
    } else {
      saved[place.id] = note;
      debugPrint('place_save:${place.id}:success');
    }
    notifyListeners();
  }

  void setFixture(Fixture fixture) {
    _generation++;
    details.fillRange(0, details.length, null);
    tab = 0;
    search.clear();
    saved.clear();
    saving.clear();
    errors.clear();
    // Outgoing routes can still have controllers attached during their exit.
    for (final controller in _drafts.values) {
      controller.clear();
    }
    for (final controller in [...scroll, ..._detailScrolls.values]) {
      if (controller.hasClients) controller.jumpTo(0);
    }
    _failNextLoad = fixture == Fixture.loadFailure;
    _failNextSave = fixture == Fixture.saveFailure;
    _empty = fixture == Fixture.empty;
    load();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    search.dispose();
    for (final controller in [...scroll, ..._detailScrolls.values]) {
      controller.dispose();
    }
    for (final controller in _drafts.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
