module SaferRailsConsole
  module Console
    class << self
      include SaferRailsConsole::Colors

      def initialize_sandbox
        enable_auto_rollback
      end

      def print_warning
        puts color_text(SaferRailsConsole.config.warn_text, SaferRailsConsole.prompt_color) # rubocop:disable Rails/Output
      end

      def sandbox_prompt_user_input
        puts "Defaulting the console into sandbox mode.\nType 'disable' to disable. Anything else will begin a sandboxed session:" # rubocop:disable Rails/Output
        gets.strip != 'disable'
      end

      private

      def enable_auto_rollback
        require 'safer_rails_console/patches/auto_rollback'
      end
    end
  end
end
