# NFR-007: Ad- and Paywall-Free

## Requirement

**ID:** NFR-007
**Title:** Ad- and Paywall-Free
**Category:** Usability
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall contain zero advertising SDKs and zero paid feature gates.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-005 | Provide the means to track fully, with no payment or ads |
| Applies To FRs | FR-007 | Ungated access |

## Measurement Criteria

- **Target:** 0 advertising SDKs; 0 features gated behind payment.
- **Minimum Acceptable:** 0 (no tolerance).
- **Measurement Method:** Dependency audit for ad/IAP SDKs; functional review that no feature requires payment.

## Acceptance Criteria

- [ ] No advertising dependency is present in the build.
- [ ] No in-app purchase or subscription gates any v1 feature.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
