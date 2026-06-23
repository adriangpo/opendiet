# FR-003: Flexible Quantity Logging

## Requirement

**ID:** FR-003
**Title:** Flexible Quantity Logging
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall allow the user to log a food by a number of servings or by a weight/volume amount, and shall scale the entry's nutrition accordingly.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-002 | Record diary entries using on-device data |
| Customer Problem | CP-002 | The user must be able to record meals accurately at any time |

## Acceptance Criteria

- [ ] A food can be logged by servings when the food defines a serving size.
- [ ] A food can be logged by weight/volume, with nutrition computed from per-100 g/ml values.
- [ ] Switching between servings and weight/volume yields consistent nutrition for the same actual amount.

## Implementation Notes

- 2026-06-21: The first S-04 implementation handles saved local food
  references from `/log/quantity/food:<id>`. Recipe servings and transient
  Open Food Facts product references remain separate route integrations.

## Test Cases

- `test/features/diary/presentation/food_quantity_entry_screen_test.dart`

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
