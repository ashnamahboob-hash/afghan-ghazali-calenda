import 'package:flutter/material.dart';

class _Province {
  final String id;
  final String ps;
  final String fa;
  final String en;
  final String zone;
  const _Province(this.id, this.ps, this.fa, this.en, this.zone);
}

class AgricultureScreen extends StatefulWidget {
  final String language;
  const AgricultureScreen({super.key, required this.language});

  @override
  State<AgricultureScreen> createState() => _AgricultureScreenState();
}

class _AgricultureScreenState extends State<AgricultureScreen> {
  String province = 'Kandahar';
  String season = 'Autumn';
  String crop = 'Wheat';

  static const crops = <String, List<String>>{
    'Wheat': ['غنم', 'گندم', 'Wheat'],
    'Rice': ['وریجې', 'برنج', 'Rice'],
    'Maize': ['جوار', 'ذرت', 'Maize'],
    'Barley': ['وربشې', 'جو', 'Barley'],
  };

  String get cropName => crops[crop]![en ? 2 : fa ? 1 : 0];

  // Province names are localized. Sowing windows below follow the Afghan
  // Ministry of Agriculture's provincial wheat advisory (1402/8/17).
  static const provinces = <_Province>[
    _Province('Badakhshan','بدخشان','بدخشان','Badakhshan','northeast'),
    _Province('Badghis','بادغیس','بادغیس','Badghis','west'),
    _Province('Baghlan','بغلان','بغلان','Baghlan','northeast'),
    _Province('Balkh','بلخ','بلخ','Balkh','north'),
    _Province('Bamyan','بامیان','بامیان','Bamyan','unknown'),
    _Province('Daykundi','دایکندي','دایکندی','Daykundi','unknown'),
    _Province('Farah','فراه','فراه','Farah','southwest'),
    _Province('Faryab','فاریاب','فاریاب','Faryab','north'),
    _Province('Ghazni','غزني','غزنی','Ghazni','cold'),
    _Province('Ghor','غور','غور','Ghor','west'),
    _Province('Helmand','هلمند','هلمند','Helmand','southwest'),
    _Province('Herat','هرات','هرات','Herat','west'),
    _Province('Jawzjan','جوزجان','جوزجان','Jawzjan','north'),
    _Province('Kabul','کابل','کابل','Kabul','cold'),
    _Province('Kandahar','کندهار','قندهار','Kandahar','southwest'),
    _Province('Kapisa','کاپیسا','کاپیسا','Kapisa','cold'),
    _Province('Khost','خوست','خوست','Khost','east'),
    _Province('Kunar','کونړ','کنر','Kunar','east'),
    _Province('Kunduz','کندز','کندز','Kunduz','northeast'),
    _Province('Laghman','لغمان','لغمان','Laghman','east'),
    _Province('Logar','لوګر','لوگر','Logar','cold'),
    _Province('Nangarhar','ننګرهار','ننگرهار','Nangarhar','east'),
    _Province('Nimroz','نیمروز','نیمروز','Nimroz','southwest'),
    _Province('Nuristan','نورستان','نورستان','Nuristan','unknown'),
    _Province('Uruzgan','ارزګان','ارزگان','Uruzgan','southwest'),
    _Province('Paktia','پکتیا','پکتیا','Paktia','unknown'),
    _Province('Paktika','پکتیکا','پکتیکا','Paktika','cold'),
    _Province('Panjshir','پنجشېر','پنجشیر','Panjshir','unknown'),
    _Province('Parwan','پروان','پروان','Parwan','cold'),
    _Province('Samangan','سمنګان','سمنگان','Samangan','north'),
    _Province('Sar-e-Pul','سرپل','سرپل','Sar-e-Pul','unknown'),
    _Province('Takhar','تخار','تخار','Takhar','northeast'),
    _Province('Wardak','میدان وردګ','میدان وردک','Maidan Wardak','cold'),
    _Province('Zabul','زابل','زابل','Zabul','southwest'),
  ];

  static const seasons = <String, List<String>>{
    'Spring': ['پسرلی', 'بهار'],
    'Summer': ['اوړی', 'تابستان'],
    'Autumn': ['منی', 'خزان'],
    'Winter': ['ژمی', 'زمستان'],
  };

  String get lang => widget.language;
  bool get en => lang == 'en';
  bool get fa => lang == 'fa';
  String get title => en ? 'Afghanistan agriculture calendar' : fa ? 'تقویم زراعتی افغانستان' : 'د افغانستان د کرنې کلیز';

  String _provinceName(_Province p) => en ? p.en : fa ? p.fa : p.ps;
  String _seasonName(String id) => en ? id : seasons[id]![fa ? 1 : 0];

