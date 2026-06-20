import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'package:opendiet/core/navigation/app_router.dart';
import 'package:opendiet/core/theme/app_theme.dart';
import 'package:opendiet/l10n/app_localizations.dart';

void main() {
  off.OpenFoodAPIConfiguration.userAgent = off.UserAgent(
    name: 'OpenDiet',
    url: 'https://github.com/anomalyco/opendiet',
  );
  off.OpenFoodAPIConfiguration.globalLanguages = [
    off.OpenFoodFactsLanguage.ENGLISH,
    off.OpenFoodFactsLanguage.PORTUGUESE,
  ];
  off.OpenFoodAPIConfiguration.globalCountry = off.OpenFoodFactsCountry.BRAZIL;
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
