# FR-027: %VD Reference Sets

## Requirement

**ID:** FR-027
**Title:** %VD Reference Sets
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall compute the %VD column from a region-selected reference set (Brazil, US, or EU), defaulted from the device region and overridable in settings.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-019 | %VD computed from a region-appropriate reference set |
| Customer Problem | CP-012 | Brazilian users expect %VD against Brazilian reference values |
| Customer Problem | CP-011 | Users expect locale-appropriate presentation |

## Acceptance Criteria

- [ ] %VD = nutrient amount / reference value, per the selected region's set.
- [ ] The reference set defaults from device region (Brazil -> ANVISA IN 75/2020) and can be changed in settings.
- [ ] Each reference set is held in a single, test-verified table citing its source regulation (not hardcoded ad hoc).
- [ ] Nutrients without a reference value in a set (e.g. trans fat) display no %VD.

## Implementation Notes

<!-- Reference values: see agent_docs/brazilian_nutrition.md. Region selection is independent of UI language. -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
