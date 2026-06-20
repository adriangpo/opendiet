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

## file_picker removed; no win32 override (was: win32 ^6 override)
We initially added `file_picker ^11` and forced `win32: ^6.0.1` (so `share_plus 13.x`,
which needs `win32 ^6`, and `file_picker` could coexist). That override was **not**
harmless: `file_picker 11`'s Windows implementation (`file_picker_windows.dart`) is
compiled even for an **Android** build, and it targets the `win32 5.x` API
(`COINIT.*`, `COMObject`, positional `CoInitializeEx`), so it fails to compile against
`win32 6` -- breaking `flutter run` on a phone with a `kernel_snapshot` error.

`file_picker` is only needed for CSV import (FR-013) / backup file selection, which is
**not built yet**, so we removed it and the `win32` override. `win32` now resolves to 6
for `share_plus` (whose Windows code is properly conditionally compiled and does not
break the mobile build). When CSV import lands, re-add a file-picking dependency that is
compatible with `win32 6` (a newer `file_picker`, or an alternative), and verify a device
build before relying on it.

## Pinning & lockfile
This is an app: **commit `pubspec.lock`**. Verify latest stable before bumping (AGENTS.md).
Bump the codegen cluster as a unit (range -> resolve -> freeze), never one across a major alone.
