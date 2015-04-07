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

Before('@restart') do |_|
  LaunchControl.launcher.run_loop = nil
end

Before do |_|
  launcher = LaunchControl.launcher
  unless launcher.active?
    LaunchControl.launcher.relaunch
    LaunchControl.launcher.calabash_notify(self)
  end
end

After do |_|
  launcher = LaunchControl.launcher
  unless launcher.calabash_no_stop?
    calabash_exit
  end
end
