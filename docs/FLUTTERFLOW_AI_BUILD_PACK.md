# Afghan Ghazali Calendar — FlutterFlow AI Build Pack

**Target FlutterFlow project:** `afghan-ghazali-calendar-zqicpn`  
**Preparation branch:** `flutterflow/migration-prep`  
**Purpose:** Reduce manual widget-by-widget work by using FlutterFlow Designer / AI Page Generator for the visual skeleton, then connect the already-parsed `AfghanGhazaliFunctions` Code File through action flows.

> Important: This pack is a set of ready-to-paste design prompts and implementation instructions. It does not automatically write into the owner's FlutterFlow canvas. Generate each page in FlutterFlow, inspect it, then connect real actions. Do not present placeholder dates, prayer times or statistics as live data.

## 1. Design system

- Product name: **افغان غزالي کلیزه** / **Afghan Ghazali Calendar**
- Visual direction: contemporary Afghan cultural utility; calm, trustworthy, clean and readable; subtle geometric / Islamic pattern accents only, no crowded ornament.
- Primary: deep evergreen `#145A32`
- Dark green: `#0B3D2E`
- Accent gold: `#C6A15B`
- Light background: `#F7F8F4`
- Surface: `#FFFFFF`
- Soft green surface: `#E8F2E9`
- Main text: `#17231C`
- Secondary text: `#66736A`
- Warning: `#A66A16`
- Error: `#B3261E`
- Radius: 16 px cards, 12 px controls, pill only for small filters.
- Spacing: 8 px base rhythm; 16 px page padding; 12–16 px card gaps.
- Elevation: very subtle; prefer clean borders over heavy shadows.
- Typography: use a legible Arabic-script font with correct Pashto/Dari shaping; test the actual FlutterFlow preview. English may use a clean sans-serif.
- Language: Pashto default; Dari and English available. Pashto/Dari RTL; English LTR.
- Responsive: phone-first, tablet/web adapts to 2-column content and NavigationRail where appropriate.
- Accessibility: strong contrast, large tap targets, no meaning conveyed by color alone.

## 2. Master prompt — app visual direction

Paste this into FlutterFlow Designer / AI page generation when asked for the app's design direction:

"Design a polished, production-minded Afghan calendar and daily utility app named Afghan Ghazali Calendar (افغان غزالي کلیزه). The default language is Pashto with right-to-left layout; the app also supports Dari RTL and English LTR. Use a calm deep evergreen palette (#145A32, #0B3D2E), muted gold accent (#C6A15B), warm off-white background (#F7F8F4), white cards and soft green surfaces (#E8F2E9). Use rounded 16px cards, subtle borders, restrained shadows, clear hierarchy, generous spacing and highly legible Arabic-script typography. The app's main purpose is to show the Afghanistan Solar Hijri date, Gregorian date, civil/tabular Hijri date, prayer times for Afghan cities, calendar navigation, and carefully sourced Afghanistan geography, population and agriculture information. Avoid decorative clutter, fake charts, fake statistics, stock photos and invented data. Use reusable components and consistent spacing. Design phone-first and adapt gracefully to tablet/web. Use real navigation affordances and clear empty/loading/error states. Keep every visible label localizable."

## 3. HomePage — generate this page first

In FlutterFlow Page Selector, open HomePage and use the Designer / AI generation feature if available for the existing page. If it cannot modify an existing page, create a temporary generated page named `HomePageDraft`, inspect it, then transfer/replace the layout deliberately; do not delete the existing HomePage until the generated result is reviewed.

Paste prompt:

