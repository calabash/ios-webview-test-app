#!/usr/bin/env ruby

require 'fileutils'

cal_app = File.expand_path('./CalWebView-cal.app')
cal_ipa = File.expand_path('./xtc-staging/CalWebView-cal.ipa')
app = File.expand_path('./CalWebView.app')
ipa = File.expand_path('./CalWebView.ipa')

# calabash-ios
rspec_resources_dir = File.expand_path('~/git/calabash-ios/calabash-cucumber/spec/resources')
FileUtils.cp_r(app, rspec_resources_dir)

dylib_dir = File.expand_path('~/git/calabash-ios/calabash-cucumber/test/dylib')
FileUtils.cp_r(app, dylib_dir)

xtc_dir = File.expand_path('~/git/calabash-ios/calabash-cucumber/test/xtc')
FileUtils.cp_r(cal_ipa, xtc_dir)

# run-loop
rspec_resources_dir = File.expand_path('~/git/run_loop/spec/resources')
FileUtils.cp_r(cal_app, rspec_resources_dir)
FileUtils.cp_r(cal_ipa, rspec_resources_dir)
FileUtils.cp_r(app, rspec_resources_dir)
FileUtils.cp_r(ipa, rspec_resources_dir)

# calabash
rspec_resources_dir = File.expand_path('~/git/calabash/spec/resources/ios')
FileUtils.cp_r(cal_app, rspec_resources_dir)
FileUtils.cp_r(cal_ipa, rspec_resources_dir)
FileUtils.cp_r(app, rspec_resources_dir)
FileUtils.cp_r(ipa, rspec_resources_dir)

