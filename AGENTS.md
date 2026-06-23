# OpenDiet

WHAT: Flutter (Dart) app for iOS + Android. Local-first — all user data on-device. Stack: Drift (on-device DB), Riverpod (code-gen) for state, freezed + json_serializable for models, go_router for navigation, official `openfoodfacts` SDK, very_good_analysis lints, build_runner for codegen (Flutter 3.44.2, Dart 3.12.2).
WHY: Privacy-first diet tracker — log food and track calories/macros/micronutrients against a target the user sets. Your data stays on your device. (Meal planning, shopping lists, and a goals/BMR engine are v2 — see `.spec/`.)

Food/nutrition data comes from three sources: **Open Food Facts** (each user signs in with their own OFF account), an **imported CSV** (flexible header mapping), and **user-created foods and recipes**. The diary, foods, and recipes are all persisted locally.

## Source-of-truth docs (read the relevant one before working)
- **Product spec:** `.spec/` — the Problem-Based SRS (business context, problems, needs, vision, and FR/NFR with full traceability). Start at `.spec/04-software-vision.md` and `.spec/functional-requirements/_index.md`. Build to the requirements; do not invent behaviour not traced there.
- **UI design:** `.spec/design/ui/` — navigation map, route table, design system, and per-screen wireframes (each screen traced to FRs). Start at `.spec/design/ui/_index.md`.
- **Open Food Facts API** — https://openfoodfacts.github.io/openfoodfacts-server/api/ — the contract for searching/fetching food data and per-user authentication. Follow it; do not invent fields or restate its limits/values here.
- **CSV import field contract** — `agent_docs/csv_import.md` — canonical food fields and the smart header-mapping rules.
- **Brazilian nutrition (ANVISA / TACO / i18n)** — `agent_docs/brazilian_nutrition.md` — mandatory nutrients, %VD source-of-truth, TACO licensing, localization model.
- **ANVISA labelling** — ANVISA RDC 429/2020 + IN 75/2020 — source of truth for the nutrient set and %VD reference values; never restate the values in code.

## Workflow — TDD is mandatory
Order for **every** change: **tests -> docs -> code.**
1. Write a failing test that defines the expected behaviour; run it and confirm it FAILS (red).
2. Update docs to match the intended behaviour — including this `AGENTS.md`, `.spec/`, or `agent_docs/` whenever a convention or contract changes.
3. Write the minimal code to make the test pass; run it and confirm it PASSES (green). Refactor while green.

Writing code before a failing test, or tests and code together without seeing red, is **not** TDD — call it out. The test is the spec.

Keep the test loop targeted while developing: run the new or affected test once to prove red, then the same targeted test(s) to prove green. Let the pre-push hook be the single full local `tool/flutter_safe test` gate before pushing; it can skip the expensive gate only when the exact current Git tree already passed locally, which covers commit-message-only pushes. Do not manually run a full suite immediately before `git push` unless the change is broad/risky, conflict-heavy, or you are not pushing.

**Edge cases are mandatory — one happy-path test is never enough.** For each unit/flow cover, and only stop when each is tested or justified N/A: **happy path + boundaries** (zero, one, max, empty, exactly-at-limit); **invalid input** (wrong type, missing/null, malformed — e.g. a malformed CSV row, an OFF product with missing nutriment fields); **failure modes** (OFF request timeout/offline, empty search result); **state-dependent** behaviour; **lists** (first/last/empty/single, pagination, ordering). Then ask **"what did I miss?"**

