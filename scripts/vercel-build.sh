#!/usr/bin/env bash
set -euo pipefail

# Build the Flutter web app in Vercel's Linux build environment.
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /tmp/flutter-sdk
export PATH="/tmp/flutter-sdk/bin:$PATH"

flutter config --enable-web
flutter create --platforms=web --project-name afghan_ghazali_calendar .
flutter pub get
flutter build web --release --base-href /
