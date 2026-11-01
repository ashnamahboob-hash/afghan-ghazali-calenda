# FlutterFlow Custom Logic Map

**Purpose:** Map existing Dart services to FlutterFlow Custom Functions, Custom Actions and Custom Widgets. This is a design contract, not a claim that the code has already been imported or compiled in FlutterFlow.

## 1. Afghan Solar Hijri calendar

Source: `lib/services/afghan_calendar.dart`

Existing concepts:
- Afghan month names in Pashto, Dari and English.
- `fromGregorian(DateTime)`
- `toGregorian(year, month, day)`
- `daysInMonth(year, month)`
- `isLeapYear(year)`
- `monthName(month, language)`
- `formatNumber(value, language)`
- `weekdayNames(language)`

Suggested FlutterFlow Custom Functions:
- `solarDateFromGregorian(year, month, day)` → structured JSON/map: solarYear, solarMonth, solarDay, weekdayIndex
- `solarDateToGregorian(solarYear, solarMonth, solarDay)` → ISO date string
- `solarDaysInMonth(solarYear, solarMonth)` → integer
- `solarMonthName(solarMonth, languageCode)` → string
- `localizedDigits(value, languageCode)` → string

**Critical blocker:** current engine explicitly uses March 21 and a provisional 33-year leap cycle. Do not port this as official calendar logic until validated against official Afghanistan calendar data across years and boundary dates. Retain a test corpus and document any correction.

## 2. Civil Hijri calendar

Source: `lib/services/islamic_calendar.dart`

Suggested Custom Function:
- `civilHijriFromGregorian(year, month, day)` → JSON/map: hijriYear, hijriMonth, hijriDay

Keep the existing disclaimer: this is arithmetic/tabular, not local moon-sighting. UI must state that local announcements can differ by one day.

## 3. Prayer-time calculation

Source: `lib/services/prayer_times.dart`; city coordinates currently reside in `lib/screens/home_screen.dart`.

Suggested Custom Action (preferred if returning multiple values cleanly):
- `calculatePrayerTimes(dateIso, latitude, longitude, utcOffsetHours, fajrAngle, ishaAngle, asrFactor)`
- Return JSON with fajr, sunrise, dhuhr, asr, maghrib, isha as local ISO date-time strings plus method metadata.

Inputs must be validated:
- latitude: -90..90
- longitude: -180..180
- UTC offset: -14..14
- Fajr/Isha angles: >0..30
- Asr factor: 1 or 2

Current implementation is an offline solar approximation. Preserve Hanafi default factor 2 and Standard factor 1, but do not imply local religious authority approval. Verify timezone handling and local timetable before production.

## 4. Administrative reference

Source: `lib/services/administrative_reference.dart` and `assets/data/afghanistan_admin_divisions_reference_draft.json`.

Suggested operations:
- `searchAdministrativeUnits(query, provincePcode?)`
- `getProvinceByPcode(pcode)`
- `getAdministrativeUnitByPcode(pcode)`

Prefer backend queries for search at scale. If bundled JSON is used, expose the draft/verification status in the UI. Current runtime parser asserts 34 provinces and 401 unique units. This does not make the names officially verified.

## 5. Population

Source: `lib/services/population_2027_dataset.dart`, population ingestion/audit scripts and docs.

Suggested operations:
- `getNationalPopulationSummary(datasetId, referenceYear)`
- `getPopulationByProvince(provincePcode, datasetId)`
- `getPopulationByAdministrativeCode(pcode, datasetId)`
- `getPopulationBreakdown(pcode, measureCode, filters)`

Use database views/queries for aggregation where possible; do not place the full 457-row dataset in App State. The existing CSV parser keeps field values as strings and validates required columns, duplicate P-codes and parent-code presence. Preserve raw values and missing markers.

The supplied 2027 estimates total 50,489,104 and reconcile across levels in the audit, but publisher provenance/licence/methodology are not yet confirmed. UI must show “estimate” and the source verification status.

## 6. Agriculture

Source: `lib/screens/agriculture_screen.dart`, `assets/data/agricultural_advisory.json`, schema and policy.

Suggested query/action:
- `getVerifiedAdvisories(provincePcode, districtPcode, cropId, season)`

Return only approved, valid, geographically applicable records by default. If no record exists, return an empty list and show the localized no-verified-guidance message. Never recreate the screen's former hard-coded sowing windows as verified advice.

## 7. Custom Widgets (only if native FlutterFlow widgets are insufficient)

- `TripleDateCell`: compact date cell with Solar, Gregorian and civil Hijri dates; use native widgets first.
- `SolarMonthCalendarGrid`: custom widget only if native GridView/Calendar widgets cannot meet Saturday-first and month-navigation requirements.
- `PopulationTrendChart`: use FlutterFlow chart components first; custom chart only for a documented missing capability.
- `AdministrativeMapLayer`: defer until verified geometry and map-provider choice are settled.

Each Custom Widget must expose simple serializable parameters, support RTL/LTR, handle loading/empty/error states, and avoid embedding business rules that should live in tested functions.

## 8. Test contracts

Port or reproduce tests for:
- solar conversion round trips, leap years, month lengths, New Year boundaries;
- civil Hijri conversion and disclaimer state;
- prayer inputs, city coordinates, Asr factor 1/2, timezone/day-boundary behavior;
- P-code uniqueness, parent hierarchy and draft status;
- population totals, missing markers, 457 vs 401 joins and source labels;
- agricultural advice source/geographic validity;
- Pashto/Dari RTL and English LTR;
- responsive navigation and all interactive controls.

### Population integrity helpers added for FlutterFlow

Portable functions in `flutterflow_custom_code/lib/afghan_ghazali_functions.dart`:
- `populationCellJson(rawValue)`: retains exact raw literal and distinguishes blank, hyphen, NULL, numeric and unparsed values.
- `sumPopulationCellsJson(rawValuesJson)`: returns a publishable total only if every supplied value is numeric; partial sums are marked audit-only.
- `comparePcodeSetsJson(sourceCodesJson, referenceCodesJson)`: exposes matched, source-only, reference-only and duplicate codes without silently discarding rows.

These functions support data integrity but do not resolve provenance or verify the supplied 2027 estimates.
