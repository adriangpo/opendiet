# FR-013: CSV Import with Column Mapping

## Requirement

**ID:** FR-013
**Title:** CSV Import with Column Mapping
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall import foods from a user-provided CSV file, proposing a mapping from the file's columns to OpenDiet's food fields that the user can review and adjust before importing.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-009 | Import foods from a CSV, mapping columns when they do not match |
| Customer Problem | CP-006 | The user expects to bring an existing food list in without re-entry |

## Acceptance Criteria

- [ ] The user can select a CSV file regardless of its column header names.
- [ ] OpenDiet proposes a column-to-field mapping automatically and lets the user change any mapping before import.
- [ ] A column may be mapped to "ignore"; a required field left unmapped blocks import with a clear explanation.
- [ ] The user can preview a sample of mapped rows before committing the import.

## Implementation Notes

<!-- Engineers add notes here during implementation. The CSV field contract lives in agent_docs/csv_import.md. -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
