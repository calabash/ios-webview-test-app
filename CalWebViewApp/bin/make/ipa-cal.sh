#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/simctl.sh

ensure_valid_core_sim_service

banner "Preparing"

if [ $(gem list -i xcpretty) = "true" ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

info "Will pipe xcodebuild to: ${XC_PIPE}"

set -e -o pipefail

XC_TARGET="CalWebView-cal"
XC_PROJECT="ios-webview-test-app.xcodeproj"
XC_SCHEME="${XC_TARGET}"
XC_CONFIG=Debug
XC_BUILD_DIR="${PWD}/build/ipa-cal"

APP="${XC_TARGET}.app"
DSYM="${APP}.dSYM"
IPA="${XC_TARGET}.ipa"

INSTALL_DIR="Products/ipa-cal"
INSTALLED_APP="${INSTALL_DIR}/${APP}"
INSTALLED_DSYM="${INSTALL_DIR}/${DSYM}"
INSTALLED_IPA="${INSTALL_DIR}/${IPA}"

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

info "Prepared install directory ${INSTALL_DIR}"

BUILD_PRODUCTS_DIR="${XC_BUILD_DIR}/Build/Products/${XC_CONFIG}-iphoneos"
BUILD_PRODUCTS_APP="${BUILD_PRODUCTS_DIR}/${APP}"
BUILD_PRODUCTS_DSYM="${BUILD_PRODUCTS_DIR}/${DSYM}"

rm -rf "${BUILD_PRODUCTS_APP}"
rm -rf "${BUILD_PRODUCTS_DSYM}"

info "Prepared archive directory"

if [ "${PREPARE_XTC_ONLY}" != "1" ]; then
  rm -rf "${INSTALL_DIR}"
  mkdir -p "${INSTALL_DIR}"

  banner "Building ${IPA}"

  COMMAND_LINE_BUILD=1 xcrun xcodebuild \
    -SYMROOT="${XC_BUILD_DIR}" \
    -derivedDataPath "${XC_BUILD_DIR}" \
    -project "${XC_PROJECT}" \
    -scheme "${XC_TARGET}" \
    -configuration "${XC_CONFIG}" \
    -sdk iphoneos \
    ARCHS="armv7 armv7s arm64" \
    VALID_ARCHS="armv7 armv7s arm64" \
    ONLY_ACTIVE_ARCH=NO \
    build | $XC_PIPE

  EXIT_CODE=${PIPESTATUS[0]}

  if [ $EXIT_CODE != 0 ]; then
    error "Building ipa failed."
    exit $EXIT_CODE
  else
    info "Building ipa succeeded."
  fi

  banner "Installing"

  install_with_ditto "${BUILD_PRODUCTS_APP}" "${INSTALLED_APP}"

  PAYLOAD_DIR="${INSTALL_DIR}/Payload"
  mkdir -p "${PAYLOAD_DIR}"

  install_with_ditto "${INSTALLED_APP}" "${PAYLOAD_DIR}/${APP}"
  zip_with_ditto "${PAYLOAD_DIR}" "${INSTALLED_IPA}"
  zip_with_ditto "${INSTALLED_APP}" "${INSTALLED_APP}.zip"

  install_with_ditto "${BUILD_PRODUCTS_DSYM}" "${INSTALLED_DSYM}"

  install_with_ditto "${INSTALLED_DSYM}" "${INSTALL_DIR}/CalWebView-device.app.dSYM"
  install_with_ditto "${INSTALLED_APP}.zip" "${INSTALL_DIR}/CalWebView-device.app.zip"
  install_with_ditto "${INSTALLED_IPA}" "${INSTALL_DIR}/CalWebView-device.ipa"

  banner "Code Signing Details"

  DETAILS=`xcrun codesign --display --verbose=2 ${INSTALLED_APP} 2>&1`

  echo "$(tput setaf 4)$DETAILS$(tput sgr0)"
fi

banner "Preparing for XTC Submit"

XTC_DIR="xtc-submit-calabash-linked"
rm -rf "${XTC_DIR}"
mkdir -p "${XTC_DIR}"

ditto_or_exit features "${XTC_DIR}/features"
info "Copied features to ${XTC_DIR}/"

ditto_or_exit config/xtc-profiles.yml "${XTC_DIR}/cucumber.yml"
info "Copied config/xtc-profiles.yml to ${XTC_DIR}/"

ditto_or_exit "${INSTALLED_IPA}" "${XTC_DIR}/"
info "Copied ${IPA} to ${XTC_DIR}/"

ditto_or_exit "${INSTALLED_DSYM}" "${XTC_DIR}/${DSYM}"
info "Copied ${DSYM} to ${XTC_DIR}/"

rm -rf "${XTC_DIR}/.xtc"
if [ -d ".xtc" ]; then
  ditto_or_exit ".xtc" "${XTC_DIR}/.xtc"
  info "Copied .xtc to ${XTC_DIR}/.xtc"
else
  info "No .xtc directory; skipping copy"
fi

cat >"${XTC_DIR}/Gemfile" <<EOF
source "https://rubygems.org"

gem "calabash-cucumber"
gem "json", "1.8.6"
gem 'rspec', '~> 3.0'
gem "cucumber", "~> 2.0"
gem "xamarin-test-cloud", "~> 2.1"

EOF

info "Wrote ${XTC_DIR}/Gemfile with contents"
cat "${XTC_DIR}/Gemfile"

info "Done!"
