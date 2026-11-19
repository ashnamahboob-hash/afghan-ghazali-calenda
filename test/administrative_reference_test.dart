import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/services/administrative_reference.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads all 34 provinces and 401 unique draft ADM2 IDs', () async {
    final reference = await AdministrativeReference.load();

    expect(reference.provinces, hasLength(34));
    expect(reference.adm2Count, 401);
    expect(
      reference.provinces.map((province) => province.id).toSet(),
      hasLength(34),
    );

    final adm2Ids = reference.provinces
        .expand((province) => province.units)
        .map((unit) => unit.id)
        .toList();
    expect(adm2Ids.toSet(), hasLength(401));
    expect(adm2Ids, contains('AF2701'));
  });


  test('resolves district and parent province by stable P-code', () async {
    final reference = await AdministrativeReference.load();
    final expected = <String, String>{
      'AF0102': 'AF01',
      'AF1114': 'AF11',
      'AF2603': 'AF26',
      'AF2711': 'AF27',
      'AF0606': 'AF06',
    };

    for (final entry in expected.entries) {
      final match = reference.findByPcode(entry.key);
      expect(match, isNotNull, reason: 'P-code ${entry.key} must resolve');
      expect(match!.province.id, entry.value);
    }

    expect(reference.findByPcode('AF9999'), isNull);
  });

  test('P-code lookup does not depend on English spelling', () async {
    final reference = await AdministrativeReference.load();
    final jaghori = reference.findByPcode('AF1114');

    expect(jaghori, isNotNull);
    expect(jaghori!.unit.localName, 'جاغوری');
    expect(jaghori.unit.englishName, 'Jaghori');
    expect(jaghori.province.localName, 'غزنی');
  });


  test('normalizes Arabic and Persian keyboard variants for search only', () {
    expect(
      AdministrativeReference.normalizeSearchText('جاغوري'),
      AdministrativeReference.normalizeSearchText('جاغوری'),
    );
    expect(
      AdministrativeReference.normalizeSearchText('كوز كُنړ'),
      AdministrativeReference.normalizeSearchText('کوز کنړ'),
    );
    // Pashto-specific letters remain distinct; normalization is not transliteration.
    expect(
      AdministrativeReference.normalizeSearchText('ښ'),
      isNot(AdministrativeReference.normalizeSearchText('ش')),
    );
  });

  test('search matches keyboard variants and preserves stored display names', () async {
    final reference = await AdministrativeReference.load();
    final matches = reference.searchUnits('جاغوري');

    expect(matches, isNotEmpty);
    expect(matches.first.unit.id, 'AF1114');
    expect(matches.first.unit.localName, 'جاغوری');
    expect(matches.first.province.localName, 'غزنی');
  });

  test('search supports stable P-codes and returns no results for empty input', () async {
    final reference = await AdministrativeReference.load();

    expect(reference.searchUnits('AF1114').single.unit.localName, 'جاغوری');
    expect(reference.searchUnits('   '), isEmpty);
  });

  test('keeps the administrative reference visibly marked as a draft', () async {
    final reference = await AdministrativeReference.load();

    expect(reference.status, contains('pending'));
  });
}
