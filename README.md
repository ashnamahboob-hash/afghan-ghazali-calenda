# افغان غزالي کلنډر | Afghan Ghazali Calendar

Flutter Android starter project for an offline-first Afghan calendar.

## Included in this first source-code version
- Afghan Solar Hijri month names in Pashto, Dari and English.
- Month grid with Saturday as the first weekday.
- Date selection and Gregorian date picker.
- Language selector and language-specific digits.
- Offline prayer-time estimate for six preset Afghan cities.
- Green and gold Material 3 theme.
- Calendar conversion unit tests.

## Important accuracy notice
This is a runnable first-version foundation, not yet a verified official Afghan calendar release.
The current solar year boundary is provisionally set to March 21, and leap years use a provisional 33-year cycle. Afghan official calendar dates can depend on the official equinox-based calendar. Before publishing, validate the calendar engine for multiple years (including leap years) against official Afghanistan calendar data and adjust `lib/services/afghan_calendar.dart`.

Prayer times are approximate offline solar calculations. They depend on the selected city coordinates, timezone, calculation angles and jurisprudential method. Sunrise is displayed separately and is not a prayer. Confirm the chosen Fajr/Isha angles and Asr method with a trusted Afghan religious authority or local mosque. The app currently uses Kabul time offset (+04:30) for the preset Afghan cities.


## Administrative reference workbook cross-check (2026-11-01)

The draft administrative reference was cross-checked against the user-supplied
`afg_admin_boundaries.xlsx` workbook (v04; `valid_on=2026-06-23`).
The workbook contains 34 unique ADM1 P-codes and 457 unique ADM2 P-codes.
Its 457 ADM2 rows are mixed unit types: 397 `District`, 29
`Temporaray District` (spelling as present in the workbook), 30
`Provincial Capital`, and 1 `Capital`.

All 34 candidate province P-codes were found. All 401 candidate ADM2 P-codes
were found in the workbook, and all 401 parent ADM1 P-codes match. This is a
code/hierarchy cross-check only; it does not certify all district names.
The 401 candidate ADM2 records comprise 367 `District`, 30
`Provincial Capital`, 3 `Temporaray District`, and 1 `Capital`.
The workbook also contains 56 ADM2 records outside the 401-record candidate
reference (30 `District` and 26 `Temporaray District`); these have not been
silently added.

### Name review completed so far

- Province labels were aligned to the workbook's English/local labels while
  preserving stable province IDs.
- The 16 Daykundi and Panjshir crosswalk labels were aligned to workbook rows:
  Daykundi: Nili, Shahristan, Meramor, Ashtarlay, Kejran, Sang-e-Takht,
  Khader, Kiti, Pato; Panjshir: Bazarak, Rukha, Onaba, Shutol, Paryan,
  Hesa-e-Awal, Darah.
- A source-name discrepancy remains for Panjshir code `AF0804`: the
  secondary candidate record says `Hesa-e-Awal / حصه اول`, while the
  crosswalk's source-local label is `خنج`. The source-local label and stable
  identifier have not been overwritten; manual source reconciliation remains
  required.

### Outstanding verification

