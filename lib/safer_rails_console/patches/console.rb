module SaferRailsConsole
  module Patches
    module Console
      ::Rails::Application.class_eval do
        console do
          gem = Gem::Specification.find_by_name("safer_rails_console")
          gem_root = gem.gem_dir
          ARGV.push '-r', File.join(gem_root, 'lib', 'safer_rails_console', 'consoles', "#{SaferRailsConsole.configuration.console}.rb")
        end
      end
    end
  end
end