module SaferRailsConsole
  module Console
    class << self
      def initialize_sandbox
        require 'safer_rails_console/patches/sandbox'
      end

      def print_warning
        puts SaferRailsConsole::Colors.color_text(SaferRailsConsole.config.warn_text, SaferRailsConsole.prompt_color) # rubocop:disable Rails/Output
      end

      def load_config
        gem = Gem::Specification.find_by_name('safer_rails_console') # rubocop:disable Rails/DynamicFindBy
        gem_root = gem.gem_dir
        ARGV.push '-r', File.join(gem_root, 'lib', 'safer_rails_console', 'consoles', "#{SaferRailsConsole.config.console}.rb")
      end
    end
  end
end
