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

  static const green = Color(0xFF145A42);
  static const darkGreen = Color(0xFF0C3D2D);
  static const gold = Color(0xFFD7AE45);
  static const cities = <String, List<double>>{
    'Kabul': [34.5553, 69.2075],
    'Kandahar': [31.6289, 65.7372],
    'Herat': [34.3529, 62.2040],
    'Mazar-e-Sharif': [36.7069, 67.1122],
    'Jalalabad': [34.4342, 70.4478],
    'Kunduz': [36.7286, 68.8681],
  };

  String tr(String ps, String fa, String en) =>
      language == 'en' ? en : language == 'fa' ? fa : ps;
  String get todayLabel => tr('نن', 'امروز', 'Today');

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
        backgroundColor: const Color(0xFFF3F7F3),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F7F3),
          foregroundColor: darkGreen,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 16,
          title: Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.auto_awesome, color: gold),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tr('افغان غزالي کلیز', 'تقویم افغانی غزالی', 'Afghan Ghazali Calendar'),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                Text(tr('د وخت، عبادت او کرنې ملګری', 'همراه زمان، عبادت و زراعت', 'Time • Prayer • Farming'),
                    style: TextStyle(fontSize: 10, color: Colors.blueGrey.shade600)),
              ],
            )),
          ]),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.translate_rounded),
              onSelected: (v) => setState(() => language = v),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'ps', child: Text('پښتو')),
                PopupMenuItem(value: 'fa', child: Text('دری')),
                PopupMenuItem(value: 'en', child: Text('English')),
              ],
            ),
            const SizedBox(width: 5),
          ],
        ),
        body: tab == 2
            ? AgricultureScreen(language: language)
            : tab == 1
                ? _prayerPage(prayer)
                : tab == 3
                    ? _settingsPage()
                    : SafeArea(
                        top: false,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                          children: [
                            Row(children: [
                              Expanded(child: Text(tr('السلام علیکم', 'السلام علیکم', 'Welcome back'),
                                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: darkGreen))),
                              Chip(
                                avatar: const Icon(Icons.circle, size: 8, color: Color(0xFF2E8B57)),
                                label: Text(todayLabel),
                                backgroundColor: const Color(0xFFE4EFE7),
                                side: BorderSide.none,
                              ),
                            ]),
                            const SizedBox(height: 14),
                            _todayCard(solar, isToday, hijri),
                            const SizedBox(height: 22),
                            _section(tr('میاشتنی کلیز', 'تقویم ماهانه', 'Monthly calendar'),
                                tr('درې ډوله نېټې په یوه ځای کې', 'سه نوع تاریخ در یک‌جا', 'Three calendar systems'),
                                Icons.calendar_month_rounded),
                            const SizedBox(height: 10),
                            _monthHeader(solar),
                            const SizedBox(height: 8),
                            _calendarGrid(solar),
                            const SizedBox(height: 22),
                            _section(tr('د لمانځه وختونه', 'اوقات نماز', 'Prayer times'), city, Icons.mosque_rounded),
                            const SizedBox(height: 10),
                            _prayerCard(prayer),
                            const SizedBox(height: 8),
                            _citySelector(),
                            const SizedBox(height: 20),
                            _section(tr('د کلیز معلومات', 'اطلاعات تقویم', 'Calendar information'),
                                tr('د روان لمریز کال پېژندنه', 'سال جاری شمسی', 'Current Afghan solar year'),
                                Icons.info_outline_rounded),
                            const SizedBox(height: 8),
                            _infoTile(Icons.wb_sunny_outlined,
                                '${AfghanCalendar.monthName(nowSolar.month, language)} ${AfghanCalendar.formatNumber(nowSolar.year, language)}',
                                tr('د افغانستان روان لمریز کال', 'سال شمسی افغانستان', 'Current Afghan solar year')),
                            const SizedBox(height: 12),
                            _accuracyNote(),
                          ],
                        ),
                      ),
        bottomNavigationBar: NavigationBar(
          height: 72,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          indicatorColor: const Color(0xFFDCECE2),
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.calendar_month_outlined),
                selectedIcon: const Icon(Icons.calendar_month_rounded), label: tr('کلیز', 'تقویم', 'Calendar')),
            NavigationDestination(icon: const Icon(Icons.access_time_rounded), label: tr('لمونځ', 'نماز', 'Prayer')),
            NavigationDestination(icon: const Icon(Icons.grass_outlined),
                selectedIcon: const Icon(Icons.agriculture_rounded), label: tr('کرنه', 'زراعت', 'Farming')),
            NavigationDestination(icon: const Icon(Icons.tune_rounded), label: tr('امستنې', 'تنظیمات', 'Settings')),
          ],
        ),
      ),
    );
  }

  Widget _todayCard(dynamic solar, bool isToday, IslamicDate hijri) {
    final muted = Colors.white.withOpacity(0.76);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [darkGreen, green, Color(0xFF287B59)],
            begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [BoxShadow(color: Color(0x25104B3A), blurRadius: 22, offset: Offset(0, 10))],
      ),
      child: Column(children: [
        Row(children: [
          const Icon(Icons.event_available_rounded, color: gold, size: 18),
          const SizedBox(width: 7),
          Text(isToday ? todayLabel : _gregorian(selectedDate),
              style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(tr('افغانستان', 'افغانستان', 'Afghanistan'), style: TextStyle(color: muted, fontSize: 11)),
        ]),
        const SizedBox(height: 12),
        Text(AfghanCalendar.formatNumber(solar.day, language),
            style: const TextStyle(color: Color(0xFFFFD76A), fontSize: 60, height: 1, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        Text('${AfghanCalendar.monthName(solar.month, language)} ${AfghanCalendar.formatNumber(solar.year, language)}',
            style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 17),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.11),
              borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white24)),
          child: Column(children: [
            _dateLine(Icons.nightlight_round,
                '${tr('قمري', 'قمری', 'Islamic')}: ${IslamicCalendar.monthName(hijri.month, language)} ${AfghanCalendar.formatNumber(hijri.day, language)} ${AfghanCalendar.formatNumber(hijri.year, language)}', Colors.white),
            const Padding(padding: EdgeInsets.symmetric(vertical: 9), child: Divider(color: Colors.white24, height: 1)),
            _dateLine(Icons.calendar_today_outlined,
                '${tr('میلادي', 'میلادی', 'Gregorian')}: ${_gregorian(selectedDate)}', muted),
          ]),
        ),
        const SizedBox(height: 13),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            onPressed: () => setState(() => selectedDate = DateTime.now()),
            icon: const Icon(Icons.today_rounded, size: 17), label: Text(todayLabel),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(.5)), shape: const StadiumBorder()),
          )),
          const SizedBox(width: 9),
          Expanded(child: OutlinedButton.icon(
            onPressed: _chooseDate,
            icon: const Icon(Icons.edit_calendar_rounded, size: 17),
            label: Text(tr('نېټه وټاکئ', 'انتخاب تاریخ', 'Choose date')),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(.5)), shape: const StadiumBorder()),
          )),
        ]),
        const SizedBox(height: 7),
        Text(tr('قمري نېټه محاسبوي ده؛ د سپوږمۍ د لیدلو له مخې یوه ورځ توپیر لرلای شي.',
            'تاریخ قمری محاسباتی است و ممکن است یک روز تفاوت داشته باشد.',
            'Calculated Hijri date may differ by one day from local moon sighting.'),
            textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 10, height: 1.4)),
      ]),
    );
  }

  Widget _dateLine(IconData icon, String value, Color color) => Row(
    mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 15, color: gold), const SizedBox(width: 7),
      Flexible(child: Text(value, textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600))),
    ]);

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(context: context, initialDate: selectedDate,
        firstDate: DateTime(1900), lastDate: DateTime(2100));
    if (picked != null) setState(() => selectedDate = picked);
  }

  String _gregorian(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Widget _section(String title, String subtitle, IconData icon) => Row(children: [
    Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFFE2EEE6), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: green, size: 20)),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: darkGreen, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(subtitle, style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 10.5)),
    ])),
  ]);

  Widget _monthHeader(dynamic solar) => Row(children: [
    IconButton.filledTonal(onPressed: () {
      final first = DateTime(selectedDate.year, selectedDate.month, 1);
      setState(() => selectedDate = DateTime(first.year, first.month - 1, 15));
    }, icon: const Icon(Icons.chevron_left_rounded)),
    Expanded(child: Column(children: [
      Text('${AfghanCalendar.monthName(solar.month, language)} ${AfghanCalendar.formatNumber(solar.year, language)}',
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: green)),
      Text(tr('د افغانستان لمریز کلیز', 'تقویم هجری شمسی افغانستان', 'Afghan solar calendar'),
          style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 10)),
    ])),
    IconButton.filledTonal(onPressed: () {
      final first = DateTime(selectedDate.year, selectedDate.month, 1);
      setState(() => selectedDate = DateTime(first.year, first.month + 1, 1));
    }, icon: const Icon(Icons.chevron_right_rounded)),
  ]);

  Widget _calendarGrid(dynamic selectedSolar) {
    final firstDate = AfghanCalendar.toGregorian(selectedSolar.year, selectedSolar.month, 1);
    final offset = (firstDate.weekday + 1) % 7;
    final count = AfghanCalendar.daysInMonth(selectedSolar.year, selectedSolar.month);
    final rows = ((offset + count) / 7).ceil();
    final weekdays = AfghanCalendar.weekdayNames(language);
    final legend = language == 'en' ? 'AFGHAN SOLAR  •  GREGORIAN  •  ISLAMIC LUNAR'
        : language == 'fa' ? 'شمسی افغانستان  •  میلادی  •  قمری'
        : 'افغاني لمریز  ·  عیسوي میلادي  ·  اسلامي قمري';
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 14, 9, 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE5ECE6)),
          boxShadow: const [BoxShadow(color: Color(0x0C173F30), blurRadius: 15, offset: Offset(0, 5))]),
      child: Column(children: [
        Text(legend, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9.5, letterSpacing: .2, fontWeight: FontWeight.w800, color: Color(0xFF718078))),
        const SizedBox(height: 12),
        Row(children: weekdays.map((d) => Expanded(child: Center(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Text(d, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: green)),
        )))).toList()),
        for (var row = 0; row < rows; row++)
          Row(children: List.generate(7, (col) {
            final day = row * 7 + col - offset + 1;
            if (day < 1 || day > count) return const Expanded(child: SizedBox(height: 57));
            final date = AfghanCalendar.toGregorian(selectedSolar.year, selectedSolar.month, day);
            final selected = DateUtils.isSameDay(date, selectedDate);
            final today = DateUtils.isSameDay(date, DateTime.now());
            final lunar = IslamicCalendar.fromGregorian(date);
            return Expanded(child: Padding(
              padding: const EdgeInsets.all(2),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => selectedDate = date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160), height: 57,
                  decoration: BoxDecoration(
                    color: selected ? green : today ? const Color(0xFFFFF4D6) : const Color(0xFFF7F9F7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? green : today ? const Color(0xFFE4BF5D) : const Color(0xFFEEF2EE)),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(AfghanCalendar.formatNumber(day, language),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                            color: selected ? Colors.white : const Color(0xFF263A30))),
                    const SizedBox(height: 3),
                    Text('${AfghanCalendar.formatNumber(date.day, language)} · ${AfghanCalendar.formatNumber(lunar.day, language)}',
                        style: TextStyle(fontSize: 8.5, height: 1,
                            color: selected ? Colors.white70 : const Color(0xFF849188))),
                  ]),
                ),
              ),
            ));
          })),
        const SizedBox(height: 9),
        Wrap(alignment: WrapAlignment.center, spacing: 13, children: [
          _legendDot(green, tr('ټاکل شوې', 'انتخاب‌شده', 'Selected')),
          _legendDot(const Color(0xFFE4BF5D), todayLabel),
        ]),
      ]),
    );
  }

  Widget _legendDot(Color color, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    const SizedBox(width: 5), Text(label, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 10)),
  ]);

  Widget _prayerPage(PrayerTimes prayer) => SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
    _section(tr('د لمانځه وختونه', 'اوقات نماز', 'Prayer times'), city, Icons.mosque_rounded),
    const SizedBox(height: 16), _citySelector(), const SizedBox(height: 12),
    _prayerCard(prayer), const SizedBox(height: 12), _accuracyNote(),
  ]));

  Widget _settingsPage() => SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
    _section(tr('امستنې', 'تنظیمات', 'Settings'),
        tr('د اپلیکیشن شخصي کول', 'شخصی‌سازی برنامه', 'Personalize the app'), Icons.tune_rounded),
    const SizedBox(height: 16),
    _infoTile(Icons.translate_rounded, tr('د اپلیکیشن ژبه', 'زبان برنامه', 'App language'),
        tr('پښتو، دري، انګلیسي', 'پشتو، دری، انگلیسی', 'Pashto, Dari, English'),
        trailing: DropdownButton<String>(value: language, underline: const SizedBox.shrink(),
          items: const [DropdownMenuItem(value: 'ps', child: Text('پښتو')),
            DropdownMenuItem(value: 'fa', child: Text('دري')), DropdownMenuItem(value: 'en', child: Text('English'))],
          onChanged: (v) { if (v != null) setState(() => language = v); })),
    const SizedBox(height: 10),
    _infoTile(Icons.location_on_outlined, tr('ټاکل شوی ښار', 'شهر انتخاب‌شده', 'Selected city'), city),
    const SizedBox(height: 8), _citySelector(), const SizedBox(height: 10),
    _infoTile(Icons.info_outline_rounded, tr('د اپلیکیشن په اړه', 'درباره برنامه', 'About'), 'Afghan Ghazali Calendar'),
  ]));

  Widget _infoTile(IconData icon, String title, String subtitle, {Widget? trailing}) => Card(
    elevation: 0, color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17), side: const BorderSide(color: Color(0xFFE7EDE8))),
    child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      leading: CircleAvatar(backgroundColor: const Color(0xFFE8F0EA), child: Icon(icon, color: green, size: 20)),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade600)),
      trailing: trailing),
  );

  Widget _prayerCard(PrayerTimes times) {
    final entries = [
      ['فجر', 'Fajr', times.fajr, Icons.wb_twilight_rounded],
      ['لمر خاته', 'Sunrise', times.sunrise, Icons.wb_sunny_outlined],
      ['ماسپښین', 'Dhuhr', times.dhuhr, Icons.light_mode_outlined],
      ['مازدیګر', 'Asr', times.asr, Icons.sunny],
      ['ماښام', 'Maghrib', times.maghrib, Icons.wb_twilight],
      ['ماخوستن', 'Isha', times.isha, Icons.nights_stay_outlined],
    ];
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7EDE8))),
      child: Column(children: entries.asMap().entries.map((entry) {
        final e = entry.value;
        final label = language == 'en' ? e[1] as String : e[0] as String;
        final time = e[2] as DateTime;
        return Column(children: [
          ListTile(dense: true,
            leading: CircleAvatar(radius: 17, backgroundColor: const Color(0xFFF2F6F2),
                child: Icon(e[3] as IconData, color: gold, size: 18)),
            title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            trailing: Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontWeight: FontWeight.w900, color: green, fontSize: 16))),
          if (entry.key != entries.length - 1) const Divider(height: 1, indent: 58, endIndent: 14),
        ]);
      }).toList()),
    );
  }

  Widget _citySelector() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5ECE6))),
    child: Row(children: [
      const Icon(Icons.location_city_rounded, color: green, size: 19), const SizedBox(width: 9),
      Text(tr('ښار', 'شهر', 'City'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
      const SizedBox(width: 12),
      Expanded(child: DropdownButton<String>(isExpanded: true, underline: const SizedBox.shrink(),
        value: city, items: cities.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (v) { if (v != null) setState(() => city = v); })),
    ]),
  );

  Widget _accuracyNote() => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: const Color(0xFFFFF8E8), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1E4C5))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.info_outline_rounded, color: Color(0xFF9B7628), size: 18),
      const SizedBox(width: 9),
      Expanded(child: Text(tr(
        'د لمانځه وختونه په آفلاین ډول اټکلي محاسبه کېږي؛ له خپل محل جومات سره یې پرتله کړئ.',
        'اوقات نماز به‌صورت آفلاین و تقریبی محاسبه می‌شود؛ با مسجد محل بررسی کنید.',
        'Prayer times are approximate offline calculations. Verify them with your local mosque timetable.'),
        style: const TextStyle(color: Color(0xFF78602B), fontSize: 11, height: 1.5))),
    ]),
  );
}
