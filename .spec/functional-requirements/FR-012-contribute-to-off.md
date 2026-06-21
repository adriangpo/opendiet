# FR-012: Contribute to Open Food Facts

## Requirement

**ID:** FR-012
**Title:** Contribute to Open Food Facts
**Priority:** Should Have
**Status:** Draft

### Statement

OpenDiet shall allow a user who is signed in to their Open Food Facts account to submit a new or corrected product to Open Food Facts.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-008 | Contribute new or corrected products using the user's own account |
| Customer Problem | CP-005 | The user expects to log foods that may be missing from the database |

## Acceptance Criteria

- [ ] Contribution is only available when the user is authenticated with their own Open Food Facts account.
- [ ] The user can submit a new product or a correction to an existing one.
- [ ] A failed submission (offline, auth error, server error) is reported clearly without losing the user's entered data.

## Implementation Notes

- 2026-06-21: S-07 exposes the correction entry point only for saved Open Food
  Facts foods. Submission/auth handling remains in S-17.

## Test Cases

- `test/features/foods/presentation/food_detail_screen_test.dart`

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
