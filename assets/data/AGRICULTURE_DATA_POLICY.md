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


## HDX Afghanistan data catalogue review (2026-11-01)

The HDX Afghanistan group page is a **catalogue of datasets**, not one unified agricultural dataset:
https://data.humdata.org/group/afg

The group page itself returned HTTP 403 during this review, so dataset references were cross-checked against indexed HDX metadata and related source pages. Do not infer that every dataset below is currently downloadable or suitable for a production advisory without inspecting its actual resource, date, geographic resolution and licence.

Relevant candidate datasets/resources identified:

- **Afghanistan - Subnational Administrative Boundaries (COD-AB)**: https://data.humdata.org/dataset/4c303d7b-8eae-4a5a-a3aa-b2331fa39d74  
  The indexed metadata describes AGCHO-sourced ADM0–ADM2 boundaries, 34 ADM1 and 401 ADM2 features, and a July 2024 accuracy review. Treat this as an important row-level P-code verification source, but compare the actual gazetteer rows and unit types before replacing the app's draft reference.
- **Afghanistan subnational rainfall**: https://data.humdata.org/dataset/afg-rainfall-subnational  
  Candidate for rainfall context and historical climate indicators; not by itself a crop sowing-date recommendation.
- **Afghanistan subnational NDVI**: https://data.humdata.org/dataset/afg-ndvi-subnational  
  Candidate for vegetation-condition monitoring; NDVI is an indicator of vegetation greenness/density, not a direct crop identity or yield measurement.
- **CHIRPS rainfall data**: the Centre for Humanitarian Data's 2026 State of Open Humanitarian Data describes WFP aggregation of CHIRPS precipitation by administrative region, with preliminary estimates every five days and finalized monthly updates. Use only after confirming the specific Afghanistan resource, time coverage, spatial unit, update cadence and reuse terms.

Implementation guidance:
1. Keep administrative boundaries/P-codes, climate observations, vegetation indices, food prices and agronomic recommendations in separate datasets/tables.
2. Store source dataset ID, resource ID, source organisation, licence, retrieval date, temporal coverage, spatial resolution and original field names with every imported resource.
3. Do not convert rainfall or NDVI anomalies directly into fertilizer, irrigation or planting advice. Such advice needs agronomic interpretation and a traceable crop/locality-specific source.
4. Preserve raw source files unchanged; perform normalization in a separate derived dataset and retain provenance.
5. The HDX group page is a discovery index. Production imports must point to a specific dataset and resource, not just the group URL.

Related references:
- OCHA/HDX COD-AB metadata mirror: https://data.amerigeoss.org/dataset/cod-ab-afg
- OCHA COD portal: https://ocha-dap.github.io/cod-site/
- HDX 2026 State of Open Humanitarian Data: https://data.humdata.org/dataset/2048a947-5714-4220-905b-e662cbcd14c8
- Centre for Humanitarian Data guidance on vegetation indices: https://data.humdata.org/dataset/2048a947-5714-4220-905b-e662cbcd14c8/resource/bcf2fce8-9359-4eda-a892-76cc480fb26f/download/climate-guidance-on-vegetation-indices.pdf
