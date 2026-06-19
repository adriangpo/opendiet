# NFR-004: Data Durability

## Requirement

**ID:** NFR-004
**Title:** Data Durability
**Category:** Reliability
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall ensure that a crash or interrupted write does not lose or corrupt previously committed data.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-016 | Maintain local-store integrity |
| Applies To FRs | FR-001, FR-023 | Local persistence and integrity-guarded writes |

## Measurement Criteria

- **Target:** Zero committed-data loss across simulated crashes and kills mid-write.
- **Minimum Acceptable:** Zero corruption of previously committed records.
- **Measurement Method:** Fault-injection tests that interrupt writes and verify the store afterward.

## Acceptance Criteria

- [ ] Killing the app during a write leaves previously committed data intact.
- [ ] Interrupted multi-record operations leave the store consistent (fully applied or not at all).
- [ ] The store opens cleanly after an abrupt termination.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
