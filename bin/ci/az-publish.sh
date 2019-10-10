#!/usr/bin/env bash

set -eo pipefail

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
# $3 => CONTAINER NAME
function azupload {
  az storage blob upload \
    --container-name "${3}" \
    --file "${1}" \
    --name "${2}"
  echo "${1} artifact uploaded with name ${2}"
}

if [ -e ./.azure-credentials ]; then
  source ./.azure-credentials
fi

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

if [ "${BUILD_SOURCESDIRECTORY}" != "" ]; then
  WORKING_DIR="${BUILD_SOURCESDIRECTORY}"
else
  WORKING_DIR="."
fi

PRODUCT_DIR="${WORKING_DIR}/CalWebViewApp/Products"
APP_PRODUCT_DIR="${PRODUCT_DIR}/app-cal"
IPA_PRODUCT_DIR="${PRODUCT_DIR}/ipa-cal"
INFO_PLIST="${APP_PRODUCT_DIR}/CalWebView-cal.app/Info.plist"

# Evaluate CalWebViewApp version (from Info.plist)
VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" ${INFO_PLIST})

# Evaluate the Xcode version used to build artifacts
XC_VERSION=$(/usr/libexec/PlistBuddy -c "Print :DTXcode" ${INFO_PLIST})

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
# We don't need to use AdHoc when executing locally
if [[ "${GIT_BRANCH}" =~ "tag/" && -e ./.azure-credentials ]]; then
  BUILD_ID="CalWebView-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}"
else
  BUILD_ID="CalWebView-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}-AdHoc"
fi

# Simulators
SIM_CONTAINER_NAME="ios-simulator-test-apps"

# Upload `app-cal/CalWebViewApp.app` (zipped)
SIM_APP_ZIP="${APP_PRODUCT_DIR}/CalWebView-sim.app.zip"
SIM_APP_NAME="${BUILD_ID}.app.zip"
azupload "${SIM_APP_ZIP}" "${SIM_APP_NAME}" "${SIM_CONTAINER_NAME}"

# Upload `app-cal/CalWebViewApp.app.dSYM` (zipped)
SIM_APP_DSYM_ZIP="${APP_PRODUCT_DIR}/CalWebView-cal.app.dSYM.zip"
zip_with_ditto "${APP_PRODUCT_DIR}/CalWebView-cal.app.dSYM" "${SIM_APP_DSYM_ZIP}"
SIM_APP_DSYM_NAME="${BUILD_ID}.app.dSYM.zip"
azupload "${SIM_APP_DSYM_ZIP}" "${SIM_APP_DSYM_NAME}" "${SIM_CONTAINER_NAME}"

# ARM
ARM_CONTAINER_NAME="ios-arm-test-apps"

# Upload `ipa-cal/CalWebViewApp.ipa`
ARM_IPA="${IPA_PRODUCT_DIR}/CalWebView-cal.ipa"
ARM_IPA_NAME="${BUILD_ID}.ipa"
azupload "${ARM_IPA}" "${ARM_IPA_NAME}" "${ARM_CONTAINER_NAME}"

# Upload `ipa-cal/CalWebViewApp_ipa.app` (zipped)
ARM_APP_ZIP="${IPA_PRODUCT_DIR}/CalWebView-cal.app.zip"
ARM_APP_NAME="${BUILD_ID}.app.zip"
azupload "${ARM_APP_ZIP}" "${ARM_APP_NAME}" "${ARM_CONTAINER_NAME}"

# Upload `ipa-cal/CalWebViewApp.app.dSYM` (zipped)
ARM_APP_DSYM_ZIP="${IPA_PRODUCT_DIR}/CalWebView-cal.app.dSYM.zip"
zip_with_ditto "${IPA_PRODUCT_DIR}/CalWebView-cal.app.dSYM" "${ARM_APP_DSYM_ZIP}"
ARM_APP_DSYM_NAME="${BUILD_ID}.app.dSYM.zip"
azupload "${ARM_APP_DSYM_ZIP}" "${ARM_APP_DSYM_NAME}" "${ARM_CONTAINER_NAME}"
