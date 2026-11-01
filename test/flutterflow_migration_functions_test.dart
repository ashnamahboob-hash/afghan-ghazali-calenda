import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../flutterflow_custom_code/lib/afghan_ghazali_functions.dart';

void main() {
  group('AfghanGhazaliFunctions Solar Hijri', () {
    test('converts a Gregorian date using the current provisional source rule', () {
      final result = jsonDecode(
        AfghanGhazaliFunctions.solarDateFromGregorianJson('2026-04-01'),
      ) as Map<String, dynamic>;

      expect(result['solarYear'], 1405);
      expect(result['solarMonth'], 1);
      expect(result['solarDay'], 12);
      expect(result['monthNamePs'], 'وری');
      expect(result['algorithmStatus'], 'provisional');
    });

    test('Solar conversion round-trips for a date after New Year', () {
      final solar = jsonDecode(
        AfghanGhazaliFunctions.solarDateFromGregorianJson('2026-04-12'),
      ) as Map<String, dynamic>;
      final gregorian = jsonDecode(
        AfghanGhazaliFunctions.solarDateToGregorianJson(
          solar['solarYear'] as int,
          solar['solarMonth'] as int,
          solar['solarDay'] as int,
        ),
      ) as Map<String, dynamic>;

      expect(gregorian['isoDate'], '2026-04-12');
    });

    test('month lengths and language labels are exposed', () {
      expect(AfghanGhazaliFunctions.solarDaysInMonth(1405, 1), 31);
      expect(AfghanGhazaliFunctions.solarDaysInMonth(1405, 7), 30);
      expect(AfghanGhazaliFunctions.solarMonthName(1, 'ps'), 'وری');
      expect(AfghanGhazaliFunctions.solarMonthName(1, 'fa'), 'حمل');
      expect(AfghanGhazaliFunctions.solarMonthName(1, 'en'), 'Hamal');
    });

    test('rejects an invalid Solar Hijri day', () {
      expect(
        () => AfghanGhazaliFunctions.solarDateToGregorianJson(1405, 1, 32),
        throwsArgumentError,
      );
    });
  });

  group('AfghanGhazaliFunctions civil Hijri', () {
    test('matches the tabular Ramadan 1445 test date', () {
      final result = jsonDecode(
        AfghanGhazaliFunctions.civilHijriFromGregorianJson('2024-03-11'),
      ) as Map<String, dynamic>;

      expect(result['hijriYear'], 1445);
      expect(result['hijriMonth'], 9);
      expect(result['hijriDay'], 1);
      expect(result['calendarType'], 'civil_tabular');
    });

    test('provides localized month labels', () {
      final result = jsonDecode(
        AfghanGhazaliFunctions.civilHijriFromGregorianJson('2024-03-11'),
      ) as Map<String, dynamic>;

      expect(result['monthNamePs'], 'رمضان');
      expect(result['monthNameEn'], 'Ramadan');
    });
  });

  group('AfghanGhazaliFunctions prayer times', () {
    test('returns ordered Kandahar prayer events and Hanafi default', () {
      final result = jsonDecode(
        AfghanGhazaliFunctions.calculatePrayerTimesJson(
          isoDate: '2026-06-21',
          latitude: 31.6289,
          longitude: 65.7372,
        ),
      ) as Map<String, dynamic>;

      final keys = <String>[
        'fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha',
      ];
      final minutes = keys.map((key) {
        final parts = (result[key] as String).split(':').map(int.parse).toList();
        return parts[0] * 60 + parts[1];
      }).toList();

      for (var i = 1; i < minutes.length; i++) {
        expect(minutes[i], greaterThan(minutes[i - 1]));
      }
      expect(result['asrFactor'], 2);
      expect(result['asrMethod'], 'Hanafi');
      expect(result['calculationStatus'], 'approximate');
    });

    test('Hanafi Asr is later than Standard Asr', () {
      String asr(int factor) {
        final result = jsonDecode(
          AfghanGhazaliFunctions.calculatePrayerTimesJson(
            isoDate: '2026-06-21',
            latitude: 31.6289,
            longitude: 65.7372,
            asrFactor: factor,
          ),
        ) as Map<String, dynamic>;
        return result['asr'] as String;
      }

      expect(asr(2), greaterThan(asr(1)));
    });

    test('rejects invalid coordinates and Asr factors', () {
      expect(
        () => AfghanGhazaliFunctions.calculatePrayerTimesJson(
          isoDate: '2026-01-01',
          latitude: 91,
          longitude: 65,
        ),
        throwsArgumentError,
      );
      expect(
        () => AfghanGhazaliFunctions.calculatePrayerTimesJson(
          isoDate: '2026-01-01',
          latitude: 31,
          longitude: 65,
          asrFactor: 3,
        ),
        throwsArgumentError,
      );
    });
  });
}
