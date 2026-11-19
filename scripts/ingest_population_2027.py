#!/usr/bin/env python3
"""Validate and byte-preservingly ingest Afghanistan 2027 population CSVs.

Place the three original CSVs in a source directory, then run:
  python scripts/ingest_population_2027.py --source-dir ./population-source --ingest

Without --ingest, the script validates only and does not modify the repository.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import shutil
import sys
import tempfile
from pathlib import Path

DATASET_DIR = Path("assets/data/population/2027")
METADATA_PATH = DATASET_DIR / "dataset_metadata.json"
EXPECTED = {
    "ADM0": {
        "filename": "afg_estimated_population_2027_dwg_202607_admin0(2).csv",
        "aliases": (
            "afg_estimated_population_2027_dwg_202607_admin0(2).csv",
            "afg_estimated_population_2027_dwg_202607_admin0(1).csv",
            "afg_estimated_population_2027_dwg_202607_admin0.csv",
        ),
        "sha256": "772ea6f2aa323df95e7e76adf42e05236b83baa8ea9274d1abd436c6086bd5b5",
        "bytes": 1330, "rows": 1, "columns": 44, "pcode": "adm0_pcode",
    },
    "ADM1": {
        "filename": "afg_estimated_population_2027_dwg_202607_admin1(2).csv",
        "aliases": (
            "afg_estimated_population_2027_dwg_202607_admin1(2).csv",
            "afg_estimated_population_2027_dwg_202607_admin1(1).csv",
            "afg_estimated_population_2027_dwg_202607_admin1.csv",
        ),
        "sha256": "ae8daf50bd930b2e4eeb7be8affc041ab2a8fd4dd2228158ee9e06fe63c1f411",
        "bytes": 19436, "rows": 35, "columns": 50, "pcode": "adm1_pcode",
    },
    "ADM2": {
        "filename": "afg_estimated_population_2027_dwg_202607_admin2.csv",
        "aliases": ("afg_estimated_population_2027_dwg_202607_admin2.csv",),
        "sha256": "06eed4523cd2ba83342c25d1cd82fab36ea06cf3165994162fc9fa87bcea71dc",
        "bytes": 224169, "rows": 458, "columns": 56, "pcode": "adm2_pcode",
    },
}
NATIONAL_TOTAL = "50,489,104"
POPULATION_COLUMN = "Total Estimated Population 2027"


def locate_source(source_dir: Path, aliases: tuple[str, ...]) -> Path:
    for name in aliases:
        candidate = source_dir / name
        if candidate.is_file():
            return candidate
    raise FileNotFoundError("Missing source file; accepted names: " + ", ".join(aliases))


def validate_file(level: str, spec: dict, source: Path) -> tuple[str, int]:
    raw = source.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if len(raw) != spec["bytes"]:
        raise ValueError(f"{level}: byte size mismatch ({len(raw)} != {spec['bytes']})")
    if digest != spec["sha256"]:
        raise ValueError(f"{level}: SHA-256 mismatch ({digest})")

    # newline='' lets csv handle the original CSV line endings correctly.
    with source.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        if len(reader.fieldnames or []) != spec["columns"]:
            raise ValueError(f"{level}: column count mismatch")
        records = list(reader)

    if len(records) != spec["rows"]:
        raise ValueError(f"{level}: data row count mismatch")
    pcodes = [row.get(spec["pcode"], "").strip() for row in records]
    if level == "ADM0":
        if pcodes != ["AF"]:
            raise ValueError("ADM0: expected the single national P-code AF")
        total_rows = records
    else:
        if sum(bool(code) for code in pcodes) != spec["rows"] - 1:
            raise ValueError(f"{level}: expected one aggregate row without a P-code")
        nonempty = [code for code in pcodes if code]
        if len(nonempty) != len(set(nonempty)):
            raise ValueError(f"{level}: duplicate P-codes found")
        total_rows = [row for row in records if not row.get(spec["pcode"], "").strip()]

    if len(total_rows) != 1 or total_rows[0].get(POPULATION_COLUMN, "").strip() != NATIONAL_TOTAL:
        raise ValueError(f"{level}: national total row does not equal {NATIONAL_TOTAL}")
    return digest, len(records)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-dir", type=Path, required=True,
                        help="Directory containing the three original source CSV files")
    parser.add_argument("--repo-root", type=Path, default=Path("."),
                        help="Repository root (default: current directory)")
    parser.add_argument("--ingest", action="store_true",
                        help="Copy exact verified bytes into assets/data/population/2027 and update metadata")
    args = parser.parse_args()

    repo_root = args.repo_root.resolve()
    source_dir = args.source_dir.resolve()
    metadata_path = repo_root / METADATA_PATH
    if not metadata_path.is_file():
        raise FileNotFoundError(f"Metadata file not found: {metadata_path}")

    metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    verified: dict[str, Path] = {}
    for level, spec in EXPECTED.items():
        source = locate_source(source_dir, spec["aliases"])
        digest, count = validate_file(level, spec, source)
        verified[level] = source
        print(f"PASS {level}: {count} data rows, {spec['columns']} columns, SHA-256 {digest}")

    if not args.ingest:
        print("Validation only; repository files were not changed. Add --ingest to copy exact bytes.")
        return 0

    destination_dir = repo_root / DATASET_DIR
    destination_dir.mkdir(parents=True, exist_ok=True)
    # Stage all files first; only move them into place after every source passed validation.
    staged: list[tuple[Path, Path]] = []
    with tempfile.TemporaryDirectory(dir=destination_dir) as temp_dir:
        temp_root = Path(temp_dir)
        for level, spec in EXPECTED.items():
            staged_file = temp_root / spec["filename"]
            shutil.copyfile(verified[level], staged_file)
            if hashlib.sha256(staged_file.read_bytes()).hexdigest() != spec["sha256"]:
                raise ValueError(f"{level}: staged copy failed SHA-256 verification")
            staged.append((staged_file, destination_dir / spec["filename"]))
        for staged_file, target in staged:
            shutil.copyfile(staged_file, target)

    for item in metadata.get("files", []):
        level = item.get("level")
        if level in EXPECTED:
            item["repository_ingested"] = True
    metadata["provenance_status"] = "source_files_sha256_verified_and_repository_ingested"
    metadata_path.write_text(json.dumps(metadata, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("INGESTED: exact verified CSV bytes copied; blank cells and literal hyphens were not transformed.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
