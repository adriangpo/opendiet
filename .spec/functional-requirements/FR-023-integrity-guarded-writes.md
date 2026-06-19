# FR-023: Integrity-Guarded Writes

## Requirement

**ID:** FR-023
**Title:** Integrity-Guarded Writes
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall validate data before writing it and shall reject malformed data so that the local store is never left in an inconsistent state.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-016 | Maintain local-store integrity so data is never silently lost or corrupted |
| Customer Problem | CP-010 | The user must be able to trust the data is intact and unrecoverable damage is avoided |

## Acceptance Criteria

- [ ] Writes that would violate referential or value constraints are rejected with a clear error.
- [ ] A rejected write leaves prior committed data unchanged.
- [ ] Multi-record operations (import, restore, recipe edits) apply atomically or not at all.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
