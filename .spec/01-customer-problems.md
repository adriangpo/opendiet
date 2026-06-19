# Customer Problems (CP): OpenDiet

**Version:** 1.0 | **Created:** 2026-06-19 | **Domain:** WHY
**Input:** `00-business-context.md`

> Notation: `[Subject] [verb] [Object] [Penalty]`. Verbs (must/expects/hopes) indicate severity class, not BCP 14 keywords.

## Summary

| Class | CPs |
|-------|-----|
| Obligation | CP-001, CP-002, CP-003, CP-010 |
| Expectation | CP-004, CP-005, CP-006, CP-007, CP-008, CP-011, CP-012, CP-013 |
| Hope | CP-009 |

---

### CP-001: Privacy of Dietary Data

**Statement:** The user must be able to track their diet without surrendering personal dietary data to a third-party vendor, otherwise they either accept surveillance or avoid tracking altogether.

**Classification:** Obligation

**Subject:** The user (privacy-conscious individual)

**Consequence if Unsolved:**
- Personal eating habits are harvested, profiled, or sold.
- Privacy-conscious users refuse to adopt any tracker.

**Benefit if Solved:**
- Dietary data stays under the user's control.
- OpenDiet has a clear reason to exist over incumbents.

---

### CP-002: Logging Without a Network

**Statement:** The user must be able to record what they eat at any time, including with no internet connection, otherwise meals go unlogged and the diary becomes unreliable.

**Classification:** Obligation

**Subject:** The user

**Consequence if Unsolved:**
- Entries are lost when offline (no signal, airplane mode).
- An incomplete diary undermines the whole purpose of tracking.

**Benefit if Solved:**
- The user can log anywhere, anytime.
- The diary is trustworthy and complete.

---

### CP-003: Surviving Device Loss and Migration

**Statement:** The user must be able to move their dietary history off and back onto a device, otherwise losing or replacing the device destroys their history irrecoverably, as there is no cloud backup.

**Classification:** Obligation

**Subject:** The user

**Consequence if Unsolved:**
- Months or years of logs vanish with a lost or reset phone.
- Local-first becomes a data trap rather than ownership.

**Benefit if Solved:**
- History survives device changes.
- "Local-first" genuinely means user-owned, portable data.

---

### CP-004: Free of Paywalls and Ads

**Statement:** The user expects core tracking capabilities (macros, scanning, custom foods) without paywalls or advertising, otherwise the everyday experience is degraded or rented back to them.

**Classification:** Expectation

**Subject:** The user

**Consequence if Unsolved:**
- Basic functionality is gated or interrupted by ads.
- Users resent the tool and abandon it.

**Benefit if Solved:**
- A clean, complete experience builds trust and retention.

---

### CP-005: Logging the Foods They Actually Eat

**Statement:** The user expects to find or record the specific foods they eat -- including packaged, local, and homemade items, at the nutrient detail they care about (including micronutrients) -- otherwise logging is inaccurate or simply impossible for many meals.

**Classification:** Expectation

**Subject:** The user

**Consequence if Unsolved:**
- Foods missing from any database cannot be logged accurately.
- Users tracking specific nutrients cannot manage their needs.

**Benefit if Solved:**
- Any food can be logged, with the detail the user needs.
- Tracking reflects reality, not the nearest approximation.

---

### CP-006: Bringing Existing Food Data In

**Statement:** The user expects to import an existing list of foods (for example a spreadsheet/CSV they already maintain, whose column names may not match a fixed format), otherwise switching to OpenDiet means re-entering everything by hand.

**Classification:** Expectation

**Subject:** The user (often a switcher from another tool)

**Consequence if Unsolved:**
- High switching cost; users stay on their current tool.
- Hours of manual re-entry discourage adoption.

**Benefit if Solved:**
- Painless onboarding from existing data.
- Lower barrier to adopting OpenDiet.

---

### CP-007: Accurate Nutrition for Home Recipes

**Statement:** The user who cooks expects accurate per-serving nutrition for their own recipes, otherwise they guess at the numbers and their tracking is systematically wrong.

**Classification:** Expectation

**Subject:** The user (home cook)

**Consequence if Unsolved:**
- Home-cooked meals are mis-counted.
- Aggregate diet data is unreliable for anyone who cooks.

**Benefit if Solved:**
- Recipes are logged with correct, consistent nutrition.

---

### CP-008: Low-Friction Daily Logging

**Statement:** The user expects to log everyday foods quickly with minimal repetition, otherwise the daily effort of tracking becomes tedious and they stop using the app.

**Classification:** Expectation

**Subject:** The user

**Consequence if Unsolved:**
- Repeatedly searching/re-entering the same foods is tedious.
- Logging fatigue leads to abandonment within weeks.

**Benefit if Solved:**
- Logging is fast and habitual.
- Sustained use produces a useful long-term record.

---

### CP-009: Remembering to Log

**Statement:** The user hopes to be reminded to log around mealtimes, otherwise they forget and the diary develops gaps that reduce its usefulness.

**Classification:** Hope

**Subject:** The user

**Consequence if Unsolved:**
- Forgotten meals leave gaps in the record.
- Inconsistent data weakens any insight drawn from it.

**Benefit if Solved:**
- Gentle prompts support a consistent logging habit.

---

### CP-010: Trustworthy Numbers and Intact Data

**Statement:** The user must be able to trust that nutrient totals are correct and that their local data is never silently corrupted, otherwise the app misleads their dietary decisions and, with no cloud copy, the damage is unrecoverable.

**Classification:** Obligation

**Subject:** The user

**Consequence if Unsolved:**
- Wrong totals lead to wrong dietary decisions.
- Silent local corruption destroys irreplaceable data.

**Benefit if Solved:**
- Users can rely on the numbers and on data durability.

---

### CP-011: Familiar Units of Measure

**Statement:** The user expects to enter and read food amounts in their own unit system (metric or imperial), otherwise they make conversion errors or find the app awkward to use.

**Classification:** Expectation

**Subject:** The user (across regions)

**Consequence if Unsolved:**
- Mismatched units cause logging errors.
- Friction for users outside the app's default region.

**Benefit if Solved:**
- Amounts are entered and shown naturally, reducing errors.

---

### CP-012: Brazilian Nutrition-Label Format (ANVISA)

**Statement:** Brazilian users expect nutrition information in the ANVISA Tabela Nutricional format -- the mandatory nutrients including added sugars and trans fat, shown per 100 g/ml and per serving with a %VD column -- otherwise the data is incomplete and unfamiliar and they mis-read or mis-enter it.

**Classification:** Expectation

**Subject:** The user (in Brazil)

**Consequence if Unsolved:**
- Added sugars and trans fat are missing, so labels cannot be reproduced.
- Without %VD and a per-serving column, the numbers do not match packaging.

**Benefit if Solved:**
- Foods match the labels users actually read in Brazil.
- Logging and verification are accurate and familiar.

---

### CP-013: Use in Brazilian Portuguese

**Statement:** Brazilian users expect to use the app in Brazilian Portuguese with local number formatting, otherwise the app is harder to use and more error-prone for them.

**Classification:** Expectation

**Subject:** The user (Portuguese speaker)

**Consequence if Unsolved:**
- An English-only UI excludes or slows many Brazilian users.
- Foreign number formatting causes entry mistakes.

**Benefit if Solved:**
- The app is natural and accessible to its primary audience.
