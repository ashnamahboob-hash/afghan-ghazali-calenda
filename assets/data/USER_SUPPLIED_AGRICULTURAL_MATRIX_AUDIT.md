# Review of the user-supplied provincial agricultural matrix

**Review date:** 2026-11-01  
**Status:** Audit only — not imported into production data.

## Decision

The supplied matrix is useful as a list of candidate crops, irrigation terms and possible seasonal topics. It is **not safe to import as a production administrative or agronomic dataset** yet. Its province P-codes conflict with the application's current secondary-reference draft, several P-codes are duplicated within the supplied matrix, district totals differ in multiple provinces, and the seasonal windows and irrigation claims do not include row-level sources.

The application's existing administrative reference remains a **draft secondary reference**, not an OCHA-certified gazetteer. The comparison below identifies conflicts with that draft; it does not certify either source as official.

## P-code comparison

| Province | Supplied P-code | App draft P-code | Finding |
|---|---:|---:|---|
| کندهار / Kandahar | AF24 | AF27 | Conflict |
| هلمند / Helmand | AF23 | AF30 | Conflict |
| اروزګان / Uruzgan | AF25 | AF25 | Same candidate code |
| زابل / Zabul | AF26 | AF26 | Same candidate code |
| نیمروز / Nimroz | AF22 | AF34 | Conflict |
| کابل / Kabul | AF01 | AF01 | Same candidate code |
| دایکندي / Daykundi | AF21 | AF24 | Conflict |
| پنجشېر / Panjsher | AF08 | AF08 | Same candidate code |
| بامیان / Bamyan | AF10 | AF10 | Same candidate code |
| پروان / Parwan | AF02 | AF03 | Conflict |
| میدان وردګ / Maidan Wardak | AF03 | AF04 | Conflict |
| لوګر / Logar | AF04 | AF05 | Conflict |
| کاپیسا / Kapisa | AF02 | AF02 | Same candidate code |
| غزني / Ghazni | AF11 | AF11 | Same candidate code |
| ننګرهار / Nangarhar | AF05 | AF06 | Conflict |
| کونړ / Kunar | AF06 | AF15 | Conflict |
| لغمان / Laghman | AF07 | AF07 | Same candidate code |
| نورستان / Nuristan | AF09 | AF16 | Conflict |
| بلخ / Balkh | AF18 | AF21 | Conflict |
| کندز / Kunduz | AF17 | AF19 | Conflict |
| تخار / Takhar | AF16 | AF18 | Conflict |
| بدخشان / Badakhshan | AF15 | AF17 | Conflict |
| سمنګان / Samangan | AF19 | AF20 | Conflict |
| سرپل / Sar-e-Pul | AF20 | AF22 | Conflict |
| جوزجان / Jawzjan | AF14 | AF28 | Conflict |
| فاریاب / Faryab | AF13 | AF29 | Conflict |
| بغلان / Baghlan | AF16 | AF09 | Conflict |
| هرات / Herat | AF12 | AF32 | Conflict |
| فراه / Farah | AF31 | AF33 | Conflict |
| بادغیس / Badghis | AF32 | AF31 | Conflict |
| غور / Ghor | AF33 | AF23 | Conflict |
| پکتیا / Paktya | AF27 | AF13 | Conflict |
| پکتیکا / Paktika | AF29 | AF12 | Conflict |
| خوست / Khost | AF28 | AF14 | Conflict |

## Duplicate P-codes inside the supplied matrix

The supplied matrix assigns the same province code to more than one province:

- AF02: Parwan and Kapisa
- AF16: Takhar and Baghlan
- AF23: Helmand and Ghor
- AF22: Nimroz and Sar-e-Pul

These collisions make province-to-district joins unsafe. A district row must never be attached to a province by a non-unique key.

## District-count differences worth resolving

The supplied counts differ from the current app draft for several provinces. Examples:

| Province | Supplied count | App draft count |
|---|---:|---:|
| Kandahar | 18 | 16 |
| Helmand | 14 | 13 |
| Uruzgan | 5 | 7 |
| Daykundi | 9 | 9 |
| Samangan | 7 | 8 |
| Paktya | 14 | 11 |

The app draft contains 34 province records and 401 ADM2 records in total. These ADM2 records include mixed administrative-unit types in the supplied COD-AB workbook cross-check; do not describe every ADM2 record as an ordinary district without checking its unit type.

## Agronomic evidence gaps

The matrix's crop lists, irrigation systems and harvest windows do not provide a source for each province/crop/activity combination. Therefore:

1. Do not load its sowing, fertilizer, irrigation or harvest dates into `agricultural_advisory.json`.
2. Do not present named dams, canals, rivers or irrigation systems as confirmed service areas for a province without a source.
3. Treat crop names as candidate catalogue entries only until they are cross-checked with MAIL, provincial agriculture directorates, FAO or a credible agronomic source.
4. Keep province-level guidance separate from district-level guidance. Never infer district dates from a province-level crop calendar.
5. Require a source URL, publication date when known, geographic scope, access date and review status for every published advisory.

## Source references

- OCHA COD-AB metadata: https://data.amerigeoss.org/en/dataset/cod-ab-afg  
  The metadata describes 34 ADM1 and 401 ADM2 features and identifies AGCHO as the source; the dataset metadata records a July 2024 accuracy review.
- OCHA COD status dashboard: https://ocha-dap.github.io/cod-site/status/  
  The dashboard reports Afghanistan's COD-AB coverage as 34 ADM1 and 401 ADM2 features, with a 2026 reference year. This is dataset-level metadata, not a row-by-row certification of the candidate names in this app.
- UN / World Bank / EU / ADB Joint Rapid Recovery Needs Assessment, November 2025, Figure 5 “Seasonal crop calendar in Afghanistan”, printed page 37: https://afghanistan.un.org/en/download/198422/307176  
  This is a broad national seasonal reference. It is not a district-specific planting calendar and should not be converted into local Solar Hijri dates without agronomic review.

## Next safe implementation steps

1. Obtain the current row-level OCHA/AGCHO ADM1/ADM2 gazetteer and reconcile every P-code, parent code, unit type and name.
2. Resolve the supplied matrix's duplicate and conflicting province codes before any relational import.
3. Build a crop catalogue independently from the advisory calendar.
4. Add calendar windows only when the source supports the exact crop, activity and geographic coverage.
5. Keep unverified material out of user-facing recommendations; the current empty advisory array is intentional.
