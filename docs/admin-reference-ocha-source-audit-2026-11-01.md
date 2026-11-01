# OCHA Afghanistan COD-AB source audit — 2026-11-01

## Purpose

Record what could be established from OCHA's current public status pages and
the accessible Afghanistan COD-AB dataset metadata. This is a source-version
audit, not a 401-row district-name verification.

## Findings

### 1. OCHA COD status dashboard

- URL: https://ocha-dap.github.io/cod-site/status/
- Dashboard last updated: 2026-10-31
- Afghanistan: COD-AB reference year 2026
- COD-AB feature counts: ADM1 34; ADM2 401
- COD-PS reference year: 2027
- COD-PS ADM2 P-codes: 457
- COD-PS ADM2 P-codes not in COD-AB: 56

The counts confirm the expected scale of the reference but do not expose
individual district names, P-codes, or parent relationships in the retrieved
dashboard content.

### 2. OCHA COD-AB coverage/work dashboard

- URL: https://ocha-dap.github.io/cod-site/status/coverage/
- Observed dashboard date: 2026-10-23
- Afghanistan work status: In Progress
- Review window displayed: In 5 months
- GIS publication indicator: Yes

This is a separate workflow/status view. It should not be conflated with the
reference-year and feature-count summary in the status dashboard.

### 3. Accessible HDX/AGCHO dataset metadata

- Dataset: https://data.humdata.org/dataset/4c303d7b-8eae-4a5a-a3aa-b2331fa39d74
- Metadata mirror: https://data.amerigeoss.org/dataset/cod-ab-afg
- Dataset authority/source: Afghanistan Geodesy and Cartography Head Office
  (AGCHO)
- Dataset described as established: 2019
- Last accuracy review described in metadata: July 2024
- Metadata last updated: 2025-01-17
- Declared coverage: 34 ADM1 and 401 ADM2 features
- Gazetteer resource: afg_admin_boundaries.xlsx

The accessible metadata is older than the 2026 status dashboard. It does not
establish that the user-supplied workbook v04 is the 2026 COD-AB extract.

### 4. COD-AB standard and review requirements

OCHA's COD-AB documentation states that COD-AB includes geographic boundary
layers and gazetteers of feature names/P-codes, and that datasets are adopted
by the country or regional Information Management Working Group as the
standard. COD-AB datasets should be reviewed every 12 months.

Documentation:
https://humanitarian.atlassian.net/wiki/spaces/imtoolbox/pages/2557378679

## Verification decision

**Row-level primary-source verification remains pending.**

The retrieved 2026 status summary provides counts and reference-year metadata,
not the 401 ADM2 rows. Until a current COD-AB gazetteer or service response is
retrieved and archived with provenance:

1. Do not label the draft gazetteer officially verified.
2. Do not replace any local-script label solely from dashboard counts.
3. Do not infer ADM2 names or parent codes from COD-PS.
4. Keep all 52 local-script discrepancies pending.
5. Keep all 12 temporary-district parent crosswalk entries pending.
6. Preserve stable district IDs and do not add the 56 unmatched COD-PS codes
   to the 401-record COD-AB candidate reference.

## Next technical step

Retrieve the current 2026 COD-AB gazetteer (or its official GIS service
feature layer) and export, at minimum, the fields for ADM2 P-code, ADM2
English name, local-language name where available, ADM1 P-code/name, unit
type, and validity dates. Then compare by exact P-code, preserve source
spellings verbatim, and write a row-level difference report before changing
the draft dataset.

## Additional independent secondary reference cross-check

On 2026-11-01, the 401 candidate ADM2 records were also compared by exact
ID/P-code string with the community-maintained
[open-admin-data Afghanistan administrative divisions dataset](https://github.com/open-admin-data/afghanistan-administrative-divisions).
Its README states an update date of 2026-09-08 and a CC-BY-4.0 license.

Results:
- 401/401 IDs joined exactly.
- 401/401 parent province IDs matched.
- English labels: 289 exact, 20 normalization-only differences, 92 remaining differences.
- Local-script labels: 396 exact, 1 normalization-only difference, 4 remaining differences.

This is useful independent secondary corroboration, but it is not an OCHA/AGCHO
source. The sampled source records have empty row-level `source` metadata.
No candidate label was changed and no review status was closed. The detailed
record-by-record ledger is at
`docs/admin-reference-secondary-crosscheck-open-admin-data-2026-11-01.json`.
The 2026 OCHA/AGCHO row-level verification remains pending.
