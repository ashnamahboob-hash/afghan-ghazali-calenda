import 'dart:convert';
import 'dart:math' as math;

/// Portable calculation layer for the Afghan Ghazali Calendar FlutterFlow
/// migration. This file deliberately has no Flutter dependencies.
///
/// IMPORTANT:
/// - The Solar Hijri implementation is PROVISIONAL: it preserves the source
///   application's current March-21 / 33-year-cycle behavior. Validate it
///   against official Afghanistan calendar tables before production.
/// - The Islamic implementation is civil/tabular, not moon-sighting.
/// - Prayer times are approximate solar calculations, not a local religious
///   authority timetable.
class AfghanGhazaliFunctions {
  AfghanGhazaliFunctions._();

  static const List<String> solarMonthsPs = <String>[
    'وری', 'غویی', 'غبرګولی', 'چنګاښ', 'زمری', 'وږی',
    'تله', 'لړم', 'لیندۍ', 'مرغومی', 'سلواغه', 'کب',
  ];
  static const List<String> solarMonthsFa = <String>[
    'حمل', 'ثور', 'جوزا', 'سرطان', 'اسد', 'سنبله',
    'میزان', 'عقرب', 'قوس', 'جدی', 'دلو', 'حوت',
  ];
  static const List<String> solarMonthsEn = <String>[
    'Hamal', 'Sawr', 'Jawza', 'Saratan', 'Asad', 'Sunbula',
    'Mizan', 'Aqrab', 'Qaws', 'Jadi', 'Dalwa', 'Hut',
  ];

  static const List<String> hijriMonthsPs = <String>[
    'محرم', 'صفر', 'ربیع الاول', 'ربیع الثاني', 'جمادی الاول',
    'جمادی الثاني', 'رجب', 'شعبان', 'رمضان', 'شوال',
    'ذوالقعده', 'ذوالحجه',
  ];
  static const List<String> hijriMonthsFa = <String>[
    'محرم', 'صفر', 'ربیع‌الاول', 'ربیع‌الثانی', 'جمادی‌الاول',
    'جمادی‌الثانی', 'رجب', 'شعبان', 'رمضان', 'شوال',
    'ذی‌القعده', 'ذی‌الحجه',
  ];
  static const List<String> hijriMonthsEn = <String>[
    'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
    'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Sha’ban',
    'Ramadan', 'Shawwal', 'Dhu al-Qadah', 'Dhu al-Hijjah',
  ];

  static void _checkDateParts(int year, int month, int day) {
    if (year < 1 || month < 1 || month > 12 || day < 1 || day > 31) {
      throw ArgumentError('Invalid date parts.');
    }
  }

  static DateTime _dateOnlyUtc(int year, int month, int day) {
    _checkDateParts(year, month, day);
    final date = DateTime.utc(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      throw ArgumentError('Invalid Gregorian date.');
    }
    return date;
  }

  /// PROVISIONAL current-source Afghan Solar Hijri leap-year behavior.
  static bool solarIsLeapYear(int solarYear) {
    final mod = solarYear % 33;
    return const <int>{1, 5, 9, 13, 17, 22, 26, 30}.contains(mod);
  }

  static int solarDaysInMonth(int solarYear, int solarMonth) {
    if (solarYear < 1 || solarMonth < 1 || solarMonth > 12) {
      throw ArgumentError('Solar year/month is outside the supported range.');
    }
    if (solarMonth <= 6) return 31;
    if (solarMonth <= 11) return 30;
    return solarIsLeapYear(solarYear) ? 30 : 29;
  }

  static String solarMonthName(int month, String languageCode) {
    if (month < 1 || month > 12) throw ArgumentError('Solar month must be 1..12.');
    final code = languageCode.toLowerCase();
    if (code == 'en') return solarMonthsEn[month - 1];
    if (code == 'fa' || code == 'da') return solarMonthsFa[month - 1];
    return solarMonthsPs[month - 1];
  }

  static String hijriMonthName(int month, String languageCode) {
    if (month < 1 || month > 12) throw ArgumentError('Hijri month must be 1..12.');
    final code = languageCode.toLowerCase();
    if (code == 'en') return hijriMonthsEn[month - 1];
    if (code == 'fa' || code == 'da') return hijriMonthsFa[month - 1];
    return hijriMonthsPs[month - 1];
  }

  static String localizeDigits(String value, String languageCode) {
    if (languageCode == 'en') return value;
    const western = '0123456789';
    const eastern = '۰۱۲۳۴۵۶۷۸۹';
    final digits = value.split('');
    return digits.map((character) {
      final index = western.indexOf(character);
      return index < 0 ? character : eastern[index];
    }).join();
  }

