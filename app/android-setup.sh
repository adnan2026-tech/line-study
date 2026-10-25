#!/usr/bin/env bash
# Adds permissions and sets the version number of the Android project.
set -euo pipefail
cd "$(dirname "$0")"
N="${1:-1}"
M=android/app/src/main/AndroidManifest.xml
INET='<uses-permission android:name="android.permission.INTERNET" />'
# Camera for recording; storage permission only for Android 10 and older (saving videos to Movies/MotionStudy)
grep -q 'android.permission.CAMERA' "$M" || sed -i "s#${INET}#${INET}\n    <uses-permission android:name=\"android.permission.CAMERA\" />\n    <uses-feature android:name=\"android.hardware.camera\" android:required=\"false\" />\n    <uses-permission android:name=\"android.permission.WRITE_EXTERNAL_STORAGE\" android:maxSdkVersion=\"29\" />\n    <uses-permission android:name=\"android.permission.READ_EXTERNAL_STORAGE\" android:maxSdkVersion=\"32\" />#" "$M"
grep -q 'requestLegacyExternalStorage' "$M" || sed -i 's#<application#<application android:requestLegacyExternalStorage="true"#' "$M"
grep -q 'android.permission.CAMERA' "$M"
grep -q 'WRITE_EXTERNAL_STORAGE' "$M"
G=android/app/build.gradle
sed -i -E "s/versionCode [0-9]+/versionCode $N/; s/versionName \"[^\"]*\"/versionName \"1.$N\"/" "$G"
grep -E "versionCode|versionName" "$G"
