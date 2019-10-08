#!/usr/bin/env ruby

require "luffa"
require "bundler"
require "run_loop"

device_set = ENV["AC_DEVICE_SET"]

if !device_set || device_set == ""
  device_set = ARGV[0]
end

if !device_set || device_set == ""
  device_set = "App-Center-Test-Cloud/ios-test-apps" 
end

Dir.chdir("CalWebViewApp") do
  Bundler.with_clean_env do
    Luffa.unix_command("bundle update")
    Luffa.unix_command("bin/ac.sh #{device_set}")
  end
end
