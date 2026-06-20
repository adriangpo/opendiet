import 'package:drift_flutter/drift_flutter.dart';
import 'package:opendiet/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

/// The application's single on-device database, opened on first use and closed
/// when the provider is disposed.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase(driftDatabase(name: 'opendiet'));
  ref.onDispose(database.close);
  return database;
}
