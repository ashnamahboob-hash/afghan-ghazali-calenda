# افغان غزالي کلنډر | Afghan Ghazali Calendar

Flutter Android starter project for an offline-first Afghan calendar.

## Included in this first source-code version
- Afghan Solar Hijri month names in Pashto, Dari and English.
- Month grid with Saturday as the first weekday.
- Date selection and Gregorian date picker.
- Language selector and language-specific digits.
- Offline prayer-time estimate for six preset Afghan cities.
- Green and gold Material 3 theme.
- Calendar conversion unit tests.

## Important accuracy notice
This is a runnable first-version foundation, not yet a verified official Afghan calendar release.
The current solar year boundary is provisionally set to March 21, and leap years use a provisional 33-year cycle. Afghan official calendar dates can depend on the official equinox-based calendar. Before publishing, validate the calendar engine for multiple years (including leap years) against official Afghanistan calendar data and adjust `lib/services/afghan_calendar.dart`.

Prayer times are approximate offline solar calculations. They depend on the selected city coordinates, timezone, calculation angles and jurisprudential method. Sunrise is displayed separately and is not a prayer. Confirm the chosen Fajr/Isha angles and Asr method with a trusted Afghan religious authority or local mosque. The app currently uses Kabul time offset (+04:30) for the preset Afghan cities.

## Requirements
- Flutter SDK 3.22 or later
- Android Studio or VS Code with Flutter extension
- Android SDK

## Run
1. Extract the ZIP.
2. Open the project folder in Android Studio / VS Code.
3. Run `flutter pub get`.
4. Run `flutter test`.
5. Connect an Android phone with USB debugging enabled, or start an emulator.
6. Run `flutter run`.

## Build APK
```bash
flutter build apk --release
```
APK output:
`build/app/outputs/flutter-apk/app-release.apk`

## Build Play Store bundle
```bash
flutter build appbundle --release
```

## Android package name
The default Flutter package name can be changed with Android Studio's refactor tools before publishing. Choose a permanent reverse-domain ID, for example `com.yourcompany.afghanghazalicalendar`.

## Next recommended development tasks
1. Verify and replace provisional Afghan leap-year / New Year logic with official calendar data.
2. Add verified Hijri lunar dates and official holiday data, with update mechanism.
3. Add prayer-time calculation-method settings and location permissions if automatic location is desired.
4. Add local notifications and user reminders.
5. Add app icon, splash screen, accessibility and device-size testing.
6. Complete full Dari and English translations and RTL/LTR layout review.
