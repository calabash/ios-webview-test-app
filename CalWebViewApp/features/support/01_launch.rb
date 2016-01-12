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

  options = {
    # Physical devices: default is :host
    # Xcode < 7.0:      default is :prefences
    # Xcode >= 7.0:     default is :host
    # :uia_strategy => :shared_element,
    # :uia_strategy => :preferences,
    # :uia_strategy => :host
    :relaunch_simulator => false,
    :uia_strategy => :preferences
  }
  unless launcher.active?
    LaunchControl.launcher.relaunch(options)
    LaunchControl.launcher.calabash_notify(self)
  end
end


After('@restart_after') do |_|
  LaunchControl.launcher.run_loop = nil
end

After do |_|
  launcher = LaunchControl.launcher
  unless launcher.calabash_no_stop?
    calabash_exit
  end
end
