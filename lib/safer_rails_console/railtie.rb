require 'active_support'
require 'rails'
require 'safer_rails_console'

module SaferRailsConsole
  class Railtie < ::Rails::Railtie
    include SaferRailsConsole::Colors

    railtie_name :safer_rails_console

    config.safer_rails_console = ActiveSupport::OrderedOptions.new

    initializer 'safer_rails_console.configure' do |app|
      set_config(app)
    end

    config.after_initialize do
      monkey_patch
    end

    def set_config(app)
      app_config = app.config.safer_rails_console

      SaferRailsConsole.configure do |config|
        config.console = app_config.fetch(:console, 'irb')
        config.env_names = app_config.fetch(:env_names,
                                            {
                                              'development' => 'dev',
                                              'staging' => 'staging',
                                              'production' => 'prod'
                                            }
        )
        config.prompt_colors = app_config.fetch(:prompt_colors,
                                               {
                                                   'development' => GREEN,
                                                   'staging' => YELLOW,
                                                   'production' => RED
                                               }
        )
        config.sandbox = app_config.fetch(:sandbox, ['production', 'development'])
        config.sandbox_disable_keyword = app_config.fetch(:sandbox_disable_keyword, 'production')
        config.warn = app_config.fetch(:warn, ['production', 'development'])
        config.warn_text = app_config.fetch(:warn_text,
                                            "WARNING: YOU ARE USING RAILS CONSOLE IN PRODUCTION!\n" \
                                            'Changing data can cause serious data loss. ' \
                                            'Make sure you know what you\'re doing.'
        )
      end
    end

    def monkey_patch
      config = SaferRailsConsole.configuration

      require 'safer_rails_console/patches/console'
      require 'safer_rails_console/patches/sandbox' if config.sandbox
    end
  end
end
