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
