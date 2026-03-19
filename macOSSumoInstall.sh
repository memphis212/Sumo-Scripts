#!/usr/bin/env bash
set -euo pipefail

# ===== CONFIG =====
SUMO_TOKEN="PASTE_TOKEN_HERE"
# ==================

if [[ "$SUMO_TOKEN" == "PASTE_TOKEN_HERE" ]]; then
  echo "You must set the token before running the script"
  exit 1
fi

DMG_PATH="/tmp/SumoCollector.dmg"
MOUNT_POINT="/Volumes/SumoCollector"
APP_PATH="/Volumes/SumoCollector/Sumo Logic Collector Installer.app/Contents/MacOS"

echo "[1/4] Downloading installer..."
curl -fL -o "$DMG_PATH" "https://collectors.sumologic.com/rest/download/mac"

echo "[2/4] Mounting DMG..."
hdiutil attach "$DMG_PATH" -nobrowse

echo "[3/4] Installing collector..."
cd "$APP_PATH"
sudo ./JavaApplicationStub -q -Vsumo.token_and_url="$SUMO_TOKEN"

echo "[4/4] Unmounting..."
hdiutil detach "$MOUNT_POINT" || true

echo "Done."