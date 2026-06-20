import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/navigation/app_router.dart';
import 'package:opendiet/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Pumps [child] in a localized [MaterialApp] and a [ProviderScope] with the
/// given [overrides], then settles. Use for single-screen widget tests.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Pumps the full application shell (bottom navigation + routed branches) with
/// the given [overrides], then settles.
Future<void> pumpAppShell(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: buildAppRouter(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
