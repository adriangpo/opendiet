# FR-029: Brazilian Portuguese Localization

## Requirement

**ID:** FR-029
**Title:** Brazilian Portuguese Localization
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall present the interface in Brazilian Portuguese with pt-BR number and unit formatting, defaulted from the device language and overridable in settings, independently of the %VD reference region.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-020 | Use the app in Brazilian Portuguese with local formatting |
| Customer Problem | CP-013 | Brazilian users expect to use the app in Portuguese |

## Acceptance Criteria

- [ ] User-facing strings are authored in English as the base/template locale and translated to Brazilian Portuguese; v1 ships en and pt-BR only.
- [ ] Adding another language requires only adding a locale resource file (ARB) -- no code changes.
- [ ] Language defaults from the device language (falling back to English) and can be changed in settings.
- [ ] Numbers and units format per the selected language (e.g. comma decimal separator in pt-BR).
- [ ] Language selection is independent of the %VD reference region (FR-027).

## Implementation Notes

<!-- Flutter gen-l10n (ARB files). User-facing strings must go through localization, not hardcoded. -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
