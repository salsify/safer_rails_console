# frozen_string_literal: true

require 'safer_rails_console/rails_version'

if SaferRailsConsole::RailsVersion.supported?
  require 'rails/command'
  require 'rails/commands/console/console_command'
  # Rails defaults `sandbox` to `false`, but we need it to NOT have a default value and
  # be `nil` when it is not user-specified
  ::Rails::Command::ConsoleCommand.class_eval do
    remove_class_option :sandbox
    class_option :sandbox, aliases: '-s', type: :boolean, desc: 'Explicitly enable/disable sandbox mode.'
    class_option :writable, aliases: '-w', type: :boolean, desc: 'Alias for --no-sandbox.'
    class_option :'read-only', aliases: '-r', type: :boolean, desc: 'Alias for --sandbox.'
  end
else
  raise "No boot/sandbox_flag patch for rails version '#{::Rails.version}' exists. "\
        'Please disable safer_rails_console, use a supported version of rails, '\
        "or remove \"require 'safer_rails_console/patches/boot'\" from your application's 'config/boot.rb'."
end
