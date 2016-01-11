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

Dir.chdir working_dir do

  Bundler.with_clean_env do
    Luffa.unix_command("bundle install")

    Luffa.unix_command("make app-cal")
    FileUtils.mkdir_p("reports")

    xcode = RunLoop::Xcode.new
    xcode_version = xcode.version
    sim_major = xcode_version.major + 2
    sim_minor = xcode_version.minor

    sim_version = RunLoop::Version.new("#{sim_major}.#{sim_minor}")

    if ENV["JENKINS_HOME"]
      devices = {
        :iphone6sPlus => 'iPhone 6s Plus',
      }
    else
      devices = {
        :air => 'iPad Air',
        :iphone4s => 'iPhone 4s',
        :iphone5s => 'iPhone 5s',
        :iphone6 => 'iPhone 6',
        :iphone6plus => 'iPhone 6 Plus'
      }
    end

    RunLoop::CoreSimulator.terminate_core_simulator_processes

    simulators = RunLoop::SimControl.new.simulators

    passed_sims = []
    failed_sims = []
    devices.each do |key, name|
      cucumber_cmd = "bundle exec cucumber -p default --format json -o reports/#{key}.json #{cucumber_args}"

      match = simulators.find do |sim|
        sim.name == name && sim.version == sim_version
      end

      env_vars = {
        "DEVICE_TARGET" => match.udid,
        "APP" => app,
        "DEBUG" => "1"
      }

      RunLoop::CoreSimulator.terminate_core_simulator_processes

      exit_code = Luffa.unix_command(cucumber_cmd, {:exit_on_nonzero_status => false,
                                                    :env_vars => env_vars})
      if exit_code == 0
        passed_sims << name
      else
        failed_sims << name
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

    # the travis ci environment is not stable enough to have all tests passing
    exit failed unless Luffa::Environment.travis_ci?

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

