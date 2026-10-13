// Abdullah AlMunaikh's mobile UX reference app. See the repository MIT license.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_liquid_glass/native_liquid_glass.dart';
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
        // UIKit bar buttons and tabs are native controls, not Flutter tap targets.
        // Expose their shell identity without pretending a synthetic tap drives UIKit.
        extractText: (element) => switch (element.widget) {
          LiquidGlassNavigationBar(:final title) => title,
          _ => null,
        },
      ),
    );
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  const app = ReferenceApp();
  runApp(kDebugMode ? MarionetteDeviceConfig(child: app) : app);
}
