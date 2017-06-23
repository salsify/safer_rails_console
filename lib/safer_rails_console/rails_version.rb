require 'rails'

module SaferRailsConsole
  module RailsVersion
    RAILS_VERSION = Gem::Version.new(::Rails.version)

    class << self
      def supported?
        four_one? || four_two? || five_zero? || five_one?
      end

      def four_one?
        @is_four_one = Gem::Requirement.new('~> 4.1.0').satisfied_by?(SaferRailsConsole::RailsVersion::RAILS_VERSION) if @is_four_one.nil?
        @is_four_one
      end

      def four_two?
        @is_four_two = Gem::Requirement.new('~> 4.2.0').satisfied_by?(SaferRailsConsole::RailsVersion::RAILS_VERSION) if @is_four_two.nil?
        @is_four_two
      end

      def five_zero?
        @is_five_zero = Gem::Requirement.new('~> 5.0.0').satisfied_by?(SaferRailsConsole::RailsVersion::RAILS_VERSION) if @is_five_zero.nil?
        @is_five_zero
      end

      def five_one?
        @is_five_one = Gem::Requirement.new('~> 5.1.0').satisfied_by?(SaferRailsConsole::RailsVersion::RAILS_VERSION) if @is_five_one.nil?
        @is_five_one
      end
    end
  end
end
