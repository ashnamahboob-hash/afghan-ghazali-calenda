import unittest

from tool.afghanistan_401_gis_pcode_verifier import audit_records, detected_scripts


def row(code="AF0101", label="ولسوالی آزمایښتي", parent="AF01", province="کابل"):
    return {
        "adm2_pcode": code,
        "adm2_name1": label,
        "adm1_pcode": parent,
        "adm1_name1": province,
    }


class AfghanistanGisPcodeAuditTests(unittest.TestCase):
    def test_pashto_and_dari_labels_are_not_flagged_as_latin(self):
        report = audit_records([row()], expected_count=1)
        self.assertEqual(report["findings"], [])
        self.assertEqual(detected_scripts("کابل"), ["Arabic"])

    def test_latin_or_bengali_mixed_script_is_reported_not_removed(self):
        original = row(code="AF2002", label="حضرت sultan", province="سمنگان")
        report = audit_records([original], expected_count=1)
        self.assertEqual(report["records"][0]["adm2_name1"], "حضرت sultan")
        codes = {item["code"] for item in report["findings"]}
        self.assertIn("MIXED_UNICODE_SCRIPTS", codes)
        self.assertIn("SANITIZATION_SUGGESTION", codes)

        bengali = audit_records([row(province="تگاب আলম")], expected_count=1)
        self.assertIn(
            "MIXED_UNICODE_SCRIPTS",
            {item["code"] for item in bengali["findings"]},
        )
        self.assertEqual(bengali["records"][0]["adm1_name1"], "تگاب আলম")

    def test_duplicate_and_invalid_pcodes_are_reported(self):
        report = audit_records(
            [row(), row(), row(code="AF1X01", parent="AF0X")],
            expected_count=3,
        )
        codes = {item["code"] for item in report["findings"]}
        self.assertIn("DUPLICATE_ADM2_PCODE", codes)
        self.assertIn("INVALID_ADM2_PCODE", codes)
        self.assertIn("INVALID_ADM1_PCODE", codes)

    def test_parent_prefix_mismatch_is_reported(self):
        report = audit_records(
            [row(code="AF0201", parent="AF01")],
            expected_count=1,
        )
        self.assertIn(
            "PARENT_PREFIX_MISMATCH",
            {item["code"] for item in report["findings"]},
        )

    def test_watch_list_code_is_retained(self):
        report = audit_records([row(code="AF2110")], expected_count=1)
        self.assertEqual(len(report["records"]), 1)
        self.assertIn(
            "USER_WATCHLIST_CODE",
            {item["code"] for item in report["findings"]},
        )

    def test_protected_label_suggests_but_does_not_overwrite(self):
        report = audit_records(
            [row(code="AF0901", label="پلخمری", parent="AF09", province="بغلان")],
            expected_count=1,
        )
        self.assertEqual(report["records"][0]["adm2_name1"], "پلخمری")
        finding = next(
            item for item in report["findings"]
            if item["code"] == "PROTECTED_LABEL_CONFLICT"
        )
        self.assertEqual(finding["suggested_value"], "بغلان مرکزی")

    def test_allowed_variants_are_preserved(self):
        report = audit_records(
            [row(code="AF0606", label="کوز کنر", parent="AF06", province="کنر")],
            expected_count=1,
        )
        self.assertEqual(report["records"][0]["adm2_name1"], "کوز کنر")
        self.assertIn(
            "USER_VARIANT_PRESERVED",
            {item["code"] for item in report["findings"]},
        )

    def test_reference_comparison_uses_exact_pcode(self):
        reference = {
            "provinces": [{
                "id": "AF01",
                "names": {"local": "کابل"},
                "districts": [{
                    "id": "AF0101",
                    "names": {"local": "کابل"},
                }],
            }]
        }
        report = audit_records(
            [row(label="کابل ښار")],
            expected_count=1,
            reference=reference,
        )
        self.assertIn(
            "REFERENCE_LABEL_DIFFERENCE",
            {item["code"] for item in report["findings"]},
        )

    def test_expected_count_is_diagnostic_only(self):
        report = audit_records([row()], expected_count=401)
        self.assertEqual(report["input_record_count"], 1)
        self.assertEqual(report["records"][0]["adm2_pcode"], "AF0101")
        self.assertIn(
            "UNEXPECTED_RECORD_COUNT",
            {item["code"] for item in report["findings"]},
        )
        self.assertEqual(report["status"], "diagnostic_only_not_official_verification")


if __name__ == "__main__":
    unittest.main()
