module SaferRailsConsole
  module Patches
    module Sandbox
      module Rails
        module Console
          def start(*args)
            options = args.last

            options[:sandbox] = SaferRailsConsole.sandbox_environment? if options[:sandbox].nil?
            options[:sandbox] = SaferRailsConsole::Console.sandbox_user_prompt if SaferRailsConsole.sandbox_environment? && SaferRailsConsole.config.sandbox_prompt

            super *args
          end
        end
      end
    end
  end
end

if SaferRailsConsole::RailsVersion.supported?
  if SaferRailsConsole::RailsVersion.five_one?
    require 'rails/commands/console/console_command'
  else
    require 'rails/commands/console'
  end

  ::Rails::Console.singleton_class.prepend(SaferRailsConsole::Patches::Sandbox::Rails::Console)
else
  raise "No sandbox patch for rails version '#{::Rails.version}' exists. "\
          'Please disable safer_rails_console, use a supported version of rails, or disable SaferRailsConsole.config.sandbox_environments.'
end
