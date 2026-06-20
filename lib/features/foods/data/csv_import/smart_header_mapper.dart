import 'package:opendiet/features/foods/domain/csv_import/column_mapping.dart';

/// Maps CSV column headers to canonical [CsvField] values using a synonym
/// table and unit detection (FR-013). See `agent_docs/csv_import.md`.
class SmartHeaderMapper {
  const SmartHeaderMapper();

  /// Normalizes [header] for synonym matching: lowercase, trim, remove
  /// diacritics, replace non-alphanumeric with spaces, collapse whitespace.
  ///
  /// Keeps unit indicators (mg, g, kj, kcal) in the result so [_detectUnit]
  /// can work on the normalized string.
  String normalizeHeader(String header) {
    var result = header.trim().toLowerCase();
    result = _removeDiacritics(result);
    result = result.replaceAll(RegExp(r'[^a-z0-9]'), ' ');
    result = result.replaceAll(RegExp(r'\s+'), ' ');
    return result.trim();
  }

  /// Proposes a [ColumnMapping] for each header in [headers].
  ///
  /// Each mapping starts with `proposedField == selectedField`; the UI lets
  /// the user change `selectedField` before import.
  List<ColumnMapping> proposeMapping(List<String> headers) {
    return [
      for (var i = 0; i < headers.length; i++) _mapSingle(i, headers[i]),
    ];
  }

  ColumnMapping _mapSingle(int index, String header) {
    final normalized = normalizeHeader(header);
    final field = _lookup(normalized);

    String? micronutrientKey;
    if (field == CsvField.micronutrient) {
      micronutrientKey = _buildMicronutrientKey(header);
    }

    return ColumnMapping(
      columnIndex: index,
      originalHeader: header,
      proposedField: field,
      selectedField: field,
      micronutrientKey: micronutrientKey,
      isRequired: field.isRequired,
    );
  }

  CsvField _lookup(String normalized) {
    // 1. Direct synonym match.
    if (_synonymTable.containsKey(normalized)) {
      return _synonymTable[normalized]!;
    }

    // 2. Try to detect a unit suffix.
    final detected = _detectUnit(normalized);
    if (detected != null) {
      final (base, unit) = detected;
      final key = '${base}_$unit';

      // 2a. Known field with explicit unit (e.g. "sodium_mg", "energy_kj").
      if (_synonymTable.containsKey(key)) {
        return _synonymTable[key]!;
      }

      // 2b. Base is a known field -- check what the unit means.
      if (_synonymTable.containsKey(base)) {
        final baseField = _synonymTable[base]!;
        // Energy with kJ unit maps to energyKj.
        if (baseField == CsvField.energyKcal && unit == 'kj') {
          return CsvField.energyKj;
        }
        return baseField;
      }

      // 2c. Unknown base with a nutritional unit -> micronutrient.
      if (_nutritionalUnits.contains(unit)) {
        return CsvField.micronutrient;
      }

      // 2d. Unknown unit -> ignore.
      return CsvField.ignore;
    }

    // 3. Unrecognized.
    return CsvField.ignore;
  }

  /// Returns (baseName, unit) when [normalized] ends with a known unit,
  /// or null.
  (String, String)? _detectUnit(String normalized) {
    final match = RegExp(
      r'^(.+?)\s+(kcal|kj|g|mg|mcg|ml)$',
    ).firstMatch(normalized);
    if (match != null) {
      return (match.group(1)!, match.group(2)!);
    }
    return null;
  }

  String _buildMicronutrientKey(String header) {
    return normalizeHeader(header).replaceAll(RegExp(r'\s+'), '_');
  }

  static String _removeDiacritics(String text) {
    for (final entry in _accentMap.entries) {
      text = text.replaceAll(entry.key, entry.value);
    }
    return text;
  }

  static const Map<String, String> _accentMap = {
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'å': 'a',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    'ñ': 'n',
    'ç': 'c',
  };

  static const _nutritionalUnits = {'g', 'mg', 'mcg', 'ml', 'kcal', 'kj'};

  // Coverage: linter line length for this large synonym table.
  // ignore_for_file: lines_longer_than_80_chars