  /// Returns JSON suitable for a FlutterFlow String-returning Custom Function.
  /// Input date is a Gregorian date-only string: YYYY-MM-DD.
  /// Result includes algorithmStatus=provisional until officially validated.
  static String solarDateFromGregorianJson(String isoDate) {
    final parts = isoDate.split('-').map(int.parse).toList();
    if (parts.length != 3) throw ArgumentError('Expected YYYY-MM-DD.');
    final date = _dateOnlyUtc(parts[0], parts[1], parts[2]);
    final startThis = DateTime.utc(date.year, 3, 21);
    final beforeNewYear = date.isBefore(startThis);
    final solarYear = date.year - 621 - (beforeNewYear ? 1 : 0);
    final start = DateTime.utc(date.year - (beforeNewYear ? 1 : 0), 3, 21);
    var remaining = date.difference(start).inDays;
    var month = 1;
    while (month <= 12) {
      final length = solarDaysInMonth(solarYear, month);
      if (remaining < length) break;
      remaining -= length;
      month++;
    }
    if (month > 12) {
      throw StateError('Solar calendar year-length mismatch; verify leap-year rule.');
    }
    return jsonEncode(<String, dynamic>{
      'solarYear': solarYear,
      'solarMonth': month,
      'solarDay': remaining + 1,
      'monthNamePs': solarMonthsPs[month - 1],
      'monthNameFa': solarMonthsFa[month - 1],
      'monthNameEn': solarMonthsEn[month - 1],
      'weekdaySaturdayFirst': (date.weekday + 1) % 7,
      'algorithmStatus': 'provisional',
      'disclaimer': 'March-21 and 33-year-cycle implementation; verify against official Afghanistan calendar.',
    });
  }

  /// Returns JSON with Gregorian year/month/day for a Solar Hijri date.
  /// This intentionally follows the same provisional source algorithm.
  static String solarDateToGregorianJson(int solarYear, int solarMonth, int solarDay) {
    final maxDay = solarDaysInMonth(solarYear, solarMonth);
    if (solarDay < 1 || solarDay > maxDay) {
      throw ArgumentError('Invalid Solar Hijri day.');
    }
    var date = DateTime.utc(solarYear + 621, 3, 21);
    for (var month = 1; month < solarMonth; month++) {
      date = date.add(Duration(days: solarDaysInMonth(solarYear, month)));
    }
    date = date.add(Duration(days: solarDay - 1));
    return jsonEncode(<String, dynamic>{
      'year': date.year,
      'month': date.month,
      'day': date.day,
      'isoDate': _isoDate(date),
      'algorithmStatus': 'provisional',
    });
  }

  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static int _gregorianToJdn(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day + (153 * m + 2) ~/ 5 + 365 * y +
        y ~/ 4 - y ~/ 100 + y ~/ 400 - 32045;
  }

  static int _islamicToJdn(int year, int month, int day) {
    const epoch = 1948440;
    return day + (59 * (month - 1) + 1) ~/ 2 + 354 * (year - 1) +
        (3 + 11 * year) ~/ 30 + epoch - 1;
  }

  /// Civil/tabular Hijri conversion. Local moon sighting can differ by a day.
  static String civilHijriFromGregorianJson(String isoDate) {
    final parts = isoDate.split('-').map(int.parse).toList();
    if (parts.length != 3) throw ArgumentError('Expected YYYY-MM-DD.');
    final date = _dateOnlyUtc(parts[0], parts[1], parts[2]);
    const epoch = 1948440;
    final jdn = _gregorianToJdn(date);
    final year = (30 * (jdn - epoch) + 10646) ~/ 10631;
    var month = 1;
    while (month < 12 && _islamicToJdn(year, month + 1, 1) <= jdn) {
      month++;
    }
    final day = jdn - _islamicToJdn(year, month, 1) + 1;
    return jsonEncode(<String, dynamic>{
      'hijriYear': year,
      'hijriMonth': month,
      'hijriDay': day,
      'monthNamePs': hijriMonthsPs[month - 1],
      'monthNameFa': hijriMonthsFa[month - 1],
      'monthNameEn': hijriMonthsEn[month - 1],
      'calendarType': 'civil_tabular',
      'disclaimer': 'Arithmetic calendar only; local moon-sighting announcements may differ by one day.',
    });
  }

