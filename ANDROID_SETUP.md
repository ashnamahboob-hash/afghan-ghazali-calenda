# Android setup notes

This source package is a Flutter project source tree. It does not contain a compiled APK because the Flutter/Android build toolchain is not available in this file-generation environment.

Recommended Android configuration:
- Minimum Android SDK: 23 (Android 6.0), subject to Flutter version support.
- Target SDK: current Play Store requirement at release time.
- App label: افغان غزالي کلنډر
- App ID: choose a permanent reverse-domain application ID before first public release.

To generate platform scaffolding if the `android/` directory is absent:
```bash
flutter create --platforms=android .
```
Then run:
```bash
flutter pub get
flutter test
flutter build apk --release
```
