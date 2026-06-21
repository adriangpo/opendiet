import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/core/units/unit_conversions.dart';
import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';
import 'package:opendiet/features/foods/domain/csv_import/csv_import_result.dart';
import 'package:opendiet/features/foods/domain/food.dart';

/// Validates a single CSV row against its column mapping (FR-014).
///
/// Rejects when: name is blank, energy is missing/non-numeric, any mapped
/// numeric field is non-numeric or negative, or `basis = per_serving` without
/// a serving_size.
abstract final class CsvRowValidator {
  /// Validates [values] (one per column) using [mappings].
  ///
  /// Returns a [ValidRow] on success or a [RejectedRow] with the reason.
  static ValidationResult validate(
    List<String> values,
    List<ColumnMapping> mappings,
  ) {
    String? name;
    String? brand;
    String? barcode;
    var basis = NutrientBasis.per100g;
    double? servingSizeMetric;
    ServingUnit? servingUnit;
    double? energyKcal;
    double? energyKj;
    double? carbohydrates;
    double? totalSugars;
    double? addedSugars;
    double? protein;
    double? totalFat;
    double? saturatedFat;
    double? transFat;
    double? dietaryFiber;
    double? sodiumMilligrams;
    final micronutrients = <String, double>{};

    for (final mapping in mappings) {
      if (mapping.selectedField == CsvField.ignore) continue;
      if (mapping.columnIndex >= values.length) continue;

      final raw = values[mapping.columnIndex].trim();
      final field = mapping.selectedField;

      try {
        switch (field) {
          case CsvField.name:
            if (raw.isEmpty) {
              return const RejectedRow(rowNumber: 0, reason: 'name is blank');
            }
            name = raw;

          case CsvField.brand:
            brand = raw.isEmpty ? null : raw;

          case CsvField.barcode:
            barcode = raw.isEmpty ? null : raw;

          case CsvField.basis:
            final normalized = raw.toLowerCase();
            if (normalized.contains('per_serving') ||
                normalized.contains('serving') ||
                normalized.contains('porcao') ||
                normalized.contains('porção')) {
              basis = NutrientBasis.perServing;
            } else if (normalized.contains('per_100ml') ||
                normalized.contains('100ml') ||
                normalized.contains('100 ml')) {
              basis = NutrientBasis.per100ml;
            }
          // Default is per100g.

          case CsvField.servingSize:
            if (raw.isNotEmpty) {
              final parsed = _parseDouble(raw);
              if (parsed == null) {
                return RejectedRow(
                  rowNumber: 0,
                  reason: 'serving_size "$raw" is not a valid number',
                );
              }
              if (parsed < 0) {
                return const RejectedRow(
                  rowNumber: 0,
                  reason: 'serving_size cannot be negative',
                );
              }
              servingSizeMetric = parsed;
            }

          case CsvField.servingUnit:
            if (raw.isNotEmpty) {
              servingUnit = _parseServingUnit(raw);
            }

          case CsvField.energyKcal:
            if (raw.isEmpty) {
              return const RejectedRow(
                rowNumber: 0,
                reason: 'energy (kcal) is missing',
              );
            }
            final parsed = _parseDouble(raw);
            if (parsed == null) {
              return RejectedRow(
                rowNumber: 0,
                reason: 'energy "$raw" is not a valid number',
              );
            }
            if (parsed < 0) {
              return const RejectedRow(
                rowNumber: 0,
                reason: 'energy cannot be negative',
              );
            }
            energyKcal = parsed;

          case CsvField.energyKj:
            if (raw.isNotEmpty) {
              final parsed = _parseDouble(raw);
              if (parsed == null) {
                return RejectedRow(
                  rowNumber: 0,
                  reason: 'energy (kJ) "$raw" is not a valid number',
                );
              }
              if (parsed < 0) {
                return const RejectedRow(
                  rowNumber: 0,
                  reason: 'energy (kJ) cannot be negative',
                );
              }
              energyKj = parsed;
            }

          case CsvField.protein:
            protein = _parseOptionalNumeric(raw, 'protein');

          case CsvField.carbs:
            carbohydrates = _parseOptionalNumeric(raw, 'carbohydrates');

          case CsvField.sugars:
            totalSugars = _parseOptionalNumeric(raw, 'sugars');

          case CsvField.addedSugars:
            addedSugars = _parseOptionalNumeric(raw, 'added_sugars');

          case CsvField.fat:
            totalFat = _parseOptionalNumeric(raw, 'fat');

          case CsvField.saturates:
            saturatedFat = _parseOptionalNumeric(raw, 'saturates');

          case CsvField.transFat:
            transFat = _parseOptionalNumeric(raw, 'trans_fat');

          case CsvField.fiber:
            dietaryFiber = _parseOptionalNumeric(raw, 'fiber');

          case CsvField.salt:
            // Salt column: convert to sodium (salt / 2.5 = sodium).
            if (raw.isNotEmpty) {
              final parsed = _parseDouble(raw);
              if (parsed == null) {
                return RejectedRow(
                  rowNumber: 0,
                  reason: 'salt "$raw" is not a valid number',
                );
              }
              if (parsed < 0) {
                return const RejectedRow(
                  rowNumber: 0,
                  reason: 'salt cannot be negative',
                );
              }
              sodiumMilligrams = SodiumSaltConverter.saltToSodium(parsed);
            }

          case CsvField.sodiumMg:
            if (raw.isNotEmpty) {
              final parsed = _parseDouble(raw);
              if (parsed == null) {
                return RejectedRow(
                  rowNumber: 0,
                  reason: 'sodium "$raw" is not a valid number',
                );
              }
              if (parsed < 0) {
                return const RejectedRow(
                  rowNumber: 0,
                  reason: 'sodium cannot be negative',
                );
              }
              sodiumMilligrams = parsed;
            }

          case CsvField.micronutrient:
            if (raw.isNotEmpty && mapping.micronutrientKey != null) {
              final parsed = _parseDouble(raw);
              if (parsed == null) {
                return RejectedRow(
                  rowNumber: 0,
                  reason:
                      '${mapping.micronutrientKey} "$raw" is not a '
                      'valid number',
                );
              }
              if (parsed < 0) {
                return RejectedRow(
                  rowNumber: 0,
                  reason: '${mapping.micronutrientKey} cannot be negative',
                );
              }
              micronutrients[mapping.micronutrientKey!] = parsed;
            }

          case CsvField.ignore:
            break;
        }
      } on _ValidationException catch (e) {
        return RejectedRow(rowNumber: 0, reason: e.message);
      }
    }

    if (name == null) {
      return const RejectedRow(rowNumber: 0, reason: 'name is missing');
    }

    // Energy must be present: either kcal or kJ, or both converted.
    if (energyKcal == null && energyKj == null) {
      return const RejectedRow(
        rowNumber: 0,
        reason: 'energy is missing (no kcal or kJ column mapped)',
      );
    }

    // If both kcal and kJ are provided, use kcal; add kJ conversion.
    if (energyKcal == null && energyKj != null) {
      energyKcal = EnergyConverter.kilojoulesToKilocalories(energyKj);
    }

    // Validate per_serving constraint.
    if (basis == NutrientBasis.perServing && servingSizeMetric == null) {
      return const RejectedRow(
        rowNumber: 0,
        reason: 'basis is per_serving but serving_size is missing',
      );
    }

    return ValidRow(
      name: name,
      brand: brand,
      barcode: barcode,
      basis: basis,
      servingSizeMetric: servingSizeMetric,
      servingUnit: servingUnit,
      nutrients: Nutrients(
        energyKcal: energyKcal,
        carbohydrates: carbohydrates,
        totalSugars: totalSugars,
        addedSugars: addedSugars,
        protein: protein,
        totalFat: totalFat,
        saturatedFat: saturatedFat,
        transFat: transFat,
        dietaryFiber: dietaryFiber,
        sodiumMilligrams: sodiumMilligrams,
        micronutrients: micronutrients,
      ),
    );
  }

