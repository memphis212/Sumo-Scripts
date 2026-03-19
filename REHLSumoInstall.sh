#!/usr/bin/env bash
set -euo pipefail

# Sumo Logic Installed Collector installer for RPM-based systems
#   sudo ./install_sumo_rpm.sh
# Usage:
# To get the install token go to service.sumologic.com then administration then installation tokens. To decode the token "echo 'TOKEN_HERE' | base64 -d"
#the decoded token will be before the https://
# Before running, update DECODED_TOKEN_HERE.

SUMO_RPM_URL="https://collectors.sumologic.com/rest/download/rpm/64"
SUMO_RPM_PATH="/tmp/SumoCollector.rpm"
SUMO_INSTALL_DIR="/opt/SumoCollector"
SUMO_CONFIG_DIR="${SUMO_INSTALL_DIR}/config"
SUMO_USER_PROPERTIES="${SUMO_CONFIG_DIR}/user.properties"

# Set these from your decoded installation token output
TOKEN_VALUE="DECODED_TOKEN_HERE"
URL_VALUE="https://collectors.sumologic.com"

# Optional collector name. Hostname is a good default for client rollouts.
COLLECTOR_NAME="$(hostname)"

echo "[1/4] Downloading Sumo Collector RPM..."
curl -fL -o "${SUMO_RPM_PATH}" "${SUMO_RPM_URL}"

echo "[2/4] Installing package..."
rpm -Uvh "${SUMO_RPM_PATH}"

echo "[3/4] Writing ${SUMO_USER_PROPERTIES} ..."
install -d -m 0750 "${SUMO_CONFIG_DIR}"

cat > "${SUMO_USER_PROPERTIES}" <<EOF
name=${COLLECTOR_NAME}
url=${URL_VALUE}
token=${TOKEN_VALUE}
EOF

# Tighten permissions
chmod 640 "${SUMO_USER_PROPERTIES}"

echo "[4/4] Restarting collector service..."
systemctl enable collector
systemctl restart collector

echo
echo "Done."
echo "Collector name: ${COLLECTOR_NAME}"
