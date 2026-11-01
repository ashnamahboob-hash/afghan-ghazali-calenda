# FlutterFlow Manual Build Guide — First Working Version

**Target project:** `afghan-ghazali-calendar-zqicpn`  
**Status:** Build instructions only. The FlutterFlow canvas has not been edited by this repository workflow.

This guide is intentionally staged: make a working read-only shell first, then add calculation features, then source-backed datasets. Do not connect an unverified dataset to a public page.

## 0. Before building pages

1. Open the owner-created FlutterFlow project.
2. Confirm Pashto, Dari and English are configured. Set Pashto as the default.
3. Set the theme to Material 3 with deep green primary, muted gold accent, warm off-white light background and charcoal dark background.
4. Use a readable font with correct Arabic-script shaping. Verify Pashto and Dari RTL on an actual preview, not only in the settings panel.
5. Create App State variables exactly as listed in `FLUTTERFLOW_APP_STATE.md`.
6. Do not connect this FlutterFlow project to the original app repository's `main` branch. If GitHub integration is used, create/use a dedicated FlutterFlow repository.

## 1. Build order

For exact page-load, selector-change, navigation, error and data-release action sequences, follow [`FLUTTERFLOW_ACTION_FLOW_SPEC.md`](FLUTTERFLOW_ACTION_FLOW_SPEC.md) alongside this visual widget guide.

Build and preview one page at a time in this order:

1. **App shell + HomePage** — header, date card, prayer summary, navigation.
2. **CalendarPage** — Solar month header, Saturday-first weekday row, date grid and selected-day panel.
3. **PrayerTimesPage** — city selector, Asr method selector, six time rows and method disclaimer.
4. **SettingsPage** — language, theme, city and prayer calculation preferences.
5. **ProvinceExplorerPage** — searchable 34-province list, then administrative-unit detail.
6. **PopulationPage** — build only after the exact source CSV payloads have been re-ingested and metadata reviewed.
7. **AgriculturePage** — show an explicit “no verified advice yet” empty state until source-backed advisory rows exist.
8. **MapsPage + ReportsPage** — defer until geometry, source metadata and export rules are ready.
9. **AboutPage** — sources, limitations, licence notices and maintainer details supplied by the owner.

## 2. HomePage — exact widget tree

Use a responsive `Scaffold` / page shell with a scrollable `Column`:

- `AppBar`
  - app title
  - compact language dropdown
  - optional theme toggle
- `TodayTripleDateCard` (build as a reusable Component)
  - Solar date (largest text)
  - Gregorian date
  - civil Hijri date
  - small civil-Hijri moon-sighting disclaimer
- `MiniSolarCalendar` (reusable Component)
  - month label
  - previous / next buttons
  - compact 7-column grid
  - “View calendar” action
- `PrayerSummaryCard`
  - selected city
  - Fajr, Dhuhr, Asr, Maghrib, Isha
  - sunrise shown separately
  - “All prayer times” action
- `QuickAccessGrid`
  - Calendar
  - Prayer times
  - Provinces
  - Population
  - Agriculture
- `DataStatusFooter`
  - calculation/data status, not decorative badges

On mobile, use a bottom navigation bar for Home, Calendar, Prayer and Explore/More. On tablet/web, use a NavigationRail or side navigation. All navigation items must have real page actions.

## 3. CalendarPage

Recommended widget tree:

- Page header with Solar month and year
- Row: previous month / current month title / next month
- Seven weekday labels beginning Saturday
- GridView with 7 columns; cells show:
  - Solar day (prominent)
  - Gregorian day (small)
  - civil Hijri day (small, if available)
- Selected-date detail card
- “Today” action

Use a single selected Solar year/month state. Previous/next actions must update the Solar month pair and correctly cross the year boundary. Do not use Gregorian month navigation. The current Solar conversion helper remains provisional; label it as such until official boundary/leap-year validation is completed.

## 4. PrayerTimesPage

- City Dropdown: stable IDs `kabul`, `kandahar`, `herat`, `mazar_e_sharif`, `jalalabad`, `kunduz`.
- Segmented control: Hanafi (factor 2, default) / Standard (factor 1).
- Six rows: Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha.
- Expandable “Calculation details” section for angles, UTC offset and verification note.
- Clearly state that values are approximate until checked against trusted local timetables.

Do not describe sunrise as a prayer. Do not imply religious authority approval.

## 5. Reusable components

Create these FlutterFlow Components before duplicating layouts:

| Component | Inputs | Purpose |
|---|---|---|
| `AppHeader` | title, languageCode | Shared title and language control |
| `TodayTripleDateCard` | solar, gregorian, hijri, status | Three-calendar date card |
| `MiniSolarCalendar` | solarYear, solarMonth, selectedDate | Compact month preview |
| `PrayerTimeRow` | label, time, isHighlighted | Consistent prayer row |
| `SourceMethodologyPanel` | source, year, unit, method, status | Provenance on data pages |
| `EmptyVerifiedDataState` | title, message | Safe empty state |
| `PcodeListTile` | pcode, localizedName, type, status | Geography result row |

Prefer native FlutterFlow widgets. Add a Custom Widget only when a native component cannot meet a documented requirement.

## 6. Data and calculation integration gates

- Solar Hijri: do not call production-ready until algorithm and leap years are validated against an official multi-year corpus.
- Civil Hijri: always disclose that local moon sighting can differ by one day.
- Prayer times: compare all six cities with trusted local timetables and record tolerances before release.
- Population: do not expose the 2027 estimates until the three original CSVs are restored, SHA-256 verified, source publisher/licence reviewed, and the dataset is registered separately from the 401-unit selector.
- Agriculture: keep the public list empty until each advisory has a verifiable source, location, date/season, and review status.
- Maps: no boundary layer until source geometry and licence are confirmed.

## 7. Acceptance check after each page

- Preview phone and tablet/web breakpoints.
- Switch Pashto ↔ Dari ↔ English and verify RTL/LTR, alignment, number formatting and clipping.
- Tap every button and dropdown; no decorative inactive controls.
- Test loading, empty and error states.
- Confirm no placeholder text, unverified statistic or invented source is visible as a real feature.

## 8. What is still manual

GitHub can hold and validate the migration source, test cases and instructions. It cannot draw or configure the FlutterFlow visual canvas through this repository alone. The owner must open the FlutterFlow project and create/sync the visual pages. The next manual milestone is the HomePage widget tree in section 2.
