# frozen_string_literal: true

require 'rails'

module SaferRailsConsole
  module RailsVersion
    RAILS_VERSION = Gem::Version.new(::Rails.version)

    class << self
      def supported?
        six_or_above?
      end

      def six_or_above?
        if @is_six_or_above.nil?
          @is_six_or_above = SaferRailsConsole::RailsVersion::RAILS_VERSION >= ::Gem::Version.new('6.0.0')
        end
        @is_six_or_above
      end
    end
  end
end