A further eight ADM2 labels were aligned by P-code for Kandahar and Herat:
`AF2706` Shah Walikot, `AF2708` Arghistan, `AF2710` Maiwand,
`AF2712` Neash, `AF2713` Meyanishin, `AF2715` Marof, `AF2716` Reg
(local label normalized to the workbook's «ریگ»), and `AF3201` Herat.
Together with the 16 Daykundi/Panjshir crosswalk entries, all 16 Kandahar
candidate records and Herat city, and a further 103 records across Badakhshan,
Samangan, Logar, Paktika, Sar-e-Pul, Paktya, Nuristan and Balkh, all 401 candidate ADM2 English labels have now been checked by P-code against
the workbook; 101 English labels were aligned to the Excel `adm2_name` field.
The separate local-language review was continued using the user's
`afg_admin_boundaries2.csv` export of the `afg_admin2` sheet (v04;
`valid_on=2026-06-23`). The file contains 457 ADM2 rows and 457 unique
ADM2 P-codes. All 401 candidate P-codes were joined by exact code. Of the
401 candidate local labels, 332 exactly match `adm2_name1`; 69 differ.
The 136 previously reviewed records were retained, and 213 additional exact
matches were recorded, bringing the reviewed count to 349 of 401. The
remaining 52 local-script discrepancies are listed in the JSON audit notes
and have not been automatically overwritten. Across all 401 records, 69
local-script or name discrepancies are documented.

### Targeted OCHA source checks

A targeted review of OCHA publications found exact P-code/name evidence for
nine disputed records. OCHA's February 2021 Humanitarian Access Group list
pairs `AF2504` with Shahid-e-Hassas, `AF2506` with Chinarto, `AF2507` with
Gizab, `AF3004` with Nahr-e-Saraj, and `AF3003` with Nawa-e-Barakzaiy.
This supports the candidate code/name mapping for the Uruzgan records and
shows that the user's v04 workbook's `AF2506`/`AF2507` names are crossed.
OCHA's 2024 Afghanistan Humanitarian Fund Annex 1 pairs `AF0905` with
Baghlan-e-Jadid, `AF1722` with Darwaz-e-Payin, `AF2304` with Charsadra,
and `AF2501` with Tirinkot. Five candidate English labels were corrected
to the OCHA spellings/names: `AF0905`, `AF2504`, `AF1722`, `AF2304`, and
`AF2501`. The relevant source references and per-record findings are stored
in `district_name_review_status.independent_source_checks` and
`english_name_review_status.post_workbook_ocha_crosscheck` in the JSON.

These targeted OCHA documents are not the complete COD gazetteer, and some
records show alternate/expanded names (for example `AF3004` Nahr-e-Saraj /
Gereshk and `AF3003` Nawa-e-Barakzaiy / Nawa). Such variants are not treated
as confirmed code errors. The CSV contains 56 additional ADM2 codes outside
the 401-record candidate reference; they have not been silently added. P-code
presence and parent-code matching must not be treated as name verification.
The workbook remains a user-supplied secondary reference; targeted OCHA
publications provide evidence only for the listed P-codes. The remaining
local-script differences still need direct source review. Do not mark the
gazetteer official or enable it as runtime administrative data until the
complete primary-source verification and application tests are complete.

## Draft ADM2 structural validation

Run the dependency-free audit check from the repository root:

```bash
python tool/validate_admin_reference.py
```

The check validates the draft's 34 province / 401 ADM2 structure, unique stable
IDs and slugs, parent-code hierarchy, bilingual labels, and review-audit
bookkeeping. GitHub Actions runs it when the draft JSON, validator, or workflow
changes. A passing structural check does not certify district names or make
the dataset an official gazetteer.

## District reference review update (2026-11-01)

- Current OCHA COD status dashboard: Afghanistan 34 ADM1 / 401 ADM2 COD-AB features; COD-PS lists 457 ADM2 P-codes, of which 56 are not in COD-AB. These are dataset-level counts, not district-name certification.
- The 52 pending local-script discrepancies are triaged as 37 orthographic/transliteration variants and 15 targeted-source or alternate-name cases still awaiting local-script or current P-code row verification. Secondary alias checks cover Khost, Baghlan, Zabul and Helmand; no local-script labels were changed.
- Afghanistan is listed as **In Progress** on OCHA's COD-AB work-status dashboard. Obtain and check the latest row-level gazetteer before closing any remaining discrepancies.
- All 52 remain pending; no local-script labels were changed by this triage. The reference remains draft-only.

## Requirements
- Flutter SDK 3.22 or later
- Android Studio or VS Code with Flutter extension
- Android SDK

## Run
1. Extract the ZIP.
2. Open the project folder in Android Studio / VS Code.
3. Run `flutter pub get`.
4. Run `flutter test`.
5. Connect an Android phone with USB debugging enabled, or start an emulator.
6. Run `flutter run`.

## Build APK
```bash
flutter build apk --release
```
APK output:
`build/app/outputs/flutter-apk/app-release.apk`

## Build Play Store bundle
```bash
flutter build appbundle --release
```

## Android package name
The default Flutter package name can be changed with Android Studio's refactor tools before publishing. Choose a permanent reverse-domain ID, for example `com.yourcompany.afghanghazalicalendar`.

## Next recommended development tasks
1. Verify and replace provisional Afghan leap-year / New Year logic with official calendar data.
2. Add verified Hijri lunar dates and official holiday data, with update mechanism.
3. Add prayer-time calculation-method settings and location permissions if automatic location is desired.
4. Add local notifications and user reminders.
5. Add app icon, splash screen, accessibility and device-size testing.
6. Complete full Dari and English translations and RTL/LTR layout review.

### OCHA 2026 status and source-version reconciliation (2026-11-01)

A fresh check of OCHA's COD Status Dashboard (dashboard last updated
2026-10-31) reports Afghanistan COD-AB reference year 2026, with 34 ADM1
and 401 ADM2 features. It reports COD-PS reference year 2027 with 457 ADM2
P-codes, 56 of which do not join to the COD-AB. The separate COD-AB
coverage/work dashboard (observed 2026-10-23) lists Afghanistan as
**In Progress**, with a review window shown as five months and GIS
publication marked Yes.

