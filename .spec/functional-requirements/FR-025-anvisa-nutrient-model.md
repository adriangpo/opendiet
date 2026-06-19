# FR-025: ANVISA Nutrient Model

## Requirement

**ID:** FR-025
**Title:** ANVISA Nutrient Model
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall store, for every food and recipe, the ten ANVISA-mandatory nutrients -- energy, total carbohydrates, total sugars, added sugars, protein, total fat, saturated fat, trans fat, dietary fiber, and sodium -- plus optional micronutrients.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-018 | Enter custom foods using the full ANVISA nutrient set |
| Customer Need | CN-019 | Present foods as the ANVISA nutrition table |
| Customer Problem | CP-012 | Brazilian users expect the ANVISA nutrition format |

## Acceptance Criteria

- [ ] The model holds all ten mandatory nutrients, with added sugars and trans fat as first-class fields.
- [ ] Any nutrient may be absent (blank) without being treated as zero.
- [ ] Micronutrients remain an open, optional set alongside the mandatory fields.
- [ ] The mandatory nutrient list matches ANVISA IN 75/2020 (sourced from `agent_docs/brazilian_nutrition.md`, not restated in code).

## Implementation Notes

<!-- Supersedes the earlier "full label + micros" model by adding added sugars + trans fat. -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
