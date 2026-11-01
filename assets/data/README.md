# Kandahar District Data (Pilot)

## Status
Draft dataset. It preserves the 16 district identifiers and Pashto labels already present in `lib/screens/agriculture_screen.dart`. It is **not yet an officially verified gazetteer**.

## Files
- `kandahar_districts.json`: data and provenance metadata.
- `district.schema.json`: administrative district dataset schema.
- `kandahar_districts_verification.md`: independent district reference cross-check; not an official OCHA row-level certification.
- `agricultural_advisory.json`: source-backed agricultural guidance records (currently empty by design).
- `agricultural_advisory.schema.json`: validation contract for agricultural guidance records.
- `AGRICULTURE_DATA_POLICY.md`: sourcing, review and publication rules for agricultural guidance.

## Schema
- `schema_version`: data contract version.
- `dataset_id`: stable dataset identifier.
- `province.id`: Kandahar province P-code (`AF27`).
- `districts[].id`: district P-code currently carried over from the app.
- `districts[].province_id`: parent province P-code.
- `districts[].names.ps`: existing Pashto label.
- `districts[].names.fa`: null until a verified Dari spelling is available.
- `districts[].names.en`: existing English label.
- `districts[].verification`: field-level verification state.
- `districts[].source_ids`: provenance keys resolved in `source_policy`.
- `districts[].reviewed_at`: ISO-8601 review date, null until reviewed.
- `districts[].record_status`: record-level verification state.

## Verification rules
1. Check every P-code and English district name against the current OCHA COD-AB ADM2 gazetteer.
2. Compare Pashto and Dari spellings with an authoritative Afghan government or national-language source; do not infer Dari spelling from Pashto.
3. Keep unresolved fields null or marked pending. Never present pending names as official.
4. Record the source URL, access date, reviewer, and evidence for each field when verified.
5. Do not infer agricultural schedules from administrative-name verification.

## Sources
- OCHA/HDX Afghanistan COD-AB: https://data.humdata.org/dataset/4c303d7b-8eae-4a5a-a3aa-b2331fa39d74
- Open Admin Data (CC BY 4.0): https://github.com/open-admin-data/afghanistan-administrative-divisions

OCHA COD-AB metadata describes Afghanistan ADM1/ADM2 administrative units and is sourced from the Afghanistan Geodesy and Cartography Head Office. The linked multilingual dataset is a secondary reference, not a substitute for official name validation.

## National administrative reference (draft)
- `afghanistan_admin_divisions_reference_draft.json`: bilingual candidate reference containing 34 provinces and 401 districts from Open Admin Data (CC BY 4.0). It is a secondary reference only; its IDs and local-script labels must not be treated as OCHA-certified until row-level P-code comparison is complete.
- OCHA/HDX COD-AB metadata confirms Afghanistan's ADM1/ADM2 coverage (34 provinces and 401 districts), identifies AGCHO as the source, and records a July 2024 accuracy review. The OCHA gazetteer row-level extraction is still pending; no district is promoted to officially verified on metadata alone.
- User-supplied `afg_admin_boundaries.xlsx` (v04; valid_on 2026-06-23) was inspected on 2026-11-01. Its `afg_admin1` sheet has 34 province rows; `afg_admin2` has 457 records: 397 `District`, 29 `Temporaray District` (source spelling), 30 `Provincial Capital`, and 1 `Capital`. These 457 mixed ADM2 records must not be described as 457 districts or equated directly with the metadata's 401-district coverage.
- Daykundi/Panjshir candidate crosswalk: all 16 candidate P-codes occur in the supplied workbook and all 16 have the expected parent province P-code. One material name conflict remains: Panjshir `PJR-06` / candidate `AF0804` is `Khenj` in the secondary candidate source but `Hesa-e-Awal` / `حصه اول` in the workbook. This is flagged for manual resolution; no mapping is promoted to OCHA-verified. See `daykundi_panjshir_district_id_crosswalk_draft.json`.
- Kandahar pilot cross-check: `kandahar_districts_verification.md` records 16/16 candidate ID and English-name matches against Open Admin Data, with two local-script spacing/spelling variants. OCHA row-level verification and local-language orthography review remain pending.

