module SaferRailsConsole
  module Patches
    module Console

      module Rails
        module Application
          console do
            gem = Gem::Specification.find_by(name: 'safer_rails_console')
            gem_root = gem.gem_dir
            ARGV.push '-r', File.join(gem_root, 'lib', 'safer_rails_console', 'consoles', "#{SaferRailsConsole.configuration.console}.rb")
          end
        end
      end

      ::Rails::Application.prepend(SaferRailsConsole::Patches::Console::Rails::Application)
    end
  end
end
