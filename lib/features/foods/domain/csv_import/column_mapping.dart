/// Canonical CSV column fields that can be mapped during import.
///
/// Each value represents either a food-level field (name, brand, etc.),
/// a nutrients-level field (energy, macros, etc.), or a special value
/// like [ignore] or [micronutrient] for dynamic micronutrient keys.
enum CsvField {
  name,
  brand,
  barcode,
  basis,
  servingSize,
  servingUnit,
  energyKcal,
  energyKj,
  protein,
  carbs,
  sugars,
  addedSugars,
  fat,
  saturates,
  transFat,
  fiber,
  salt,
  sodiumMg,
  ignore,
  micronutrient;

  bool get isRequired => this == name || this == energyKcal;
}

/// Maps a single CSV column to a canonical field.
class ColumnMapping {
  const ColumnMapping({
    required this.columnIndex,
    required this.originalHeader,
    required this.proposedField,
    required this.selectedField,
    this.micronutrientKey,
    this.isRequired = false,
  });

  final int columnIndex;
  final String originalHeader;
  final CsvField proposedField;
  final CsvField selectedField;
  final String? micronutrientKey;
  final bool isRequired;

  ColumnMapping copyWith({
    int? columnIndex,
    String? originalHeader,
    CsvField? proposedField,
    CsvField? selectedField,
    String? micronutrientKey,
    bool? isRequired,
  }) {
    return ColumnMapping(
      columnIndex: columnIndex ?? this.columnIndex,
      originalHeader: originalHeader ?? this.originalHeader,
      proposedField: proposedField ?? this.proposedField,
      selectedField: selectedField ?? this.selectedField,
      micronutrientKey: micronutrientKey ?? this.micronutrientKey,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  @override
  // Fields are final; equality makes this mapping a testable value object.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnMapping &&
          columnIndex == other.columnIndex &&
          originalHeader == other.originalHeader &&
          proposedField == other.proposedField &&
          selectedField == other.selectedField &&
          micronutrientKey == other.micronutrientKey &&
          isRequired == other.isRequired;

  @override
  // Fields are final; equality makes this mapping a testable value object.
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(
    columnIndex,
    originalHeader,
    proposedField,
    selectedField,
    micronutrientKey,
    isRequired,
  );
}

List<CsvField> missingRequiredCsvFields(Iterable<ColumnMapping> mappings) {
  final selectedFields = mappings
      .map((mapping) => mapping.selectedField)
      .toSet();
  return [
    if (!selectedFields.contains(CsvField.name)) CsvField.name,
    if (!selectedFields.contains(CsvField.energyKcal) &&
        !selectedFields.contains(CsvField.energyKj))
      CsvField.energyKcal,
  ];
}
