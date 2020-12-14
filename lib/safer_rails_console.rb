# frozen_string_literal: true

require 'safer_rails_console/version'
require 'safer_rails_console/railtie'
require 'safer_rails_console/colors'
require 'safer_rails_console/rails_version'
require 'safer_rails_console/console'
require 'active_model/type'

module SaferRailsConsole
  class << self
    def environment_name
      if ENV.key?('SAFER_RAILS_CONSOLE_ENVIRONMENT_NAME')
        ENV['SAFER_RAILS_CONSOLE_ENVIRONMENT_NAME']
      else
        config.environment_names.key?(::Rails.env.downcase) ? config.environment_names[::Rails.env.downcase] : 'unknown env'
      end
    end

    def prompt_color
      if ENV.key?('SAFER_RAILS_CONSOLE_PROMPT_COLOR')
        SaferRailsConsole::Colors.const_get(ENV['SAFER_RAILS_CONSOLE_PROMPT_COLOR'].upcase)
      else
        config.environment_prompt_colors.key?(::Rails.env.downcase) ? config.environment_prompt_colors[::Rails.env.downcase] : SaferRailsConsole::Colors::NONE
      end
    end

    def sandbox_environment?
      if ENV.key?('SAFER_RAILS_CONSOLE_SANDBOX_ENVIRONMENT')
        ActiveModel::Type::Boolean.new.cast(ENV['SAFER_RAILS_CONSOLE_SANDBOX_ENVIRONMENT'])
      else
        config.sandbox_environments.include?(::Rails.env.downcase)
      end
    end

    def warn_environment?
      if ENV.key?('SAFER_RAILS_CONSOLE_WARN_ENVIRONMENT')
        ActiveModel::Type::Boolean.new.cast(ENV['SAFER_RAILS_CONSOLE_WARN_ENVIRONMENT'])
      else
        config.warn_environments.include?(::Rails.env.downcase)
      end
    end

    def warn_text
      if ENV.key?('SAFER_RAILS_CONSOLE_WARN_TEXT')
        ENV['SAFER_RAILS_CONSOLE_WARN_TEXT']
      else
        config.warn_text
      end
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
        sandbox_environments: %w{production},
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
