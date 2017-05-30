require 'active_support'
require 'safer_rails_console/version'

module SaferRailsConsole
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  require 'safer_rails_console/railtie' if defined?(::Rails)

  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:console)
    config_accessor(:env_names)
    config_accessor(:prompt_colors)
    config_accessor(:sandbox)
    config_accessor(:sandbox_disable_keyword)
    config_accessor(:warn)
    config_accessor(:warn_text)
  end
end
