#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh

if [ ! -x "$(command -v greadlink)" ]; then
  error "This script requires greadlink which can be installed with homebrew"
  error "$ brew update"
  error "$ brew install coreutils"
fi

INSTALL_DIR="$(greadlink -f ../../../xtc/xamarin/test-cloud-test-apps/uitest-test-apps/iOS)"

if [ ! -d $INSTALL_DIR ]; then
  error "Expected the test-cloud-test-apps repo to be installed here:"
  error "  $INSTALL_DIR"
  exit 1
fi

make app-cal
make ipa-cal

banner "Installing to UITest Apps"

install_with_ditto \
  "Products/app-cal/CalWebView-sim.app.zip" \
  "${INSTALL_DIR}/CalWebView-sim.app.zip"

install_with_ditto \
  "Products/app-cal/CalWebView-sim.app.dSYM" \
  "${INSTALL_DIR}/CalWebView-sim.app.dSYM"

install_with_ditto \
  "Products/ipa-cal/CalWebView-device.app.dSYM" \
  "${INSTALL_DIR}/CalWebView-device.app.dSYM"

install_with_ditto \
  "Products/ipa-cal/CalWebView-device.app.zip" \
  "${INSTALL_DIR}/CalWebView-device.app.zip"

install_with_ditto \
  "Products/ipa-cal/CalWebView-device.ipa" \
  "${INSTALL_DIR}/CalWebView-device.ipa"
