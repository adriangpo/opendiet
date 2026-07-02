import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_import_providers.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_import_service.dart';
import 'package:opendiet/features/foods/data/csv_import/csv_row_validator.dart';
import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';
import 'package:opendiet/features/foods/domain/csv_import/csv_import_result.dart';
import 'package:opendiet/features/foods/domain/csv_import/taco_preset.dart';
import 'package:opendiet/l10n/app_localizations.dart';

/// 4-step CSV import wizard (S-11, FR-013, FR-014, FR-030).
class CsvImportScreen extends ConsumerStatefulWidget {
  const CsvImportScreen({super.key});

  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  var _currentStep = 0;
  String? _fileContent;
  String? _fileName;
  CsvParseResult? _parseResult;
  List<ColumnMapping>? _adjustedMappings;
  CsvImportResult? _importResult;
  bool _importing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final service = ref.watch(csvImportServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_stepTitle(l10n))),
      body: _buildStep(l10n, service),
    );
  }

  String _stepTitle(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return l10n.csvImportStepPickFile;
      case 1:
        return l10n.csvImportStepMapColumns;
      case 2:
        return l10n.csvImportStepPreview;
      case 3:
        return l10n.csvImportStepResult;
      default:
        return '';
    }
  }

  Widget _buildStep(AppLocalizations l10n, CsvImportService service) {
    switch (_currentStep) {
      case 0:
        return _buildPickFileStep(l10n);
      case 1:
        return _buildMapColumnsStep(l10n);
      case 2:
        return _buildPreviewStep(l10n);
      case 3:
        return _buildResultStep(l10n);
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // Step 1: Pick file
  // ---------------------------------------------------------------------------
  Widget _buildPickFileStep(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Column(
              children: [
                Icon(
                  Boxicons.bx_upload,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Boxicons.bx_folder_open),
                  label: Text(l10n.csvImportChooseFile),
                ),
              ],
            ),
          ),
          if (_fileName != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Boxicons.bx_file),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _fileName!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    if (_parseResult != null)
                      Text(
                        '(${_parseResult!.rowCount})',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          FilledButton(
            onPressed: _fileContent != null ? _nextStep : null,
            child: Text(l10n.actionNext),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    final content = await File(file.path!).readAsString();
    final service = ref.read(csvImportServiceProvider);
    final parseResult = service.parseCsv(content);

    setState(() {
      _fileContent = content;
      _fileName = file.name;
      _parseResult = parseResult;
      _adjustedMappings = List.of(parseResult.mappings);
    });
  }

  // ---------------------------------------------------------------------------
  // Step 2: Map columns
  // ---------------------------------------------------------------------------
  Widget _buildMapColumnsStep(AppLocalizations l10n) {
    final mappings = _adjustedMappings;
    if (mappings == null || _parseResult == null) {
      return const SizedBox.shrink();
    }

    final requiredUnmapped = missingRequiredCsvFields(mappings);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mappings.length,
            itemBuilder: (context, index) {
              final mapping = mappings[index];
              return Card(
                child: ListTile(
                  title: Text(mapping.originalHeader),
                  subtitle: Text(
                    _fieldLabel(
                      l10n,
                      mapping.selectedField,
                      mapping.micronutrientKey,
                    ),
                    style: TextStyle(
                      color: mapping.selectedField == CsvField.ignore
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                  ),
                  trailing: PopupMenuButton<CsvField>(
                    onSelected: (field) {
                      setState(() {
                        _adjustedMappings![index] = mapping.copyWith(
                          selectedField: field,
                          micronutrientKey: field == CsvField.micronutrient
                              ? mapping.micronutrientKey
                              : null,
                        );
                      });
                    },
                    itemBuilder: (context) => [
                      for (final field in CsvField.values)
                        PopupMenuItem(
                          value: field,
                          child: Text(_fieldLabel(l10n, field)),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (requiredUnmapped.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.csvImportRequiredUnmapped(
                requiredUnmapped
                    .map((field) => _fieldLabel(l10n, field))
                    .join(', '),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _applyTacoPreset,
                  child: Text(l10n.csvImportTacoPreset),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  child: Text(l10n.actionBack),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: requiredUnmapped.isEmpty ? _nextStep : null,
                  child: Text(l10n.actionNext),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _applyTacoPreset() {
    if (_parseResult == null) return;
    setState(() {
      _adjustedMappings = TacoPreset.proposeMapping(_parseResult!.headers);
    });
  }

  // ---------------------------------------------------------------------------
  // Step 3: Preview
  // ---------------------------------------------------------------------------
  Widget _buildPreviewStep(AppLocalizations l10n) {
    final dataRows = _parseResult?.dataRows ?? [];
    final mappings = _adjustedMappings ?? [];
    final previewRows = dataRows.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.csvImportPreviewDescription(
              previewRows.length,
              dataRows.length,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: previewRows.length,
            itemBuilder: (context, index) {
              final row = previewRows[index];
              final result = CsvRowValidator.validate(row, mappings);
              final energyKcal = result is ValidRow
                  ? result.nutrients.energyKcal
                  : null;
              final energyText = energyKcal == null
                  ? null
                  : '${energyKcal.toStringAsFixed(1)} ${l10n.unitKilocalorie}';
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.csvImportRowLabel} ${index + 2}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      if (result is ValidRow)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.name,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            if (energyText != null)
                              Text(
                                energyText,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          ],
                        )
                      else
                        Text(
                          (result as RejectedRow).reason,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  child: Text(l10n.actionBack),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _importing ? null : _runImport,
                  child: _importing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.csvImportActionImport),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 4: Result
  // ---------------------------------------------------------------------------
  Widget _buildResultStep(AppLocalizations l10n) {
    final result = _importResult;
    if (result == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Icon(
            result.rejectedCount == 0
                ? Boxicons.bxs_check_circle
                : Boxicons.bx_error_circle,
            size: 64,
            color: result.rejectedCount == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.csvImportResultSummary(
              result.importedCount,
              result.rejectedCount,
            ),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (result.rejectedRowReasons.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: result.rejectedRowReasons.length,
                itemBuilder: (context, index) {
                  final rejected = result.rejectedRowReasons[index];
                  return ListTile(
                    leading: Text(
                      '${l10n.csvImportRowLabel} ${rejected.rowNumber}',
                    ),
                    title: Text(rejected.reason),
                  );
                },
              ),
            ),
          const Spacer(),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionDone),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    setState(() => _currentStep++);
  }

  void _prevStep() {
    setState(() => _currentStep--);
  }

  Future<void> _runImport() async {
    if (_fileContent == null || _adjustedMappings == null) return;

    setState(() => _importing = true);

    final service = ref.read(csvImportServiceProvider);
    final result = await service.importFromCsv(
      _fileContent!,
      overrideMappings: _adjustedMappings,
    );

    setState(() {
      _importResult = result;
      _importing = false;
      _currentStep = 3;
    });
  }

  String _fieldLabel(
    AppLocalizations l10n,
    CsvField field, [
    String? micronutrientKey,
  ]) {
    switch (field) {
      case CsvField.name:
        return l10n.foodFieldName;
      case CsvField.brand:
        return l10n.foodFieldBrand;
      case CsvField.barcode:
        return l10n.foodFieldBarcode;
      case CsvField.basis:
        return l10n.foodBasisLabel;
      case CsvField.servingSize:
        return l10n.foodFieldServingSize;
      case CsvField.servingUnit:
        return l10n.csvImportFieldServingUnit;
      case CsvField.energyKcal:
        return l10n.csvImportFieldEnergy;
      case CsvField.energyKj:
        return '${l10n.csvImportFieldEnergy} (kJ)';
      case CsvField.protein:
        return l10n.nutrientProtein;
      case CsvField.carbs:
        return l10n.nutrientCarbohydrates;
      case CsvField.sugars:
        return l10n.nutrientTotalSugars;
      case CsvField.addedSugars:
        return l10n.nutrientAddedSugars;
      case CsvField.fat:
        return l10n.nutrientTotalFat;
      case CsvField.saturates:
        return l10n.nutrientSaturatedFat;
      case CsvField.transFat:
        return l10n.nutrientTransFat;
      case CsvField.fiber:
        return l10n.nutrientDietaryFiber;
      case CsvField.salt:
        return l10n.csvImportFieldSalt;
      case CsvField.sodiumMg:
        return l10n.nutrientSodium;
      case CsvField.micronutrient:
        return micronutrientKey ?? l10n.csvImportFieldMicronutrient;
      case CsvField.ignore:
        return l10n.csvImportFieldIgnore;
    }
  }
}
