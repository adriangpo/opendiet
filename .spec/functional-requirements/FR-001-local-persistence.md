# FR-001: Local Persistence

## Requirement

**ID:** FR-001
**Title:** Local Persistence
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall store all foods, recipes, diary entries, settings, and the daily target in an on-device store that persists between app launches.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-001 | Keep all dietary data stored only on the device |
| Customer Problem | CP-001 | The user must track their diet without surrendering data to a vendor |

## Acceptance Criteria

- [ ] Data created in one session is present after the app is closed and reopened.
- [ ] All entity types (foods, recipes, diary entries, meal slots, settings, target) are persisted locally.
- [ ] No user data is written to any remote location as part of persistence.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
