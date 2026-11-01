# User-Supplied ADM2/ADM1 Crosswalk Review — 2026-11-01

## Evidence status
This note records two consecutive CSV-like ADM2/ADM1 extracts pasted by the project owner on 2026-11-01. The first extract began at `AF0101` and ended at `AF2911`; the corrected second extract begins at `AF2911` and ends at `AF3406`. The latter contains 76 rows (75 unique P-codes after accounting for AF2911? No: 76 rows and 76 unique P-codes). No source organization, publication date, URL, version, or licensing metadata accompanied the pasted text.

**This is user-supplied evidence, not an independently verified primary source.** It must not be used to certify official district names or silently overwrite the draft runtime reference.

## Join and preservation rules
- Match administrative units by exact `adm2_pcode`.
- Validate parent relationships by exact `adm1_pcode`.
- Preserve supplied labels separately from candidate labels.
- Do not infer missing records from sequence gaps.
- Do not replace runtime labels until source provenance and row-level records are confirmed.

## Earlier spot-checks
| ADM2 P-code | Pasted ADM2 label | Current draft label | Review note |
|---|---|---|---|
| AF0606 | کوز کونړ | کوز کنر | Local-script spelling variant; preserve both pending source confirmation. |
| AF0901 | بغلان مرکزی | پلخمری | Material name discrepancy; do not overwrite. |
| AF0905 | بغلان مرکزی | بغلان جدید | Material name discrepancy; do not overwrite. |
| AF1119 | ناوه | ناوه | ADM2 matches; supplied ADM1 label had mixed-script text. |
| AF2002 | حضرت sultan | حضرت سلطان | Mixed-script source label; not a certified correction. |
| AF2110 | Not present in supplied extract | Not present in 401-unit draft | Do not infer or synthesize. |
| AF2711 | مقر سپین بولدک | سپین بولدک | Material name discrepancy; preserve both pending primary-source check. |

## Corrected second-extract machine comparison
The corrected second extract contains **76 rows and 76 unique ADM2 P-codes** (AF2911–AF3406). It was compared by exact P-code against `assets/data/afghanistan_admin_divisions_reference_draft.json` on branch `feature/modern-calendar-agriculture-prayer` (draft blob SHA `5334b4d9a54c97f3d88ad31a4677ac480d2fcb4b`).

- **56 of 76** supplied P-codes exist in the current 401-unit draft.
- **20 supplied P-codes** are absent: AF2915, AF2916, AF2917, AF2918, AF2919, AF3014, AF3015, AF3016, AF3017, AF3018, AF3019, AF3108, AF3109, AF3110, AF3217, AF3218, AF3219, AF3220, AF3312, AF3406.
- Among the 56 matched codes, **11 local-script labels differ**:
  - AF2914: supplied `خان چهارباغ`; draft `خان چارباغ`.
  - AF3003: supplied `ناوه`; draft `ناوه بارکزائی`.
  - AF3004: supplied `گرشک`; draft `نهر سراج`.
  - AF3011: supplied `خانشین`; draft `ریگ خان نشین`.
  - AF3105: supplied `بالامرغاب`; draft `بالا مرغاب`.
  - AF3206: supplied `پښتون زرغون`; draft `پشتون زرغون`.
  - AF3212: supplied `اوبه`; draft `اوبی`.
  - AF3302: supplied `پُشت رود`; draft `پشترود`.
  - AF3310: supplied `گُلستان`; draft `گلستان`.
  - AF3404: supplied `چهاربرجک`; draft `چاربرجک`.
  - AF3405: supplied `خاشرود`; draft `خاش رود`.
- **No parent ADM1 P-code mismatch** was found among the 56 matched records.
- The supplied label for AF3110 is `تگاب alam`, containing Latin-script text; retain it verbatim as supplied and request source clarification rather than silently normalizing it.

These are comparison results only. The 20 absent codes must not be added to runtime data from this extract alone, and none of the 11 label differences is accepted as a correction without source verification. Supplied ADM1 parent labels are not independent proof of official province spellings.

## CI verification
The Flutter validation workflow for commit `435c2c83035c0098d1f8ee745575ef38d47432a7` completed successfully on 2026-11-01. The preceding failed run was caused by a test expecting `غزني` while the existing draft province label is `غزنی`; the test expectation was corrected without changing the dataset label. CI validates code and dataset structure, not the truth or official status of administrative names.

## Next verification required
Obtain the complete source file or authoritative published dataset with provenance and version metadata. Then run a full row-level audit for duplicate P-codes, missing/extra P-codes, parent-code mismatches, nulls, and local/English label differences. Keep the draft dataset unchanged until discrepancies are resolved against the primary source.
