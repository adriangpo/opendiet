# Screens — Foods & Recipes (S-06..S-10)

Conventions and shared components are in `design-system.md`.

---

## S-06 Foods (catalog)  ·  tab  ·  FR-008, FR-009, FR-011

```
+-----------------------------------+
|  Foods                     [|||]  |   barcode shortcut -> S-03
|  [ Search your foods + OFF...  ]  |
|  ( Mine )( Saved from OFF )( All ) |
|-----------------------------------|
|  Oats              180/100g  [...]|   FoodListTile; [...] = menu
|  Banana             89/100g  [...]|
|  Greek yogurt      ...            |
|-----------------------------------|
|  [ Import CSV ]   [ + New food ]  |   -> S-11 / S-05
| [ Diary ][ Foods ][Recipes][Setts]|
+-----------------------------------+
```

- **Components:** search (local + OFF), source filter, `FoodListTile`, import + create actions.
- **Interactions:** tap -> S-07; row menu = log / favorite / edit / delete; deleting a saved food requires confirmation and removes the local catalog record without deleting existing diary snapshots; Import -> S-11; New -> S-05; OFF results can be saved locally (FR-011).
- **States:** *Empty* -> `EmptyState` ("Add your first food / import a CSV / search Open Food Facts"); OFF results loading/error isolated and offline-tolerant.

---

## S-07 Food Detail  ·  Foods  ·  FR-011, FR-012, FR-018, FR-026, FR-027

```
+-----------------------------------+
| <  Oats                  [fav][..]|
|-----------------------------------|
|  Brand: Generic    Source: OFF    |
|  Tabela Nutricional               |   NutritionTableBR (FR-026)
|              100g   porção   %VD   |   porção: medida caseira
|  Energia    380     95       5%   |
|  Carboidr.  60g     15g      5%   |
|   Açúc. tot 1g      0.3g     -    |
|   Açúc. adi 0g      0g       0%   |
|  Proteínas  13g     3.3g     7%   |
|  Gord. tot  7g      1.8g     2%   |
|   Saturadas 1.2g    0.3g     1%   |
|   Trans     0g      0g       --   |   trans: no %VD
|  Fibra      10g     2.5g    10%   |
|  Sódio      5mg     1mg      0%   |
|   + micronutrientes (expand)      |
|  %VD ref: Brasil (IN 75/2020) [v] |   region-selectable (FR-027)
|-----------------------------------|
|  [ Log this food ]                |   -> S-04
|  [ Edit ]  [ Suggest a correction]|   correction -> S-17 (FR-012)
+-----------------------------------+
```

- **Interactions:** Log -> S-04; Edit -> S-05 (local edits never alter the OFF source, FR-011); favorite toggle (FR-018); "Suggest a correction" routes to the OFF contribute flow when signed in (FR-012).
- **States:** *Local-only food* hides OFF source/correction; *Missing fields* shown as blank, not zero.

---

## S-08 Recipes (list)  ·  tab  ·  FR-015

```
+-----------------------------------+
|  Recipes                          |
|  [ Search recipes........... ]    |
|-----------------------------------|
|  Chicken curry     serves 4       |
|   520 kcal / serving              |
|  Overnight oats    serves 1       |
|   310 kcal / serving              |
|-----------------------------------|
|                            ( + )  |   FAB -> S-09
| [ Diary ][ Foods ][Recipes][Setts]|
+-----------------------------------+
```

- **Interactions:** tap -> S-10; FAB -> S-09 (new recipe).
- **States:** *Empty* -> `EmptyState` with "Create your first recipe".

---

## S-09 Recipe Editor  ·  Recipes  ·  FR-015, FR-016

```
+-----------------------------------+
| X  New recipe          [ Save ]   |
|-----------------------------------|
|  Name  [ ........................]|
|  Yield [ 4 ] servings             |
|-----------------------------------|
|  Ingredients                      |
|   Chicken breast   300 g     [x]  |   each = food + QuantityField
|   Onion            100 g     [x]  |
|   [ + Add ingredient ]            |   -> food picker (S-02 style)
|-----------------------------------|
|  Computed (auto):                 |
|   Total 2080 kcal  ->  520 /serv  |   live (FR-016)
+-----------------------------------+
```

- **Components:** name, yield, ingredient rows (`QuantityField` each), live total + per-serving panel.
- **Interactions:** add ingredient via the food picker; editing any ingredient/quantity/yield recomputes totals and per-serving instantly (FR-016).
- **States:** *Validation* -> at least one ingredient and yield >= 1; ingredient with missing nutrients handled without breaking totals (FR-016 acceptance).

---

## S-10 Recipe Detail  ·  Recipes  ·  FR-016, FR-017

```
+-----------------------------------+
| <  Chicken curry         [..]     |
|-----------------------------------|
|  Serves 4                         |
|  Per serving: 520 kcal            |
|   P 42  C 30  F 22 (+ micros)     |
|  Whole recipe: 2080 kcal          |
|-----------------------------------|
|  Ingredients (read-only list)     |
|-----------------------------------|
|  [ Log servings ]   [ Edit ]      |   Log -> S-04 (servings) FR-017
+-----------------------------------+
```

- **Interactions:** "Log servings" -> S-04 with a servings field (FR-017); Edit -> S-09.
- **States:** per-serving and whole-recipe nutrition stay consistent with the editor (FR-016).
