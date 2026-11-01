# FlutterFlow App State Contract

Use App State for small user preferences and navigation selections only. Do not store large datasets or complete CSV payloads in global state.

| Variable | Type | Default | Persist | Purpose |
|---|---|---|---|---|
| appLanguage | String | ps | yes | ps, fa, en |
| themeMode | String | system | yes | system, light, dark |
| selectedDateIso | String | local today | yes | Local calendar date as YYYY-MM-DD |
| selectedCityId | String | kabul | yes | Stable city key |
| asrFactor | int | 2 | yes | 2 Hanafi; 1 Standard/Shafi'i |
| fajrAngle | double | 18.0 (provisional) | yes | Existing service default; verify before release |
| ishaAngle | double | 17.0 (provisional) | yes | Existing service default; verify before release |
| utcOffsetHours | double | 4.5 | yes | Current Afghanistan offset; use IANA timezone for robust future handling |
| selectedProvincePcode | String | empty | yes | Selected province P-code |
| selectedDistrictPcode | String | empty | yes | Selected ADM2 P-code |
| populationDatasetId | String | current approved dataset or empty | yes | Selected population release |
| populationMeasure | String | population_total | yes | Selected chart measure |
| showDraftData | bool | false | no | Explicitly reveal research-only records in admin/research views |

## State rules
- Use stable IDs/P-codes rather than translated labels.
- Store local date strings as dates, not UTC instants, to avoid timezone shifts.
- Changing appLanguage must update both translations and text direction.
- If selected province changes, clear selectedDistrictPcode if it does not belong to that province.
- Never set showDraftData=true in the normal end-user flow.
- Do not store credentials, secrets or service-role keys in App State.
