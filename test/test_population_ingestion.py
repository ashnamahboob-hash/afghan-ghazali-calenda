import hashlib
import importlib.util
import tempfile
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).resolve().parents[1] / "scripts" / "ingest_population_2027.py"
SPEC = importlib.util.spec_from_file_location("ingest_population_2027", SCRIPT_PATH)
ingestion = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(ingestion)


class PopulationIngestionValidationTests(unittest.TestCase):
    def make_source(self, text):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        path = Path(temporary.name) / "source.csv"
        raw = text.encode("utf-8")
        path.write_bytes(raw)
        return path, raw

    def spec_for(self, level, pcode, rows):
        return {
            "sha256": hashlib.sha256(self.raw).hexdigest(),
            "bytes": len(self.raw),
            "rows": rows,
            "columns": 3,
            "pcode": pcode,
        }

    def test_adm0_national_total_is_validated(self):
        source, self.raw = self.make_source(
            'adm0_pcode,Total Estimated Population 2027,marker\n'
            'AF,"50,489,104",-\n'
        )
        spec = self.spec_for("ADM0", "adm0_pcode", 1)
        digest, rows = ingestion.validate_file("ADM0", spec, source)
        self.assertEqual(digest, spec["sha256"])
        self.assertEqual(rows, 1)
        self.assertEqual(source.read_bytes(), self.raw)

    def test_adm1_keeps_blank_aggregate_and_literal_hyphen(self):
        source, self.raw = self.make_source(
            'adm1_pcode,Total Estimated Population 2027,marker\n'
            'AF01,123,-\n'
            ',"50,489,104",\n'
        )
        spec = self.spec_for("ADM1", "adm1_pcode", 2)
        digest, rows = ingestion.validate_file("ADM1", spec, source)
        self.assertEqual(digest, spec["sha256"])
        self.assertEqual(rows, 2)
        self.assertEqual(source.read_bytes(), self.raw)

    def test_adm2_rejects_duplicate_pcodes(self):
        source, self.raw = self.make_source(
            'adm2_pcode,Total Estimated Population 2027,marker\n'
            'AF0101,100,-\n'
            'AF0101,200,\n'
            ',"50,489,104",\n'
        )
        spec = self.spec_for("ADM2", "adm2_pcode", 3)
        with self.assertRaisesRegex(ValueError, "duplicate P-codes"):
            ingestion.validate_file("ADM2", spec, source)

    def test_rejects_modified_source_bytes_before_parsing(self):
        source, self.raw = self.make_source(
            'adm0_pcode,Total Estimated Population 2027,marker\n'
            'AF,"50,489,104",-\n'
        )
        spec = self.spec_for("ADM0", "adm0_pcode", 1)
        source.write_bytes(self.raw + b" ")
        with self.assertRaisesRegex(ValueError, "byte size mismatch|SHA-256 mismatch"):
            ingestion.validate_file("ADM0", spec, source)

    def test_rejects_wrong_national_total(self):
        source, self.raw = self.make_source(
            'adm0_pcode,Total Estimated Population 2027,marker\n'
            'AF,"50,000,000",-\n'
        )
        spec = self.spec_for("ADM0", "adm0_pcode", 1)
        with self.assertRaisesRegex(ValueError, "national total"):
            ingestion.validate_file("ADM0", spec, source)


if __name__ == "__main__":
    unittest.main()
