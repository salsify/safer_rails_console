module SaferRailsConsole
  module Patches
    module DisableSandboxFlag

      module Rails
        module CommandsTasks4
          def console
            require_command!('console')

            Rails::Console.prepend(SaferRailsConsole::Patches::DisableSandboxFlag::Rails::Console4)
            Rails::Console.class_eval do
              class << self
                def parse_arguments(arguments)
                  options = {}

                  OptionParser.new do |opt|
                    opt.banner = 'Usage: rails console [environment] [options]'
                    opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
                    opt.on('-ds', '--disable-sandbox', 'Explicitly disable sandbox mode.') { |v| options[:'disable-sandbox'] = v }
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
            end

            super
          end
        end

        module CommandsTasks50
          def console
            require_command!('console')

            Rails::ConsoleHelper.prepend(SaferRailsConsole::Patches::DisableSandboxFlag::Rails::ConsoleHelper50)
            Rails::Console.class_eval do
              class << self
                def parse_arguments(arguments)
                  options = {}

                  OptionParser.new do |opt|
                    opt.banner = 'Usage: rails console [environment] [options]'
                    opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
                    opt.on('-ds', '--disable-sandbox', 'Explicitly disable sandbox mode.') { |v| options[:'disable-sandbox'] = v }
                    opt.on('-e', '--environment=name', String,
                           'Specifies the environment to run this console under (test/development/production).',
                           'Default: development') { |v| options[:environment] = v.strip }
                    opt.parse!(arguments)
                  end

                  set_options_env(arguments, options)
                end
              end
            end

            super
          end
        end

        module Console4
          class << self
            include SaferRailsConsole::Console

            def start(*args)
              options = args.last

              if options[:'disable-sandbox']
                options[:sandbox] = false
              elsif !options[:sandbox]
                options[:sandbox] = SaferRailsConsole.sandbox_environment?
                options[:sandbox] = sandbox_prompt if SaferRailsConsole.sandbox_environment? && SaferRailsConsole.sandbox_prompt?
              end

              initialize_sandbox if sandbox? && SaferRailsConsole.sandbox_environment?
              print_warning if !sandbox? && SaferRailsConsole.warn_environment?

              super args
            end
          end
        end

        module ConsoleHelper50
          module ClassMethods
            include SaferRailsConsole::Console

            def start(*args)
              options = args.last

              if options[:'disable-sandbox']
                options[:sandbox] = false
              elsif !options[:sandbox]
                options[:sandbox] = SaferRailsConsole.sandbox_environment?
                options[:sandbox] = sandbox_prompt if SaferRailsConsole.sandbox_environment? && SaferRailsConsole.sandbox_prompt?
              end

              initialize_sandbox if sandbox? && SaferRailsConsole.sandbox_environment?
              print_warning if !sandbox? && SaferRailsConsole.warn_environment?

              super args
            end
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

      if SaferRailsConsole::RailsVersion.four_one? || SaferRailsConsole::RailsVersion.four_two?
        ::Rails::CommandsTasks.prepend(SaferRailsConsole::Patches::DisableSandboxFlag::Rails::CommandsTasks4)
      elsif SaferRailsConsole::RailsVersion.five_zero?
        ::Rails::CommandsTasks.prepend(SaferRailsConsole::Patches::DisableSandboxFlag::Rails::CommandsTasks50)
      elsif SaferRailsConsole::RailsVersion.five_one?
        ::Rails::Command.prepend(SaferRailsConsole::Patches::DisableSandboxFlag::Rails::Command)
      else
        raise "No disable_sandbox_flag patch for rails version #{::Rails::VERSION} exists"
      end
    end
  end
end
