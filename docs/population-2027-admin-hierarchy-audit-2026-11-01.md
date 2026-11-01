# 2027 Estimated Population ADM0/ADM1/ADM2 Crosswalk Audit

**Review date:** 2026-11-01  
**Inputs supplied in chat:**
- `afg_estimated_population_2027_dwg_202607_admin0.csv`
- `afg_estimated_population_2027_dwg_202607_admin1.csv`
- `afg_estimated_population_2027_dwg_202607_admin2.csv`

**Scope:** Structural, P-code, parent-child, and population-total reconciliation only. The uploaded CSVs do not by themselves establish source provenance or official administrative status.

## 1. Record counts

Each file contains one national aggregate row (blank administrative P-code) where applicable.

| Level | Data rows excluding aggregate row | Unique P-codes |
|---|---:|---:|
| ADM0 | 1 | 1 (`AF`) |
| ADM1 | 34 | 34 |
| ADM2 | 457 | 457 |

- ADM1 P-codes cover `AF01` through `AF34`, with no duplicates.
- All 457 ADM2 P-codes match the `AF####` pattern, are unique, and have an ADM1 parent P-code matching their first four characters.
- All 34 ADM1 P-codes in the population file match the 34 province IDs in the app's draft administrative reference.
- All 34 supplied ADM1 local labels exactly match the current draft reference labels.

## 2. ADM2 cross-check against the app's 401-unit draft reference

The 457 ADM2 P-codes in the population file contain **all 401** P-codes in the app's draft reference. No draft-reference P-code is absent from the population file.

There are **56 additional P-codes** in the population file that are not in the 401-unit draft reference. This is consistent with the previously recorded OCHA COD status-dashboard summary of 457 COD-PS ADM2 P-codes, 56 of which are not in COD-AB. This set comparison is a strong structural match, but it is not independent proof that the uploaded files are an official OCHA/AGCHO release; the files' provenance and row-level source metadata still need to be retained/confirmed.

The 56 additional codes are:
`AF0623, AF0706, AF0707, AF0808, AF0916, AF1008, AF1220, AF1221, AF1222, AF1223, AF1224, AF1225, AF1312, AF1313, AF1314, AF1315, AF1516, AF1609, AF1610, AF1729, AF1908, AF1909, AF1910, AF2117, AF2208, AF2209, AF2210, AF2211, AF2311, AF2312, AF2313, AF2612, AF2717, AF2718, AF2719, AF2720, AF2915, AF2916, AF2917, AF2918, AF2919, AF3014, AF3015, AF3016, AF3017, AF3018, AF3019, AF3108, AF3109, AF3110, AF3217, AF3218, AF3219, AF3220, AF3312, AF3406`.

### ADM2 type breakdown

| ADM2 type as supplied | In 401-unit draft | Additional to draft | Total |
|---|---:|---:|---:|
| District | 367 | 30 | 397 |
| Provincial Capital | 30 | 0 | 30 |
| Capital | 1 | 0 | 1 |
| `Temporaray District` (source spelling) | 3 | 26 | 29 |
| **Total** | **401** | **56** | **457** |

The source literal `Temporaray District` appears misspelled. Preserve the original value in the source data; any corrected display label should be maintained separately with provenance.

The previously user-supplied watch-list code `AF2110` is absent from both the uploaded 457-row ADM2 data and the app's 401-code draft reference. This absence is not, by itself, an official determination that the code is invalid.

## 3. Population reconciliation

The supplied total estimated population is **50,489,104**.

| Reconciliation | Result |
|---|---:|
| ADM0 national total | 50,489,104 |
| Sum of 34 ADM1 totals | 50,489,104 |
| Sum of 457 ADM2 totals | 50,489,104 |
| ADM0 minus ADM1 sum | 0 |
| ADM1 minus child ADM2 sums, all 34 provinces | 0 |

All 12 age/sex population components sum exactly to the total population on every row at ADM0, ADM1, and ADM2.

All numeric population measures also reconcile from ADM2 to ADM1 and from ADM1 to ADM0 when missing markers are kept missing and aggregate comparisons sum the available values. No missing value was converted to zero during this review.

