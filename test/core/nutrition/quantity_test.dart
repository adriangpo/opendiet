import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/nutrition/quantity.dart';

void main() {
  group('Quantity', () {
    test('named helpers set the matching measure', () {
      expect(Quantity.grams(150).measure, QuantityMeasure.grams);
      expect(Quantity.milliliters(330).measure, QuantityMeasure.milliliters);
      expect(Quantity.servings(2.5).measure, QuantityMeasure.servings);
      expect(Quantity.grams(150).amount, 150);
    });

    test('isByServings distinguishes serving quantities from metric ones', () {
      expect(Quantity.servings(1).isByServings, isTrue);
      expect(Quantity.grams(1).isByServings, isFalse);
      expect(Quantity.milliliters(1).isByServings, isFalse);
    });

    test('round-trips through json', () {
      final quantity = Quantity.servings(1.5);

      expect(Quantity.fromJson(quantity.toJson()), quantity);
    });
  });
}
