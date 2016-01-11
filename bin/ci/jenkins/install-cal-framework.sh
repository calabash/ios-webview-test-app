#!/usr/bin/env bash

rm -rf calabash-ios-server
git clone https://github.com/calabash/calabash-ios-server

(cd calabash-ios-server; make framework)

cd CalWebViewApp
rm -rf calabash.framework
mv ../calabash-ios-server/calabash.framework ./

