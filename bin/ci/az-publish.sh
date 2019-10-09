#!/usr/bin/env bash

set -eo pipefail

function xcode_version {
  xcrun xcodebuild -version | \
    grep -E "(\d+\.\d+(\.\d+)?)" | cut -f2- -d" " | \
    tr -d "\n"
}

function info {
  if [ "${TERM}" = "dumb" ]; then
    echo "INFO: $1"
  else
    echo "$(tput setaf 2)INFO: $1$(tput sgr0)"
  fi
}

function zip_with_ditto {
  xcrun ditto \
  -ck --rsrc --sequesterRsrc --keepParent \
  "${1}" \
  "${2}"
  info "Installed ${2}"
}

# $1 => SOURCE PATH
# $2 => TARGET NAME
function azupload {
  az storage blob upload \
    --container-name test-apps \
    --file "${1}" \
    --name "${2}"
  echo "${1} artifact uploaded with name ${2}"
}

# Pipeline Variables are set through the AzDevOps UI
# See also the ./azure-pipelines.yml
if [[ -z "${AZURE_STORAGE_ACCOUNT}" ]]; then
  echo "AZURE_STORAGE_ACCOUNT is required"
  exit 1
fi

if [[ -z "${AZURE_STORAGE_KEY}" ]]; then
  echo "AZURE_STORAGE_KEY is required"
  exit 1
fi

if [[ -z "${AZURE_STORAGE_CONNECTION_STRING}" ]]; then
  echo "AZURE_STORAGE_CONNECTION_STRING is required"
  exit 1
fi

# Evaluate git-sha value
GIT_SHA=$(git rev-parse --verify HEAD | tr -d '\n')

# Evaluate CalWebViewApp version (from Info.plist)
VERSION=$(plutil -p CalWebViewApp/Products/app-cal/CalWebView-cal.app/Info.plist | grep CFBundleShortVersionString | grep -o '"[[:digit:].]*"' | sed 's/"//g')

# Evaluate the Xcode version used to build artifacts
XC_VERSION=$(xcode_version)

az --version

WORKING_DIR="${BUILD_SOURCESDIRECTORY}"

# Upload `CalWebViewApp.app` (zipped)
APP_ZIP="${WORKING_DIR}/CalWebViewApp/Products/app-cal/CalWebView-cal.app.zip"
zip_with_ditto "${WORKING_DIR}/CalWebViewApp/Products/app-cal/CalWebView-cal.app" "${APP_ZIP}"
APP_NAME="CalWebView-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app.zip"
azupload "${APP_ZIP}" "${APP_NAME}"

# Upload `CalWebViewApp.app.dSYM` (zipped)
APP_DSYM_ZIP="${WORKING_DIR}/CalWebViewApp/Products/app-cal/CalWebView-cal.app.dSYM.zip"
zip_with_ditto "${WORKING_DIR}/CalWebViewApp/Products/app-cal/CalWebView-cal.app.dSYM" "${APP_DSYM_ZIP}"
APP_DSYM_NAME="CalWebView-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app.dSYM.zip"
azupload "${APP_DSYM_ZIP}" "${APP_DSYM_NAME}"

# Upload `CalWebViewApp.ipa`
IPA="${WORKING_DIR}/CalWebViewApp/Products/ipa-cal/CalWebView-cal.ipa"
IPA_NAME="CalWebView-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa"
azupload "${IPA}" "${IPA_NAME}"

# Upload `CalWebViewApp.ipa.dSYM` (zipped)
IPA_DSYM_ZIP="${WORKING_DIR}/CalWebViewApp/Products/ipa-cal/CalWebView-cal.app.dSYM.zip"
zip_with_ditto "${WORKING_DIR}/CalWebViewApp/Products/ipa-cal/CalWebView-cal.app.dSYM" "${IPA_DSYM_ZIP}"
IPA_DSYM_NAME="CalWebView-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa.dSYM.zip"
azupload "${IPA_DSYM_ZIP}" "${IPA_DSYM_NAME}"
