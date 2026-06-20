import 'package:opendiet/core/units/measurement_unit.dart';

/// The unit system the user enters and reads amounts in (FR-024).
///
/// Selection only changes presentation and input parsing; stored values are
/// always canonical metric.
enum UnitSystem {
  metric,
  imperial;

  /// The mass unit this system displays.
  MassUnit get massUnit =>
      this == UnitSystem.metric ? MassUnit.gram : MassUnit.ounce;

  /// The volume unit this system displays.
  VolumeUnit get volumeUnit =>
      this == UnitSystem.metric ? VolumeUnit.milliliter : VolumeUnit.fluidOunce;
}
