require 'active_support/configurable'
require 'safer_rails_console/colors'
require 'safer_rails_console/railtie'
require 'safer_rails_console/version'
require 'safer_rails_console/patches/disable_sandbox_flag'

module SaferRailsConsole
  class << self
    def sandbox_environment?
      config.sandbox_environments.include?(::Rails.env.downcase)
    end

    def sandbox_prompt?
      config.sandbox_disable_methods.include?('prompt')
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
    include SaferRailsConsole::Colors

    CONFIG_DEFAULTS = {
        console: 'irb', # irb, pry
        environment_names: {
            'development' => 'dev',
            'staging' => 'staging',
            'production' => 'prod'
        },
        environment_prompt_colors: {
            'development' => GREEN,
            'staging' => YELLOW,
            'production' => RED
        },
        sandbox_environments: %w{production development},
        prompt_to_disable_sandbox: false,
        warn_environments: %w{production development},
        warn_text: "WARNING: YOU ARE USING RAILS CONSOLE UNSANDBOXED!\n" \
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
