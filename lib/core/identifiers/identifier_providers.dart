import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'identifier_providers.g.dart';

/// Mints sortable UUIDv7 identifiers for new entities.
@Riverpod(keepAlive: true)
IdGenerator idGenerator(Ref ref) => UuidV7Generator(ref.watch(clockProvider));
