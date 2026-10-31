# Kandahar District Reference Cross-check

**Review date:** 2026-10-31  
**Pilot province:** Kandahar (AF27)  
**Scope:** Compare the 16 district records in `assets/data/kandahar_districts.json` with the independent Open Admin Data Afghanistan administrative divisions dataset.

## Result

- District count: **16 / 16** in both datasets.
- District P-code / stable ID: **16 / 16 match**.
- English district name: **16 / 16 match**.
- Local-script spelling: **14 exact matches; 2 spelling/spacing variants**.
- OCHA COD-AB remains the primary administrative reference for final verification. The available OCHA metadata confirms the national dataset contains 34 provinces and 401 districts and is sourced from AGCHO, but this review did not obtain the OCHA row-level gazetteer. Therefore, no record is marked officially verified.

## Row-level comparison

| District ID | App Pashto/local label | Open Admin Data local label | English name | Result |
|---|---|---|---|---|
| AF2701 | کندهار | کندهار | Kandahar | Match |
| AF2702 | ارغنداب | ارغنداب | Arghandab | Match |
| AF2703 | دامان | دامان | Daman | Match |
| AF2704 | پنجوائی | پنجوائی | Panjwayi | Match |
| AF2705 | ژړۍ | ژړۍ | Zheray | Match |
| AF2706 | شاه ولی کوت | شاه ولی کوت | Shah Wali Kot | Match |
| AF2707 | خاکریز | خاکریز | Khakrez | Match |
| AF2708 | ارغستان | ارغستان | Arghestan | Match |
| AF2709 | غورک | غورک | Ghorak | Match |
| AF2710 | میوند | میوند | Maywand | Match |
| AF2711 | سپین بولدک | سپین بولدک | Spin Boldak | Match |
| AF2712 | نیش | نیش | Nesh | Match |
| AF2713 | میانشین | میانشین | Miyanshin | Match |
| AF2714 | شورابک | شور آبک | Shorabak | Local spelling/spacing variant |
| AF2715 | معروف | معروف | Maruf | Match |
| AF2716 | ریګ (شګه) | ریگ ( شگه ) | Reg | Local spelling/spacing variant |

## Decision

1. Keep all current district IDs and parent ID `AF27`; the independent reference corroborates them.
2. Keep the app's existing Pashto labels unchanged for now. The two variants above need local/official orthographic review before any change.
3. Keep Dari (`fa`) labels null until a reliable Dari spelling source is checked.
4. Keep every record's status as pending official verification. This cross-check is corroboration from an independent open dataset, not an OCHA row-level certification.

## Sources

- Open Admin Data, Afghanistan Administrative Divisions, CC BY 4.0: https://github.com/open-admin-data/afghanistan-administrative-divisions
- OCHA Afghanistan Subnational Administrative Boundaries (COD-AB), sourced from AGCHO: https://data.humdata.org/dataset/4c303d7b-8eae-4a5a-a3aa-b2331fa39d74
