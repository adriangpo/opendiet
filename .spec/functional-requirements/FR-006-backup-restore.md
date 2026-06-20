# FR-006: Backup Restore

## Requirement

**ID:** FR-006
**Title:** Backup Restore
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall restore the complete dataset from a previously exported backup file.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-004 | Restore the entire dataset from a backup file |
| Customer Problem | CP-003 | The user must be able to survive device loss and migration |

## Acceptance Criteria

- [ ] Importing a backup reproduces every entity present at export time.
- [ ] The user is informed before a restore overwrites or merges existing data.
- [ ] A malformed or incompatible backup file is rejected with a clear message and no partial corruption.

## Implementation Notes

- `BackupRepository.import()` parses and validates the JSON envelope before any
  write: an unsupported version or a malformed record raises
  `BackupFormatException` and the store is left untouched. The restore itself
  runs in a single database transaction that wipes every table and re-inserts
  the parsed dataset, so a referential-integrity failure rolls the whole thing
  back (wipe included), leaving previously committed data intact (NFR-004).

## Test Cases

- `test/features/backup/domain/backup_document_test.dart`
- `test/features/backup/data/drift_backup_repository_test.dart`

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
