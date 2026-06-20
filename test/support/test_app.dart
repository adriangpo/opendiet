import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/navigation/app_router.dart';
import 'package:opendiet/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Pumps [child] in a localized [MaterialApp] and a [ProviderScope] with the
/// given [overrides]. Use for single-screen widget tests.
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
  // Two pumps let async work (e.g. FutureProvider) resolve without hanging
  // on animated loading indicators.
  await tester.pump();
  await tester.pump();
}

/// Common overrides for app-shell tests.  Spread into `pumpAppShell`'s
/// `overrides` to prevent real database operations during tests.
///
/// Empty by design -- each test overrides every provider it needs exactly
/// once (no double-override assertions).
List<Override> shellOverrides() => [
  // intentionally empty -- tests override providers themselves
];

/// Pumps the full application shell (bottom navigation + routed branches) with
/// the given [overrides].
///
/// Tests that use the shell should spread [shellOverrides] (or equivalent) into
/// their overrides to avoid real database timeouts.
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
  // Two pumps let async work (e.g. FutureProvider) resolve without hanging
  // on animated loading indicators.
  await tester.pump();
  await tester.pump();
}