  static double _hourAngle(double altitudeDegrees, double latitudeRadians, double declination) {
    final altitude = altitudeDegrees * math.pi / 180;
    final cosine = (math.sin(altitude) -
        math.sin(latitudeRadians) * math.sin(declination)) /
        (math.cos(latitudeRadians) * math.cos(declination));
    if (!cosine.isFinite || cosine < -1 || cosine > 1) {
      throw StateError('Sun angle is unavailable for this date/location.');
    }
    return math.acos(cosine) * 180 / math.pi;
  }

  static String _clockFromMinutes(int totalMinutes) {
    final normalized = ((totalMinutes % 1440) + 1440) % 1440;
    final hour = normalized ~/ 60;
    final minute = normalized % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Approximate prayer times for a local Gregorian date and city coordinates.
  /// Returns JSON so FlutterFlow can decode fields with JSON path selectors.
  static String calculatePrayerTimesJson({
    required String isoDate,
    required double latitude,
    required double longitude,
    double utcOffsetHours = 4.5,
    double fajrAngle = 18.0,
    double ishaAngle = 17.0,
    int asrFactor = 2,
  }) {
    final parts = isoDate.split('-').map(int.parse).toList();
    if (parts.length != 3) throw ArgumentError('Expected YYYY-MM-DD.');
    final date = _dateOnlyUtc(parts[0], parts[1], parts[2]);
    if (!latitude.isFinite || latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90.');
    }
    if (!longitude.isFinite || longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180.');
    }
    if (!utcOffsetHours.isFinite || utcOffsetHours < -14 || utcOffsetHours > 14) {
      throw ArgumentError('UTC offset must be between -14 and 14.');
    }
    if (!fajrAngle.isFinite || fajrAngle <= 0 || fajrAngle > 30 ||
        !ishaAngle.isFinite || ishaAngle <= 0 || ishaAngle > 30) {
      throw ArgumentError('Fajr/Isha angles must be greater than 0 and at most 30.');
    }
    if (asrFactor != 1 && asrFactor != 2) {
      throw ArgumentError('Asr factor must be 1 (Standard) or 2 (Hanafi).');
    }

    final dayOfYear = date.difference(DateTime.utc(date.year, 1, 1)).inDays + 1;
    final gamma = 2 * math.pi / 365 * (dayOfYear - 1);
    final equationOfTime = 229.18 *
        (0.000075 +
            0.001868 * math.cos(gamma) -
            0.032077 * math.sin(gamma) -
            0.014615 * math.cos(2 * gamma) -
            0.040849 * math.sin(2 * gamma));
    final declination = 0.006918 -
        0.399912 * math.cos(gamma) +
        0.070257 * math.sin(gamma) -
        0.006758 * math.cos(2 * gamma) +
        0.000907 * math.sin(2 * gamma) -
        0.002697 * math.cos(3 * gamma) +
        0.00148 * math.sin(3 * gamma);

    final latitudeRadians = latitude * math.pi / 180;
    final noon = 12 + utcOffsetHours - longitude / 15 - equationOfTime / 60;
    final sunrise = noon - _hourAngle(-0.833, latitudeRadians, declination) / 15;
    final sunset = noon + _hourAngle(-0.833, latitudeRadians, declination) / 15;
    final fajr = noon - _hourAngle(-fajrAngle, latitudeRadians, declination) / 15;
    final isha = noon + _hourAngle(-ishaAngle, latitudeRadians, declination) / 15;
    final shadowAngle = math.atan(
      1 / (asrFactor + math.tan((latitudeRadians - declination).abs())),
    );
    final asr = noon + _hourAngle(shadowAngle * 180 / math.pi, latitudeRadians, declination) / 15;

    int minutes(double hour) => (hour * 60).round();
    return jsonEncode(<String, dynamic>{
      'fajr': _clockFromMinutes(minutes(fajr)),
      'sunrise': _clockFromMinutes(minutes(sunrise)),
      'dhuhr': _clockFromMinutes(minutes(noon)),
      'asr': _clockFromMinutes(minutes(asr)),
      'maghrib': _clockFromMinutes(minutes(sunset)),
      'isha': _clockFromMinutes(minutes(isha)),
      'asrFactor': asrFactor,
      'asrMethod': asrFactor == 2 ? 'Hanafi' : 'Standard/Shafii',
      'calculationStatus': 'approximate',
      'fajrAngle': fajrAngle,
      'ishaAngle': ishaAngle,
      'utcOffsetHours': utcOffsetHours,
      'disclaimer': 'Approximate offline solar calculation; verify against a trusted local timetable.',
    });
  }
  /// Safely interprets one source cell without changing the original literal.
  /// Missing markers remain missing; they are never converted to numeric zero.
  static String populationCellJson(String? rawValue) {
    if (rawValue == null) {
      return jsonEncode(<String, dynamic>{
        'sourceValueRaw': null,
        'numericValue': null,
        'valueStatus': 'missing_null',
      });
    }
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) {
      return jsonEncode(<String, dynamic>{
        'sourceValueRaw': rawValue,
        'numericValue': null,
        'valueStatus': 'missing_blank',
      });
    }
    if (trimmed == '-') {
      return jsonEncode(<String, dynamic>{
        'sourceValueRaw': rawValue,
        'numericValue': null,
        'valueStatus': 'missing_marker',
      });
    }
    if (trimmed.toLowerCase() == 'null') {
      return jsonEncode(<String, dynamic>{
        'sourceValueRaw': rawValue,
        'numericValue': null,
        'valueStatus': 'missing_null_literal',
      });
    }
    final numeric = num.tryParse(trimmed.replaceAll(',', ''));
    if (numeric == null || !numeric.isFinite) {
      return jsonEncode(<String, dynamic>{
        'sourceValueRaw': rawValue,
        'numericValue': null,
        'valueStatus': 'unparsed_source_value',
      });
    }
    return jsonEncode(<String, dynamic>{
      'sourceValueRaw': rawValue,
      'numericValue': numeric,
      'valueStatus': 'source_numeric_value',
    });
  }

