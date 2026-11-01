import 'dart:convert';

import 'package:flutter/services.dart';

class AdministrativeUnit {
  final String id;
  final String localName;
  final String englishName;

  const AdministrativeUnit({
    required this.id,
    required this.localName,
    required this.englishName,
  });
}

class AdministrativeProvince {
  final String id;
  final String localName;
  final String englishName;
  final List<AdministrativeUnit> units;

  const AdministrativeProvince({
    required this.id,
    required this.localName,
    required this.englishName,
    required this.units,
  });
}

class AdministrativeUnitMatch {
  final AdministrativeProvince province;
  final AdministrativeUnit unit;

  const AdministrativeUnitMatch({
    required this.province,
    required this.unit,
  });
}

class AdministrativeReference {
  final List<AdministrativeProvince> provinces;
  final String status;

  const AdministrativeReference({
    required this.provinces,
    required this.status,
  });

  int get adm2Count =>
      provinces.fold(0, (total, province) => total + province.units.length);

  /// Resolves a district/unit by its stable ADM2 P-code, never by its label.
  /// The returned province is the explicit parent from the nested reference.
  AdministrativeUnitMatch? findByPcode(String pcode) {
    for (final province in provinces) {
      for (final unit in province.units) {
        if (unit.id == pcode) {
          return AdministrativeUnitMatch(province: province, unit: unit);
        }
      }
    }
    return null;
  }

  static Future<AdministrativeReference> load() async {
    final raw = await rootBundle.loadString(
      'assets/data/afghanistan_admin_divisions_reference_draft.json',
    );
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final provinceRows = root['provinces'] as List<dynamic>;
    final provinces = provinceRows.map((value) {
      final row = value as Map<String, dynamic>;
      final names = row['names'] as Map<String, dynamic>;
      final districtRows = row['districts'] as List<dynamic>;
      final units = districtRows.map((districtValue) {
        final district = districtValue as Map<String, dynamic>;
        final districtNames = district['names'] as Map<String, dynamic>;
        return AdministrativeUnit(
          id: district['id'] as String,
          localName: districtNames['local'] as String,
          englishName: districtNames['en'] as String,
        );
      }).toList(growable: false);
      return AdministrativeProvince(
        id: row['id'] as String,
        localName: names['local'] as String,
        englishName: names['en'] as String,
        units: units,
      );
    }).toList(growable: false);

    final allAdm2Ids = provinces
        .expand((province) => province.units)
        .map((unit) => unit.id)
        .toList(growable: false);
    if (provinces.length != 34 ||
        allAdm2Ids.length != 401 ||
        provinces.map((province) => province.id).toSet().length != 34 ||
        allAdm2Ids.toSet().length != 401) {
      throw const FormatException(
        'Administrative draft must contain 34 unique provinces and 401 unique units.',
      );
    }

    return AdministrativeReference(
      provinces: provinces,
      status: root['status'] as String,
    );
  }
}
