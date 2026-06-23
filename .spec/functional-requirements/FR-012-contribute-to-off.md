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
- The Open Food Facts account state is restored from platform secure storage
  when the S-17 settings screen loads. Restoring a stored account configures
  the OFF client for authenticated write operations without calling the live
  login API on every screen open.
- Sign-in validates the user's own OFF username/password against the OFF
  repository before credentials are persisted. Contribution actions remain
  hidden until an account is signed in.
- Sign-out deletes the secure-storage entry and clears the OFF client account
  used for write operations.

## Test Cases

- `test/features/foods/data/off_account_repository_test.dart`
- `test/features/settings/presentation/off_account_screen_test.dart`

---
*Created: 2026-06-19*
*Last Updated: 2026-06-21*
*Author: Problem-Based SRS*
