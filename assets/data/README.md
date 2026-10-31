# Kandahar District Data (Pilot)

## Status
Draft dataset. It preserves the 16 district identifiers and Pashto labels already present in `lib/screens/agriculture_screen.dart`. It is **not yet an officially verified gazetteer**.

## Files
- `kandahar_districts.json`: data and provenance metadata.

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
