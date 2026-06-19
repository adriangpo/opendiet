# FR-016: Recipe Nutrition Computation

## Requirement

**ID:** FR-016
**Title:** Recipe Nutrition Computation
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall compute a recipe's total and per-serving nutrition from its ingredients and yield.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-010 | Automatically compute per-serving recipe nutrition |
| Customer Problem | CP-007 | The user who cooks expects accurate per-serving nutrition |

## Acceptance Criteria

- [ ] Recipe total nutrition equals the sum of its ingredients' contributions across all tracked nutrients.
- [ ] Per-serving nutrition equals total nutrition divided by the yield.
- [ ] Changing an ingredient, quantity, or yield updates totals and per-serving values consistently.
- [ ] Nutrient fields absent from an ingredient are handled without producing incorrect totals.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
