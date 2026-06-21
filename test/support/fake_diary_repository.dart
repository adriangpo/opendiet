import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/diary_repository.dart';

/// An in-memory [DiaryRepository] for widget tests.
class FakeDiaryRepository implements DiaryRepository {
  final List<DiaryEntry> _entries = [];

  @override
  Future<void> saveEntry(DiaryEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      _entries[index] = entry;
    } else {
      _entries.add(entry);
    }
  }

  @override
  Future<DiaryEntry?> findEntry(String id) async {
    final matching = _entries.where((e) => e.id == id);
    return matching.isEmpty ? null : matching.first;
  }

  @override
  Future<List<DiaryEntry>> entriesForDay(DateTime day) async =>
      _entries.where((e) => _isSameDate(e.day, day)).toList();

  @override
  Future<List<DiaryEntry>> allEntries() async => List.of(_entries);

  @override
  Future<void> deleteEntry(String id) async =>
      _entries.removeWhere((e) => e.id == id);

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
