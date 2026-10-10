# Theme foundations

Abdullah AlMunaikh’s modified Flutter edition, based on Emil Kowalski’s original skills.

Use this reference when creating or extending the shared visual system. Inspect the existing theme first; extend it rather than creating a competing token system. The fork's craft principle is deliberate, coherent decisions, not a prescribed aesthetic.

## Intentional controls, no ink splashes

Do not use unstyled stock Material for every screen and control. Start with the product’s component system; create a custom component when the task, brand, or interaction deserves one. Deliberately themed framework buttons and fields are also valid foundations: retain activation, semantics, cancellation, focus, and disabled behavior while designing their appearance. Custom does not mean a bare `GestureDetector` with a label.

Use **no ink splash or ripple effects**. Set `ThemeData(splashFactory: NoSplash.splashFactory, splashColor: Colors.transparent)` in both light and dark themes, as in the foundation below. Check nested themes, `InkWell`/`InkResponse`, per-button `ButtonStyle.splashFactory`, and third-party controls for overrides; the root theme cannot disable an independently implemented effect. Configure or replace any ripple that remains.

Keep purposeful pressed feedback, visible keyboard focus, hover for actual pointers, selection, and disabled states. Use a restrained color/contrast change or eligible press motion from the shared component system. Do not globally make every state overlay transparent: that erases useful feedback along with the unwanted ink effect. Inspect touch-down, drag-off cancellation, keyboard activation, and disabled controls.

## Semantic tokens

Keep colors, spacing, type, radii, elevation, and motion in the nearest shared theme module. Prefer semantic colors (`primary`, `surface`, `background`, `textPrimary`, `textMuted`, `border`, `success`, `warning`) over raw palette names. Connect the tokens to `ColorScheme` and control themes as well, so dialogs, inputs, selection, and disabled states agree with feature widgets.

The following complete foundation is a starting point for an app without one. Values are example design decisions, not universal rules. Split it along the project's existing module boundaries. A single extension is used here to keep the example compact; separate color, spacing, and radius extensions work equally well.

```dart
import 'package:flutter/material.dart';

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textMuted,
    required this.border,
    this.small = 8,
    this.medium = 16,
    this.large = 24,
    this.corner = 20,
  });

  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textMuted;
  final Color border;
  final double small;
  final double medium;
  final double large;
  final double corner;

  @override
  AppTokens copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textMuted,
    Color? border,
    double? small,
    double? medium,
    double? large,
    double? corner,
  }) => AppTokens(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    textPrimary: textPrimary ?? this.textPrimary,
    textMuted: textMuted ?? this.textMuted,
    border: border ?? this.border,
    small: small ?? this.small,
    medium: medium ?? this.medium,
    large: large ?? this.large,
    corner: corner ?? this.corner,
  );

  @override
  AppTokens lerp(covariant AppTokens? other, double t) {
    if (other == null) return this;
    double mix(double a, double b) => a + (b - a) * t;
    return AppTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      small: mix(small, other.small),
      medium: mix(medium, other.medium),
      large: mix(large, other.large),
      corner: mix(corner, other.corner),
    );
  }
}

extension AppThemeContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
  ColorScheme get colours => Theme.of(this).colorScheme;
  AppTokens get spacing => tokens;
  AppTokens get radius => tokens;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

ThemeData buildAppTheme(Brightness brightness) {
  const corners = BorderRadius.all(Radius.circular(20));
  const restingFieldBorder = OutlineInputBorder(
    borderRadius: corners,
    borderSide: BorderSide.none,
  );
  final ColorScheme colours = ColorScheme.fromSeed(
    seedColor: const Color(0xff285c52),
    brightness: brightness,
  );
  final ThemeData base = ThemeData(
    colorScheme: colours,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
  );
  return base.copyWith(
    scaffoldBackgroundColor: colours.surface,
    textTheme: base.textTheme.copyWith(
      displayLarge: base.textTheme.displayLarge?.copyWith(
        height: 1.05,
        letterSpacing: -1,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.5),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppTokens(
        background: colours.surface,
        surface: colours.surfaceContainerLow,
        textPrimary: colours.onSurface,
        textMuted: colours.onSurfaceVariant,
        border: colours.outlineVariant,
      ),
    ],
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colours.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: restingFieldBorder,
      enabledBorder: restingFieldBorder,
      disabledBorder: restingFieldBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: corners,
        borderSide: BorderSide(color: colours.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: corners,
        borderSide: BorderSide(color: colours.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: corners,
        borderSide: BorderSide(color: colours.error, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: const RoundedSuperellipseBorder(
          borderRadius: corners,
        ),
      ),
    ),
  );
}
```