  // The synonym table keys are post-normalization. This is the ONLY place to
  // add new header aliases (see agent_docs/csv_import.md).
  static const Map<String, CsvField> _synonymTable = {
    // name
    'name': CsvField.name,
    'food': CsvField.name,
    'product': CsvField.name,
    'description': CsvField.name,
    'item': CsvField.name,
    'titulo': CsvField.name,
    'nome': CsvField.name,
    'alimento': CsvField.name,
    'produto': CsvField.name,

    // energy_kcal (also catches "energy kcal" from normalization)
    'energy': CsvField.energyKcal,
    'kcal': CsvField.energyKcal,
    'calories': CsvField.energyKcal,
    'cal': CsvField.energyKcal,
    'calorias': CsvField.energyKcal,
    'energia': CsvField.energyKcal,

    // energy_kj
    'kj': CsvField.energyKj,
    'energy kj': CsvField.energyKj,
    'energia kj': CsvField.energyKj,

    // protein_g
    'protein': CsvField.protein,
    'proteins': CsvField.protein,
    'prot': CsvField.protein,
    'proteina': CsvField.protein,
    'proteinas': CsvField.protein,

    // carbs_g
    'carbs': CsvField.carbs,
    'carbohydrate': CsvField.carbs,
    'carbohydrates': CsvField.carbs,
    'cho': CsvField.carbs,
    'carboidratos': CsvField.carbs,
    'carboidrato': CsvField.carbs,
    'carbo': CsvField.carbs,

    // sugars_g
    'sugar': CsvField.sugars,
    'sugars': CsvField.sugars,
    'of which sugars': CsvField.sugars,
    'acucar': CsvField.sugars,
    'acucares': CsvField.sugars,
    'acucares totais': CsvField.sugars,

    // added_sugars_g
    'added sugar': CsvField.addedSugars,
    'added sugars': CsvField.addedSugars,
    'acucares adicionados': CsvField.addedSugars,

    // trans_fat_g
    'trans': CsvField.transFat,
    'trans fat': CsvField.transFat,
    'gorduras trans': CsvField.transFat,
    'gordura trans': CsvField.transFat,

    // fat_g
    'fat': CsvField.fat,
    'fats': CsvField.fat,
    'total fat': CsvField.fat,
    'gordura': CsvField.fat,
    'gorduras': CsvField.fat,
    'gorduras totais': CsvField.fat,
    'lipidios': CsvField.fat,

    // saturates_g
    'saturated': CsvField.saturates,
    'saturates': CsvField.saturates,
    'saturated fat': CsvField.saturates,
    'saturada': CsvField.saturates,
    'gordura saturada': CsvField.saturates,

    // fiber_g
    'fiber': CsvField.fiber,
    'fibre': CsvField.fiber,
    'dietary fiber': CsvField.fiber,
    'fibra': CsvField.fiber,
    'fibras': CsvField.fiber,

    // salt_g / sodium_mg
    'salt': CsvField.salt,
    'sal': CsvField.salt,
    'sodium': CsvField.sodiumMg,
    'sodio': CsvField.sodiumMg,
    'na': CsvField.sodiumMg,

    // serving_size / serving_unit
    'serving': CsvField.servingSize,
    'serving size': CsvField.servingSize,
    'portion': CsvField.servingSize,
    'porcao': CsvField.servingSize,
    'unit': CsvField.servingUnit,
    'unidade': CsvField.servingUnit,

    // basis
    'basis': CsvField.basis,
    'base': CsvField.basis,

    // brand
    'brand': CsvField.brand,
    'marca': CsvField.brand,

    // barcode
    'barcode': CsvField.barcode,
    'ean': CsvField.barcode,
    'upc': CsvField.barcode,
    'codigo de barras': CsvField.barcode,
    'codigo': CsvField.barcode,

    // Unit-suffixed known fields (matched after unit detection).
    'protein_g': CsvField.protein,
    'carbs_g': CsvField.carbs,
    'sugars_g': CsvField.sugars,
    'added_sugars_g': CsvField.addedSugars,
    'trans_fat_g': CsvField.transFat,
    'fat_g': CsvField.fat,
    'saturates_g': CsvField.saturates,
    'fiber_g': CsvField.fiber,
    'salt_g': CsvField.salt,
    'sodium_mg': CsvField.sodiumMg,
    'energy_kcal': CsvField.energyKcal,
    'energy_kj': CsvField.energyKj,
  };
}
