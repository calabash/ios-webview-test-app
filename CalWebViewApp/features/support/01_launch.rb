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
  #RunLoop::SimControl.new.reset_sim_content_and_settings
  launcher = LaunchControl.launcher
  #launcher.run_loop = nil
  unless launcher.active?
    LaunchControl.launcher.relaunch({:relaunch_simulator => false})
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
