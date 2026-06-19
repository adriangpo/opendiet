# Business Context: OpenDiet

**Version:** 1.0 | **Created:** 2026-06-19 | **Last Updated:** 2026-06-19

## Project Identity

| Field | Value |
|-------|-------|
| **Project Name** | OpenDiet |
| **Business Domain** | Personal health / nutrition tracking (consumer mobile app) |
| **Purpose** | Give privacy-conscious individuals full control over diet tracking and meal data on their own device, without surrendering it to a cloud service. |
| **Inception Date** | 2026-06 |

## Business Principles

### BP-001: Local-First, Privacy by Default

**Statement:** All user data is stored on the user's device. No account is required to use the app, and no user data leaves the device except network requests the user explicitly initiates against Open Food Facts.
**Class:** Mandatory
**Rationale:** Privacy is the product. The whole reason to choose OpenDiet over commercial trackers is that the user, not a vendor, owns their dietary data.

### BP-002: Works Offline

**Statement:** Core logging (custom foods, recipes, previously-saved foods, diary, totals) must function with no network connection. Only fresh Open Food Facts lookups require connectivity.
**Class:** Mandatory
**Rationale:** People log meals anywhere, including with no signal. A tracker that needs the network to record lunch will not be used.

### BP-003: User Owns and Can Move Their Data

**Statement:** The user can export their entire dataset to an open file format and re-import it, with full round-trip fidelity.
**Class:** Mandatory
**Rationale:** Local-first without export is a trap, not ownership. Data must survive device loss and migration.

### BP-004: Build on Open Data and Open Formats

**Statement:** Prefer open food data (Open Food Facts) and open interchange formats (CSV import, JSON backup) over proprietary databases or lock-in.
**Class:** Guiding
**Rationale:** Aligns with the open ethos of the project and avoids dependence on closed, paywalled food databases.

### BP-005: Correctness over Speed of Delivery

**Statement:** Every change is delivered test-first (TDD) under a strict analyzer; nutrition math and data integrity are verified by tests before code ships.
**Class:** Mandatory
**Rationale:** A tracker that miscounts calories or corrupts the local store is worthless and, with no cloud backup, the damage is unrecoverable. Engineering conventions are recorded in `AGENTS.md`.

## Stakeholders

| Role | Name/Group | Interest | Influence |
|------|------------|----------|-----------|
| Sponsor / Owner | Project owner (solo, open-source) | Ship a usable, private diet tracker | Decision |
| User | Privacy-conscious individuals tracking diet and planning meals | Fast logging, accurate nutrition, data ownership | Input |
| Data Provider | Open Food Facts community + API | Accurate crowd-sourced food data; contributions back | Constraints (external) |
| Development | Solo developer + AI assistant | Feasibility, maintainability, clarity | Technical Input |

## Current Situation

### Current Process
Individuals who track diet today use commercial calorie trackers (e.g. MyFitnessPal and similar) that require an account and an internet connection, or fall back to manual spreadsheets. Custom foods and home recipes are entered ad hoc and rarely portable.

### Pain Points
- Commercial trackers require accounts and harvest personal dietary data; privacy is poor.
- Core features (macros, custom foods, scanning) are increasingly paywalled and ad-laden.
- Food databases are closed; users cannot import their own data or trust coverage.
- No easy way to bring an existing food list (e.g. a CSV) into the app.
- Home recipes are hard to model, so per-serving nutrition is guessed.
- Data is locked to the vendor; leaving means losing history.

### Existing Systems
- Open Food Facts — open, barcode-indexed food database and API (intended data source).
- Commercial calorie trackers — the incumbents OpenDiet competes with.
- Spreadsheets / notes — the low-tech fallback users resort to.

### What Works Well
- Open Food Facts offers a large, open, barcode-indexed dataset with an official Dart SDK.
- Barcode-scan-to-log is a familiar, fast interaction users already expect.

## Domain Boundaries

