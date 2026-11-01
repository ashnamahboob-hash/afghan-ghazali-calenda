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


PROVINCE_ID = re.compile(r"^AF\\d{2}$")
DISTRICT_ID = re.compile(r"^AF\\d{4}$")


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
    if "draft" not in str(data.get("status", "")).lower():
        fail("dataset status must continue to identify this as a draft")
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

    return checks


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
