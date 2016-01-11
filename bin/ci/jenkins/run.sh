#!/usr/bin/env bash

bundle update

bin/ci/install-keychain.sh

# Not yet.
# bin/ci/jenkins/install-framework.sh

(cd CalWebViewApp; make clean)
bin/ci/make-ipa.sh
bundle exec bin/ci/jenkins/cucumber.rb

