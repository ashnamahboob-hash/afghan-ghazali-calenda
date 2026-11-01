# FlutterFlow Custom Code Integration — Verified Workflow

**Project:** Afghan Ghazali Calendar  
**Preparation branch:** `flutterflow/migration-prep`  
**Prepared:** 2026-11-01

## Why the code is split this way

The migration helper in `flutterflow_custom_code/lib/afghan_ghazali_functions.dart` is a portable Dart class containing multiple related calculations. It is not a ready-made FlutterFlow Custom Function snippet.

FlutterFlow distinguishes:
- **Custom Functions** — small Dart functions used in widget/action properties. They have restricted imports.
- **Custom Actions** — action-flow functions, generally suitable for asynchronous work and package imports.
- **Code Files** — reusable Dart classes/enums and business logic.
- **Custom Widgets** — reusable UI where native widgets are insufficient.

Use the Code File route for the calculation class, then expose only small, typed wrappers to page/action flows. Do not paste the entire class into the body of one Custom Function.

## Integration sequence

### A. Create the Code File

1. Open the FlutterFlow project.
2. Open **Custom Code**.
3. Choose the **Code File** resource type and create a file named `afghan_ghazali_functions`.
4. Copy the complete contents of:
   `flutterflow_custom_code/lib/afghan_ghazali_functions.dart`
5. Save and use FlutterFlow's parser/analyzer to check whether the Code File accepts the complete class.
6. If the parser rejects a Dart feature, do not silently remove logic. Record the exact error and adapt the file while preserving its tests.

FlutterFlow's Code File parser has documented limitations (for example, generic classes, function-typed fields/parameters and extension methods). The current helper intentionally uses ordinary classes and static methods, but parser compatibility still needs an in-project compile check.

### B. Add small callable wrappers

Create Custom Functions or Custom Actions that call the Code File methods. Prefer returning a JSON string for complex results, then decode it in FlutterFlow using JSON paths.

Suggested public wrappers:

| FlutterFlow resource | Inputs | Output | Calls |
|---|---|---|---|
| `getSolarDateJson` | `isoDate: String` | String (JSON) | `solarDateFromGregorianJson` |
| `getGregorianDateJson` | `solarYear, solarMonth, solarDay: int` | String (JSON) | `solarDateToGregorianJson` |
| `getCivilHijriJson` | `isoDate: String` | String (JSON) | `civilHijriFromGregorianJson` |
| `getPrayerTimesJson` | date, lat, lon, offset, Fajr/Isha angles, Asr factor | String (JSON) | `calculatePrayerTimesJson` |
| `getCityConfigJson` | `cityId: String` | String (JSON) | city configuration lookup |
| `getLocalizedSolarMonth` | month, languageCode | String | `solarMonthName` |
| `getLocalizedHijriMonth` | month, languageCode | String | `hijriMonthName` |

Do not expose a wrapper until its argument names, nullability, return type and generated imports are confirmed in the target project.

### C. Connect page actions

- HomePage: call Solar, civil Hijri and prayer wrappers on page load/date change.
- CalendarPage: call Solar conversion for the selected Gregorian date; previous/next month updates the Solar year/month state, not Gregorian month state.
- PrayerTimesPage: recalculate when city, date, Asr method or angle settings change.
- SettingsPage: persist stable city ID and Asr factor; default factor remains 2 (Hanafi).
- PopulationPage: do not connect until exact source CSVs are restored and checksums match.

### D. Compile and test in FlutterFlow

1. Compile Custom Functions.
2. Compile Custom Actions/Widgets if the editor requires it for preview.
3. Add each wrapper to a temporary test page before using it on production pages.
4. Test invalid dates and out-of-range coordinates.
5. Compare the output JSON against the test fixtures in `test/flutterflow_migration_functions_test.dart`.
6. Verify Pashto/Dari/English labels and RTL/LTR layout.
7. Keep a screenshot or written record of successful compile and preview tests.

## Known calculation limitations — must remain visible

- Solar Hijri: current March-21 / 33-year cycle logic is provisional. It must not be labelled official or production-accurate until checked against an authoritative Afghan calendar corpus over multiple years.
- Islamic Hijri: civil/tabular calculation only; local moon-sighting may differ by one day.
- Prayer times: approximate solar calculation; Fajr/Isha angles and local method need validation against trusted Afghan timetables. Sunrise is not a prayer.
- City coordinates and UTC/timezone behavior require final verification.

## GitHub / VS Code workflow

FlutterFlow's VS Code Extension supports syncing and editing Custom Actions, Custom Widgets, Custom Functions and package dependencies. Pull the latest FlutterFlow changes before local edits, and push local custom-code changes back before testing them in FlutterFlow. A push can overwrite corresponding custom-code files in the project, so review the modified-file list and avoid mixing unpulled visual-builder changes with local edits.

The extension is not a way to convert a conventional Flutter application's entire UI into editable FlutterFlow pages. Continue rebuilding the page layout with FlutterFlow's visual builder.

## Official FlutterFlow references

- Writing Custom Code: https://docs.flutterflow.io/concepts/custom-code/
- Code Files: https://docs.flutterflow.io/concepts/custom-code/code-file/
- VS Code Extension: https://docs.flutterflow.io/concepts/custom-code/vscode-extension/
- Common Custom Code Examples: https://docs.flutterflow.io/concepts/custom-code/common-examples/

## Completion checklist

- [ ] Code File created in the actual FlutterFlow project.
- [ ] Full helper class accepted by the FlutterFlow parser.
- [ ] Wrappers created with exact input/output types.
- [ ] All wrappers compile.
- [ ] Temporary test page returns expected JSON.
- [ ] HomePage and CalendarPage use the wrappers.
- [ ] PrayerTimesPage outputs checked against local timetable references.
- [ ] Solar algorithm validation completed before public release.
