# FlutterFlow Custom Code Setup Guide

This guide describes how to transfer the portable Dart helper layer into the owner-created FlutterFlow project.

## Source files prepared in GitHub

- `flutterflow_custom_code/lib/afghan_ghazali_functions.dart` — dependency-free calculation layer.
- `test/flutterflow_migration_functions_test.dart` — Flutter tests for the portable helpers.

These files are prepared in the `flutterflow/migration-prep` branch of the original source repository. They are not automatically imported into the FlutterFlow project by being present here.

## Recommended FlutterFlow setup

Create the custom functions only after connecting FlutterFlow to its dedicated repository/branch. Keep the generated FlutterFlow repository separate from the original source repository.

### Custom Function A — Solar date JSON

- Name: `solarDateFromGregorianJson`
- Return type: String
- Argument: `isoDate` String
- Implementation: call `AfghanGhazaliFunctions.solarDateFromGregorianJson(isoDate)`

### Custom Function B — Solar date to Gregorian JSON

- Name: `solarDateToGregorianJson`
- Return type: String
- Arguments: `solarYear` int, `solarMonth` int, `solarDay` int
- Implementation: call `AfghanGhazaliFunctions.solarDateToGregorianJson(solarYear, solarMonth, solarDay)`

### Custom Function C — Civil Hijri JSON

- Name: `civilHijriFromGregorianJson`
- Return type: String
- Argument: `isoDate` String
- Implementation: call `AfghanGhazaliFunctions.civilHijriFromGregorianJson(isoDate)`

### Custom Function D — Solar month name

- Name: `solarMonthName`
- Return type: String
- Arguments: `month` int, `languageCode` String
- Implementation: call `AfghanGhazaliFunctions.solarMonthName(month, languageCode)`

### Custom Function E — Hijri month name

- Name: `hijriMonthName`
- Return type: String
- Arguments: `month` int, `languageCode` String
- Implementation: call `AfghanGhazaliFunctions.hijriMonthName(month, languageCode)`

### Custom Function F — Localized digits

- Name: `localizeDigits`
- Return type: String
- Arguments: `value` String, `languageCode` String
- Implementation: call `AfghanGhazaliFunctions.localizeDigits(value, languageCode)`

### Custom Action G — Prayer time JSON

- Name: `calculatePrayerTimesJson`
- Return type: String
- Arguments:
  - `isoDate` String
  - `latitude` double
  - `longitude` double
  - `utcOffsetHours` double (default 4.5)
  - `fajrAngle` double (current source default 18.0; provisional)
  - `ishaAngle` double (current source default 17.0; provisional)
  - `asrFactor` int (default 2 / Hanafi)
- Implementation: call `AfghanGhazaliFunctions.calculatePrayerTimesJson(...)`

The exact FlutterFlow custom-code editor may wrap function bodies in generated boilerplate. Keep the portable helper class in a custom-code file supported by the connected FlutterFlow project, then add a supported import to the generated custom-functions/actions file. Do not hand-edit generated files unless the FlutterFlow GitHub integration explicitly supports that workflow; generated files may be overwritten by subsequent syncs.

### City configuration helpers

- `supportedCitiesJson()` — returns the six city IDs, localized labels and source-app coordinates.
- `cityConfigurationJson(cityId)` — returns one city configuration by stable ID.

Use the stable IDs `kabul`, `kandahar`, `herat`, `mazar_e_sharif`, `jalalabad`, and `kunduz` in App State and database relations. The coordinates are copied from the existing app and still require geographic verification before production.

## Reading JSON results in FlutterFlow

The functions return a JSON string to keep their interface simple and serializable. Use FlutterFlow's JSON parsing / Get JSON Field actions with these paths:

- Solar: `$.solarYear`, `$.solarMonth`, `$.solarDay`, `$.monthNamePs`, `$.algorithmStatus`
- Gregorian conversion: `$.isoDate`, `$.year`, `$.month`, `$.day`
- Hijri: `$.hijriYear`, `$.hijriMonth`, `$.hijriDay`, `$.monthNamePs`
- Prayer: `$.fajr`, `$.sunrise`, `$.dhuhr`, `$.asr`, `$.maghrib`, `$.isha`, `$.asrMethod`, `$.calculationStatus`

## Important validation notices

1. Solar conversion is explicitly marked `provisional`. Do not remove the warning until the leap-year and New Year boundary logic is verified against official Afghanistan calendar references across a multi-year corpus.
2. Civil Hijri is arithmetic/tabular; local moon sighting may differ by one day.
3. Prayer times are approximate and must be compared with a trusted local timetable for all six supported cities before being presented as authoritative.
4. Current Fajr/Isha angles are inherited from the source implementation, not independently endorsed.
5. Afghanistan's local UTC offset is currently +4.5 hours. Keep it configurable and use an IANA timezone in any future timestamp-based scheduling.
6. All returned times are local clock strings. They do not contain a date or timezone offset.

## Population-safe helpers

The portable helper file also includes functions for population and administrative joins:

### Custom Function H — Population cell parser

- Name: `populationCellJson`
- Return type: String
- Argument: `rawValue` String (nullable if FlutterFlow supports nullable String inputs)
- Returns `sourceValueRaw`, `numericValue`, and `valueStatus`.
- Missing blank cells, literal hyphens and literal NULL markers remain missing, never zero.

### Custom Function I — Safe population sum

- Name: `sumPopulationCellsJson`
- Return type: String
- Argument: `rawValuesJson` String containing a JSON array of original source values.
- Returns a complete `value` only when every input is numeric. Otherwise `value=null`, with a separate `partialSumForAuditOnly` and missing count.

### Custom Function J — P-code set comparison

- Name: `comparePcodeSetsJson`
- Return type: String
- Arguments: `sourceCodesJson` String and `referenceCodesJson` String; each is a JSON array of P-code strings.
- Returns matched, source-only and reference-only codes, and duplicate-code lists.
- This helper does not alter either dataset or promote draft administrative codes to verified status.

JSON paths:
- Cell: `$.sourceValueRaw`, `$.numericValue`, `$.valueStatus`
- Sum: `$.value`, `$.partialSumForAuditOnly`, `$.missingCount`, `$.valueStatus`
- P-code compare: `$.matched`, `$.sourceOnly`, `$.referenceOnly`, `$.duplicateSourceCodes`, `$.duplicateReferenceCodes`

## Verification

The source repository's Flutter validation workflow runs `flutter analyze` and `flutter test` on changes to `test/**`. The helper test file checks the known tabular Ramadan 1445 date, Solar round-trip behavior under the provisional algorithm, language labels, prayer-time ordering, Hanafi/Standard Asr difference and invalid input rejection.
