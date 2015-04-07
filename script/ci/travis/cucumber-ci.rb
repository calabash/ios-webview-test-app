#!/usr/bin/env ruby

require 'luffa'

cucumber_args = "#{ARGV.join(' ')}"

working_directory = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'CalWebViewApp'))

# on-simulator tests of features in test/cucumber
Dir.chdir(working_directory) do
  Luffa.log_info "Cucumber args: #{cucumber_args}"

  Luffa.unix_command("bundle exec cucumber #{cucumber_args}",
                     {:pass_msg => 'Cucumbers passed',
                      :fail_msg => 'Cucumbers failed'})
end
