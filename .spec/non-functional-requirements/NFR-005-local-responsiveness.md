# NFR-005: Local Responsiveness

## Requirement

**ID:** NFR-005
**Title:** Local Responsiveness
**Category:** Performance
**Priority:** Should Have
**Status:** Draft

### Statement

OpenDiet shall reflect local diary actions (add/edit/delete entry, recompute totals) within 200 ms at the 95th percentile on supported devices.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-002, CN-012 | Record and re-log foods quickly |
| Applies To FRs | FR-002, FR-003, FR-004, FR-018 | Diary editing, totals, quick entry |

## Measurement Criteria

- **Target:** p95 < 200 ms for local diary operations.
- **Minimum Acceptable:** p95 < 500 ms with a realistic dataset (e.g. thousands of entries).
- **Measurement Method:** Instrumented timing tests on representative devices/datasets.

## Acceptance Criteria

- [ ] Adding or editing an entry updates the UI and totals within the target on a realistic dataset.
- [ ] Performance holds as the diary grows to a multi-year volume of entries.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
