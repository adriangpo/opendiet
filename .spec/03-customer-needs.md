# Customer Needs (CN): OpenDiet

**Version:** 1.0 | **Created:** 2026-06-19 | **Domain:** WHAT
**Input:** `01-customer-problems.md`, `02-software-glance.md`

> Notation: `[Noun] [verb] OpenDiet to [Object] [Condition]`. One outcome class per CN.

## Summary

| Outcome Class | CNs |
|---------------|-----|
| Information | CN-007, CN-014, CN-015, CN-017, CN-019, CN-020 |
| Control | CN-001, CN-016 |
| Construction | CN-002, CN-003, CN-004, CN-005, CN-006, CN-008, CN-009, CN-010, CN-011, CN-012, CN-013, CN-018, CN-021 |
| Entertainment | (none) |

---

**CN-001** — The user needs OpenDiet to keep all dietary data stored only on the device, transmitting nothing except requests the user explicitly initiates against Open Food Facts.
- Outcome Class: Control
- Traces to: CP-001

**CN-002** — The user needs OpenDiet to record diary entries and show daily totals at any time, including with no network connection, using on-device data.
- Outcome Class: Construction
- Traces to: CP-002

**CN-003** — The user needs OpenDiet to generate a complete backup file containing the entire dataset.
- Outcome Class: Construction
- Traces to: CP-003

**CN-004** — The user needs OpenDiet to restore the entire dataset from a previously generated backup file.
- Outcome Class: Construction
- Traces to: CP-003

**CN-005** — The user needs OpenDiet to provide the means to log food and track nutrition fully, with no payment required and no advertising.
- Outcome Class: Construction
- Traces to: CP-004

**CN-006** — The user needs OpenDiet to create custom foods with full nutrition-label fields and micronutrient values.
- Outcome Class: Construction
- Traces to: CP-005

**CN-007** — The user needs OpenDiet to obtain nutrition data for packaged foods by searching Open Food Facts and by scanning a product barcode.
- Outcome Class: Information
- Traces to: CP-005

**CN-008** — The user needs OpenDiet to contribute new or corrected products to Open Food Facts using the user's own account.
- Outcome Class: Construction
- Traces to: CP-005

**CN-009** — The user needs OpenDiet to import foods from a user-provided CSV file, mapping the file's columns to OpenDiet's fields when they do not already match.
- Outcome Class: Construction
- Traces to: CP-006

**CN-010** — The user needs OpenDiet to create recipes from foods with a defined yield and automatically computed per-serving nutrition.
- Outcome Class: Construction
- Traces to: CP-007

**CN-011** — The user needs OpenDiet to log a recipe into the diary by the number of servings consumed.
- Outcome Class: Construction
- Traces to: CP-007

**CN-012** — The user needs OpenDiet to log foods rapidly using recently logged items, favorites, search history, and by copying a previous day or meal.
- Outcome Class: Construction
- Traces to: CP-008

**CN-013** — The user needs OpenDiet to organize the diary into fully customizable meal slots, with an optional default template.
- Outcome Class: Construction
- Traces to: CP-008

**CN-014** — The user needs OpenDiet to be reminded to log at configurable mealtimes.
- Outcome Class: Information
- Traces to: CP-009

**CN-015** — The user needs OpenDiet to know accurate daily nutrient totals compared against a target the user sets.
- Outcome Class: Information
- Traces to: CP-010

**CN-016** — The user needs OpenDiet to maintain the integrity of the local store so that data is never silently lost or corrupted.
- Outcome Class: Control
- Traces to: CP-010

**CN-017** — The user needs OpenDiet to accept and display food amounts in the user's chosen unit system (metric or imperial).
- Outcome Class: Information
- Traces to: CP-011

**CN-018** — The user needs OpenDiet to create and enter custom foods using the full ANVISA nutrient set (including added sugars and trans fat), with a serving size and household measure.
- Outcome Class: Construction
- Traces to: CP-012

**CN-019** — The user needs OpenDiet to present any food or recipe as the ANVISA nutrition table (per 100 g/ml and per serving, with a %VD column computed from a region-appropriate reference set).
- Outcome Class: Information
- Traces to: CP-012

**CN-020** — The user needs OpenDiet to present the interface in Brazilian Portuguese with local number formatting, defaulted from the device language and overridable.
- Outcome Class: Information
- Traces to: CP-013

**CN-021** — The user needs OpenDiet to import Brazilian foods from a TACO-format file (the user's own copy) into the catalog.
- Outcome Class: Construction
- Traces to: CP-005
