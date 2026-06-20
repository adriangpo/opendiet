import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/time/clock.dart';

void main() {
  group('UuidV7Generator', () {
    test('produces a syntactically valid version-7 UUID', () {
      final generator = UuidV7Generator(FixedClock(DateTime.utc(2026, 6, 19)));

      final id = generator.newId();

      // Canonical 8-4-4-4-12 hex layout, with the version nibble fixed to 7
      // and the variant nibble in 8-b (UUIDv7).
      final hexLayout = RegExp(r'^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$');
      expect(hexLayout.hasMatch(id), isTrue, reason: id);
      expect(id[14], '7', reason: id);
      expect('89ab'.contains(id[19]), isTrue, reason: id);
    });

    test('consecutive ids are unique', () {
      final generator = UuidV7Generator(FixedClock(DateTime.utc(2026, 6, 19)));

      final ids = List.generate(1000, (_) => generator.newId()).toSet();

      expect(ids, hasLength(1000));
    });

    test('an id minted at a later time sorts after an earlier one', () {
      // UUIDv7 embeds the millisecond timestamp in its high bits, so lexical
      // order tracks creation time -- the property the diary relies on.
      final clock = FixedClock(DateTime.utc(2026, 6, 19, 8));
      final generator = UuidV7Generator(clock);

      final earlier = generator.newId();
      clock.advance(const Duration(milliseconds: 5));
      final later = generator.newId();

      expect(earlier.compareTo(later), lessThan(0));
    });
  });
}
