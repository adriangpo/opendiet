# Project Setup / Bootstrap

One-time steps to scaffold and configure OpenDiet. Most are run automatically the first time;
this file is the reproducible record (and the recovery path if the toolchain is reinstalled).

## Prerequisites
- Flutter (stable) on PATH; `flutter doctor` should pass for Android (iOS needs macOS).
- JDK 17+ for Android builds.

## 1. Scaffold the app (into this existing repo)
```
flutter create --org dev.opendiet --project-name opendiet --platforms android,ios .
```
After this, restore the project files that `flutter create` may overwrite:
- Keep this repo's `analysis_options.yaml` (very_good_analysis + strict-*), `.gitignore`, `.gitattributes`.

## 2. Add dependencies (pinned; commit `pubspec.lock`)
Runtime:
```
flutter pub add flutter_riverpod riverpod_annotation drift drift_flutter \
  path_provider path freezed_annotation json_annotation go_router openfoodfacts \
  mobile_scanner flutter_local_notifications flutter_secure_storage file_picker \
  share_plus csv uuid intl
```
Dev / codegen (the matched build_runner cluster):
```
flutter pub add --dev build_runner drift_dev riverpod_generator freezed \
  json_serializable mocktail very_good_analysis
flutter pub remove flutter_lints   # replaced by very_good_analysis
```

> **Deviations (see `agent_docs/dependencies.md` for the why):**
> - `riverpod_lint` / `custom_lint` are **omitted** — their stable releases need analyzer
>   ranges that don't overlap with stable freezed on Flutter 3.44.2.
> - `freezed` is pinned to the prerelease `3.2.6-dev.1` (build-time only; analyzer-12 lag).
> - `dependency_overrides: win32: ^6.0.1` lets `file_picker 11.x` and `share_plus 13.x`
>   coexist (win32 is Windows-only; we target iOS+Android).

## 3. Codegen
```
dart run build_runner build --delete-conflicting-outputs
```
Commit the generated `*.g.dart` / `*.freezed.dart` (they are excluded from the analyzer, not gitignored).

## 4. Feature-first layout
Create `lib/features/<feature>/{data,domain,presentation}` and `lib/core/` as features are built
(see `AGENTS.md` Structure and `.spec/design/ui/`).

## 5. Enable the local pre-push gate
```
git config core.hooksPath .githooks
```
Mirrors CI: `dart format` + `flutter analyze` + `flutter test`.

## 6. Verify
```
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

> Verify the latest stable of each dependency at add time (AGENTS.md guardrail) — do not trust
> the versions resolved on any particular day without checking.
