// Abdullah AlMunaikh's mobile UX reference app. See the repository MIT license.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

import 'reference_app.dart';

Future<void> main() async {
  if (kDebugMode) {
    final collector = PrintLogCollector();
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) collector.addLog(message);
      originalDebugPrint(message, wrapWidth: wrapWidth);
    };
    MarionetteBinding.ensureInitialized(
      MarionetteConfiguration(
        logCollector: collector,
        enableSessionReports: true,
        isInteractiveElement: (element) => switch (element.widget) {
          GlassButton(:final enabled) => enabled,
          GlassIconButton(:final onPressed) => onPressed != null,
          GlassMenuItem(:final enabled) => enabled,
          GlassTabBar() => true,
          _ => false,
        },
        extractText: (element) => switch (element.widget) {
          GlassButton(:final label) => label,
          GlassIconButton(:final semanticLabel) => semanticLabel,
          GlassMenuItem(:final title) => title,
          _ => null,
        },
      ),
    );
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await LiquidGlassWidgets.initialize(enablePerformanceMonitor: false);
  final app = LiquidGlassWidgets.wrap(
    brightnessResolver: Theme.maybeBrightnessOf,
    child: const ReferenceApp(),
  );
  runApp(kDebugMode ? MarionetteDeviceConfig(child: app) : app);
}
