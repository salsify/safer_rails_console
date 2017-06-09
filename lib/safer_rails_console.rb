require 'safer_rails_console/version'
require 'safer_rails_console/railtie'
require 'safer_rails_console/colors'

module SaferRailsConsole
  class << self
    def environment_name
      config.environment_names.key?(::Rails.env.downcase) ? config.environment_names[::Rails.env.downcase] : 'unknown env'
    end

    def prompt_color
      config.environment_prompt_colors.key?(::Rails.env.downcase) ? config.environment_prompt_colors[::Rails.env.downcase] : SaferRailsConsole::Colors::NONE
    end

    def sandbox_environment?
      config.sandbox_environments.include?(::Rails.env.downcase)
    end

    def warn_environment?
      config.warn_environments.include?(::Rails.env.downcase)
    end

    def config
      @config ||= Configuration.new
    end
  end

  class Configuration
    include ActiveSupport::Configurable

    CONFIG_DEFAULTS = {
        console: 'irb',
        environment_names: {
            'development' => 'dev',
            'staging' => 'staging',
            'production' => 'prod'
        },
        environment_prompt_colors: {
            'development' => SaferRailsConsole::Colors::GREEN,
            'staging' => SaferRailsConsole::Colors::YELLOW,
            'production' => SaferRailsConsole::Colors::RED
        },
        sandbox_environments: %w{production development},
        sandbox_prompt: false,
        warn_environments: %w{production},
        warn_text: "WARNING: YOU ARE USING RAILS CONSOLE IN PRODUCTION!\n" \
                   'Changing data can cause serious data loss. ' \
                   'Make sure you know what you\'re doing.'
    }.freeze

    CONFIG_DEFAULTS.each do |name, value|
      config_accessor(name) { value }
    end

    def set(**new_config)
      config.merge!(new_config.select { |k, _v| CONFIG_DEFAULTS.key?(k) })
    end
  end
end
