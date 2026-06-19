# NFR-001: Privacy

## Requirement

**ID:** NFR-001
**Title:** Privacy — No Unbidden Network Traffic
**Category:** Security
**Priority:** Must Have
**Status:** Draft

### Statement

OpenDiet shall contact no network destination other than Open Food Facts requests the user explicitly initiates, exposing zero telemetry or analytics endpoints.

## Traceability

| Traces To | ID | Description |
|-----------|-----|-------------|
| Customer Need | CN-001 | Keep all dietary data stored only on the device |
| Applies To FRs | FR-001, FR-009, FR-010, FR-011, FR-012 | Persistence and Open Food Facts access |

## Measurement Criteria

- **Target:** 0 network destinations besides user-initiated Open Food Facts calls.
- **Minimum Acceptable:** 0 (no tolerance).
- **Measurement Method:** Network capture during a full feature pass; static audit of dependencies for analytics SDKs.

## Acceptance Criteria

- [ ] A network trace over all v1 flows shows only user-initiated Open Food Facts traffic.
- [ ] No analytics, crash-telemetry, or advertising endpoint is contacted.

## Implementation Notes

<!-- Engineers add notes here during implementation -->

---
*Created: 2026-06-19*
*Last Updated: 2026-06-19*
