import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/features/backup/data/backup_providers.dart';
import 'package:opendiet/features/backup/domain/backup_document.dart';
import 'package:opendiet/features/backup/presentation/backup_file_gateway.dart';
import 'package:opendiet/features/diary/data/diary_providers.dart';
import 'package:opendiet/features/foods/data/food_providers.dart';
import 'package:opendiet/features/foods/data/food_search_providers.dart';
import 'package:opendiet/features/recipes/data/recipe_providers.dart';
import 'package:opendiet/features/settings/presentation/settings_controller.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// Backup export and restore screen (S-12, FR-005, FR-006).
class BackupRestoreScreen extends ConsumerStatefulWidget {
  /// Creates the backup and restore screen.
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() =>
      _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  bool _isExporting = false;
  bool _isRestoring = false;
  String? _lastExportPath;
  String? _statusMessage;
  String? _errorMessage;

  bool get _isBusy => _isExporting || _isRestoring;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.backupDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isBusy ? null : () => unawaited(_exportBackup(l10n)),
            icon: const Icon(Boxicons.bx_share),
            label: Text(
              _isExporting ? l10n.backupExportInProgress : l10n.backupExport,
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.backupLastExport(_lastExportPath ?? l10n.backupNever)),
          const Divider(height: 32),
          FilledButton.tonalIcon(
            onPressed: _isBusy ? null : () => unawaited(_restoreBackup(l10n)),
            icon: const Icon(Boxicons.bx_history),
            label: Text(
              _isRestoring ? l10n.backupRestoreInProgress : l10n.backupRestore,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Boxicons.bx_info_circle,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(l10n.backupRestoreWarning)),
            ],
          ),
          if (_statusMessage != null) ...[
            const SizedBox(height: 24),
            _MessageBanner(message: _statusMessage!),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 24),
            _MessageBanner(message: _errorMessage!, isError: true),
          ],
        ],
      ),
    );
  }

  Future<void> _exportBackup(AppLocalizations l10n) async {
    setState(() {
      _isExporting = true;
      _statusMessage = null;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(backupRepositoryProvider);
      final files = ref.read(backupFileGatewayProvider);
      final json = await repository.export();
      final savedPath = await files.saveJsonBackup(
        fileName: 'opendiet-backup.json',
        json: json,
      );
      if (!mounted) return;
      if (savedPath == null) {
        setState(() => _isExporting = false);
        return;
      }
      final displayPath = _displayPath(savedPath);
      setState(() {
        _isExporting = false;
        _lastExportPath = displayPath;
        _statusMessage = l10n.backupExportSuccess(displayPath);
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _isExporting = false;
        _errorMessage = l10n.backupExportError;
      });
    }
  }

  Future<void> _restoreBackup(AppLocalizations l10n) async {
    setState(() {
      _isRestoring = true;
      _statusMessage = null;
      _errorMessage = null;
    });

    try {
      final json = await ref.read(backupFileGatewayProvider).pickJsonBackup();
      if (!mounted || json == null) {
        setState(() => _isRestoring = false);
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.backupRestoreConfirmTitle),
          content: Text(l10n.backupRestoreConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.backupRestoreConfirmAction),
            ),
          ],
        ),
      );
      if (!mounted || confirmed != true) {
        setState(() => _isRestoring = false);
        return;
      }
      await ref.read(backupRepositoryProvider).import(json);
      _refreshRestoredData();
      if (!mounted) return;
      setState(() {
        _isRestoring = false;
        _statusMessage = l10n.backupRestoreSuccess;
      });
    } on BackupFormatException {
      if (!mounted) return;
      setState(() {
        _isRestoring = false;
        _errorMessage = l10n.backupMalformedError;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _isRestoring = false;
        _errorMessage = l10n.backupRestoreError;
      });
    }
  }

  void _refreshRestoredData() {
    ref
      ..invalidate(mealSlotsProvider)
      ..invalidate(selectedDayEntriesProvider)
      ..invalidate(foodListProvider)
      ..invalidate(recentFoodsProvider)
      ..invalidate(favoriteFoodsProvider)
      ..invalidate(foodSearchResultsProvider)
      ..invalidate(recipeListProvider)
      ..invalidate(settingsControllerProvider);
  }

  String _displayPath(String path) {
    final normalized = path.replaceAll(r'\', '/');
    return normalized.split('/').last;
  }
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isError
            ? colorScheme.errorContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              isError ? Boxicons.bx_info_circle : Boxicons.bx_check_circle,
              color: isError
                  ? colorScheme.onErrorContainer
                  : colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: isError ? colorScheme.onErrorContainer : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
