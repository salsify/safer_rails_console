require 'safer_rails_console/rails_version'

module SaferRailsConsole
  module Patches
    module Boot
      module SandboxFlag
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
                opt.banner = 'Usage: rails console [environment] [options]'
                opt.on('-s', '--[no-]sandbox', 'Explicitly enable/disable sandbox mode.') { |v| options[:sandbox] = v }
                opt.on('-e', '--environment=name', String,
                       'Specifies the environment to run this console under (test/development/production).',
                       'Default: development') { |v| options[:environment] = v.strip }
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
                opt.banner = 'Usage: rails console [environment] [options]'
                opt.on('-s', '--[no-]sandbox', 'Explicitly enable/disable sandbox mode.') { |v| options[:sandbox] = v }
                opt.on('-e', '--environment=name', String,
                       'Specifies the environment to run this console under (test/development/production).',
                       'Default: development') { |v| options[:environment] = v.strip }
                opt.parse!(arguments)
              end

              set_options_env(arguments, options)
            end
          end

          module Command
            class << self
              def find_by_namespace(namespace, command_name = nil)
                if command_name && command_name.try(:eql?, 'console')
                  require 'rails/commands/console/console_command'
                  Rails::Command::ConsoleCommand.class_eval do
                    class_option :'disable-sandbox', aliases: '-ds', type: :boolean,
                                 desc: 'Explicitly disable sandbox mode.'
                  end
                end

                super(namespace, command_name)
              end

              def sorted_groups
                require 'rails/commands/console/console_command'
                Rails::Command::ConsoleCommand.class_eval do
                  class_option :'disable-sandbox', aliases: '-ds', type: :boolean,
                               desc: 'Explicitly disable sandbox mode.'
                end

                super
              end
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
elsif SaferRailsConsole::RailsVersion.five_one? || SaferRailsConsole::RailsVersion.five_two?
  require 'rails/command'
  ::Rails::Command.prepend(SaferRailsConsole::Patches::Boot::SandboxFlag::Rails::Command)
else
  raise "No boot/sandbox_flag patch for rails version '#{::Rails::VERSION}' exists. "\
        "Please disable safer_rails_console, use a supported version of rails, or remove \"require 'safer_rails_console/patches/boot'\" from your application's 'config/boot.rb'."
end
