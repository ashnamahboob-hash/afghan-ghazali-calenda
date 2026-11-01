#!/usr/bin/env python3
"""Diagnostic audit for Afghanistan ADM2 GIS P-code CSV extracts.

This tool preserves every input row and label. It does not certify OCHA
provenance, delete "banned" codes, or silently rewrite names.
"""
from __future__ import annotations

import argparse
import csv
import json
import re
import sys
import unicodedata
from collections import defaultdict
from pathlib import Path
from typing import Any, Iterable

ADM2_PATTERN = re.compile(r"^AF\d{4}$")
ADM1_PATTERN = re.compile(r"^AF\d{2}$")

# User-supplied review rules. These are not official-source determinations.
CUSTOM_OVERRIDES = {
    "AF0606": {
        "allowed_variants": ["کوز کونړ", "کوز کنر"],
        "action": "PRESERVE_BOTH",
    },
    "AF0901": {
        "protected_label": "بغلان مرکزی",
        "blocked_overwrites": ["پلخمری"],
        "action": "PROTECT",
    },
    "AF0905": {
        "protected_label": "بغلان مرکزی",
        "blocked_overwrites": ["بغلان جدید"],
        "action": "PROTECT",
    },
    "AF2002": {
        "dirty_label": "حضرت sultan",
        "cleaned_label": "حضرت سلطان",
        "action": "SANITIZE",
    },
    "AF2711": {
        "allowed_variants": ["مقر سپین بولدک", "سپین بولدک"],
        "action": "PRESERVE_BOTH",
    },
}

# User-supplied watch list only; membership does not prove a code is invalid.
BANNED_CODES = {"AF2110"}
REQUIRED_FIELDS = ("adm2_pcode", "adm2_name1", "adm1_pcode", "adm1_name1")


def _text(value: Any) -> str:
    return str(value).strip() if value is not None else ""


def _script_of(char: str) -> str | None:
    if not char.isalpha():
        return None
    name = unicodedata.name(char, "")
    for script in ("LATIN", "ARABIC", "BENGALI", "DEVANAGARI", "CYRILLIC"):
        if script in name:
            return script.title()
    return "Other"


def detected_scripts(value: str) -> list[str]:
    """Return distinct Unicode scripts present in a label, in encounter order."""
    found = []
    for char in value:
        script = _script_of(char)
        if script and script not in found:
            found.append(script)
    return found


def _add(
    findings: list[dict[str, Any]],
    row: int,
    pcode: str,
    field: str,
    value: str,
    severity: str,
    code: str,
    message: str,
    suggested_value: str | None = None,
) -> None:
    item = {
        "row": row,
        "adm2_pcode": pcode,
        "field": field,
        "value": value,
        "severity": severity,
        "code": code,
        "message": message,
    }
    if suggested_value is not None:
        item["suggested_value"] = suggested_value
    findings.append(item)


def _reference_index(reference: dict[str, Any] | None) -> dict[str, dict[str, str]]:
    """Index the app's nested draft reference by ADM2 P-code, if supplied."""
    index: dict[str, dict[str, str]] = {}
    if not reference:
        return index
    for province in reference.get("provinces", []):
        province_id = _text(province.get("id"))
        province_name = _text((province.get("names") or {}).get("local"))
        for district in province.get("districts", []):
            names = district.get("names") or {}
            code = _text(district.get("id"))
            if code:
                index[code] = {
                    "adm1_pcode": province_id,
                    "adm1_name1": province_name,
                    "adm2_name1": _text(names.get("local")),
                }
    return index


