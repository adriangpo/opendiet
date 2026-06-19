# Screens — Diary & Logging (S-01..S-05)

The core loop. Conventions and shared components are in `design-system.md`.

---

## S-01 Diary (home)  ·  tab  ·  FR-002, FR-003, FR-004, FR-019, FR-022

```
+-----------------------------------+
| < Mon 19 Jun >            [today] |   date stepper; tap = date picker
|-----------------------------------|
|  Energy  1860 / 2000 kcal   [===-]|   NutrientTotalsBar vs target
|  P 96g   C 210g   F 70g           |
|-----------------------------------|
|  Breakfast                 320 kcal|   meal slot header (user-defined)
|   Oats, 1 bowl (250 g)      180    |   entry: tap=edit, swipe=delete
|   Banana, 1 medium          140    |
|   + Add to Breakfast              |
|-----------------------------------|
|  Lunch                     540 kcal|
|   ...                             |
|   + Add to Lunch                  |
|-----------------------------------|
|                            ( + )  |   FAB -> S-02 (Add/Log)
| [ Diary ][ Foods ][Recipes][Setts]|
+-----------------------------------+
```

- **Components:** date stepper, `NutrientTotalsBar`, per-slot sections (from FR-019 meal slots), entry rows, FAB.
- **Interactions:** tap entry -> S-04 (edit amount); swipe -> delete (undo snackbar); "+ Add to <slot>" -> S-02 with slot preselected; FAB -> S-02; date stepper changes day.
- **States:** *Empty* day -> per-slot "+ Add" plus an `EmptyState` hint; *No target set* -> show totals without the comparison bar (FR-022); *Loaded/Error* per conventions. Fully offline (NFR-002).

---

## S-02 Add / Log hub  ·  flow  ·  FR-003, FR-009, FR-011, FR-017, FR-018

```
+-----------------------------------+
| X  Add to Lunch                   |
|-----------------------------------|
| [ Search foods............ ] [|||]|   text field + barcode icon -> S-03
|-----------------------------------|
| ( Recent )( Favorites )( Foods )  |   chips/segments (FR-018)
| ( Recipes )( OFF results )        |
|-----------------------------------|
|  Oats                  180/100g  +|   FoodListTile; + = quick log
|  Banana                 89/100g  +|
|  Chicken breast recipe   ...     +|
|-----------------------------------|
|  [ + Create custom food ]         |   -> S-05
+-----------------------------------+
```

- **Components:** search field with barcode action, source segments (Recent / Favorites / Foods / Recipes / OFF results), `FoodListTile` list, create-custom action.
- **Interactions:** typing searches local first, OFF on submit (FR-009); barcode icon -> S-03; tapping a row -> S-04 (set amount); `+` quick-logs a default amount; recipes log via servings (FR-017).
- **States:** *Recent/Favorites* default before typing (FR-018); *OFF results Loading/Error* are isolated and offline-tolerant (NFR-006) while local results remain; *Empty search* -> offer create custom or contribute.

---

## S-03 Barcode Scanner  ·  flow  ·  FR-010

```
+-----------------------------------+
| X                          [flash]|
|        +-----------------+        |
|        |                 |        |   live camera preview
|        |   [ scan box ]  |        |   auto-detects barcode
|        |                 |        |
|        +-----------------+        |
|  Point at a product barcode       |
|  [ Enter barcode manually ]       |
+-----------------------------------+
```

- **Interactions:** on detect -> OFF lookup; found -> S-04; not found -> dialog "Not on Open Food Facts" with *Create custom food* (S-05) or *Contribute* (S-17).
- **States:** *Permission denied* -> explainer + open-settings button; *Offline* -> message + manual-entry fallback; *Looking up* -> inline progress, cancellable (NFR-006).

---

## S-04 Quantity Entry  ·  flow  ·  FR-003, FR-017, FR-024

```
+-----------------------------------+
| <  Oats                      [fav]|
|-----------------------------------|
|  Amount [ 250 ]  ( g | ml | serv )|   QuantityField; unit per FR-024
|  Meal   ( Lunch v )    Date (19/6)|
|-----------------------------------|
|  For this amount:                 |
|   Energy 180  P 6  C 30  F 3      |   live recompute
|  (micros shown expandable)        |
|-----------------------------------|
|              [ Add to diary ]     |
+-----------------------------------+
```

- **Components:** `QuantityField` (servings vs weight/volume toggle), slot/date selectors, live nutrition preview, favorite toggle.
- **Interactions:** changing amount/unit recomputes instantly; recipes show a *servings* field (FR-017); confirm writes the entry and returns to S-01.
- **States:** *Edit existing entry* prefills amount; *Food missing serving size* hides the servings option; values display in the chosen unit system (FR-024).

---

## S-05 Custom Food Editor  ·  flow / Foods  ·  FR-008, FR-024, FR-028

```
+-----------------------------------+
| X  New food            [ Save ]   |
|-----------------------------------|
|  Name   [ .......................]|
|  Brand  [ ............ ] (optional)|
|  Barcode[ ............ ] (optional)|
|-----------------------------------|
|  Values per ( 100 g | 100 ml |    |
|              serving )            |   basis selector
|  Serving size [ 30 ] ( g | piece )|
|  Household measure [ 2 unidades ] |   medida caseira (FR-028)
|-----------------------------------|
|  Energy       [   ] kcal          |
|  Carbs        [   ] g  Sugars [ ] |
|   Added sugars[   ] g              |   ANVISA (FR-028)
|  Protein      [   ] g             |
|  Total fat    [   ] g  Sat.  [  ] |
|   Trans fat   [   ] g              |   ANVISA; no %VD
|  Fiber        [   ] g  Sodium [ ] |
|  [ + Add micronutrient ]          |   open set (FR-008)
+-----------------------------------+
```

- **Components:** `NutrientForm`, basis selector, serving definition, add-micronutrient.
- **Interactions:** Save validates (name + energy required; blanks allowed elsewhere) and returns the food for logging or to the catalog.
- **States:** *Edit* prefills; *Validation error* marks fields inline (runtime checks, never asserts — see `AGENTS.md`); inputs honor the unit system (FR-024).
