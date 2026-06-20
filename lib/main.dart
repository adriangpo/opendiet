import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: OpenDietApp()));
}

/// Root widget for the OpenDiet application.
class OpenDietApp extends StatelessWidget {
  /// Creates the OpenDiet application root.
  const OpenDietApp({super.key});

  static const Color _seed = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenDiet',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: _seed)),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

/// Placeholder landing screen until the Diary feature lands.
///
/// See `.spec/design/ui/` for the screen designs.
class HomePage extends StatelessWidget {
  /// Creates the landing screen.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('OpenDiet')),
      body: Center(child: Text(l10n.appTagline)),
    );
  }
}