## NSIA 1402 Kandahar production extract (draft)
- `kandahar_production_profiles_nsia_1402_draft.json`: source-transcribed Kandahar province rows from NSIA Statistical Yearbook 1402 (2023-24), covering wheat (Table 8-6), maize/rice/barley (8-7), major fruits (8-13), and potatoes/onions/carrots (8-17), plus national cultivated-area context from Table 8-5.
- Source PDF: user-provided `سالنامه-احصائیوی-1402نسخه-وبسایت.pdf`. Printed pages 209, 210, 211, 216, 220 correspond to PDF pages 248, 249, 250, 255, 259 in the file reader.
- All records are province-level; the source does not provide district breakdowns here. Blank source cells remain null, not zero. The second transcription review against the original PDF text was completed on 2026-11-01 for Tables 8-6, 8-7, 8-13 and 8-17; the extract remains a draft and is not enabled for runtime advice.
- Keep NSIA 1402 figures separate from MAIL 1402 figures; do not merge or average the two sources.


## COD-AB workbook cross-check update (2026-11-01)
- The supplied v04 workbook contains 34 unique ADM1 P-codes and 457 unique ADM2 P-codes across mixed unit types.
- All 401 candidate ADM2 records in `afghanistan_admin_divisions_reference_draft.json` have a matching P-code in the workbook, and all 401 parent ADM1 P-codes match.
- The 401 candidate records correspond in the workbook to 367 `District`, 30 `Provincial Capital`, 3 `Temporaray District`, and 1 `Capital` records. This explains why the candidate hierarchy's 401 ADM2 entries must not automatically be called 401 ordinary districts.
- The workbook has 56 additional ADM2 P-codes absent from the candidate hierarchy (30 `District`, 26 `Temporaray District`). They are not added to the candidate hierarchy without further source review.
- Province-name variants are recorded in the JSON cross-check metadata: `Hirat/Herat`, `Hilmand/Helmand`, `کنر ها/کونړ`, and `میدان وردک/میدان وردگ`. No spelling has been silently normalized.
- The complete 401-row district-name comparison remains pending. P-code presence and parent-code agreement do not establish name equivalence or official status.
- This comparison used the user-supplied workbook and does not constitute independent OCHA/AGCHO certification. Runtime remains disabled pending official row-level verification and name review.

## NSIA 1402 review status correction
- The Kandahar NSIA 1402 extract's second transcription review was completed against the original PDF text on 2026-11-01 for Tables 8-6, 8-7, 8-13 and 8-17. Blank source cells remain null; the extract remains province-level and is not enabled for runtime advice.

- Province-name variants found in the v04 workbook comparison have now been aligned to workbook spellings for AF32 (Herat), AF30 (Helmand), AF15 (کونړ), and AF04 (میدان وردگ). Province P-codes were not changed. This is a secondary-reference spelling alignment, not independent OCHA/AGCHO certification.
- Historical note (superseded by the 2026-11-01 review below): at that point, the 401-row ADM2 name-by-name comparison had not yet been completed; only ADM2 P-code presence and parent ADM1 code matching had been established.

## District-name alignment against supplied COD-AB workbook (2026-11-01)
- The four province-name variants identified in the earlier workbook comparison were aligned to the v04 workbook spellings; province IDs were preserved.
- The 16 Daykundi/Panjshir crosswalk reference labels were aligned to the exact workbook `adm2_name` / `adm2_name1` values, and the same 16 entries in the administrative reference draft were aligned. Source-local IDs and source-submitted Pashto labels were not changed.
- One material source-label conflict remains: `PJR-06` retains source label `خنج`, while workbook P-code `AF0804` is labelled `Hesa-e-Awal / حصه اول`. The stable candidate P-code was not changed; this mapping remains flagged for manual reconciliation.
- Historical note (superseded by the 2026-11-01 review below): 385 candidate ADM2 records were still awaiting name comparison at that earlier checkpoint. The full 401-row comparison has since been completed as summarized below.
- All of these edits remain secondary-reference alignments only. OCHA/AGCHO row-level verification is still pending and runtime remains disabled.


## OCHA COD status cross-check and unresolved district-name triage (2026-11-01)

