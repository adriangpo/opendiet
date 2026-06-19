# NFR-009: Engineering Quality Gate

## Requirement

**ID:** NFR-009
**Title:** Engineering Quality Gate
**Category:** Maintainability
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall be built such that every change ships test-first under a strict analyzer with all tests passing before it is pushed.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-016 | Maintain integrity and trustworthy numbers |
| Business Success Criterion | SC-05 | Nutrition math under test |
| Applies To FRs | FR-004, FR-016, FR-023 | Nutrition math and integrity (and all FRs generally) |

## Measurement Criteria

- **Target:** 100% of changes have a failing-test-first record; formatter, analyzer, and tests all green pre-push.
- **Minimum Acceptable:** No change merges with a failing analyzer or failing tests.
- **Measurement Method:** CI required checks (format + analyze + test) and the pre-push gate defined in `AGENTS.md`.

## Acceptance Criteria

- [ ] Nutrition computations (totals, recipe scaling, unit conversion) are covered by passing tests.
- [ ] CI fails any change that does not pass format, analyze, and test.

## Implementation Notes

<!-- Conventions and the pre-push gate are defined in AGENTS.md. -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
