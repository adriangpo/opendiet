# FR-031: Quick-Add Food

## Requirement

**ID:** FR-031
**Title:** Quick-Add Food
**Priority:** Should Have
**Status:** Draft

### Statement

OpenDiet shall let the user log an ad-hoc food directly into a meal by entering only a name and an energy value (with other nutrients optional), without first saving the food to the catalog; and shall let the user afterwards promote that logged entry into a saved custom food, completing the remaining fields.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-012 | Log foods rapidly with minimal friction |
| Customer Problem | CP-008 | The user expects low-friction daily logging |
| Related | FR-008 | Promotion produces a custom food via the food editor |
| Related | FR-025 | A promoted draft carries over the entered ANVISA nutrients |

## Acceptance Criteria

- [ ] The user can add a diary entry to a chosen meal by entering just a name and energy (kcal); other nutrients are optional.
- [ ] A quick-added entry is **not** written to the foods catalog; only the diary entry is stored, carrying its own name and nutrient snapshot.
- [ ] A quick-added entry contributes to the day's totals like any other entry (FR-004).
- [ ] From a quick-added entry the user can choose "Save as food", which opens the custom-food editor (FR-008/FR-028) prefilled with the entered name and nutrients so the remaining fields can be completed before saving.
- [ ] Promotion that the user cancels leaves the original diary entry unchanged and adds nothing to the catalog.

## Implementation Notes

<!-- Modelled by a diary entry with reference kind "quick add" and no catalog
reference; the entry already snapshots its label and nutrients, so it is
self-contained. Promotion builds a draft custom food from that snapshot. -->

## Test Cases

<!-- QA adds test case references here -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
*Author: Problem-Based SRS*
