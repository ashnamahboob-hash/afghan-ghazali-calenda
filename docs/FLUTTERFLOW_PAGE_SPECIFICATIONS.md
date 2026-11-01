# FlutterFlow Page Specifications

## Global shell
- Persistent app title/brand and language control.
- Responsive navigation: mobile bottom bar + More destination; tablet/web navigation rail or side panel.
- Selected language controls translated strings, number formatting and directionality.
- All pages must implement loading, empty, error and normal states where data is asynchronous.

## Home Dashboard
**Components:** AppHeader, TodayTripleDateCard, MiniSolarCalendar, PrayerSummaryCard, QuickAccessGrid, DataStatusFooter.

**Actions:** open full calendar; select date; open prayer page; open population/province/agriculture pages; change language.

**Data:** current local date; solar conversion; civil Hijri conversion; selected city prayer calculation; approved summary indicators only.

## Calendar
**Components:** SolarMonthHeader, WeekdayHeader (Saturday first), SolarCalendarGrid, SelectedDayDetail.

**Actions:** previous/next Solar month; select date; return to today; open date detail.

**Rules:** month navigation is based on Solar Hijri month/year, not Gregorian month. Each day shows solar day prominently and Gregorian/Hijri dates in smaller text. If a month has 29/30/31 days, grid height must adapt. Use validated official solar calendar logic only.

## Prayer Times
**Components:** CityDropdown, AsrMethodSelector, CalculationMethodDetails, PrayerTimeList, VerificationNotice.

**Actions:** change city; switch Asr method; edit calculation angles only in advanced settings; refresh/recalculate.

**Rules:** default Asr factor is 2 (Hanafi). Factor 1 is Standard/Shafi'i. Sunrise is a solar event, not a prayer. Keep calculation assumptions visible.

## Population
**Components:** PopulationDatasetHeader, NationalKpiCards, ProvinceRankingChart, SexAgeBreakdown, UrbanRuralBreakdown, GeographyFilter, SourceMethodologyPanel.

**Actions:** select dataset/reference year; filter province/unit; change chart measure; export current filtered data where supported.

**Rules:** show estimates as estimates; show source/reference year/units/status with every chart. Hide a chart when its source measure is missing. Never turn missing markers into zero. Do not imply that all population records have official publisher provenance.

## Province & District Explorer
**Components:** ProvinceSearch, ProvinceList, ProvinceDetail, UnitSearch, UnitList, UnitDetail, VerificationStatus.

**Actions:** search by P-code or localized label; select province; filter units; open unit detail.

**Rules:** preserve P-code as key. Show administrative type and dataset membership. Explain the 401-draft / 457-population distinction.

## Agriculture
**Components:** ProvinceSelector, DistrictSearchSelector, SeasonSelector, CropSelector, VerifiedAdvisoryList, SourceDetails.

**Actions:** filter by geography, crop and season; open source details.

**Rules:** only show verified and currently valid advice by default. If no advisory exists, show a translated empty state. Never extrapolate province guidance to a district.

## Maps
**Components:** MapCanvas, LayerSelector, Legend, DataProvenancePanel.

**Actions:** select layer, province/unit, zoom to selection.

**Rules:** no production map until verified geometry is available. Label source/year/status and distinguish estimates from observed data.

## Reports
**Components:** ReportTypeSelector, FilterSummary, Preview, ExportActions.

**Actions:** export CSV/PDF for currently filtered records.

**Rules:** include source, reference year, units, methodology, filters and caveats in exported output.

## Settings
**Components:** LanguageSelector, ThemeModeSelector, CitySelector, PrayerMethodSettings, DataSourcesLink, AboutLink.

**Actions:** persist preferences; open sources and about.

## About
Show app purpose, version, developer/maintainer attribution supplied by owner, source policy, licences and accuracy disclaimers. Do not invent organizational endorsements.
