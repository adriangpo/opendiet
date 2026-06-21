# FR-026: ANVISA Nutrition Table View

## Requirement

**ID:** FR-026
**Title:** ANVISA Nutrition Table View
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall present any food or recipe as the ANVISA nutrition table, with a per-100 g/ml column, a per-serving column (including the household measure), and a %VD column.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-019 | See foods as the ANVISA table with %VD |
| Customer Problem | CP-012 | Brazilian users expect the ANVISA nutrition format |

## Acceptance Criteria

- [ ] The table shows per-100 g/ml and per-serving columns, with the serving's household measure.
- [ ] A %VD column is shown for nutrients that have a reference value; trans fat shows no %VD.
- [ ] The same table renders for local, custom, recipe, and Open-Food-Facts-sourced foods.
- [ ] Mandatory nutrients absent from the source (e.g. added sugars from OFF) are shown as not-informed, not zero.

## Implementation Notes

<!-- %VD computation is FR-027. This requirement is the presentation. -->

## Test Cases

- `test/features/foods/presentation/food_detail_screen_test.dart`
- `test/features/diary/presentation/food_quantity_entry_screen_test.dart`

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
