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
        .expand((province) => province.districts)
        .map((unit) => district.id)
        .toList();
    expect(adm2Ids.toSet(), hasLength(401));
    expect(adm2Ids, contains('AF2701'));
  });

  test('keeps the administrative reference visibly marked as a draft', () async {
    final reference = await AdministrativeReference.load();

    expect(reference.status, contains('draft'));
  });
}
