# Screens — Data & Settings (S-11..S-18)

Conventions and shared components are in `design-system.md`.

---

## S-11 CSV Import Wizard  ·  Foods / Settings  ·  FR-013, FR-014, FR-030

Four steps. Field contract and mapping rules: `agent_docs/csv_import.md`. A **preset** (e.g. TACO) on step 2 pre-fills the column mapping (FR-030); the user can still adjust it, and OpenDiet ships no TACO data (the user supplies their own file).

```
Step 1 Pick file        Step 2 Map columns
+-------------------+    +-----------------------------+
| Import foods      |    | Map columns -> fields       |
| [ Choose CSV ]    |    |  "Produto"  -> Name      [v]|  auto-proposed
| foods.csv (412)   |    |  "kcal"     -> Energy    [v]|  user can change
| [ Next > ]        |    |  "Prot"     -> Protein   [v]|
+-------------------+    |  "Col7"     -> Ignore    [v]|
                        |  Required unmapped: none    |
Step 3 Preview          | [ Back ]          [ Next > ]|
+-------------------+    +-----------------------------+
| 3 sample rows     |
| mapped + valid    |    Step 4 Result
| [ Back ][Import]  |    +-----------------------------+
+-------------------+    | Imported 408 / 412          |
                        | 4 rejected:                 |
                        |  row 17 - energy missing    |  (FR-014)
                        |  row 88 - bad number        |
                        | [ Export rejected ] [ Done ]|
                        +-----------------------------+
```

- **Interactions:** pick any CSV (headers need not match); OpenDiet proposes a column->field mapping the user adjusts (FR-013); preview shows mapped sample; import validates per row and reports rejects without aborting valid rows (FR-014).
- **States:** *Required field unmapped* blocks Next with a clear message; *All rows rejected* explains why; runs fully offline.

---

## S-12 Backup & Restore  ·  Settings  ·  FR-005, FR-006

```
+-----------------------------------+
| <  Backup & Restore               |
|-----------------------------------|
|  Your data lives only on this     |
|  device. Back it up to a file.    |
|-----------------------------------|
|  [ Export backup ]                |   FR-005 -> share/save file
|  Last export: never               |
|-----------------------------------|
|  [ Restore from file ]            |   FR-006
|  ! Restoring affects current data |
+-----------------------------------+
```

- **Interactions:** Export writes one backup file to a user location (FR-005); Restore confirms before replacing current data (FR-006). A successful restore refreshes the active diary, food, recipe, and settings reads immediately; the user must not need to restart the app to see restored data.
- **States:** *Export in progress* -> actions disabled with inline status; *Export failed* -> clear retryable message and actions re-enabled; *Restore confirmation canceled* -> no data change; *Restore of malformed file* -> rejected with a clear message, no partial corruption (FR-006, NFR-004); round-trip is lossless (NFR-003).

---

## S-13 Settings (hub)  ·  Settings  ·  FR-007, FR-019, FR-020, FR-022, FR-024, FR-027, FR-029

```
+-----------------------------------+
|  Settings                         |
|-----------------------------------|
|  Daily target            >        |   S-16
|  Meal slots              >        |   S-14
|  Reminders               >        |   S-15
|  Units        ( Metric | Imp )    |   inline (FR-024)
|  Idioma / Language ( PT | EN )    |   FR-029 (from device, override)
|  %VD reference ( Brasil v )       |   FR-027 (Brazil/US/EU, from region)
|  Open Food Facts account >        |   S-17
|  Backup & restore        >        |   S-12
|-----------------------------------|
|  About  (no account, no ads,      |   reinforces NFR-001/007
|          your data stays here)    |
| [ Diary ][ Foods ][Recipes][Setts]|
+-----------------------------------+
```

- **Interactions:** rows route to sub-screens; Units toggles inline (FR-024). No paywall/upgrade anywhere (FR-007, NFR-007).

---

## S-14 Meal Slots  ·  Settings  ·  FR-019

```
+-----------------------------------+
| <  Meal slots         [ Save ]    |
|-----------------------------------|
|  = Breakfast                 [x]  |   drag = reorder, [x] = remove
|  = Lunch                     [x]  |
|  = Dinner                    [x]  |
|  = Snacks                    [x]  |
|  [ + Add slot ]                   |
|  [ Reset to default template ]    |
+-----------------------------------+
```

- **Interactions:** add/rename/reorder/remove slots; optional default template (FR-019). Removing a slot with entries prompts to reassign or confirm (no data loss).

---

## S-15 Reminders  ·  Settings  ·  FR-020, FR-021

```
+-----------------------------------+
| <  Reminders                      |
|-----------------------------------|
|  Breakfast   08:00     [ on  ]    |   per-time toggle
|  Lunch       13:00     [ on  ]    |
|  Dinner      19:30     [ off ]    |
|  [ + Add reminder ]               |
|-----------------------------------|
|  Reminders are local only.        |   no push service (FR-021)
+-----------------------------------+
```

- **Interactions:** add/edit/enable/remove reminder times, optionally tied to a slot (FR-020); delivered as local notifications (FR-021).
- **States:** *Notification permission denied* -> inline explainer + open-settings.

---

## S-16 Daily Target  ·  Settings  ·  FR-022

```
+-----------------------------------+
| <  Daily target       [ Save ]    |
|-----------------------------------|
|  Energy  [ 2000 ] kcal            |
|  Protein [  120 ] g               |
|  Carbs   [  220 ] g               |
|  Fat     [   70 ] g               |
|  (optional micros...)             |
|  [ Clear target ]                 |
+-----------------------------------+
```

- **Interactions:** user-entered target only; no BMR/TDEE calculator in v1 (FR-022). Clearing a target leaves the Diary showing totals without comparison.

---

## S-17 Open Food Facts Account & Contribute  ·  Settings  ·  FR-012

```
+-----------------------------------+
| <  Open Food Facts                |
|-----------------------------------|
|  Status: not signed in            |
|  Sign in to contribute products.  |
|  [ Sign in ]   (your own account) |
|-----------------------------------|
|  Signed in:                       |
|   [ Add a product ]               |   FR-012
|   [ Suggest a correction ]        |
|   [ Sign out ]                    |
+-----------------------------------+
```

- **Interactions:** sign in with the user's own OFF account; contribute/correct products only when authenticated (FR-012). Credentials go to secure storage (NFR-008).
- **States:** *Signed out* hides contribute actions and shows username/password
  fields; *Signed in* shows the username plus Add product, Suggest correction,
  and Sign out actions; *Sign-in failed* keeps the entered form values and
  reports clearly; *Submit offline/failed* keeps entered contribution data and
  reports clearly (NFR-006).

---

## S-18 First-run Onboarding  ·  flow  ·  FR-024, FR-022, FR-012

```
+-----------------------------------+
|  Welcome to OpenDiet              |
|  Private. Offline. Yours.         |
|-----------------------------------|
|  1) Units   ( Metric | Imperial ) |   FR-024
|  2) Daily target (optional)       |   FR-022 (skippable)
|  3) Open Food Facts (optional)    |   FR-012 (skippable)
|-----------------------------------|
|  [ Skip ]            [ Start ]    |
+-----------------------------------+
```

- **Interactions:** all steps skippable; lands on the Diary. No account is required to use the app (NFR-001/007).
- **States:** shown only on first launch; re-runnable later from Settings.
- **Implementation dependency:** S-18 persists unit system, optional daily target, and
  first-run completion through the same Settings repository used by S-13/S-16.
  The optional Open Food Facts entry validates through the OFF repository
  boundary; it must not depend on the S-17 account route being present, and it
  must remain skippable if authentication fails or is not attempted.
