import 'package:flutter/material.dart';

/// The application's Material 3 theme, generated from the brand seed color for
/// both light and dark (see .spec/design/ui/design-system.md).
abstract final class AppTheme {
  /// Brand seed color; the full palette derives from it.
  static const Color seed = Color(0xFF2E7D32);

  /// The light theme.
  static ThemeData light() => _themeFor(Brightness.light);

  /// The dark theme.
  static ThemeData dark() => _themeFor(Brightness.dark);

  static ThemeData _themeFor(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
  );
}
