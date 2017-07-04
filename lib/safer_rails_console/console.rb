module SaferRailsConsole
  module Console
    class << self
      def initialize_sandbox
        require 'safer_rails_console/patches/sandbox'
      end

      def print_warning
        puts SaferRailsConsole::Colors.color_text(SaferRailsConsole.config.warn_text, SaferRailsConsole.prompt_color) # rubocop:disable Rails/Output
      end
    end
  end
end
