# FR-005: Backup Export

## Requirement

**ID:** FR-005
**Title:** Backup Export
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall export the complete dataset to a single backup file that the user can store outside the app.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-003 | Generate a complete backup file of all data |
| Customer Problem | CP-003 | The user must be able to survive device loss and migration |

## Acceptance Criteria

- [ ] The export contains every entity type (foods, recipes, diary, meal slots, settings, target, quick-entry history).
- [ ] The export is written to a single user-accessible file.
- [ ] The export completes without requiring a network connection.

## Implementation Notes

- `BackupRepository.export()` (`lib/features/backup/`) serializes the full dataset
  to a single JSON document: a versioned envelope around each entity collection.
  Entity values use the entities' own `toJson`, so no field shape is restated.
  Export reads through the existing feature repositories (foods, recipes, meal
  slots, diary, settings), so it never touches the network.

## Test Cases

- `test/features/backup/domain/backup_document_test.dart`
- `test/features/backup/data/drift_backup_repository_test.dart`

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
