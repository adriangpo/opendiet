# FR-030: TACO Import

## Requirement

**ID:** FR-030
**Title:** TACO Import
**Priority:** Should Have
**Status:** Draft

### Statement

OpenDiet shall import Brazilian foods from a TACO-format file supplied by the user, using a built-in TACO column-mapping preset, without bundling or redistributing the TACO dataset.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-021 | Import Brazilian foods from a TACO-format file |
| Customer Problem | CP-005 | The user expects to log the (Brazilian) foods they actually eat |
| Customer Problem | CP-006 | The user expects to bring existing data in |

## Acceptance Criteria

- [ ] A TACO preset pre-maps the TACO columns onto OpenDiet fields in the CSV import flow (FR-013).
- [ ] The user supplies their own TACO file; OpenDiet ships no TACO data (restricted-use licence).
- [ ] Imported foods carry the ANVISA nutrient fields where the TACO file provides them.
- [ ] Per-row validation and reporting (FR-014) apply to the import.

## Implementation Notes

<!-- Licence rationale and TACO column layout: agent_docs/brazilian_nutrition.md + agent_docs/csv_import.md. -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
