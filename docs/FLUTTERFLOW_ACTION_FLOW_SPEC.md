# FlutterFlow Action-Flow Specification

**Project:** Afghan Ghazali Calendar  
**Preparation branch:** `flutterflow/migration-prep`  
**Status:** Implementation contract; action flows below have not yet been configured in the owner's FlutterFlow canvas.

This document turns the page blueprint and App State contract into concrete FlutterFlow action sequences. Build the first three pages with local state and tested calculation outputs before provisioning a backend or exposing source-sensitive datasets.

## 1. Shared conventions

- Stable identifiers are stored in state; translated labels are display-only.
- Date-only values use `YYYY-MM-DD` local calendar strings, not UTC timestamps.
- Default language is `ps`; language changes must also change text direction.
- Default city is `kabul`; default Asr factor is `2` (Hanafi). Factor `1` means Standard.
- Keep the calculation disclaimers visible wherever their outputs are displayed.
- Never convert missing population values to zero.
- Do not expose unverified population, boundary or agriculture records in the ordinary user flow.

## 2. App State — create these variables first

Use the existing contract in `FLUTTERFLOW_APP_STATE.md`. The following initialization and update rules are mandatory:

| Variable | Initialize / update rule |
|---|---|
| `appLanguage` | Initialize to `ps`; only allow `ps`, `fa`, `en`. |
| `themeMode` | Initialize to `system`; allow `system`, `light`, `dark`. |
| `selectedDateIso` | Set to today's local date as `YYYY-MM-DD`; do not use a UTC date conversion. |
| `selectedCityId` | Initialize to `kabul`; store the stable city ID. |
| `asrFactor` | Initialize to integer `2`; only allow `1` or `2`. |
| `fajrAngle`, `ishaAngle` | Use provisional defaults `18.0` and `17.0`; mark as calculation settings, not verified local standards. |
| `utcOffsetHours` | Afghanistan current offset `4.5`; replace fixed-offset handling with a timezone-aware approach before supporting other countries or future timezone changes. |
| `selectedProvincePcode`, `selectedDistrictPcode` | Initialize empty; store P-codes, never localized names. |
| `populationDatasetId` | Initialize empty unless an approved dataset is configured. |
| `populationMeasure` | Initialize to `population_total`. |
| `showDraftData` | Initialize false; do not add a normal-user toggle for this variable. |

Persist preferences (language, theme, city and Asr method). Persisting a selected date is optional; if enabled, restore it only after validating the stored date string.

## 3. HomePage action flows

### On Page Load

1. Read `appLanguage`, `selectedDateIso`, `selectedCityId`, `asrFactor`, `fajrAngle`, `ishaAngle`, and `utcOffsetHours`.
2. If `selectedDateIso` is empty or invalid, set it to today's local date.
3. Call the Solar date JSON function with `selectedDateIso`.
4. Call the civil Hijri JSON function with `selectedDateIso`.
5. Resolve city coordinates from the fixed six-city configuration using `selectedCityId`.
6. Call the prayer-time JSON function with the selected date, coordinates and calculation settings.
7. Bind returned JSON fields to the date card and prayer summary.
8. If any calculation fails, show a visible error/empty state; never display stale values as if they were current.

### Language selector — On Change

1. Validate the new value is one of `ps`, `fa`, `en`.
2. Set App State `appLanguage`.
3. Allow FlutterFlow localization to refresh translated strings.
4. Set page direction to RTL for `ps` and `fa`, LTR for `en` (use a conditional page/component layout if project-level direction cannot be bound).
5. Keep city IDs, P-codes and ISO dates unchanged.

### City selector — On Change

1. Set `selectedCityId` to the selected stable ID.
2. Resolve latitude/longitude from the city configuration.
3. Re-run the prayer calculation for `selectedDateIso`.
4. Update prayer values and the city label together.
5. If the calculation fails, show the error state and do not retain old-city times under the new city label.

### Calendar shortcut

Navigate to `CalendarPage` and pass `selectedDateIso` if the page uses a page parameter. Otherwise read the shared App State variable.

## 4. CalendarPage action flows

### On Page Load

1. Read `selectedDateIso`.
2. Convert it to the provisional Solar Hijri year/month/day.
3. Set page state for the displayed Solar year and month.
4. Build the month grid with Saturday as weekday index zero.
5. For every visible date cell, display the Solar day and Gregorian date; add civil Hijri only if the conversion is available.
6. Keep a clear provisional-calendar notice until the algorithm passes official multi-year validation.

