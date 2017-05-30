module SaferRailsConsole
  module Patches
    module Sandbox
      ::Rails::Application.class_eval do
        def require_environment_with_console!
          if defined?(Rails::Console)
            Rails::Console.class_eval do
              class << self
                include SaferRailsConsole::Console

                def start(*args)
                  options = args.last

                  if sandbox?
                    options[:sandbox] = user_input if options[:sandbox].blank?
                    options[:sandbox] ? initialize_sandbox : print_warning
                  end

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
