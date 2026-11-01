import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/services/administrative_reference.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads all 34 provinces and 401 unique draft district IDs', () async {
    final reference = await AdministrativeReference.load();

    expect(reference.provinces, hasLength(34));
    expect(reference.districtCount, 401);
    expect(
      reference.provinces.map((province) => province.id).toSet(),
      hasLength(34),
    );

    final districtIds = reference.provinces
        .expand((province) => province.districts)
        .map((district) => district.id)
        .toList();
    expect(districtIds.toSet(), hasLength(401));
    expect(districtIds, contains('AF2701'));
  });

  test('keeps the administrative reference visibly marked as a draft', () async {
    final reference = await AdministrativeReference.load();

    expect(reference.status, contains('draft'));
  });
}
