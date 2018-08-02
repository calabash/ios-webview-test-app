#!/usr/bin/env ruby

require "luffa"
require "bundler"
require "run_loop"

# Only maintainers can submit AC tests.
if Luffa::Environment.travis_ci? && !ENV["TRAVIS_SECURE_ENV_VARS"]
  Luffa.log_info("Skipping AC submission; non-maintainer activity")
  exit 0
end

device_set = ENV["AC_DEVICE_SET"]

if !device_set || device_set == ""
  device_set = ARGV[0]
end

if !device_set || device_set == ""
  device_set = "App-Center-Test-Cloud/latest-releases-ios" 
end

Dir.chdir("CalWebViewApp") do
  Luffa.unix_command("make ipa-cal")
  Bundler.with_clean_env do
    Luffa.unix_command("bundle update")
    Luffa.unix_command("bin/ac.sh #{device_set}")
  end
end
