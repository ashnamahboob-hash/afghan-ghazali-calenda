# FlutterFlow Migration Acceptance Test Plan

## Calendar
- Verify Solar Hijri month names and Saturday-first weekday order.
- Test month navigation across year boundary in both directions.
- Test every month length and leap-year transition against an official reference corpus.
- Test Gregorian ↔ Solar conversion round trips.
- Verify selected day displays all three date systems consistently.
- Verify civil Hijri disclaimer is visible and local moon-sighting may differ.

## Prayer times
- Verify six city coordinates against trusted geographic references.
- Test factor 1 and factor 2 outputs and ensure default is factor 2.
- Validate Fajr/Isha angle input bounds and UTC offset handling.
- Test dates near local midnight and year boundaries.
- Compare selected dates/cities with a trusted local timetable; record tolerances and calculation assumptions.
- Confirm sunrise is not labelled as a prayer.

## Population
- Verify dataset source metadata and reference year are visible.
- Confirm 50,489,104 total only when the exact audited dataset version is selected and clearly labelled as an estimate.
- Confirm ADM0, ADM1 and ADM2 totals reconcile for the audited source version.
- Confirm missing literal hyphens, blank cells and NULL values are never converted to zero.
- Test P-code joins for all 457 population ADM2 rows.
- Confirm the 56 codes outside the 401-unit draft selector are retained and clearly distinguished.
- Test sex, age and urban/rural charts only where the source values are populated.
- Suppress household, household-size or density visuals unless source fields and compatible area data exist.

## Administrative geography
- Validate 34 unique province P-codes and current parent links.
- Validate the 401-unit draft selector independently of the 457-row population dataset.
- Test localized name search and exact P-code search.
- Ensure draft/pending status is visible and no unresolved label is silently promoted to official.

## Agriculture
- Verify empty advisory data produces a clear empty state.
- Confirm only approved records appear in normal user mode.
- Confirm each visible advisory has source, locality, publication/validity information and review metadata.
- Ensure province-level data is not shown as district-specific guidance.

## Localization and layout
- Test Pashto and Dari RTL on phone, tablet and web.
- Test English LTR on phone, tablet and web.
- Check long labels, mixed-script P-codes, date cells, charts, forms and navigation.
- Check font shaping and scalable text.

## Interaction and accessibility
- Every visible button, menu item, selector, card action and export control performs its advertised action.
- Loading, empty, permission-denied and error states are understandable.
- Controls have accessible labels, sufficient contrast and keyboard focus where applicable.
- No placeholder or decorative control is shipped as an active feature.

## Release decision
Release only after all critical tests pass, source and licence metadata are documented, and the owner has reviewed the preview. Do not merge to the original repository's main branch without explicit owner approval.
