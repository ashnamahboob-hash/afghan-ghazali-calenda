import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('agricultural advisory dataset has valid metadata and unique records',
      () async {
    final raw = await rootBundle.loadString(
      'assets/data/agricultural_advisory.json',
    );
    final dataset = jsonDecode(raw) as Map<String, dynamic>;
    final records = dataset['records'] as List<dynamic>;

    expect(dataset['dataset_id'], 'AF-AGRI-ADVISORY');
    expect(dataset['country'], 'AF');
    expect(dataset['calendar_system'], 'afghan_solar_hijri');

    final ids = <String>{};
    for (final value in records) {
      final record = value as Map<String, dynamic>;
      final id = record['id'] as String;
      expect(ids.add(id), isTrue, reason: 'Duplicate advisory id: $id');

      final provinceId = record['province_id'] as String;
      expect(RegExp(r'^AF[0-9]{2}$').hasMatch(provinceId), isTrue);

      final districtId = record['district_id'] as String?;
      if (districtId != null) {
        expect(RegExp(r'^AF[0-9]{4}$').hasMatch(districtId), isTrue);
      }

      if (record['verification_status'] == 'verified') {
        expect(record['sources'], isNotEmpty);
        expect(record['reviewed_at'], isA<String>());
        expect(record['reviewed_by'], isA<String>());
      }

      final window = record['window'] as Map<String, dynamic>?;
      if (window != null) {
        expect(window['calendar'], 'afghan_solar_hijri');
        for (final key in ['start', 'end']) {
          final date = window[key] as Map<String, dynamic>;
          final month = date['month'] as int;
          final day = date['day'] as int;
          expect(month, inInclusiveRange(1, 12));
          expect(day, inInclusiveRange(1, month <= 6 ? 31 : 30));
        }
      }
    }
  });

  test('every district-specific advisory references a known Kandahar district',
      () async {
    final advisoryRaw = await rootBundle.loadString(
      'assets/data/agricultural_advisory.json',
    );
    final districtRaw = await rootBundle.loadString(
      'assets/data/kandahar_districts.json',
    );
    final advisories =
        (jsonDecode(advisoryRaw) as Map<String, dynamic>)['records']
            as List<dynamic>;
    final districts =
        (jsonDecode(districtRaw) as Map<String, dynamic>)['districts']
            as List<dynamic>;
    final districtIds = districts
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toSet();

    for (final value in advisories) {
      final record = value as Map<String, dynamic>;
      final districtId = record['district_id'] as String?;
      if (districtId != null && record['province_id'] == 'AF27') {
        expect(districtIds.contains(districtId), isTrue,
            reason: 'Unknown Kandahar district id: $districtId');
      }
    }
  });
}
