import 'package:opendiet/core/time/clock.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

/// Mints identifiers for locally-stored entities.
///
/// An interface (not a bare function) so it can be injected and faked.
// ignore: one_member_abstracts
abstract interface class IdGenerator {
  /// Returns a fresh identifier.
  String newId();
}

/// Generates time-ordered UUIDv7 identifiers.
///
/// UUIDv7 embeds the creation timestamp in its high bits, so identifiers sort
/// lexically by creation time. That keeps diary and entry ordering stable
/// without a separate sequence column (see AGENTS.md). The timestamp comes from
/// the injected [Clock] so generation is deterministic under test.
class UuidV7Generator implements IdGenerator {
  /// Creates a generator that timestamps ids from [Clock].
  UuidV7Generator(this._clock, [this._uuid = const Uuid()]);

  final Clock _clock;
  final Uuid _uuid;

  @override
  String newId() {
    final millis = _clock.now().millisecondsSinceEpoch;
    return _uuid.v7(config: V7Options(millis, null));
  }
}