"Create a beautiful phone-first Home dashboard for Afghan Ghazali Calendar. Keep a compact deep-green app bar with the app name, a small language selector and optional theme control. Under it, place a prominent Today Triple-Date card with three clearly separated rows: Afghanistan Solar Hijri date (largest), Gregorian date, and civil/tabular Hijri date; include a small disclaimer that civil Hijri may differ from local moon sighting and mark Solar date calculation as provisional until officially verified. Next add a compact Solar calendar preview with month/year title, previous and next chevrons, Saturday-first weekday labels, a small 7-column date grid and a 'Full calendar' action. Add a Prayer Summary card showing selected Afghan city and six rows for Fajr, Sunrise, Dhuhr, Asr, Maghrib and Isha; visually distinguish Sunrise as not a prayer and show a concise approximate-calculation note. Add a 2-column Quick Access grid for Calendar, Prayer Times, Provinces, Population, Agriculture and Maps/Reports. Add a restrained data-status footer. Use deep evergreen, muted gold, soft green and white surfaces; 16px rounded cards; 16px page margins; clean RTL alignment; no fabricated live values. Use placeholder labels only where data binding will be connected later. Add a bottom navigation bar for Home, Calendar, Prayer and Explore. All buttons should have clear action affordances."

### HomePage component breakdown

Create reusable components from generated blocks where possible:

1. `TodayTripleDateCard`: solarDate, gregorianDate, hijriDate, solarStatus, hijriDisclaimer.
2. `MiniSolarCalendar`: solarYear, solarMonth, selectedSolarDay, onPrevious, onNext, onOpenCalendar.
3. `PrayerSummaryCard`: cityName, fajr, sunrise, dhuhr, asr, maghrib, isha, methodLabel, status.
4. `QuickAccessTile`: title, icon, destination/action.
5. `DataStatusFooter`: status text and source/method note.

FlutterFlow Components can be created from generated widget blocks and reused. Use component parameters for variable text/data rather than duplicating the same card six times.

## 4. CalendarPage prompt

"Design a full Afghanistan Solar Hijri calendar page in Pashto RTL. Use a compact header with the Solar month and year, previous/next month controls and a Today button. Weekday labels must begin Saturday. Show a clean 7-column calendar grid. Each day cell should prioritize the Solar day number and allow smaller Gregorian day text; civil Hijri day may appear as secondary text only if available. Highlight today and selected day with accessible contrast. Under the grid, show a selected-date details card with Solar, Gregorian and civil Hijri values and a moon-sighting disclaimer. Add an unobtrusive note that Solar conversion is provisional until verified against official Afghan calendar tables. Do not use Gregorian month navigation. Use the app's evergreen/gold design system and responsive layout."

## 5. PrayerTimesPage prompt

"Design a prayer times page for Afghanistan. At the top show a city selector for Kabul, Kandahar, Herat, Mazar-e-Sharif, Jalalabad and Kunduz. Include an Asr method segmented control with Hanafi selected by default and Standard as the alternative. Show six spacious time rows: Fajr, Sunrise, Dhuhr, Asr, Maghrib and Isha. Sunrise must be visually identified as sunrise, not a prayer. Show selected date and city. Add a collapsible calculation details section for Fajr/Isha angles, UTC offset and method. Display a clear note that times are approximate offline calculations and should be checked against a trusted local timetable. Use clear time typography, evergreen highlights and restrained gold accents; no invented times."

## 6. SettingsPage prompt

"Design a clean Settings page with grouped sections: Language (Pashto default, Dari, English), Appearance (System, Light, Dark), Default Afghan city, Asr calculation method (Hanafi default / Standard), and Advanced calculation settings (Fajr and Isha angles) inside a collapsed advanced section. Add an About and Sources link. Explain that changing language also changes RTL/LTR direction. Use switches, dropdowns and segmented controls with clear labels and generous tap targets. Do not include destructive reset actions without confirmation."

## 7. ProvinceExplorerPage prompt

"Design an Afghanistan province and district explorer. Add a searchable province list with a clean list tile for province name, optional verified administrative code and a chevron. On selection, show a province detail page with district list, search and source/version information. Keep the stable P-code separate from localized names. Show a neutral empty state when a record is unavailable. Do not invent boundaries, population values or district names. Distinguish the draft 401-unit selector reference from the separate 457 ADM2 population estimate records; never silently merge them."

## 8. PopulationPage prompt — safe empty state only

"Design a Population and Demographics page for Afghanistan, but show a professional empty/review state until source files, publisher, licence, methodology and P-code joins have been verified. Include clearly labelled slots for dataset name, reference year, source, methodology and geographic level. Do not show invented population totals, charts, rankings or estimates. Add a neutral notice: 'Verified population data is not yet available in this app.' The layout should be ready for future sourced cards and charts without pretending data is live."

