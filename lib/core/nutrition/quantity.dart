import 'package:freezed_annotation/freezed_annotation.dart';

part 'quantity.freezed.dart';
part 'quantity.g.dart';

/// How a logged amount is expressed.
///
/// [grams] and [milliliters] are canonical-metric amounts; [servings] is a
/// count of the food's own serving (FR-003).
enum QuantityMeasure { grams, milliliters, servings }

/// An amount of a food: a number paired with the [QuantityMeasure] it is in.
@freezed
abstract class Quantity with _$Quantity {
  /// Creates a quantity of [amount] expressed in [measure].
  const factory Quantity({
    required double amount,
    required QuantityMeasure measure,
  }) = _Quantity;

  const Quantity._();

  /// Builds a quantity from its JSON form.
  factory Quantity.fromJson(Map<String, dynamic> json) =>
      _$QuantityFromJson(json);

  /// A mass quantity in grams.
  factory Quantity.grams(double amount) =>
      Quantity(amount: amount, measure: QuantityMeasure.grams);

  /// A volume quantity in milliliters.
  factory Quantity.milliliters(double amount) =>
      Quantity(amount: amount, measure: QuantityMeasure.milliliters);

  /// A quantity counted in the food's own servings.
  factory Quantity.servings(double amount) =>
      Quantity(amount: amount, measure: QuantityMeasure.servings);

  /// Whether this quantity counts servings rather than a metric amount.
  bool get isByServings => measure == QuantityMeasure.servings;
}
