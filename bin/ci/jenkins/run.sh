#!/usr/bin/env bash

set -e

# Install page.hmtl and iframe.html
IFRAME_SOURCE="CalWebViewApp/CalWebViewApp/iframe.html"
PAGE_SOURCE="CalWebViewApp/CalWebViewApp/page.html"

IFRAME_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/iframe.html"
PAGE_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/page.html"

cp "${IFRAME_SOURCE}" "${IFRAME_TARGET}"
cp "${PAGE_SOURCE}" "${PAGE_TARGET}"

bundle update

bin/ci/install-keychain.sh

# Not yet.
# bin/ci/jenkins/install-framework.sh

(cd CalWebViewApp; make clean)

bundle exec bin/ci/test-cloud.rb
bundle exec bin/ci/jenkins/cucumber.rb --tags ~@pending

