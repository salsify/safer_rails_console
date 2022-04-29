# frozen_string_literal: true

module SaferRailsConsole
  module Patches
    module Sandbox
      module Rails
        module Console
          def start(*args)
            options = args.last

            if options[:sandbox].nil?
              options[:sandbox] = if options[:'read-only']
                                    true
                                  elsif options[:writable]
                                    false
                                  else
                                    SaferRailsConsole.sandbox_environment? && SaferRailsConsole.config.sandbox_prompt ? SaferRailsConsole::Console.sandbox_user_prompt : SaferRailsConsole.sandbox_environment?
                                  end
            end

            super *args
          end
        end
      end
    end
  end
end

if SaferRailsConsole::RailsVersion.supported?
  require 'rails/commands/console/console_command'

  ::Rails::Console.singleton_class.prepend(SaferRailsConsole::Patches::Sandbox::Rails::Console)
else
  raise "No sandbox patch for rails version '#{::Rails.version}' exists. "\
          'Please disable safer_rails_console, use a supported version of rails, or disable SaferRailsConsole.config.sandbox_environments.'
end
