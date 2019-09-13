require 'rails'

module SaferRailsConsole
  module RailsVersion
    RAILS_VERSION = Gem::Version.new(::Rails.version)

    class << self
      def supported?
        five_zero? || five_one? || five_two? || six_zero?
      end

      def five_zero?
        @is_five_zero = Gem::Requirement.new('~> 5.0.0').satisfied_by?(SaferRailsConsole::RailsVersion::RAILS_VERSION) if @is_five_zero.nil?
        @is_five_zero
      end

      def five_one?
        @is_five_one = Gem::Requirement.new('~> 5.1.0').satisfied_by?(SaferRailsConsole::RailsVersion::RAILS_VERSION) if @is_five_one.nil?
        @is_five_one
      end

      def five_one_or_above?
        @is_five_one_or_above = SaferRailsConsole::RailsVersion::RAILS_VERSION >= ::Gem::Version.new('5.1.0') if @is_five_one_or_above.nil?
        @is_five_one_or_above
      end

      def five_two?
        @is_five_two = Gem::Requirement.new('~> 5.2.0').satisfied_by?(SaferRailsConsole::RailsVersion::RAILS_VERSION) if @is_five_two.nil?
        @is_five_two
      end

      def six_zero?
        @is_six_zero = Gem::Requirement.new('~> 6.0.0').satisfied_by?(SaferRailsConsole::RailsVersion::RAILS_VERSION) if @is_six_zero.nil?
        @is_six_zero
      end

      def six_or_above?
        @is_six_or_above = SaferRailsConsole::RailsVersion::RAILS_VERSION >= ::Gem::Version.new('6.0.0') if @is_six_or_above.nil?
        @is_six_or_above
      end
    end
  end
end
