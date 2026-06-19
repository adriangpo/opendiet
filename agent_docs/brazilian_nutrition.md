# Brazilian Nutrition Support (ANVISA + TACO + i18n)

Implements FR-025..FR-030 and NFR-010/011. The ANVISA table is the **universal** format
for all users; only the **%VD reference set** varies by region.

## ANVISA mandatory nutrients (IN 75/2020)

The ten mandatory declarations, in order, are:

1. Valor energético (energy) -- kcal (and kJ)
2. Carboidratos totais (total carbohydrates)
3. Açúcares totais (total sugars)
4. Açúcares adicionados (added sugars)
5. Proteínas (protein)
6. Gorduras totais (total fat)
7. Gorduras saturadas (saturated fat)
8. Gorduras trans (trans fat)
9. Fibra alimentar (dietary fiber)
10. Sódio (sodium)

These are first-class fields on every food/recipe (FR-025). Micronutrients remain an optional
open set alongside them. **Added sugars** and **trans fat** are the two fields a generic label
lacks; data sources (e.g. Open Food Facts) often omit them -- treat absent as not-informed, never zero.

## The table layout (FR-026)

Three columns: **per 100 g/ml**, **per porção** (with the *medida caseira*, e.g. "2 unidades (30 g)"),
and **%VD**. Note: **trans fat has no %VD** (no reference value exists for it).

## %VD reference values -- SOURCE OF TRUTH, do not restate here (FR-027, NFR-011)

%VD = nutrient amount / reference value, for the selected region's reference set:
- **Brazil:** the Valores Diários de referência (VD) in ANVISA **IN 75/2020** (~2000 kcal basis).
- **US:** FDA Daily Values (DV). **EU:** Reference Intakes (NRV).

Per the AGENTS.md "never restate an external contract" rule, **do not transcribe the numbers into
this doc or into comments.** Hold each reference set in a **single Dart table** with a test that
asserts the values against the cited regulation, and a source comment pointing to the regulation
(not the values). One place per set; nothing duplicated in prose.

Sources to cite in that table:
- ANVISA RDC 429/2020 and IN 75/2020 -- https://www.gov.br/anvisa/pt-br/assuntos/alimentos/rotulagem/rotulagem-nutricional

Out of scope for v1: the front-of-pack "lupa" high-in warnings (manufacturer labelling).

## TACO -- licensing and sourcing (FR-030)

The official TACO (NEPA/UNICAMP) ships only as PDF + MS Excel under a **restricted-use licence**;
there is no official open machine-readable download or API. Community digitizations exist
(GitHub JSON/CSV, REST/GraphQL, Kaggle) but inherit that licence, so **OpenDiet must not bundle or
redistribute TACO/TBCA data.**

Approach: the user imports **their own** TACO file through the CSV importer, using a built-in
**TACO column-mapping preset** (see `csv_import.md`). Any "scraper/normalizer" we build is a
**personal-use import helper**, never a shipped dataset. Same rule applies to TBCA (tbca.net.br).

## Localization (FR-029, NFR-010)

- **Base/template locale is English** (`lib/l10n/app_en.arb`); Brazilian Portuguese is a translation
  (`app_pt.arb`). v1 ships en + pt-BR only.
- All user-facing strings go through Flutter `gen-l10n` -- no hardcoded UI strings. Adding a language
  is just adding an ARB file; no code changes.
- UI **language** (from device language) and the **%VD reference region** (from device region) are
  independent settings; either can be overridden. The brand name "OpenDiet" is a proper noun and is
  not translated.
