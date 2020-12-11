require 'bundler/setup'
require 'climate_control'
require 'mixlib/shellout'
require 'safer_rails_console'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    system!("export RAILS_ENV=development && cd #{rails_root} && rake db:drop && rake db:setup && rake db:test:prepare")
    system!("export RAILS_ENV=production && cd #{rails_root} && rake db:drop && rake db:setup && rake db:test:prepare")
  end

  config.before :each do
    allow(::Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
  end

  def run_console(*args, rails_env: :development, input: nil)
    rails_cmd = File.join(rails_root, 'bin', 'rails')
    shell_out = Mixlib::ShellOut.new(
      "#{rails_cmd} console #{args.join(' ')}",
      env: { RAILS_ENV: rails_env.to_s },
      input: input
    )
    shell_out.run_command
  end

  def rails_root
    File.join(__dir__, 'internal', "rails_#{::Rails.version[0..2].tr('.', '_')}")
  end

  def with_modified_env(options, &block)
    ClimateControl.modify(options, &block)
  end

  def system!(command)
    unless system(command)
      raise "Command failed with exit code #{$CHILD_STATUS}: #{command}"
    end
  end
end
