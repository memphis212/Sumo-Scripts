# Sumo Logic Collector Install Scripts

## Overview

This repository provides simple, self-contained scripts to install and register the Sumo Logic Installed Collector across platforms:

* Linux (Debian/Ubuntu)
* Linux (RHEL/Rocky/Alma/CentOS)
* Windows
* macOS

Each script:

* downloads the correct installer
* installs the collector
* applies the installation token
* starts the collector service

Sources are NOT configured by these scripts. Add them later in the Sumo Logic UI.

## Included Scripts

* sumo_deb_install.sh      (Debian / Ubuntu)
* sumo_rpm_install.sh      (RHEL / Rocky / Alma / CentOS)
* sumo_windows_install.ps1 (Windows)
* sumo_macos_install.sh    (macOS)

## Token Handling

There are two different token behaviors depending on platform:

Linux (DEB / RPM)

* Uses decoded token
* Requires writing user.properties

Windows and macOS

* Use raw installation token directly
* Passed to installer at runtime

## Linux Configuration (DEB/RPM)

Scripts write:

/opt/SumoCollector/config/user.properties

Format:

name=<hostname>
url=[https://collectors.sumologic.com](https://collectors.sumologic.com)
token=<decoded_token>

Notes:

* Token must be decoded beforehand
* URL is typically [https://collectors.sumologic.com](https://collectors.sumologic.com)
* Parameters are case-sensitive

## Windows Configuration

Token is defined inside the script:

$SUMO_TOKEN = "PASTE_TOKEN_HERE"

Used during install:

-Vsumo.token_and_url=$SUMO_TOKEN

No decoding required.

## macOS Configuration

Token is defined inside the script:

SUMO_TOKEN="PASTE_TOKEN_HERE"

Used during install:

-Vsumo.token_and_url="$SUMO_TOKEN"

No decoding required.

## Usage

Linux (Debian/Ubuntu):

sudo ./sumo_deb_install.sh

Linux (RHEL/Rocky):

sudo ./sumo_rpm_install.sh

Windows:

powershell -ExecutionPolicy Bypass -File .\sumo_windows_install.ps1

macOS:

chmod +x sumo_macos_install.sh
sudo ./sumo_macos_install.sh

## Verification

Linux:

systemctl status collector --no-pager -l

Windows:

Get-Service sumo-collector

macOS:

ps aux | grep -i sumo

After install, confirm the collector appears in the Sumo Logic UI.

## What These Scripts Do Not Do

* Configure log sources
* Manage upgrades
* Handle proxies
* Secure token storage beyond script usage

## Recommended Improvements

* Add argument support for token instead of editing scripts
* Add logging output to file
* Add proxy support
* Add auto-detection for Linux package type

## Security Notes

* Do NOT commit real tokens to public repositories
* Treat tokens as credentials
* Use client-specific copies of scripts when needed

## End

These scripts are intended for fast, repeatable deployments across environments with minimal dependencies.
