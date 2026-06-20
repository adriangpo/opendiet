# Traceability Matrix: OpenDiet

**Version:** 1.0 | **Created:** 2026-06-19
**Chain:** CP (WHY) → CN (WHAT) → FR/NFR (HOW)

## CP → CN → FR

| CP | CN | FR |
|----|----|----|
| CP-001 Privacy | CN-001 | FR-001 |
| CP-002 Offline logging | CN-002 | FR-002, FR-003, FR-004 |
| CP-003 Device loss / migration | CN-003 | FR-005 |
| CP-003 Device loss / migration | CN-004 | FR-006 |
| CP-004 No paywall / ads | CN-005 | FR-007 |
| CP-005 Log real foods | CN-006 | FR-008 |
| CP-005 Log real foods | CN-007 | FR-009, FR-010, FR-011 |
| CP-005 Log real foods | CN-008 | FR-012 |
| CP-006 Import existing data | CN-009 | FR-013, FR-014 |
| CP-007 Recipe nutrition | CN-010 | FR-015, FR-016 |
| CP-007 Recipe nutrition | CN-011 | FR-017 |
| CP-008 Low-friction logging | CN-012 | FR-018, FR-031 |
| CP-008 Low-friction logging | CN-013 | FR-019 |
| CP-009 Remembering to log | CN-014 | FR-020, FR-021 |
| CP-010 Trust / integrity | CN-015 | FR-004, FR-022 |
| CP-010 Trust / integrity | CN-016 | FR-023 |
| CP-011 Familiar units | CN-017 | FR-024 |
| CP-012 ANVISA format | CN-018 | FR-025, FR-028 |
| CP-012 ANVISA format | CN-019 | FR-025, FR-026, FR-027 |
| CP-013 Portuguese | CN-020 | FR-029 |
| CP-005 Log real foods | CN-021 | FR-030 (TACO) |

## NFR → CN

| NFR | Category | Traces to CN | Applies to FRs |
|-----|----------|--------------|----------------|
| NFR-001 Privacy | Security | CN-001 | FR-001, FR-009..012 |
| NFR-002 Offline coverage | Reliability | CN-002 | FR-002, FR-003, FR-004, FR-008, FR-015..019, FR-022, FR-024 |
| NFR-003 Backup fidelity | Reliability | CN-003, CN-004 | FR-005, FR-006 |
| NFR-004 Data durability | Reliability | CN-016 | FR-001, FR-023 |
| NFR-005 Local responsiveness | Performance | CN-002, CN-012 | FR-002, FR-003, FR-004, FR-018 |
| NFR-006 OFF resilience | Reliability | CN-007 | FR-009..012 |
| NFR-007 Ad/paywall-free | Usability | CN-005 | FR-007 |
| NFR-008 Credential security | Security | CN-008 | FR-012 |
| NFR-009 Quality gate | Maintainability | CN-016 / SC-05 | FR-004, FR-016, FR-023 (and all) |
| NFR-010 Localization | Usability | CN-020 | FR-029 |
| NFR-011 Regulatory accuracy | Reliability | CN-019 | FR-025, FR-026, FR-027 |

## Coverage summary

- **Customer Problems:** 13 (CP-001..CP-013) — all mapped to ≥1 CN.
- **Customer Needs:** 21 (CN-001..CN-021) — all mapped to ≥1 FR.
- **Functional Requirements:** 30 (FR-001..FR-030) — all trace to a CN.
- **Non-Functional Requirements:** 11 (NFR-001..NFR-011) — all trace to a CN/SC.
- **Orphans:** none. **Uncovered CPs/CNs:** none.