## 4. Missing values and source-label observations

- ADM2 `Urban Total` and its 12 component fields use the literal `-` marker on 372 records. Treat this as missing/not supplied, not as numeric zero.
- ADM2 `Rural Total` and its component fields use `-` on one record: `AF0601` (Jalalabad / Provincial Capital); its urban total is populated.
- ADM2 `adm2_ref_name` is blank on 404 rows and `adm2_ref_name1` is blank on 447 rows. These reference-name fields are sparse and should not be required fields for the P-code crosswalk.
- The 34 ADM1 local labels and all 457 ADM2 local labels contain Arabic-script characters only in this script scan; no mixed Latin/Bengali-script labels were detected in these local-name fields.
- No duplicate ADM2 P-codes, malformed ADM2 P-codes, or ADM2/ADM1 prefix-parent mismatches were found.

## 5. Safe use recommendation

1. Keep these population tables separate from the app's draft 401-unit administrative gazetteer.
2. Preserve all 457 source ADM2 rows and their original `adm_type`, labels, and missing markers.
3. If the app needs population figures, join them by exact P-code and retain the distinction between the 401 draft-reference units and the 56 additional COD-PS-like units.
4. Do not automatically merge the 56 additional codes into the 401-unit district selector. First verify their intended use, hierarchy, and geometry against the attributable source release.
5. Do not infer that an absent code is invalid, or that a matching P-code set proves official provenance.
6. Keep district-level agriculture advisory calculations disabled unless the population/admin hierarchy is separately reviewed for that use.

**Conclusion:** The three files are internally coherent: their ADM0/ADM1/ADM2 population totals reconcile exactly, and the 457 ADM2 P-code set is a superset of the app's 401-code draft reference by exactly 56 codes. This is a valuable crosswalk finding, not completion of official row-level COD-AB verification.


## 2A. Independent snapshot comparison against the linked Open Admin Data repository

**Repository:** https://github.com/open-admin-data/afghanistan-administrative-divisions  
**Dataset file:** `data/all-district.json`  
**Snapshot:** `main` at commit `9ceec68cc8f3eb66116b304f8ceaa6c7330d6266` (2026-09-08)  
**Declared licence:** CC-BY-4.0 (retain attribution when redistributing or adapting this dataset).

A fresh row-level comparison was performed between that 401-record district file and the app's existing 401-unit draft reference:

| Check | Result |
|---|---:|
| Source district records | 401 |
| Unique source P-codes | 401 |
| Draft-reference records | 401 |
| Draft P-codes absent from source | 0 |
| Source P-codes absent from draft | 0 |
| Exact P-code matches | 401 / 401 |
| Parent-province P-code mismatches | 0 |
| Local-script name differences | 5 |
| English-name differences | 112 |
| Records with both local and English differences | 4 |
| Records with at least one name difference | 113 |

The five local-script differences are limited to these P-codes: `AF2706`, `AF0805`, `AF0806`, `AF2716`, and `AF0804`. English transliteration differences are more numerous. These are comparison findings only: neither source's labels are automatically preferred, and no names or IDs were changed.

**Interpretation:** the linked repository provides a reproducible secondary cross-check for the 401 P-code set and parent hierarchy used by the app draft. It does not establish that the 457-row population CSVs are published by this repository, nor does it certify the 56 additional population P-codes. The repository's CC-BY-4.0 licence and declared coverage are not proof of official OCHA/AGCHO status.

**Implementation decision:** keep the current 401-unit app reference unchanged. Retain the linked repository as a separately attributed secondary source snapshot. Keep name differences in an audit/crosswalk report until reviewed against an attributable primary gazetteer; do not silently overwrite local or English labels. The 457-row population dataset remains a separate source dataset.


## 6. Detailed district-name review

The complete P-code-keyed list of all 113 label differences (5 local-script and 112 English) is recorded in [Administrative District Name Crosswalk Review](admin-name-crosswalk-review-2026-11-01.md). The crosswalk is review-only: it does not change the app's 401-unit reference or approve either source's labels as authoritative.