  String _wheatWindow(String zone) {
    switch (zone) {
      case 'cold':
        return en
            ? 'Winter wheat: 1–20 Mizan. Semi-winter wheat: 20 Mizan–20 Aqrab.'
            : fa
                ? 'گندم زمستانی: ۱ تا ۲۰ میزان؛ گندم نیمه‌زمستانی: ۲۰ میزان تا ۲۰ عقرب.'
                : 'ژمنی غنم: د میزان له ۱مې تر ۲۰مې؛ نیمه‌ژمنی غنم: د میزان له ۲۰مې تر ۲۰مې عقرب.';
      case 'north':
        return en ? 'Wheat sowing: 1 Aqrab–1 Qaws.' : fa ? 'زمان مناسب کشت گندم: ۱ عقرب تا ۱ قوس.' : 'د غنمو د کرلو مناسب وخت: د عقرب له ۱مې تر ۱مې قوس.';
      case 'west':
        return en ? 'Wheat sowing: after 15 Aqrab through the end of Qaws.' : fa ? 'زمان مناسب کشت گندم: پس از ۱۵ عقرب تا پایان قوس.' : 'د غنمو د کرلو مناسب وخت: د عقرب له ۱۵مې څخه د قوس تر پای پورې.';
      case 'northeast':
        return en ? 'Wheat sowing: 15 Aqrab–10 Qaws.' : fa ? 'زمان مناسب کشت گندم: ۱۵ عقرب تا ۱۰ قوس.' : 'د غنمو د کرلو مناسب وخت: د عقرب له ۱۵مې تر ۱۰مې قوس.';
      case 'east':
        return en ? 'Wheat sowing: 15 Aqrab–15 Qaws.' : fa ? 'زمان مناسب کشت گندم: ۱۵ عقرب تا ۱۵ قوس.' : 'د غنمو د کرلو مناسب وخت: د عقرب له ۱۵مې تر ۱۵مې قوس.';
      default:
        return en
            ? 'No verified provincial sowing window is available for this province yet. Please consult the local agricultural extension office.'
            : fa
                ? 'زمان کشت تأییدشده برای این ولایت هنوز در دسترس نیست؛ لطفاً با ریاست ترویج زراعتی محل مشوره کنید.'
                : 'د دې ولایت لپاره د کرلو تایید شوی وخت لا نه دی موندل شوی؛ مهرباني وکړئ د خپلې سیمې د کرنیز ترویج له ادارې سره مشوره وکړئ.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = provinces.firstWhere((p) => p.id == province);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF145A42), Color(0xFF247A59)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.agriculture, color: Color(0xFFFFD76A), size: 34),
                const SizedBox(height: 10),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  en ? 'Choose your province and season' : fa ? 'ولایت و فصل را انتخاب کنید' : 'خپل ولایت او موسم وټاکئ',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(en ? 'Province' : fa ? 'ولایت' : 'ولایت', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: province,
            isExpanded: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.location_on_outlined),
              labelText: en ? 'Select province' : fa ? 'انتخاب ولایت' : 'ولایت وټاکئ',
            ),
            items: provinces.map((p) => DropdownMenuItem(value: p.id, child: Text(_provinceName(p)))).toList(),
            onChanged: (v) { if (v != null) setState(() => province = v); },
          ),
          const SizedBox(height: 14),
          Text(en ? 'Season' : fa ? 'فصل' : 'موسم', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: season,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.wb_sunny_outlined),
            ),
            items: seasons.keys.map((s) => DropdownMenuItem(value: s, child: Text(_seasonName(s)))).toList(),
            onChanged: (v) { if (v != null) setState(() => season = v); },
          ),
          const SizedBox(height: 14),
          Text(en ? 'Crop' : fa ? 'محصول' : 'کرنیز فصل', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: crop,
            isExpanded: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.grass_outlined),
              labelText: en ? 'Select crop' : fa ? 'انتخاب محصول' : 'محصول وټاکئ',
            ),
            items: crops.keys.map((id) => DropdownMenuItem(value: id, child: Text(crops[id]![en ? 2 : fa ? 1 : 0]))).toList(),
            onChanged: (v) { if (v != null) setState(() => crop = v); },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.grass, color: Color(0xFF145A42)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(en ? '$cropName planting guidance' : fa ? 'راهنمای زمان کشت $cropName' : 'د $cropName د کرلو لارښوونه', style: const TextStyle(fontWeight: FontWeight.bold))),
                  ]),
                  const SizedBox(height: 10),
                  if (crop == 'Wheat' && season == 'Autumn')
                    Text(_wheatWindow(selected.zone), style: const TextStyle(fontSize: 15, height: 1.5))
                  else
                    Text(
                      en
                          ? 'A verified planting window for this crop and season has not yet been added. We will not show an unverified date.'
                          : fa
                              ? 'زمان معتبر کشت این محصول برای این فصل هنوز ثبت نشده است؛ تاریخ تأییدنشده نمایش داده نمی‌شود.'
                              : 'د دې فصل لپاره د دې فصل کرنیز وخت لا تر اوسه په باوري سرچینه نه دی تثبیت شوی؛ ناتایید شوې نېټه نه ښودل کېږي.',
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  if (crop == 'Wheat' && season == 'Autumn') ...[
                    const SizedBox(height: 12),
                    Text(
                    en
                        ? 'Official source: Afghanistan Ministry of Agriculture, General Directorate of Agricultural Extension, advisory dated 17 Aqrab 1402.'
                        : fa
                            ? 'منبع: وزارت زراعت، آبیاری و مالداری افغانستان، ریاست عمومی ترویج زراعتی، اطلاعیه ۱۷ عقرب ۱۴۰۲.'
                            : 'سرچینه: د افغانستان د کرنې، اوبولګولو او مالدارۍ وزارت، د کرنیز ترویج عمومي ریاست؛ د ۱۴۰۲ کال د عقرب ۱۷مه لارښوونه.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFFD4AF37)),
              title: Text(en ? 'Local conditions matter' : fa ? 'شرایط محلی مهم است' : 'ځايي شرایط مهم دي'),
              subtitle: Text(
                en
                    ? 'Sowing dates can shift with altitude, temperature, soil moisture, irrigation and yearly weather. District-level guidance and seed rates will be added only after source verification.'
                    : fa
                        ? 'زمان کشت با ارتفاع، دما، رطوبت خاک، آبیاری و وضعیت سالانه هوا تغییر می‌کند. راهنمای ولسوالی و مقدار تخم پس از بررسی منبع معتبر اضافه می‌شود.'
                        : 'د کرلو نېټه د ارتفاع، تودوخې، د خاورې لندبل، اوبو لګولو او کلنۍ هوا له بدلون سره بدلېږي. د ولسوالیو لارښوونې او د تخم اندازه به د باوري سرچینې تر تایید وروسته ورزیاتې شي.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
