# Dependency Decisions

Why the dependency set looks the way it does. Update this when the matched set changes
(AGENTS.md "institutional memory" guardrail). Toolchain: **Flutter 3.44.2 / Dart 3.12.2**.

## Codegen cluster (build-time)
`build_runner`, `drift_dev`, `riverpod_generator`, `freezed`, `json_serializable`.
Re-run after changing Drift tables, freezed models, or `@riverpod` providers:
`dart run build_runner build --delete-conflicting-outputs`. Commit the generated
`*.g.dart` / `*.freezed.dart`; they are excluded from the analyzer, not gitignored.

## build.yaml — `explicit_to_json: true`
`json_serializable` is configured (in `build.yaml`) with `explicit_to_json: true`
so a model's `toJson` calls nested models' own `toJson` (e.g. `Food.nutrients`,
`Recipe.ingredients`) instead of leaving live objects in the map. Without it,
`fromJson(toJson())` round-trips fail at runtime. Backup fidelity (NFR-003)
depends on these round-trips, so the option is load-bearing, not cosmetic.

## freezed is pinned to a prerelease (3.2.6-dev.1) — intentional
Flutter 3.44.2 bundles **analyzer 12.x**. Stable `freezed 3.2.5` supports only
`analyzer >=9 <11`, so no stable freezed resolves on this Flutter; the dev release is the
only one built for analyzer 12. freezed is a **build-time-only codegen tool** — it never
ships in the app binary and its output is deterministic and committed, so the usual
"avoid prereleases" guardrail (which protects shipped code) does not really apply here.
Pinned **exactly** (`freezed: 3.2.6-dev.1`). Revisit and move to stable once freezed ships
for analyzer 12.

## riverpod_lint + custom_lint are intentionally NOT included
Their latest stable releases require mutually exclusive analyzer ranges
(`riverpod_lint 3.1.4` -> analyzer ^12, `custom_lint 0.8.1` -> analyzer ^8,
`freezed 3.2.5` -> analyzer 9-10). No analyzer version satisfies all of them at once, so
the Riverpod lint plugins cannot be added in stable form on any Flutter right now. Linting
is covered by `very_good_analysis` + the strict analyzer modes. Add `riverpod_lint`/
`custom_lint` back once the ecosystem realigns on a single analyzer major.

## win32 dependency_override
`share_plus 13.x` needs `win32 ^6`; `file_picker 8-11` declares `win32 ^5`. Without
intervention pub silently drops `file_picker` to **3.0.4** (years old). `win32` is a
**Windows-only** plugin and we target **iOS + Android only**, so we override `win32: ^6.0.1`
to let both libraries use current versions. Harmless here; revisit if Windows is ever a
target (file_picker's Windows code would then need a win32-6-compatible release).

## Pinning & lockfile
This is an app: **commit `pubspec.lock`**. Verify latest stable before bumping (AGENTS.md).
Bump the codegen cluster as a unit (range -> resolve -> freeze), never one across a major alone.
