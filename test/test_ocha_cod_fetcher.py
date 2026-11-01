import unittest

from tool.fetch_ocha_cod_ab_afg_adm2 import build_snapshot


def feature(code="AF0101", parent="AF01", country="AFG"):
    return {
        "attributes": {
            "adm2_pcode": code,
            "adm1_pcode": parent,
            "adm0_pcode": country,
            "adm2_name": "Test District",
            "adm2_name1": "آزمایښتي",
            "valid_on": 1798761600000,
            "valid_to": None,
            "version_no": 1,
        }
    }


class OchaSnapshotTests(unittest.TestCase):
    def test_builds_pending_snapshot_for_expected_feature_count(self):
        snapshot = build_snapshot(
            {"features": [feature()]},
            "2026-11-01T00:00:00+00:00",
            expected_count=1,
        )
        self.assertEqual(snapshot["retrieved_feature_count"], 1)
        self.assertEqual(snapshot["unique_adm2_pcodes"], 1)
        self.assertEqual(
            snapshot["snapshot_status"],
            "retrieved_pending_manual_comparison",
        )
        self.assertEqual(snapshot["features"][0]["adm2_pcode"], "AF0101")

    def test_duplicate_pcode_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "duplicate ADM2 P-code"):
            build_snapshot(
                {"features": [feature(), feature()]},
                "2026-11-01T00:00:00+00:00",
                expected_count=2,
            )

    def test_wrong_country_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "adm0_pcode=AFG"):
            build_snapshot(
                {"features": [feature(country="PAK")]},
                "2026-11-01T00:00:00+00:00",
                expected_count=1,
            )

    def test_transfer_limit_keeps_snapshot_pending(self):
        snapshot = build_snapshot(
            {"features": [feature()], "exceededTransferLimit": True},
            "2026-11-01T00:00:00+00:00",
            expected_count=1,
        )
        self.assertEqual(
            snapshot["snapshot_status"],
            "unexpected_count_or_transfer_limit_pending_review",
        )


if __name__ == "__main__":
    unittest.main()