### In Scope (v1)
- Daily food diary with fully user-customizable meals.
- Food sources: Open Food Facts search, barcode scanning, CSV import (flexible header mapping), user-created custom foods.
- Recipes (ingredients + yield, auto per-serving nutrition).
- Universal ANVISA nutrition table: the ten mandatory nutrients (including added sugars and trans fat) plus micronutrients, shown per 100 g/ml and per serving with a %VD column (reference set selectable by region).
- Daily nutrient totals with a simple user-entered target.
- Configurable meal-time reminders (local notifications).
- Full backup export and import.
- Quick-entry helpers: recently logged, favorites, copy a previous day/meal, search history.
- Metric and imperial units (canonical metric storage).
- Brazilian Portuguese localization (pt-BR), language defaulted from device, overridable.
- TACO (Brazilian food composition table) import via the CSV importer (user's own copy; not bundled).
- Single local user profile.
- Platforms: iOS and Android.

### Out of Scope (v1)
- Cloud accounts or cloud sync (beyond the user's own Open Food Facts account).
- Medical, clinical, or therapeutic advice; OpenDiet is not a medical device.
- Social / sharing / community features.
- Web and desktop builds.

### Adjacent Systems
- Open Food Facts API — external source of truth for product/nutrition data; supports per-user authenticated contributions.

### Future Considerations (v2+)
- Meal planning across days/weeks and shopping-list generation.
- Goals engine: BMR/TDEE calculator and computed targets.
- Weight and body-metric tracking with progress charts and streaks.
- Multiple profiles per device.
- Micronutrient goals.

## Constraints

| Category | Constraint | Impact |
|----------|-----------|--------|
| Technical (decided) | Flutter/Dart, iOS + Android only; on-device DB (Drift); Riverpod; freezed/json_serializable; go_router; official `openfoodfacts` SDK; very_good_analysis; build_runner codegen | Fixes the implementation platform and data layer; recorded in `AGENTS.md` |
| Technical (external) | Open Food Facts data is crowd-sourced, frequently incomplete, and its API availability/limits are outside our control | App must treat OFF fields as optional and handle offline/timeout/missing data as normal |
| Organizational | Solo developer plus AI assistant | Limited capacity forces a tightly-scoped v1 and deferral of planning/goals |
| Financial | Open-source, effectively no budget | No paid backend/cloud services; reinforces local-first |
| Regulatory / Privacy | Handles personal dietary data; not a medical device | No health claims; local-only storage keeps the privacy surface minimal |
| Regulatory (Brazil) | Nutrition labelling follows ANVISA RDC 429/2020 + IN 75/2020 (mandatory nutrients, %VD reference values) | Defines the nutrient set and %VD; the regulation is the source of truth, not restated in code |
| Licensing (food data) | TACO and TBCA are restricted-use licensed | Must not be bundled or redistributed; Brazilian foods enter only via the user importing their own copy |
| Engineering | TDD mandatory, strict analyzer, pinned dependencies, committed lockfile | Governs how all requirements are built; detailed in `AGENTS.md` |

## Success Criteria

| ID | Criterion | Measure | Target |
|----|-----------|---------|--------|
| SC-01 | Core logging works offline | Share of v1 logging flows usable with the network disabled (custom/saved foods, recipes, diary, totals) | 100% |
| SC-02 | Data is portable | Export then import on a fresh install restores the dataset | 100% round-trip fidelity |
| SC-03 | Arbitrary CSV food lists can be imported | Import a food CSV whose headers do not match canonical names, via a mapping step | Supported with user confirmation |
| SC-04 | Privacy is preserved | Network destinations contacted by the app other than user-initiated Open Food Facts calls | 0 (no telemetry/analytics endpoints) |
| SC-05 | Nutrition is trustworthy | Diary/recipe nutrient math covered by passing automated tests before release | 100% of nutrition math under test |
| SC-06 | Brazilian foods are usable | Import a TACO-format file and log a Brazilian food shown in the full ANVISA table | Supported end to end |
| SC-07 | Usable in Portuguese | User-facing strings available in pt-BR with local formatting when selected | No untranslated user-facing strings |
