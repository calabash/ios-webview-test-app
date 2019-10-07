#!/usr/bin/env ruby

require "luffa"
require "run_loop"
require "bundler"

cucumber_args = "#{ARGV.join(" ")}"

working_dir = File.expand_path(File.join(File.dirname(__FILE__),
                                         "..",
                                         "..",
                                         "..",
                                         "CalWebViewApp"))
app = File.join(working_dir, "Products", "app-cal", "CalWebView-cal.app")

def select_sim_by_name(simctl, regex)
  simctl.simulators.select do |sim|
    sim.to_s[/#{regex} \(/]
  end.sort_by do |sim|
    sim.version
  end.last
end

Dir.chdir working_dir do

  Bundler.with_clean_env do
    Luffa.unix_command("bundle install")

    Luffa.unix_command("make app-cal")
    FileUtils.mkdir_p("reports")

    xcode = RunLoop::Xcode.new
    simctl = RunLoop::Simctl.new

    if xcode.version.major < 11
      devices = {
        :iphoneXs => select_sim_by_name(simctl, "iPhone Xs"),
        :iphoneXr => select_sim_by_name(simctl, "iPhone Xʀ")
      }
    else
      devices = {
        :iphone11Pro => select_sim_by_name(simctl, "iPhone 11 Pro"),
        :iphone11 => select_sim_by_name(simctl, "iPhone 11")
      }
    end

    devices.delete_if { |k, v| v.nil? }

    FileUtils.rm_rf("reports")
    FileUtils.mkdir("reports")

    RunLoop::CoreSimulator.terminate_core_simulator_processes

    passed_sims = []
    failed_sims = []
    devices.each do |key, simulator|
      cucumber_cmd = "bundle exec cucumber -p default -f json -o reports/#{key}.json -f junit -o reports/junit/#{key} #{cucumber_args}"

      env_vars = {
        "DEVICE_TARGET" => simulator.udid.chomp,
        "APP" => app
      }

      RunLoop::CoreSimulator.terminate_core_simulator_processes

      exit_code = Luffa.unix_command(cucumber_cmd,
                                     {:exit_on_nonzero_status => false,
                                      :env_vars => env_vars})
      if exit_code == 0
        passed_sims << simulator.to_s
      else
        failed_sims << simulator.to_s
      end
    end

    Luffa.log_info '=== SUMMARY ==='
    Luffa.log_info ''
    Luffa.log_info 'PASSING SIMULATORS'
    passed_sims.each { |sim| Luffa.log_info(sim) }
    Luffa.log_info ''
    Luffa.log_info 'FAILING SIMULATORS'
    failed_sims.each { |sim| Luffa.log_info(sim) }

    sims = devices.count
    passed = passed_sims.count
    failed = failed_sims.count

    puts ''
    Luffa.log_info "passed on '#{passed}' out of '#{sims}'"

    exit failed
  end
end