  static double? _parseOptionalNumeric(String raw, String fieldName) {
    if (raw.isEmpty) return null;
    final parsed = _parseDouble(raw);
    if (parsed == null) {
      throw _ValidationException('$fieldName "$raw" is not a valid number');
    }
    if (parsed < 0) {
      throw _ValidationException('$fieldName cannot be negative');
    }
    return parsed;
  }

  static double? _parseDouble(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    String converted;
    if (trimmed.contains('.') && trimmed.contains(',')) {
      // European thousand-sep dot + decimal comma: "1.200,5" -> "1200.5"
      if (trimmed.lastIndexOf(',') > trimmed.lastIndexOf('.')) {
        converted = trimmed.replaceAll('.', '').replaceFirst(',', '.');
      } else {
        // English thousand-sep comma + decimal dot: "1,200.5" -> "1200.5"
        converted = trimmed.replaceAll(',', '');
      }
    } else if (trimmed.contains(',')) {
      final afterComma = trimmed.substring(trimmed.lastIndexOf(',') + 1);
      if (afterComma.length == 3 && RegExp(r'^\d{3}$').hasMatch(afterComma)) {
        // Likely a thousand separator: "1,200" -> "1200"
        converted = trimmed.replaceAll(',', '');
      } else {
        // Likely a decimal comma: "1200,5" -> "1200.5"
        converted = trimmed.replaceFirst(',', '.');
      }
    } else {
      converted = trimmed;
    }

    return double.tryParse(converted);
  }

  static ServingUnit? _parseServingUnit(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized == 'g' || normalized == 'gram' || normalized == 'grams') {
      return ServingUnit.gram;
    }
    if (normalized == 'ml' ||
        normalized == 'milliliter' ||
        normalized == 'milliliters') {
      return ServingUnit.milliliter;
    }
    if (normalized == 'piece' ||
        normalized == 'pieces' ||
        normalized == 'unidade' ||
        normalized == 'unidades' ||
        normalized == 'und') {
      return ServingUnit.piece;
    }
    return null;
  }
}

class _ValidationException implements Exception {
  const _ValidationException(this.message);
  final String message;
}
