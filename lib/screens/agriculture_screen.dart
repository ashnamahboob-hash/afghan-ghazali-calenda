import 'package:flutter/material.dart';
import '../services/administrative_reference.dart';

class AgricultureScreen extends StatefulWidget {
  final String language;
  const AgricultureScreen({super.key, required this.language});

  @override
  State<AgricultureScreen> createState() => _AgricultureScreenState();
}

class _AgricultureScreenState extends State<AgricultureScreen> {
  String province = 'AF27';
  String season = 'Autumn';
  String crop = 'Wheat';
  String? district = 'AF2701';
  late final Future<AdministrativeReference> referenceFuture;

  @override
  void initState() {
    super.initState();
    referenceFuture = AdministrativeReference.load();
  }

  String _districtName(AdministrativeDistrict item) =>
      en ? item.englishName : item.localName;

  String _provinceName(AdministrativeProvince item) =>
      en ? item.englishName : item.localName;

  static const crops = <String, List<String>>{
    'Wheat': ['غنم', 'گندم', 'Wheat'],
    'Rice': ['وریجې', 'برنج', 'Rice'],
    'Maize': ['جوار', 'ذرت', 'Maize'],
    'Barley': ['وربشې', 'جو', 'Barley'],
  };

  String get cropName => crops[crop]![en ? 2 : fa ? 1 : 0];

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

  String _seasonName(String id) => en ? id : seasons[id]![fa ? 1 : 0];



  @override
  Widget build(BuildContext context) {
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
          FutureBuilder<AdministrativeReference>(
            future: referenceFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  en
                      ? 'Could not load the administrative reference.'
                      : fa
                          ? 'بارگذاری فهرست اداری ناموفق بود.'
                          : 'د اداري معلوماتو لېست نه شو لوډ کېدای.',
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final reference = snapshot.data!;
              final selectedProvince = reference.provinces.firstWhere(
                (item) => item.id == province,
                orElse: () => reference.provinces.first,
              );
              final selectedDistrict = selectedProvince.districts.any(
                (item) => item.id == district,
              )
                  ? district
                  : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    en ? 'Province' : fa ? 'ولایت' : 'ولایت',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedProvince.id,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      labelText: en
                          ? 'Select province'
                          : fa
                              ? 'انتخاب ولایت'
                              : 'ولایت وټاکئ',
                    ),
                    items: reference.provinces
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(_provinceName(item)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          province = value;
                          district = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    en ? 'District' : fa ? 'ولسوالی' : 'ولسوالۍ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.map_outlined),
                      labelText: en
                          ? 'Select district'
                          : fa
                              ? 'انتخاب ولسوالی'
                              : 'ولسوالۍ وټاکئ',
                    ),
                    items: selectedProvince.districts
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(_districtName(item)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => district = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            en
                                ? 'Preview reference only: 34 provinces and 401 district entries. Names and some administrative relationships are still under source review; do not treat this list as an officially certified gazetteer.'
                                : fa
                                    ? 'این فهرست پیش‌نویس است: ۳۴ ولایت و ۴۰۱ ولسوالی. نام‌ها و برخی روابط اداری هنوز بررسی منبع می‌شوند و نباید مرجع رسمی و تأییدشده تلقی شوند.'
                                    : 'دا د ازمایښتي معلوماتو لېست دی: ۳۴ ولایتونه او ۴۰۱ ولسوالۍ. نومونه او ځینې اداري اړیکې لا د سرچینو له مخې تر ارزونې لاندې دي؛ د رسمي تایید شوي نوملړ په توګه یې مه کاروئ.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
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
                  Text(
                    en
                        ? 'No verified advisory is available for this crop, province and season yet. Unverified dates are intentionally hidden.'
                        : fa
                            ? 'برای این محصول، ولایت و فصل هنوز رهنمود زراعتی تأییدشده ثبت نشده است؛ تاریخ تأییدنشده نمایش داده نمی‌شود.'
                            : 'د دې محصول، ولایت او موسم لپاره لا تایید شوې کرنیزه لارښوونه نشته؛ ناتایید شوې نېټې قصداً نه ښودل کېږي.',
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
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
