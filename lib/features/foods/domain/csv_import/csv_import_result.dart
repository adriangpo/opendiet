import 'package:opendiet/core/nutrition/nutrients.dart';
import 'package:opendiet/core/units/measurement_unit.dart';
import 'package:opendiet/features/foods/domain/food.dart';

/// A row that either validated successfully or was rejected.
sealed class ValidationResult {
  const ValidationResult();
}

/// A successfully parsed row from the CSV.
class ValidRow extends ValidationResult {
  const ValidRow({
    required this.name,
    this.brand,
    this.barcode,
    this.basis = NutrientBasis.per100g,
    this.servingSizeMetric,
    this.servingUnit,
    this.nutrients = Nutrients.empty,
  });

  final String name;
  final String? brand;
  final String? barcode;
  final NutrientBasis basis;
  final double? servingSizeMetric;
  final ServingUnit? servingUnit;
  final Nutrients nutrients;

  Food toFood(String id, DateTime now) => Food(
    id: id,
    name: name,
    source: FoodSource.imported,
    basis: basis,
    nutrients: nutrients,
    createdAt: now,
    updatedAt: now,
    brand: brand,
    barcode: barcode,
    servingSizeMetric: servingSizeMetric,
    servingUnit: servingUnit,
  );
}

/// A rejected row with the reason.
class RejectedRow extends ValidationResult {
  const RejectedRow({
    required this.rowNumber,
    required this.reason,
  });

  /// 1-indexed row number (header is row 1, first data row is 2).
  final int rowNumber;

  /// Human-readable rejection reason.
  final String reason;
}

/// Summary of a CSV import operation.
class CsvImportResult {
  const CsvImportResult({
    required this.importedCount,
    required this.rejectedCount,
    required this.rejectedRowReasons,
  });

  final int importedCount;
  final int rejectedCount;
  final List<RejectedRow> rejectedRowReasons;
}
