import 'package:opendiet/core/nutrition/nutrient.dart';
import 'package:opendiet/core/nutrition/nutrients.dart';

/// A region whose %VD reference set is used to compute the %VD column (FR-027).
enum VdRegion {
  brazil,
  unitedStates,
  europeanUnion;

  // EU member-state ISO 3166-1 alpha-2 codes (uppercase).
  static const Set<String> _euCountryCodes = {
    'AT',
    'BE',
    'BG',
    'HR',
    'CY',
    'CZ',
    'DK',
    'EE',
    'FI',
    'FR',
    'DE',
    'GR',
    'HU',
    'IE',
    'IT',
    'LV',
    'LT',
    'LU',
    'MT',
    'NL',
    'PL',
    'PT',
    'RO',
    'SK',
    'SI',
    'ES',
    'SE',
  };

  /// The default region for a device country [code] (ISO 3166-1 alpha-2),
  /// falling back to Brazil when unknown (FR-027). Overridable in settings.
  static VdRegion fromCountryCode(String? code) {
    final upper = code?.toUpperCase();
    if (upper == 'BR') return VdRegion.brazil;
    if (upper == 'US') return VdRegion.unitedStates;
    if (upper != null && _euCountryCodes.contains(upper)) {
      return VdRegion.europeanUnion;
    }
    return VdRegion.brazil;
  }
}

/// A single region's %VD reference values, keyed by [Nutrient].
///
/// A nutrient absent from the map has no reference value in this region and
/// therefore shows no %VD (e.g. trans fat everywhere). Each value is in the
/// nutrient's canonical unit (kcal / g / mg).
class VdReferenceSet {
  const VdReferenceSet(this.region, this._references);

  /// The region this set belongs to.
  final VdRegion region;
  final Map<Nutrient, double> _references;

  /// The reference value for [nutrient], or null when the region defines none.
  double? referenceFor(Nutrient nutrient) => _references[nutrient];

  /// The %VD for [amount] of [nutrient]: amount / reference x 100.
  ///
  /// Returns null when the amount is absent or the nutrient has no reference.
  double? percentOf(double? amount, Nutrient nutrient) {
    final reference = _references[nutrient];
    if (amount == null || reference == null) return null;
    return amount / reference * 100;
  }

  /// The %VD of every nutrient in [nutrients]; absent entries map to null.
  Map<Nutrient, double?> percentagesFor(Nutrients nutrients) => {
    for (final nutrient in Nutrient.values)
      nutrient: percentOf(nutrients.amountOf(nutrient), nutrient),
  };
}

/// The %VD reference sets, one per region (FR-027, NFR-011).
///
/// These tables are the single in-code home of the reference values; the values
/// are verified against their source regulations in vd_reference_test.dart and
/// are never restated in prose elsewhere (see AGENTS.md). A nutrient omitted
/// from a table has no reference value in that region.
abstract final class VdReference {
  /// The reference set for [region].
  static VdReferenceSet forRegion(VdRegion region) => switch (region) {
    VdRegion.brazil => _brazil,
    VdRegion.unitedStates => _unitedStates,
    VdRegion.europeanUnion => _europeanUnion,
  };

  // ANVISA RDC 429/2020 + IN 75/2020, Anexo II (VDR for foods in general).
  static const VdReferenceSet _brazil = VdReferenceSet(VdRegion.brazil, {
    Nutrient.energy: 2000,
    Nutrient.carbohydrates: 300,
    Nutrient.addedSugars: 50,
    Nutrient.protein: 50,
    Nutrient.totalFat: 65,
    Nutrient.saturatedFat: 20,
    Nutrient.dietaryFiber: 25,
    Nutrient.sodium: 2000,
  });

  // FDA Daily Values, 21 CFR 101.9 (2016 Nutrition Facts label update).
  static const VdReferenceSet _unitedStates = VdReferenceSet(
    VdRegion.unitedStates,
    {
      Nutrient.energy: 2000,
      Nutrient.carbohydrates: 275,
      Nutrient.addedSugars: 50,
      Nutrient.protein: 50,
      Nutrient.totalFat: 78,
      Nutrient.saturatedFat: 20,
      Nutrient.dietaryFiber: 28,
      Nutrient.sodium: 2300,
    },
  );

  // Regulation (EU) No 1169/2011, Annex XIII, Part B (Reference Intakes).
  // The regulation lists salt 6 g; held here as sodium 2400 mg (salt / 2.5).
  static const VdReferenceSet _europeanUnion = VdReferenceSet(
    VdRegion.europeanUnion,
    {
      Nutrient.energy: 2000,
      Nutrient.totalFat: 70,
      Nutrient.saturatedFat: 20,
      Nutrient.carbohydrates: 260,
      Nutrient.totalSugars: 90,
      Nutrient.protein: 50,
      Nutrient.sodium: 2400,
    },
  );
}
