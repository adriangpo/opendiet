# NFR-011: Regulatory Accuracy

## Requirement

**ID:** NFR-011
**Title:** Regulatory Accuracy of Nutrient Set and %VD
**Category:** Reliability
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall keep the ANVISA mandatory nutrient set and each %VD reference set faithful to their source regulations, holding each as a single test-verified table that cites its source rather than restating values ad hoc.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-019 | Present the ANVISA table with correct %VD |
| Applies To FRs | FR-025, FR-026, FR-027 | Nutrient model, table view, %VD reference sets |

## Measurement Criteria

- **Target:** Nutrient set and each reference set match their cited regulation exactly.
- **Minimum Acceptable:** No incorrect mandatory nutrient or reference value ships.
- **Measurement Method:** Tests assert each reference table against values quoted (with citation) from the regulation.

## Acceptance Criteria

- [ ] The ANVISA mandatory nutrient list matches IN 75/2020.
- [ ] Each %VD reference set (Brazil/US/EU) is verified by a test citing its source.
- [ ] Reference values live in one place; they are not duplicated in prose or comments.

## Implementation Notes

<!-- See agent_docs/brazilian_nutrition.md for sources. Honors the AGENTS.md "never restate an external contract" rule. -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
