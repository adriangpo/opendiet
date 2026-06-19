# FR-014: CSV Row Validation

## Requirement

**ID:** FR-014
**Title:** CSV Row Validation
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall validate each row of an imported CSV and report rows that cannot be imported, without aborting the import of the valid rows.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-009 | Import foods from a CSV reliably |
| Customer Problem | CP-006 | The user expects to bring existing data in |
| Customer Problem | CP-010 | The user must be able to trust the data is intact |

## Acceptance Criteria

- [ ] Rows with missing required fields, wrong types, or malformed values are rejected individually.
- [ ] Valid rows are imported even when some rows are rejected.
- [ ] The user receives a summary of imported vs rejected rows, with the reason per rejected row.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
