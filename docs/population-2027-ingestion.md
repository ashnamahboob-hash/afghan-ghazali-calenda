# Afghanistan 2027 population data ingestion

This procedure keeps the original population source files byte-for-byte intact. It does not normalize CSV values, fill blank cells, convert hyphen markers to zero, or merge this dataset with the app's separate 401-unit administrative selector.

## Source files and verified fingerprints

Put the three original CSV files in one local folder. The ingestion validator accepts the uploaded (1) aliases for ADM0 and ADM1 as well as the canonical (2) filenames.

| Level | Data rows (including aggregate where present) | Columns | Bytes | SHA-256 |
|---|---:|---:|---:|---|
| ADM0 | 1 | 44 | 1,330 | `772ea6f2aa323df95e7e76adf42e05236b83baa8ea9274d1abd436c6086bd5b5` |
| ADM1 | 35 | 50 | 19,436 | `ae8daf50bd930b2e4eeb7be8affc041ab2a8fd4dd2228158ee9e06fe63c1f411` |
| ADM2 | 458 | 56 | 224,169 | `06eed4523cd2ba83342c25d1cd82fab36ea06cf3165994162fc9fa87bcea71dc` |

The three source files were re-checked locally on 2026-11-01 against all fingerprints above. Their national aggregate is 50,489,104. ADM1 contains 34 province records plus one aggregate row; ADM2 contains 457 P-code records plus one aggregate row.

ADM2's original source contains 867 empty cells and 4,849 whitespace-padded literal hyphen markers (` -   `). These are source values, not numeric zeroes. Keep their original bytes and whitespace.

## Validate before ingesting

From the repository root:

    python scripts/ingest_population_2027.py --source-dir ./population-source

This performs validation only. It checks exact byte lengths and SHA-256 fingerprints before parsing, validates row and column counts, checks P-code uniqueness and the single aggregate row, and verifies the national total.

## Ingest after validation

Only after the validation-only run succeeds, run:

    python scripts/ingest_population_2027.py --source-dir ./population-source --ingest

The script stages verified copies and writes the exact original bytes into `assets/data/population/2027/`, then updates the metadata flags. Review the resulting Git diff and hashes before committing.

## Data separation and provenance

- Keep NSIA, MAIL, and FAO datasets separate; do not combine sources into one table.
- Do not merge the 457 ADM2 population records into the separate 401-unit administrative selector.
- Do not infer missing district values from province-level values.
- Source organization, publication date, source URL, and licence remain unverified in the metadata until confirmed from the publisher.
- A passing CI run validates the script and tests; it does not mean the CSV payloads have been committed. The metadata remains `repository_ingested: false` until the actual ingest is completed and reviewed.