## Commands
- Run Flutter through `tool/flutter_safe` in agent/worktree sessions; it clears Git worktree variables and serializes Flutter SDK cache access so parallel agents do not poison `bin/cache/flutter.version.json`.
- Install: `tool/flutter_safe pub get` (if Flutter reports SDK version `0.0.0-unknown`, check the Flutter SDK cache and rerun through the wrapper).
- Codegen: `tool/dart_safe run build_runner build --delete-conflicting-outputs` (watch: `tool/dart_safe run build_runner watch --delete-conflicting-outputs`). Drift, Riverpod, freezed, and json_serializable all generate.
- Run: `tool/flutter_safe run`
- Test: `tool/flutter_safe test`   single: `tool/flutter_safe test test/path_test.dart --plain-name "<name>"`
- Analyze: `tool/flutter_safe analyze`   Format: `tool/dart_safe format .`
- **Done = a failing test was written first, docs updated, then codegen current + `tool/dart_safe format .` clean + `tool/flutter_safe analyze` clean + `tool/flutter_safe test` green.** Never leave generated output stale.
- **Pre-commit hook**: `tool/dart_safe format .` + `tool/flutter_safe analyze` -- runs before every commit (`.githooks/pre-commit`). Auto-formats in place and stages formatting fixes; skips tests for speed. Pre-push covers the full gate.
- **Pre-push gate (hard)**: `tool/dart_safe format --set-exit-if-changed .` + `tool/flutter_safe analyze` + `tool/flutter_safe test` must all pass before pushing (`.githooks/pre-push`). The hook records the passing Git tree and can skip the expensive gate when a later push has the same tree, such as after amending only the commit message. If a check can't run, say so — never claim it passed.

## Structure
Feature-first: `lib/features/<feature>/{data,domain,presentation}` with shared code in `lib/core/`.
- `lib/features/<feature>/domain/` — entities (freezed), use cases, repository **interfaces**; no Flutter/data-source imports.
- `lib/features/<feature>/data/` — repository implementations (Drift, OFF SDK, CSV importer, backup, notifications).
- `lib/features/<feature>/presentation/` — widgets + Riverpod providers + go_router routes.
- `lib/core/` — cross-feature shared code. `test/` mirrors `lib/`.
- Food data sources (Open Food Facts, CSV import, user-created) sit behind repository interfaces — the rest of the app depends on the interface, never on a concrete source.

