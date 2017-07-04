require 'rails'
require 'safer_rails_console'

module SaferRailsConsole
  class Railtie < ::Rails::Railtie
    railtie_name :safer_rails_console

    config.safer_rails_console = ActiveSupport::OrderedOptions.new

    initializer 'safer_rails_console.configure' do |app|
      SaferRailsConsole.config.set(app.config.safer_rails_console)
    end

    config.after_initialize do
      require 'safer_rails_console/patches/railtie'
    end

    console do
      SaferRailsConsole::Console.initialize_sandbox if ::Rails.application.sandbox
      SaferRailsConsole::Console.print_warning if SaferRailsConsole.warn_environment?
      load_console_config
    end

    private

    def load_console_config
      gem = Gem::Specification.find_by_name('safer_rails_console') # rubocop:disable Rails/DynamicFindBy
      gem_root = gem.gem_dir
      ARGV.push '-r', File.join(gem_root, 'lib', 'safer_rails_console', 'consoles', "#{SaferRailsConsole.config.console}.rb")
    end
  end
end
