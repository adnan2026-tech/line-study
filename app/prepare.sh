#!/usr/bin/env bash
# Copies everything the app needs into www/ so it works with no internet.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p www/mediapipe/wasm www/fonts www/lib
# Remove files that do not belong to this app
rm -f www/Index.html
cp node_modules/jspdf/dist/jspdf.umd.min.js node_modules/html2canvas/dist/html2canvas.min.js node_modules/exceljs/dist/exceljs.min.js www/lib/
cp node_modules/@mediapipe/tasks-vision/vision_bundle.mjs www/mediapipe/
cp node_modules/@mediapipe/tasks-vision/wasm/* www/mediapipe/wasm/
for f in barlow-condensed/files/barlow-condensed-latin-600-normal barlow-condensed/files/barlow-condensed-latin-700-normal \
         ibm-plex-sans/files/ibm-plex-sans-latin-400-normal ibm-plex-sans/files/ibm-plex-sans-latin-500-normal ibm-plex-sans/files/ibm-plex-sans-latin-600-normal \
         ibm-plex-mono/files/ibm-plex-mono-latin-400-normal ibm-plex-mono/files/ibm-plex-mono-latin-500-normal \
         noto-sans-bengali/files/noto-sans-bengali-bengali-400-normal noto-sans-bengali/files/noto-sans-bengali-bengali-600-normal noto-sans-bengali/files/noto-sans-bengali-bengali-700-normal; do
  cp "node_modules/@fontsource/$f.woff2" www/fonts/
done
if [ "${SKIP_MODEL:-0}" != "1" ]; then
  curl -fsSL -o www/mediapipe/hand_landmarker.task \
    https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task
  test "$(stat -c%s www/mediapipe/hand_landmarker.task)" -gt 3000000
fi
echo "Offline files ready:"; du -sh www