Supply both themes through `MaterialApp(theme: ..., darkTheme: ..., themeMode: ThemeMode.system)`. Extend with explicit error, success, warning, and high-contrast tokens where the product requires them. Do not assume generating a seed scheme proves every custom text/surface combination has sufficient contrast.

## Text fields

Design search, note, and form fields as part of the same component system as cards and buttons. Share corner and spacing tokens; avoid an accidental default radius or a harsh dark frame around every field. The example uses a quiet filled surface with no resting outline and a thin theme-colored focus/error outline. Other products may need a deliberate border for contrast; choose it against the actual backdrop rather than accepting a default.

Keep a clear label, readable placeholder and entered text, caret and selection, generous content padding, and helper/error messages that can wrap. Focus must remain visible, and errors need explanatory text rather than color alone. Check empty, populated, focused, disabled, and invalid states in light/dark mode, large text, and with the keyboard open. A pale fill alone does not establish sufficient separation: inspect it in context, including high contrast.

## Typography

Treat size, weight, tracking, and leading as a set. Tighten large headings; keep body tracking near zero and body leading comfortable. Adapt for the actual script and language. Flutter `TextStyle.letterSpacing` is in logical pixels; `height` is a font-size multiplier. Use `FontVariation('opsz', value)` only when the actual bundled variable font supports that axis; Configure supported optical axes deliberately.

Preserve the product font. Without a reason for custom type, use platform-appropriate defaults. When the brief needs a Google Fonts face, use `google_fonts` to build the centralized `TextTheme`, not individual feature styles; bundle production font assets if runtime font fetching would delay first paint or fail offline. Preserve licensing. Expose typography through `context.textTheme` and add semantic styles centrally when needed.

Honor `MediaQuery.textScalerOf(context)` through ordinary `Text` behavior; do not globally clamp or disable scaling to rescue a brittle layout. Avoid fixed text-container heights. At large accessibility sizes, wrap labels, expand controls, and change composition rather than shrinking text. Use directional padding/alignment and localized content.

## Shape and depth

For new soft rounded surfaces, use SDK `RoundedSuperellipseBorder`, `ClipRSuperellipse`, and `ShapeDecoration` where supported. The border and clip must agree; a decoration alone does not clip its child. Reuse the project's shape when it carries stronger identity or the pinned SDK lacks these APIs. `BorderRadius.circular` describes the superellipse's corner parameter here; it does not make `RoundedSuperellipseBorder` a regular rounded rectangle. Do not install an extra shape package when the SDK already supports the treatment.

Shadows follow Emil’s general principles of cohesion, restraint, and attention to unseen details. The rules below are Abdullah AlMunaikh’s Flutter adaptation; Emil’s guide does not prescribe one shadow recipe or universal numerical values.

- Give a shadow a job: distinguish a floating control, sheet, menu, or elevated layer from its backdrop. Do not put a shadow on every card, field, or button.
- Use spacing, tonal separation, or a purposeful border when those communicate the relationship clearly. An in-flow content group may need no elevation.
- Define a small set of shared depth tokens with consistent light direction and surface roles. Tune blur, offset, spread, and alpha together; avoid unrelated per-feature shadow values and heavy decorative halos.
- Match apparent depth to the surface’s role, size, and surrounding material. Larger floating surfaces may need more separation, but a busy image, plain canvas, and dark background require different treatments. Never copy one black shadow onto all three.
- Inspect edges and contrast with real content in light and dark mode. A defined border or tonal surface can work better where a shadow disappears. Keep pressed, focused, and disabled states legible.
- Profile large or animated shadows and blur in the actual app. Keep expensive effects bounded; a subtle appearance does not prove low raster cost.

The example theme’s radii, padding, and colors are starting points for its visual language, not a required aesthetic or values attributed to Emil.

## Sources

- [NoSplash](https://api.flutter.dev/flutter/material/NoSplash-class.html)
- [ButtonStyle.splashFactory](https://api.flutter.dev/flutter/material/ButtonStyle/splashFactory.html)
- [ThemeExtension](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)
- [RoundedSuperellipseBorder](https://api.flutter.dev/flutter/painting/RoundedSuperellipseBorder-class.html)
- [ClipRSuperellipse](https://api.flutter.dev/flutter/widgets/ClipRSuperellipse-class.html)
- [TextScaler migration](https://docs.flutter.dev/release/breaking-changes/deprecate-textscalefactor)
