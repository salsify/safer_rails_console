require 'active_support/ordered_options'
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
      monkey_patches
    end

    private

    def monkey_patches
      require 'safer_rails_console/patches/console'
      require 'safer_rails_console/patches/sandbox'
    end
  end
end
