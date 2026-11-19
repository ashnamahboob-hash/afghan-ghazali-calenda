/// Civil/tabular Islamic calendar conversion.
///
/// This is an arithmetic estimate, not an official moon-sighting calendar.
/// Local religious authorities may announce dates one day earlier or later.
class IslamicDate {
  final int year;
  final int month;
  final int day;

  const IslamicDate({required this.year, required this.month, required this.day});
}

class IslamicCalendar {
  static const int _islamicEpoch = 1948440; // 1 Muharram 1 AH, civil tabular epoch

  static const List<String> monthPs = [
    'محرم', 'صفر', 'ربیع الاول', 'ربیع الثاني', 'جمادی الاول', 'جمادی الثاني',
    'رجب', 'شعبان', 'رمضان', 'شوال', 'ذوالقعده', 'ذوالحجه',
  ];
  static const List<String> monthFa = [
    'محرم', 'صفر', 'ربیع‌الاول', 'ربیع‌الثانی', 'جمادی‌الاول', 'جمادی‌الثانی',
    'رجب', 'شعبان', 'رمضان', 'شوال', 'ذی‌القعده', 'ذی‌الحجه',
  ];
  static const List<String> monthEn = [
    'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
    'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Sha’ban',
    'Ramadan', 'Shawwal', 'Dhu al-Qadah', 'Dhu al-Hijjah',
  ];

  static int _gregorianToJdn(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day + (153 * m + 2) ~/ 5 + 365 * y +
        y ~/ 4 - y ~/ 100 + y ~/ 400 - 32045;
  }

  static int _islamicToJdn(int year, int month, int day) {
    return day + (59 * (month - 1) + 1) ~/ 2 + 354 * (year - 1) +
        (3 + 11 * year) ~/ 30 + _islamicEpoch - 1;
  }

  static IslamicDate fromGregorian(DateTime input) {
    final date = DateTime(input.year, input.month, input.day);
    final jdn = _gregorianToJdn(date);
    final year = (30 * (jdn - _islamicEpoch) + 10646) ~/ 10631;
    var month = 1;
    while (month < 12 && _islamicToJdn(year, month + 1, 1) <= jdn) {
      month++;
    }
    final day = jdn - _islamicToJdn(year, month, 1) + 1;
    return IslamicDate(year: year, month: month, day: day);
  }

  static String monthName(int month, String language) {
    if (month < 1 || month > 12) return '';
    if (language == 'en') return monthEn[month - 1];
    if (language == 'fa') return monthFa[month - 1];
    return monthPs[month - 1];
  }
}
