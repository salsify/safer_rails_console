module SaferRailsConsole
  class RailsVersion
    class << self
      VERSION = Gem::Version.new(::Rails::VERSION)

      def four_one?
        Gem::Requirement.new('~> 4.1.0').satisfied_by?(VERSION)
      end

      def four_two?
        Gem::Requirement.new('~> 4.2.0').satisfied_by?(VERSION)
      end

      def five_zero?
        Gem::Requirement.new('~> 5.0.0').satisfied_by?(VERSION)
      end

      def five_one?
        Gem::Requirement.new('~> 5.1.0').satisfied_by?(VERSION)
      end
    end
  end
end
