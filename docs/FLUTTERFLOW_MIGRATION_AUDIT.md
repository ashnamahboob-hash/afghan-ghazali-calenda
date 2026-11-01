# FlutterFlow Migration Audit

**Prepared:** 2026-11-01  
**Source repository:** `ashnamahboob-hash/afghan-ghazali-calenda`  
**Source branch:** `preview/browser-review`  
**Preparation branch:** `flutterflow/migration-prep`  
**Target FlutterFlow project (created by owner):** `afghan-ghazali-calendar-zqicpn`

## Scope and safety

This document records a source-code audit for a visual rebuild in FlutterFlow. A conventional Flutter repository is not imported as editable FlutterFlow page/widget definitions. Rebuild the presentation with FlutterFlow widgets, then port reusable Dart business logic into Custom Functions, Custom Actions, and (only where necessary) Custom Widgets.

The original `main` branch must remain untouched. No merge to `main` is authorized by this migration plan. This preparation branch is based on `preview/browser-review`; it is documentation-only at this stage.

## Source application inventory

| Area | Existing source | Current behavior / notes | Migration target |
|---|---|---|---|
| App bootstrap/theme | `lib/main.dart` | Material 3; seed green; Pashto/Dari/English locales; Pashto initial locale | FlutterFlow Theme, App Settings, Localization |
| Home/calendar UI | `lib/screens/home_screen.dart` | Stateful home screen; calendar, triple-date card, city selector, prayer card, bottom navigation, settings | Rebuild as FlutterFlow pages/components |
| Solar calendar | `lib/services/afghan_calendar.dart` | Afghan month names; conversion; provisional March 21 boundary and 33-year leap cycle | Port only after authoritative date validation |
| Hijri calendar | `lib/services/islamic_calendar.dart` | Civil/tabular conversion; explicitly not moon-sighting authority | Custom Function(s), display disclaimer |
| Prayer times | `lib/services/prayer_times.dart` | Offline solar approximation; six city coordinates in HomeScreen; Asr factor 1/2; angle and offset inputs | Custom Action or Custom Function, settings persisted separately |
| Administrative selector | `lib/services/administrative_reference.dart` | Loads draft JSON; checks 34 provinces and 401 unique units; searches by P-code/name | Database tables or bundled read-only JSON; keep draft status visible |
| Population | `lib/services/population_2027_dataset.dart` | Parses a CSV while preserving string-valued source fields; indexes ADM2 by P-code and province | Staged source dataset + normalized analytical view; do not assume upload to app is complete |
| Agriculture UI | `lib/screens/agriculture_screen.dart` | Province/district, season and crop selectors; hides unverified advice | FlutterFlow page + sourced advisory records only |
| Agriculture policy/data | `assets/data/AGRICULTURE_DATA_POLICY.md`, JSON schemas and datasets | Empty advisory array is intentional; unsupported dates must remain hidden | Database with source, geography, verification and validity fields |
| Tests | `test/` | Calendar, navigation, RTL, administrative, population and agriculture tests | Preserve as acceptance criteria; add FlutterFlow/manual test cases |
| CI | `.github/workflows/flutter-validation.yml`, other workflows | Flutter validation and data checks | Keep source CI independent of FlutterFlow-generated repository |

## Confirmed migration constraints

1. The owner reports that a new FlutterFlow project exists and that theme colors and localization languages have been configured. These settings have not been independently inspected in the FlutterFlow UI.
2. The owner chose a visual rebuild in FlutterFlow, not a direct code import.
3. The target experience must support Pashto (default), Dari and English, with RTL for Pashto/Dari and LTR for English.
4. The population module is in scope. The owner explicitly requested that population information be included.
5. Never label estimates as census results. Keep source, reference year, unit, methodology and verification status visible.
6. Preserve original source CSV bytes and all literal missing markers. Do not convert `-`, blanks or NULL to zero.
7. Keep the 457-record 2027 population ADM2 hierarchy distinct from the 401-unit draft administrative selector. Their join is by exact P-code only, with unmatched rows retained and explained.
8. Agriculture guidance remains unpublished unless each record has a traceable source and geographic applicability.
9. Do not overwrite stable P-codes or source labels to resolve a disagreement without row-level evidence.
10. Do not modify `main`, delete source data, or merge this work without explicit owner approval.

## Data integrity findings already recorded in source repository

- Population 2027 audit: 34 province P-codes and 457 ADM2 P-codes; population totals reconcile across ADM0/ADM1/ADM2 to 50,489,104 in the supplied dataset. Provenance of the CSV publisher remains unverified.
- The population ADM2 data includes 56 P-codes beyond the app's 401-unit draft reference. These must not be silently added to the selector.
- The population data includes literal missing markers; the existing ingestion procedure fingerprints original files before ingestion.
- The administrative draft is 34 provinces / 401 units and is explicitly not an officially certified gazetteer.
- OCHA dashboard-level counts do not constitute row-level verification of all names.
- Agriculture advice records are empty by design until supported by suitable sources.

See:
- `docs/population-2027-ingestion.md`
- `docs/population-2027-admin-hierarchy-audit-2026-11-01.md`
- `docs/admin-reference-ocha-source-audit-2026-11-01.md`
- `assets/data/AGRICULTURE_DATA_POLICY.md`

## Migration risks / blockers

| Risk | Severity | Required action before production |
|---|---|---|
| Solar calendar boundary and leap-year rule are provisional | Critical | Compare multiple official Afghanistan calendar years, including boundary and leap dates; only then port |
| Prayer calculations are approximate | High | Verify calculation angles, Asr rule, timezone and local timetable against trusted authority |
| Population CSV publisher/licence provenance is not confirmed | High | Trace original publisher, release date, licence and methodology; preserve current uncertainty |
| Administrative 401-unit draft is not fully OCHA row-level certified | High | Obtain current primary-source gazetteer and reconcile by P-code |
| Population 457 ADM2 rows differ from 401-unit selector | High | Model both datasets independently; expose joins and unmatched codes |
| Agricultural UI currently contains hard-coded seasonal logic | High | Keep unverified guidance hidden; migrate only sourced records |
| FlutterFlow target database not selected | Medium | Decide Supabase vs Firebase vs local read-only assets after schema and query requirements review |
| FlutterFlow GitHub sync not confirmed | Medium | Owner must connect the target project to a dedicated repository/branch in FlutterFlow |

## Recommended implementation sequence

1. Finish the data and logic contracts in this migration package.
2. Confirm source provenance and calculation blockers; do not silently upgrade draft data to verified.
3. Build FlutterFlow theme, localization and reusable components.
4. Build Home Dashboard and navigation.
5. Build calendar, then prayer times.
6. Build population pages with provenance and missing-data semantics.
7. Build province/district explorer using stable P-codes and explicit draft/verified status.
8. Build agriculture page with only source-backed advisory data.
9. Add maps/reports after verified geospatial data and export requirements are defined.
10. Execute the acceptance checklist and obtain owner review before release.

## Current migration status

See `docs/FLUTTERFLOW_MIGRATION_STATUS.md`. This branch currently contains migration preparation documentation; the FlutterFlow visual application has not been built or verified by this repository work.
