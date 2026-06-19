# NFR-006: Open Food Facts Resilience

## Requirement

**ID:** NFR-006
**Title:** Open Food Facts Resilience
**Category:** Reliability
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall handle Open Food Facts calls so that they time out gracefully and never block local logging.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-007 | Obtain food data from Open Food Facts without compromising local use |
| Applies To FRs | FR-009, FR-010, FR-011, FR-012 | Open Food Facts access |

## Measurement Criteria

- **Target:** Every Open Food Facts call has a bounded timeout; the UI remains interactive throughout.
- **Minimum Acceptable:** No Open Food Facts failure prevents using local logging.
- **Measurement Method:** Tests simulating offline, slow, and error responses from Open Food Facts.

## Acceptance Criteria

- [ ] Slow or failed Open Food Facts responses surface a clear, dismissible message.
- [ ] Local logging remains fully usable while an Open Food Facts call is pending or failing.
- [ ] Missing or partial Open Food Facts fields are treated as normal, not as errors.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
