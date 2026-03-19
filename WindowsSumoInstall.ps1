$ErrorActionPreference = "Stop"

# ===== CONFIG =====
$SUMO_TOKEN = "PASTE_TOKEN_HERE"
# ==================

if (-not $SUMO_TOKEN) {
    throw "SUMO_TOKEN is not set"
}

$downloadPath = "$env:TEMP\SumoCollector.exe"

Write-Host "[1/3] Downloading installer..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://collectors.sumologic.com/rest/download/win64" -OutFile $downloadPath

Write-Host "[2/3] Installing collector..."
Start-Process -FilePath $downloadPath `
    -ArgumentList "-q","-console","-Vsumo.token_and_url=$SUMO_TOKEN" `
    -Wait `
    -NoNewWindow

Write-Host "[3/3] Verifying service..."
Get-Service sumo-collector

Write-Host "Done."