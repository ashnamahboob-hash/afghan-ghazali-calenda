import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Kandahar pilot district asset has 16 unique linked records', () async {
    final raw = await rootBundle.loadString(
      'assets/data/kandahar_districts.json',
    );
    final dataset = jsonDecode(raw) as Map<String, dynamic>;
    final districts = dataset['districts'] as List<dynamic>;

    expect(dataset['dataset_id'], 'AF-KDH-ADM2-PILOT');
    expect(dataset['province']['id'], 'AF27');
    expect(districts, hasLength(16));

    final ids = districts
        .map((record) => (record as Map<String, dynamic>)['id'] as String)
        .toList();

    expect(ids.toSet(), hasLength(16));
    for (final record in districts.cast<Map<String, dynamic>>()) {
      expect(record['province_id'], 'AF27');
      expect(record['names']['ps'], isA<String>());
      expect(record['names']['en'], isA<String>());
      expect(record['verification']['pcode'], isNotEmpty);
      expect(record['record_status'], 'pending_official_verification');
    }
  });
}
