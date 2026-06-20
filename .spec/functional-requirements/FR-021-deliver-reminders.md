# FR-021: Deliver Reminders

## Requirement

**ID:** FR-021
**Title:** Deliver Reminders
**Priority:** Should Have
**Status:** Draft

### Statement

OpenDiet shall deliver a local notification at each configured reminder time.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-014 | Be reminded to log at configurable mealtimes |
| Customer Problem | CP-009 | The user hopes to be reminded so the diary has no gaps |

## Acceptance Criteria

- [x] A local notification fires at each enabled reminder time without the app being open.
- [x] Disabled or removed reminders do not fire.
- [x] Reminders use only on-device notification scheduling (no remote/push service).
- [x] Denied notification permission is handled with a clear in-app explanation.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
