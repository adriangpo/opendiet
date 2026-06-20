import 'package:opendiet/core/database/database_providers.dart';
import 'package:opendiet/features/settings/data/drift_settings_repository.dart';
import 'package:opendiet/features/settings/domain/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// The settings repository, backed by the on-device database.
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    DriftSettingsRepository(ref.watch(appDatabaseProvider));
