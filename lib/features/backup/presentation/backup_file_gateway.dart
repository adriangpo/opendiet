import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/features/backup/domain/backup_document.dart';

/// File-system boundary for user-selected backup files.
abstract interface class BackupFileGateway {
  /// Saves [json] as a user-accessible JSON backup and returns the selected
  /// path or file name. Returns null when the user cancels.
  Future<String?> saveJsonBackup({
    required String fileName,
    required Map<String, dynamic> json,
  });

  /// Reads a user-selected JSON backup. Returns null when the user cancels.
  Future<Map<String, dynamic>?> pickJsonBackup();
}

/// Platform implementation using the OS file picker.
class DeviceBackupFileGateway implements BackupFileGateway {
  @override
  Future<String?> saveJsonBackup({
    required String fileName,
    required Map<String, dynamic> json,
  }) async {
    final content = const JsonEncoder.withIndent('  ').convert(json);
    return FilePicker.platform.saveFile(
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: Uint8List.fromList(utf8.encode(content)),
    );
  }

  @override
  Future<Map<String, dynamic>?> pickJsonBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final bytes = file.bytes;
    final content = bytes != null
        ? utf8.decode(bytes)
        : file.path != null
        ? await File(file.path!).readAsString()
        : null;
    if (content == null) return null;

    try {
      final decoded = jsonDecode(content);
      if (decoded is! Map) {
        throw const BackupFormatException(
          'Backup file must contain a JSON object.',
        );
      }
      return Map<String, dynamic>.from(decoded);
    } on BackupFormatException {
      rethrow;
    } on Object {
      throw const BackupFormatException('Backup file is not valid JSON.');
    }
  }
}

/// The backup file gateway used by the backup screen.
final backupFileGatewayProvider = Provider<BackupFileGateway>(
  (ref) => DeviceBackupFileGateway(),
);
