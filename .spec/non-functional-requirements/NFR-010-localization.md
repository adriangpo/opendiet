# NFR-010: Localization Completeness

## Requirement

**ID:** NFR-010
**Title:** Localization Completeness
**Category:** Usability
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall, when pt-BR is selected, render every user-facing string in Brazilian Portuguese with no untranslated leakage, and format numbers and units per pt-BR conventions.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-020 | Use the app in Brazilian Portuguese |
| Applies To FRs | FR-029 | Brazilian Portuguese localization |

## Measurement Criteria

- **Target:** 0 untranslated user-facing strings in pt-BR; numbers/units formatted per pt-BR.
- **Minimum Acceptable:** 0 untranslated strings (no English leakage in pt-BR mode).
- **Measurement Method:** ARB key-coverage check (no missing pt-BR keys) plus a UI pass in pt-BR.

## Acceptance Criteria

- [ ] Every localization key present in the base locale is present in pt-BR.
- [ ] No hardcoded user-facing strings bypass localization.
- [ ] pt-BR uses the comma decimal separator and local unit display.

## Implementation Notes

<!-- A test asserts ARB key parity across locales. -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
