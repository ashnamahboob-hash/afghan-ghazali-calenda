# FlutterFlow Code File — First Preview Smoke Test

**Purpose:** Verify the first custom-code integration in the actual FlutterFlow builder before wiring calculations into the HomePage.

This is a manual acceptance checklist. The Code File has not been parsed in the owner's FlutterFlow project by this repository workflow.

## Before starting

- Open the FlutterFlow project `afghan-ghazali-calendar-zqicpn`.
- Create a working branch in FlutterFlow before changing custom-code layout or project-wide settings.
- Add a Code File named `afghan_ghazali_functions` and paste the helper from this repository branch.
- Use the editor's Validate, then Parse controls. Resolve errors without deleting calculation logic.
- Confirm FlutterFlow detects the `AfghanGhazaliFunctions` class and its static methods.

Official reference: [FlutterFlow Code File documentation](https://docs.flutterflow.io/concepts/custom-code/code-file/).

## Temporary test page

Create a temporary page called `CodeTestPage`. Add a scrollable Column containing four test sections. Use **Call Static Method** actions and save each String result into a separate Page State String variable, then bind a Text widget to each result.

### Test 1 — Solar date

| Setting | Value |
|---|---|
| Class | `AfghanGhazaliFunctions` |
| Static method | `solarDateFromGregorianJson` |
| Input | `isoDate = 2026-04-01` |
| Expected | Valid JSON; `solarYear=1405`, `solarMonth=1`, `solarDay=12`, `monthNamePs=وری`, `algorithmStatus=provisional` |

This expected value matches the repository's current provisional implementation and its unit test. It is not evidence that the calendar algorithm is officially validated.

### Test 2 — Civil Hijri date

| Setting | Value |
|---|---|
| Static method | `civilHijriFromGregorianJson` |
| Input | `isoDate = 2024-03-11` |
| Expected | Valid JSON; `hijriYear=1445`, `hijriMonth=9`, `hijriDay=1`, `calendarType=civil_tabular` |

Keep the local moon-sighting disclaimer visible in the actual page.

### Test 3 — Kandahar city record

| Setting | Value |
|---|---|
| Static method | `cityConfigurationJson` |
| Input | `cityId = kandahar` |
| Expected | Valid JSON; `id=kandahar`, `latitude=31.6289`, `longitude=65.7372`, `namePs=کندهار` |

Coordinates are inherited from the existing app and still need independent geographic verification before public release.

### Test 5 — One-call Home dashboard payload (recommended first integration)

| Setting | Value |
|---|---|
| Static method | `homeDashboardJson` |
| Inputs | `isoDate = 2026-04-01`, `cityId = kandahar`, `asrFactor = 2` |
| Expected | Valid JSON containing nested `solar`, `gregorian`, `hijri`, `city`, `prayerTimes`, and `status` objects; Solar sample 1405/1/12; Kandahar city ID; Hanafi prayer metadata |

This single positional call is the preferred HomePage integration because it avoids several separate action calls and does not require configuring named arguments.

### Test 6 — Positional city prayer wrapper

| Setting | Value |
|---|---|
| Static method | `prayerTimesForCityJson` |
| Inputs | `isoDate = 2026-06-21`, `cityId = kandahar`, `asrFactor = 2` |
| Expected | Six non-empty time fields and `asrMethod=Hanafi` |

### Test 4 — Prayer-time JSON

| Setting | Value |
|---|---|
| Static method | `calculatePrayerTimesJson` |
| Input | `isoDate=2026-06-21`, `latitude=31.6289`, `longitude=65.7372`, `utcOffsetHours=4.5`, `fajrAngle=18.0`, `ishaAngle=17.0`, `asrFactor=2` |
| Expected | Valid JSON with non-empty `fajr`, `sunrise`, `dhuhr`, `asr`, `maghrib`, `isha`; `asrMethod=Hanafi`; `calculationStatus=approximate` |

Do not require exact minute equality against a local mosque timetable at this smoke-test stage. A separate validation study is required before release.

## If Call Static Method does not expose a method

1. Capture the exact editor error or unavailable method name.
2. Confirm the Code File parsed successfully and that the method is declared `static`.
3. Do not add a Custom Function import; FlutterFlow Custom Functions cannot import arbitrary Code Files.
4. Use a Custom Action fallback only after generating its boilerplate in FlutterFlow and confirming the supported import path.
5. Record the workaround and test result in the migration status document.

## Acceptance record

Mark each item only after it is visibly verified in FlutterFlow:

- [ ] Code File Validate succeeds.
- [ ] Code File Parse succeeds and detects the class.
- [ ] Solar date method returns expected JSON.
- [ ] Civil Hijri method returns expected JSON.
- [ ] Kandahar city method returns expected JSON.
- [ ] Prayer method returns all six named clock fields.
- [ ] Invalid-input handling does not silently return a plausible date/time.
- [ ] Screenshot of the temporary test page is saved for the project record.
- [ ] Only after these checks, connect the methods to HomePage.

## Important boundary

A passing repository-side Flutter test does not prove that FlutterFlow's parser, generated action editor, or preview runtime accepts the Code File. The acceptance record above must be completed in the actual FlutterFlow project.