## 9. AgriculturePage prompt — safe empty state only

"Design an Afghanistan Agriculture information page with category filters for crops, planting seasons, irrigation and provincial guidance. For now show a helpful empty/review state explaining that verified, location-specific agricultural recommendations are being prepared. Do not invent planting dates, fertilizer rates, yields or advice. Future advice cards must have source, location, season/reference date and review status. Use calm green agricultural visual language without stock-photo clutter."

## 10. MapsPage and ReportsPage prompts — defer live layers

Maps:
"Design an Afghanistan map explorer shell with a map placeholder area, province/district selector, layer legend and source/version panel. Do not draw invented administrative boundaries or claim geospatial accuracy. Show a clear 'verified boundary layer not yet connected' state."

Reports:
"Design a reports page with report categories for calendar, prayer timetable, geography and population. Include export controls only as disabled/coming-soon until verified data and export actions are connected. Every future report must display source, reference date/year, units and methodology."

## 11. AboutPage prompt

"Design an About and Sources page for Afghan Ghazali Calendar. Include app purpose, supported languages, calculation-method notes, data-source register, version and maintainer contact placeholder. Clearly distinguish provisional Solar calendar calculation, civil/tabular Hijri conversion and approximate prayer-time calculation. Do not claim official approval or religious authority validation."

## 12. Connect the parsed Code File

The owner has reported that `my_class.dart` passed Validate and Parse, and its class is `AfghanGhazaliFunctions`. Confirm the class and methods are visible in FlutterFlow before configuring actions.

Use the Code File static methods through FlutterFlow's **Call Static Method** action / variable picker where available. Do not paste the entire class into a Custom Function. Do not assume the UI has connected merely because Parse succeeded.

Initial smoke tests from `FLUTTERFLOW_CODEFILE_SMOKE_TEST.md`:
- `solarDateFromGregorianJson("2026-04-01")` → provisional Solar date JSON; expected sample 1405/1/12 under the current provisional rule.
- `civilHijriFromGregorianJson("2024-03-11")` → civil/tabular sample 1445/9/1.
- `cityConfigurationJson("kandahar")` → Kandahar coordinates and localized names.
- `calculatePrayerTimesJson` with 2026-06-21, Kandahar coordinates, UTC offset 4.5, Fajr 18°, Isha 17°, Asr factor 2 → six time fields and Hanafi metadata.

If FlutterFlow's action picker cannot call a named-argument method, stop and use the documented Custom Action wrapper workflow. Do not improvise imports or claim compilation before testing.

## 13. Required App State

Use the variable names and initialization rules in `FLUTTERFLOW_APP_STATE.md` and `FLUTTERFLOW_ACTION_FLOW_SPEC.md`. At minimum: `appLanguage=ps`, `themeMode=system`, `selectedDateIso` (today's local date), `selectedCityId=kabul`, `asrFactor=2`, provisional `fajrAngle=18.0`, `ishaAngle=17.0`, `utcOffsetHours=4.5`. Store stable IDs and ISO date strings, not translated labels.

## 14. Build order and stop gates

1. Generate/review HomePage visual shell.
2. Create reusable date, mini-calendar, prayer summary and quick-access components.
3. Connect Code File smoke tests and HomePage calculations.
4. Generate CalendarPage and PrayerTimesPage; connect their actions.
5. Generate SettingsPage and ProvinceExplorerPage.
6. Generate Population and Agriculture pages as safe empty/review states only.
7. Add Maps/Reports only after source and geometry gates pass.
8. Complete AboutPage, localization, RTL/LTR, responsive and interaction QA.

Do not continue to the next feature if the current page has broken layout, inactive controls, incorrect date output or stale prayer times.

## 15. Official FlutterFlow workflow notes

- FlutterFlow supports AI Designer generation for pages/components, reusable Components, and import from Figma frames. Use the generator as a time-saving starting point, then verify the result and bind actions/data.
- A component is reusable; update its definition once and its instances update together.
- A generated page/component is not automatically wired to this repository's Dart logic.
- Keep `main` branch untouched. Current preparation remains on `flutterflow/migration-prep`.