## Conventions
<!-- Semantic + strictness rules. Pure formatting is the analyzer/`dart format`'s job, not this file's. -->
- **Strict analyzer**: include `package:very_good_analysis` and enable `strict-casts`, `strict-inference`, `strict-raw-types` in `analysis_options.yaml`; treat analyzer issues as build-breaking. Exclude generated files (`*.g.dart`, `*.freezed.dart`).
- **Explicit types — no `dynamic`/implicit-any**; declare return types (`always_declare_return_types`, `avoid_dynamic_calls`). Model value sets (meal type, measurement unit, OFF nutriment keys) as enums, not magic strings.
- **Validate at runtime, not with `assert`** — Flutter strips asserts in release builds, so any precondition that can fail in production (parsed CSV input, OFF responses, user input) must be guarded by an explicit check that throws. Reserve `assert` for debug-only developer invariants. <!-- OPINIONATED -->
- **Lint-ignores are line-level + justified** with a reason comment; never blanket `// ignore_for_file`.
- **`dart format` owns formatting** — no style rules in this file.
- **No abbreviations** in identifiers (`configuration`, not `config`); ecosystem names exempt. <!-- OPINIONATED -->
- **Imports at file top only**; resolve circular deps by restructuring.
- **Comments explain WHY, not WHAT**; code, comments, docs, and commit/PR text in English.
- **Never restate an external contract in comments/code**: do not hardcode Open Food Facts field meanings, limits, or values as prose. Describe client **intent** ("reads the energy-kcal nutriment off the response"), not the policy; read server numbers from the response, never copy them into a comment.
- **Inject a clock** (no raw `DateTime.now()`); use sortable IDs (UUIDv7) for locally-stored entities so diary/entry ordering is stable. <!-- OPINIONATED -->
- **Store canonical metric**; convert at the edges for display/entry (see FR-024). Never persist imperial values.
- **All user-facing strings via gen-l10n** — English is the base/template locale (`lib/l10n/app_en.arb`); pt-BR is a translation. No hardcoded UI strings; adding a language = adding an ARB. The brand name "OpenDiet" is a proper noun and is not translated.
- **ASCII-only** in tracked non-`.md` files and in commit/PR text (use `-`, `"`, `'`, `...`, `->`). **Exception:** user-facing string *values* in localization files (`lib/l10n/*.arb`) may use the target language's letters where the language requires them (accented vowels, `ç`, etc.) -- this covers letters only; typographic punctuation (em/en dashes, smart quotes, the ellipsis character, arrows) stays ASCII even there, and ARB keys/`@`-metadata stay ASCII. Tracked `.md` files exempt. <!-- OPINIONATED -->
- **No backticks in non-`.md` files** — they render as nothing. Exception: Dart `///` dartdoc comments (which render Markdown) and Dart string interpolation, both allowed. <!-- OPINIONATED -->
- **Commit messages follow the [Conventional Commits](https://www.conventionalcommits.org/) format**: `type(scope): description`. Types: `feat`, `fix`, `refactor`, `chore`, `test`, `docs`, `revert`. Branch commit messages and PR titles do NOT include `(#PR)`. Only the final squash-merge commit title, entered at merge time after the PR number exists, appends the PR number as the last element: `type(scope): description (#PR)`. Do not edit a PR title after publishing just to add its PR number. <!-- OPINIONATED -->
- **Branch prefix follows the work type.** Use `feature/` only when the branch is a feature; use another clear prefix such as `docs/`, `fix/`, `chore/`, or `test/` for non-feature work. Never use `feat/` as a branch prefix: commit messages use `feat:`, but feature branches spell the namespace out, for example `feature/quantity-field`. <!-- OPINIONATED -->

## Guardrails
- **Verify latest stable** before adding/upgrading any dependency — never trust versions from memory.
- **Pin dependencies and commit `pubspec.lock`** (this is an app). Bump a related cluster (the build_runner/codegen set) as a unit, never one package across a major alone; avoid prereleases.
- **Never commit secrets** — no OFF credentials, API keys, or `.env` in the repo; keep them gitignored. OFF credentials live in platform secure storage at runtime, never bundled (see NFR-008).
- **Privacy is a hard constraint** — the app contacts no network destination other than user-initiated Open Food Facts calls; never add analytics/telemetry/ad SDKs (NFR-001, NFR-007).
- **Commit completeness**: tests + docs + code land together; never commit code without its tests. Update this file / `.spec/` / `agent_docs` in the same change when a convention or contract drifts.
- **No AI attribution** in commits or PR bodies (no `Co-Authored-By: <model>`, no "Generated with" line); commit identity = the configured git user only. <!-- OPINIONATED -->
- **Subagent work**: give a detailed prompt, then verify the actual diff — not the summary.
- **No `TODO` without a linked issue.**
- **Enable hooks** with `git config core.hooksPath .githooks` (already set for this repo). Both `pre-commit` (lint) and `pre-push` (format + analyze + test) are enforced locally. Keep `tool/dart_safe` for Dart commands and `tool/flutter_safe` for Flutter commands in hooks; Flutter is itself a Git checkout, and leaked worktree variables or parallel cache writes can make Pub see the SDK as `0.0.0-unknown`.
- Do not invent Open Food Facts endpoints, fields, or values — confirm against its API docs first.
- **Never bundle or redistribute TACO/TBCA data** (restricted-use licence) — Brazilian foods enter only via the user's own imported file.
- **Never hardcode %VD reference values or the ANVISA nutrient set in prose/comments** — hold each in one test-verified table citing the regulation (`agent_docs/brazilian_nutrition.md`).

<important if="you are writing or modifying tests">
- Unit-test domain/repository logic with fakes; **widget-test** UI with `testWidgets`; reserve `integration_test/` for end-to-end flows.
- Never hit the live Open Food Facts API in tests — fake the repository or stub the HTTP client with recorded fixtures.
- Nutrition math (totals, recipe scaling, unit conversion) and CSV/backup round-trips must be covered — they are integrity-critical (NFR-003, NFR-004, NFR-009).
- Single test: `tool/flutter_safe test test/path_test.dart --plain-name "<name>"`.
</important>

<important if="you are integrating Open Food Facts (search, fetch, or auth)">
- Read the OFF API docs first (linked above). Authentication is **per-user** — the user supplies their own OFF account; never hardcode or share credentials.
- Model OFF nutriment keys and product fields as typed Dart enums/classes mirroring the spec; do not pass `dynamic` JSON around the app.
- Handle offline/timeout/missing-field as first-class outcomes; an OFF call must never block local logging (NFR-006).
</important>

<important if="you are importing CSV food data or registering user foods/recipes">
- Read `agent_docs/csv_import.md` first. Validate every row/field at runtime and reject malformed input per-row without aborting the import (FR-013, FR-014).
- Foods, recipes, and OFF products feed the same domain model via their repository — keep the conversion in the data layer, not in widgets.
</important>

<important if="you are building a screen, widget, or navigation flow">
- Read the relevant screen in `.spec/design/ui/` first; it defines the layout, components, states (empty/loading/error), and the FRs the screen satisfies.
- Use the shared components and semantic color roles from `.spec/design/ui/design-system.md`; do not hardcode colors or invent per-screen widgets.
- Every screen must specify all four states; local reads should render without a spinner (NFR-005), and OFF-dependent areas must stay offline-tolerant (NFR-006).
</important>

<important if="you are working on the nutrition table, %VD, or Brazilian Portuguese localization">
- Read `agent_docs/brazilian_nutrition.md` first. The ANVISA table is the universal format; only the %VD reference set varies by region, and language is a separate setting.
- Hold the ANVISA nutrient set and each %VD reference set in one test-verified table citing the regulation; never restate the values.
- Route every user-facing string through gen-l10n (English base ARB + pt-BR translation); the brand name "OpenDiet" is not translated.
- Never bundle TACO/TBCA data; Brazilian foods come from the user's own import (FR-030).
</important>

<important if="you change Drift tables, freezed models, or @riverpod providers">
- Re-run `tool/dart_safe run build_runner build --delete-conflicting-outputs`; commit the generated `*.g.dart` / `*.freezed.dart` alongside the source and keep them excluded from the analyzer.
- If codegen fails on analyzer/version conflicts, stop and reconcile the matched dependency set — do not "fix" it by upgrading random packages.
</important>

<important if="you write widget tests that use ProviderScope overrides">
- **Riverpod 3.x does NOT re-export `Override` from `flutter_riverpod`.** To use `Override` as a type, import `package:riverpod_annotation/riverpod_annotation.dart` (it reaches it via `package:riverpod/src/internals.dart` -> `framework.dart`'s `part` files). Same for `AsyncData` — it IS exported from `flutter_riverpod`'s barrel in 3.x.
- **Never override the same provider twice** in one `ProviderScope` — Riverpod 3.x asserts on it. Each test must override each provider exactly once. A shared `shellOverrides()` helper that returns `List<Override>` can't contain a provider that a test also overrides. Prefer empty helpers (`shellOverrides() => []`) and have each test provide its own full list.
- **Override ALL providers that touch the database** in every shell test. The initial tab (Diary) calls `mealSlotsProvider` which calls `mealSlotRepository` which calls `appDatabase` -> `driftDatabase`. If unoverridden, `driftDatabase` creates a real SQLite timer that persists beyond the test teardown, causing "A Timer is still pending" failures even when the assertion passes.
- **Avoid `CircularProgressIndicator` in loading states** if the screen is inside an `IndexedStack` (all shell branches build eagerly). Its infinite animation causes `pumpAndSettle` to time out. Use `SizedBox.shrink()` or a static placeholder instead, and call `pump()` twice (not `pumpAndSettle`) in the test helper to let `FutureProvider` microtasks resolve.
- **Two-pump pattern for tab-switch tests**: `await tester.pump()` (process navigation, build screen, `FutureProvider` starts) then `await tester.pump()` (microtask resolves, provider emits, screen rebuilds with data).
</important>
