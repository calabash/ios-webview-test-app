require 'calabash-cucumber/launcher'

# noinspection ALL
module LaunchControl
  @@launcher = nil

  def self.launcher
    @@launcher ||= Calabash::Cucumber::Launcher.new
  end

  def self.launcher=(launcher)
    @@launcher = launcher
  end
end

Before do |_|
  LaunchControl.launcher.relaunch
  LaunchControl.launcher.calabash_notify(self)
end

After do |_|
  launcher = LaunchControl.launcher
  unless launcher.calabash_no_stop?
    calabash_exit
  end
end