This needs to be distinguished from the accessible HDX/AGCHO dataset
metadata, which still describes the COD-AB as established in 2019, last
reviewed for accuracy in July 2024, and metadata last updated 2025-01-17.
The public dashboard's 2026 summary gives feature counts and reference year,
but the retrieved page does not expose the 401 row-level ADM2 P-code/name/
parent records. Therefore:

- The 2026 dashboard figures are recorded as official dataset-level status,
  not as row-level name verification.
- The user-supplied v04 workbook (valid_on=2026-06-23) is not assumed to be
  the 2026 COD-AB gazetteer.
- The complete 401-row primary-source comparison remains pending.
- Do not change stable IDs, local-script labels, or parent mappings based
  only on dashboard counts or the 457-row COD-PS table.

The source-version evidence and the remaining retrieval gap are recorded in
assets/data/afghanistan_admin_divisions_reference_draft.json under
sources.official_status_dashboard. A concise investigation log is in
docs/admin-reference-ocha-source-audit-2026-11-01.md.

## National administrative selector preview

The Agriculture screen now includes a draft-only selector for all 34 provinces
and 401 ADM2 administrative-unit records. This is a development preview, not
an officially certified gazetteer. The UI displays a warning, and the selector
does not produce district-level agricultural advice or planting dates. Official
production use remains disabled until current OCHA row-level P-code/name/parent
verification and local-name review are complete.

The runtime loader and tests are in
`lib/services/administrative_reference.dart` and
`test/administrative_reference_test.dart`. Flutter validation runs through
`.github/workflows/flutter-validation.yml`.

## Independent secondary ADM2 cross-check (2026-11-01)

A community-maintained bilingual administrative dataset
([open-admin-data/afghanistan-administrative-divisions](https://github.com/open-admin-data/afghanistan-administrative-divisions),
README-stated update 2026-09-08, CC-BY-4.0) was compared with the 401-record
candidate reference using exact ADM2 ID/P-code strings.

- 401/401 IDs joined.
- 401/401 parent province IDs matched.
- English labels: 289 exact; 20 additional differences are formatting-only
  under conservative normalization; 92 remain different.
- Local-script labels: 396 exact; 1 additional difference is spacing-only;
  4 remain different after normalization.
- No candidate labels were overwritten and no pending discrepancy was marked
  resolved. The secondary source's sampled row-level `source` metadata is
  empty, so this is corroboration only—not official COD-AB verification.

The complete per-record comparison is recorded in
`docs/admin-reference-secondary-crosscheck-open-admin-data-2026-11-01.json`.
The current OCHA/AGCHO row-level gazetteer comparison remains pending.

### OCHA GIS service retrieval lead

An OCHA global COD Admin2 ArcGIS layer has been identified:
https://gis.unocha.org/server/rest/services/COD/GLB_COD_Admin2/MapServer/0

Its schema exposes ADM2 and ADM1 P-codes, multilingual names, validity dates,
and version fields. The Afghanistan-filtered feature query could not be
retrieved in this environment, so this is not yet row-level verification.
The next source task is to obtain and archive the Afghanistan query response
from this service (or the equivalent current COD Services API).
