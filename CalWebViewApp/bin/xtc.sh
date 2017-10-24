#!/usr/bin/env bash

set -e

source bin/log.sh

#gem uninstall -Vax --force --no-abort-on-dependent run_loop
#(cd ../../run-loop && rake install)

#gem uninstall -Vax --force --no-abort-on-dependent calabash-cucumber
#(cd ../../calabash-ios/calabash-cucumber && rake install)

make ipa-cal

cd xtc-submit-calabash-linked
bundle update

rm -rf .xtc
mkdir .xtc
echo 87c0333d165301c018779c35abb418ac9e6ac96d > .xtc/device-agent-sha

if [ "${SERIES}" = "" ]; then
  SERIES=master
fi

if [ "${1}" = "" ]; then
  error "Usage: ${0} [device-set]"
  exit 1
fi

PIPELINE="pipeline:update-to-DeviceAgent-1.2.1"
#  --include .xtc \
#  --test-parameters "${PIPELINE}"

bundle exec test-cloud submit \
  CalWebView-cal.ipa \
  d2e62be879f95a833a63b712cdda5885 \
  --devices "${1}" \
  --series "${SERIES}" \
  --app-name "CalWebView-cal" \
  --user joshua.moody@xamarin.com \
  --dsym-file CalWebView-cal.app.dSYM \
  --config cucumber.yml \
  --profile default
