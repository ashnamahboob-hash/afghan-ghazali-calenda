# Afghan Ghazali Calendar — FlutterFlow Master Blueprint

## Product goal

A multilingual Afghan reference app combining the Afghan Solar Hijri calendar, civil Hijri and Gregorian dates, prayer-time estimates, population statistics, administrative geography and source-backed agriculture information.

**Default language:** Pashto.  
**Additional languages:** Dari and English.  
**Visual direction:** Material 3, deep green and gold, warm off-white surfaces, charcoal dark theme.  
**Target layouts:** mobile first; tablet and web responsive.

## Navigation model

Recommended FlutterFlow shell: persistent responsive navigation with these destinations:

1. Home
2. Calendar
3. Prayer Times
4. Population
5. Provinces & Districts
6. Agriculture
7. Maps
8. Reports
9. Settings
10. About

On narrow mobile screens use a bottom NavigationBar for the primary destinations (Home, Calendar, Prayer, Explore); place remaining destinations in a More/Drawer page. On wide layouts use NavigationRail or a side navigation panel. Avoid hiding core features behind nonfunctional decorative controls.

## Page specifications

### Home Dashboard
- App title and language selector.
- Today's Afghan Solar Hijri date, Gregorian date and civil Hijri date.
- Compact monthly calendar preview.
- Prayer times for selected city.
- Shortcuts to population, provinces and agriculture.
- Clear data-source/estimate badges where numerical indicators are shown.
- Date and city state must be shared with the relevant pages.

### Calendar
- Month/year selector using Afghan Solar Hijri month order.
- Week starts Saturday.
- Day cell shows Solar Hijri, Gregorian and civil Hijri dates.
- Selected date detail panel.
- Month navigation must use Solar Hijri month arithmetic, not Gregorian month arithmetic.
- Clearly disclose that civil Hijri dates may differ from local moon-sighting announcements.
- Do not publish official-calendar accuracy claims until the solar engine is validated.

### Prayer Times
- City selector: Kabul, Kandahar, Herat, Mazar-e-Sharif, Jalalabad, Kunduz.
- Display Fajr, sunrise, Dhuhr, Asr, Maghrib, Isha.
- Asr option: Hanafi (factor 2, default) / Standard-Shafi'i (factor 1).
- Calculation settings: Fajr angle, Isha angle, UTC offset, method label and source/verification note.
- Sunrise must be labelled separately and not represented as a prayer.
- Explain that current implementation is an offline approximation pending local verification.

### Population
- National summary and province comparison.
- Sex and age breakdown only when source columns support the measure.
- Urban/rural breakdown only when supplied and non-missing.
- Density only if a compatible population measure and area dataset are available.
- Households and household size only if source-backed.
- Province and ADM2 detail pages.
- Every chart/table shows source, reference year, unit, geography, method and status.
- Explicitly distinguish reported, calculated, modelled, estimated and missing values.
- Never call the 2027 estimates a census.

### Province & District Explorer
- Province list (34 P-codes).
- District/administrative-unit list with stable P-codes.
- Search by Pashto/Dari/English names and P-code.
- Show administrative type and verification state.
- Preserve the difference between 401 draft reference units and 457 population ADM2 records.
- Do not merge unmatched population P-codes into the administrative selector automatically.

### Agriculture
- Crop and season filters.
- Province and district filters.
- Display only verified source-backed advice.
- Each advisory includes crop, activity, locality, source, publication date, validity, reviewer and conditions.
- If no verified advice exists, show a clear “not yet verified” state.
- Do not infer district advice from province-level source material.

### Maps
- Map provinces/districts only when suitable verified geometry is available.
- Population and agriculture thematic layers must include source/year/status.
- Do not fabricate boundaries or geocode names as official polygons.

### Reports
- CSV/PDF export only from records visible to the user and carrying source metadata.
- Include generated date, filters, source references, units and caveats.
- Keep raw source data separate from normalized/export views.

### Settings
- Language: Pashto / Dari / English.
- Theme: light / dark / system.
- Selected city and prayer calculation options.
- About, sources, licences, data update status and privacy.

## Shared app state

Use FlutterFlow App State only for small cross-page user preferences and selections:

- `appLanguage`: `ps | fa | en` (default `ps`)
- `themeMode`: `system | light | dark`
- `selectedDateIso`: ISO date string (local calendar date, not UTC instant)
- `selectedCityId`: stable city key
- `asrFactor`: integer 2 default, or 1
- `fajrAngle`, `ishaAngle`, `utcOffsetHours`: numeric configuration values
- `selectedProvincePcode`
- `selectedDistrictPcode`
- `populationDatasetId` and selected reference year
- `showDraftData`: false by default; only enable for clearly labelled research/admin views

Do not put whole population tables or large administrative datasets into App State. Fetch/filter them through queries or load a bounded read-only asset.

## Database / data-source strategy

Do not select a backend merely for convenience. Evaluate:
- Supabase/PostgreSQL for relational P-code hierarchy, source provenance, joins, filtering and analytics.
- Firebase/Firestore if the app prioritizes document-oriented mobile sync and simpler user-specific settings.
- Bundled JSON/CSV for immutable, offline reference snapshots when dataset size and licensing permit.
- API-backed updates only after source endpoint, licence, caching, offline behavior and versioning are defined.

The schema proposal is in `FLUTTERFLOW_DATABASE_SCHEMA.md`. Keep raw source snapshots immutable and separate from normalized query tables.

## Design tokens

The owner reports that these values have already been entered in FlutterFlow Theme Settings; verify them in the project before duplicating:
- Primary: `#14532D`
- Secondary: `#C9A227`
- Background: `#F8F7F1`
- Text: `#26332B`
- Error: `#B42318`

Typography must use a tested Pashto/Dari-capable font. Check shaping, line height, digits, truncation and RTL alignment on real devices.

## Release gates

- Calendar: official dates verified for a representative multi-year test set.
- Prayer: calculation assumptions and local comparisons documented.
- Population: publisher/source/licence/methodology confirmed; missing values retained.
- Admin geography: P-code/name/parent relationships reviewed against current primary source.
- Agriculture: only reviewed, source-backed advice published.
- Localization: every visible string translated; RTL/LTR tested.
- Functionality: all controls have working actions and loading/empty/error states.
- Accessibility: readable contrast, scalable text, semantic labels and keyboard support.