  /// Aggregates a JSON array of source cell strings.
  /// A partial sum is provided for diagnostics, but value is null unless every
  /// row contains a numeric value. This prevents incomplete totals looking
  /// like complete population totals.
  static String sumPopulationCellsJson(String rawValuesJson) {
    final decoded = jsonDecode(rawValuesJson);
    if (decoded is! List) throw ArgumentError('Expected a JSON array of source values.');
    num partialSum = 0;
    var included = 0;
    var missing = 0;
    final rawValues = <String?>[];
    for (final item in decoded) {
      if (item == null) {
        rawValues.add(null);
        missing++;
        continue;
      }
      if (item is! String && item is! num) {
        throw ArgumentError('Population source values must be strings or numbers.');
      }
      final raw = item.toString();
      rawValues.add(raw);
      final parsed = num.tryParse(raw.trim().replaceAll(',', ''));
      if (parsed == null || !parsed.isFinite) {
        missing++;
      } else {
        partialSum += parsed;
        included++;
      }
    }
    final complete = missing == 0;
    return jsonEncode(<String, dynamic>{
      'value': complete ? partialSum : null,
      'partialSumForAuditOnly': partialSum,
      'includedCount': included,
      'missingCount': missing,
      'rowCount': decoded.length,
      'valueStatus': complete ? 'calculated_complete' : 'incomplete_missing_values',
      'rawValuesPreserved': rawValues,
    });
  }

  /// Compares two JSON arrays of P-codes without modifying either input set.
  /// Source-only codes are retained for review, not silently discarded.
  static String comparePcodeSetsJson(String sourceCodesJson, String referenceCodesJson) {
    final sourceDecoded = jsonDecode(sourceCodesJson);
    final referenceDecoded = jsonDecode(referenceCodesJson);
    if (sourceDecoded is! List || referenceDecoded is! List) {
      throw ArgumentError('Both P-code inputs must be JSON arrays.');
    }
    if (sourceDecoded.any((value) => value is! String) ||
        referenceDecoded.any((value) => value is! String)) {
      throw ArgumentError('Every P-code must be a string.');
    }
    final source = sourceDecoded.cast<String>();
    final reference = referenceDecoded.cast<String>();
    final sourceSet = source.toSet();
    final referenceSet = reference.toSet();
    final duplicatesSource = source.where((code) => source.where((x) => x == code).length > 1).toSet().toList()..sort();
    final duplicatesReference = reference.where((code) => reference.where((x) => x == code).length > 1).toSet().toList()..sort();
    final matched = sourceSet.intersection(referenceSet).toList()..sort();
    final sourceOnly = sourceSet.difference(referenceSet).toList()..sort();
    final referenceOnly = referenceSet.difference(sourceSet).toList()..sort();
    return jsonEncode(<String, dynamic>{
      'matched': matched,
      'sourceOnly': sourceOnly,
      'referenceOnly': referenceOnly,
      'duplicateSourceCodes': duplicatesSource,
      'duplicateReferenceCodes': duplicatesReference,
      'sourceCount': source.length,
      'referenceCount': reference.length,
      'matchedCount': matched.length,
      'sourceOnlyCount': sourceOnly.length,
      'referenceOnlyCount': referenceOnly.length,
      'status': duplicatesSource.isEmpty && duplicatesReference.isEmpty ? 'compared' : 'duplicates_found',
    });
  }

}
