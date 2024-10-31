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
        return @six_or_above if defined?(@six_or_above)

        @six_or_above = SaferRailsConsole::RailsVersion::RAILS_VERSION >= ::Gem::Version.new('6.0.0')
      end

      def eight_or_above?
        return @eight_or_above if defined?(@eight_or_above)

        @eight_or_above = SaferRailsConsole::RailsVersion::RAILS_VERSION >= ::Gem::Version.new('8.0.0')
      end
    end
  end
end
