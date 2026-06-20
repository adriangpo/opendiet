import 'package:opendiet/core/time/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time_providers.g.dart';

/// The application clock (the device wall clock in production).
@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const SystemClock();
