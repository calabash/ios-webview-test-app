#!/bin/sh

(cd ~/calabash-ios-server;
make framework)

rm -rf ./calabash.framework
mv -f ~/calabash-ios-server/calabash.framework .

make app-cal
APP=./CalWebView-cal.app bundle exec calabash-ios console
