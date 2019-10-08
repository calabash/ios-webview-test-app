#!/usr/bin/env ruby

require "luffa"
require "run_loop"
require "bundler"

cucumber_args = "#{ARGV.join(" ")}"

working_dir = File.expand_path(File.join(File.dirname(__FILE__),
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

    # if none failed then we have success
    exit 0 if failed == 0

    # the ci environment is not stable enough to have all tests passing
    exit failed unless RunLoop::Environment.azurepipelines?

    # we'll take 75% passing as good indicator of health
    expected = 75
    actual = ((passed.to_f/sims.to_f) * 100).to_i

    if actual >= expected
      Luffa.log_pass "We failed '#{failed}' sims, but passed '#{actual}%' so we say good enough"
      exit 0
    else
      Luffa.log_fail "We failed '#{failed}' sims, which is '#{actual}%' and not enough to pass"
      exit 1
    end
  end
end
