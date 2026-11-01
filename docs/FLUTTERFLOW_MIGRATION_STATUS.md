# FlutterFlow Migration Status

**Last updated:** 2026-11-01  
**FlutterFlow project:** `afghan-ghazali-calendar-zqicpn` (owner-created)  
**Preparation branch:** `flutterflow/migration-prep`

## Completed in this preparation branch

- [x] Inspected source repository README and Flutter package manifest.
- [x] Inspected app bootstrap, HomeScreen, AgricultureScreen and core calendar/prayer/admin/population services.
- [x] Reviewed population ingestion and ADM hierarchy audit documentation.
- [x] Recorded source-to-FlutterFlow page and logic mapping.
- [x] Drafted master page/navigation blueprint.
- [x] Drafted logical database schema and data provenance rules.
- [x] Recorded critical blockers and acceptance gates.
- [x] Added a portable, Flutter-independent Dart calculation layer for Solar/Hijri date conversion and approximate prayer times.
- [x] Added population missing-value handling, complete-only aggregation and P-code set comparison helpers.
- [x] Added six-city prayer configuration with stable IDs and localized labels, preserving source coordinates.
- [x] Added Flutter tests for the migration helper layer.
- [x] Added FlutterFlow custom-code setup and JSON field mapping instructions.
- [x] Added staged FlutterFlow manual page-build guide.
- [x] Added page-by-page FlutterFlow action-flow specification covering app state, Home, Calendar, Prayer Times, Settings, geography and data-release gates.
- [x] Updated integration instructions to prefer FlutterFlow Code File static-method calls.
- [x] Added a four-part Code File smoke-test guide with exact sample inputs and expected JSON fields.
- [x] Added Code File / Custom Action integration workflow.
- [x] Added population custom-function setup instructions and data-integrity tests.
- [x] Added `docs/FLUTTERFLOW_AI_BUILD_PACK.md` with ready-to-paste FlutterFlow Designer prompts for the app shell and each page, reusable component breakdown, and implementation gates.
- [x] Kept `main` untouched; migration work is isolated on `flutterflow/migration-prep`.

## Reported by owner, not independently verified in FlutterFlow

- [x] New FlutterFlow project created.
- [x] Theme colors entered.
- [x] Localization languages configured.
- [x] Owner reports that the Code File `my_class.dart` containing class `AfghanGhazaliFunctions` passed Validate and Parse. Static-method invocation and runtime outputs have not yet been independently tested.

## Not yet done

- [ ] Confirm Code File static methods appear in FlutterFlow action/variable pickers and run the smoke tests.
- [ ] Add and compile typed FlutterFlow wrappers if direct invocation of named-argument methods is unavailable.
- [ ] Select and provision backend (Supabase/Firebase/local snapshot strategy).
- [ ] Validate official Afghan Solar Hijri date algorithm and replace provisional logic if needed.
- [ ] Confirm population CSV publisher, source URL, publication date, licence and methodology.
- [ ] Complete current primary-source administrative row-level reconciliation.
- [ ] Generate/review Home Dashboard visually in FlutterFlow using the AI build pack.
- [ ] Create reusable visual components and connect HomePage action flows.
- [ ] Generate CalendarPage, PrayerTimesPage and SettingsPage; connect and test their actions.
- [ ] Build province/district, population and agriculture pages with the documented data-release gates.
- [ ] Add maps and exports after source and geometry readiness.
- [ ] Execute functional, data-integrity, localization, RTL/LTR and responsive QA.
- [x] Confirm migration helper, population ingestion-script syntax, Python data-tool tests, Flutter analyze and Flutter tests pass in GitHub Actions (run `41305136222`, 2026-11-01).
- [ ] Owner review and approval before release.

## Latest automated validation

- Workflow run: `41305136222` — **success**.
- Jobs/steps passed: population-ingestion script syntax check, Python data-tool tests, Flutter dependency setup, `flutter analyze`, and `flutter test`.
- This validates code and synthetic fixtures only; it does not ingest the original population CSV payloads or verify their publisher provenance.

## Latest migration-preparation update (2026-11-01)

- Added `docs/FLUTTERFLOW_AI_BUILD_PACK.md` containing a consistent design system and paste-ready AI generation prompts for Home, Calendar, Prayer Times, Settings, Province Explorer, safe Population/Agriculture empty states, Maps/Reports shells and About.
- The build pack recommends generating HomePage first, extracting reusable Components, then connecting the parsed Code File and expanding to the remaining pages.
- FlutterFlow supports AI page/component generation and reusable Components. The generated visual UI still needs owner review, data binding and action configuration in the FlutterFlow project.
- Owner reports successful Validate and Parse for `my_class.dart`; this is not yet proof that static methods compile in action flows or return correct runtime values.
- The FlutterFlow canvas is not directly controlled by GitHub repository operations. The next practical milestone is to use the HomePage prompt in the AI Designer / page generator, review the generated layout, and then connect its date and prayer data.

## Current status

**Status:** Preparation in progress; Code File parse reported successful by owner; visual page generation and runtime integration remain.

## Safety

- Do not merge into `main` without explicit owner approval.
- Do not delete or rewrite original source datasets.
- Do not present draft/modelled/estimated data as official or census data.
- Keep all migration work isolated and reviewable.
