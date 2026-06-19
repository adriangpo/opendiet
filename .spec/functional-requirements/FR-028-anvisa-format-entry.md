# FR-028: ANVISA-Format Food Entry

## Requirement

**ID:** FR-028
**Title:** ANVISA-Format Food Entry
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall let the user enter a custom food in the ANVISA layout -- the ten mandatory nutrients, the serving size, and the household measure -- when creating or editing a food.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-018 | Enter custom foods using the full ANVISA nutrient set |
| Customer Problem | CP-012 | Brazilian users expect the ANVISA nutrition format |

## Acceptance Criteria

- [ ] The custom-food editor exposes all ten mandatory nutrients, including added sugars and trans fat.
- [ ] The user can enter a serving size and a household measure (e.g. "2 unidades (30 g)").
- [ ] Values may be entered on a per-100 g/ml or per-serving basis; any field may be left blank.
- [ ] Entered values are validated at runtime and stored as canonical metric.

## Implementation Notes

<!-- Extends FR-008 (custom food creation) with the ANVISA fields and household measure. -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
