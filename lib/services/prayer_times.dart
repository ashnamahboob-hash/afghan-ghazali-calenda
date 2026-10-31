import 'dart:math' as math;

class PrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  const PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  /// Lightweight offline solar calculation.
  /// Coordinates are entered manually; times are approximate and must be
  /// checked against a trusted local timetable before religious use.
  static PrayerTimes calculate({
    required DateTime date,
    required double latitude,
    required double longitude,
    double utcOffsetHours = 4.5,
    double fajrAngle = 18.0,
    double ishaAngle = 17.0,
    int asrFactor = 1,
  }) {
    final n = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    final gamma = 2 * math.pi / 365 * (n - 1);
    final eqTime = 229.18 *
        (0.000075 +
            0.001868 * math.cos(gamma) -
            0.032077 * math.sin(gamma) -
            0.014615 * math.cos(2 * gamma) -
            0.040849 * math.sin(2 * gamma));
    final decl = 0.006918 -
        0.399912 * math.cos(gamma) +
        0.070257 * math.sin(gamma) -
        0.006758 * math.cos(2 * gamma) +
        0.000907 * math.sin(2 * gamma) -
        0.002697 * math.cos(3 * gamma) +
        0.00148 * math.sin(3 * gamma);

    double hourAngle(double altitude) {
      final lat = latitude * math.pi / 180;
      final alt = altitude * math.pi / 180;
      final c = (math.sin(alt) - math.sin(lat) * math.sin(decl)) /
          (math.cos(lat) * math.cos(decl));
      return math.acos(c.clamp(-1.0, 1.0)) * 180 / math.pi;
    }

    final noon = 12 + utcOffsetHours - longitude / 15 - eqTime / 60;
    final sunriseH = noon - hourAngle(-0.833) / 15;
    final sunsetH = noon + hourAngle(-0.833) / 15;
    final fajrH = noon - hourAngle(-fajrAngle) / 15;
    final ishaH = noon + hourAngle(-ishaAngle) / 15;

    final latRad = latitude * math.pi / 180;
    final shadowAngle = math.atan(1 / (asrFactor + math.tan((latRad - decl).abs())));
    final asrH = noon + hourAngle(shadowAngle * 180 / math.pi) / 15;

    DateTime at(double hour) {
      final minutes = (hour * 60).round();
      return DateTime(date.year, date.month, date.day)
          .add(Duration(minutes: minutes));
    }

    return PrayerTimes(
      fajr: at(fajrH),
      sunrise: at(sunriseH),
      dhuhr: at(noon),
      asr: at(asrH),
      maghrib: at(sunsetH),
      isha: at(ishaH),
    );
  }
}
