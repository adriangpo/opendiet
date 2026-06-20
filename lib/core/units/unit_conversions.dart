import 'package:opendiet/core/units/measurement_unit.dart';

/// Converts mass amounts between [MassUnit]s and the canonical gram.
///
/// Factors are the exact international avoirdupois definitions.
abstract final class MassConverter {
  static const double _gramsPerOunce = 28.349523125;
  static const double _gramsPerPound = 453.59237;

  /// Converts [value] expressed in [unit] to grams.
  static double toGrams(double value, MassUnit unit) =>
      value * _gramsPerGram(unit);

  /// Converts [grams] to [unit].
  static double fromGrams(double grams, MassUnit unit) =>
      grams / _gramsPerGram(unit);

  static double _gramsPerGram(MassUnit unit) => switch (unit) {
    MassUnit.gram => 1,
    MassUnit.ounce => _gramsPerOunce,
    MassUnit.pound => _gramsPerPound,
  };
}

/// Converts volume amounts between [VolumeUnit]s and the canonical milliliter.
abstract final class VolumeConverter {
  // US customary fluid ounce.
  static const double _millilitersPerFluidOunce = 29.5735295625;

  /// Converts [value] expressed in [unit] to milliliters.
  static double toMilliliters(double value, VolumeUnit unit) =>
      value * _millilitersPer(unit);

  /// Converts [milliliters] to [unit].
  static double fromMilliliters(double milliliters, VolumeUnit unit) =>
      milliliters / _millilitersPer(unit);

  static double _millilitersPer(VolumeUnit unit) => switch (unit) {
    VolumeUnit.milliliter => 1,
    VolumeUnit.fluidOunce => _millilitersPerFluidOunce,
  };
}

/// Converts food energy between kilocalories (canonical) and kilojoules.
abstract final class EnergyConverter {
  // Thermochemical kilocalorie definition.
  static const double _kilojoulesPerKilocalorie = 4.184;

  /// Converts [kilocalories] to kilojoules.
  static double kilocaloriesToKilojoules(double kilocalories) =>
      kilocalories * _kilojoulesPerKilocalorie;

  /// Converts [kilojoules] to kilocalories.
  static double kilojoulesToKilocalories(double kilojoules) =>
      kilojoules / _kilojoulesPerKilocalorie;
}

/// Converts between sodium and salt for the same mass unit.
///
/// Salt (sodium chloride) mass is sodium mass times this factor; the relation
/// is the food-labelling convention documented in agent_docs/csv_import.md.
abstract final class SodiumSaltConverter {
  static const double _saltPerSodium = 2.5;

  /// Salt mass equivalent to [sodium] (same mass unit).
  static double sodiumToSalt(double sodium) => sodium * _saltPerSodium;

  /// Sodium mass equivalent to [salt] (same mass unit).
  static double saltToSodium(double salt) => salt / _saltPerSodium;
}
