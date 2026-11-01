#!/usr/bin/env python3
"""Fetch an OCHA COD global Admin2 layer snapshot filtered to Afghanistan.

This utility archives source attributes for manual P-code/name/parent review.
It never edits the app's draft reference and never certifies names by itself.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import re
import sys
from urllib.error import URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


LAYER_URL = "https://gis.unocha.org/server/rest/services/COD/GLB_COD_Admin2/MapServer/0"
QUERY_URL = f"{LAYER_URL}/query"
OUT_FIELDS = [
    "adm2_pcode", "adm2_name", "adm2_name1", "adm2_name2", "adm2_name3",
    "adm1_pcode", "adm1_name", "adm1_name1", "adm1_name2", "adm1_name3",
    "adm0_pcode", "valid_on", "valid_to", "version_no",
    "lang", "lang1", "lang2", "lang3",
]


def build_snapshot(payload: dict, retrieved_at: str, expected_count: int = 401) -> dict:
    if not isinstance(payload, dict):
        raise ValueError("OCHA response must be a JSON object")
    if payload.get("error"):
        raise ValueError(f"OCHA ArcGIS error: {payload['error']}")
    features = payload.get("features")
    if not isinstance(features, list):
        raise ValueError("OCHA response does not contain a features list")

    rows = []
    seen = set()
    for index, feature in enumerate(features):
        attributes = feature.get("attributes") if isinstance(feature, dict) else None
        if not isinstance(attributes, dict):
            raise ValueError(f"feature {index} has no attributes object")
        code = attributes.get("adm2_pcode")
        parent = attributes.get("adm1_pcode")
        country = attributes.get("adm0_pcode")
        if not isinstance(code, str) or not re.fullmatch(r"AF\\d{4}", code):
            raise ValueError(f"feature {index} has invalid/missing ADM2 P-code: {code!r}")
        if code in seen:
            raise ValueError(f"duplicate ADM2 P-code in OCHA response: {code}")
        seen.add(code)
        if not isinstance(parent, str) or not re.fullmatch(r"AF\\d{2}", parent):
            raise ValueError(f"{code} has invalid/missing ADM1 parent P-code: {parent!r}")
        if country != "AFG":
            raise ValueError(f"{code} is not tagged with adm0_pcode=AFG")
        rows.append({field: attributes.get(field) for field in OUT_FIELDS})

    count_matches = len(rows) == expected_count
    return {
        "snapshot_id": "OCHA_COD_GLOBAL_ADMIN2_AFG",
        "source_layer_url": LAYER_URL,
        "query_url": QUERY_URL,
        "retrieved_at_utc": retrieved_at,
        "query": {
            "where": "adm0_pcode='AFG'",
            "out_fields": OUT_FIELDS,
            "return_geometry": False,
            "format": "json",
        },
        "expected_feature_count": expected_count,
        "retrieved_feature_count": len(rows),
        "unique_adm2_pcodes": len(seen),
        "transfer_limit_exceeded": bool(payload.get("exceededTransferLimit", False)),
        "snapshot_status": (
            "retrieved_pending_manual_comparison"
            if count_matches and not payload.get("exceededTransferLimit", False)
            else "unexpected_count_or_transfer_limit_pending_review"
        ),
        "important_note": (
            "A successful download and count check do not certify names, parent "
            "relationships, current legal status, or the app's draft records. "
            "Compare every row by exact P-code and retain source provenance before "
            "changing any candidate label."
        ),
        "features": rows,
    }


def fetch_payload(timeout: int = 60) -> dict:
    params = {
        "where": "adm0_pcode='AFG'",
        "outFields": ",".join(OUT_FIELDS),
        "returnGeometry": "false",
        "orderByFields": "adm2_pcode",
        "f": "json",
    }
    url = f"{QUERY_URL}?{urlencode(params)}"
    request = Request(url, headers={"User-Agent": "Afghanistan-Admin-Reference-Audit/1.0"})
    with urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        default="artifacts/ocha_cod_ab_afg_adm2_snapshot.json",
        help="where to archive the retrieved source snapshot",
    )
    parser.add_argument("--expected-count", type=int, default=401)
    parser.add_argument("--timeout", type=int, default=60)
    args = parser.parse_args()

    try:
        payload = fetch_payload(args.timeout)
        retrieved_at = datetime.now(timezone.utc).isoformat()
        snapshot = build_snapshot(payload, retrieved_at, args.expected_count)
        output = Path(args.output)
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(
            json.dumps(snapshot, ensure_ascii=False, indent=2) + "\\n",
            encoding="utf-8",
        )
        print(f"Saved OCHA source snapshot: {output}")
        print(
            f"Retrieved {snapshot['retrieved_feature_count']} features; "
            f"unique ADM2 P-codes: {snapshot['unique_adm2_pcodes']}; "
            f"status: {snapshot['snapshot_status']}"
        )
        if snapshot["snapshot_status"] != "retrieved_pending_manual_comparison":
            return 2
        print("NOTE: This is a source snapshot only; no candidate labels were certified.")
        return 0
    except (OSError, URLError, TimeoutError, json.JSONDecodeError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
