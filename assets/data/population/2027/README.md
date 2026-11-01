# Afghanistan estimated population dataset — 2027

This directory is reserved for the source-preserving 2027 population dataset.

## Files expected

The three source CSVs were supplied in the conversation and independently inspected. Their original basenames, byte sizes and SHA-256 checksums are recorded in `dataset_metadata.json`.

| Administrative level | Original filename | Rows × columns |
|---|---|---:|
| ADM0 | `afg_estimated_population_2027_dwg_202607_admin0(2).csv` | 1 × 44 |
| ADM1 | `afg_estimated_population_2027_dwg_202607_admin1(2).csv` | 35 × 50 |
| ADM2 | `afg_estimated_population_2027_dwg_202607_admin2.csv` | 458 × 56 |

**Important:** The CSV payloads have not yet been committed to this directory. Do not treat the dataset as available to the Flutter app until all three source files have been added and their hashes re-verified.

## Data handling rules

- Keep the three original CSVs byte-for-byte unchanged. Do not rename columns, rewrite encoding, normalize names, or reformat numeric fields.
- Keep this population dataset separate from the app's 401-unit administrative draft reference, agricultural data, and prayer-time data.
- The ADM2 source contains 457 administrative-unit rows plus a national aggregate row. Do not insert the 457 rows into the 401-unit district selector.
- Join records only by exact source P-code after validating the relevant parent relationship. Never infer district-level population from a province total.
- Preserve empty cells as empty/null and preserve literal `-` markers as source values; neither means numeric zero.
- Keep source-specific datasets separate. Do not merge population figures from different publishers or years into one value.
- Do not label the dataset as official OCHA/AGCHO data unless an authoritative source establishes that provenance.
- Record source organization, source URL, publication/release date and licence only when verified from the original source.

## Current status

Source-file inspection and checksum calculation were completed. Repository ingestion is pending because the exact original CSV payloads have not yet been copied into this repository. The metadata intentionally marks provenance fields that have not been verified as unknown.

## Flutter data service

The Flutter-side parser is implemented in
`lib/services/population_2027_dataset.dart`. It reads ADM2 rows into an
independent population model and supports exact P-code lookup. It does not
modify or populate the 401-unit administrative selector.

The parser keeps source cells as strings, including empty values, commas,
whitespace-padded hyphen markers and quoted text. It skips the blank-ADM2-
P-code aggregate row and rejects duplicate ADM2 P-codes, missing parent
ADM1 P-codes, and malformed row widths.

**Integration is intentionally pending:** the original CSV payloads are not
yet committed, and the population CSV is not yet registered in
`pubspec.yaml`. Do not call the asset loader or expose population figures in
the app until the exact source file has been ingested and its checksum
re-verified. Parser unit tests use synthetic fixtures only; they do not
represent actual population observations.
