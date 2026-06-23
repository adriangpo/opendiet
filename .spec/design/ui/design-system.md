# OpenDiet Design System

**Version:** 1.0 | Material 3, light + dark following the system setting.

## Color

- **Brand seed:** `#0066CC` (Ocean blue).
- Palette is generated from the seed via Material 3 `ColorScheme.fromSeed` for both light and dark.
- Use **semantic color roles**, never hardcoded colors: `primary` (primary actions, FAB), `surface`/`surfaceContainer` (cards, sheets), `onSurfaceVariant` (secondary text), `error` (validation/destructive), `tertiary` (accents such as the over-target state).
- **Nutrient accents** (used consistently in charts/rings and totals): energy = primary; protein, carbs, fat = three fixed tonal roles defined once in the theme. Do not invent per-screen colors.
- Over-target values use `error`; on-target/remaining uses `primary`. Color is never the only signal (see Accessibility).

## Typography & shape

- **Typeface:** Inter (bundled as local asset — Regular 400, Medium 500, SemiBold 600, Bold 700).
- Material 3 type scale. Numbers in totals/targets use the tabular/`titleLarge`/`headlineSmall` roles for alignment.
- Default component shapes from Material 3 (rounded cards, full-width filled buttons). No custom radii unless added here.

## Spacing & layout

- 4 pt base grid; common steps 4 / 8 / 16 / 24. Screen padding 16. Card padding 16.
- Lists use Material `ListTile`; forms use a single scrolling column with 16 gutters.
- Touch targets >= 48 dp.

## Shared components

| Component | Use | Notes |
|-----------|-----|-------|
| `AppScaffold` | Tab screens | Hosts the bottom `NavigationBar` (Diary/Foods/Recipes/Settings). |
| `NutrientTotalsBar` | Diary, Recipe detail | Energy + macros vs target; ring or bar. Single source of formatting. |
| `FoodListTile` | Search, catalog, recents | Name, brand, per-amount energy; trailing add/favorite. |
| `QuantityField` | Quantity entry, recipe ingredients | Amount + unit toggle (servings vs g/ml); respects unit system (FR-024). |
| `NutrientForm` | Custom food, CSV mapping preview | The ten ANVISA nutrients (incl. added sugars, trans fat) + micronutrients; blanks allowed (FR-008, FR-028). |
| `NutritionTableBR` | Food/recipe detail | ANVISA table: per-100 g/ml + per-porção + %VD columns; trans fat shows no %VD (FR-026). |
| `EmptyState` | Any empty list | Icon (Boxicons, `package:flutter_boxicons`) + one-line explainer + primary action. |
| `ErrorBanner` | OFF/network/import errors | Dismissible, non-blocking; never blocks local actions (NFR-006). |

## State conventions (every data-backed screen specifies all four)

- **Loaded** — normal content.
- **Empty** — `EmptyState` with the relevant create/add action.
- **Loading** — skeleton/spinner; only OFF-dependent areas may show network loading. Local reads should be instant (NFR-005), so prefer no spinner for local data.
- **Error** — `ErrorBanner`; for OFF, the rest of the screen stays usable offline.

## Units (FR-024)

- Store canonical metric; the `QuantityField` and all displays format to the user's chosen system.
- Show the unit next to every amount; never display a bare number where a unit is expected.

## Accessibility

- Meet WCAG AA contrast in both themes (seed-generated roles satisfy this; verify the final seed).
- Color is never the sole signal — pair the over/under-target color with text or an icon.
- All actionable elements have semantic labels; the scanner and FAB have explicit labels for screen readers.
- Support system text scaling without clipping totals.

## Localization & nutrition format

- **Language** (pt-BR / en) routes through Flutter gen-l10n; English is the base/template locale, pt-BR a translation. No hardcoded user-facing strings. Default from device language; overridable in Settings. Brand name "OpenDiet" is not translated.
- **Nutrition is shown as the universal ANVISA table** everywhere (`NutritionTableBR`, FR-026) — per 100 g/ml + per-porção + %VD.
- **%VD reference set** (Brazil / US / EU) defaults from device region and is overridable in Settings — independent of language (FR-027).
- Numbers/units follow the selected language (comma decimal in pt-BR).

## Privacy in the UI (NFR-001, NFR-007)

- No account wall: the app is fully usable signed-out; the OFF account is only requested at the point of contributing (S-17).
- No ads, no telemetry/consent prompts, no "upgrade" surfaces anywhere.
