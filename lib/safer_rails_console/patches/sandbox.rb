module SaferRailsConsole
  module Patches
    module Sandbox
      ::Rails::Application.class_eval do
        def require_environment_with_console!
          if defined?(Rails::Console) && SaferRailsConsole.configuration.sandbox.include?(Rails.env.downcase)
            Rails::Console.class_eval do
              class << self
                include SaferRailsConsole::Console

                def start(*args)
                  options = args.last
                  options[:sandbox] = user_input if options[:sandbox].blank?

                  initialize_sandbox if options[:sandbox]

                  new(*args).start
                end
              end
            end
          end
          require_environment_without_console!
        end
        alias_method_chain :require_environment!, :console
      end
    end
  end
end
