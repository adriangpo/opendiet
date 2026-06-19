# Functional Requirements — Index

**Project:** OpenDiet | **Version:** 1.0 | **Created:** 2026-06-19
**Total FRs:** 30

| FR | Title | Traces to CN | Priority |
|----|-------|--------------|----------|
| [FR-001](FR-001-local-persistence.md) | Local persistence | CN-001 | Must |
| [FR-002](FR-002-offline-diary-editing.md) | Offline diary editing | CN-002 | Must |
| [FR-003](FR-003-flexible-quantity.md) | Flexible quantity logging | CN-002 | Must |
| [FR-004](FR-004-daily-totals.md) | Daily nutrient totals | CN-002, CN-015 | Must |
| [FR-005](FR-005-backup-export.md) | Backup export | CN-003 | Must |
| [FR-006](FR-006-backup-restore.md) | Backup restore | CN-004 | Must |
| [FR-007](FR-007-ungated-access.md) | Ungated access | CN-005 | Must |
| [FR-008](FR-008-custom-food-creation.md) | Custom food creation | CN-006 | Must |
| [FR-009](FR-009-off-text-search.md) | Open Food Facts text search | CN-007 | Must |
| [FR-010](FR-010-barcode-lookup.md) | Barcode lookup | CN-007 | Must |
| [FR-011](FR-011-save-off-product.md) | Save Open Food Facts product | CN-007 | Must |
| [FR-012](FR-012-contribute-to-off.md) | Contribute to Open Food Facts | CN-008 | Should |
| [FR-013](FR-013-csv-import-mapping.md) | CSV import with column mapping | CN-009 | Must |
| [FR-014](FR-014-csv-row-validation.md) | CSV row validation | CN-009 | Must |
| [FR-015](FR-015-recipe-creation.md) | Recipe creation | CN-010 | Must |
| [FR-016](FR-016-recipe-nutrition.md) | Recipe nutrition computation | CN-010 | Must |
| [FR-017](FR-017-log-recipe-by-servings.md) | Log recipe by servings | CN-011 | Must |
| [FR-018](FR-018-quick-entry.md) | Quick entry | CN-012 | Should |
| [FR-019](FR-019-customizable-meals.md) | Customizable meal slots | CN-013 | Must |
| [FR-020](FR-020-configure-reminders.md) | Configure reminders | CN-014 | Should |
| [FR-021](FR-021-deliver-reminders.md) | Deliver reminders | CN-014 | Should |
| [FR-022](FR-022-target-and-comparison.md) | Daily target and comparison | CN-015 | Must |
| [FR-023](FR-023-integrity-guarded-writes.md) | Integrity-guarded writes | CN-016 | Must |
| [FR-024](FR-024-unit-system.md) | Unit system | CN-017 | Must |
| [FR-025](FR-025-anvisa-nutrient-model.md) | ANVISA nutrient model | CN-018, CN-019 | Must |
| [FR-026](FR-026-anvisa-table-view.md) | ANVISA nutrition table view | CN-019 | Must |
| [FR-027](FR-027-vd-reference-sets.md) | %VD reference sets | CN-019 | Must |
| [FR-028](FR-028-anvisa-format-entry.md) | ANVISA-format food entry | CN-018 | Must |
| [FR-029](FR-029-ptbr-localization.md) | Brazilian Portuguese localization | CN-020 | Must |
| [FR-030](FR-030-taco-import.md) | TACO import | CN-021 | Should |

## CN → FR coverage

| CN | FRs |
|----|-----|
| CN-001 | FR-001 |
| CN-002 | FR-002, FR-003, FR-004 |
| CN-003 | FR-005 |
| CN-004 | FR-006 |
| CN-005 | FR-007 |
| CN-006 | FR-008 |
| CN-007 | FR-009, FR-010, FR-011 |
| CN-008 | FR-012 |
| CN-009 | FR-013, FR-014 |
| CN-010 | FR-015, FR-016 |
| CN-011 | FR-017 |
| CN-012 | FR-018 |
| CN-013 | FR-019 |
| CN-014 | FR-020, FR-021 |
| CN-015 | FR-004, FR-022 |
| CN-016 | FR-023 |
| CN-017 | FR-024 |
| CN-018 | FR-025, FR-028 |
| CN-019 | FR-026, FR-027 (and FR-025) |
| CN-020 | FR-029 |
| CN-021 | FR-030 |

All 21 CNs are covered by at least one FR.
