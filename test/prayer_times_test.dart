import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/services/prayer_times.dart';

void main() {
  group('PrayerTimes.calculate', () {
    test('returns chronologically ordered events for Kandahar', () {
      final times = PrayerTimes.calculate(
        date: DateTime(2026, 6, 21),
        latitude: 31.6289,
        longitude: 65.7372,
      );

      final events = [
        times.fajr,
        times.sunrise,
        times.dhuhr,
        times.asr,
        times.maghrib,
        times.isha,
      ];

      for (var index = 1; index < events.length; index++) {
        expect(events[index].isAfter(events[index - 1]), isTrue);
      }
    });

    test('Hanafi Asr occurs later than standard Asr', () {
      final date = DateTime(2026, 6, 21);
      final standard = PrayerTimes.calculate(
        date: date,
        latitude: 31.6289,
        longitude: 65.7372,
        asrFactor: 1,
      );
      final hanafi = PrayerTimes.calculate(
        date: date,
        latitude: 31.6289,
        longitude: 65.7372,
        asrFactor: 2,
      );

      expect(hanafi.asr.isAfter(standard.asr), isTrue);
    });

    test('rejects coordinates outside valid geographic ranges', () {
      expect(
        () => PrayerTimes.calculate(
          date: DateTime(2026, 1, 1),
          latitude: 91,
          longitude: 65,
        ),
        throwsArgumentError,
      );
      expect(
        () => PrayerTimes.calculate(
          date: DateTime(2026, 1, 1),
          latitude: 31,
          longitude: 181,
        ),
        throwsArgumentError,
      );
    });

    test('rejects invalid offsets, angles and Asr factors', () {
      expect(
        () => PrayerTimes.calculate(
          date: DateTime(2026, 1, 1),
          latitude: 31,
          longitude: 65,
          utcOffsetHours: 15,
        ),
        throwsArgumentError,
      );
      expect(
        () => PrayerTimes.calculate(
          date: DateTime(2026, 1, 1),
          latitude: 31,
          longitude: 65,
          fajrAngle: 0,
        ),
        throwsArgumentError,
      );
      expect(
        () => PrayerTimes.calculate(
          date: DateTime(2026, 1, 1),
          latitude: 31,
          longitude: 65,
          ishaAngle: 31,
        ),
        throwsArgumentError,
      );
      expect(
        () => PrayerTimes.calculate(
          date: DateTime(2026, 1, 1),
          latitude: 31,
          longitude: 65,
          asrFactor: 3,
        ),
        throwsArgumentError,
      );
    });
  });
}
