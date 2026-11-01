#!/usr/bin/env python3
"""Validate the structure and audit bookkeeping of the draft Afghanistan ADM2 reference.

This script does not certify administrative names or promote the draft dataset to
an official/runtime source. It checks identifiers, hierarchy, required labels,
and the internal consistency of the documented review counts.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


PROVINCE_ID = re.compile(r"^AF\d{2}$")
DISTRICT_ID = re.compile(r"^AF\d{4}$")


def fail(message: str) -> None:
    raise ValueError(message)


def unique(values: list[str], label: str) -> None:
    duplicates = sorted({value for value in values if values.count(value) > 1})
    if duplicates:
        fail(f"{label} must be unique; duplicates: {', '.join(duplicates[:10])}")


def validate(path: Path) -> list[str]:
    data = json.loads(path.read_text(encoding="utf-8"))
    checks: list[str] = []

    if data.get("schema_version") != "1.0.0":
        fail("schema_version must be 1.0.0")
    draft_identity = f"{data.get('dataset_id', '')} {data.get('purpose', '')}".lower()
    if "draft" not in draft_identity:
        fail("dataset ID or purpose must continue to identify this as a draft")
    checks.append("schema and draft status")

    provinces = data.get("provinces")
    if not isinstance(provinces, list) or not provinces:
        fail("provinces must be a non-empty list")
    province_ids = [p.get("id", "") for p in provinces]
    unique(province_ids, "province IDs")
    for province in provinces:
        pid = province.get("id", "")
        if not PROVINCE_ID.fullmatch(pid):
            fail(f"invalid province ID: {pid}")
        names = province.get("names", {})
        if not isinstance(names.get("local"), str) or not names["local"].strip():
            fail(f"missing local province name: {pid}")
        if not isinstance(names.get("en"), str) or not names["en"].strip():
            fail(f"missing English province name: {pid}")
    checks.append(f"{len(provinces)} unique provinces with bilingual labels")

    districts = []
    for province in provinces:
        children = province.get("districts")
        if not isinstance(children, list):
            fail(f"districts must be a list for {province['id']}")
        for district in children:
            districts.append((province, district))

    district_ids = [d.get("id", "") for _, d in districts]
    unique(district_ids, "district IDs")
    slugs = [d.get("slug", "") for _, d in districts]
    if any(not slug.strip() for slug in slugs):
        fail("every district must have a non-empty slug")
    unique(slugs, "district slugs")

    for province, district in districts:
        did = district.get("id", "")
        if not DISTRICT_ID.fullmatch(did):
            fail(f"invalid district ID: {did}")
        if not did.startswith(province["id"]):
            fail(f"district {did} does not belong to parent {province['id']}")
        names = district.get("names", {})
        if not isinstance(names.get("local"), str) or not names["local"].strip():
            fail(f"missing local district name: {did}")
        if not isinstance(names.get("en"), str) or not names["en"].strip():
            fail(f"missing English district name: {did}")
    checks.append(f"{len(districts)} unique ADM2 IDs/slugs; parent hierarchy and bilingual labels")

    counts = data.get("counts", {})
    if counts.get("provinces") != len(provinces):
        fail("counts.provinces does not match the province list")
    if counts.get("districts") != len(districts):
        fail("counts.districts does not match the district list")
    checks.append("published record counts match actual records")

    review = data.get("district_name_review_status", {})
    completed = review.get("completed_record_ids", [])
    pending = review.get("pending_discrepancy_record_ids", [])
    if len(completed) != len(set(completed)) or len(pending) != len(set(pending)):
        fail("review ID lists must not contain duplicates")
    if set(completed) & set(pending):
        fail("completed and pending review IDs must be disjoint")
    if set(completed) | set(pending) != set(district_ids):
        missing = sorted(set(district_ids) - (set(completed) | set(pending)))
        extra = sorted((set(completed) | set(pending)) - set(district_ids))
        fail(f"review IDs must cover every ADM2 exactly once; missing={missing[:5]}, extra={extra[:5]}")
    if review.get("workbook_name_matches_completed") != len(completed):
        fail("workbook_name_matches_completed does not match completed_record_ids")
    if review.get("workbook_name_matches_remaining") != len(pending):
        fail("workbook_name_matches_remaining does not match pending_discrepancy_record_ids")
    if review.get("records_compared") != len(districts):
        fail("records_compared does not match ADM2 record count")
    if review.get("exact_local_name_matches", 0) + review.get("local_name_discrepancies", 0) != len(districts):
        fail("exact matches + local discrepancies must equal the ADM2 record count")

    notes = review.get("discrepancy_notes", [])
    note_ids = [n.get("id") for n in notes]
    unique(note_ids, "discrepancy note IDs")
    if not set(pending).issubset(set(note_ids)):
        fail("every pending discrepancy must have an audit note")
    checks.append(
        f"review audit covers {len(completed)} completed and {len(pending)} pending records"
    )

    source_checks = review.get("independent_source_checks", [])
    if review.get("independent_source_checks_completed") != len(source_checks):
        fail("independent_source_checks_completed does not match the evidence list")
    checks.append(f"{len(source_checks)} targeted independent-source checks are accounted for")

    triage = review.get("review_triage", {})
    triage_total = (
        triage.get("orthographic_or_transliteration", 0)
        + triage.get("material_name_or_code_conflicts", 0)
        + triage.get("source_checked_or_alternate_name_pending_local_review", 0)
    )
    if triage.get("total_pending") != len(pending) or triage_total != len(pending):
        fail("review triage categories must sum to all pending discrepancies")
    checks.append(
        f"review triage accounts for {triage_total} pending discrepancies without closing them"
    )

    dataset_checks = data.get("dataset_level_source_checks", [])
    dataset_check_ids = [item.get("id", "") for item in dataset_checks]
    unique(dataset_check_ids, "dataset-level source check IDs")
    if not dataset_checks or any(not item.get("source_url") or not item.get("scope") for item in dataset_checks):
        fail("dataset-level source checks must include unique IDs, source URLs, and scope notes")
    checks.append(f"{len(dataset_checks)} dataset-level source checks are documented separately from row-level checks")

    secondary_checks = data.get("secondary_source_checks", [])
    secondary_ids = [item.get("id", "") for item in secondary_checks]
    unique(secondary_ids, "secondary source check IDs")
    if any(not item.get("source_urls") or not item.get("scope") or not item.get("finding") for item in secondary_checks):
        fail("secondary source checks must include source URLs, scope notes, and findings")
    checks.append(f"{len(secondary_checks)} secondary alias/name checks are documented without treating them as primary COD verification")

    return checks



def validate_parent_crosswalk(path: Path) -> list[str]:
    """Validate the separate user-supplied temporary-district parent crosswalk."""
    data = json.loads(path.read_text(encoding="utf-8"))
    records = data.get("records")
    if not isinstance(records, list) or not records:
        fail("parent crosswalk records must be a non-empty list")

    ids = [item.get("id", "") for item in records]
    unique(ids, "parent crosswalk ADM2 P-codes")
    if any(not DISTRICT_ID.fullmatch(code) for code in ids):
        fail("parent crosswalk contains an invalid ADM2 P-code")
    if any(not item.get("district_name_en") or not item.get("district_name_ps") for item in records):
        fail("every parent crosswalk record must have English and local names")
    if any(not item.get("parent_mapping_supplied") for item in records):
        fail("every parent crosswalk record must preserve its supplied parent label")
    if any(item.get("verification_status") != "pending" for item in records):
        fail("crosswalk records must remain pending until primary-source verification")

    workbook = data.get("workbook_crosscheck", {})
    if workbook.get("matching_pcodes") != len(records):
        fail("workbook cross-check count must equal crosswalk record count")
    if workbook.get("temporary_districts") != 11 or workbook.get("ordinary_districts") != 1:
        fail("v04 workbook classification must remain 11 temporary and 1 ordinary district")
    if workbook.get("ordinary_district_record_ids") != ["AF3015"]:
        fail("Babaji (AF3015) must remain the sole ordinary district in the supplied v04 cross-check")

    source_records = [item.get("source_workbook_crosscheck", {}) for item in records]
    if any(
        source.get("source_sheet") != "afg_admin2"
        or source.get("source_version") != "v04"
        or source.get("valid_on") != "2026-06-23"
        or source.get("adm2_pcode") != item.get("id")
        or not source.get("unittype_source_spelling")
        or not source.get("adm2_ref_name")
        for item, source in zip(records, source_records)
    ):
        fail("each crosswalk record must include its row-level v04 workbook cross-check")
    if sum(source.get("unit_type_normalized") == "Temporary District" for source in source_records) != 11:
        fail("row-level workbook classifications must contain exactly 11 temporary districts")
    if sum(source.get("unit_type_normalized") == "District" for source in source_records) != 1:
        fail("row-level workbook classifications must contain exactly one ordinary district")

    if data.get("counts", {}).get("records") != len(records):
        fail("crosswalk counts.records does not match records")
    if data.get("counts", {}).get("pending_records") != len(records):
        fail("all crosswalk records must be counted as pending")
    if data.get("counts", {}).get("verified_records") != 0:
        fail("crosswalk must not claim primary-source verification")
    return [
        f"parent crosswalk has {len(records)} unique ADM2 P-codes with row-level v04 workbook evidence",
        "parent crosswalk preserves 11 temporary-district classifications and Babaji as 1 ordinary district",
        "all parent crosswalk records remain pending; no primary-source verification is claimed",
    ]


def validate_secondary_audit(path: Path) -> list[str]:
    """Validate the recorded independent secondary ADM2 cross-check."""
    data = json.loads(path.read_text(encoding="utf-8"))
    counts = data.get("counts", {})
    if data.get("classification") != "secondary independent reference only; not official COD-AB evidence":
        fail("secondary cross-check must remain explicitly classified as non-official")
    if counts.get("source_records") != 401 or counts.get("candidate_records") != 401:
        fail("secondary cross-check must compare 401 source and candidate records")
    if counts.get("exact_id_matches") != 401 or counts.get("missing_candidate_ids") != []:
        fail("secondary cross-check must preserve the complete exact-ID join")
    if counts.get("exact_parent_province_id_matches") != 401 or counts.get("parent_province_id_differences") != 0:
        fail("secondary cross-check parent-province match counts are inconsistent")
    english = data.get("english_differences", [])
    local = data.get("local_script_differences", [])
    parents = data.get("parent_differences", [])
    if len(english) != counts.get("english_total_different_strings"):
        fail("English difference rows do not match the summary count")
    if len(local) != counts.get("local_script_total_different_strings"):
        fail("local-script difference rows do not match the summary count")
    if len(parents) != counts.get("parent_province_id_differences"):
        fail("parent difference rows do not match the summary count")
    if counts.get("english_exact_matches", 0) + counts.get("english_total_different_strings", 0) != 401:
        fail("English exact and differing labels must account for all 401 ADM2 records")
    if counts.get("local_script_exact_matches", 0) + counts.get("local_script_total_different_strings", 0) != 401:
        fail("local-script exact and differing labels must account for all 401 ADM2 records")
    triage = data.get("english_review_triage", {})
    triage_counts = triage.get("counts", {})
    triage_rows = triage.get("records", [])
    expected_triage = {
        "exact_match": 289,
        "formatting_only": 20,
        "minor_variant_non_blocking": 67,
        "manual_glance_recommended": 25,
        "total": 401,
    }
    if triage_counts != expected_triage or len(triage_rows) != 112:
        fail("English spelling-variation triage counts/ledger are inconsistent")
    if triage.get("candidate_labels_changed") is not False:
        fail("English secondary-source triage must not claim candidate labels were changed")
    if triage.get("official_certification") is not False:
        fail("English secondary-source triage must not claim official certification")
    if triage.get("draft_preview_blocked_by_english_spelling") is not False:
        fail("user-approved minor English spelling differences must remain non-blocking")
    method = data.get("comparison_method", {})
    if method.get("no_candidate_labels_changed") is not True or method.get("no_discrepancy_status_changed") is not True:
        fail("secondary cross-check must not claim candidate labels or review statuses were changed")
    if not data.get("source", {}).get("url") or not data.get("source", {}).get("raw_url"):
        fail("secondary cross-check must retain source and raw data URLs")
    return [
        "secondary reference cross-check covers 401 exact IDs and 401 parent IDs",
        f"secondary label difference ledgers are internally consistent ({len(english)} English, {len(local)} local-script)",
        "secondary cross-check remains non-official and does not close pending review records",
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "json_file",
        nargs="?",
        default="assets/data/afghanistan_admin_divisions_reference_draft.json",
        help="path to the draft administrative reference JSON",
    )
    args = parser.parse_args()
    try:
        checks = validate(Path(args.json_file))
        crosswalk_path = Path("assets/data/temporary_district_parent_mapping_draft.json")
        if crosswalk_path.exists():
            checks.extend(validate_parent_crosswalk(crosswalk_path))
        secondary_audit_path = Path("docs/admin-reference-secondary-crosscheck-open-admin-data-2026-11-01.json")
        if secondary_audit_path.exists():
            checks.extend(validate_secondary_audit(secondary_audit_path))
    except (OSError, json.JSONDecodeError, ValueError, TypeError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1

    print("PASS: Afghanistan administrative reference structural validation")
    for item in checks:
        print(f"  - {item}")
    print("NOTE: This validates structure/audit bookkeeping only; it does not verify official names.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
