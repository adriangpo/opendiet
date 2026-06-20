import 'package:opendiet/features/diary/domain/diary_entry.dart';

/// Persists and retrieves diary entries (FR-002, FR-004).
///
/// All operations are local and never block on a network call.
abstract interface class DiaryRepository {
  /// Inserts or updates [entry].
  Future<void> saveEntry(DiaryEntry entry);

  /// The diary entry with [id], or null when absent.
  Future<DiaryEntry?> findEntry(String id);

  /// All entries on [day]'s calendar date, ordered by creation.
  Future<List<DiaryEntry>> entriesForDay(DateTime day);

  /// Every diary entry across all days, ordered by id (FR-005).
  Future<List<DiaryEntry>> allEntries();

  /// Removes the diary entry with [id].
  Future<void> deleteEntry(String id);
}