- The OCHA COD status dashboard currently lists Afghanistan with 34 ADM1 and 401 ADM2 COD-AB features, COD-AB reference year 2026, and COD-PS reference year 2027. It also reports 56 of 457 ADM2 COD-PS P-codes not present in COD-AB. Source: https://ocha-dap.github.io/cod-site/status/
- A separate OCHA COD-AB work-status dashboard lists Afghanistan as **In Progress**. Source: https://ocha-dap.github.io/hdx-cod-ab-status/
- These are dataset-level status findings, not evidence for any individual district name. The 56 unmatched records remain separate; they are not silently added to the 401-record draft.
- The 52 pending local-script discrepancies are triaged for review: 37 orthographic/transliteration variants and 15 records with targeted OCHA or secondary alias/name evidence but unresolved local-script spelling or current P-code row verification. No pending record is currently classed as a proven material code/name conflict after alias evidence was reviewed.
- Triage does not close any record. All 52 remain pending until the latest row-level OCHA/AGCHO gazetteer and an appropriate local-language source are checked. Do not normalize or overwrite local labels based only on transliteration preference.
- The OCHA work-status dashboard indicates that COD-AB work is in progress; therefore the older HDX dataset metadata reviewed in July 2024 must not be treated as proof that it is the current 2026 row-level release.

## COD Services API investigation (2026-11-01)

- OCHA's COD FAQ confirms that a COD-specific API exists and provides gazetteer information including P-codes, names, administrative levels, metadata, and versioning. It also identifies the COD Services lookup resource for retrieving P-code/name lists: https://knowledge.base.unocha.org/wiki/spaces/imtoolbox/pages/2493153411
- The public UGA-ITOSHumanitarianGIS/CODV2API issue tracker documents the versioned GeoJSON route pattern `/api/v1/cod-ab/locations/{ISO3}/versions/current/geojson/{level}`; its example is from 2023 and uses the beta host, so it is treated as API route documentation, not proof of a current Afghanistan response: https://github.com/UGA-ITOSHumanitarianGIS/CODV2API/issues/24
- The API's documented route was investigated for Afghanistan ADM2, but the live endpoint could not be retrieved in this review environment. No API response, current version identifier, Afghanistan feature count, or row-level P-code/name records were obtained.
- The COD status dashboard still reports Afghanistan COD-AB reference year 2026 (34 ADM1 / 401 ADM2), while the separate COD-AB work-status dashboard marks Afghanistan In Progress. These dashboard facts do not substitute for the row-level gazetteer: https://ocha-dap.github.io/cod-site/status/ and https://ocha-dap.github.io/hdx-cod-ab-status/
- Consequently, no district labels, IDs, or aliases were changed as a result of this API investigation. The 52 local-script discrepancies remain pending. The 56 COD-PS P-codes outside COD-AB remain a separate population-statistics mismatch set and must not be imported into the 401-record ADM2 reference.
- Next verification gate: obtain the current Afghanistan COD-AB XLSX gazetteer or a successful versioned COD Services API response; preserve the source file/version and compare every ADM2 row by P-code before resolving any district record.



## Review progress correction (2026-11-01)

The earlier statements in this file that the 401-row comparison was pending or that 385 records remained unchecked are historical checkpoints and are superseded by the completed review recorded in `afghanistan_admin_divisions_reference_draft.json`.

Current exact-P-code comparison against the user-supplied v04 workbook:
- 401 candidate ADM2 records compared.
- 349 records reviewed and closed as exact workbook local-name matches or separately documented review outcomes.
- 52 local-script discrepancies remain pending.
- 332 exact local-name matches across the full 401-record comparison; 69 total local-name discrepancies were identified, of which 52 remain open.
- No unresolved local-script label was auto-normalized. English labels also have a separate review history, including five targeted OCHA overrides.
- This comparison establishes alignment to the supplied workbook only; it does not certify the workbook as the current official OCHA/AGCHO gazetteer.


## Temporary-district parent mapping (draft)
- `temporary_district_parent_mapping_draft.json` records 12 user-supplied ADM2 P-code/name/parent-label pairs, including Babaji (AF3015).
- The parent labels are preserved verbatim as user-supplied candidate mappings. The supplied table describes them as OCHA's original cluster mapping, but no original row-level OCHA source file or current COD-AB gazetteer extract accompanied the table; all 12 records therefore remain `pending` and none is certified.
- This is a crosswalk for review only. It must not be used to merge districts, change stable IDs, infer official administrative parentage, or activate new runtime district relationships.
- AF2409 (Pato) has a source difference to resolve: the earlier supplied v04 excerpt gives parent `Patoo`, while the new supplied table gives `Gizab / Patoo`. Both are retained in the draft note pending primary-source verification.
