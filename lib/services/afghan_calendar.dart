import '../models/calendar_day.dart';

/// First-version Afghan Solar Hijri calendar engine.
///
/// This implementation uses the Afghan month names and the commonly used
/// Afghanistan civil-calendar month lengths. The year boundary is currently
/// anchored to March 21 for the first version. Before public release, compare
/// every year with the official Afghanistan calendar authority and update
/// [newYearStart] if an official year begins on March 20.
class AfghanCalendar {
  static const List<String> monthPs = [
    'وری', 'غویی', 'غبرګولی', 'چنګاښ', 'زمری', 'وږی',
    'تله', 'لړم', 'لیندۍ', 'مرغومی', 'سلواغه', 'کب'
  ];
  static const List<String> monthFa = [
    'حمل', 'ثور', 'جوزا', 'سرطان', 'اسد', 'سنبله',
    'میزان', 'عقرب', 'قوس', 'جدی', 'دلو', 'حوت'
  ];
  static const List<String> monthEn = [
    'Hamal', 'Sawr', 'Jawza', 'Saratan', 'Asad', 'Sunbula',
    'Mizan', 'Aqrab', 'Qaws', 'Jadi', 'Dalwa', 'Hut'
  ];

  static DateTime newYearStart(int gregorianYear) =>
      DateTime(gregorianYear, 3, 21);

  static bool isLeapYear(int solarYear) {
    // Afghan leap years follow the 33-year cycle in this initial engine.
    // Official calendar verification is required before release.
    final mod = solarYear % 33;
    return const {1, 5, 9, 13, 17, 22, 26, 30}.contains(mod);
  }

  static int daysInMonth(int year, int month) {
    if (month >= 1 && month <= 6) return 31;
    if (month >= 7 && month <= 11) return 30;
    if (month == 12) return isLeapYear(year) ? 30 : 29;
    throw ArgumentError('Month must be between 1 and 12');
  }

  static CalendarDay fromGregorian(DateTime input) {
    final date = DateTime(input.year, input.month, input.day);
    final startThis = newYearStart(date.year);
    final bool belongsToPreviousSolarYear = date.isBefore(startThis);
    final solarYear = date.year - 621 - (belongsToPreviousSolarYear ? 1 : 0);
    final start = newYearStart(date.year - (belongsToPreviousSolarYear ? 1 : 0));
    var dayOfYear = date.difference(start).inDays;
    var month = 1;
    while (month <= 12) {
      final length = daysInMonth(solarYear, month);
      if (dayOfYear < length) break;
      dayOfYear -= length;
      month++;
    }
    final weekday = (date.weekday + 1) % 7; // Dart Mon=1; Sat becomes 0.
    return CalendarDay(
      gregorian: date,
      year: solarYear,
      month: month,
      day: dayOfYear + 1,
      weekdayIndex: weekday,
    );
  }

  static DateTime toGregorian(int year, int month, int day) {
    if (month < 1 || month > 12 || day < 1 || day > daysInMonth(year, month)) {
      throw ArgumentError('Invalid Afghan solar date');
    }
    final gregorianYear = year + 621;
    var date = newYearStart(gregorianYear);
    for (var m = 1; m < month; m++) {
      date = date.add(Duration(days: daysInMonth(year, m)));
    }
    return date.add(Duration(days: day - 1));
  }

  static String monthName(int month, String language) {
    switch (language) {
      case 'fa':
        return monthFa[month - 1];
      case 'en':
        return monthEn[month - 1];
      default:
        return monthPs[month - 1];
    }
  }

  static String formatNumber(int value, String language) {
    final digits = language == 'en'
        ? '0123456789'
        : language == 'fa'
            ? '۰۱۲۳۴۵۶۷۸۹'
            : '۰۱۲۳۴۵۶۷۸۹';
    return value.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  static List<String> weekdayNames(String language) {
    if (language == 'en') {
      return ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    }
    if (language == 'fa') {
      return ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'];
    }
    return ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'];
  }
}
