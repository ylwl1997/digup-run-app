#!/bin/bash
# Builds an unsigned Digup Run DMG for CI (GitHub Actions macOS runner).
# Uses ad-hoc signing via ./build.sh (no Developer ID / notarization).
# For signed+notarized releases on a real Mac: SIGN_ID=… NOTARY_PROFILE=… scripts/release.sh
#   scripts/package-macos-ci.sh  →  build.noindex/release/DigupRun-<version>-macos-arm64.dmg
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ "$(uname -s)" != Darwin ]]; then
  echo "package-macos-ci.sh must run on macOS" >&2
  exit 1
fi

./build.sh

VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" Resources/Info.plist)
APP=build.noindex/DigupRun.app
OUT=build.noindex/release
STAGE="$OUT/dmg"
DMG="$OUT/DigupRun-${VERSION}-macos-arm64.dmg"

rm -rf "$OUT"
mkdir -p "$STAGE"
ditto "$APP" "$STAGE/DigupRun.app"
ln -s /Applications "$STAGE/Applications"
hdiutil create -quiet -volname "Digup Run" -srcfolder "$STAGE" -fs HFS+ -format ULFO -ov "$DMG"
rm -rf "$STAGE"
ls -la "$DMG"
echo "Built unsigned CI DMG: $DMG"
