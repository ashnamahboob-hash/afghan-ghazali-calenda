# Administrative District Name Crosswalk Review

**Review date:** 2026-11-01  
**App branch:** `feature/modern-calendar-agriculture-prayer`  
**App reference:** `assets/data/afghanistan_admin_divisions_reference_draft.json`  
**External source:** [open-admin-data/afghanistan-administrative-divisions](https://github.com/open-admin-data/afghanistan-administrative-divisions) — `data/all-district.json`  
**Pinned external snapshot:** commit `9ceec68cc8f3eb66116b304f8ceaa6c7330d6266` (2026-09-08)  
**Declared licence:** CC-BY-4.0; preserve attribution for any reuse.

## Purpose and safety

This file records label differences between the app's current 401-unit draft reference and the pinned Open Admin Data snapshot. It is a review aid, not an instruction to replace names. P-codes and province-parent relationships were compared independently from labels. No application data, identifiers, slugs, or selector behavior were changed by this review.

## Comparison summary

| Check | Result |
|---|---:|
| External district rows | 401 |
| App district rows | 401 |
| Unique P-codes in external source | 401 |
| P-code set differences | 0 |
| Parent-province mismatches | 0 |
| Local-script label differences | 5 |
| English label differences | 112 |
| Records with at least one label difference | 113 |

## Review table

Legend: `Local differs` and `English differs` show which label fields differ. The app's current labels are shown first; the external source labels are shown second.

| P-code | Province | Local: app → source | English: app → source | Difference |
|---|---|---|---|---|
| AF1703 | Badakhshan (بدخشان) | ارغنچخواه → ارغنچخواه | Arghanchkhwah → Arghanj Khwah | English |
| AF1704 | Badakhshan (بدخشان) | یفتل سفلی → یفتل سفلی | Yaftal → Yaftal-e-Sufla | English |
| AF1724 | Badakhshan (بدخشان) | شکی → شکی | Shakai → Shaki | English |
| AF3101 | Badghis (بادغیس) | قلعه نو → قلعه نو | Qala-e Naw → Qala-e-Naw | English |
| AF3102 | Badghis (بادغیس) | آب کمری → آب کمری | Abkamari → Ab Kamari | English |
| AF3104 | Badghis (بادغیس) | قادیس → قادیس | Qades → Qadis | English |
| AF0906 | Baghlan (بغلان) | خنجان → خنجان | Khenjan → Khinjan | English |
| AF0908 | Baghlan (بغلان) | ده صلاح → ده صلاح | Dehsalah → Deh Salah | English |
| AF0909 | Baghlan (بغلان) | خواجه هجران → خواجه هجران | Jelgah → Khwaja Hejran | English |
| AF0910 | Baghlan (بغلان) | بورکه → بورکه | Borka → Burka | English |
| AF0911 | Baghlan (بغلان) | تاله وبرفک → تاله وبرفک | Tala-Wa-Barfak → Tala Wa Barfak | English |
| AF0914 | Baghlan (بغلان) | گذرگاه نور → گذرگاه نور | Guzargah-e-Noor → Guzargah-e-Nur | English |
| AF0915 | Baghlan (بغلان) | فرنگ وغارو → فرنگ وغارو | Fereng-o-Gharu → Fereng Wa Gharu | English |
| AF2107 | Balkh (بلخ) | شولگره → شولگره | Sholgarah → Sholgareh | English |
| AF2111 | Balkh (بلخ) | چار بولک → چار بولک | Chaharbolak → Char Bolak | English |
| AF2114 | Balkh (بلخ) | کشنده → کشنده | Kushenda → Keshendeh | English |
| AF2116 | Balkh (بلخ) | شهرک حیرتان → شهرک حیرتان | Chahi → Sharak-e-Hayratan | English |
| AF1002 | Bamyan (بامیان) | شیبر → شیبر | Shebar → Shibar | English |
| AF2402 | Daykundi (دایکندی) | شهرستان → شهرستان | Shahristan → Shahrestan | English |
| AF2404 | Daykundi (دایکندی) | خدیر → خدیر | Khader → Khadir | English |
| AF2406 | Daykundi (دایکندی) | میرامور → میرامور | Meramor → Miramor | English |
| AF2408 | Daykundi (دایکندی) | کجران → کجران | Kejran → Kajran | English |
| AF2409 | Daykundi (دایکندی) | پاتو → پاتو | Pato → Patoo | English |
| AF3302 | Farah (فراه) | پشترود → پشترود | Pushterod → Pushtrod | English |
| AF3303 | Farah (فراه) | خاک سفید → خاک سفید | Khak-e-Safid → Khak-e-Safed | English |
| AF3304 | Farah (فراه) | قلعه کاه → قلعه کاه | Qalah-e-Kah → Qala-e-Kah | English |
| AF3305 | Farah (فراه) | شیب کوه → شیب کوه | Shebkoh → Shibkoh | English |
| AF3311 | Farah (فراه) | پُرچمن → پُرچمن | Purchaman → Pur Chaman | English |
| AF2901 | Faryab (فاریاب) | میمنه → میمنه | Maimana → Maymana | English |
| AF2903 | Faryab (فاریاب) | خواجه سبزپوش → خواجه سبزپوش | Khwaja Sabzposh → Khwaja Sabz Posh | English |
| AF2907 | Faryab (فاریاب) | قیصار → قیصار | Qaisar → Qaysar | English |
| AF2908 | Faryab (فاریاب) | گرزیوان → گرزیوان | Garziwan → Garzewan | English |
| AF2911 | Faryab (فاریاب) | قرم قل → قرم قل | Qaramqul → Qaram Qul | English |
| AF1103 | Ghazni (غزنی) | خواجه عمری → خواجه عمری | Khwaja Omari → Khwaja Umari | English |
| AF1108 | Ghazni (غزنی) | زنه خان → زنه خان | Zana Khan → Zanakhan | English |
| AF1111 | Ghazni (غزنی) | قره باغ → قره باغ | Qarabagh → Qara Bagh | English |
| AF1114 | Ghazni (غزنی) | جاغوری → جاغوری | Jaghori → Jaghuri | English |
| AF2302 | Ghor (غور) | دو لینه → دو لینه | Do Layna → DoLayna | English |
| AF3003 | Helmand (هلمند) | ناوه بارکزائی → ناوه بارکزائی | Nawa → Nawa-e-Barakzaiy | English |
| AF3004 | Helmand (هلمند) | نهر سراج → نهر سراج | Gereshk → Nahr-e-Saraj | English |
| AF3005 | Helmand (هلمند) | واشیر → واشیر | Washir → Washer | English |
| AF3011 | Helmand (هلمند) | ریگ خان نشین → ریگ خان نشین | Khanshin → Reg-i-Khan Nishin | English |
| AF3013 | Helmand (هلمند) | دیشو → دیشو | Disho → Deh-e-Shu | English |
| AF3201 | Herat (هرات) | هرات → هرات | Herat → Hirat | English |
| AF3210 | Herat (هرات) | کُشک کهنه → کُشک کهنه | Kushk-e-Kohna → Kushk-e-Kuhna | English |
| AF3216 | Herat (هرات) | چشت شریف → چشت شریف | Chesht-e-Sharif → Chisht-e-Sharif | English |
| AF2801 | Jawzjan (جوزجان) | شبرغان → شبرغان | Sheberghan → Shiberghan | English |
| AF2804 | Jawzjan (جوزجان) | منگجک → منگجک | Mingajek → Mingajik | English |
| AF2806 | Jawzjan (جوزجان) | خمیاب → خمیاب | Kham Ab → Khamyab | English |
| AF2810 | Jawzjan (جوزجان) | قرقین → قرقین | Qarqen → Qarqin | English |
| AF2811 | Jawzjan (جوزجان) | درز آب → درز آب | Darz Ab → Darzab | English |
| AF0106 | Kabul (کابل) | شکردره → شکردره | Shakardara → Shakar Dara | English |
| AF0107 | Kabul (کابل) | موسهی → موسهی | Mosahi → Musahi | English |
| AF0109 | Kabul (کابل) | خاک جبار → خاک جبار | Khak-e-Jabar → Khak-e-Jabbar | English |
| AF0113 | Kabul (کابل) | استالف → استالف | Istalef → Estalef | English |
| AF0114 | Kabul (کابل) | قره باغ → قره باغ | Qarabagh → Qara Bagh | English |
| AF2706 | Kandahar (کندهار) | شاه ولیکوت → شاه ولی کوت | Shah Walikot → Shah Wali Kot | Local + English |
| AF2708 | Kandahar (کندهار) | ارغستان → ارغستان | Arghistan → Arghestan | English |
| AF2710 | Kandahar (کندهار) | میوند → میوند | Maiwand → Maywand | English |
| AF2712 | Kandahar (کندهار) | نیش → نیش | Neash → Nesh | English |
| AF2713 | Kandahar (کندهار) | میانشین → میانشین | Meyanishin → Miyanshin | English |
| AF2715 | Kandahar (کندهار) | معروف → معروف | Marof → Maruf | English |
| AF2716 | Kandahar (کندهار) | ریگ → ریگ ( شگه ) | Reg → Reg | Local |
| AF1402 | Khost (خوست) | مندوزائی → مندوزائی | Esmail Khel Aw Mandozayi → Mandozayi | English |
| AF1403 | Khost (خوست) | گربز → گربز | Gurbaz → Gurbuz | English |
| AF1405 | Khost (خوست) | موسی خیل → موسی خیل | Musakhel → Musa Khel | English |
| AF1406 | Khost (خوست) | نادرشاه کوت → نادرشاه کوت | Nadershahkot → Nadir Shah Kot | English |
| AF1407 | Khost (خوست) | صبری → صبری | Sabari Aw Yaqubi → Sabari | English |
| AF1408 | Khost (خوست) | تری زائی → تری زائی | Alisher Aw Terizi → Terezayi | English |
| AF1412 | Khost (خوست) | شمل → شمل | Shumul → Shamal | English |
| AF1413 | Khost (خوست) | جاجی میدان → جاجی میدان | Zazi Maydan → Jaji Maydan | English |
| AF1501 | Kunar (کونړ) | اسد آباد → اسد آباد | Asadabad → Asad Abad | English |
| AF1503 | Kunar (کونړ) | وته پور → وته پور | Watapor → Watapur | English |
| AF1505 | Kunar (کونړ) | سرکانی → سرکانی | Sarkani → Sar Kani | English |
| AF1507 | Kunar (کونړ) | دره پیچ → دره پیچ | Darah-e-Pech → Dara-e-Pech | English |
| AF1513 | Kunar (کونړ) | چپه دره → چپه دره | Chapa Darah → Chapa Dara | English |
| AF1514 | Kunar (کونړ) | نورگل → نورگل | Noorgal → Nurgal | English |
| AF1515 | Kunar (کونړ) | ناړی → ناړی | Narai → Nari | English |
| AF1907 | Kunduz (کندز) | قلعه ذال → قلعه ذال | Qala-e-zal → Qala-e-Zal | English |
| AF0702 | Laghman (لغمان) | قرغه ئی → قرغه ئی | Qarghayee → Qarghayi | English |
| AF0705 | Laghman (لغمان) | دولت شاه → دولت شاه | Dawlat Shah → Dawlatshah | English |
| AF0404 | Maidan Wardak (میدان وردگ) | چک → چک | Chak → Chak-e-Wardak | English |
| AF0405 | Maidan Wardak (میدان وردگ) | سید آباد → سید آباد | Sayedabad → Saydabad | English |
| AF0406 | Maidan Wardak (میدان وردگ) | دایمیرداد → دایمیرداد | Daimirdad → Daymirdad | English |
| AF0408 | Maidan Wardak (میدان وردگ) | جغتو → جغتو | Jaghato → Jaghatu | English |
| AF0611 | Nangarhar (ننگرهار) | پچیراگام → پچیراگام | Pachiragam → Pachir Wa Agam | English |
| AF0617 | Nangarhar (ننگرهار) | مهمند دره → مهمند دره | Momand Darah → Muhmand Dara | English |
| AF0618 | Nangarhar (ننگرهار) | لعل پور → لعل پور | Lalpura → Lalpur | English |
| AF3404 | Nimroz (نیمروز) | چاربرجک → چاربرجک | Chahar Burjak → Char Burjak | English |
| AF1604 | Nuristan (نورستان) | نورگرام → نورگرام | Nurgeram → Nurgaram | English |
| AF1605 | Nuristan (نورستان) | دو آب → دو آب | Dowab → Duab | English |
| AF1205 | Paktika (پکتیکا) | سرروضه (سرحوضه) → سرروضه (سرحوضه) | Sar Rawza → Sar Rawzah | English |
| AF1213 | Paktika (پکتیکا) | نیکه → نیکه | Neka → Nika | English |
| AF1216 | Paktika (پکتیکا) | دیله → دیله | Delah → Dila | English |
| AF1217 | Paktika (پکتیکا) | وازه خواه → وازه خواه | Wazakhwa → Wazakhah | English |
| AF1302 | Paktya (پکتیا) | احمد آبا → احمد آبا | Ahmad Abad → Ahmadaba | English |
| AF1305 | Paktya (پکتیا) | حّدران → حّدران | Waza Zadran → Zadran | English |
| AF1307 | Paktya (پکتیا) | علی خیل → علی خیل | Zazi → Jaji | English |
| AF1308 | Paktya (پکتیا) | لجه احمد خیل → لجه احمد خیل | Laj-e-Ahmadkhel → Lija Ahmad Khel | English |
| AF1311 | Paktya (پکتیا) | دند وپټان → دند وپټان | Dand-e-Patan → Dand Wa Patan | English |
| AF0803 | Panjsher (پنجشیر) | دره → دره | Darah → Dara | English |
| AF0804 | Panjsher (پنجشیر) | حصه اول → خنج (حصه اول) | Hesa-e-Awal → Khenj | Local + English |
| AF0805 | Panjsher (پنجشیر) | عُنابه → عنابه | Onaba → Anawa | Local + English |
| AF0806 | Panjsher (پنجشیر) | شتُل → شُتل | Shutol → Shutul | Local + English |
| AF1810 | Takhar (تخار) | رُستاق → رُستاق | Rustaq → Rostaq | English |
| AF1811 | Takhar (تخار) | اشکمش → اشکمش | Eshkamesh → Eshkmesh | English |
| AF1816 | Takhar (تخار) | چاه آب → چاه آب | Chah Ab → Chahab | English |
| AF1817 | Takhar (تخار) | ینگی قلعه → ینگی قلعه | Yangi Qalah → Yangi Qala | English |
| AF2503 | Uruzgan (ارزگان) | چوره → چوره | Chorah → Chora | English |
| AF2505 | Uruzgan (ارزگان) | خاص ارزگان → خاص ارزگان | Khas Urozgan → Khas Uruzgan | English |
| AF2606 | Zabul (زابل) | شاه جوی → شاه جوی | Shahjoy → Shah Joi | English |
| AF2610 | Zabul (زابل) | شملزائی → شملزائی | Shamolzai → Shamul Zayi | English |
| AF2611 | Zabul (زابل) | کاکړ → کاکړ | Khak-e-Afghan → Kakar | English |

## Interpretation

- Identical P-code sets and parent links support the use of this external snapshot as a secondary structural cross-check for the app's 401 draft entries.
- Label differences may reflect transliteration conventions, spelling variants, alternative locality labels, or source-specific editorial choices. A string difference alone does not establish which label is authoritative.
- Five records differ in the local-script field; 112 differ in English; four differ in both. The full list above is keyed by exact P-code.
- The external snapshot does not validate the separate 457-row population dataset or its 56 additional P-codes.
- The external repository's declared CC-BY-4.0 licence does not establish official OCHA/AGCHO status.

## Recommended handling

1. Keep the app's existing 401-unit reference unchanged pending human review against attributable primary sources.
2. Do not modify fixed P-code IDs, province parents, slugs, or district selector contents as part of a name-only review.
3. If a label is later approved for display, preserve the source label and provenance separately from the original draft label; document the reviewer, date, and reason.
4. Do not treat the Open Admin Data label as automatically preferred solely because it is newer or differs.
5. Keep the population CSV data and its 457 ADM2 records in a separate dataset; do not infer additional district selector entries from this crosswalk.

## Reproducibility

- External snapshot commit: `9ceec68cc8f3eb66116b304f8ceaa6c7330d6266`
- External file blob SHA: `d0dae4988a016f487b48bd8fe3726351ea574562`
- App reference blob SHA at review: `5334b4d9a54c97f3d88ad31a4677ac480d2fcb4b`
- Match key: exact district P-code (`id`).
- Compared fields: local label, English label, and parent province P-code.
- No normalization, transliteration, fuzzy matching, or automatic correction was used.
