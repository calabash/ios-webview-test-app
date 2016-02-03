#!/usr/bin/env ruby

require "bundler"
require "luffa"

working_dir = File.expand_path(File.join(".", "CalWebViewApp"))

Dir.chdir(working_dir) do
  Bundler.with_clean_env do

    Luffa.unix_command("bundle install")
    Luffa.unix_command("make app-cal")
    Luffa.unix_command("bundle exec cucumber --tags ~@pending")
  end
end

