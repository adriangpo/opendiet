# CSV Food Import — Field Contract & Smart Header Mapping

Implements **FR-013** (import + column mapping) and **FR-014** (per-row validation).
Goal: a user can import a food CSV **without renaming their columns**. OpenDiet proposes a
mapping from the file's headers to the canonical fields, the user adjusts it, then rows are
validated and imported individually.

## Canonical food fields

| Canonical field | Type | Required | Notes |
|-----------------|------|----------|-------|
| `name` | text | **yes** | Food display name. |
| `brand` | text | no | Manufacturer/brand. |
| `barcode` | text | no | EAN/UPC if known. |
| `basis` | enum `per_100g` \| `per_100ml` \| `per_serving` | no (default `per_100g`) | How the nutrient columns are expressed. |
| `serving_size` | number | conditional | Required when `basis = per_serving` or when the user logs by serving. |
| `serving_unit` | enum `g` \| `ml` \| `piece` \| ... | conditional | Paired with `serving_size`. |
| `energy_kcal` | number | **yes** | Energy. `energy_kj` accepted and converted. |
| `protein_g` | number | no | |
| `carbs_g` | number | no | Total carbohydrate. |
| `sugars_g` | number | no | Of which sugars (total). |
| `added_sugars_g` | number | no | ANVISA mandatory field (açúcares adicionados). |
| `fat_g` | number | no | |
| `saturates_g` | number | no | Of which saturates. |
| `trans_fat_g` | number | no | ANVISA mandatory field (gorduras trans); no %VD. |
| `fiber_g` | number | no | |
| `salt_g` | number | no | Stored canonical; `sodium_mg` accepted and converted (salt = sodium x 2.5). |
| micronutrients | number | no | Open set (e.g. `sodium_mg`, `calcium_mg`, `iron_mg`, `vitamin_c_mg`, ...). Unknown nutrient columns may be mapped or ignored. |

All amounts are stored as **canonical metric** (see `AGENTS.md`). Imperial inputs are converted on import.

## Smart header mapping

1. **Normalize** each header: lowercase, trim, strip punctuation and surrounding units
   (`Energy (kcal)` -> `energy kcal`), collapse whitespace.
2. **Match** the normalized header against a synonym table (below) to propose a canonical field.
3. **Detect units** embedded in the header (`sodium (mg)` -> `sodium_mg`; `salt (g)` -> `salt_g`).
4. **Propose** the full mapping; the user can change any column's target, set a column to
   *ignore*, or map an unrecognized column to a micronutrient (FR-013).
5. **Block import** only if a required field (`name`, `energy_kcal`) is left unmapped, with a clear message.
6. **Preview** a sample of mapped rows before committing.

### Synonym seeds (extend over time; case-insensitive, post-normalization)

- `name` <- name, food, product, description, item, título, nome, alimento, produto
- `energy_kcal` <- kcal, calories, energy, cal, calorias, energia
- `protein_g` <- protein, proteins, prot, proteína, proteínas
- `carbs_g` <- carbs, carbohydrate, carbohydrates, cho, carboidratos, carbo
- `sugars_g` <- sugar, sugars, of which sugars, açúcar, açúcares, açúcares totais
- `added_sugars_g` <- added sugar, added sugars, açúcares adicionados
- `trans_fat_g` <- trans, trans fat, gorduras trans, gordura trans
- `fat_g` <- fat, fats, total fat, gordura, gorduras, lipídios
- `saturates_g` <- saturated, saturates, saturated fat, saturada, gordura saturada
- `fiber_g` <- fiber, fibre, dietary fiber, fibra, fibras
- `salt_g` <- salt, sal · `sodium_mg` <- sodium, sódio, na
- `serving_size` <- serving, serving size, portion, porção · `serving_unit` <- unit, unidade

> The synonym table is the **only** place to add new header aliases. Keep it data, not branching
> logic, so it is easy to extend and to unit-test. Do not hardcode any nutrient's meaning or limit
> in prose elsewhere (see the "never restate an external contract" rule in `AGENTS.md`).

## TACO preset (FR-030)

A built-in preset pre-maps a TACO-format file's columns onto the canonical fields, so a user can
import their own TACO export in one tap. OpenDiet ships **no TACO data** (restricted-use licence --
see `brazilian_nutrition.md`); the preset only knows the column layout, not the data. The preset is
just a saved mapping in the synonym/mapping system -- the user can still adjust it before importing.

## Per-row validation (FR-014)

- Reject a row when: `name` empty, `energy_kcal` missing/non-numeric, a mapped numeric field is
  non-numeric or negative, or `basis = per_serving` without a `serving_size`.
- A rejected row does **not** abort the import — valid rows still import.
- Return a summary: imported count, rejected count, and the reason per rejected row.

## Edge cases to test

Empty file; header-only file; missing required column; duplicate headers; extra/unknown columns;
mixed units across rows; `energy_kj` only; `sodium_mg` only (derive salt); negative/zero/blank
numerics; non-UTF-8 / different delimiters; thousands separators and comma decimals; very large files.
