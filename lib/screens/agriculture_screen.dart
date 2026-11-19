import 'package:flutter/material.dart';
import '../services/administrative_reference.dart';

class AgricultureScreen extends StatefulWidget {
  final String language;
  const AgricultureScreen({super.key, required this.language});

  @override
  State<AgricultureScreen> createState() => _AgricultureScreenState();
}

class _AgricultureScreenState extends State<AgricultureScreen> {
  static const green = Color(0xFF145A42);
  static const darkGreen = Color(0xFF0C3D2D);
  static const gold = Color(0xFFD7AE45);

  String province = 'AF27';
  String season = 'Autumn';
  String crop = 'Wheat';
  String? district = 'AF2701';
  String districtQuery = '';
  late final Future<AdministrativeReference> referenceFuture;

  @override
  void initState() {
    super.initState();
    referenceFuture = AdministrativeReference.load();
  }

  String get lang => widget.language;
  bool get en => lang == 'en';
  bool get fa => lang == 'fa';
  String tr(String ps, String faText, String enText) =>
      en ? enText : fa ? faText : ps;

  static const crops = <String, List<String>>{
    'Wheat': ['غنم', 'گندم', 'Wheat'],
    'Rice': ['وریجې', 'برنج', 'Rice'],
    'Maize': ['جوار', 'ذرت', 'Maize'],
    'Barley': ['وربشې', 'جو', 'Barley'],
  };

  static const seasons = <String, List<String>>{
    'Spring': ['پسرلی', 'بهار'],
    'Summer': ['اوړی', 'تابستان'],
    'Autumn': ['منی', 'خزان'],
    'Winter': ['ژمی', 'زمستان'],
  };

  // Deliberately fictional QA fixtures. These dates are for interface testing only.
  // They are not agronomic recommendations and must not be used for farm decisions.
  static const testDateWindows = <String, Map<String, List<String>>>{
    'Wheat': {
      'Spring': ['10/03 – 25/03', '10/07 – 25/07'],
      'Summer': ['01/06 – 20/06', '15/09 – 05/10'],
      'Autumn': ['15/10 – 15/11', '15/05 – 15/06'],
      'Winter': ['01/12 – 20/12', '01/06 – 20/06'],
    },
    'Rice': {
      'Spring': ['15/04 – 15/05', '15/08 – 15/09'],
      'Summer': ['01/06 – 25/06', '01/10 – 01/11'],
      'Autumn': ['01/09 – 20/09', '01/01 – 20/01'],
      'Winter': ['01/12 – 20/12', '01/04 – 20/04'],
    },
    'Maize': {
      'Spring': ['15/03 – 15/04', '15/07 – 15/08'],
      'Summer': ['01/06 – 01/07', '15/09 – 15/10'],
      'Autumn': ['01/09 – 20/09', '01/01 – 20/01'],
      'Winter': ['01/12 – 20/12', '01/04 – 20/04'],
    },
    'Barley': {
      'Spring': ['01/03 – 20/03', '15/06 – 15/07'],
      'Summer': ['01/06 – 20/06', '01/09 – 20/09'],
      'Autumn': ['01/10 – 01/11', '15/04 – 15/05'],
      'Winter': ['01/12 – 20/12', '01/05 – 20/05'],
    },
  };

  String get cropName => crops[crop]![en ? 2 : fa ? 1 : 0];
  String get seasonName => en ? season : seasons[season]![fa ? 1 : 0];
  String _districtName(AdministrativeUnit item) =>
      en ? item.englishName : item.localName;
  String _provinceName(AdministrativeProvince item) =>
      en ? item.englishName : item.localName;

