# Agricultural Advisory Data Policy

## Purpose
This policy governs agricultural calendar and crop guidance shown in Afghan Ghazali Calendar. It is designed for traceable, locality-aware advice rather than unsupported fixed dates.

## Data contract
- `agricultural_advisory.json`: records consumed by the app.
- `agricultural_advisory.schema.json`: JSON Schema Draft 2020-12 validation contract.
- Calendar windows use the Afghan Solar Hijri calendar, represented by numeric month (1–12) and day (1–31). UI labels must be localized separately.
- Every record has a stable record ID, crop ID, province P-code, optional district P-code, activity, season, localized recommendation, source list, and verification status.
- Use `district_id: null` only when the advice applies to the whole province or the source does not provide district-level detail. Never infer a district from a province-level statement.
- Optional conditions can record irrigation, soil, altitude and locality notes when the source supports them.

## Publication and verification rules
1. Never invent sowing, irrigation, fertilizer, pest-control or harvest dates.
2. A record marked `verified` must include at least one traceable source, reviewer identity and review date. The source must support the specific crop, activity and geographic scope.
3. Prefer current Afghan Ministry of Agriculture, Irrigation and Livestock (MAIL) guidance, provincial agriculture directorates, recognized agricultural research institutions, FAO and other reputable technical publications.
4. Record the source title, issuing organization, URL, publication date when known, and access date.
5. If sources disagree, preserve the disagreement in notes and keep the record at `pending_review`; do not average dates or choose one without an agronomist's decision.
6. Recommendations that vary with elevation, irrigation, soil or microclimate must carry those conditions. A province-wide date must not be presented as a district-specific date.
7. Review time-sensitive guidance before each agricultural season and set `valid_from` / `valid_until` when the source defines a validity period.
8. Keep draft or pending records out of user-facing recommendations unless clearly labeled as unverified research notes.
9. Administrative IDs must match the province/district gazetteer. Use stable P-codes, never localized names, as database keys.
10. This schema is a data contract, not an agronomic source and not a substitute for local extension advice.

## Existing screen audit
The current `AgricultureScreen` contains province-level wheat sowing windows selected through hard-coded climate-zone labels. Before those dates are displayed as verified guidance, each window must be traced to its underlying MAIL advisory (including publication date and applicable provinces), then migrated into this dataset. Provinces currently assigned the `unknown` zone must continue to show the existing "no verified window" message. Do not extrapolate dates to Kandahar districts without supporting district/locality evidence.

## Initial scope
Start with Kandahar as the district-data pilot. Add crop/activity records only after the source and geographic coverage are documented. An empty `records` array is intentional until suitable source-backed records are entered.
