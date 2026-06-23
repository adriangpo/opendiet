# FR-019: Customizable Meal Slots

## Requirement

**ID:** FR-019
**Title:** Customizable Meal Slots
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall allow the user to create, rename, reorder, and remove meal slots, and shall offer an optional default template of slots.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-013 | Organize the diary into fully customizable meal slots |
| Customer Problem | CP-008 | The user expects logging structured to their own routine |

## Acceptance Criteria

- [ ] The user can add, rename, reorder, and remove meal slots.
- [ ] An optional default template (e.g. Breakfast/Lunch/Dinner/Snacks) can be applied and then fully customized.
- [ ] Diary entries are organized under the user's meal slots and totals respect that grouping.
- [ ] Removing a slot handles existing entries in that slot without data loss (e.g. reassign or confirm).

## Implementation Notes

- S-14 (`/settings/meals`) uses the existing `MealSlotRepository` to stage and persist create, rename, reorder, remove, and reset-to-default changes. Deletion is confirmation-gated; entry-aware reassignment will need a diary-entry count/reassign use case because the current meal-slot repository only exposes save/list/delete.

## Test Cases

- Widget coverage: `test/features/settings/presentation/meal_slots_screen_test.dart`
- Settings/router coverage: `test/features/settings/presentation/settings_screen_test.dart`, `test/core/navigation/app_shell_test.dart`

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
