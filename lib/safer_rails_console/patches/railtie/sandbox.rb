module SaferRailsConsole
  module Patches
    module Sandbox
      module Rails
        module Console
          def start(*args)
            if SaferRailsConsole::RailsVersion.five_one? && SaferRailsConsole.sandbox_environment?
              puts "Rails 5.1 does not support explicitly enabling/disabling via flags.  The sandbox prompt will be used.\n\n"
              # TODO: Fix Rails 5.1 support
              # SaferRailsConsole.config.set(sandbox_prompt: true)
            end

            options = args.last

            # TODO: Fix Rails 5.1 support
            options[:sandbox] = SaferRailsConsole.sandbox_environment? if options[:sandbox].nil?
            options[:sandbox] = SaferRailsConsole::Console.sandbox_prompt_user_input if SaferRailsConsole.sandbox_environment? && SaferRailsConsole.config.sandbox_prompt

            SaferRailsConsole::Console.initialize_sandbox if options[:sandbox]
            SaferRailsConsole::Console.print_warning if SaferRailsConsole.warn_environment?

            super *args
          end
        end
      end
    end
  end
end

if SaferRailsConsole::RailsVersion.four_one? || SaferRailsConsole::RailsVersion.four_two? || SaferRailsConsole::RailsVersion.five_one?
  ::Rails::Console.singleton_class.prepend(SaferRailsConsole::Patches::Sandbox::Rails::Console)
elsif SaferRailsConsole::RailsVersion.five_zero?
  ::Rails::ConsoleHelper::ClassMethods.prepend(SaferRailsConsole::Patches::Sandbox::Rails::Console)
else
  raise "No sandbox patch for rails version '#{::Rails.version}' exists. "\
          'Please disable safer_rails_console, use a supported version of rails, or disable SaferRailsConsole.config.sandbox_environments.'
end
