# NFR-002: Offline Coverage

## Requirement

**ID:** NFR-002
**Title:** Offline Coverage
**Category:** Reliability
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall keep 100% of non-Open-Food-Facts flows fully functional with networking disabled.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-002 | Record diary entries and totals at any time, including offline |
| Applies To FRs | FR-002, FR-003, FR-004, FR-008, FR-015, FR-016, FR-017, FR-018, FR-019, FR-022, FR-024 | Local-only capabilities |

## Measurement Criteria

- **Target:** 100% of listed flows pass with the network disabled.
- **Minimum Acceptable:** 100% (logging and totals are non-negotiable offline).
- **Measurement Method:** Execute the offline test suite with networking stubbed/disabled.

## Acceptance Criteria

- [ ] Diary editing, custom foods, recipes, totals, target comparison, quick entry, meal slots, and units all work offline.
- [ ] Only Open-Food-Facts-dependent actions (search, barcode lookup, contribute) require connectivity.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
