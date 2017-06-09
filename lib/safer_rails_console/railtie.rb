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
  end
end
