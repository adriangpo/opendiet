/// A source of the current time.
///
/// Injected everywhere a timestamp is needed so production code never calls
/// DateTime.now() directly and tests stay deterministic (see AGENTS.md). Kept
/// as an interface (not a function) so it can be passed and faked as a
/// dependency.
// ignore: one_member_abstracts
abstract interface class Clock {
  /// The current instant.
  DateTime now();
}

/// The real clock, backed by the device wall clock.
class SystemClock implements Clock {
  /// Creates a clock that reads the device time.
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// A clock pinned to a fixed instant that can be advanced manually.
///
/// Useful for deterministic tests and for any flow that needs to replay or
/// pin time rather than read the wall clock.
class FixedClock implements Clock {
  /// Creates a clock fixed at the given instant.
  FixedClock(this._instant);

  DateTime _instant;

  @override
  DateTime now() => _instant;

  /// Moves the clock forward by [duration].
  void advance(Duration duration) => _instant = _instant.add(duration);
}
