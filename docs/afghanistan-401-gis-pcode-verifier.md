# Afghanistan ADM2 GIS P-code verifier

This is a **diagnostic-only** CSV audit. It preserves all input rows and labels.
It does not certify OCHA provenance, establish legal/administrative status, delete
watch-list codes, or rewrite source labels.

## Required CSV columns

The input CSV must contain these exact column names:

- `adm2_pcode`
- `adm2_name1`
- `adm1_pcode`
- `adm1_name1`

The CSV may contain additional columns; the report retains the four audit fields.

## Run the audit

From the repository root:

```bash
python tool/afghanistan_401_gis_pcode_verifier.py \
  --input path/to/your_admin_crosswalk.csv \
  --output artifacts/afghanistan_401_gis_pcode_audit.json
```

By default, the tool compares the row count with 401. To disable that count check:

```bash
python tool/afghanistan_401_gis_pcode_verifier.py \
  --input path/to/your_admin_crosswalk.csv \
  --expected-count 0
```

To compare exact P-codes and labels with the app's current **draft** reference:

```bash
python tool/afghanistan_401_gis_pcode_verifier.py \
  --input path/to/your_admin_crosswalk.csv \
  --reference-json assets/data/afghanistan_admin_divisions_reference_draft.json \
  --output artifacts/afghanistan_401_gis_pcode_audit.json
```

## What it checks

- Required fields, ADM1/ADM2 P-code formats, duplicate ADM2 P-codes, and ADM2-to-ADM1 prefix consistency.
- Mixed Unicode scripts (for example Arabic-script plus Latin or Bengali-script text) without removing any characters.
- Different province labels attached to the same ADM1 P-code.
- User-supplied protected labels, allowed variants, cleanup suggestions, and watch-list codes.
- Optional exact-P-code comparison with the app's draft reference.

Findings are marked `error`, `warning`, or `info`. Suggested labels are metadata
in the report only; the input label remains unchanged. CSV row numbers in findings
start at 2 because row 1 contains the header. A report row number of 0 represents
a dataset-level finding.

## Important limitations

- The 401 expected-row count is a diagnostic expectation, not proof that all official
  units were retrieved.
- `BANNED_CODES` and `CUSTOM_OVERRIDES` are user-supplied review rules, not official
  OCHA determinations. A watch-list code is reported and retained.
- A label difference against the app draft reference does not prove which label is
  correct. Resolve differences against a complete, attributable, row-level primary
  source before changing the draft reference.
- The script does not change the app's runtime data or certify the draft gazetteer.
