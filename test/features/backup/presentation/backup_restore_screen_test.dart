import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/features/backup/data/backup_providers.dart';
import 'package:opendiet/features/backup/domain/backup_document.dart';
import 'package:opendiet/features/backup/domain/backup_repository.dart';
import 'package:opendiet/features/backup/presentation/backup_file_gateway.dart';
import 'package:opendiet/features/backup/presentation/backup_restore_screen.dart';

import '../../../support/test_app.dart';

void main() {
  testWidgets('exports a backup and shows the saved file state', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(savedPath: 'opendiet-backup.json');
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    expect(find.text('Last export: never'), findsOneWidget);

    await tester.tap(find.text('Export backup'));
    await tester.pump();
    await tester.pump();

    expect(repository.exportCount, 1);
    expect(files.savedJson, repository.exportJson);
    expect(
      find.text('Backup exported to opendiet-backup.json.'),
      findsOneWidget,
    );
    expect(find.text('Last export: opendiet-backup.json'), findsOneWidget);
  });

  testWidgets('keeps export available after a save failure', (tester) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(saveError: Exception('Disk full'));
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    await tester.tap(find.text('Export backup'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('Could not export backup. Try another location.'),
      findsOneWidget,
    );
    expect(find.text('Export backup'), findsOneWidget);
  });

  testWidgets('asks for confirmation before restoring from a file', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(importJson: const {'version': 1});
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    await tester.tap(find.text('Restore from file'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Replace current data?'), findsOneWidget);
    expect(repository.importCount, 0);

    await tester.tap(find.text('Restore'));
    await tester.pump();
    await tester.pump();

    expect(repository.importCount, 1);
    expect(repository.importedJson, const {'version': 1});
    expect(find.text('Backup restored.'), findsOneWidget);
  });

  testWidgets('canceling the restore confirmation leaves data untouched', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(importJson: const {'version': 1});
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    await tester.tap(find.text('Restore from file'));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pump();

    expect(repository.importCount, 0);
    expect(find.text('Restore from file'), findsOneWidget);
  });

  testWidgets('rejects malformed backup files without restoring', (
    tester,
  ) async {
    final repository = FakeBackupRepository();
    final files = FakeBackupFileGateway(
      importError: const BackupFormatException('Invalid JSON.'),
    );
    await pumpApp(
      tester,
      const BackupRestoreScreen(),
      overrides: [
        backupRepositoryProvider.overrideWithValue(repository),
        backupFileGatewayProvider.overrideWithValue(files),
      ],
    );

    await tester.tap(find.text('Restore from file'));
    await tester.pump();
    await tester.pump();

    expect(repository.importCount, 0);
    expect(
      find.text(
        'Backup file is malformed or incompatible. No data was changed.',
      ),
      findsOneWidget,
    );
  });
}

class FakeBackupRepository implements BackupRepository {
  final Map<String, dynamic> exportJson = <String, dynamic>{
    'version': BackupDocument.currentVersion,
    'foods': <Object?>[],
    'recipes': <Object?>[],
    'mealSlots': <Object?>[],
    'diaryEntries': <Object?>[],
    'settings': <String, Object?>{},
  };

  int exportCount = 0;
  int importCount = 0;
  Map<String, dynamic>? importedJson;

  @override
  Future<Map<String, dynamic>> export() async {
    exportCount++;
    return exportJson;
  }

  @override
  Future<void> import(Map<String, dynamic> json) async {
    importCount++;
    importedJson = json;
  }
}

class FakeBackupFileGateway implements BackupFileGateway {
  FakeBackupFileGateway({
    this.savedPath,
    this.importJson,
    this.saveError,
    this.importError,
  });

  final String? savedPath;
  final Map<String, dynamic>? importJson;
  final Exception? saveError;
  final Exception? importError;
  Map<String, dynamic>? savedJson;

  @override
  Future<Map<String, dynamic>?> pickJsonBackup() async {
    final error = importError;
    if (error != null) throw error;
    return importJson;
  }

  @override
  Future<String?> saveJsonBackup({
    required String fileName,
    required Map<String, dynamic> json,
  }) async {
    final error = saveError;
    if (error != null) throw error;
    savedJson = json;
    return savedPath;
  }
}
