# FlutterFlow Database Schema Proposal

**Status:** Proposed logical schema; not yet provisioned in Supabase/Firebase.  
**Primary key policy:** Use stable P-codes for geography, immutable IDs for source datasets and records. Localized names are display fields, never relational keys.

## 1. Reference tables

### `cities`
| Field | Type | Notes |
|---|---|---|
| id | text | Stable key: kabul, kandahar, herat, mazar_e_sharif, jalalabad, kunduz |
| name_ps / name_fa / name_en | text | Localized labels |
| latitude / longitude | numeric | Existing app coordinates; validate before release |
| timezone_id | text | IANA zone, expected Afghanistan zone; do not store only a fixed offset for all future date logic |
| is_active | boolean | Availability |

### `provinces`
| Field | Type | Notes |
|---|---|---|
| pcode | text PK | e.g. AF27 |
| name_ps / name_fa / name_en | text nullable | Each language reviewed independently |
| verification_status | enum/text | draft, pending, verified, retired |
| source_dataset_id | FK | Exact provenance |

### `administrative_units`
| Field | Type | Notes |
|---|---|---|
| pcode | text PK | Stable ADM2 P-code |
| province_pcode | text FK | References provinces.pcode |
| name_ps / name_fa / name_en | text nullable | Preserve unresolved labels |
| administrative_type | text nullable | Preserve source literal, including source spelling |
| reference_set | text | e.g. draft_401; population_2027_457 |
| verification_status | text | draft, pending, verified |
| source_dataset_id | FK | Provenance |

Important: the 401-unit draft selector and 457-row population ADM2 set are separate source sets. Model source membership explicitly. Never force one-to-one assumptions where a source has additional units or differing administrative types.

## 2. Population data

### `population_datasets`
- `id` text PK
- `title` text
- `publisher` text nullable until confirmed
- `source_url` text nullable until confirmed
- `publication_date` date nullable
- `reference_year` integer (2027 for the supplied estimate)
- `methodology` text nullable until confirmed
- `licence` text nullable until confirmed
- `status` text: source_unverified, reviewed, approved, retired
- `raw_sha256` text
- `raw_filename` text
- `notes` text

### `population_observations`
- `id` uuid/text PK
- `dataset_id` FK
- `geography_level` text: ADM0 / ADM1 / ADM2
- `geography_pcode` text
- `measure_code` text
- `value_numeric` numeric nullable
- `source_value_raw` text nullable
- `unit` text
- `value_status` text: source_reported, calculated, modelled, estimated, missing, suppressed
- `sex` text nullable
- `age_group` text nullable
- `urban_rural` text nullable
- `source_column` text nullable
- `method_note` text nullable

Preserve raw source rows separately. A literal hyphen, blank, NULL or whitespace-padded marker is not zero. Store normalized values only in a separate analytical layer, with the original source value and missingness status retained.

### Population measures

Map source columns explicitly to measures only after inspecting the exact CSV headers:
- total population
- male / female population
- age-by-sex components
- urban / rural population
- household count / household size (only if source columns exist)
- density (only if a compatible area source exists)

Do not infer measures that are absent. Do not publish household or density metrics merely because they are desired product features.

## 3. Agricultural data

### `agricultural_advisories`
- `id` uuid/text PK
- `crop_id` FK
- `province_pcode` FK
- `district_pcode` FK nullable
- `activity` text
- `season` text
- `solar_start_month/day`, `solar_end_month/day` nullable
- `recommendation_ps/fa/en` text
- `conditions` json/text nullable
- `verification_status` text
- `reviewer` text nullable
- `reviewed_at` timestamp nullable
- `valid_from`, `valid_until` date nullable
- `source_id` FK

### `crops`
- `id` text PK
- `name_ps/fa/en` text
- `crop_group` text nullable

### `sources`
- `id` text PK
- `organization` text
- `title` text
- `url` text
- `publication_date` date nullable
- `accessed_at` date
- `licence` text nullable
- `source_type` text
- `notes` text

Only advisories with an approved verification state and applicable source should be displayed as guidance. Pending records stay hidden from normal user advice.

## 4. User preferences (if accounts are enabled)

### `user_preferences`
- `user_id` PK/FK to auth user
- `language` text
- `theme_mode` text
- `city_id` FK
- `asr_factor` integer
- `fajr_angle` numeric
- `isha_angle` numeric
- `updated_at` timestamp

Authentication is not required for the core read-only calendar. Do not add user accounts unless sync, saved preferences or other account features justify them.

## 5. Security and access

- Public read-only access for approved reference data.
- No public write access to population, geography or agriculture source records.
- Administrative edits restricted to trusted maintainers with audit history.
- If Supabase is selected, enable Row Level Security on every exposed table and write explicit read/write policies.
- Do not store private credentials, API keys or service-role secrets in FlutterFlow client code.
- Keep source snapshots and export artifacts in controlled storage with provenance metadata.

## 6. Backend decision

This is a relational dataset with exact P-code joins and source lineage. Supabase/PostgreSQL is the leading candidate, but it is not selected yet. First confirm expected offline behavior, dataset sizes, refresh frequency, user authentication needs, and whether the app must work without connectivity. Static calendar logic and bounded reference data can remain local; large or updated population tables may need a backend or downloadable versioned snapshots.
