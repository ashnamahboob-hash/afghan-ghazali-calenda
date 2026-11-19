import 'package:flutter/material.dart';
import '../services/afghan_calendar.dart';
import '../services/islamic_calendar.dart';
import '../services/prayer_times.dart';
import 'agriculture_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  String language = 'ps';
  String city = 'Kabul';
  int tab = 0;

  static const cities = <String, List<double>>{
    'Kabul': [34.5553, 69.2075],
    'Kandahar': [31.6289, 65.7372],
    'Herat': [34.3529, 62.2040],
    'Mazar-e-Sharif': [36.7069, 67.1122],
    'Jalalabad': [34.4342, 70.4478],
    'Kunduz': [36.7286, 68.8681],
  };

  String get trTitle => language == 'en'
      ? 'Afghan Ghazali Calendar'
      : language == 'fa'
          ? 'تقویم افغانی غزالی'
          : 'افغان غزالي کلنډر';

  String get todayLabel => language == 'en'
      ? 'Today'
      : language == 'fa'
          ? 'امروز'
          : 'نن';

  @override
  Widget build(BuildContext context) {
    final solar = AfghanCalendar.fromGregorian(selectedDate);
    final nowSolar = AfghanCalendar.fromGregorian(DateTime.now());
    final hijri = IslamicCalendar.fromGregorian(selectedDate);
    final prayer = PrayerTimes.calculate(
      date: selectedDate,
      latitude: cities[city]![0],
      longitude: cities[city]![1],
    );
    final isToday = DateUtils.isSameDay(selectedDate, DateTime.now());

    return Directionality(
      key: const ValueKey('home-content-direction'),
      textDirection: language == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
      appBar: AppBar(
        title: Text(trTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) => setState(() => language = value),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'ps', child: Text('پښتو')),
              PopupMenuItem(value: 'fa', child: Text('دری')),
              PopupMenuItem(value: 'en', child: Text('English')),
            ],
          ),
        ],
      ),
      body: tab == 2
          ? AgricultureScreen(language: language)
          : tab == 1
              ? _prayerPage(prayer)
              : tab == 3
                  ? _settingsPage()
                  : SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            _todayCard(solar, isToday, hijri),
            const SizedBox(height: 16),
            _monthHeader(solar),
            const SizedBox(height: 8),
            _calendarGrid(solar),
            const SizedBox(height: 16),
            _sectionTitle(language == 'en' ? 'Prayer times' : language == 'fa' ? 'اوقات نماز' : 'د لمانځه وختونه'),
            const SizedBox(height: 8),
            _prayerCard(prayer),
            const SizedBox(height: 12),
            _citySelector(),
            const SizedBox(height: 18),
            _sectionTitle(language == 'en' ? 'Calendar information' : language == 'fa' ? 'معلومات تقویم' : 'د کلیز معلومات'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.event_available, color: Color(0xFF145A42)),
                title: Text('${AfghanCalendar.monthName(nowSolar.month, language)} ${AfghanCalendar.formatNumber(nowSolar.year, language)}'),
                subtitle: Text(language == 'en' ? 'Current Afghan solar year' : language == 'fa' ? 'سال شمسی افغانستان' : 'د افغانستان روان لمریز کال'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              language == 'en'
                  ? 'Prayer times are approximate offline calculations. Verify with your local mosque timetable.'
                  : language == 'fa'
                      ? 'اوقات نماز به‌صورت آفلاین و تقریبی محاسبه می‌شود؛ با جدول مسجد محل بررسی کنید.'
                      : 'د لمانځه وختونه په آفلاین ډول اټکلي محاسبه کېږي؛ د خپل محل له جومات سره یې پرتله کړئ.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.calendar_month), label: language == 'en' ? 'Calendar' : language == 'fa' ? 'تقویم' : 'کلیز'),
          NavigationDestination(icon: const Icon(Icons.access_time), label: language == 'en' ? 'Prayer' : language == 'fa' ? 'نماز' : 'لمونځ'),
          NavigationDestination(icon: const Icon(Icons.agriculture), label: language == 'en' ? 'Farming' : language == 'fa' ? 'زراعت' : 'کرنه'),
          NavigationDestination(icon: const Icon(Icons.settings), label: language == 'en' ? 'Settings' : language == 'fa' ? 'تنظیمات' : 'تنظیمات'),
        ],
      ),
    ));
  }


  Widget _prayerPage(PrayerTimes prayer) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(language == 'en' ? 'Prayer times' : language == 'fa' ? 'اوقات نماز' : 'د لمانځه وختونه'),
          const SizedBox(height: 8),
          _citySelector(),
          const SizedBox(height: 12),
          _prayerCard(prayer),
          const SizedBox(height: 12),
          Text(
            language == 'en'
                ? 'Times are calculated offline and are approximate. Select your city and verify with your local mosque.'
                : language == 'fa'
                    ? 'اوقات به‌صورت آفلاین و تقریبی محاسبه می‌شود. شهر خود را انتخاب کنید و با مسجد محل بررسی نمایید.'
                    : 'وختونه په آفلاین ډول اټکلي محاسبه کېږي. خپل ښار وټاکئ او د خپل محل له جومات سره یې پرتله کړئ.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _settingsPage() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(language == 'en' ? 'Settings' : language == 'fa' ? 'تنظیمات' : 'تنظیمات'),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(language == 'en' ? 'App language' : language == 'fa' ? 'زبان برنامه' : 'د اپلیکیشن ژبه'),
              subtitle: Text(language == 'en' ? 'Pashto, Dari, English' : language == 'fa' ? 'پشتو، دری، انگلیسی' : 'پښتو، دري، انګلیسي'),
              trailing: DropdownButton<String>(
                value: language,
                items: const [
                  DropdownMenuItem(value: 'ps', child: Text('پښتو')),
                  DropdownMenuItem(value: 'fa', child: Text('دري')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) { if (value != null) setState(() => language = value); },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(child: ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(language == 'en' ? 'Selected city' : language == 'fa' ? 'شهر انتخاب‌شده' : 'ټاکل شوی ښار'),
            subtitle: Text(city),
            trailing: const Icon(Icons.location_city),
          )),
          _citySelector(),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(language == 'en' ? 'About this app' : language == 'fa' ? 'درباره برنامه' : 'د اپلیکیشن په اړه'),
              subtitle: const Text('Afghan Ghazali Calendar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _todayCard(dynamic solar, bool isToday, IslamicDate hijri) {
    final month = AfghanCalendar.monthName(solar.month, language);
    final day = AfghanCalendar.formatNumber(solar.day, language);
    final year = AfghanCalendar.formatNumber(solar.year, language);
    final muted = Colors.white.withOpacity(0.76);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF104B3A), Color(0xFF176B50), Color(0xFF21805E)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Color(0x24104B3A), blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.16)),
                ),
                child: Text(
                  isToday ? todayLabel : _gregorian(selectedDate),
                  style: TextStyle(color: muted, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(day, style: const TextStyle(
            color: Color(0xFFFFD76A), fontSize: 62, height: 1.08, fontWeight: FontWeight.w800,
          )),
          const SizedBox(height: 3),
          Text('$month $year', style: const TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.nightlight_round, color: Color(0xFFFFD76A), size: 18),
                    const SizedBox(width: 7),
                    Flexible(child: Text(
                      language == 'en'
                        ? 'Islamic: ${IslamicCalendar.monthName(hijri.month, language)} ${hijri.day} ${hijri.year} AH'
                        : language == 'fa'
                          ? 'قمری: ${IslamicCalendar.monthName(hijri.month, language)} ${AfghanCalendar.formatNumber(hijri.day, language)} ${AfghanCalendar.formatNumber(hijri.year, language)}'
                          : 'قمري: ${IslamicCalendar.monthName(hijri.month, language)} ${AfghanCalendar.formatNumber(hijri.day, language)} ${AfghanCalendar.formatNumber(hijri.year, language)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                    )),
                  ],
                ),
                const SizedBox(height: 8),
                Container(height: 1, color: Colors.white.withOpacity(0.16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 15),
                    const SizedBox(width: 7),
                    Text(
                      language == 'en' ? 'Gregorian: ${_gregorian(selectedDate)}'
                        : language == 'fa' ? 'میلادی: ${_gregorian(selectedDate)}'
                        : 'میلادي: ${_gregorian(selectedDate)}',
                      style: TextStyle(color: muted, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  language == 'en'
                    ? 'Calculated lunar date; local moon sighting may differ by one day.'
                    : language == 'fa'
                      ? 'تاریخ قمری محاسباتی است و ممکن است با رؤیت محلی هلال یک روز تفاوت داشته باشد.'
                      : 'دا محاسبوي قمري نېټه ده؛ د سپوږمۍ د رسمي لیدنې له مخې یوه ورځ توپیر کولای شي.',
                  style: TextStyle(color: muted, fontSize: 11.5, height: 1.45),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => selectedDate = DateTime.now()),
                icon: const Icon(Icons.today_rounded, size: 17),
                label: Text(todayLabel),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.55)),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 11),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
                icon: const Icon(Icons.calendar_month_rounded, size: 18),
                label: Text(language == 'en' ? 'Choose date' : language == 'fa' ? 'انتخاب تاریخ' : 'نېټه وټاکئ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.55)),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

    String _gregorian(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Widget _monthHeader(dynamic solar) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () {
              final first = DateTime(selectedDate.year, selectedDate.month, 1);
              setState(() => selectedDate = DateTime(first.year, first.month - 1, 15));
            },
            icon: const Icon(Icons.chevron_left_rounded),
            tooltip: language == 'en' ? 'Previous month' : language == 'fa' ? 'ماه قبل' : 'تېره میاشت',
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${AfghanCalendar.monthName(solar.month, language)} ${AfghanCalendar.formatNumber(solar.year, language)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xFF145A42)),
                ),
                Text(
                  language == 'en' ? 'Afghan solar calendar' : language == 'fa' ? 'تقویم هجری شمسی افغانستان' : 'د افغانستان لمریز کلیز',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF75847C), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              final first = DateTime(selectedDate.year, selectedDate.month, 1);
              setState(() => selectedDate = DateTime(first.year, first.month + 1, 1));
            },
            icon: const Icon(Icons.chevron_right_rounded),
            tooltip: language == 'en' ? 'Next month' : language == 'fa' ? 'ماه بعد' : 'راتلونکې میاشت',
          ),
        ],
      ),
    );
  }

    Widget _calendarGrid(dynamic selectedSolar) {
    final firstDate = AfghanCalendar.toGregorian(selectedSolar.year, selectedSolar.month, 1);
    final offset = (firstDate.weekday + 1) % 7;
    final count = AfghanCalendar.daysInMonth(selectedSolar.year, selectedSolar.month);
    final rows = ((offset + count) / 7).ceil();
    final weekdays = AfghanCalendar.weekdayNames(language);
    final legend = language == 'en'
        ? 'AFGHAN SOLAR  •  GREGORIAN  •  ISLAMIC LUNAR'
        : language == 'fa'
            ? 'شمسی افغانستان  •  میلادی  •  قمری'
            : 'افغاني لمریز  •  عیسوي میلادي  •  اسلامي قمري';
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8EEE9)),
        boxShadow: const [
          BoxShadow(color: Color(0x0D173F30), blurRadius: 18, offset: Offset(0, 7)),
        ],
      ),
      child: Column(
        children: [
          Text(legend, textAlign: TextAlign.center, style: const TextStyle(
            fontSize: 10, letterSpacing: 0.25, fontWeight: FontWeight.w800, color: Color(0xFF718078),
          )),
          const SizedBox(height: 13),
          Row(
            children: weekdays.map((d) => Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(d, style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF145A42),
                  )),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 3),
          for (var row = 0; row < rows; row++)
            Row(
              children: List.generate(7, (col) {
                final day = row * 7 + col - offset + 1;
                if (day < 1 || day > count) {
                  return const Expanded(child: SizedBox(height: 57));
                }
                final date = AfghanCalendar.toGregorian(selectedSolar.year, selectedSolar.month, day);
                final selected = DateUtils.isSameDay(date, selectedDate);
                final today = DateUtils.isSameDay(date, DateTime.now());
                final hijriDate = IslamicCalendar.fromGregorian(date);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(13),
                      onTap: () => setState(() => selectedDate = date),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 57,
                        decoration: BoxDecoration(
                          color: selected
                            ? const Color(0xFF145A42)
                            : today ? const Color(0xFFFFF5D8) : const Color(0xFFF8FAF8),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: selected ? const Color(0xFF145A42)
                              : today ? const Color(0xFFE3BD54) : const Color(0xFFF0F3F0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AfghanCalendar.formatNumber(day, language),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: selected || today ? FontWeight.w800 : FontWeight.w600,
                                color: selected ? Colors.white : const Color(0xFF263A30),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${AfghanCalendar.formatNumber(date.day, language)} · ${AfghanCalendar.formatNumber(hijriDate.day, language)}',
                              style: TextStyle(
                                fontSize: 8.5,
                                height: 1,
                                color: selected ? Colors.white70 : const Color(0xFF849188),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

    Widget _sectionTitle(String title) => Text(title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF145A42)));

  Widget _prayerCard(PrayerTimes times) {
    final entries = [
      ['فجر', 'Fajr', times.fajr],
      ['لمر خاته', 'Sunrise', times.sunrise],
      ['ماسپښین', 'Dhuhr', times.dhuhr],
      ['مازدیګر', 'Asr', times.asr],
      ['ماښام', 'Maghrib', times.maghrib],
      ['ماخوستن', 'Isha', times.isha],
    ];
    return Card(
      child: Column(
        children: entries.map((e) {
          final label = language == 'en' ? e[1] as String : e[0] as String;
          final time = e[2] as DateTime;
          return ListTile(
            dense: true,
            leading: const Icon(Icons.access_time, color: Color(0xFFD4AF37)),
            title: Text(label),
            trailing: Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF145A42), fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _citySelector() {
    return Row(
      children: [
        const Icon(Icons.location_city, color: Color(0xFF145A42)),
        const SizedBox(width: 8),
        Text(language == 'en' ? 'City:' : language == 'fa' ? 'شهر:' : 'ښار:'),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: city,
            items: cities.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) { if (v != null) setState(() => city = v); },
          ),
        ),
      ],
    );
  }
}
