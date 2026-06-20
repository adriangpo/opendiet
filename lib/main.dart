import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/core/navigation/app_router.dart';
import 'package:opendiet/core/theme/app_theme.dart';
import 'package:opendiet/l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: OpenDietApp()));
}

/// Root widget for the OpenDiet application.
class OpenDietApp extends ConsumerWidget {
  /// Creates the OpenDiet application root.
  const OpenDietApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => 'OpenDiet',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
