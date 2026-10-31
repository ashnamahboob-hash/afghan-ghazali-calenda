import 'package:flutter/material.dart';

class AgricultureScreen extends StatefulWidget {
  final String language;
  const AgricultureScreen({super.key, required this.language});

  @override
  State<AgricultureScreen> createState() => _AgricultureScreenState();
}

class _AgricultureScreenState extends State<AgricultureScreen> {
  String region = 'Central';
  String season = 'Spring';

  static const regions = <String, String>{
    'Central': 'مرکزي زون',
    'South': 'سوېلي زون',
    'East': 'ختیځ زون',
    'North': 'شمالي زون',
    'West': 'لوېدیځ زون',
    'Northeast': 'شمال ختیځ زون',
    'Highlands': 'لوړې غرنۍ سیمې',
  };

  static const seasons = <String, String>{
    'Spring': 'پسرلی',
    'Summer': 'اوړی',
    'Autumn': 'منی',
    'Winter': 'ژمی',
  };

  String get _title => widget.language == 'en'
      ? 'Agriculture calendar'
      : widget.language == 'fa'
          ? 'تقویم زراعتی افغانستان'
          : 'د افغانستان د کرنې کلیز';

  @override
  Widget build(BuildContext context) {
    final en = widget.language == 'en';
    final fa = widget.language == 'fa';
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
                Text(_title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  en ? 'Crop guidance by region and season' : fa ? 'راهنمای کشت بر اساس منطقه و فصل' : 'د سیمې او موسم له مخې د فصلونو لارښوونې',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(en ? 'Region' : fa ? 'منطقه' : 'سیمه', style: const TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            value: region,
            decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.map_outlined)),
            items: regions.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(en ? e.key : e.value))).toList(),
            onChanged: (v) { if (v != null) setState(() => region = v); },
          ),
          const SizedBox(height: 12),
          Text(en ? 'Season' : fa ? 'فصل' : 'موسم', style: const TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            value: season,
            decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.wb_sunny_outlined)),
            items: seasons.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(en ? e.key : fa ? e.value : e.value))).toList(),
            onChanged: (v) { if (v != null) setState(() => season = v); },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.info_outline, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(en ? 'Regional crop database' : fa ? 'بانک معلومات زراعتی منطقه‌ای' : 'د سیمو د کرنې معلوماتي زېرمه', style: const TextStyle(fontWeight: FontWeight.bold))),
                  ]),
                  const SizedBox(height: 10),
                  Text(
                    en
                        ? 'The region and season selectors are ready. Verified crop calendars, sowing windows, seed rates, irrigation and harvest guidance will be added from reliable Afghan agricultural sources before being presented as recommendations.'
                        : fa
                            ? 'انتخاب منطقه و فصل آماده است. زمان کشت، مقدار تخم، آبیاری و برداشت پس از بررسی منابع معتبر زراعتی افغانستان اضافه می‌شود.'
                            : 'د سیمې او موسم ټاکلو برخه چمتو ده. د کرلو وختونه، د تخم اندازه، اوبه لګول او د حاصل ټولولو لارښوونې به د افغانستان له باوري کرنیزو سرچینو تر څېړنې وروسته ورزیاتې شي.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    en ? 'Selected: ${regions[region]} · ${seasons[season]}' : 'ټاکل شوې سیمه: ${regions[region]} — ${seasons[season]}',
                    style: const TextStyle(color: Color(0xFF145A42), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined, color: Color(0xFF145A42)),
              title: Text(en ? 'Crop guides' : fa ? 'راهنمای محصولات' : 'د فصلونو لارښود'),
              subtitle: Text(en ? 'Planting · care · pests · harvest' : fa ? 'کشت · مراقبت · آفات · برداشت' : 'کرنه · پالنه · افتونه · حاصل'),
            ),
          ),
        ],
      ),
    );
  }
}
