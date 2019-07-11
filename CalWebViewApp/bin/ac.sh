#!/usr/bin/env bash

source "bin/log.sh"

set -e

if [ -z ${1} ]; then
  echo "Usage: ${0} device-set

Examples:

$ bin/ac.sh App-Center-Test-Cloud/latest-releases-ios
$ SERIES='DeviceAgent 2.0' bin/xtc.sh App-Center-Test-Cloud/latest-releases-ios

Responds to these env variables:

    SERIES: the Test Cloud series - defaults to master
    AC_TOKEN: appcenter token - defaults to token from TestCloudDev.keychain.
"

  exit 64
fi

hash appcenter 2>/dev/null || {
  error "appcenter cli is not installed."
  error ""
  error "$ brew update; brew install npm"
  error "$ npm install -g appcenter-cli"
  error ""
  error "Then try again."
  exit 1
}

info "Using $(appcenter --version)"

if [ "${AC_TOKEN}" = "" ]; then
  KEYCHAIN="${HOME}/.test-cloud-dev/TestCloudDev.keychain"

  if [ ! -e "${KEYCHAIN}" ]; then
    echo "Cannot find AppCenter token: there is no TestCloudDev.keychain"
    echo "  ${KEYCHAIN}"
    exit 1
  fi

  if [ ! -e "${HOME}/.test-cloud-dev/find-keychain-credential.sh" ]; then
    echo "Cannot find AppCenter token: no find-keychain-credential.sh script"
    echo "  ${HOME}/.test-cloud-dev/find-keychain-credential.sh"
    exit 1
  fi

  info "Fetching AppCenter token from TestCloudDev.keychain"
  AC_TOKEN=$("${HOME}/.test-cloud-dev/find-keychain-credential.sh" api-token)
fi

WORKSPACE="xtc-submit-calabash-linked"

if [ ! -e "${WORKSPACE}" ]; then
  error "Expected this directory to exist:"
  error "  ${WORKSPACE}"
  error "Did you forget to run 'make ipa-cal'?"
  exit 1
else
  info "Using existing workspace: ${WORKSPACE}"
fi

if [ "${SERIES}" = "" ]; then
  SERIES=master
fi

appcenter test run calabash \
  --app "App-Center-Test-Cloud/CalWebView-cal" \
  --devices "${1}" \
  --app-path "${WORKSPACE}/CalWebView-cal.ipa" \
  --test-series "${SERIES}" \
  --project-dir "${WORKSPACE}" \
  --config-path "cucumber.yml" \
  --token "${AC_TOKEN}" \
  --dsym-dir "${WORKSPACE}/CalWebView-cal.app.dSYM" \
  --async \
  --locale "en_US" \
  --disable-telemetry