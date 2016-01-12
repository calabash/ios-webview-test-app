#!/usr/bin/env bash

# cucumber/.env must exist or "make ipa-cal" will not stage for submit
DOTENV="CalWebViewApp/.env"

if [ -n "${JENKINS_HOME}" ] || [ -n "${TRAVIS}" ]; then
  # Write a new .env for every run.
  rm -rf "${DOTENV}"
fi

bin/ci/install-keychain.sh

CODE_SIGN_DIR="${HOME}/.calabash/calabash-codesign"
KEYCHAIN="${CODE_SIGN_DIR}/ios/Calabash.keychain"

if [ ! -e "${DOTENV}" ]; then
  STAGING="${PWD}/CalWebViewApp/xtc-submit-calabash-linked"
  echo "XTC_STAGING_DIR=\"${STAGING}\"" > "${DOTENV}"
  echo "IPA=\"${STAGING}/CalWebView-cal.ipa\"" >> "${DOTENV}"
  echo "XTC_OTHER_GEMS_FILE=config/xtc-other-gems.rb" >> "${DOTENV}"
  echo "XTC_SERIES=ci-master" >> "${DOTENV}"
  echo "XTC_DSYM=\"${STAGING}/CalWebView-cal.app.dSYM\"" >> "${DOTENV}"
  echo "XTC_WAIT_FOR_RESULTS=0" >> "${DOTENV}"
  echo "XTC_LOCALE=en_US" >> "${DOTENV}"
  echo "XTC_ACCOUNT=calabash-ios-ci" >> "${DOTENV}"
  echo "XTC_USER=joshua.moody@xamarin.com" >> "${DOTENV}"
fi

OUT=`xcrun security find-identity -p codesigning -v "${KEYCHAIN}"`
IDENTITY=`echo $OUT | grep -E -o "iPhone Developer: Karl Krukow \([0-9A-Z]{10}\)" | tr -d '\n'`
(cd CalWebViewApp && CODE_SIGN_IDENTITY="${IDENTITY}" make ipa-cal)

