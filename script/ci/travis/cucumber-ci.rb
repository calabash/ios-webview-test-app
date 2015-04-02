#!/usr/bin/env ruby

require 'luffa'

cucumber_args = "#{ARGV.join(' ')}"

working_directory = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'CalWebViewApp'))

# on-simulator tests of features in test/cucumber
Dir.chdir(working_directory) do

  Luffa.unix_command('bundle install',
                     {:pass_msg => 'bundled',
                      :fail_msg => 'could not bundle'})

  # remove any stale targets
  Luffa.unix_command('bundle exec calabash-ios sim reset',
                     {:pass_msg => 'reset the simulator',
                      :fail_msg => 'could not reset the simulator'})

  Luffa.log_info "Cucumber args: #{cucumber_args}"
end
