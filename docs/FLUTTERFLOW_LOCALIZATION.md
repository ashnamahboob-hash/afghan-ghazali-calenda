# FlutterFlow Localization and RTL/LTR Rules

## Supported locales
- Pashto: `ps` — default, RTL.
- Dari: `fa` — RTL.
- English: `en` — LTR.

The owner reports that all three languages have been configured in the FlutterFlow project. Verify locale codes and default locale in the actual project before wiring page actions.

## Directionality
- Pashto and Dari pages must use RTL alignment and reading order.
- English pages must use LTR alignment and reading order.
- Icons that imply direction (back/forward/chevrons) must mirror where appropriate.
- Numeric tables and P-codes should remain legible; use explicit LTR spans for codes when needed.
- Search fields must support mixed-script input and P-code entry.

## Translation requirements
- Translate every button, label, tooltip, empty/error/loading state, chart title, table heading, accessibility label and disclaimer.
- Do not translate stable P-codes, dataset IDs, crop IDs or source organization names.
- Use the official Afghan Pashto solar month names in Pashto:
  وری، غویی، غبرګولی، چنګاښ، زمری، وږی، تله، لړم، لیندۍ، مرغومی، سلواغه، کب.
- Dari month labels should use the Afghan Solar Hijri convention configured for the app.
- English month labels should be consistent and documented.
- Number digit style should be consistent within each locale; provide a preference only if product requirements later call for it.

## Font and layout QA
Choose a font available in FlutterFlow that supports Pashto and Dari glyph shaping. Test connected letters, diacritics, numerals, line wrapping and mixed Latin/Arabic-script strings on Android, iOS and web. Do not assume that a font merely displaying Arabic glyphs guarantees correct Pashto typography.

## Required localization checks
- No untranslated key appears in any supported locale.
- RTL screens have no clipped trailing controls or reversed navigation errors.
- English LTR screens remain correctly aligned.
- Dates, numbers, chart legends, P-codes and exported reports are localized consistently.
