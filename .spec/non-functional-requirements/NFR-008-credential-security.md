# NFR-008: Credential Security

## Requirement

**ID:** NFR-008
**Title:** Credential Security
**Category:** Security
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall store Open Food Facts credentials in platform secure storage and shall never log them or include them in backups or source control.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-008 | Contribute using the user's own Open Food Facts account |
| Applies To FRs | FR-012 | Contribute to Open Food Facts |

## Measurement Criteria

- **Target:** Credentials only ever reside in platform secure storage at rest.
- **Minimum Acceptable:** Credentials never appear in logs, exports, or the repository.
- **Measurement Method:** Inspect storage location, log output, and backup contents; static scan for secrets.

## Acceptance Criteria

- [ ] Open Food Facts credentials are written only to platform secure storage.
- [ ] Credentials never appear in logs or in a backup export.
- [ ] No credential is bundled with or committed to the app.

## Implementation Notes

- OFF credentials are owned by `OffCredentialStore`, whose production adapter
  writes only to `FlutterSecureStorage`. They are not part of Drift settings,
  backup documents, fixtures, source code, or localization strings.
- UI/controller state exposes only the signed-in username. Passwords are used
  only inside the account repository and OFF repository authentication methods.

---
*Created: 2026-06-19*
*Last Updated: 2026-06-21*
