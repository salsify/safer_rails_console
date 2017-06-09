require 'safer_rails_console/console'

module SaferRailsConsole
  module Patches
    module Sandbox
      module Rails
        module Console
          def start(*args)
            options = args.last

            if options[:sandbox].nil?
              options[:sandbox] = SaferRailsConsole.sandbox_environment?
              options[:sandbox] = SaferRailsConsole::Console.sandbox_prompt_user_input if SaferRailsConsole.sandbox_environment? && SaferRailsConsole.config.sandbox_prompt
            end

            SaferRailsConsole::Console.initialize_sandbox if options[:sandbox]
            SaferRailsConsole::Console.print_warning if SaferRailsConsole.warn_environment?

            super *args
          end
        end
      end
    end
  end
end

if SaferRailsConsole.config.sandbox_environments
  if SaferRailsConsole::RailsVersion.four_one? || SaferRailsConsole::RailsVersion.four_two?
    ::Rails::Console.singleton_class.prepend(SaferRailsConsole::Patches::Sandbox::Rails::Console)
  elsif SaferRailsConsole::RailsVersion.five_zero?
    ::Rails::ConsoleHelper.ClassMethods.prepend(SaferRailsConsole::Patches::Sandbox::Rails::Console)
  else
    raise "No sandbox patch for rails version '#{::Rails::VERSION}' exists. "\
          "Please disable safer_rails_console, use a supported version of rails, or disable SaferRailsConsole.config,sandbox_environments."
  end
end
