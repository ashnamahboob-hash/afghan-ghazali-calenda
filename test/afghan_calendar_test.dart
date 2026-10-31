import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/services/afghan_calendar.dart';

void main() {
  test('Afghan month lengths follow the configured civil rules', () {
    expect(AfghanCalendar.daysInMonth(1405, 1), 31);
    expect(AfghanCalendar.daysInMonth(1405, 7), 30);
    expect(AfghanCalendar.daysInMonth(1405, 12), 29);
  });

  test('Date conversion round trips within the configured calendar', () {
    final date = AfghanCalendar.toGregorian(1405, 2, 12);
    final converted = AfghanCalendar.fromGregorian(date);
    expect(converted.year, 1405);
    expect(converted.month, 2);
    expect(converted.day, 12);
  });
}
