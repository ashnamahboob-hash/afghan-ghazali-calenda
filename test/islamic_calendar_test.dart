import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/services/islamic_calendar.dart';

void main() {
  test('Converts known Gregorian dates to tabular Islamic dates', () {
    final ramadan1445 = IslamicCalendar.fromGregorian(DateTime(2024, 3, 11));
    expect(ramadan1445.year, 1445);
    expect(ramadan1445.month, 9);
    expect(ramadan1445.day, 1);

    final ramadan1446 = IslamicCalendar.fromGregorian(DateTime(2025, 3, 1));
    expect(ramadan1446.year, 1446);
    expect(ramadan1446.month, 9);
    expect(ramadan1446.day, 1);
  });

  test('Returns localized Islamic month names', () {
    expect(IslamicCalendar.monthName(9, 'ps'), 'رمضان');
    expect(IslamicCalendar.monthName(9, 'en'), 'Ramadan');
  });
}
