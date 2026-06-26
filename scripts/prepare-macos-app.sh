#!/bin/bash
set -euo pipefail

CONFIGURATION="${1:-debug}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_PATH="$(swift build --configuration "$CONFIGURATION" --show-bin-path)"
APP_PATH="$BIN_PATH/FlowerDoro.app"
EXECUTABLE_PATH="$BIN_PATH/FlowerDoroApp"
RESOURCE_BUNDLE_PATH="$BIN_PATH/FlowerDoro_FlowerDoro.bundle"
ICON_PATH="$ROOT_DIR/Assets/AppIcon/FlowerDoro.icns"

if [[ ! -x "$EXECUTABLE_PATH" ]]; then
  echo "Missing executable: $EXECUTABLE_PATH" >&2
  exit 1
fi

mkdir -p "$APP_PATH/Contents/MacOS" "$APP_PATH/Contents/Resources"
INFO_PLIST="$APP_PATH/Contents/Info.plist"

if [[ ! -f "$INFO_PLIST" ]]; then
  cat > "$INFO_PLIST" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict/>
</plist>
PLIST
fi

plist_set_string() {
  local key="$1"
  local value="$2"
  /usr/libexec/PlistBuddy -c "Set :$key $value" "$INFO_PLIST" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :$key string $value" "$INFO_PLIST" >/dev/null
}

plist_set_bool() {
  local key="$1"
  local value="$2"
  /usr/libexec/PlistBuddy -c "Set :$key $value" "$INFO_PLIST" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :$key bool $value" "$INFO_PLIST" >/dev/null
}

cp "$EXECUTABLE_PATH" "$APP_PATH/Contents/MacOS/FlowerDoro"
cp "$ICON_PATH" "$APP_PATH/Contents/Resources/FlowerDoro.icns"

if [[ -d "$RESOURCE_BUNDLE_PATH" ]]; then
  rm -rf "$APP_PATH/FlowerDoro_FlowerDoro.bundle"
  cp -R "$RESOURCE_BUNDLE_PATH" "$APP_PATH/FlowerDoro_FlowerDoro.bundle"
fi

plist_set_string CFBundleExecutable FlowerDoro
plist_set_string CFBundleIdentifier com.aquariues.flowerdoro.mac.preview
plist_set_string CFBundleName FlowerDoro
plist_set_string CFBundleDisplayName FlowerDoro
plist_set_string CFBundlePackageType APPL
plist_set_string CFBundleShortVersionString 0.1.0
plist_set_string CFBundleVersion 1
plist_set_string LSMinimumSystemVersion 14.0
plist_set_string CFBundleIconFile FlowerDoro
plist_set_bool NSHighResolutionCapable true

echo "$APP_PATH"
