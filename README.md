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
candidate records and Herat city, 33 of the 401 candidate ADM2 names have now
been checked by P-code against the workbook; 368 candidate records remain.

The remaining 368 candidate ADM2 records still require a complete
name-by-name comparison against the workbook. P-code presence and parent-code
matching must not be treated as name verification. The workbook is a
user-supplied secondary reference for this review and does not replace
row-level OCHA/AGCHO certification. Do not mark the gazetteer official or
enable it as runtime administrative data until the required primary-source
verification and application tests are complete.

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