  @override
  Widget build(BuildContext context) {
    final windows = testDateWindows[crop]![season]!;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          _hero(),
          const SizedBox(height: 18),
          _sectionTitle(
            tr('د کرنې ځای او فصل', 'موقعیت و فصل زراعت', 'Farm location & season'),
            tr('ولایت، اداري واحد او موسم وټاکئ', 'ولایت، واحد اداری و فصل را انتخاب کنید', 'Choose province, administrative unit and season'),
            Icons.tune_rounded,
          ),
          const SizedBox(height: 12),
          FutureBuilder<AdministrativeReference>(
            future: referenceFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _notice(
                  tr('د اداري معلوماتو لوډول ناکام شول.', 'بارگذاری اطلاعات اداری ناموفق بود.', 'Could not load administrative reference.'),
                  Icons.error_outline_rounded,
                );
              }
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final reference = snapshot.data!;
              final selectedProvince = reference.provinces.firstWhere(
                (item) => item.id == province,
                orElse: () => reference.provinces.first,
              );
              final query = AdministrativeReference.normalizeSearchText(districtQuery);
              final visibleUnits = selectedProvince.units.where((item) {
                if (query.isEmpty) return true;
                return <String>[item.id, item.localName, item.englishName]
                    .map(AdministrativeReference.normalizeSearchText)
                    .any((name) => name.contains(query));
              }).toList(growable: false);
              final selectedDistrict = visibleUnits.any((item) => item.id == district)
                  ? district
                  : null;
              return _panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(tr('ولایت', 'ولایت', 'Province'), Icons.location_on_outlined),
                    DropdownButtonFormField<String>(
                      value: selectedProvince.id,
                      isExpanded: true,
                      decoration: _inputDecoration(tr('ولایت وټاکئ', 'انتخاب ولایت', 'Select province')),
                      items: reference.provinces.map((item) => DropdownMenuItem(
                        value: item.id, child: Text(_provinceName(item)),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() {
                          province = value;
                          district = null;
                          districtQuery = '';
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    _fieldLabel(tr('اداري واحد', 'واحد اداری', 'Administrative unit'), Icons.map_outlined),
                    TextFormField(
                      decoration: _inputDecoration(tr('د اداري واحد لټون', 'جستجوی واحد اداری', 'Search administrative unit'))
                          .copyWith(prefixIcon: const Icon(Icons.search)),
                      onChanged: (value) => setState(() => districtQuery = value),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedDistrict,
                      isExpanded: true,
                      decoration: _inputDecoration(tr('واحد وټاکئ', 'انتخاب واحد', 'Select unit')),
                      hint: Text(tr('برابر واحد ونه موندل شو', 'واحدی یافت نشد', 'No matching units')),
                      items: visibleUnits.map((item) => DropdownMenuItem(
                        value: item.id, child: Text(_districtName(item)),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => district = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    _notice(
                      tr(
                        'د اداري نوملړ مخکتنه ده: ۳۴ ولایتونه او ۴۰۱ د دویمې کچې ریکارډونه. نومونه او اړیکې لا رسمي تایید ته اړتیا لري.',
                        'این فهرست پیش‌نمایش است: ۳۴ ولایت و ۴۰۱ واحد سطح دوم. نام‌ها و ارتباطات هنوز نیازمند تأیید رسمی‌اند.',
                        'Preview reference: 34 provinces and 401 ADM2 records. Names and relationships still require official verification.',
                      ),
                      Icons.info_outline_rounded,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          _panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel(tr('موسم', 'فصل', 'Season'), Icons.wb_sunny_outlined),
                DropdownButtonFormField<String>(
                  value: season,
                  isExpanded: true,
                  decoration: _inputDecoration(tr('موسم وټاکئ', 'انتخاب فصل', 'Select season')),
                  items: seasons.keys.map((value) => DropdownMenuItem(
                    value: value, child: Text(en ? value : seasons[value]![fa ? 1 : 0]),
                  )).toList(),
                  onChanged: (value) { if (value != null) setState(() => season = value); },
                ),
                const SizedBox(height: 14),
                _fieldLabel(tr('کرنیز محصول', 'محصول زراعتی', 'Crop'), Icons.grass_rounded),
                DropdownButtonFormField<String>(
                  value: crop,
                  isExpanded: true,
                  decoration: _inputDecoration(tr('محصول وټاکئ', 'انتخاب محصول', 'Select crop')),
                  items: crops.keys.map((value) => DropdownMenuItem(
                    value: value, child: Text(crops[value]![en ? 2 : fa ? 1 : 0]),
                  )).toList(),
                  onChanged: (value) { if (value != null) setState(() => crop = value); },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _sectionTitle(
            tr('د کښت او حاصل نېټې', 'تاریخ کشت و برداشت', 'Planting & harvest dates'),
            tr('د ټاکل شوي محصول لپاره ازمایښتي نمونه', 'نمونه آزمایشی برای محصول انتخاب‌شده', 'Test sample for the selected crop'),
            Icons.date_range_rounded,
          ),
          const SizedBox(height: 10),
          _testBanner(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _dateCard(
                icon: Icons.spa_outlined,
                title: tr('د کښت ازمایښتي موده', 'بازه آزمایشی کشت', 'Test planting window'),
                value: windows[0],
              )),
              const SizedBox(width: 10),
              Expanded(child: _dateCard(
                icon: Icons.agriculture_outlined,
                title: tr('د حاصل ازمایښتي موده', 'بازه آزمایشی برداشت', 'Test harvest window'),
                value: windows[1],
              )),
            ],
          ),
          const SizedBox(height: 12),
          _panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('د ازموینې ټاکنې', 'انتخاب‌های آزمایشی', 'Current test selection'),
                    style: const TextStyle(fontWeight: FontWeight.w800, color: darkGreen)),
                const SizedBox(height: 10),
                _selectionLine(tr('محصول', 'محصول', 'Crop'), cropName),
                _selectionLine(tr('موسم', 'فصل', 'Season'), seasonName),
                _selectionLine(tr('نېټې', 'تاریخ‌ها', 'Date format'), 'DD/MM'),
                const SizedBox(height: 10),
                Text(
                  tr(
                    'مهم: پورته نېټې یوازې د سکرین او انتخابونو د ازموینې لپاره تصادفي نمونې دي. د ولایت، ولسوالۍ، لوړوالي، اوبو او اقلیم له مخې نه دي محاسبه شوې؛ د حقیقي کرنې لپاره یې مه کاروئ.',
                    'مهم: تاریخ‌های بالا نمونه‌های ساختگی برای آزمایش صفحه و انتخاب‌ها هستند. بر اساس ولایت، ولسوالی، ارتفاع، آب یا اقلیم محاسبه نشده‌اند؛ برای کشت واقعی استفاده نکنید.',
                    'Important: The dates above are fictional QA samples for testing the screen and selectors. They are not calculated for the province, district, altitude, irrigation or climate. Do not use them for real farming.',
                  ),
                  style: const TextStyle(fontSize: 12, height: 1.55, color: Color(0xFF795D22)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _notice(
            tr(
              'د کرنې باوري سپارښتنې به یوازې د کرنې وزارت، FAO یا نورو باوري سرچینو تر ارزونې وروسته جلا ورزیاتې شي.',
              'رهنمودهای معتبر زراعتی تنها پس از بررسی وزارت زراعت، FAO یا منابع معتبر دیگر اضافه خواهند شد.',
              'Verified agricultural guidance will be added separately after review of Ministry of Agriculture, FAO or other reliable sources.',
            ),
            Icons.verified_outlined,
          ),
        ],
      ),
    );
  }

  Widget _hero() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [darkGreen, green, Color(0xFF287B59)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [BoxShadow(color: Color(0x24104B3A), blurRadius: 18, offset: Offset(0, 8))],
    ),
    child: Row(
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(color: Colors.white.withOpacity(.13), borderRadius: BorderRadius.circular(17)),
          child: const Icon(Icons.agriculture_rounded, color: Color(0xFFFFD76A), size: 30),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr('د افغانستان د کرنې کلیز', 'تقویم زراعتی افغانستان', 'Afghanistan Agriculture Calendar'),
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text(tr('د محصولاتو او موسمونو ازموینه', 'آزمایش محصولات و فصل‌ها', 'Test crops and growing seasons'),
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        )),
      ],
    ),
  );

  Widget _sectionTitle(String title, String subtitle, IconData icon) => Row(
    children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: const Color(0xFFE5F0E8), borderRadius: BorderRadius.circular(13)),
        child: Icon(icon, color: green, size: 21),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: darkGreen, fontSize: 15, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 10.5)),
        ],
      )),
    ],
  );

  Widget _panel({required Widget child}) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE5ECE6)),
      boxShadow: const [BoxShadow(color: Color(0x09173F30), blurRadius: 13, offset: Offset(0, 4))],
    ),
    child: child,
  );

  Widget _fieldLabel(String label, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(children: [
      Icon(icon, color: green, size: 17),
      const SizedBox(width: 7),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: darkGreen)),
    ]),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: Color(0xFFDDE6DE)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    filled: true,
    fillColor: const Color(0xFFFAFCFA),
  );

  Widget _dateCard({required IconData icon, required String title, required String value}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE5ECE6)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: gold, size: 23),
        const SizedBox(height: 9),
        Text(title, style: TextStyle(fontSize: 10.5, height: 1.35, color: Colors.blueGrey.shade600, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        Text(value, style: const TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text('DD/MM', style: TextStyle(fontSize: 9, color: Colors.blueGrey.shade400)),
      ],
    ),
  );

  Widget _testBanner() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF4D8),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE8CA79)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.science_outlined, color: Color(0xFF956D18), size: 20),
        const SizedBox(width: 9),
        Expanded(child: Text(
          tr('ازمایښتي معلومات – رسمي کرنیز معلومات نه دي', 'اطلاعات آزمایشی – داده رسمی زراعتی نیست', 'TEST DATA – NOT VERIFIED AGRICULTURAL DATA'),
          style: const TextStyle(color: Color(0xFF795D22), fontSize: 11, fontWeight: FontWeight.w900, height: 1.4),
        )),
      ],
    ),
  );

  Widget _selectionLine(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(child: Text(label, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 12))),
      Text(value, style: const TextStyle(color: darkGreen, fontSize: 12, fontWeight: FontWeight.w800)),
    ]),
  );

  Widget _notice(String message, IconData icon) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF1F6F2),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFDDE9DF)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: green, size: 19),
        const SizedBox(width: 9),
        Expanded(child: Text(message, style: const TextStyle(fontSize: 11, height: 1.5, color: Color(0xFF52665A)))),
      ],
    ),
  );
}
