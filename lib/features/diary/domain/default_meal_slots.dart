import 'package:opendiet/core/identifiers/id_generator.dart';
import 'package:opendiet/features/diary/domain/meal_slot.dart';

/// Builds the optional default meal-slot template (FR-019).
///
/// Produces Breakfast / Lunch / Dinner / Snack in day order, each a fully
/// editable [MealSlot]. Names are supplied by [DefaultMealSlots.build]'s caller
/// so the domain stays language-neutral (localization happens at presentation).
abstract final class DefaultMealSlots {
  /// The default slots, in order, with sequential positions and fresh ids.
  ///
  /// [localizedName] maps each kind to its user-facing name; [idGenerator]
  /// mints each slot's id.
  static List<MealSlot> build({
    required String Function(DefaultMealSlotKind kind) localizedName,
    required IdGenerator idGenerator,
  }) {
    const kinds = DefaultMealSlotKind.values;
    return [
      for (var position = 0; position < kinds.length; position++)
        MealSlot(
          id: idGenerator.newId(),
          name: localizedName(kinds[position]),
          position: position,
        ),
    ];
  }
}