def audit_records(
    incoming_records: Iterable[dict[str, Any]],
    expected_count: int | None = 401,
    banned_codes: set[str] | None = None,
    overrides: dict[str, dict[str, Any]] | None = None,
    reference: dict[str, Any] | None = None,
) -> dict[str, Any]:
    """Audit records without dropping rows or mutating supplied labels."""
    banned = BANNED_CODES if banned_codes is None else banned_codes
    rules = CUSTOM_OVERRIDES if overrides is None else overrides
    findings: list[dict[str, Any]] = []
    rows: list[dict[str, str]] = []
    seen_codes: dict[str, int] = {}
    parent_labels: dict[str, set[str]] = defaultdict(set)
    reference_rows = _reference_index(reference)

    for row_number, raw in enumerate(incoming_records, start=2):
        record = {field: _text(raw.get(field)) for field in REQUIRED_FIELDS}
        rows.append(record)
        pcode = record["adm2_pcode"]
        parent = record["adm1_pcode"]

        for field in REQUIRED_FIELDS:
            if not record[field]:
                _add(findings, row_number, pcode, field, "", "error",
                     "MISSING_VALUE", f"Required field {field} is empty.")

        if pcode and not ADM2_PATTERN.fullmatch(pcode):
            _add(findings, row_number, pcode, "adm2_pcode", pcode, "error",
                 "INVALID_ADM2_PCODE", "Expected format AF followed by four digits.")
        if parent and not ADM1_PATTERN.fullmatch(parent):
            _add(findings, row_number, pcode, "adm1_pcode", parent, "error",
                 "INVALID_ADM1_PCODE", "Expected format AF followed by two digits.")
        if pcode and parent and ADM2_PATTERN.fullmatch(pcode) and ADM1_PATTERN.fullmatch(parent):
            if not pcode.startswith(parent):
                _add(findings, row_number, pcode, "adm1_pcode", parent, "error",
                     "PARENT_PREFIX_MISMATCH",
                     "ADM2 P-code prefix does not match the supplied ADM1 P-code.")

        if pcode:
            if pcode in seen_codes:
                _add(findings, row_number, pcode, "adm2_pcode", pcode, "error",
                     "DUPLICATE_ADM2_PCODE",
                     f"ADM2 P-code was already seen on CSV row {seen_codes[pcode]}.")
            else:
                seen_codes[pcode] = row_number

        if parent and record["adm1_name1"]:
            parent_labels[parent].add(record["adm1_name1"])

        for field in ("adm2_name1", "adm1_name1"):
            label = record[field]
            scripts = detected_scripts(label)
            if len(scripts) > 1:
                _add(findings, row_number, pcode, field, label, "warning",
                     "MIXED_UNICODE_SCRIPTS",
                     "Label contains more than one writing script: " + ", ".join(scripts) + ".")
            elif "Latin" in scripts:
                _add(findings, row_number, pcode, field, label, "warning",
                     "LATIN_SCRIPT_LABEL",
                     "Label contains Latin-script letters; review against the source.")

        if pcode in banned:
            _add(findings, row_number, pcode, "adm2_pcode", pcode, "warning",
                 "USER_WATCHLIST_CODE",
                 "Code appears in the user-supplied watch list; it is retained, not deleted.")

        rule = rules.get(pcode)
        if rule:
            action = rule.get("action")
            label = record["adm2_name1"]
            if action == "PRESERVE_BOTH":
                allowed = rule.get("allowed_variants", [])
                if label in allowed:
                    _add(findings, row_number, pcode, "adm2_name1", label, "info",
                         "USER_VARIANT_PRESERVED",
                         "Label matches a user-supplied allowed variant; no normalization applied.")
                else:
                    _add(findings, row_number, pcode, "adm2_name1", label, "warning",
                         "OVERRIDE_VARIANT_REVIEW",
                         "Label is not among the user-supplied variants; manual review required.")
            elif action == "PROTECT" and label in rule.get("blocked_overwrites", []):
                _add(findings, row_number, pcode, "adm2_name1", label, "warning",
                     "PROTECTED_LABEL_CONFLICT",
                     "Label conflicts with a user-supplied protected-label rule; original retained.",
                     rule.get("protected_label"))
            elif action == "SANITIZE" and label == rule.get("dirty_label"):
                _add(findings, row_number, pcode, "adm2_name1", label, "warning",
                     "SANITIZATION_SUGGESTION",
                     "Possible mixed-script spelling; suggestion only, original retained.",
                     rule.get("cleaned_label"))

        if reference_rows and pcode in reference_rows:
            ref = reference_rows[pcode]
            if parent and ref["adm1_pcode"] and parent != ref["adm1_pcode"]:
                _add(findings, row_number, pcode, "adm1_pcode", parent, "warning",
                     "REFERENCE_PARENT_MISMATCH",
                     f"Supplied parent differs from draft reference parent {ref['adm1_pcode']}.")
            if record["adm2_name1"] and ref["adm2_name1"] and record["adm2_name1"] != ref["adm2_name1"]:
                _add(findings, row_number, pcode, "adm2_name1", record["adm2_name1"], "info",
                     "REFERENCE_LABEL_DIFFERENCE",
                     "Label differs from the app draft reference; this is a comparison finding, not proof either label is official.",
                     ref["adm2_name1"])
        elif reference_rows and pcode:
            _add(findings, row_number, pcode, "adm2_pcode", pcode, "warning",
                 "NOT_IN_DRAFT_REFERENCE",
                 "P-code was not found in the supplied app draft reference.")

    for parent, labels in parent_labels.items():
        if len(labels) > 1:
            _add(findings, 0, "", "adm1_name1", " | ".join(sorted(labels)), "warning",
                 "INCONSISTENT_PARENT_LABEL",
                 f"ADM1 code {parent} is associated with multiple supplied province labels.")

    if expected_count is not None and len(rows) != expected_count:
        _add(findings, 0, "", "record_count", str(len(rows)), "warning",
             "UNEXPECTED_RECORD_COUNT",
             f"Found {len(rows)} records; expected {expected_count}. Count alone does not prove completeness.")

    severity_counts = {
        level: sum(1 for item in findings if item["severity"] == level)
        for level in ("error", "warning", "info")
    }
    return {
        "report_type": "Afghanistan ADM2 GIS P-code diagnostic audit",
        "status": "diagnostic_only_not_official_verification",
        "input_record_count": len(rows),
        "unique_adm2_pcode_count": len(seen_codes),
        "expected_record_count": expected_count,
        "findings_count": len(findings),
        "severity_counts": severity_counts,
        "records": rows,
        "findings": findings,
        "important_note": (
            "Input records and labels are preserved. User overrides and watch-list "
            "entries are not official determinations. A matching count or P-code "
            "pattern does not establish OCHA provenance or legal/administrative validity."
        ),
    }


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        missing = [field for field in REQUIRED_FIELDS if field not in (reader.fieldnames or [])]
        if missing:
            raise ValueError("CSV is missing required columns: " + ", ".join(missing))
        return list(reader)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", required=True, help="Input CSV with the four ADM2/ADM1 columns.")
    parser.add_argument("--output", default="artifacts/afghanistan_401_gis_pcode_audit.json",
                        help="JSON diagnostic report path.")
    parser.add_argument("--expected-count", type=int, default=401,
                        help="Expected row count; use 0 to disable the count check.")
    parser.add_argument("--reference-json",
                        help="Optional app draft reference JSON for exact-P-code comparison.")
    args = parser.parse_args(argv)

    try:
        records = read_csv(Path(args.input))
        reference = None
        if args.reference_json:
            reference = json.loads(Path(args.reference_json).read_text(encoding="utf-8"))
        report = audit_records(
            records,
            expected_count=None if args.expected_count == 0 else args.expected_count,
            reference=reference,
        )
        output = Path(args.output)
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n",
                          encoding="utf-8")
        print(f"Audit report saved: {output}")
        print(
            f"Rows: {report['input_record_count']}; unique P-codes: "
            f"{report['unique_adm2_pcode_count']}; findings: {report['findings_count']} "
            f"(errors {report['severity_counts']['error']}, "
            f"warnings {report['severity_counts']['warning']}, "
            f"info {report['severity_counts']['info']})"
        )
        print("Diagnostic only: source labels were not rewritten and no rows were deleted.")
        return 0
    except (OSError, json.JSONDecodeError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
