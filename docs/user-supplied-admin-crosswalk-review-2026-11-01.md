# User-Supplied ADM2/ADM1 Crosswalk Review — 2026-11-01

## Evidence status

This note records a review of a CSV-like ADM2/ADM1 table pasted by the project owner into the conversation on 2026-11-01. The pasted extract ends at `AF2911`; it does not include the remaining apparent province-code ranges, so it is not treated as a complete 401-row verifier workbook. No source organization, publication date, URL, version, or licensing metadata accompanied the pasted text.

**This is user-supplied evidence, not an independently verified primary source.** It must not be used to certify official district names or silently overwrite the draft runtime reference.

## Join and preservation rules

- Match administrative units by exact `adm2_pcode`.
- Validate the parent relationship by exact `adm1_pcode`.
- Compare `adm2_name1` and `adm1_name1` as supplied labels, retaining source spelling separately.
- Do not infer missing records from sequence gaps.
- Do not replace any current label until the source provenance and row-level records are confirmed.

## Spot-check against the current 401-unit draft

| ADM2 P-code | Pasted ADM2 label | Current draft label | Pasted ADM1 label | Current parent | Review note |
|---|---|---|---|---|---|
| AF0606 | کوز کونړ | کوز کنر | ننگرهار | ننگرهار (AF06) | Local-script spelling variant; preserve both pending source confirmation. |
| AF0901 | بغلان مرکزی | پلخمری | بغلان | بغلان (AF09) | Material name discrepancy; do not overwrite. |
| AF0905 | بغلان مرکزی | بغلان جدید | بغلان | بغلان (AF09) | Material name discrepancy; do not overwrite. |
| AF1119 | ناوه | ناوه | غزنی (with Latin `ni` in pasted row) | غزنی (AF11) | ADM2 label matches; pasted parent label contains mixed-script text. |
| AF2002 | حضرت sultan | حضرت سلطان | سمنگان | سمنگان (AF20) | Mixed-script source label; likely normalization candidate, not certified correction. |
| AF2110 | Not present in pasted extract | Not present in 401-unit draft | — | — | Missing from both reviewed lists; do not infer or synthesize. |
| AF2711 | مقر سپین بولدک | سپین بولدک | کندهار | کندهار (AF27) | Material name discrepancy; preserve both pending primary-source check. |

The five P-codes previously discussed (AF0102, AF1114, AF2603, AF2711, AF0606) are present in the current draft and their parent ADM1 codes match the supplied parent codes. AF2711 and AF0606 nevertheless have the label differences recorded above.

## CI verification

The Flutter validation workflow for commit `435c2c83035c0098d1f8ee745575ef38d47432a7` completed successfully on 2026-11-01. The preceding failed run was caused by a test expecting `غزني` while the existing draft province label is `غزنی`; the test expectation was corrected without changing the dataset label.

The administrative-reference validation workflow had also passed on the preceding commits. These CI results validate code and dataset structure, not the truth or official status of administrative names.

## Next verification required

Obtain the complete source file or authoritative published dataset with provenance and version metadata. Then run a full row-level audit for duplicate P-codes, missing/extra P-codes, parent-code mismatches, nulls, and local/English label differences. Keep the draft dataset unchanged until discrepancies are resolved against the primary source.
