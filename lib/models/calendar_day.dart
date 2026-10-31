class CalendarDay {
  const CalendarDay({
    required this.gregorian,
    required this.year,
    required this.month,
    required this.day,
    required this.weekdayIndex,
  });

  final DateTime gregorian;
  final int year;
  final int month;
  final int day;
  /// Saturday = 0 ... Friday = 6
  final int weekdayIndex;
}
