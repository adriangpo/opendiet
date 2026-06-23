# FR-018: Quick Entry

## Requirement

**ID:** FR-018
**Title:** Quick Entry
**Priority:** Should Have
**Status:** Draft

### Statement

OpenDiet shall provide fast-logging helpers: recently logged foods, user-marked favorites, copying a previous day or meal, and search history.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-012 | Log foods rapidly via recents, favorites, copy day/meal, search history |
| Customer Problem | CP-008 | The user expects low-friction daily logging |

## Acceptance Criteria

- [ ] Recently logged foods are surfaced for one-tap re-logging.
- [ ] Foods and recipes can be marked/unmarked as favorites and are listed for quick access.
- [ ] The user can copy a previous day or a specific meal into the current day.
- [ ] Recent searches are retained and re-selectable.
- [ ] A recently logged food can be re-logged in no more than three taps.

## Implementation Notes

- 2026-06-21: S-07 lets users toggle a saved food favorite from the detail
  screen using `FoodRepository.toggleFavorite`, so favorites stay source
  independent.

## Test Cases

- `test/features/foods/presentation/food_detail_screen_test.dart`

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