### Previous Month / Next Month

Use a Solar month pair, not Gregorian date arithmetic:

- Previous: if month is 1, set month to 12 and decrement year; otherwise decrement month.
- Next: if month is 12, set month to 1 and increment year; otherwise increment month.
- Rebuild the grid using the Solar month length helper.
- Never allow day 30 in month 12 unless the current provisional leap rule returns 30; this is still not official validation.

### Select Date Cell

1. Convert the selected Solar year/month/day to a Gregorian ISO date.
2. If conversion succeeds, set `selectedDateIso`.
3. Refresh selected-date Solar, Gregorian and civil Hijri details.
4. Recalculate prayer times for the selected date and current city.
5. Visually mark the selected cell.
6. If conversion fails, retain the previous selected date and show a clear error.

### Today button

Set `selectedDateIso` to today's local date, convert it to the displayed Solar month, select the corresponding cell and refresh dependent data.

## 5. PrayerTimesPage action flows

### On Page Load

1. Read selected date, city, Asr factor, Fajr/Isha angles and UTC offset.
2. Resolve city coordinates.
3. Calculate all six values: Fajr, Sunrise, Dhuhr, Asr, Maghrib and Isha.
4. Show Sunrise in its own row and label it as sunrise, not a prayer.
5. Display method metadata and an approximate-calculation disclaimer.

### Asr method selector

- Hanafi sets `asrFactor = 2`.
- Standard sets `asrFactor = 1`.
- Persist the new value, recalculate, and update the method label in the same action flow.

### City / date change

Recalculate from the latest selected city and date. Avoid parallel action flows that could finish out of order and overwrite a newer selection.

## 6. SettingsPage action flows

- Language: update `appLanguage`; verify localized strings and RTL/LTR direction.
- Theme: update `themeMode` and apply the matching theme mode.
- City: update `selectedCityId`; Home and Prayer pages recalculate on next load or immediately if kept mounted.
- Asr: update `asrFactor` (1 or 2) and persist.
- Advanced Fajr/Isha angle controls: hide under an advanced section; validate range greater than 0 and at most 30; keep defaults explicitly marked provisional.
- Reset preferences: restore language `ps`, theme `system`, city `kabul`, Asr factor `2`, and provisional angles; do not clear approved source records.

## 7. Province and district explorer

- Search by localized label, but select and navigate using P-code.
- When province changes, clear `selectedDistrictPcode` unless the chosen district belongs to that province.
- Show verification status and source provenance with each record.
- Keep the draft 401-unit selector distinct from the 457 ADM2 population estimate rows. Do not silently merge labels or codes.
- If a query returns no record, show an empty state; do not invent a district or substitute a similarly named unit.

## 8. Population page — release gate

The page may be visually built with a disabled/empty state, but must not show live figures until all gates pass:

1. Re-ingest the exact original ADM0, ADM1 and ADM2 CSV files.
2. Verify the three expected SHA-256 checksums in `population-2027-ingestion.md`.
3. Confirm publisher, source URL, publication date, licence and methodology.
4. Preserve raw source values and missingness markers.
5. Verify P-code joins and complete-only aggregations.
6. Register the dataset as reviewed/approved before selecting it in `populationDatasetId`.

A missing, blank, hyphen or NULL value is not zero. Do not publish the draft dataset simply because its arithmetic totals reconcile.

## 9. Agriculture, maps and reports

- Agriculture: show a “verified recommendations are not available yet” empty state until each recommendation has a source, location, season/date and review status.
- Maps: do not add boundary polygons until geometry source, administrative version and licence are confirmed.
- Reports: only export records with source, reference date/year, unit and methodology; include a note for estimates and missing values.

## 10. Build and QA checklist

For each page, test:

- [ ] Phone and tablet/web responsive layouts.
- [ ] Pashto and Dari RTL; English LTR.
- [ ] Language changes do not alter stable IDs or data.
- [ ] All controls trigger real actions.
- [ ] Empty, loading and error states are visible.
- [ ] Date boundaries: Solar month 1/12, leap/non-leap Esfand, Gregorian year boundary.
- [ ] Prayer calculations update after city/date/Asr changes.
- [ ] Sunrise is not described as a prayer.
- [ ] No draft/unverified dataset is shown as official.
- [ ] No missing population value is rendered as zero.

## 11. Integration status

This specification is ready to follow in FlutterFlow. It does not mean the visual pages, action flows, database or Code File have been created in the actual FlutterFlow project. Record parser/compile results and preview screenshots after the owner performs those steps.
