# NFR-003: Backup Round-Trip Fidelity

## Requirement

**ID:** NFR-003
**Title:** Backup Round-Trip Fidelity
**Category:** Reliability
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall restore an exported dataset with 100% record fidelity when that backup is imported into a fresh installation.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-003, CN-004 | Generate and restore a complete backup |
| Applies To FRs | FR-005, FR-006 | Backup export and restore |

## Measurement Criteria

- **Target:** Exported then imported dataset is record-for-record identical to the source.
- **Minimum Acceptable:** No loss or alteration of any user-entered record.
- **Measurement Method:** Automated round-trip test comparing pre-export and post-import datasets.

## Acceptance Criteria

- [ ] Every food, recipe, diary entry, meal slot, setting, target, and history item survives export then import.
- [ ] No field values are altered by the round trip.
- [ ] Importing on a fresh install reproduces the original app state.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
