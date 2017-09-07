require 'safer_rails_console/rails_version'

module SaferRailsConsole
  module Patches
    module Boot
      module SandboxFlag
        def self.console_options(opt)
          opt.banner = 'Usage: rails console [environment] [options]'
          opt.on('-s', '--[no-]sandbox', 'Explicitly enable/disable sandbox mode.') { |v| options[:sandbox] = v }
          opt.on('-w', '--writable', 'Alias for --no-sandbox.') { |v| options[:writable] = v }
          opt.on('-r', '--read-only', 'Alias for --sandbox.') { |v| options[:'read-only'] = v }
          opt.on('-e', '--environment=name', String,
                 'Specifies the environment to run this console under (test/development/production).',
                 'Default: development') { |v| options[:environment] = v.strip }
        end

        module Rails
          module CommandsTasks4
            def console
              require_command!('console')
              ::Rails::Console.singleton_class.prepend(::SaferRailsConsole::Patches::Boot::SandboxFlag::Rails::Console4)
              super
            end
          end

          module Console4
            def parse_arguments(arguments)
              options = {}

              OptionParser.new do |opt|
                ::SaferRailsConsole::Patches::Boot::SandboxFlag.console_options(opt)
                opt.on('--debugger', 'Enable the debugger.') { |v| options[:debugger] = v }
                opt.parse!(arguments)
              end

              if arguments.first && arguments.first[0] != '-'
                env = arguments.first
                options[:environment] = if available_environments.include? env
                                          env
                                        else
                                          %w(production development test).detect { |e| e =~ /^#{env}/ } || env
                                        end
              end

              options
            end
          end

          module CommandsTasks50
            def console
              require_command!('console')
              ::Rails::Console.singleton_class.prepend(::SaferRailsConsole::Patches::Boot::SandboxFlag::Rails::Console50)
              super
            end
          end

          module Console50
            def parse_arguments(arguments)
              options = {}

              OptionParser.new do |opt|
                ::SaferRailsConsole::Patches::Boot::SandboxFlag.console_options(opt)
                opt.parse!(arguments)
              end

              set_options_env(arguments, options)
            end
          end
        end
      end
    end
  end
end

if SaferRailsConsole::RailsVersion.four_one? || SaferRailsConsole::RailsVersion.four_two?
  require 'rails/commands/commands_tasks'
  ::Rails::CommandsTasks.prepend(SaferRailsConsole::Patches::Boot::SandboxFlag::Rails::CommandsTasks4)
elsif SaferRailsConsole::RailsVersion.five_zero?
  require 'rails/commands/commands_tasks'
  ::Rails::CommandsTasks.prepend(SaferRailsConsole::Patches::Boot::SandboxFlag::Rails::CommandsTasks50)
elsif SaferRailsConsole::RailsVersion.five_one?
  require 'rails/command'
  require 'rails/commands/console/console_command'
  # Rails 5.1 defaults `sandbox` to `false`, but we need it to NOT have a default value and be `nil` when it is not user-specified
  ::Rails::Command::ConsoleCommand.class_eval do
    remove_class_option :sandbox
    class_option :sandbox, aliases: '-s', type: :boolean, desc: 'Explicitly enable/disable sandbox mode.'
    class_option :writable, aliases: '-w', type: :boolean, desc: 'Alias for --no-sandbox.'
    class_option :'read-only', aliases: '-r', type: :boolean, desc: 'Alias for --sandbox.'
  end
else
  unless SaferRailsConsole::RailsVersion.supported?
    raise "No boot/sandbox_flag patch for rails version '#{::Rails.version}' exists. "\
          'Please disable safer_rails_console, use a supported version of rails, '\
          "or remove \"require 'safer_rails_console/patches/boot'\" from your application's 'config/boot.rb'."
  end
end
