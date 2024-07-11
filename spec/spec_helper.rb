# frozen_string_literal: true

require 'bundler/setup'
require 'climate_control'
require 'mixlib/shellout'
require 'safer_rails_console'

DB_ADAPTERS = [:postgresql, :mysql2].freeze

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    migrate_all_dbs
    system!("cd #{rails_root} && rake db:test:prepare")
    system!('export SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production && ' \
              "cd #{rails_root} && rake db:drop && rake db:setup && rake db:test:prepare")
  end

  config.before do
    allow(::Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
  end

  def run_console(*args, rails_env: :development, input: nil)
    rails_cmd = File.join(rails_root, 'bin', 'rails')
    shell_out = Mixlib::ShellOut.new(
      "#{rails_cmd} console #{args.join(' ')}",
      env: {
        SECRET_KEY_BASE_DUMMY: '1',
        RAILS_ENV: rails_env.to_s
      },
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
    raise "Command failed with exit code #{$CHILD_STATUS}: #{command}" unless system(command)
  end

  def migrate_all_dbs
    DB_ADAPTERS.each { |adapter| migrate(adapter: adapter) }
  end

  def migrate(adapter:)
    env = 'development'
    env += "-#{adapter}" if adapter && adapter != :postgresql
    system!("export SECRET_KEY_BASE_DUMMY=1 && export RAILS_ENV=#{env} && " \
              "cd #{rails_root} && rake db:drop && rake db:setup")
  end
end
