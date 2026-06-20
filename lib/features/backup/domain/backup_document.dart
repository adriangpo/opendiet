import 'package:opendiet/features/diary/domain/diary_entry.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';
import 'package:opendiet/features/foods/domain/food.dart';
import 'package:opendiet/features/recipes/domain/recipe.dart';
import 'package:opendiet/features/settings/domain/app_settings.dart';

/// Raised when a backup document cannot be parsed: an unsupported envelope
/// version, a missing or wrongly typed field, or a malformed record (FR-006).
///
/// Parsing fails before any write, so a rejected backup never corrupts the
/// store.
class BackupFormatException implements Exception {
  /// Creates an exception describing why a backup is unreadable.
  const BackupFormatException(this.message);

  /// A human-readable explanation of the problem.
  final String message;

  @override
  String toString() => 'BackupFormatException: $message';
}

/// The in-memory shape of a full-dataset backup (FR-005, FR-006).
///
/// This is a versioned envelope around every entity collection. Entity values
/// are (de)serialized with the entities' own toJson/fromJson, so this type
/// never restates their field shapes.
class BackupDocument {
  /// Creates a backup document.
  const BackupDocument({
    required this.version,
    required this.foods,
    required this.recipes,
    required this.mealSlots,
    required this.diaryEntries,
    required this.settings,
  });

  /// Parses and validates a backup document from its JSON form.
  ///
  /// Throws [BackupFormatException] when the envelope version is unsupported or
  /// any field is missing, wrongly typed, or a malformed record.
  factory BackupDocument.fromJson(Map<String, dynamic> json) {
    final version = json['version'];
    if (version is! int) {
      throw const BackupFormatException(
        'Backup is missing a numeric "version".',
      );
    }
    if (version != currentVersion) {
      throw BackupFormatException('Unsupported backup version: $version.');
    }
    try {
      return BackupDocument(
        version: version,
        foods: _records(json, 'foods', Food.fromJson),
        recipes: _records(json, 'recipes', Recipe.fromJson),
        mealSlots: _records(json, 'mealSlots', MealSlot.fromJson),
        diaryEntries: _records(json, 'diaryEntries', DiaryEntry.fromJson),
        settings: AppSettings.fromJson(_object(json, 'settings')),
      );
    } on BackupFormatException {
      rethrow;
    } on Object catch (error) {
      throw BackupFormatException('Backup contains a malformed record: $error');
    }
  }

  /// The current backup envelope schema version. A document carrying any other
  /// version is rejected rather than guessed at.
  static const int currentVersion = 1;

  /// The envelope schema version of this document.
  final int version;

  /// Every stored food.
  final List<Food> foods;

  /// Every stored recipe with its ordered ingredients.
  final List<Recipe> recipes;

  /// Every meal slot.
  final List<MealSlot> mealSlots;

  /// Every diary entry across all days.
  final List<DiaryEntry> diaryEntries;

  /// The single profile's settings.
  final AppSettings settings;

  /// Serializes the whole dataset to a single JSON document.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'version': version,
    'foods': foods.map((food) => food.toJson()).toList(),
    'recipes': recipes.map((recipe) => recipe.toJson()).toList(),
    'mealSlots': mealSlots.map((slot) => slot.toJson()).toList(),
    'diaryEntries': diaryEntries.map((entry) => entry.toJson()).toList(),
    'settings': settings.toJson(),
  };

  static List<T> _records<T>(
    Map<String, dynamic> json,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final raw = json[key];
    if (raw is! List) {
      throw BackupFormatException('Backup field "$key" must be a list.');
    }
    return raw.map((element) {
      if (element is! Map) {
        throw BackupFormatException(
          'Backup field "$key" contains a non-object element.',
        );
      }
      return fromJson(Map<String, dynamic>.from(element));
    }).toList();
  }

  static Map<String, dynamic> _object(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw is! Map) {
      throw BackupFormatException('Backup field "$key" must be an object.');
    }
    return Map<String, dynamic>.from(raw);
  }
}
