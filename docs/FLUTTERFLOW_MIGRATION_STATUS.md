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
- [x] Kept `main` untouched; migration work is isolated on a new branch based on `preview/browser-review`.

## Reported by owner, not independently verified in FlutterFlow

- [x] New FlutterFlow project created.
- [x] Theme colors entered.
- [x] Localization languages configured.

## Not yet done

- [ ] Connect FlutterFlow project to a dedicated GitHub repository/branch.
- [ ] Select and provision backend (Supabase/Firebase/local snapshot strategy).
- [ ] Validate official Afghan Solar Hijri date algorithm and replace provisional logic if needed.
- [ ] Confirm population CSV publisher, source URL, publication date, licence and methodology.
- [ ] Complete current primary-source administrative row-level reconciliation.
- [ ] Rebuild Home Dashboard visually in FlutterFlow.
- [ ] Build calendar and prayer-time pages.
- [ ] Build population, province/district and agriculture pages.
- [ ] Add maps and exports after data-source readiness.
- [ ] Execute functional, data-integrity, localization, RTL/LTR and responsive QA.
- [ ] Owner review and approval before release.

## Current status

<badge>Preparation in progress</badge>

The FlutterFlow UI itself has not been built by GitHub operations. The files in this branch are migration documentation and design contracts. No claim is made that the FlutterFlow project is connected to GitHub or that the app has been migrated.

## Safety

- Do not merge into `main` without explicit owner approval.
- Do not delete or rewrite original source datasets.
- Do not present draft/modelled/estimated data as official or census data.
- Keep all migration work isolated and reviewable.
