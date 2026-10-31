# Build APK using only an Android phone

The APK is built on GitHub-hosted Linux, not on your phone.

1. Open https://github.com in Chrome and sign in or create a free account.
2. Create a new repository named `afghan-ghazali-calendar`. Choose Private if you want to keep the source private.
3. Upload the contents of this ZIP into the repository root. Include `.github/workflows/build-apk.yml`. If mobile upload hides dot-folders, turn on Chrome's Desktop site or create that file in GitHub's web editor at exactly `.github/workflows/build-apk.yml`.
4. Open the repository's Actions tab.
5. Select “Build Afghan Ghazali Calendar APK”.
6. Tap “Run workflow”.
7. When the run finishes successfully, open it and download the artifact named `Afghan-Ghazali-Calendar-APK`.
8. Extract that artifact ZIP and install `app-release.apk`. Android may ask permission to install apps from your browser or file manager.

If the workflow is not listed, check that `.github/workflows/build-apk.yml` exists in the repository and Actions are enabled.

This first version is a prototype. Verify Afghan solar calendar dates against official Afghan calendar data and prayer times against a trusted local timetable before relying on them.
